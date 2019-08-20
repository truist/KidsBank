package KidsBank::Controller::Calc;
use Mojo::Base 'Mojolicious::Controller';

use POSIX qw(floor);
use List::Util qw(min);

sub interest {
  my ($self) = @_;

  my $json = $self->req->json;
  if ($json) {
    my $interest = floor($json->{balance} / $json->{child_age}) * $json->{amount_per_age_of_balance};

    $self->render(json => { interest => $interest });
  } else {
    $self->render(msg => "Testing from the interest calculator");
  }

}

sub match_calc {
  my ($self) = @_;

  my $json = $self->req->json;

  my $match = 0;
  $match = $json->{deposit_total} * $json->{rate};
  $match = int($match / $json->{granularity}) * $json->{granularity};
  $match = min($match, $json->{max});
  $match = 0 if $match < $json->{min};

  $self->render(json => { match => $match });
}


1;
