use crate::{
    hint::unlikely,
    nan_preserving_float::{F32, F64},
    TrapCode,
};

/// Type of a value.
///
/// See [`Val`] for details.
///
/// [`Val`]: enum.Value.html
#[derive(Copy, Clone, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum ValType {
    /// 32-bit signed or unsigned integer.
    I32,
    /// 64-bit signed or unsigned integer.
    I64,
    /// 32-bit IEEE 754-2008 floating point number.
    F32,
    /// 64-bit IEEE 754-2008 floating point number.
    F64,
    /// A nullable function reference.
    FuncRef,
    /// A nullable external reference.
    ExternRef,
}

impl ValType {
    /// Returns `true` if [`ValType`] is a Wasm numeric type.
    ///
    /// This is `true` for [`ValType::I32`], [`ValType::I64`],
    /// [`ValType::F32`] and [`ValType::F64`].
    pub fn is_num(&self) -> bool {
        matches!(self, Self::I32 | Self::I64 | Self::F32 | Self::F64)
    }

    /// Returns `true` if [`ValType`] is a Wasm reference type.
    ///
    /// This is `true` for [`ValType::FuncRef`] and [`ValType::ExternRef`].
    pub fn is_ref(&self) -> bool {
        matches!(self, Self::ExternRef | Self::FuncRef)
    }

    pub fn is_float(&self) -> bool {
        matches!(self, Self::F32 | Self::F64)
    }
}

/// Convert one type to another by wrapping.
pub trait WrapInto<T> {
    /// Convert one type to another by wrapping.
    fn wrap_into(self) -> T;
}

/// Convert one type to another by rounding to the nearest integer towards zero.
///
/// # Errors
///
/// Traps when the input float cannot be represented by the target integer or
/// when the input float is NaN.
pub trait TryTruncateInto<T, E> {
    /// Convert one type to another by rounding to the nearest integer towards zero.
    ///
    /// # Errors
    ///
    /// - If the input float value is NaN (not a number).
    /// - If the input float value cannot be represented using the truncated
    ///   integer type.
    fn try_truncate_into(self) -> Result<T, E>;
}

/// Convert one type to another by rounding to the nearest integer towards zero.
///
/// # Note
///
/// This has saturating semantics for when the integer cannot represent the float.
///
/// Returns
///
/// - `0` when the input is NaN.
/// - `int::MIN` when the input is -INF.
/// - `int::MAX` when the input is +INF.
pub trait TruncateSaturateInto<T> {
    /// Convert one type to another by rounding to the nearest integer towards zero.
    fn truncate_saturate_into(self) -> T;
}

/// Convert one type to another by extending with leading zeroes.
pub trait ExtendInto<T> {
    /// Convert one type to another by extending with leading zeroes.
    fn extend_into(self) -> T;
}

/// Sign-extends `Self` integer type from `T` integer type.
pub trait SignExtendFrom<T> {
    /// Convert one type to another by extending with leading zeroes.
    fn sign_extend_from(self) -> Self;
}

/// Allows to efficiently load bytes from `memory` into a buffer.
pub trait LoadInto {
    /// Loads bytes from `memory` into `self`.
    ///
    /// # Errors
    ///
    /// Traps if the `memory` access is out of bounds.
    fn load_into(&mut self, memory: &[u8], address: usize) -> Result<(), TrapCode>;
}

impl<const N: usize> LoadInto for [u8; N] {
    #[inline]
    fn load_into(&mut self, memory: &[u8], address: usize) -> Result<(), TrapCode> {
        let slice: &Self = memory
            .get(address..)
            .and_then(|slice| slice.get(..N))
            .and_then(|slice| slice.try_into().ok())
            .ok_or(TrapCode::MemoryOutOfBounds)?;
        *self = *slice;
        Ok(())
    }
}

/// Allows to efficiently write bytes from a buffer into `memory`.
pub trait StoreFrom {
    /// Writes bytes from `self` to `memory`.
    ///
    /// # Errors
    ///
    /// Traps if the `memory` access is out of bounds.
    fn store_from(&self, memory: &mut [u8], address: usize) -> Result<(), TrapCode>;
}

