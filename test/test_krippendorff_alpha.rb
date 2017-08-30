require 'minitest/autorun'
require 'matrix'
require_relative '../lib/krippendorff_alpha'

class TestKrippendorffAlpha < Minitest::Test
  def setup
    # http://repository.upenn.edu/cgi/viewcontent.cgi?article=1043&context=asc_papers
    @matrix = Matrix[
      [1, 2, 3, 3, 2, 1, 4, 1, 2, nil, nil, nil],
      [1, 2, 3, 3, 2, 2, 4, 1, 2, 5, nil, 3],
      [nil, 3, 3, 3, 2, 3, 4, 2, 2, 5, 1, nil],
      [1, 2, 3, 3, 2, 4, 4, 1, 2, 5, 1, nil]
    ]
  end

  def test_should_calculate_krippendorff_alpha
    assert_equal 0.849, @matrix.krippendorff_alpha.round(3)
  end
end
