use cgg_collection::CollectionSplit;
use crate::{hades_permutation_const, hades_permutation_const_result};


const fn poseidon_update_state_with_pair(
    state: [felt252; 3], first: felt252, second: felt252,
) -> [felt252; 3] {
    let [s0, s1, s2] = state;
    hades_permutation_const(s0 + first, s1 + second, s2)
}

pub const fn poseidon_hash_finalize_odd(s0: felt252, s1: felt252, s2: felt252) -> felt252 {
    hades_permutation_const_result(s0, s1 + 1, s2)
}

pub const fn poseidon_hash_finalize_even(s0: felt252, s1: felt252, s2: felt252) -> felt252 {
    hades_permutation_const_result(s0 + 1, s1, s2)
}

pub const fn poseidon_hash_const_single(value: felt252) -> felt252 {
    hades_permutation_const_result(value, 1, 0)
}
pub const fn poseidon_hash_const_two(value1: felt252, value2: felt252) -> felt252 {
    let [s0, s1, s2] = hades_permutation_const(value1, value2, 0);
    hades_permutation_const_result(s0 + 1, s1, s2)
}
pub const fn poseidon_hash_const_three(
    value1: felt252, value2: felt252, value3: felt252,
) -> felt252 {
    let [s0, s1, s2] = hades_permutation_const(value1, value2, 0);
    hades_permutation_const_result(s0 + value3, s1 + 1, s2)
}

pub trait PoseidonFixedArray<T> {
    const fn poseidon_hash_fixed_array(self: [felt252; 3], inputs: T) -> felt252;
}

impl PoseidonHashConst0 of PoseidonFixedArray<[felt252; 0]> {
    const fn poseidon_hash_fixed_array(self: [felt252; 3], inputs: [felt252; 0]) -> felt252 {
        let [s0, s1, s2] = self;
        poseidon_hash_finalize_even(s0, s1, s2)
    }
}

impl PoseidonHashConst1 of PoseidonFixedArray<[felt252; 1]> {
    const fn poseidon_hash_fixed_array(self: [felt252; 3], inputs: [felt252; 1]) -> felt252 {
        let [value] = inputs;
        let [s0, s1, s2] = self;
        poseidon_hash_finalize_odd(s0 + value, s1, s2)
    }
}

impl PoseidonFixedArrayImpl<
    const SIZE: usize,
    impl S0: CollectionSplit<[felt252; SIZE]>[Head: felt252],
    impl S1: CollectionSplit<S0::Rest>[Head: felt252],
    impl Pos: PoseidonFixedArray<S1::Rest>,
    +Drop<S1::Rest>,
> of PoseidonFixedArray<[felt252; SIZE]> {
    const fn poseidon_hash_fixed_array(self: [felt252; 3], inputs: [felt252; SIZE]) -> felt252 {
        let (value1, rest) = inputs.split_head();
        let (value2, rest) = rest.split_head();
        let [s0, s1, s2] = self;
        let new_state = poseidon_update_state_with_pair([s0, s1, s2], value1, value2);
        new_state.poseidon_hash_fixed_array(rest)
    }
}


pub const fn poseidon_hash_fixed_array<
    const SIZE: usize, impl Hash: PoseidonFixedArray<[felt252; SIZE]>,
>(
    inputs: [felt252; SIZE],
) -> felt252 {
    let initial_state: [felt252; 3] = [0, 0, 0];
    initial_state.poseidon_hash_fixed_array(inputs)
}


#[cfg(test)]
mod tests {
    use core::fmt::Debug;
    use core::poseidon::poseidon_hash_span;
    use snforge_std::fuzzable::Fuzzable;
    use super::{
        PoseidonFixedArray, poseidon_hash_const_single, poseidon_hash_const_three,
        poseidon_hash_const_two, poseidon_hash_fixed_array,
    };


    const VALUES_1: [felt252; 1] = ['hello'];
    const HASH_1: felt252 = poseidon_hash_fixed_array(VALUES_1);
    const HASH_FN_1: felt252 = poseidon_hash_const_single('hello');
    const VALUES_2: [felt252; 2] = ['foo', 'bar'];
    const HASH_2: felt252 = poseidon_hash_fixed_array(VALUES_2);
    const HASH_FN_2: felt252 = poseidon_hash_const_two('foo', 'bar');
    const VALUES_3: [felt252; 3] = ['make', 'it', 'so'];
    const HASH_3: felt252 = poseidon_hash_fixed_array(VALUES_3);
    const HASH_FN_3: felt252 = poseidon_hash_const_three('make', 'it', 'so');
    const VALUES_4: [felt252; 4] = ['Ubiquitous', 'Mendacious', 'Polyglottal', 'Donkey Balls'];
    const HASH_4: felt252 = poseidon_hash_fixed_array(VALUES_4);
    const VALUES_16: [felt252; 16] = [
        'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven',
        'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen',
    ];
    const HASH_16: felt252 = poseidon_hash_fixed_array(VALUES_16);