impl<const N: usize> StoreFrom for [u8; N] {
    #[inline]
    fn store_from(&self, memory: &mut [u8], address: usize) -> Result<(), TrapCode> {
        let slice: &mut Self = memory
            .get_mut(address..)
            .and_then(|slice| slice.get_mut(..N))
            .and_then(|slice| slice.try_into().ok())
            .ok_or(TrapCode::MemoryOutOfBounds)?;
        *slice = *self;
        Ok(())
    }
}

/// Types that can be converted from and to little endian bytes.
pub trait LittleEndianConvert {
    /// The little endian bytes representation.
    type Bytes: Default + LoadInto + StoreFrom;

    /// Converts `self` into little endian bytes.
    fn into_le_bytes(self) -> Self::Bytes;

    /// Converts little endian bytes into `Self`.
    fn from_le_bytes(bytes: Self::Bytes) -> Self;
}

macro_rules! impl_little_endian_convert_primitive {
    ( $($primitive:ty),* $(,)? ) => {
        $(
            impl LittleEndianConvert for $primitive {
                type Bytes = [::core::primitive::u8; ::core::mem::size_of::<$primitive>()];

                #[inline]
                fn into_le_bytes(self) -> Self::Bytes {
                    <$primitive>::to_le_bytes(self)
                }

                #[inline]
                fn from_le_bytes(bytes: Self::Bytes) -> Self {
                    <$primitive>::from_le_bytes(bytes)
                }
            }
        )*
    };
}
impl_little_endian_convert_primitive!(u8, u16, u32, u64, i8, i16, i32, i64, f32, f64);

macro_rules! impl_little_endian_convert_float {
    ( $( struct $float_ty:ident($uint_ty:ty); )* $(,)? ) => {
        $(
            impl LittleEndianConvert for $float_ty {
                type Bytes = <$uint_ty as LittleEndianConvert>::Bytes;

                #[inline]
                fn into_le_bytes(self) -> Self::Bytes {
                    <$uint_ty>::into_le_bytes(self.to_bits())
                }

                #[inline]
                fn from_le_bytes(bytes: Self::Bytes) -> Self {
                    Self::from_bits(<$uint_ty>::from_le_bytes(bytes))
                }
            }
        )*
    };
}
impl_little_endian_convert_float!(
    struct F32(u32);
    struct F64(u64);
);

/// Arithmetic operations.
pub trait ArithmeticOps<T>: Copy {
    /// Add two values.
    fn add(self, other: T) -> T;
    /// Subtract two values.
    fn sub(self, other: T) -> T;
    /// Multiply two values.
    fn mul(self, other: T) -> T;
}

/// Integer value.
pub trait Integer<T>: ArithmeticOps<T> {
    /// Counts leading zeros in the bitwise representation of the value.
    fn leading_zeros(self) -> T;
    /// Counts trailing zeros in the bitwise representation of the value.
    fn trailing_zeros(self) -> T;
    /// Counts 1-bits in the bitwise representation of the value.
    fn count_ones(self) -> T;
    /// Get left bit rotation result.
    fn rotl(self, other: T) -> T;
    /// Get right bit rotation result.
    fn rotr(self, other: T) -> T;
    /// Divide two values.
    ///
    /// # Errors
    ///
    /// If `other` is equal to zero.
    fn div(self, other: T) -> Result<T, TrapCode>;
    /// Get division remainder.
    ///
    /// # Errors
    ///
    /// If `other` is equal to zero.
    fn rem(self, other: T) -> Result<T, TrapCode>;
}

/// Float-point value.
pub trait Float<T>: ArithmeticOps<T> {
    /// Get absolute value.
    fn abs(self) -> T;
    /// Returns the largest integer less than or equal to a number.
    fn floor(self) -> T;
    /// Returns the smallest integer greater than or equal to a number.
    fn ceil(self) -> T;
    /// Returns the integer part of a number.
    fn trunc(self) -> T;
    /// Returns the nearest integer to a number. Ties are round to even number.
    fn nearest(self) -> T;
    /// Takes the square root of a number.
    fn sqrt(self) -> T;
    /// Returns the division of the two numbers.
    fn div(self, other: T) -> T;
    /// Returns the minimum of the two numbers.
    fn min(self, other: T) -> T;
    /// Returns the maximum of the two numbers.
    fn max(self, other: T) -> T;
    /// Sets sign of this value to the sign of other value.
    fn copysign(self, other: T) -> T;
}

