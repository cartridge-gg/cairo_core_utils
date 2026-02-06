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
