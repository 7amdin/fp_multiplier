# IEEE-754 Single-Precision Floating-Point Multiplier

A behavioral VHDL implementation of a 32-bit IEEE-754 single-precision floating-point multiplier.

## Interface

`fp_multiplier`

| Port     | Dir | Width | Description                  |
|----------|-----|-------|-------------------------------|
| `a`, `b` | in  | 32    | Operands in IEEE-754 format  |
| `result` | out | 32    | `a * b`, in IEEE-754 format  |

## How it works

1. **Sign** – computed directly as `sign_a XOR sign_b`.
2. **Field extraction** – the 8-bit exponent and 23-bit mantissa are extracted from each operand.
3. **Implicit bit** – a `1` is prepended to each mantissa to restore the implicit leading bit, giving 24-bit mantissas.
4. **Exponent sum** – the two exponents are added and the IEEE-754 bias (127) is subtracted, using a 9-bit intermediate to avoid overflow.
5. **Mantissa multiplication** – the two 24-bit mantissas are multiplied directly (`mant_a * mant_b`), producing a 48-bit product.
6. **Normalization** – the multiplier checks the top bit of the 48-bit product. If it is `1`, the product is ≥ 2 in normalized form, so the mantissa window shifts down one position and the exponent is incremented by one; otherwise the next-lower 23-bit window is used as-is.
7. **Output** – sign, final 8-bit exponent, and 23-bit mantissa are concatenated into the IEEE-754 result.

## Known limitations

This is a teaching/exercise core rather than a production FPU:

- No rounding is applied — the mantissa is truncated to 23 bits rather than rounded.
- Special values (zero, infinity, NaN, subnormals) are not explicitly detected or handled.
- Exponent overflow/underflow beyond the 8-bit field is not checked or saturated.