macro_rules! impl_wrap_into {
    ($from:ident, $into:ident) => {
        impl WrapInto<$into> for $from {
            #[inline]
            fn wrap_into(self) -> $into {
                self as $into
            }
        }
    };
    ($from:ident, $intermediate:ident, $into:ident) => {
        impl WrapInto<$into> for $from {
            #[inline]
            fn wrap_into(self) -> $into {
                $into::from(self as $intermediate)
            }
        }
    };
}

impl_wrap_into!(i32, i8);
impl_wrap_into!(i32, i16);
impl_wrap_into!(i64, i8);
impl_wrap_into!(i64, i16);
impl_wrap_into!(i64, i32);
impl_wrap_into!(i64, f32, F32);
impl_wrap_into!(u64, f32, F32);

// Casting to self
impl_wrap_into!(i32, i32);
impl_wrap_into!(i64, i64);
impl_wrap_into!(F32, F32);
impl_wrap_into!(F64, F64);

impl WrapInto<F32> for F64 {
    #[inline]
    fn wrap_into(self) -> F32 {
        (f64::from(self) as f32).into()
    }
}

macro_rules! impl_try_truncate_into {
    (@primitive $from: ident, $into: ident, $to_primitive:path, $rmin:literal, $rmax:literal) => {
        impl TryTruncateInto<$into, TrapCode> for $from {
            #[inline]
            fn try_truncate_into(self) -> Result<$into, TrapCode> {
                if self.is_nan() {
                    return Err(TrapCode::BadConversionToInteger);
                }
                if self <= $rmin || self >= $rmax {
                    return Err(TrapCode::IntegerOverflow);
                }
                Ok(self as _)
            }
        }

        impl TruncateSaturateInto<$into> for $from {
            #[inline]
            fn truncate_saturate_into(self) -> $into {
                if self.is_nan() {
                    return <$into as Default>::default();
                }
                if self.is_infinite() && self.is_sign_positive() {
                    return <$into>::MAX;
                }
                if self.is_infinite() && self.is_sign_negative() {
                    return <$into>::MIN;
                }
                self as _
            }
        }
    };
    (@wrapped $from:ident, $intermediate:ident, $into:ident) => {
        impl TryTruncateInto<$into, TrapCode> for $from {
            #[inline]
            fn try_truncate_into(self) -> Result<$into, TrapCode> {
                $intermediate::from(self).try_truncate_into()
            }
        }

        impl TruncateSaturateInto<$into> for $from {
            #[inline]
            fn truncate_saturate_into(self) -> $into {
                $intermediate::from(self).truncate_saturate_into()
            }
        }
    };
}

impl_try_truncate_into!(@primitive f32, i32, num_traits::cast::ToPrimitive::to_i32, -2147483904.0_f32, 2147483648.0_f32);
impl_try_truncate_into!(@primitive f32, u32, num_traits::cast::ToPrimitive::to_u32,          -1.0_f32, 4294967296.0_f32);
impl_try_truncate_into!(@primitive f64, i32, num_traits::cast::ToPrimitive::to_i32, -2147483649.0_f64, 2147483648.0_f64);
impl_try_truncate_into!(@primitive f64, u32, num_traits::cast::ToPrimitive::to_u32,          -1.0_f64, 4294967296.0_f64);
impl_try_truncate_into!(@primitive f32, i64, num_traits::cast::ToPrimitive::to_i64, -9223373136366403584.0_f32,  9223372036854775808.0_f32);
impl_try_truncate_into!(@primitive f32, u64, num_traits::cast::ToPrimitive::to_u64,                   -1.0_f32, 18446744073709551616.0_f32);
impl_try_truncate_into!(@primitive f64, i64, num_traits::cast::ToPrimitive::to_i64, -9223372036854777856.0_f64,  9223372036854775808.0_f64);
impl_try_truncate_into!(@primitive f64, u64, num_traits::cast::ToPrimitive::to_u64,                   -1.0_f64, 18446744073709551616.0_f64);
impl_try_truncate_into!(@wrapped F32, f32, i32);
impl_try_truncate_into!(@wrapped F32, f32, i64);
impl_try_truncate_into!(@wrapped F64, f64, i32);
impl_try_truncate_into!(@wrapped F64, f64, i64);
impl_try_truncate_into!(@wrapped F32, f32, u32);
impl_try_truncate_into!(@wrapped F32, f32, u64);
impl_try_truncate_into!(@wrapped F64, f64, u32);
impl_try_truncate_into!(@wrapped F64, f64, u64);

