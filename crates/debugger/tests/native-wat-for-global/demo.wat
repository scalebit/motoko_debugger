(module
  (type $t0 (func (param i32)))
  (type $t1 (func))
  (type $t2 (func (result i32)))
  (func $set_a (type $t0) (param $value i32)
    (global.set $A
      (local.get $value)))
  (func $increase_a (type $t1)
    (global.set $A
      (i32.add
        (global.get $A)
        (i32.const 1))))
  (func $get_a (export "get_a") (type $t2) (result i32)
    (global.get $A))
  (func $testtt (export "testtt") (type $t1)
    (call $increase_a)
    (call $increase_a)
    (call $increase_a)
    (call $increase_a)
    (call $increase_a))
  (global $A (export "A") (mut i32) (i32.const 0)))
