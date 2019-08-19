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

1;