macro_rules! impl_extend_into {
    ($from:ident, $into:ident) => {
        impl ExtendInto<$into> for $from {
            #[inline]
            #[allow(clippy::cast_lossless)]
            fn extend_into(self) -> $into {
                self as $into
            }
        }
    };
    ($from:ident, $intermediate:ident, $into:ident) => {
        impl ExtendInto<$into> for $from {
            #[inline]
            #[allow(clippy::cast_lossless)]
            fn extend_into(self) -> $into {
                $into::from(self as $intermediate)
            }
        }
    };
}

impl_extend_into!(i8, i32);
impl_extend_into!(u8, i32);
impl_extend_into!(i16, i32);
impl_extend_into!(u16, i32);
impl_extend_into!(i8, i64);
impl_extend_into!(u8, i64);
impl_extend_into!(i16, i64);
impl_extend_into!(u16, i64);
impl_extend_into!(i32, i64);
impl_extend_into!(u32, i64);
impl_extend_into!(u32, u64);

impl_extend_into!(i32, f32, F32);
impl_extend_into!(i32, f64, F64);
impl_extend_into!(u32, f32, F32);
impl_extend_into!(u32, f64, F64);
impl_extend_into!(i64, f64, F64);
impl_extend_into!(u64, f64, F64);
impl_extend_into!(f32, f64, F64);

// Casting to self
impl_extend_into!(i32, i32);
impl_extend_into!(i64, i64);
impl_extend_into!(F32, F32);
impl_extend_into!(F64, F64);

impl ExtendInto<F64> for F32 {
    #[inline]
    fn extend_into(self) -> F64 {
        F64::from(f64::from(f32::from(self)))
    }
}

macro_rules! impl_sign_extend_from {
    ( $( impl SignExtendFrom<$from_type:ty> for $for_type:ty; )* ) => {
        $(
            impl SignExtendFrom<$from_type> for $for_type {
                #[inline]
                #[allow(clippy::cast_lossless)]
                fn sign_extend_from(self) -> Self {
                    (self as $from_type) as Self
                }
            }
        )*
    };
}
impl_sign_extend_from! {
    impl SignExtendFrom<i8> for i32;
    impl SignExtendFrom<i16> for i32;
    impl SignExtendFrom<i8> for i64;
    impl SignExtendFrom<i16> for i64;
    impl SignExtendFrom<i32> for i64;
}

macro_rules! impl_integer_arithmetic_ops {
    ($type: ident) => {
        impl ArithmeticOps<$type> for $type {
            #[inline]
            fn add(self, other: $type) -> $type {
                self.wrapping_add(other)
            }
            #[inline]
            fn sub(self, other: $type) -> $type {
                self.wrapping_sub(other)
            }
            #[inline]
            fn mul(self, other: $type) -> $type {
                self.wrapping_mul(other)
            }
        }
    };
}

impl_integer_arithmetic_ops!(i32);
impl_integer_arithmetic_ops!(u32);
impl_integer_arithmetic_ops!(i64);
impl_integer_arithmetic_ops!(u64);

macro_rules! impl_float_arithmetic_ops {
    ($type:ty) => {
        impl ArithmeticOps<Self> for $type {
            #[inline]
            fn add(self, other: Self) -> Self {
                self + other
            }
            #[inline]
            fn sub(self, other: Self) -> Self {
                self - other
            }
            #[inline]
            fn mul(self, other: Self) -> Self {
                self * other
            }
        }
    };
}

impl_float_arithmetic_ops!(f32);
impl_float_arithmetic_ops!(f64);
impl_float_arithmetic_ops!(F32);
impl_float_arithmetic_ops!(F64);

