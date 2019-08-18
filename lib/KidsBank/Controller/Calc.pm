package KidsBank::Controller::Calc;
use Mojo::Base 'Mojolicious::Controller';

use POSIX;
use List::Util qw(min);

sub interest {
  my ($self) = @_;

  my $json = $self->req->json;

  my $interest = floor($json->{balance} / $json->{child_age}) * $json->{amount_per_age_of_balance};

  $self->render(json => { interest => $interest, new_balance => ($json->{balance} + $interest) });
}

sub match_calc {
  my ($self) = @_;

  my $json = $self->req->json;
  my $settings = $json->{match_settings};

  my $match = 0;
  $match = $json->{deposit_total} * $settings->{rate};
  $match = $match - _remainder($match, $settings->{granularity});
  $match = min($match, $settings->{max});
  $match = 0 if $match < $settings->{min};

  $self->render(json => { match => $match, new_balance => ($json->{balance} + $match) });
}

sub _remainder {
  my ($a, $b) = @_;
  return 0 unless $b && $a;
  return $a / $b - int($a / $b);
}

# $request_json = {
#   balance => 27.75,
#   deposit_total => 7.25,
#   match_settings => {
#     rate => 0.5,
#     granularity => 1,
#     min => 2,
#     max => 4,
#   }
# };

1;
