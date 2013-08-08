#!/opt/perl-5.8.8/bin/perl -w

use strict;

use CGI;
use Sys::Hostname;
use Cwd;
use Data::Dumper;

BEGIN { $ENV{TERM} = 'xterm' }

our $PRDAILY_APP = "/usr/sbin/prdaily";

my @menu =
  (
   ['info', 'General information', \&s_common],
   ['env', 'Environment', \&s_env],
   ['fcgi', 'FastCGI processes', \&s_fcgi],
   ['top', 'Top sorted by memory size', \&s_top],
   ['kill', 'Kill FastCGI scripts', \&s_kill],
   ['stack', 'Show process stack', \&s_stack],
   ['swap', 'Swapping statistics', \&s_swap],
   ['prdaily', $PRDAILY_APP, \&s_prdaily],
  );

my %menu;
for my $item (@menu) {
    $menu{$item->[0]} = $item;
}

my $prog = $0;
$prog =~ s/^.*\///;

my $q = CGI->new();
my $url = $q->url(-relative => 1);
print $q->header(-expires => '-1d');

my $addr = $ENV{HTTP_X_FORWARDED_FOR} || $ENV{ HTTP_X_FWD_IP_ADDR} || $ENV{REMOTE_ADDR} || '';
if ($addr =~ /^(?:130\.14\.|10\.10\.|10\.\20\.|165\.112\.7\.|127\.0\.0\.1$)/) {
    my $a = 0;
}
else
{
    print $q->start_html($prog);
    print "You are NOT ALLOWED to perform this operation [your address: $addr]\n";
    print $q->end_html();
    exit 0;
}

print $q->start_html($prog);
my $serv = $q->param('s') || '';
menu($serv);

if (exists $menu{$serv}) {
    print $q->h1($menu{$serv}[1]);
    $menu{$serv}[2]->();
}

print $q->end_html();

exit 0;

################################################################
sub menu
{
    my $serv = shift;

    print "<ul>\n";
    for my $item (@menu) {
    if ($item->[0] ne $serv) {
        print "<li>" . $q->a({href => "$url?s=$item->[0]"}, $item->[1]) . "\n";
    } else {
        print "<li><b>$item->[1]</b>\n";
    }
    }
    print "</ul>\n";
}

################################################################
sub s_common
{
    print "<pre>\n";
    prn("uname", `/usr/bin/uname -a`);

    if (open(CPU, "</proc/cpuinfo")) {
    prn("/proc/cpuinfo");
    print "<pre>";
    print while(<CPU>);
    print "</pre>";
    close CPU;
    }
    print "</pre>\n";
}

################################################################
sub s_env
{
    print "<pre>\n";
    prn("", \%ENV);
    print "</pre>\n";
}

################################################################
sub s_top
{
    print "<pre>\n";
    if (open(P, "/usr/bin/top -bn1 2>&1 |")) {
    my ($title, @y);
    while(<P>){
        chomp;
        my @x = split;
        if (!exists $x[0] || $x[0] !~ /^\d+$/) {
        print $_, "\n";
        next;
        }
        next if @x != 12 or $x[0] !~ /^\d+$/;
        $x[100] = $x[4];
        $x[100] = $1 * 1_000 if ($x[4] =~ /(\d+)m$/);
        $x[100] = $1 * 1_000_000 if ($x[4] =~ /(\d+)g$/);
        push @y, [@x];
    }
#   prnt($title) if $title;
    for (sort {$b->[100] <=> $a->[100]} @y){prnt($_)};
    close(P);
    } else {
    print "'/usr/bin/top -bn1' failed\n";
    }

    print "</pre>\n";
}

################################################################
sub prnt {
    print "ERROR: prnt(): " . Dumper(\@_)."\n" if ref($_[0]) ne 'ARRAY';
    printf("<a href='info.cgi?s=stack&id=%s'>%5s</a> %-8s %3s %3s %5s %4s %5s %-4s %4s %4s %6s %s\n",
       $_[0][0], @{$_[0]})
}

################################################################
sub s_fcgi
{
    print "<pre>\n";
    if (open(P, "/bin/ps -eaf |")) {
    while(<P>) {
        chomp;
        next if !/\.fcgi/;
        s/^(\w+\s+)(\d+)(\s+)(\d+)/$1<a href="info.cgi?s=stack&id=$2,$4">$2$3$4<\/a>/;
        print "$_\n";
    }
    close(P);
    } else {
    print "'/bin/ps -eaf' failed\n";
    }

    print "</pre>\n";
}

################################################################
sub s_swap
{
    print "<pre>\n";
    if (open(P, "/usr/bin/sar -W |")) {
    while(<P>) {
        chomp;
        print "$_\n";
    }
    close(P);
    } else {
    print "'/usr/bin/sar -W' failed\n";
    }

    print "</pre>\n";
}

################################################################
sub s_prdaily
{
    print "<pre>\n";
    if (open(P, "$PRDAILY_APP |")) {
    local $/;
    my $content = <P>;
    close(P);
    $content =~ s/\n{2,}/\n\n/sg;
    print $content;
    } else {
    print "'$PRDAILY_APP' failed\n";
    }
    print "</pre>\n";
}

################################################################
sub s_stack
{
    my $ids = $q->param('id') || '';
    print "<pre>";
    for my $id (split(/\s*,\s*/, $ids)) {
    next if $id !~ /^\d+$/;
    print "\nID: $id [<a href='info.cgi?s=kill&id=$id'>kill</a>]\n";
    if (open(P, "/usr/bin/pstack $id 2>&1 |")) {
        while(<P>) {
        chomp;
        print "$_\n";
        }
        close(P);
    } else {
        print "'/usr/bin/pstack ' failed\n";
    }
    }
    print "</pre>";
}

################################################################
sub s_kill
{
    print "<pre>\n";
    my $hostname = hostname();
    my $dir = $0;
    $dir =~ s/\/[^\/]+$//;

    my $pid = $q->param('id');
    if ($pid && $pid =~ /^\d+$/) {
    print "killing process [PID: $pid] on $hostname\n";
    my $rc = kill(9,$pid);
    if ($rc) {
        print "process [PID: $pid] on $hostname was KILLED\n";
    } else {
        print "ERROR: process [PID: $pid] on $hostname was NOT killed\n";
    }
    return;
    }

    print "Processes started from '$dir' on '$hostname' will be killed!\n";

    if (open(P, "/bin/ps -fu www |")) {
    my $cnt = 0;
    while(<P>) {
        chomp;
        next unless m{$dir};
        next unless m{\.fcgi};
        if (/(\d+) .*? (\S+)$/) {
        ++$cnt;
        printf "kill -9 %s;  %s\n", $1, $2;
        kill 9, $1;
        }
    }
    print "$cnt processes were killed\n";
    close P;
    } else {
    print "'/bin/ps -fu www' failed\n";
    }

    print "</pre>\n";
}

################################################################
sub prn
{
    my ($header, $str) = @_;
    print "\n", "=" x 16, " $header ", "=" x 16, "\n" if $header;
    return if not defined $str;

    if (ref $str eq '') {
    print "$str\n";
    } elsif (ref $str eq 'HASH') {
    for (sort keys %{ $str }) {
        printf "%-24s: %s\n", $_, $str->{$_};
    }
    }
}

### END ###
