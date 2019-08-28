package Website::Test;

use base 'Test::Class';

use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

sub make_mojo : Tests(startup) {
  my ($self) = @_;

  $self->{t} = Test::Mojo->new('KidsBank');
}

sub test_website : Test(3) {
  my ($self) = @_;

  $self->{t}->get_ok('/')
    ->status_is(200)
    ->content_like(qr/Mojolicious/i);
}

sub _check_form_elements {
  my ($self, @ids) = @_;

  foreach my $id (@ids) {
    $self->{t}->element_exists("label[for=$id]")
      ->element_exists("input[name=$id][type=text]");
  }
}

sub test_interest_form_loads : Test(11) {
  my ($self) = @_;

  $self->{t}->get_ok('/calc/interest')
    ->status_is(200)
    ->content_type_is('text/html;charset=UTF-8')
    ->element_exists('form')
    ->element_exists('input[type=submit]');

  $self->_check_form_elements('balance', 'age', 'amount_per_age');
}

1;

