package CalcMatch::Test;

use Calc; use base 'Calc::Test';

sub make_request_json : Tests(setup) {
  my ($self) = @_;

  $self->{request_json} = {
    deposit_total => 7.25,
    rate => 0.5,
    granularity => 1,
    min => 2,
    max => 4,
  };
}

sub _test_match_calc {
  my ($self, $value_to_change, $new_value, $expected_match) = @_;

  $self->{request_json}->{$value_to_change} = $new_value;
  $self->_test_calc('match', $self->{request_json}, { match => $expected_match });
}

sub test_basic_case : Test(4) {
  shift->_test_match_calc('deposit_total', 7.25, 3);
}

sub test_different_case : Test(4) {
  shift->_test_match_calc('deposit_total', 4, 2);
}

sub test_not_enough_deposits : Test(4) {
  shift->_test_match_calc('deposit_total', 1.5, 0);
}

sub test_exceed_max : Test(4) {
  shift->_test_match_calc('deposit_total', 11.5, 4);
}

sub test_weird_granularity : Test(4) {
  shift->_test_match_calc('granularity', 0.25, 3.5);
}


1;

