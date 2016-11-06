require 'minitest/autorun'
require 'matrix'
require_relative '../lib/krippendorff_alpha'

class TestKrippendorffAlpha < Minitest::Test
  def setup
    @matrix = Matrix[
       [ nil, nil, nil, nil, nil, 3, 4, 1, 2, 1, 1, 3, 3, nil, 3 ],    # coder 1
       [ 1, nil, 2, 1, 3, 3, 4, 3, nil, nil, nil, nil, nil, nil, nil], # coder 2
       [ nil, nil, 2, 1, 3, 4, 4, nil, 2, 1, 1, 3, 3, nil, 4 ]         # coder 3
    ]
  end

  def test_should_calculate_krippendorff_alpha
    assert_equal 0.809, @matrix.krippendorff_alpha.round(3)
  end
end
