package KidsBank;
use Mojo::Base 'Mojolicious';

sub startup {
  my ($self) = @_;

  my $config = $self->plugin('Config');
  $self->secrets($config->{secrets});

  my $r = $self->routes;
  $r->get('/')->to('example#welcome');

  $r->post('/calc/interest')->to('calc#interest');
  $r->post('/calc/match')->to('calc#match_calc');
}

1;
