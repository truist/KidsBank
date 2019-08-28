package CalcInterest::Test;

use Calc; use base 'Calc::Test';

sub make_request_json : Tests(setup) {
  my ($self) = @_;

  $self->{request_json} = {
    balance => 27.75,
    child_age => 7,
    amount_per_age => 0.25
  };
}

sub _test_interest_calc {
  my ($self, $value_to_change, $new_value, $expected_interest) = @_;

  $self->{request_json}->{$value_to_change} = $new_value;
  $self->_test_calc('interest', $self->{request_json}, { interest => $expected_interest });
}

sub basic_case : Test(4) {
  shift->_test_interest_calc('balance', 27.75, 0.75);
}

sub different_case : Test(4) {
  shift->_test_interest_calc('balance', 28.5, 1);
}

sub odd_amount : Test(4) {
  shift->_test_interest_calc('amount_per_age', 5.35, 16.05);
}

sub zero_balance : Test(4) {
  shift->_test_interest_calc('balance', 0, 0);
}

sub under_age : Test(4) {
  shift->_test_interest_calc('child_age', 30, 0);
}

sub rich_kid : Test(4) {
  shift->_test_interest_calc('balance', 1_000_000, 35_714.25);
}


1;