macro_rules! impl_integer {
    ($type:ty) => {
        impl Integer<Self> for $type {
            #[inline]
            #[allow(clippy::cast_lossless)]
            fn leading_zeros(self) -> Self {
                self.leading_zeros() as _
            }
            #[inline]
            #[allow(clippy::cast_lossless)]
            fn trailing_zeros(self) -> Self {
                self.trailing_zeros() as _
            }
            #[inline]
            #[allow(clippy::cast_lossless)]
            fn count_ones(self) -> Self {
                self.count_ones() as _
            }
            #[inline]
            fn rotl(self, other: Self) -> Self {
                self.rotate_left(other as u32)
            }
            #[inline]
            fn rotr(self, other: Self) -> Self {
                self.rotate_right(other as u32)
            }
            #[inline]
            fn div(self, other: Self) -> Result<Self, TrapCode> {
                if unlikely(other == 0) {
                    return Err(TrapCode::IntegerDivisionByZero);
                }
                let (result, overflow) = self.overflowing_div(other);
                if unlikely(overflow) {
                    return Err(TrapCode::IntegerOverflow);
                }
                Ok(result)
            }
            #[inline]
            fn rem(self, other: Self) -> Result<Self, TrapCode> {
                if unlikely(other == 0) {
                    return Err(TrapCode::IntegerDivisionByZero);
                }
                Ok(self.wrapping_rem(other))
            }
        }
    };
}
impl_integer!(i32);
impl_integer!(u32);
impl_integer!(i64);
impl_integer!(u64);

// We cannot call the math functions directly, because they are not all available in `core`.
// In no-std cases we instead rely on `libm`.
// These wrappers handle that delegation.
macro_rules! impl_float {
    (type $type:ident as $repr:ty) => {
        // In this particular instance we want to directly compare floating point numbers.
        impl Float<Self> for $type {
            #[inline]
            fn abs(self) -> Self {
                WasmFloatExt::abs(<$repr>::from(self)).into()
            }
            #[inline]
            fn floor(self) -> Self {
                WasmFloatExt::floor(<$repr>::from(self)).into()
            }
            #[inline]
            fn ceil(self) -> Self {
                WasmFloatExt::ceil(<$repr>::from(self)).into()
            }
            #[inline]
            fn trunc(self) -> Self {
                WasmFloatExt::trunc(<$repr>::from(self)).into()
            }
            #[inline]
            fn nearest(self) -> Self {
                WasmFloatExt::nearest(<$repr>::from(self)).into()
            }
            #[inline]
            fn sqrt(self) -> Self {
                WasmFloatExt::sqrt(<$repr>::from(self)).into()
            }
            #[inline]
            fn div(self, other: Self) -> Self {
                self / other
            }
            #[inline]
            fn min(self, other: Self) -> Self {
                // Note: equal to the unstable `f32::minimum` method.
                //
                // Once `f32::minimum` is stable we can simply use it here.
                if self < other {
                    self
                } else if other < self {
                    other
                } else if self == other {
                    if <$repr>::is_sign_negative(<$repr>::from(self))
                        && <$repr>::is_sign_positive(<$repr>::from(other))
                    {
                        self
                    } else {
                        other
                    }
                } else {
                    // At least one input is NaN. Use `+` to perform NaN propagation and quieting.
                    self + other
                }
            }
            #[inline]
            fn max(self, other: Self) -> Self {
                // Note: equal to the unstable `f32::maximum` method.
                //
                // Once `f32::maximum` is stable we can simply use it here.
                if self > other {
                    self
                } else if other > self {
                    other
                } else if self == other {
                    if <$repr>::is_sign_positive(<$repr>::from(self))
                        && <$repr>::is_sign_negative(<$repr>::from(other))
                    {
                        self
                    } else {
                        other
                    }
                } else {
                    // At least one input is NaN. Use `+` to perform NaN propagation and quieting.
                    self + other
                }
            }
            #[inline]
            fn copysign(self, other: Self) -> Self {
                WasmFloatExt::copysign(<$repr>::from(self), <$repr>::from(other)).into()
            }
        }
    };
}
impl_float!( type F32 as f32 );
impl_float!( type F64 as f64 );

