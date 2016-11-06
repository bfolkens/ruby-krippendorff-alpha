# Krippendorff Alpha

An implementation of the Krippendorff Alpha coefficient calculation for the Ruby standard Matrix library.  Krippendorff's algorithm is used extensively in content analysis to determine inter-rater reliability.

https://en.wikipedia.org/wiki/Krippendorff%27s_alpha

## Implementation

This implementation assumes the ratio difference function, though any function can be passed through the `diff_func` parameter as a `Proc` object accepting `c` and `k` values, as mentioned in the Wikipedia article above.

## References

* http://grrrr.org/data/dev/krippendorff_alpha/krippendorff_alpha.py
