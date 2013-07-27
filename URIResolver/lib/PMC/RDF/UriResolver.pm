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
    $self->config($config);
}

# Initialize the FCGI
sub fastcgi_init {
    my ($self) = shift;
    $self->read_config_if_necessary;
}

sub process_request {
    my ($self, $q) = @_;

    $self->read_config_if_necessary;

    # Parse the request URL.  This script should work identically in any of
    # several different environments (for debugging purposes).  E.g.
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

    my $requestUri = $self->{requestUri} = $ENV{REQUEST_URI};
    if ($requestUri !~ m/
          (                        # capture the whole match
            \/                     # always has a leading slash, I think
            (                      # start of the script url (which might be empty)
              (rdf\/)?             # optional rdf prefix
              (index\.f?cgi\/)?    # optional name of the script
            )
            ([A-Za-z0-9_\-.]+)     # project
            (\/.*)                 # resource
          )
        /x)
    {
        $self->badUrl($q);
        return;
    }
    my $match = $1;
    my $scriptUrl = $self->{scriptUrl} = $2;
    my $project   = $self->{project}   = $5;
    my $resource  = $self->{resource}  = $6;


    print $q->header("text/plain");
    print "requestUri = $requestUri\n";
    print "match = $match\n";
    print "scriptUrl  = $scriptUrl\n";
    print "project    = $project\n";
    print "resource   = $resource\n";

    #print "config was last read at " . $self->config_read_at . "\n";
    #print Dumper($self->config);
    print Dumper(\%ENV);

}

sub badUrl {
    my ($self, $q) = @_;
    print $q->header(-type => "text/plain",
                     -status => '404 Not found',);
    print "404 Not found.\n";
}

1;
