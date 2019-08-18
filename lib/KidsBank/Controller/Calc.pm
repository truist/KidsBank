package KidsBank::Controller::Calc;
use Mojo::Base 'Mojolicious::Controller';

use POSIX;

sub interest {
  my ($self) = @_;

  my $json = $self->req->json;

  my $interest = floor($json->{balance} / $json->{child_age}) * $json->{amount_per_age_of_balance};

  $self->render(json => { interest => $interest, new_balance => ($json->{balance} + $interest) });

}

1;