/// Low-level Wasm float interface to support `no_std` environments.
///
/// # Dev. Note
///
/// The problem is that in `no_std` builds the Rust standard library
/// does not specify all of the below methods for `f32` and `f64`.
/// Thus this trait serves as an adapter to import this functionality
/// via `libm`.
trait WasmFloatExt {
    /// Equivalent to the Wasm `{f32,f64}.abs` instructions.
    fn abs(self) -> Self;
    /// Equivalent to the Wasm `{f32,f64}.ceil` instructions.
    fn ceil(self) -> Self;
    /// Equivalent to the Wasm `{f32,f64}.floor` instructions.
    fn floor(self) -> Self;
    /// Equivalent to the Wasm `{f32,f64}.trunc` instructions.
    fn trunc(self) -> Self;
    /// Equivalent to the Wasm `{f32,f64}.sqrt` instructions.
    fn sqrt(self) -> Self;
    /// Equivalent to the Wasm `{f32,f64}.nearest` instructions.
    fn nearest(self) -> Self;
    /// Equivalent to the Wasm `{f32,f64}.copysign` instructions.
    fn copysign(self, other: Self) -> Self;
}

#[cfg(not(feature = "std"))]
macro_rules! impl_wasm_float {
    ($ty:ty) => {
        impl WasmFloatExt for $ty {
            #[inline]
            fn abs(self) -> Self {
                <libm::Libm<Self>>::fabs(self)
            }

            #[inline]
            fn ceil(self) -> Self {
                <libm::Libm<Self>>::ceil(self)
            }

            #[inline]
            fn floor(self) -> Self {
                <libm::Libm<Self>>::floor(self)
            }

            #[inline]
            fn trunc(self) -> Self {
                <libm::Libm<Self>>::trunc(self)
            }

            #[inline]
            fn nearest(self) -> Self {
                let round = <libm::Libm<Self>>::round(self);
                if <Self as WasmFloatExt>::abs(self - <Self as WasmFloatExt>::trunc(self)) != 0.5 {
                    return round;
                }
                let rem = round % 2.0;
                if rem == 1.0 {
                    <Self as WasmFloatExt>::floor(self)
                } else if rem == -1.0 {
                    <Self as WasmFloatExt>::ceil(self)
                } else {
                    round
                }
            }

            #[inline]
            fn sqrt(self) -> Self {
                <libm::Libm<Self>>::sqrt(self)
            }

            #[inline]
            fn copysign(self, other: Self) -> Self {
                <libm::Libm<Self>>::copysign(self, other)
            }
        }
    };
}

#[cfg(feature = "std")]
macro_rules! impl_wasm_float {
    ($ty:ty) => {
        impl WasmFloatExt for $ty {
            #[inline]
            fn abs(self) -> Self {
                self.abs()
            }

            #[inline]
            fn ceil(self) -> Self {
                self.ceil()
            }

            #[inline]
            fn floor(self) -> Self {
                self.floor()
            }

            #[inline]
            fn trunc(self) -> Self {
                self.trunc()
            }

            #[inline]
            fn nearest(self) -> Self {
                self.round_ties_even()
            }

            #[inline]
            fn sqrt(self) -> Self {
                self.sqrt()
            }

            #[inline]
            fn copysign(self, other: Self) -> Self {
                self.copysign(other)
            }
        }
    };
}

impl_wasm_float!(f32);
impl_wasm_float!(f64);

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn wasm_float_min_regression_works() {
        assert_eq!(
            Float::min(F32::from(-0.0), F32::from(0.0)).to_bits(),
            0x8000_0000,
        );
        assert_eq!(
            Float::min(F32::from(0.0), F32::from(-0.0)).to_bits(),
            0x8000_0000,
        );
    }

    #[test]
    fn wasm_float_max_regression_works() {
        assert_eq!(
            Float::max(F32::from(-0.0), F32::from(0.0)).to_bits(),
            0x0000_0000,
        );
        assert_eq!(
            Float::max(F32::from(0.0), F32::from(-0.0)).to_bits(),
            0x0000_0000,
        );
    }

    #[test]
    fn copysign_regression_works() {
        // This test has been directly extracted from a WebAssembly Specification assertion.
        use Float as _;
        assert!(F32::from_bits(0xFFC00000).is_nan());
        assert_eq!(
            F32::from_bits(0xFFC00000)
                .copysign(F32::from_bits(0x0000_0000))
                .to_bits(),
            F32::from_bits(0x7FC00000).to_bits()
        )
    }
}
