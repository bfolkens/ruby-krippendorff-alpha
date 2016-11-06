require 'matrix'

module KrippendorffAlpha
  # Calculate Krippendorff's alpha (inter-rater reliability)
  # data = [
  #   [ nil, nil, nil, nil, nil, 3, 4, 1, 2, 1, 1, 3, 3, nil, 3 ],    # coder 1
  #   [ 1, nil, 2, 1, 3, 3, 4, 3, nil, nil, nil, nil, nil, nil, nil], # coder 2
  #   [ nil, nil, 2, 1, 3, 4, 4, nil, 2, 1, 1, 3, 3, nil, 4 ]         # coder 3
  # ]
  def krippendorff_alpha(conversion = :to_f)
    diff_func = lambda {|c, k| ((c-k)/(c+k))**2 }
    units = column_vectors.to_a.map {|unit| unit.to_a.compact}.reject {|unit| unit.size < 2}
    n = units.to_a.flatten.count # number of pairable values

    d_o = units.inject(0.0) do |sum_a, unit|
      d_u = unit.product(unit).inject(0.0) do |sum_b, pair|
        sum_b + diff_func.call(*pair.map(&conversion))
      end
      sum_a + d_u / (unit.size - 1)
    end / n.to_f

    d_e = units.inject(0.0) do |sum_a, unit_a|
      sum_a + units.inject(0.0) do |sum_b, unit_b|
        sum_b + unit_a.product(unit_b).inject(0.0) do |sum_p, pair|
          sum_p + diff_func.call(*pair.map(&conversion))
        end
      end
    end / (n * (n - 1)).to_f

    return 1.0 - d_o / d_e
  end
end

Matrix.send(:include, KrippendorffAlpha)
