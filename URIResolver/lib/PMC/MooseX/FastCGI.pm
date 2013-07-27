package PMC::MooseX::FastCGI;

use Moose::Role;

requires 'process_request';

use CGI::Fast;

has 'max_loops' => (
		    is => 'ro',
		    isa => 'Int',
		    default => 100,
		   );

sub run {
    my $self = shift;
    my $n_loop = 0;

    $self->fastcgi_init if $self->can('fastcgi_init');

    while(my $q = CGI::Fast->new()) {
	$self->process_request($q);
	last if ++$n_loop > $self->max_loops;
    }
}

1;
