package PMC::RDF::UriResolver;
# This is the main module for the RDF URIResolver script, as specified here:
# https://confluence.ncbi.nlm.nih.gov/x/Ew9iAQ.

use Moose;
use MooseX::StrictConstructor;

my $READ_CONFIG_INTERVAL = 10;

with qw(
    PMC::MooseX::FastCGI
);

use Config::Any;
use Data::Dumper;

# The last time the config file was read
has config_read_at => (
    is => 'rw',
    isa => 'Int'
);

# The name of the config file
has config_file => (
    is => 'rw',
    isa => 'Str',
    default => 'config.xml',
    # Here's how to get it to default to the name of the script but with
    # the '.conf' extension.
    # sub {
    #     (my $name = $0) =~ s/\.[^\.]*$//;
    #     $name . ".conf";
    # },
);

# The configuration data, as read in from the config file
has config => (
    is => 'rw',
    isa => 'HashRef'
);

# Set to 1 to enable debugging (turns off redirects, produces text/plain, and
# prints out a debug message).
my $debug = 1;



# This reads the config file if it's never been read before, or if
# $READ_CONFIG_INTERVAL seconds have elapsed.
sub read_config_if_necessary {
    my ($self) = @_;

    return if $self->config_read_at &&
              ($self->config_read_at + $READ_CONFIG_INTERVAL > time());

    my $config_file = $self->config_file;
    die "$config_file not found\n" if !-r $config_file;

    my $config = Config::Any->load_files({
        files => [ $config_file ],
        use_ext => 1,  # use the config file extension to determine its format
        flatten_to_hash => 1,
    }) or die "Config::Any->load_files failed\n";
    $self->config_read_at(time());
    $self->config($config->{$config_file});
}

# Initialize the FCGI
sub fastcgi_init {
    my ($self) = shift;
    $self->read_config_if_necessary;
}

sub process_request {
    my ($self, $q) = @_;
    my $d = '';  # debug string.
    if ($debug) {
        print $q->header("text/plain");
    }

    $self->read_config_if_necessary;

    # Parse the request URL.  This script should work identically in any of
    # several different environments (for debugging purposes).  E.g.
    #     http://ipmc-dev1/cfm/web/rdf/index.cgi/project/resource
    #     http://mwebdev2/rdf/project/resource
    #     http://mwebdev2/rdf/index.fcgi/project/resource
    #     http://mwebdev2/rdf/index.cgi/project/resource
    #     http://rdf.ncbi.nlm.nih.gov/project/resource
    #     http://rdf.ncbi.nlm.nih.gov/index.fcgi/project/resource
    # Depending on the Apache rules that get us here, the environment variables
    # might vary widely.  So just use REQUEST_URI, which is always everything
    # after the authority.
    # The following regex puts the "preamble" into $scriptUrl, and then parses out
    # the $project and the $resource.

    my $requestUri = $ENV{REQUEST_URI};
    # Pull out the scriptUrl
    if ($requestUri !~ s/
            (                      # start of the script url (which might be just a slash)
              \/                   # always has a leading slash
              (rdf\/)?             # optional 'rdf' path prefix
              (.*index\.f?cgi\/)?  # optional path-to-script
            )
        //x)
    {
        $self->badUrl($q, "Empty URL path");
        return;
    }
    my $scriptUrl = $1;

    # Get the project and the resource
    if ($requestUri !~ m/
            ([A-Za-z0-9_\-.]+)     # project
            (\/.*)                 # resource
        /x)
    {
        $self->badUrl($q, "Missing project or resource");
        return;
    }
    my $project   = $1;
    my $resource  = $2;

    # Validate
    if ( $resource =~ /\?/ )         # query strings are not allowed
    {
        $self->badUrl($q, "Query strings are not allowed");
        return;
    }

    # Get the list of mime types this client accepts
    my @clientAccepts = $q->Accept();

    # Find this project in the config file
    my $config = $self->config;
    my $projConfig = $config->{project}{$project};
    if (!$projConfig) {
        $self->badUrl($q, "Can't find project $project.");
        return;
    }

    # Look for redirects
    foreach my $redirect (@{$projConfig->{redirect}}) {
        # Check if the URL matches the pattern
        my $pattern = $redirect->{pattern};
        if ($resource =~ m/$pattern/) {
            my $one = $1;
            my $two = $2;
            my $three = $3;

            # Default target is the one on the main <redirect> element
            my $target = $redirect->{target};

            # If there are <accept> children, then we'll try to do a match on
            # HTTP accept header
            my $matchAccepts = $redirect->{accept};
            if ($matchAccepts) {
                $d .= "\$matchAccepts is true.\n" if $debug;
                # First construct a hash cross-referencing accept header values to
                # accept hashes.
                my %acceptVals;
                foreach my $matchAccept (@$matchAccepts) {
                    # Get the @values attribute as an array of mime types
                    my $mavals = $matchAccept->{values};
                    map { $acceptVals{$_} = $matchAccept } (split /,/, $mavals);
                }

                # Now find the first client-provided accept type that work
                my ($ca) = grep {exists $acceptVals{$_}} @clientAccepts;
                if ($ca) {
                    $target = $acceptVals{$ca}{target};
                    $d .= "target from accept value is '$target'\n" if $debug;
                }
            }

            $target =~ s/\$1/$one/;
            $target =~ s/\$2/$two/;
            $target =~ s/\$3/$three/;
            #print "  target = $target\n";
            print $q->redirect(
                -uri => $target,
                -status => '303 See Other');
            return;
        }
    }

    if ($debug) {
        $d .= "config was last read at " . $self->config_read_at . "\n";
        $d .= Dumper($self->config);
        $d .= "clientAccepts = " . Dumper(\@clientAccepts) . "\n";
        $d .= "requestUri = $requestUri\n";
        $d .= "scriptUrl  = $scriptUrl\n";
        $d .= "project    = $project\n";
        $d .= "resource   = $resource\n";
        #$d .= Dumper(\%ENV);
    }
}

sub badUrl {
    my ($self, $q, $msg) = @_;
    print $q->header(-type => "text/plain",
                     -status => "404 Not found",);
    print "404 Not found.\n\n$msg\n";
}

1;
