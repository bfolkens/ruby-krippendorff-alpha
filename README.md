# Krippendorff Alpha

An implementation of the Krippendorff Alpha coefficient calculation for the Ruby standard Matrix library.  Krippendorff's algorithm is used extensively in content analysis to determine inter-rater reliability.

https://en.wikipedia.org/wiki/Krippendorff%27s_alpha

## Implementation

This implementation assumes the ratio difference function, though any function can be passed through the `diff_func` parameter as a `Proc` object accepting `c` and `k` values, as mentioned in the Wikipedia article above.

## Example

```
m = Matrix[
   [ nil, nil, nil, nil, nil, 3, 4, 1, 2, 1, 1, 3, 3, nil, 3 ],    # coder 1
   [ 1, nil, 2, 1, 3, 3, 4, 3, nil, nil, nil, nil, nil, nil, nil], # coder 2
   [ nil, nil, 2, 1, 3, 4, 4, nil, 2, 1, 1, 3, 3, nil, 4 ]         # coder 3
]

puts m.krippendorff_alpha
```

## Optimization

Since Matrix objects can get quite large, and some of the calculations for the Alpha score can have a significant computation cost associated with the multiple levels of recursion, we've implemented an FFI module in order to enjoy a profound speedup in performance.

Given the following:

```
require 'benchmark'
require_relative 'lib/krippendorff_alpha'

m = Matrix.build(35, 100) { |row, col| ((rand * 2) + 1).round }
puts Benchmark.measure { 10.times { m.krippendorff_alpha }}
```

We observe the following speedup:

Method | user | system | total | real
--- | ---:| ---:| ---:| ---:
FFI | 0.010000 | 0.000000 | 0.010000 | 0.010492
Ruby | 84.350000 | 0.090000 | 84.440000 | 85.125188

## References

* http://grrrr.org/data/dev/krippendorff_alpha/krippendorff_alpha.py
* http://repository.upenn.edu/cgi/viewcontent.cgi?article=1043&context=asc_papers
