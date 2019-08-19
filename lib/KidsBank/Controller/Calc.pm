package KidsBank::Controller::Calc;
use Mojo::Base 'Mojolicious::Controller';

use POSIX;
use List::Util qw(min);

sub interest {
  my ($self) = @_;

  my $json = $self->req->json;

  my $interest = floor($json->{balance} / $json->{child_age}) * $json->{amount_per_age_of_balance};

  $self->render(json => { interest => $interest });
}

sub match_calc {
  my ($self) = @_;

  my $json = $self->req->json;
  my $settings = $json->{settings};

  my $match = 0;
  $match = $json->{deposit_total} * $settings->{rate};
  $match = int($match / $settings->{granularity}) * $settings->{granularity};
  $match = min($match, $settings->{max});
  $match = 0 if $match < $settings->{min};

  $self->render(json => { match => $match });
}


1;
