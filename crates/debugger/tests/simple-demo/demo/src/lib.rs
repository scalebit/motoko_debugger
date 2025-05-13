pub fn inc_mut(inc_mut_para:&mut i32) {
    *inc_mut_para += 1;
}

#[no_mangle]
pub fn inc_impl(inc_param: i32) -> i32 {
    let inc_local = 10;
    return inc_param + inc_local;
}

#[no_mangle]
pub fn inc(inc_param: i32) -> i32 {
    let inc_local = inc_param;
    return inc_impl(inc_local);
}

#[no_mangle]
pub fn testtt() -> i32 {
    let test_local = 1;
    let mut test_local_inc = inc(test_local);
    inc_mut(&mut test_local_inc);
    return test_local_inc;
}

// run inc -- 100
// expectd finish(110)
