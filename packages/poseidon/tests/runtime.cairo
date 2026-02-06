#[cfg(test)]
mod tests {
    use cgg_poseidon::{poseidon_hash_single, poseidon_hash_three, poseidon_hash_two};
    use core::hash::HashStateTrait;
    use core::poseidon::{PoseidonTrait, poseidon_hash_span};

    #[test]
    fn test_poseidon_hash_single() {
        let value = 'salt';
        let result = poseidon_hash_single(value);
        let expected_result = poseidon_hash_span([value].span());
        let other_expected_result = PoseidonTrait::new().update(value).finalize();
        assert_eq!(result, expected_result);
        assert_eq!(result, other_expected_result);
    }

    #[test]
    fn test_poseidon_hash_two() {
        let value_1 = 'salt';
        let value_2 = 'beef';
        let result = poseidon_hash_two(value_1, value_2);
        let expected_result = poseidon_hash_span([value_1, value_2].span());
        let other_expected_result = PoseidonTrait::new().update(value_1).update(value_2).finalize();
        assert_eq!(result, expected_result);
        assert_eq!(result, other_expected_result);
    }

    #[test]
    fn test_poseidon_hash_three() {
        let value_1 = 'salt';
        let value_2 = 'beef';
        let value_3 = 'hash';
        let result = poseidon_hash_three(value_1, value_2, value_3);
        let expected_result = poseidon_hash_span([value_1, value_2, value_3].span());
        let other_expected_result = PoseidonTrait::new()
            .update(value_1)
            .update(value_2)
            .update(value_3)
            .finalize();
        assert_eq!(result, expected_result);
        assert_eq!(result, other_expected_result);
    }
}
