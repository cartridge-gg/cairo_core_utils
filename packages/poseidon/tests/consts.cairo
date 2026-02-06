#[cfg(test)]
mod tests {
    use cgg_poseidon::{
        PoseidonFixedArray, poseidon_hash_const_single, poseidon_hash_const_three,
        poseidon_hash_const_two, poseidon_hash_fixed_array,
    };
    use core::fmt::Debug;
    use core::poseidon::poseidon_hash_span;
    use snforge_std::fuzzable::Fuzzable;


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
