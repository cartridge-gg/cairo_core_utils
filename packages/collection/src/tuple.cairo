pub trait IsTuple<T> {
    const SIZE: u32;
}

mod impls {
    pub impl Tuple<T, const SIZE: u32> of super::IsTuple<T> {
        const SIZE: u32 = SIZE;
    }
}

impl TupleSize0 = impls::Tuple::<(), 0>;
impl TupleSize1<E0> = impls::Tuple<(E0,), 1>;
impl TupleSize2<E0, E1> = impls::Tuple<(E0, E1), 2>;
impl TupleSize3<E0, E1, E2> = impls::Tuple<(E0, E1, E2), 3>;
impl TupleSize4<E0, E1, E2, E3> = impls::Tuple<(E0, E1, E2, E3), 4>;
impl TupleSize5<E0, E1, E2, E3, E4> = impls::Tuple<(E0, E1, E2, E3, E4), 5>;
impl TupleSize6<E0, E1, E2, E3, E4, E5> = impls::Tuple<(E0, E1, E2, E3, E4, E5), 6>;
impl TupleSize7<E0, E1, E2, E3, E4, E5, E6> = impls::Tuple<(E0, E1, E2, E3, E4, E5, E6), 7>;
impl TupleSize8<E0, E1, E2, E3, E4, E5, E6, E7> = impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7), 8>;
impl TupleSize9<E0, E1, E2, E3, E4, E5, E6, E7, E8> =
    impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7, E8), 9>;
impl TupleSize10<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9> =
    impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7, E8, E9), 10>;
impl TupleSize11<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10> =
    impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10), 11>;
impl TupleSize12<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11> =
    impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11), 12>;
impl TupleSize13<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12> =
    impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12), 13>;
impl TupleSize14<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13> =
    impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13), 14>;
impl TupleSize15<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14> =
    impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14), 15>;
impl TupleSize16<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15> =
    impls::Tuple<(E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15), 16>;
