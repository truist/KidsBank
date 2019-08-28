package KidsBank::Controller::Calc;
use Mojo::Base 'Mojolicious::Controller';

use POSIX qw(floor);
use List::Util qw(min);

sub _params {
  my ($self, @names) = @_;

  my @values;
  foreach my $name (@names) {
    push(@values, $self->param($name));
  }

  return @values;
}

sub interest {
  my ($self) = @_;

  if ('GET' eq $self->req->method) {
    my ($balance, $age, $amount_per_age) = $self->_params('balance', 'age', 'amount_per_age');
    if ($balance && $age && $amount_per_age) {
      # $self->flash(confirmation => "After message");
      $self->render(msg => $self->_calc_interest($balance, $age, $amount_per_age));
      # $self->redirect_to('interest');
    } else {
      # $self->flash(confirmation => "Before message");
      $self->render(msg => "Some text passed from the code to the HTML template");
    }
  } else {
    my $json = $self->req->json;
    my $interest = $self->_calc_interest($json->{balance}, $json->{child_age}, $json->{amount_per_age});
    $self->render(json => { interest => $interest });
  }
}

sub _calc_interest {
  my ($self, $balance, $age, $amount_per_age) = @_;

  return floor($balance / $age) * $amount_per_age;
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