    impl FuzzableFixedArrayImpl<
        T,
        const SIZE: usize,
        +Debug<[T; SIZE]>,
        +Debug<T>,
        +Drop<T>,
        impl FuzzyElem: Fuzzable<T>,
        impl TI: TryInto<Span<T>, @Box<[T; SIZE]>>,
        +Copy<T>,
    > of Fuzzable<[T; SIZE]> {
        fn generate() -> [T; SIZE] {
            let array = (0..SIZE).into_iter().map(|_i| FuzzyElem::generate()).collect::<Array<_>>();
            TI::try_into(array.span()).unwrap().unbox()
        }
        fn blank() -> [T; SIZE] {
            let array = (0..SIZE).into_iter().map(|_i| FuzzyElem::blank()).collect::<Array<_>>();
            TI::try_into(array.span()).unwrap().unbox()
        }
    }
    fn test_poseidon_hash_fixed_array<
        const SIZE: usize,
        +PoseidonFixedArray<[felt252; SIZE]>,
        impl ToSpan: ToSpanTrait<[felt252; SIZE], felt252>,
    >(
        values: [felt252; SIZE],
    ) {
        let hash = poseidon_hash_fixed_array(values);
        test_hash_against_poseidon_hash_span::<_, _, ToSpan>(hash, values);
    }

    fn test_hash_against_poseidon_hash_span<
        const SIZE: usize,
        +PoseidonFixedArray<[felt252; SIZE]>,
        impl ToSpan: ToSpanTrait<[felt252; SIZE], felt252>,
    >(
        hash: felt252, values: [felt252; SIZE],
    ) {
        let expected_hash = poseidon_hash_span(ToSpan::span(@values));
        assert_eq!(hash, expected_hash);
    }

    #[test]
    fn test_poseidon_hash_const_fixed_array_size_1() {
        test_hash_against_poseidon_hash_span(HASH_1, VALUES_1);
        assert_eq!(HASH_1, HASH_FN_1);
    }
    #[test]
    fn test_poseidon_hash_const_fixed_array_size_2() {
        test_hash_against_poseidon_hash_span(HASH_2, VALUES_2);
        assert_eq!(HASH_2, HASH_FN_2);
    }

    #[test]
    fn test_poseidon_hash_const_fixed_array_size_3() {
        test_hash_against_poseidon_hash_span(HASH_3, VALUES_3);
        assert_eq!(HASH_3, HASH_FN_3);
    }

    #[test]
    fn test_poseidon_hash_const_fixed_array_size_4() {
        test_hash_against_poseidon_hash_span(HASH_4, VALUES_4);
    }

    #[test]
    fn test_poseidon_hash_const_fixed_array_size_16() {
        test_hash_against_poseidon_hash_span(HASH_16, VALUES_16);
    }

    #[test]
    #[fuzzer]
    fn test_poseidon_hash_fixed_array_size_1(values: [felt252; 1]) {
        test_poseidon_hash_fixed_array(values);
    }

    #[test]
    #[fuzzer]
    fn test_poseidon_hash_fixed_array_size_2(values: [felt252; 2]) {
        test_poseidon_hash_fixed_array(values);
    }


    #[test]
    #[fuzzer]
    fn test_poseidon_hash_fixed_array_size_3(values: [felt252; 3]) {
        test_poseidon_hash_fixed_array(values);
    }

    #[test]
    #[fuzzer]
    fn test_poseidon_hash_fixed_array_size_4(values: [felt252; 4]) {
        test_poseidon_hash_fixed_array(values);
    }

    #[test]
    #[fuzzer]
    fn test_poseidon_hash_fixed_array_size_5(values: [felt252; 5]) {
        test_poseidon_hash_fixed_array(values);
    }

    #[test]
    #[fuzzer]
    fn test_poseidon_hash_fixed_array_size_16(values: [felt252; 16]) {
        test_poseidon_hash_fixed_array(values);
    }
}
