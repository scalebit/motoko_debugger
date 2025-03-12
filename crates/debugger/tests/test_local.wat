(module $lib_wasm.wasm
  (type $t0 (func (param i32 i32)))
  (type $t1 (func (param i32 i32 i32) (result i32)))
  (type $t2 (func (param i32 i32) (result i32)))
  (type $t3 (func (param i32)))
  (type $t4 (func (param i32) (result i32)))
  (type $t5 (func))
  (type $t6 (func (param i32 i32 i32)))
  (type $t7 (func (param i32 i32 i32 i32) (result i32)))
  (type $t8 (func (param i32 i32 i32 i32 i32)))
  (type $t9 (func (param i32 i32 i32 i32)))
  (type $t10 (func (param i32 i32 i32 i32 i32 i32) (result i32)))
  (type $t11 (func (param i32 i32 i32 i32 i32) (result i32)))
  (func $_ZN8lib_wasm7inc_mut17h2f05961c35083b52E (type $t3) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32)
    (local.set $l1
      (global.get $__stack_pointer))
    (local.set $l2
      (i32.const 16))
    (local.set $l3
      (i32.sub
        (local.get $l1)
        (local.get $l2)))
    (global.set $__stack_pointer
      (local.get $l3))
    (i32.store offset=12
      (local.get $l3)
      (local.get $p0))
    (local.set $l4
      (i32.load
        (local.get $p0)))
    (local.set $l5
      (i32.const 1))
    (local.set $l6
      (i32.add
        (local.get $l4)
        (local.get $l5)))
    (local.set $l7
      (i32.lt_s
        (local.get $l6)
        (local.get $l4)))
    (local.set $l8
      (i32.const 1))
    (local.set $l9
      (i32.and
        (local.get $l7)
        (local.get $l8)))
    (block $B0
      (br_if $B0
        (local.get $l9))
      (i32.store
        (local.get $p0)
        (local.get $l6))
      (local.set $l10
        (i32.const 16))
      (local.set $l11
        (i32.add
          (local.get $l3)
          (local.get $l10)))
      (global.set $__stack_pointer
        (local.get $l11))
      (return))
    (local.set $l12
      (i32.const 1048588))
    (call $_ZN4core9panicking11panic_const24panic_const_add_overflow17h76ec5bef6e5a6f3eE
      (local.get $l12))
    (unreachable))
  (func $_ZN8lib_wasm3inc17h83afce7f1755173bE (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32)
    (local.set $l1
      (global.get $__stack_pointer))
    (local.set $l2
      (i32.const 16))
    (local.set $l3
      (i32.sub
        (local.get $l1)
        (local.get $l2)))
    (global.set $__stack_pointer
      (local.get $l3))
    (i32.store offset=8
      (local.get $l3)
      (local.get $p0))
    (local.set $l4
      (i32.const 1))
    (i32.store offset=12
      (local.get $l3)
      (local.get $l4))
    (local.set $l5
      (i32.const 1))
    (local.set $l6
      (i32.add
        (local.get $p0)
        (local.get $l5)))
    (local.set $l7
      (i32.lt_s
        (local.get $l6)
        (local.get $p0)))
    (local.set $l8
      (i32.const 1))
    (local.set $l9
      (i32.and
        (local.get $l7)
        (local.get $l8)))
    (block $B0
      (br_if $B0
        (local.get $l9))
      (local.set $l10
        (i32.const 16))
      (local.set $l11
        (i32.add
          (local.get $l3)
          (local.get $l10)))
      (global.set $__stack_pointer
        (local.get $l11))
      (return
        (local.get $l6)))
    (local.set $l12
      (i32.const 1048604))
    (call $_ZN4core9panicking11panic_const24panic_const_add_overflow17h76ec5bef6e5a6f3eE
      (local.get $l12))
    (unreachable))
  (func $testtt (export "testtt") (type $t5)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32)
    (local.set $l0
      (global.get $__stack_pointer))
    (local.set $l1
      (i32.const 16))
    (local.set $l2
      (i32.sub
        (local.get $l0)
        (local.get $l1)))
    (global.set $__stack_pointer
      (local.get $l2))
    (local.set $l3
      (i32.const 1))
    (i32.store offset=12
      (local.get $l2)
      (local.get $l3))
    (local.set $l4
      (i32.const 1))
    (local.set $l5
      (call $_ZN8lib_wasm3inc17h83afce7f1755173bE
        (local.get $l4)))
    (i32.store offset=8
      (local.get $l2)
      (local.get $l5))
    (local.set $l6
      (i32.const 8))
    (local.set $l7
      (i32.add
        (local.get $l2)
        (local.get $l6)))
    (local.set $l8
      (local.get $l7))
    (call $_ZN8lib_wasm7inc_mut17h2f05961c35083b52E
      (local.get $l8))
    (local.set $l9
      (i32.const 16))
    (local.set $l10
      (i32.add
        (local.get $l2)
        (local.get $l9)))
    (global.set $__stack_pointer
      (local.get $l10))
    (return))
  (func $__rust_alloc (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    (local.set $l2
      (call $__rdl_alloc
        (local.get $p0)
        (local.get $p1)))
    (return
      (local.get $l2)))
  (func $__rust_dealloc (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (call $__rdl_dealloc
      (local.get $p0)
      (local.get $p1)
      (local.get $p2))
    (return))
  (func $__rust_realloc (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (local $l4 i32)
    (local.set $l4
      (call $__rdl_realloc
        (local.get $p0)
        (local.get $p1)
        (local.get $p2)
        (local.get $p3)))
    (return
      (local.get $l4)))
  (func $__rust_alloc_error_handler (type $t0) (param $p0 i32) (param $p1 i32)
    (call $__rg_oom
      (local.get $p0)
      (local.get $p1))
    (return))
  (func $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h229dd4e49c45a9d9E (type $t0) (param $p0 i32) (param $p1 i32)
    (i64.store offset=8
      (local.get $p0)
      (i64.const 7199936582794304877))
    (i64.store
      (local.get $p0)
      (i64.const -5076933981314334344)))
  (func $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17hde63666261ad548fE (type $t0) (param $p0 i32) (param $p1 i32)
    (i64.store offset=8
      (local.get $p0)
      (i64.const -235516408301547304))
    (i64.store
      (local.get $p0)
      (i64.const 799433722634398613)))
  (func $_ZN5alloc7raw_vec20RawVecInner$LT$A$GT$7reserve21do_reserve_and_handle17h6d615f432a43e13eE (type $t8) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32)
    (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i64)
    (global.set $__stack_pointer
      (local.tee $l5
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 32))))
    (block $B0
      (br_if $B0
        (i32.ge_u
          (local.tee $p2
            (i32.add
              (local.get $p1)
              (local.get $p2)))
          (local.get $p1)))
      (call $_ZN5alloc7raw_vec12handle_error17hf3853b1ce4c4ed17E
        (i32.const 0)
        (i32.const 0))
      (unreachable))
    (local.set $l6
      (i32.const 0))
    (block $B1
      (br_if $B1
        (i32.eqz
          (i32.wrap_i64
            (i64.shr_u
              (local.tee $l9
                (i64.mul
                  (i64.extend_i32_u
                    (i32.and
                      (i32.add
                        (i32.add
                          (local.get $p3)
                          (local.get $p4))
                        (i32.const -1))
                      (i32.sub
                        (i32.const 0)
                        (local.get $p3))))
                  (i64.extend_i32_u
                    (local.tee $l7
                      (select
                        (local.tee $l7
                          (select
                            (i32.const 8)
                            (i32.const 4)
                            (i32.eq
                              (local.get $p4)
                              (i32.const 1))))
                        (local.tee $p2
                          (select
                            (local.tee $l8
                              (i32.shl
                                (local.tee $p1
                                  (i32.load
                                    (local.get $p0)))
                                (i32.const 1)))
                            (local.get $p2)
                            (i32.gt_u
                              (local.get $l8)
                              (local.get $p2))))
                        (i32.gt_u
                          (local.get $l7)
                          (local.get $p2)))))))
              (i64.const 32)))))
      (call $_ZN5alloc7raw_vec12handle_error17hf3853b1ce4c4ed17E
        (i32.const 0)
        (i32.const 0))
      (unreachable))
    (block $B2
      (block $B3
        (br_if $B3
          (i32.gt_u
            (local.tee $p2
              (i32.wrap_i64
                (local.get $l9)))
            (i32.sub
              (i32.const -2147483648)
              (local.get $p3))))
        (block $B4
          (block $B5
            (br_if $B5
              (local.get $p1))
            (local.set $p4
              (i32.const 0))
            (br $B4))
          (i32.store offset=28
            (local.get $l5)
            (i32.mul
              (local.get $p1)
              (local.get $p4)))
          (i32.store offset=20
            (local.get $l5)
            (i32.load offset=4
              (local.get $p0)))
          (local.set $p4
            (local.get $p3)))
        (i32.store offset=24
          (local.get $l5)
          (local.get $p4))
        (call $_ZN5alloc7raw_vec11finish_grow17hfd102e347a05a36eE
          (i32.add
            (local.get $l5)
            (i32.const 8))
          (local.get $p3)
          (local.get $p2)
          (i32.add
            (local.get $l5)
            (i32.const 20)))
        (br_if $B2
          (i32.ne
            (i32.load offset=8
              (local.get $l5))
            (i32.const 1)))
        (local.set $l8
          (i32.load offset=16
            (local.get $l5)))
        (local.set $l6
          (i32.load offset=12
            (local.get $l5))))
      (call $_ZN5alloc7raw_vec12handle_error17hf3853b1ce4c4ed17E
        (local.get $l6)
        (local.get $l8))
      (unreachable))
    (local.set $p3
      (i32.load offset=12
        (local.get $l5)))
    (i32.store
      (local.get $p0)
      (local.get $l7))
    (i32.store offset=4
      (local.get $p0)
      (local.get $p3))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l5)
        (i32.const 32))))
  (func $_ZN4core3fmt5Write9write_fmt17h0e60a00aadf60017E (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (call $_ZN4core3fmt5write17h298882761c3c0a18E
      (local.get $p0)
      (i32.const 1048620)
      (local.get $p1)))
  (func $_ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17hcbd303fab6b1dcf7E (type $t3) (param $p0 i32)
    (local $l1 i32)
    (block $B0
      (br_if $B0
        (i32.eqz
          (local.tee $l1
            (i32.load
              (local.get $p0)))))
      (call $__rust_dealloc
        (i32.load offset=4
          (local.get $p0))
        (local.get $l1)
        (i32.const 1))))
  (func $_ZN4core3ptr77drop_in_place$LT$std..panicking..begin_panic_handler..FormatStringPayload$GT$17h3cfdc40d9ec2a053E (type $t3) (param $p0 i32)
    (local $l1 i32)
    (block $B0
      (br_if $B0
        (i32.eq
          (i32.or
            (local.tee $l1
              (i32.load
                (local.get $p0)))
            (i32.const -2147483648))
          (i32.const -2147483648)))
      (call $__rust_dealloc
        (i32.load offset=4
          (local.get $p0))
        (local.get $l1)
        (i32.const 1))))
  (func $_ZN4core5panic12PanicPayload6as_str17h3f59927b7c7bd59eE (type $t0) (param $p0 i32) (param $p1 i32)
    (i32.store
      (local.get $p0)
      (i32.const 0)))
  (func $_ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$10write_char17h3b4d45a179ad00f2E (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32)
    (global.set $__stack_pointer
      (local.tee $l2
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.lt_u
            (local.get $p1)
            (i32.const 128)))
        (i32.store offset=12
          (local.get $l2)
          (i32.const 0))
        (block $B2
          (block $B3
            (br_if $B3
              (i32.lt_u
                (local.get $p1)
                (i32.const 2048)))
            (block $B4
              (br_if $B4
                (i32.lt_u
                  (local.get $p1)
                  (i32.const 65536)))
              (i32.store8 offset=15
                (local.get $l2)
                (i32.or
                  (i32.and
                    (local.get $p1)
                    (i32.const 63))
                  (i32.const 128)))
              (i32.store8 offset=12
                (local.get $l2)
                (i32.or
                  (i32.shr_u
                    (local.get $p1)
                    (i32.const 18))
                  (i32.const 240)))
              (i32.store8 offset=14
                (local.get $l2)
                (i32.or
                  (i32.and
                    (i32.shr_u
                      (local.get $p1)
                      (i32.const 6))
                    (i32.const 63))
                  (i32.const 128)))
              (i32.store8 offset=13
                (local.get $l2)
                (i32.or
                  (i32.and
                    (i32.shr_u
                      (local.get $p1)
                      (i32.const 12))
                    (i32.const 63))
                  (i32.const 128)))
              (local.set $p1
                (i32.const 4))
              (br $B2))
            (i32.store8 offset=14
              (local.get $l2)
              (i32.or
                (i32.and
                  (local.get $p1)
                  (i32.const 63))
                (i32.const 128)))
            (i32.store8 offset=12
              (local.get $l2)
              (i32.or
                (i32.shr_u
                  (local.get $p1)
                  (i32.const 12))
                (i32.const 224)))
            (i32.store8 offset=13
              (local.get $l2)
              (i32.or
                (i32.and
                  (i32.shr_u
                    (local.get $p1)
                    (i32.const 6))
                  (i32.const 63))
                (i32.const 128)))
            (local.set $p1
              (i32.const 3))
            (br $B2))
          (i32.store8 offset=13
            (local.get $l2)
            (i32.or
              (i32.and
                (local.get $p1)
                (i32.const 63))
              (i32.const 128)))
          (i32.store8 offset=12
            (local.get $l2)
            (i32.or
              (i32.shr_u
                (local.get $p1)
                (i32.const 6))
              (i32.const 192)))
          (local.set $p1
            (i32.const 2)))
        (block $B5
          (br_if $B5
            (i32.ge_u
              (i32.sub
                (i32.load
                  (local.get $p0))
                (local.tee $l3
                  (i32.load offset=8
                    (local.get $p0))))
              (local.get $p1)))
          (call $_ZN5alloc7raw_vec20RawVecInner$LT$A$GT$7reserve21do_reserve_and_handle17h6d615f432a43e13eE
            (local.get $p0)
            (local.get $l3)
            (local.get $p1)
            (i32.const 1)
            (i32.const 1))
          (local.set $l3
            (i32.load offset=8
              (local.get $p0))))
        (drop
          (call $memcpy
            (i32.add
              (i32.load offset=4
                (local.get $p0))
              (local.get $l3))
            (i32.add
              (local.get $l2)
              (i32.const 12))
            (local.get $p1)))
        (i32.store offset=8
          (local.get $p0)
          (i32.add
            (local.get $l3)
            (local.get $p1)))
        (br $B0))
      (block $B6
        (br_if $B6
          (i32.ne
            (local.tee $l3
              (i32.load offset=8
                (local.get $p0)))
            (i32.load
              (local.get $p0))))
        (call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$8grow_one17he969f3d3a0337461E
          (local.get $p0)))
      (i32.store offset=8
        (local.get $p0)
        (i32.add
          (local.get $l3)
          (i32.const 1)))
      (i32.store8
        (i32.add
          (i32.load offset=4
            (local.get $p0))
          (local.get $l3))
        (local.get $p1)))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l2)
        (i32.const 16)))
    (i32.const 0))
  (func $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$8grow_one17he969f3d3a0337461E (type $t3) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32)
    (global.set $__stack_pointer
      (local.tee $l1
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 32))))
    (block $B0
      (br_if $B0
        (i32.ne
          (local.tee $l2
            (i32.load
              (local.get $p0)))
          (i32.const -1)))
      (call $_ZN5alloc7raw_vec12handle_error17hf3853b1ce4c4ed17E
        (i32.const 0)
        (i32.const 0))
      (unreachable))
    (block $B1
      (br_if $B1
        (i32.ge_s
          (local.tee $l3
            (select
              (local.tee $l3
                (select
                  (local.tee $l3
                    (i32.shl
                      (local.get $l2)
                      (i32.const 1)))
                  (local.tee $l4
                    (i32.add
                      (local.get $l2)
                      (i32.const 1)))
                  (i32.gt_u
                    (local.get $l3)
                    (local.get $l4))))
              (i32.const 8)
              (i32.gt_u
                (local.get $l3)
                (i32.const 8))))
          (i32.const 0)))
      (call $_ZN5alloc7raw_vec12handle_error17hf3853b1ce4c4ed17E
        (i32.const 0)
        (i32.const 0))
      (unreachable))
    (block $B2
      (block $B3
        (br_if $B3
          (local.get $l2))
        (local.set $l2
          (i32.const 0))
        (br $B2))
      (i32.store offset=28
        (local.get $l1)
        (local.get $l2))
      (i32.store offset=20
        (local.get $l1)
        (i32.load offset=4
          (local.get $p0)))
      (local.set $l2
        (i32.const 1)))
    (i32.store offset=24
      (local.get $l1)
      (local.get $l2))
    (call $_ZN5alloc7raw_vec11finish_grow17hfd102e347a05a36eE
      (i32.add
        (local.get $l1)
        (i32.const 8))
      (i32.const 1)
      (local.get $l3)
      (i32.add
        (local.get $l1)
        (i32.const 20)))
    (block $B4
      (br_if $B4
        (i32.ne
          (i32.load offset=8
            (local.get $l1))
          (i32.const 1)))
      (call $_ZN5alloc7raw_vec12handle_error17hf3853b1ce4c4ed17E
        (i32.load offset=12
          (local.get $l1))
        (i32.load offset=16
          (local.get $l1)))
      (unreachable))
    (local.set $l2
      (i32.load offset=12
        (local.get $l1)))
    (i32.store
      (local.get $p0)
      (local.get $l3))
    (i32.store offset=4
      (local.get $p0)
      (local.get $l2))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l1)
        (i32.const 32))))
  (func $_ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$9write_str17hf0fb92960288353aE (type $t1) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32)
    (block $B0
      (br_if $B0
        (i32.ge_u
          (i32.sub
            (i32.load
              (local.get $p0))
            (local.tee $l3
              (i32.load offset=8
                (local.get $p0))))
          (local.get $p2)))
      (call $_ZN5alloc7raw_vec20RawVecInner$LT$A$GT$7reserve21do_reserve_and_handle17h6d615f432a43e13eE
        (local.get $p0)
        (local.get $l3)
        (local.get $p2)
        (i32.const 1)
        (i32.const 1))
      (local.set $l3
        (i32.load offset=8
          (local.get $p0))))
    (drop
      (call $memcpy
        (i32.add
          (i32.load offset=4
            (local.get $p0))
          (local.get $l3))
        (local.get $p1)
        (local.get $p2)))
    (i32.store offset=8
      (local.get $p0)
      (i32.add
        (local.get $l3)
        (local.get $p2)))
    (i32.const 0))
  (func $_ZN5alloc7raw_vec11finish_grow17hfd102e347a05a36eE (type $t9) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32)
    (block $B0
      (block $B1
        (br_if $B1
          (i32.lt_s
            (local.get $p2)
            (i32.const 0)))
        (block $B2
          (block $B3
            (block $B4
              (br_if $B4
                (i32.eqz
                  (i32.load offset=4
                    (local.get $p3))))
              (block $B5
                (br_if $B5
                  (local.tee $l4
                    (i32.load offset=8
                      (local.get $p3))))
                (block $B6
                  (br_if $B6
                    (local.get $p2))
                  (local.set $p3
                    (local.get $p1))
                  (br $B2))
                (drop
                  (i32.load8_u offset=1049289
                    (i32.const 0)))
                (br $B3))
              (local.set $p3
                (call $__rust_realloc
                  (i32.load
                    (local.get $p3))
                  (local.get $l4)
                  (local.get $p1)
                  (local.get $p2)))
              (br $B2))
            (block $B7
              (br_if $B7
                (local.get $p2))
              (local.set $p3
                (local.get $p1))
              (br $B2))
            (drop
              (i32.load8_u offset=1049289
                (i32.const 0))))
          (local.set $p3
            (call $__rust_alloc
              (local.get $p2)
              (local.get $p1))))
        (block $B8
          (br_if $B8
            (i32.eqz
              (local.get $p3)))
          (i32.store offset=8
            (local.get $p0)
            (local.get $p2))
          (i32.store offset=4
            (local.get $p0)
            (local.get $p3))
          (i32.store
            (local.get $p0)
            (i32.const 0))
          (return))
        (i32.store offset=8
          (local.get $p0)
          (local.get $p2))
        (i32.store offset=4
          (local.get $p0)
          (local.get $p1))
        (br $B0))
      (i32.store offset=4
        (local.get $p0)
        (i32.const 0)))
    (i32.store
      (local.get $p0)
      (i32.const 1)))
  (func $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$12unlink_chunk17h6c7a0664360897f7E (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    (local.set $l2
      (i32.load offset=12
        (local.get $p0)))
    (block $B0
      (block $B1
        (block $B2
          (br_if $B2
            (i32.lt_u
              (local.get $p1)
              (i32.const 256)))
          (local.set $l3
            (i32.load offset=24
              (local.get $p0)))
          (block $B3
            (block $B4
              (block $B5
                (br_if $B5
                  (i32.ne
                    (local.get $l2)
                    (local.get $p0)))
                (br_if $B4
                  (local.tee $p1
                    (i32.load
                      (i32.add
                        (local.get $p0)
                        (select
                          (i32.const 20)
                          (i32.const 16)
                          (local.tee $l2
                            (i32.load offset=20
                              (local.get $p0))))))))
                (local.set $l2
                  (i32.const 0))
                (br $B3))
              (i32.store offset=12
                (local.tee $p1
                  (i32.load offset=8
                    (local.get $p0)))
                (local.get $l2))
              (i32.store offset=8
                (local.get $l2)
                (local.get $p1))
              (br $B3))
            (local.set $l4
              (select
                (i32.add
                  (local.get $p0)
                  (i32.const 20))
                (i32.add
                  (local.get $p0)
                  (i32.const 16))
                (local.get $l2)))
            (loop $L6
              (local.set $l5
                (local.get $l4))
              (local.set $l4
                (select
                  (i32.add
                    (local.tee $l2
                      (local.get $p1))
                    (i32.const 20))
                  (i32.add
                    (local.get $l2)
                    (i32.const 16))
                  (local.tee $p1
                    (i32.load offset=20
                      (local.get $l2)))))
              (br_if $L6
                (local.tee $p1
                  (i32.load
                    (i32.add
                      (local.get $l2)
                      (select
                        (i32.const 20)
                        (i32.const 16)
                        (local.get $p1)))))))
            (i32.store
              (local.get $l5)
              (i32.const 0)))
          (br_if $B0
            (i32.eqz
              (local.get $l3)))
          (block $B7
            (br_if $B7
              (i32.eq
                (i32.load
                  (local.tee $p1
                    (i32.add
                      (i32.shl
                        (i32.load offset=28
                          (local.get $p0))
                        (i32.const 2))
                      (i32.const 1049312))))
                (local.get $p0)))
            (i32.store
              (i32.add
                (local.get $l3)
                (select
                  (i32.const 16)
                  (i32.const 20)
                  (i32.eq
                    (i32.load offset=16
                      (local.get $l3))
                    (local.get $p0))))
              (local.get $l2))
            (br_if $B0
              (i32.eqz
                (local.get $l2)))
            (br $B1))
          (i32.store
            (local.get $p1)
            (local.get $l2))
          (br_if $B1
            (local.get $l2))
          (i32.store offset=1049724
            (i32.const 0)
            (i32.and
              (i32.load offset=1049724
                (i32.const 0))
              (i32.rotl
                (i32.const -2)
                (i32.load offset=28
                  (local.get $p0)))))
          (br $B0))
        (block $B8
          (br_if $B8
            (i32.eq
              (local.get $l2)
              (local.tee $l4
                (i32.load offset=8
                  (local.get $p0)))))
          (i32.store offset=12
            (local.get $l4)
            (local.get $l2))
          (i32.store offset=8
            (local.get $l2)
            (local.get $l4))
          (return))
        (i32.store offset=1049720
          (i32.const 0)
          (i32.and
            (i32.load offset=1049720
              (i32.const 0))
            (i32.rotl
              (i32.const -2)
              (i32.shr_u
                (local.get $p1)
                (i32.const 3)))))
        (return))
      (i32.store offset=24
        (local.get $l2)
        (local.get $l3))
      (block $B9
        (br_if $B9
          (i32.eqz
            (local.tee $p1
              (i32.load offset=16
                (local.get $p0)))))
        (i32.store offset=16
          (local.get $l2)
          (local.get $p1))
        (i32.store offset=24
          (local.get $p1)
          (local.get $l2)))
      (br_if $B0
        (i32.eqz
          (local.tee $p1
            (i32.load offset=20
              (local.get $p0)))))
      (i32.store offset=20
        (local.get $l2)
        (local.get $p1))
      (i32.store offset=24
        (local.get $p1)
        (local.get $l2))
      (return)))
  (func $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$13dispose_chunk17h93817601d12c9b57E (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32)
    (local.set $l2
      (i32.add
        (local.get $p0)
        (local.get $p1)))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.and
            (local.tee $l3
              (i32.load offset=4
                (local.get $p0)))
            (i32.const 1)))
        (br_if $B0
          (i32.eqz
            (i32.and
              (local.get $l3)
              (i32.const 2))))
        (local.set $p1
          (i32.add
            (local.tee $l3
              (i32.load
                (local.get $p0)))
            (local.get $p1)))
        (block $B2
          (br_if $B2
            (i32.ne
              (local.tee $p0
                (i32.sub
                  (local.get $p0)
                  (local.get $l3)))
              (i32.load offset=1049736
                (i32.const 0))))
          (br_if $B1
            (i32.ne
              (i32.and
                (i32.load offset=4
                  (local.get $l2))
                (i32.const 3))
              (i32.const 3)))
          (i32.store offset=1049728
            (i32.const 0)
            (local.get $p1))
          (i32.store offset=4
            (local.get $l2)
            (i32.and
              (i32.load offset=4
                (local.get $l2))
              (i32.const -2)))
          (i32.store offset=4
            (local.get $p0)
            (i32.or
              (local.get $p1)
              (i32.const 1)))
          (i32.store
            (local.get $l2)
            (local.get $p1))
          (br $B0))
        (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$12unlink_chunk17h6c7a0664360897f7E
          (local.get $p0)
          (local.get $l3)))
      (block $B3
        (block $B4
          (block $B5
            (block $B6
              (br_if $B6
                (i32.and
                  (local.tee $l3
                    (i32.load offset=4
                      (local.get $l2)))
                  (i32.const 2)))
              (br_if $B4
                (i32.eq
                  (local.get $l2)
                  (i32.load offset=1049740
                    (i32.const 0))))
              (br_if $B3
                (i32.eq
                  (local.get $l2)
                  (i32.load offset=1049736
                    (i32.const 0))))
              (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$12unlink_chunk17h6c7a0664360897f7E
                (local.get $l2)
                (local.tee $l3
                  (i32.and
                    (local.get $l3)
                    (i32.const -8))))
              (i32.store offset=4
                (local.get $p0)
                (i32.or
                  (local.tee $p1
                    (i32.add
                      (local.get $l3)
                      (local.get $p1)))
                  (i32.const 1)))
              (i32.store
                (i32.add
                  (local.get $p0)
                  (local.get $p1))
                (local.get $p1))
              (br_if $B5
                (i32.ne
                  (local.get $p0)
                  (i32.load offset=1049736
                    (i32.const 0))))
              (i32.store offset=1049728
                (i32.const 0)
                (local.get $p1))
              (return))
            (i32.store offset=4
              (local.get $l2)
              (i32.and
                (local.get $l3)
                (i32.const -2)))
            (i32.store offset=4
              (local.get $p0)
              (i32.or
                (local.get $p1)
                (i32.const 1)))
            (i32.store
              (i32.add
                (local.get $p0)
                (local.get $p1))
              (local.get $p1)))
          (block $B7
            (br_if $B7
              (i32.lt_u
                (local.get $p1)
                (i32.const 256)))
            (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$18insert_large_chunk17h5f84d09c81f6adaaE
              (local.get $p0)
              (local.get $p1))
            (return))
          (local.set $l2
            (i32.add
              (i32.and
                (local.get $p1)
                (i32.const 248))
              (i32.const 1049456)))
          (block $B8
            (block $B9
              (br_if $B9
                (i32.and
                  (local.tee $l3
                    (i32.load offset=1049720
                      (i32.const 0)))
                  (local.tee $p1
                    (i32.shl
                      (i32.const 1)
                      (i32.shr_u
                        (local.get $p1)
                        (i32.const 3))))))
              (i32.store offset=1049720
                (i32.const 0)
                (i32.or
                  (local.get $l3)
                  (local.get $p1)))
              (local.set $p1
                (local.get $l2))
              (br $B8))
            (local.set $p1
              (i32.load offset=8
                (local.get $l2))))
          (i32.store offset=8
            (local.get $l2)
            (local.get $p0))
          (i32.store offset=12
            (local.get $p1)
            (local.get $p0))
          (i32.store offset=12
            (local.get $p0)
            (local.get $l2))
          (i32.store offset=8
            (local.get $p0)
            (local.get $p1))
          (return))
        (i32.store offset=1049740
          (i32.const 0)
          (local.get $p0))
        (i32.store offset=1049732
          (i32.const 0)
          (local.tee $p1
            (i32.add
              (i32.load offset=1049732
                (i32.const 0))
              (local.get $p1))))
        (i32.store offset=4
          (local.get $p0)
          (i32.or
            (local.get $p1)
            (i32.const 1)))
        (br_if $B0
          (i32.ne
            (local.get $p0)
            (i32.load offset=1049736
              (i32.const 0))))
        (i32.store offset=1049728
          (i32.const 0)
          (i32.const 0))
        (i32.store offset=1049736
          (i32.const 0)
          (i32.const 0))
        (return))
      (i32.store offset=1049736
        (i32.const 0)
        (local.get $p0))
      (i32.store offset=1049728
        (i32.const 0)
        (local.tee $p1
          (i32.add
            (i32.load offset=1049728
              (i32.const 0))
            (local.get $p1))))
      (i32.store offset=4
        (local.get $p0)
        (i32.or
          (local.get $p1)
          (i32.const 1)))
      (i32.store
        (i32.add
          (local.get $p0)
          (local.get $p1))
        (local.get $p1))
      (return)))
  (func $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$18insert_large_chunk17h5f84d09c81f6adaaE (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    (local.set $l2
      (i32.const 0))
    (block $B0
      (br_if $B0
        (i32.lt_u
          (local.get $p1)
          (i32.const 256)))
      (local.set $l2
        (i32.const 31))
      (br_if $B0
        (i32.gt_u
          (local.get $p1)
          (i32.const 16777215)))
      (local.set $l2
        (i32.add
          (i32.sub
            (i32.and
              (i32.shr_u
                (local.get $p1)
                (i32.sub
                  (i32.const 6)
                  (local.tee $l2
                    (i32.clz
                      (i32.shr_u
                        (local.get $p1)
                        (i32.const 8))))))
              (i32.const 1))
            (i32.shl
              (local.get $l2)
              (i32.const 1)))
          (i32.const 62))))
    (i64.store offset=16 align=4
      (local.get $p0)
      (i64.const 0))
    (i32.store offset=28
      (local.get $p0)
      (local.get $l2))
    (local.set $l3
      (i32.add
        (i32.shl
          (local.get $l2)
          (i32.const 2))
        (i32.const 1049312)))
    (block $B1
      (br_if $B1
        (i32.and
          (i32.load offset=1049724
            (i32.const 0))
          (local.tee $l4
            (i32.shl
              (i32.const 1)
              (local.get $l2)))))
      (i32.store
        (local.get $l3)
        (local.get $p0))
      (i32.store offset=24
        (local.get $p0)
        (local.get $l3))
      (i32.store offset=12
        (local.get $p0)
        (local.get $p0))
      (i32.store offset=8
        (local.get $p0)
        (local.get $p0))
      (i32.store offset=1049724
        (i32.const 0)
        (i32.or
          (i32.load offset=1049724
            (i32.const 0))
          (local.get $l4)))
      (return))
    (block $B2
      (block $B3
        (block $B4
          (br_if $B4
            (i32.ne
              (i32.and
                (i32.load offset=4
                  (local.tee $l4
                    (i32.load
                      (local.get $l3))))
                (i32.const -8))
              (local.get $p1)))
          (local.set $l2
            (local.get $l4))
          (br $B3))
        (local.set $l3
          (i32.shl
            (local.get $p1)
            (select
              (i32.const 0)
              (i32.sub
                (i32.const 25)
                (i32.shr_u
                  (local.get $l2)
                  (i32.const 1)))
              (i32.eq
                (local.get $l2)
                (i32.const 31)))))
        (loop $L5
          (br_if $B2
            (i32.eqz
              (local.tee $l2
                (i32.load
                  (local.tee $l5
                    (i32.add
                      (i32.add
                        (local.get $l4)
                        (i32.and
                          (i32.shr_u
                            (local.get $l3)
                            (i32.const 29))
                          (i32.const 4)))
                      (i32.const 16)))))))
          (local.set $l3
            (i32.shl
              (local.get $l3)
              (i32.const 1)))
          (local.set $l4
            (local.get $l2))
          (br_if $L5
            (i32.ne
              (i32.and
                (i32.load offset=4
                  (local.get $l2))
                (i32.const -8))
              (local.get $p1)))))
      (i32.store offset=12
        (local.tee $l3
          (i32.load offset=8
            (local.get $l2)))
        (local.get $p0))
      (i32.store offset=8
        (local.get $l2)
        (local.get $p0))
      (i32.store offset=24
        (local.get $p0)
        (i32.const 0))
      (i32.store offset=12
        (local.get $p0)
        (local.get $l2))
      (i32.store offset=8
        (local.get $p0)
        (local.get $l3))
      (return))
    (i32.store
      (local.get $l5)
      (local.get $p0))
    (i32.store offset=24
      (local.get $p0)
      (local.get $l4))
    (i32.store offset=12
      (local.get $p0)
      (local.get $p0))
    (i32.store offset=8
      (local.get $p0)
      (local.get $p0)))
  (func $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$4free17hc3311d3fb11cee48E (type $t3) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    (local.set $l3
      (i32.add
        (local.tee $l1
          (i32.add
            (local.get $p0)
            (i32.const -8)))
        (local.tee $p0
          (i32.and
            (local.tee $l2
              (i32.load
                (i32.add
                  (local.get $p0)
                  (i32.const -4))))
            (i32.const -8)))))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.and
            (local.get $l2)
            (i32.const 1)))
        (br_if $B0
          (i32.eqz
            (i32.and
              (local.get $l2)
              (i32.const 2))))
        (local.set $p0
          (i32.add
            (local.tee $l2
              (i32.load
                (local.get $l1)))
            (local.get $p0)))
        (block $B2
          (br_if $B2
            (i32.ne
              (local.tee $l1
                (i32.sub
                  (local.get $l1)
                  (local.get $l2)))
              (i32.load offset=1049736
                (i32.const 0))))
          (br_if $B1
            (i32.ne
              (i32.and
                (i32.load offset=4
                  (local.get $l3))
                (i32.const 3))
              (i32.const 3)))
          (i32.store offset=1049728
            (i32.const 0)
            (local.get $p0))
          (i32.store offset=4
            (local.get $l3)
            (i32.and
              (i32.load offset=4
                (local.get $l3))
              (i32.const -2)))
          (i32.store offset=4
            (local.get $l1)
            (i32.or
              (local.get $p0)
              (i32.const 1)))
          (i32.store
            (local.get $l3)
            (local.get $p0))
          (return))
        (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$12unlink_chunk17h6c7a0664360897f7E
          (local.get $l1)
          (local.get $l2)))
      (block $B3
        (block $B4
          (block $B5
            (block $B6
              (block $B7
                (block $B8
                  (br_if $B8
                    (i32.and
                      (local.tee $l2
                        (i32.load offset=4
                          (local.get $l3)))
                      (i32.const 2)))
                  (br_if $B6
                    (i32.eq
                      (local.get $l3)
                      (i32.load offset=1049740
                        (i32.const 0))))
                  (br_if $B5
                    (i32.eq
                      (local.get $l3)
                      (i32.load offset=1049736
                        (i32.const 0))))
                  (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$12unlink_chunk17h6c7a0664360897f7E
                    (local.get $l3)
                    (local.tee $l2
                      (i32.and
                        (local.get $l2)
                        (i32.const -8))))
                  (i32.store offset=4
                    (local.get $l1)
                    (i32.or
                      (local.tee $p0
                        (i32.add
                          (local.get $l2)
                          (local.get $p0)))
                      (i32.const 1)))
                  (i32.store
                    (i32.add
                      (local.get $l1)
                      (local.get $p0))
                    (local.get $p0))
                  (br_if $B7
                    (i32.ne
                      (local.get $l1)
                      (i32.load offset=1049736
                        (i32.const 0))))
                  (i32.store offset=1049728
                    (i32.const 0)
                    (local.get $p0))
                  (return))
                (i32.store offset=4
                  (local.get $l3)
                  (i32.and
                    (local.get $l2)
                    (i32.const -2)))
                (i32.store offset=4
                  (local.get $l1)
                  (i32.or
                    (local.get $p0)
                    (i32.const 1)))
                (i32.store
                  (i32.add
                    (local.get $l1)
                    (local.get $p0))
                  (local.get $p0)))
              (br_if $B4
                (i32.lt_u
                  (local.get $p0)
                  (i32.const 256)))
              (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$18insert_large_chunk17h5f84d09c81f6adaaE
                (local.get $l1)
                (local.get $p0))
              (local.set $l1
                (i32.const 0))
              (i32.store offset=1049760
                (i32.const 0)
                (local.tee $p0
                  (i32.add
                    (i32.load offset=1049760
                      (i32.const 0))
                    (i32.const -1))))
              (br_if $B0
                (local.get $p0))
              (block $B9
                (br_if $B9
                  (i32.eqz
                    (local.tee $p0
                      (i32.load offset=1049448
                        (i32.const 0)))))
                (local.set $l1
                  (i32.const 0))
                (loop $L10
                  (local.set $l1
                    (i32.add
                      (local.get $l1)
                      (i32.const 1)))
                  (br_if $L10
                    (local.tee $p0
                      (i32.load offset=8
                        (local.get $p0))))))
              (i32.store offset=1049760
                (i32.const 0)
                (select
                  (local.get $l1)
                  (i32.const 4095)
                  (i32.gt_u
                    (local.get $l1)
                    (i32.const 4095))))
              (return))
            (i32.store offset=1049740
              (i32.const 0)
              (local.get $l1))
            (i32.store offset=1049732
              (i32.const 0)
              (local.tee $p0
                (i32.add
                  (i32.load offset=1049732
                    (i32.const 0))
                  (local.get $p0))))
            (i32.store offset=4
              (local.get $l1)
              (i32.or
                (local.get $p0)
                (i32.const 1)))
            (block $B11
              (br_if $B11
                (i32.ne
                  (local.get $l1)
                  (i32.load offset=1049736
                    (i32.const 0))))
              (i32.store offset=1049728
                (i32.const 0)
                (i32.const 0))
              (i32.store offset=1049736
                (i32.const 0)
                (i32.const 0)))
            (br_if $B0
              (i32.le_u
                (local.get $p0)
                (local.tee $l4
                  (i32.load offset=1049752
                    (i32.const 0)))))
            (br_if $B0
              (i32.eqz
                (local.tee $p0
                  (i32.load offset=1049740
                    (i32.const 0)))))
            (local.set $l2
              (i32.const 0))
            (br_if $B3
              (i32.lt_u
                (local.tee $l5
                  (i32.load offset=1049732
                    (i32.const 0)))
                (i32.const 41)))
            (local.set $l1
              (i32.const 1049440))
            (loop $L12
              (block $B13
                (br_if $B13
                  (i32.gt_u
                    (local.tee $l3
                      (i32.load
                        (local.get $l1)))
                    (local.get $p0)))
                (br_if $B3
                  (i32.lt_u
                    (local.get $p0)
                    (i32.add
                      (local.get $l3)
                      (i32.load offset=4
                        (local.get $l1))))))
              (local.set $l1
                (i32.load offset=8
                  (local.get $l1)))
              (br $L12)))
          (i32.store offset=1049736
            (i32.const 0)
            (local.get $l1))
          (i32.store offset=1049728
            (i32.const 0)
            (local.tee $p0
              (i32.add
                (i32.load offset=1049728
                  (i32.const 0))
                (local.get $p0))))
          (i32.store offset=4
            (local.get $l1)
            (i32.or
              (local.get $p0)
              (i32.const 1)))
          (i32.store
            (i32.add
              (local.get $l1)
              (local.get $p0))
            (local.get $p0))
          (return))
        (local.set $l3
          (i32.add
            (i32.and
              (local.get $p0)
              (i32.const 248))
            (i32.const 1049456)))
        (block $B14
          (block $B15
            (br_if $B15
              (i32.and
                (local.tee $l2
                  (i32.load offset=1049720
                    (i32.const 0)))
                (local.tee $p0
                  (i32.shl
                    (i32.const 1)
                    (i32.shr_u
                      (local.get $p0)
                      (i32.const 3))))))
            (i32.store offset=1049720
              (i32.const 0)
              (i32.or
                (local.get $l2)
                (local.get $p0)))
            (local.set $p0
              (local.get $l3))
            (br $B14))
          (local.set $p0
            (i32.load offset=8
              (local.get $l3))))
        (i32.store offset=8
          (local.get $l3)
          (local.get $l1))
        (i32.store offset=12
          (local.get $p0)
          (local.get $l1))
        (i32.store offset=12
          (local.get $l1)
          (local.get $l3))
        (i32.store offset=8
          (local.get $l1)
          (local.get $p0))
        (return))
      (block $B16
        (br_if $B16
          (i32.eqz
            (local.tee $l1
              (i32.load offset=1049448
                (i32.const 0)))))
        (local.set $l2
          (i32.const 0))
        (loop $L17
          (local.set $l2
            (i32.add
              (local.get $l2)
              (i32.const 1)))
          (br_if $L17
            (local.tee $l1
              (i32.load offset=8
                (local.get $l1))))))
      (i32.store offset=1049760
        (i32.const 0)
        (select
          (local.get $l2)
          (i32.const 4095)
          (i32.gt_u
            (local.get $l2)
            (i32.const 4095))))
      (br_if $B0
        (i32.le_u
          (local.get $l5)
          (local.get $l4)))
      (i32.store offset=1049752
        (i32.const 0)
        (i32.const -1))))
  (func $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$6malloc17hb720925448de7b1dE (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i64)
    (global.set $__stack_pointer
      (local.tee $l1
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (block $B0
      (block $B1
        (block $B2
          (block $B3
            (block $B4
              (block $B5
                (block $B6
                  (block $B7
                    (br_if $B7
                      (i32.lt_u
                        (local.get $p0)
                        (i32.const 245)))
                    (block $B8
                      (br_if $B8
                        (i32.lt_u
                          (local.get $p0)
                          (i32.const -65587)))
                      (local.set $p0
                        (i32.const 0))
                      (br $B0))
                    (local.set $l3
                      (i32.and
                        (local.tee $l2
                          (i32.add
                            (local.get $p0)
                            (i32.const 11)))
                        (i32.const -8)))
                    (br_if $B3
                      (i32.eqz
                        (local.tee $l4
                          (i32.load offset=1049724
                            (i32.const 0)))))
                    (local.set $l5
                      (i32.const 31))
                    (block $B9
                      (br_if $B9
                        (i32.gt_u
                          (local.get $p0)
                          (i32.const 16777204)))
                      (local.set $l5
                        (i32.add
                          (i32.sub
                            (i32.and
                              (i32.shr_u
                                (local.get $l3)
                                (i32.sub
                                  (i32.const 6)
                                  (local.tee $p0
                                    (i32.clz
                                      (i32.shr_u
                                        (local.get $l2)
                                        (i32.const 8))))))
                              (i32.const 1))
                            (i32.shl
                              (local.get $p0)
                              (i32.const 1)))
                          (i32.const 62))))
                    (local.set $l2
                      (i32.sub
                        (i32.const 0)
                        (local.get $l3)))
                    (block $B10
                      (br_if $B10
                        (local.tee $l6
                          (i32.load
                            (i32.add
                              (i32.shl
                                (local.get $l5)
                                (i32.const 2))
                              (i32.const 1049312)))))
                      (local.set $p0
                        (i32.const 0))
                      (local.set $l7
                        (i32.const 0))
                      (br $B6))
                    (local.set $p0
                      (i32.const 0))
                    (local.set $l8
                      (i32.shl
                        (local.get $l3)
                        (select
                          (i32.const 0)
                          (i32.sub
                            (i32.const 25)
                            (i32.shr_u
                              (local.get $l5)
                              (i32.const 1)))
                          (i32.eq
                            (local.get $l5)
                            (i32.const 31)))))
                    (local.set $l7
                      (i32.const 0))
                    (loop $L11
                      (block $B12
                        (br_if $B12
                          (i32.lt_u
                            (local.tee $l9
                              (i32.and
                                (i32.load offset=4
                                  (local.tee $l6
                                    (local.get $l6)))
                                (i32.const -8)))
                            (local.get $l3)))
                        (br_if $B12
                          (i32.ge_u
                            (local.tee $l9
                              (i32.sub
                                (local.get $l9)
                                (local.get $l3)))
                            (local.get $l2)))
                        (local.set $l2
                          (local.get $l9))
                        (local.set $l7
                          (local.get $l6))
                        (br_if $B12
                          (local.get $l9))
                        (local.set $l2
                          (i32.const 0))
                        (local.set $l7
                          (local.get $l6))
                        (local.set $p0
                          (local.get $l6))
                        (br $B5))
                      (local.set $p0
                        (select
                          (select
                            (local.tee $l9
                              (i32.load offset=20
                                (local.get $l6)))
                            (local.get $p0)
                            (i32.ne
                              (local.get $l9)
                              (local.tee $l6
                                (i32.load
                                  (i32.add
                                    (i32.add
                                      (local.get $l6)
                                      (i32.and
                                        (i32.shr_u
                                          (local.get $l8)
                                          (i32.const 29))
                                        (i32.const 4)))
                                    (i32.const 16))))))
                          (local.get $p0)
                          (local.get $l9)))
                      (local.set $l8
                        (i32.shl
                          (local.get $l8)
                          (i32.const 1)))
                      (br_if $B6
                        (i32.eqz
                          (local.get $l6)))
                      (br $L11)))
                  (block $B13
                    (br_if $B13
                      (i32.eqz
                        (i32.and
                          (local.tee $p0
                            (i32.shr_u
                              (local.tee $l6
                                (i32.load offset=1049720
                                  (i32.const 0)))
                              (local.tee $l2
                                (i32.shr_u
                                  (local.tee $l3
                                    (select
                                      (i32.const 16)
                                      (i32.and
                                        (i32.add
                                          (local.get $p0)
                                          (i32.const 11))
                                        (i32.const 504))
                                      (i32.lt_u
                                        (local.get $p0)
                                        (i32.const 11))))
                                  (i32.const 3)))))
                          (i32.const 3))))
                    (block $B14
                      (block $B15
                        (br_if $B15
                          (i32.eq
                            (local.tee $p0
                              (i32.add
                                (local.tee $l3
                                  (i32.shl
                                    (local.tee $l8
                                      (i32.add
                                        (i32.and
                                          (i32.xor
                                            (local.get $p0)
                                            (i32.const -1))
                                          (i32.const 1))
                                        (local.get $l2)))
                                    (i32.const 3)))
                                (i32.const 1049456)))
                            (local.tee $l7
                              (i32.load offset=8
                                (local.tee $l2
                                  (i32.load
                                    (i32.add
                                      (local.get $l3)
                                      (i32.const 1049464))))))))
                        (i32.store offset=12
                          (local.get $l7)
                          (local.get $p0))
                        (i32.store offset=8
                          (local.get $p0)
                          (local.get $l7))
                        (br $B14))
                      (i32.store offset=1049720
                        (i32.const 0)
                        (i32.and
                          (local.get $l6)
                          (i32.rotl
                            (i32.const -2)
                            (local.get $l8)))))
                    (local.set $p0
                      (i32.add
                        (local.get $l2)
                        (i32.const 8)))
                    (i32.store offset=4
                      (local.get $l2)
                      (i32.or
                        (local.get $l3)
                        (i32.const 3)))
                    (i32.store offset=4
                      (local.tee $l3
                        (i32.add
                          (local.get $l2)
                          (local.get $l3)))
                      (i32.or
                        (i32.load offset=4
                          (local.get $l3))
                        (i32.const 1)))
                    (br $B0))
                  (br_if $B3
                    (i32.le_u
                      (local.get $l3)
                      (i32.load offset=1049728
                        (i32.const 0))))
                  (block $B16
                    (block $B17
                      (block $B18
                        (br_if $B18
                          (local.get $p0))
                        (br_if $B3
                          (i32.eqz
                            (local.tee $p0
                              (i32.load offset=1049724
                                (i32.const 0)))))
                        (local.set $l2
                          (i32.sub
                            (i32.and
                              (i32.load offset=4
                                (local.tee $l7
                                  (i32.load
                                    (i32.add
                                      (i32.shl
                                        (i32.ctz
                                          (local.get $p0))
                                        (i32.const 2))
                                      (i32.const 1049312)))))
                              (i32.const -8))
                            (local.get $l3)))
                        (local.set $l6
                          (local.get $l7))
                        (loop $L19
                          (block $B20
                            (br_if $B20
                              (local.tee $p0
                                (i32.load offset=16
                                  (local.get $l7))))
                            (br_if $B20
                              (local.tee $p0
                                (i32.load offset=20
                                  (local.get $l7))))
                            (local.set $l5
                              (i32.load offset=24
                                (local.get $l6)))
                            (block $B21
                              (block $B22
                                (block $B23
                                  (br_if $B23
                                    (i32.ne
                                      (local.tee $p0
                                        (i32.load offset=12
                                          (local.get $l6)))
                                      (local.get $l6)))
                                  (br_if $B22
                                    (local.tee $l7
                                      (i32.load
                                        (i32.add
                                          (local.get $l6)
                                          (select
                                            (i32.const 20)
                                            (i32.const 16)
                                            (local.tee $p0
                                              (i32.load offset=20
                                                (local.get $l6))))))))
                                  (local.set $p0
                                    (i32.const 0))
                                  (br $B21))
                                (i32.store offset=12
                                  (local.tee $l7
                                    (i32.load offset=8
                                      (local.get $l6)))
                                  (local.get $p0))
                                (i32.store offset=8
                                  (local.get $p0)
                                  (local.get $l7))
                                (br $B21))
                              (local.set $l8
                                (select
                                  (i32.add
                                    (local.get $l6)
                                    (i32.const 20))
                                  (i32.add
                                    (local.get $l6)
                                    (i32.const 16))
                                  (local.get $p0)))
                              (loop $L24
                                (local.set $l9
                                  (local.get $l8))
                                (local.set $l8
                                  (select
                                    (i32.add
                                      (local.tee $p0
                                        (local.get $l7))
                                      (i32.const 20))
                                    (i32.add
                                      (local.get $p0)
                                      (i32.const 16))
                                    (local.tee $l7
                                      (i32.load offset=20
                                        (local.get $p0)))))
                                (br_if $L24
                                  (local.tee $l7
                                    (i32.load
                                      (i32.add
                                        (local.get $p0)
                                        (select
                                          (i32.const 20)
                                          (i32.const 16)
                                          (local.get $l7)))))))
                              (i32.store
                                (local.get $l9)
                                (i32.const 0)))
                            (br_if $B16
                              (i32.eqz
                                (local.get $l5)))
                            (block $B25
                              (br_if $B25
                                (i32.eq
                                  (i32.load
                                    (local.tee $l7
                                      (i32.add
                                        (i32.shl
                                          (i32.load offset=28
                                            (local.get $l6))
                                          (i32.const 2))
                                        (i32.const 1049312))))
                                  (local.get $l6)))
                              (i32.store
                                (i32.add
                                  (local.get $l5)
                                  (select
                                    (i32.const 16)
                                    (i32.const 20)
                                    (i32.eq
                                      (i32.load offset=16
                                        (local.get $l5))
                                      (local.get $l6))))
                                (local.get $p0))
                              (br_if $B16
                                (i32.eqz
                                  (local.get $p0)))
                              (br $B17))
                            (i32.store
                              (local.get $l7)
                              (local.get $p0))
                            (br_if $B17
                              (local.get $p0))
                            (i32.store offset=1049724
                              (i32.const 0)
                              (i32.and
                                (i32.load offset=1049724
                                  (i32.const 0))
                                (i32.rotl
                                  (i32.const -2)
                                  (i32.load offset=28
                                    (local.get $l6)))))
                            (br $B16))
                          (local.set $l2
                            (select
                              (local.tee $l7
                                (i32.sub
                                  (i32.and
                                    (i32.load offset=4
                                      (local.get $p0))
                                    (i32.const -8))
                                  (local.get $l3)))
                              (local.get $l2)
                              (local.tee $l7
                                (i32.lt_u
                                  (local.get $l7)
                                  (local.get $l2)))))
                          (local.set $l6
                            (select
                              (local.get $p0)
                              (local.get $l6)
                              (local.get $l7)))
                          (local.set $l7
                            (local.get $p0))
                          (br $L19)))
                      (block $B26
                        (block $B27
                          (br_if $B27
                            (i32.eq
                              (local.tee $l7
                                (i32.add
                                  (local.tee $l2
                                    (i32.shl
                                      (local.tee $l9
                                        (i32.ctz
                                          (i32.and
                                            (i32.shl
                                              (local.get $p0)
                                              (local.get $l2))
                                            (i32.or
                                              (local.tee $p0
                                                (i32.shl
                                                  (i32.const 2)
                                                  (local.get $l2)))
                                              (i32.sub
                                                (i32.const 0)
                                                (local.get $p0))))))
                                      (i32.const 3)))
                                  (i32.const 1049456)))
                              (local.tee $l8
                                (i32.load offset=8
                                  (local.tee $p0
                                    (i32.load
                                      (i32.add
                                        (local.get $l2)
                                        (i32.const 1049464))))))))
                          (i32.store offset=12
                            (local.get $l8)
                            (local.get $l7))
                          (i32.store offset=8
                            (local.get $l7)
                            (local.get $l8))
                          (br $B26))
                        (i32.store offset=1049720
                          (i32.const 0)
                          (i32.and
                            (local.get $l6)
                            (i32.rotl
                              (i32.const -2)
                              (local.get $l9)))))
                      (i32.store offset=4
                        (local.get $p0)
                        (i32.or
                          (local.get $l3)
                          (i32.const 3)))
                      (i32.store offset=4
                        (local.tee $l8
                          (i32.add
                            (local.get $p0)
                            (local.get $l3)))
                        (i32.or
                          (local.tee $l7
                            (i32.sub
                              (local.get $l2)
                              (local.get $l3)))
                          (i32.const 1)))
                      (i32.store
                        (i32.add
                          (local.get $p0)
                          (local.get $l2))
                        (local.get $l7))
                      (block $B28
                        (br_if $B28
                          (i32.eqz
                            (local.tee $l6
                              (i32.load offset=1049728
                                (i32.const 0)))))
                        (local.set $l2
                          (i32.add
                            (i32.and
                              (local.get $l6)
                              (i32.const -8))
                            (i32.const 1049456)))
                        (local.set $l3
                          (i32.load offset=1049736
                            (i32.const 0)))
                        (block $B29
                          (block $B30
                            (br_if $B30
                              (i32.and
                                (local.tee $l9
                                  (i32.load offset=1049720
                                    (i32.const 0)))
                                (local.tee $l6
                                  (i32.shl
                                    (i32.const 1)
                                    (i32.shr_u
                                      (local.get $l6)
                                      (i32.const 3))))))
                            (i32.store offset=1049720
                              (i32.const 0)
                              (i32.or
                                (local.get $l9)
                                (local.get $l6)))
                            (local.set $l6
                              (local.get $l2))
                            (br $B29))
                          (local.set $l6
                            (i32.load offset=8
                              (local.get $l2))))
                        (i32.store offset=8
                          (local.get $l2)
                          (local.get $l3))
                        (i32.store offset=12
                          (local.get $l6)
                          (local.get $l3))
                        (i32.store offset=12
                          (local.get $l3)
                          (local.get $l2))
                        (i32.store offset=8
                          (local.get $l3)
                          (local.get $l6)))
                      (local.set $p0
                        (i32.add
                          (local.get $p0)
                          (i32.const 8)))
                      (i32.store offset=1049736
                        (i32.const 0)
                        (local.get $l8))
                      (i32.store offset=1049728
                        (i32.const 0)
                        (local.get $l7))
                      (br $B0))
                    (i32.store offset=24
                      (local.get $p0)
                      (local.get $l5))
                    (block $B31
                      (br_if $B31
                        (i32.eqz
                          (local.tee $l7
                            (i32.load offset=16
                              (local.get $l6)))))
                      (i32.store offset=16
                        (local.get $p0)
                        (local.get $l7))
                      (i32.store offset=24
                        (local.get $l7)
                        (local.get $p0)))
                    (br_if $B16
                      (i32.eqz
                        (local.tee $l7
                          (i32.load offset=20
                            (local.get $l6)))))
                    (i32.store offset=20
                      (local.get $p0)
                      (local.get $l7))
                    (i32.store offset=24
                      (local.get $l7)
                      (local.get $p0)))
                  (block $B32
                    (block $B33
                      (block $B34
                        (br_if $B34
                          (i32.lt_u
                            (local.get $l2)
                            (i32.const 16)))
                        (i32.store offset=4
                          (local.get $l6)
                          (i32.or
                            (local.get $l3)
                            (i32.const 3)))
                        (i32.store offset=4
                          (local.tee $l3
                            (i32.add
                              (local.get $l6)
                              (local.get $l3)))
                          (i32.or
                            (local.get $l2)
                            (i32.const 1)))
                        (i32.store
                          (i32.add
                            (local.get $l3)
                            (local.get $l2))
                          (local.get $l2))
                        (br_if $B33
                          (i32.eqz
                            (local.tee $l8
                              (i32.load offset=1049728
                                (i32.const 0)))))
                        (local.set $l7
                          (i32.add
                            (i32.and
                              (local.get $l8)
                              (i32.const -8))
                            (i32.const 1049456)))
                        (local.set $p0
                          (i32.load offset=1049736
                            (i32.const 0)))
                        (block $B35
                          (block $B36
                            (br_if $B36
                              (i32.and
                                (local.tee $l9
                                  (i32.load offset=1049720
                                    (i32.const 0)))
                                (local.tee $l8
                                  (i32.shl
                                    (i32.const 1)
                                    (i32.shr_u
                                      (local.get $l8)
                                      (i32.const 3))))))
                            (i32.store offset=1049720
                              (i32.const 0)
                              (i32.or
                                (local.get $l9)
                                (local.get $l8)))
                            (local.set $l8
                              (local.get $l7))
                            (br $B35))
                          (local.set $l8
                            (i32.load offset=8
                              (local.get $l7))))
                        (i32.store offset=8
                          (local.get $l7)
                          (local.get $p0))
                        (i32.store offset=12
                          (local.get $l8)
                          (local.get $p0))
                        (i32.store offset=12
                          (local.get $p0)
                          (local.get $l7))
                        (i32.store offset=8
                          (local.get $p0)
                          (local.get $l8))
                        (br $B33))
                      (i32.store offset=4
                        (local.get $l6)
                        (i32.or
                          (local.tee $p0
                            (i32.add
                              (local.get $l2)
                              (local.get $l3)))
                          (i32.const 3)))
                      (i32.store offset=4
                        (local.tee $p0
                          (i32.add
                            (local.get $l6)
                            (local.get $p0)))
                        (i32.or
                          (i32.load offset=4
                            (local.get $p0))
                          (i32.const 1)))
                      (br $B32))
                    (i32.store offset=1049736
                      (i32.const 0)
                      (local.get $l3))
                    (i32.store offset=1049728
                      (i32.const 0)
                      (local.get $l2)))
                  (local.set $p0
                    (i32.add
                      (local.get $l6)
                      (i32.const 8)))
                  (br $B0))
                (block $B37
                  (br_if $B37
                    (i32.or
                      (local.get $p0)
                      (local.get $l7)))
                  (local.set $l7
                    (i32.const 0))
                  (br_if $B3
                    (i32.eqz
                      (local.tee $p0
                        (i32.and
                          (i32.or
                            (local.tee $p0
                              (i32.shl
                                (i32.const 2)
                                (local.get $l5)))
                            (i32.sub
                              (i32.const 0)
                              (local.get $p0)))
                          (local.get $l4)))))
                  (local.set $p0
                    (i32.load
                      (i32.add
                        (i32.shl
                          (i32.ctz
                            (local.get $p0))
                          (i32.const 2))
                        (i32.const 1049312)))))
                (br_if $B4
                  (i32.eqz
                    (local.get $p0))))
              (loop $L38
                (local.set $l4
                  (select
                    (local.get $p0)
                    (local.get $l7)
                    (local.tee $l5
                      (i32.lt_u
                        (local.tee $l9
                          (i32.sub
                            (local.tee $l6
                              (i32.and
                                (i32.load offset=4
                                  (local.get $p0))
                                (i32.const -8)))
                            (local.get $l3)))
                        (local.get $l2)))))
                (local.set $l8
                  (i32.lt_u
                    (local.get $l6)
                    (local.get $l3)))
                (local.set $l9
                  (select
                    (local.get $l9)
                    (local.get $l2)
                    (local.get $l5)))
                (block $B39
                  (br_if $B39
                    (local.tee $l6
                      (i32.load offset=16
                        (local.get $p0))))
                  (local.set $l6
                    (i32.load offset=20
                      (local.get $p0))))
                (local.set $l7
                  (select
                    (local.get $l7)
                    (local.get $l4)
                    (local.get $l8)))
                (local.set $l2
                  (select
                    (local.get $l2)
                    (local.get $l9)
                    (local.get $l8)))
                (local.set $p0
                  (local.get $l6))
                (br_if $L38
                  (local.get $l6))))
            (br_if $B3
              (i32.eqz
                (local.get $l7)))
            (block $B40
              (br_if $B40
                (i32.lt_u
                  (local.tee $p0
                    (i32.load offset=1049728
                      (i32.const 0)))
                  (local.get $l3)))
              (br_if $B3
                (i32.ge_u
                  (local.get $l2)
                  (i32.sub
                    (local.get $p0)
                    (local.get $l3)))))
            (local.set $l5
              (i32.load offset=24
                (local.get $l7)))
            (block $B41
              (block $B42
                (block $B43
                  (br_if $B43
                    (i32.ne
                      (local.tee $p0
                        (i32.load offset=12
                          (local.get $l7)))
                      (local.get $l7)))
                  (br_if $B42
                    (local.tee $l6
                      (i32.load
                        (i32.add
                          (local.get $l7)
                          (select
                            (i32.const 20)
                            (i32.const 16)
                            (local.tee $p0
                              (i32.load offset=20
                                (local.get $l7))))))))
                  (local.set $p0
                    (i32.const 0))
                  (br $B41))
                (i32.store offset=12
                  (local.tee $l6
                    (i32.load offset=8
                      (local.get $l7)))
                  (local.get $p0))
                (i32.store offset=8
                  (local.get $p0)
                  (local.get $l6))
                (br $B41))
              (local.set $l8
                (select
                  (i32.add
                    (local.get $l7)
                    (i32.const 20))
                  (i32.add
                    (local.get $l7)
                    (i32.const 16))
                  (local.get $p0)))
              (loop $L44
                (local.set $l9
                  (local.get $l8))
                (local.set $l8
                  (select
                    (i32.add
                      (local.tee $p0
                        (local.get $l6))
                      (i32.const 20))
                    (i32.add
                      (local.get $p0)
                      (i32.const 16))
                    (local.tee $l6
                      (i32.load offset=20
                        (local.get $p0)))))
                (br_if $L44
                  (local.tee $l6
                    (i32.load
                      (i32.add
                        (local.get $p0)
                        (select
                          (i32.const 20)
                          (i32.const 16)
                          (local.get $l6)))))))
              (i32.store
                (local.get $l9)
                (i32.const 0)))
            (br_if $B1
              (i32.eqz
                (local.get $l5)))
            (block $B45
              (br_if $B45
                (i32.eq
                  (i32.load
                    (local.tee $l6
                      (i32.add
                        (i32.shl
                          (i32.load offset=28
                            (local.get $l7))
                          (i32.const 2))
                        (i32.const 1049312))))
                  (local.get $l7)))
              (i32.store
                (i32.add
                  (local.get $l5)
                  (select
                    (i32.const 16)
                    (i32.const 20)
                    (i32.eq
                      (i32.load offset=16
                        (local.get $l5))
                      (local.get $l7))))
                (local.get $p0))
              (br_if $B1
                (i32.eqz
                  (local.get $p0)))
              (br $B2))
            (i32.store
              (local.get $l6)
              (local.get $p0))
            (br_if $B2
              (local.get $p0))
            (i32.store offset=1049724
              (i32.const 0)
              (i32.and
                (i32.load offset=1049724
                  (i32.const 0))
                (i32.rotl
                  (i32.const -2)
                  (i32.load offset=28
                    (local.get $l7)))))
            (br $B1))
          (block $B46
            (block $B47
              (block $B48
                (block $B49
                  (block $B50
                    (block $B51
                      (br_if $B51
                        (i32.ge_u
                          (local.tee $p0
                            (i32.load offset=1049728
                              (i32.const 0)))
                          (local.get $l3)))
                      (block $B52
                        (br_if $B52
                          (i32.gt_u
                            (local.tee $p0
                              (i32.load offset=1049732
                                (i32.const 0)))
                            (local.get $l3)))
                        (call $_ZN61_$LT$dlmalloc..sys..System$u20$as$u20$dlmalloc..Allocator$GT$5alloc17hf5fdd2c850785749E
                          (i32.add
                            (local.get $l1)
                            (i32.const 4))
                          (i32.const 1049764)
                          (i32.and
                            (i32.add
                              (local.get $l3)
                              (i32.const 65583))
                            (i32.const -65536)))
                        (block $B53
                          (br_if $B53
                            (local.tee $l6
                              (i32.load offset=4
                                (local.get $l1))))
                          (local.set $p0
                            (i32.const 0))
                          (br $B0))
                        (local.set $l5
                          (i32.load offset=12
                            (local.get $l1)))
                        (i32.store offset=1049744
                          (i32.const 0)
                          (local.tee $p0
                            (i32.add
                              (i32.load offset=1049744
                                (i32.const 0))
                              (local.tee $l9
                                (i32.load offset=8
                                  (local.get $l1))))))
                        (i32.store offset=1049748
                          (i32.const 0)
                          (select
                            (local.tee $l2
                              (i32.load offset=1049748
                                (i32.const 0)))
                            (local.get $p0)
                            (i32.gt_u
                              (local.get $l2)
                              (local.get $p0))))
                        (block $B54
                          (block $B55
                            (block $B56
                              (br_if $B56
                                (i32.eqz
                                  (local.tee $l2
                                    (i32.load offset=1049740
                                      (i32.const 0)))))
                              (local.set $p0
                                (i32.const 1049440))
                              (loop $L57
                                (br_if $B55
                                  (i32.eq
                                    (local.get $l6)
                                    (i32.add
                                      (local.tee $l7
                                        (i32.load
                                          (local.get $p0)))
                                      (local.tee $l8
                                        (i32.load offset=4
                                          (local.get $p0))))))
                                (br_if $L57
                                  (local.tee $p0
                                    (i32.load offset=8
                                      (local.get $p0))))
                                (br $B54)))
                            (block $B58
                              (block $B59
                                (br_if $B59
                                  (i32.eqz
                                    (local.tee $p0
                                      (i32.load offset=1049756
                                        (i32.const 0)))))
                                (br_if $B58
                                  (i32.ge_u
                                    (local.get $l6)
                                    (local.get $p0))))
                              (i32.store offset=1049756
                                (i32.const 0)
                                (local.get $l6)))
                            (i32.store offset=1049760
                              (i32.const 0)
                              (i32.const 4095))
                            (i32.store offset=1049452
                              (i32.const 0)
                              (local.get $l5))
                            (i32.store offset=1049444
                              (i32.const 0)
                              (local.get $l9))
                            (i32.store offset=1049440
                              (i32.const 0)
                              (local.get $l6))
                            (i32.store offset=1049468
                              (i32.const 0)
                              (i32.const 1049456))
                            (i32.store offset=1049476
                              (i32.const 0)
                              (i32.const 1049464))
                            (i32.store offset=1049464
                              (i32.const 0)
                              (i32.const 1049456))
                            (i32.store offset=1049484
                              (i32.const 0)
                              (i32.const 1049472))
                            (i32.store offset=1049472
                              (i32.const 0)
                              (i32.const 1049464))
                            (i32.store offset=1049492
                              (i32.const 0)
                              (i32.const 1049480))
                            (i32.store offset=1049480
                              (i32.const 0)
                              (i32.const 1049472))
                            (i32.store offset=1049500
                              (i32.const 0)
                              (i32.const 1049488))
                            (i32.store offset=1049488
                              (i32.const 0)
                              (i32.const 1049480))
                            (i32.store offset=1049508
                              (i32.const 0)
                              (i32.const 1049496))
                            (i32.store offset=1049496
                              (i32.const 0)
                              (i32.const 1049488))
                            (i32.store offset=1049516
                              (i32.const 0)
                              (i32.const 1049504))
                            (i32.store offset=1049504
                              (i32.const 0)
                              (i32.const 1049496))
                            (i32.store offset=1049524
                              (i32.const 0)
                              (i32.const 1049512))
                            (i32.store offset=1049512
                              (i32.const 0)
                              (i32.const 1049504))
                            (i32.store offset=1049532
                              (i32.const 0)
                              (i32.const 1049520))
                            (i32.store offset=1049520
                              (i32.const 0)
                              (i32.const 1049512))
                            (i32.store offset=1049528
                              (i32.const 0)
                              (i32.const 1049520))
                            (i32.store offset=1049540
                              (i32.const 0)
                              (i32.const 1049528))
                            (i32.store offset=1049536
                              (i32.const 0)
                              (i32.const 1049528))
                            (i32.store offset=1049548
                              (i32.const 0)
                              (i32.const 1049536))
                            (i32.store offset=1049544
                              (i32.const 0)
                              (i32.const 1049536))
                            (i32.store offset=1049556
                              (i32.const 0)
                              (i32.const 1049544))
                            (i32.store offset=1049552
                              (i32.const 0)
                              (i32.const 1049544))
                            (i32.store offset=1049564
                              (i32.const 0)
                              (i32.const 1049552))
                            (i32.store offset=1049560
                              (i32.const 0)
                              (i32.const 1049552))
                            (i32.store offset=1049572
                              (i32.const 0)
                              (i32.const 1049560))
                            (i32.store offset=1049568
                              (i32.const 0)
                              (i32.const 1049560))
                            (i32.store offset=1049580
                              (i32.const 0)
                              (i32.const 1049568))
                            (i32.store offset=1049576
                              (i32.const 0)
                              (i32.const 1049568))
                            (i32.store offset=1049588
                              (i32.const 0)
                              (i32.const 1049576))
                            (i32.store offset=1049584
                              (i32.const 0)
                              (i32.const 1049576))
                            (i32.store offset=1049596
                              (i32.const 0)
                              (i32.const 1049584))
                            (i32.store offset=1049604
                              (i32.const 0)
                              (i32.const 1049592))
                            (i32.store offset=1049592
                              (i32.const 0)
                              (i32.const 1049584))
                            (i32.store offset=1049612
                              (i32.const 0)
                              (i32.const 1049600))
                            (i32.store offset=1049600
                              (i32.const 0)
                              (i32.const 1049592))
                            (i32.store offset=1049620
                              (i32.const 0)
                              (i32.const 1049608))
                            (i32.store offset=1049608
                              (i32.const 0)
                              (i32.const 1049600))
                            (i32.store offset=1049628
                              (i32.const 0)
                              (i32.const 1049616))
                            (i32.store offset=1049616
                              (i32.const 0)
                              (i32.const 1049608))
                            (i32.store offset=1049636
                              (i32.const 0)
                              (i32.const 1049624))
                            (i32.store offset=1049624
                              (i32.const 0)
                              (i32.const 1049616))
                            (i32.store offset=1049644
                              (i32.const 0)
                              (i32.const 1049632))
                            (i32.store offset=1049632
                              (i32.const 0)
                              (i32.const 1049624))
                            (i32.store offset=1049652
                              (i32.const 0)
                              (i32.const 1049640))
                            (i32.store offset=1049640
                              (i32.const 0)
                              (i32.const 1049632))
                            (i32.store offset=1049660
                              (i32.const 0)
                              (i32.const 1049648))
                            (i32.store offset=1049648
                              (i32.const 0)
                              (i32.const 1049640))
                            (i32.store offset=1049668
                              (i32.const 0)
                              (i32.const 1049656))
                            (i32.store offset=1049656
                              (i32.const 0)
                              (i32.const 1049648))
                            (i32.store offset=1049676
                              (i32.const 0)
                              (i32.const 1049664))
                            (i32.store offset=1049664
                              (i32.const 0)
                              (i32.const 1049656))
                            (i32.store offset=1049684
                              (i32.const 0)
                              (i32.const 1049672))
                            (i32.store offset=1049672
                              (i32.const 0)
                              (i32.const 1049664))
                            (i32.store offset=1049692
                              (i32.const 0)
                              (i32.const 1049680))
                            (i32.store offset=1049680
                              (i32.const 0)
                              (i32.const 1049672))
                            (i32.store offset=1049700
                              (i32.const 0)
                              (i32.const 1049688))
                            (i32.store offset=1049688
                              (i32.const 0)
                              (i32.const 1049680))
                            (i32.store offset=1049708
                              (i32.const 0)
                              (i32.const 1049696))
                            (i32.store offset=1049696
                              (i32.const 0)
                              (i32.const 1049688))
                            (i32.store offset=1049716
                              (i32.const 0)
                              (i32.const 1049704))
                            (i32.store offset=1049704
                              (i32.const 0)
                              (i32.const 1049696))
                            (i32.store offset=1049740
                              (i32.const 0)
                              (local.tee $l2
                                (i32.add
                                  (local.tee $p0
                                    (i32.and
                                      (i32.add
                                        (local.get $l6)
                                        (i32.const 15))
                                      (i32.const -8)))
                                  (i32.const -8))))
                            (i32.store offset=1049712
                              (i32.const 0)
                              (i32.const 1049704))
                            (i32.store offset=1049732
                              (i32.const 0)
                              (local.tee $l7
                                (i32.add
                                  (i32.add
                                    (i32.sub
                                      (local.get $l6)
                                      (local.get $p0))
                                    (local.tee $p0
                                      (i32.add
                                        (local.get $l9)
                                        (i32.const -40))))
                                  (i32.const 8))))
                            (i32.store offset=4
                              (local.get $l2)
                              (i32.or
                                (local.get $l7)
                                (i32.const 1)))
                            (i32.store offset=4
                              (i32.add
                                (local.get $l6)
                                (local.get $p0))
                              (i32.const 40))
                            (i32.store offset=1049752
                              (i32.const 0)
                              (i32.const 2097152))
                            (br $B46))
                          (br_if $B54
                            (i32.ge_u
                              (local.get $l2)
                              (local.get $l6)))
                          (br_if $B54
                            (i32.gt_u
                              (local.get $l7)
                              (local.get $l2)))
                          (br_if $B54
                            (i32.and
                              (local.tee $l7
                                (i32.load offset=12
                                  (local.get $p0)))
                              (i32.const 1)))
                          (br_if $B50
                            (i32.eq
                              (i32.shr_u
                                (local.get $l7)
                                (i32.const 1))
                              (local.get $l5))))
                        (i32.store offset=1049756
                          (i32.const 0)
                          (select
                            (local.tee $p0
                              (i32.load offset=1049756
                                (i32.const 0)))
                            (local.get $l6)
                            (i32.gt_u
                              (local.get $l6)
                              (local.get $p0))))
                        (local.set $l7
                          (i32.add
                            (local.get $l6)
                            (local.get $l9)))
                        (local.set $p0
                          (i32.const 1049440))
                        (block $B60
                          (block $B61
                            (block $B62
                              (loop $L63
                                (br_if $B62
                                  (i32.eq
                                    (local.tee $l8
                                      (i32.load
                                        (local.get $p0)))
                                    (local.get $l7)))
                                (br_if $L63
                                  (local.tee $p0
                                    (i32.load offset=8
                                      (local.get $p0))))
                                (br $B61)))
                            (br_if $B61
                              (i32.and
                                (local.tee $l7
                                  (i32.load offset=12
                                    (local.get $p0)))
                                (i32.const 1)))
                            (br_if $B60
                              (i32.eq
                                (i32.shr_u
                                  (local.get $l7)
                                  (i32.const 1))
                                (local.get $l5))))
                          (local.set $p0
                            (i32.const 1049440))
                          (block $B64
                            (loop $L65
                              (block $B66
                                (br_if $B66
                                  (i32.gt_u
                                    (local.tee $l7
                                      (i32.load
                                        (local.get $p0)))
                                    (local.get $l2)))
                                (br_if $B64
                                  (i32.lt_u
                                    (local.get $l2)
                                    (local.tee $l7
                                      (i32.add
                                        (local.get $l7)
                                        (i32.load offset=4
                                          (local.get $p0)))))))
                              (local.set $p0
                                (i32.load offset=8
                                  (local.get $p0)))
                              (br $L65)))
                          (i32.store offset=1049740
                            (i32.const 0)
                            (local.tee $l8
                              (i32.add
                                (local.tee $p0
                                  (i32.and
                                    (i32.add
                                      (local.get $l6)
                                      (i32.const 15))
                                    (i32.const -8)))
                                (i32.const -8))))
                          (i32.store offset=1049732
                            (i32.const 0)
                            (local.tee $l4
                              (i32.add
                                (i32.add
                                  (i32.sub
                                    (local.get $l6)
                                    (local.get $p0))
                                  (local.tee $p0
                                    (i32.add
                                      (local.get $l9)
                                      (i32.const -40))))
                                (i32.const 8))))
                          (i32.store offset=4
                            (local.get $l8)
                            (i32.or
                              (local.get $l4)
                              (i32.const 1)))
                          (i32.store offset=4
                            (i32.add
                              (local.get $l6)
                              (local.get $p0))
                            (i32.const 40))
                          (i32.store offset=1049752
                            (i32.const 0)
                            (i32.const 2097152))
                          (i32.store offset=4
                            (local.tee $l8
                              (select
                                (local.get $l2)
                                (local.tee $p0
                                  (i32.add
                                    (i32.and
                                      (i32.add
                                        (local.get $l7)
                                        (i32.const -32))
                                      (i32.const -8))
                                    (i32.const -8)))
                                (i32.lt_u
                                  (local.get $p0)
                                  (i32.add
                                    (local.get $l2)
                                    (i32.const 16)))))
                            (i32.const 27))
                          (local.set $l10
                            (i64.load offset=1049440 align=4
                              (i32.const 0)))
                          (i64.store align=4
                            (i32.add
                              (local.get $l8)
                              (i32.const 16))
                            (i64.load offset=1049448 align=4
                              (i32.const 0)))
                          (i64.store offset=8 align=4
                            (local.get $l8)
                            (local.get $l10))
                          (i32.store offset=1049452
                            (i32.const 0)
                            (local.get $l5))
                          (i32.store offset=1049444
                            (i32.const 0)
                            (local.get $l9))
                          (i32.store offset=1049440
                            (i32.const 0)
                            (local.get $l6))
                          (i32.store offset=1049448
                            (i32.const 0)
                            (i32.add
                              (local.get $l8)
                              (i32.const 8)))
                          (local.set $p0
                            (i32.add
                              (local.get $l8)
                              (i32.const 28)))
                          (loop $L67
                            (i32.store
                              (local.get $p0)
                              (i32.const 7))
                            (br_if $L67
                              (i32.lt_u
                                (local.tee $p0
                                  (i32.add
                                    (local.get $p0)
                                    (i32.const 4)))
                                (local.get $l7))))
                          (br_if $B46
                            (i32.eq
                              (local.get $l8)
                              (local.get $l2)))
                          (i32.store offset=4
                            (local.get $l8)
                            (i32.and
                              (i32.load offset=4
                                (local.get $l8))
                              (i32.const -2)))
                          (i32.store offset=4
                            (local.get $l2)
                            (i32.or
                              (local.tee $p0
                                (i32.sub
                                  (local.get $l8)
                                  (local.get $l2)))
                              (i32.const 1)))
                          (i32.store
                            (local.get $l8)
                            (local.get $p0))
                          (block $B68
                            (br_if $B68
                              (i32.lt_u
                                (local.get $p0)
                                (i32.const 256)))
                            (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$18insert_large_chunk17h5f84d09c81f6adaaE
                              (local.get $l2)
                              (local.get $p0))
                            (br $B46))
                          (local.set $l7
                            (i32.add
                              (i32.and
                                (local.get $p0)
                                (i32.const 248))
                              (i32.const 1049456)))
                          (block $B69
                            (block $B70
                              (br_if $B70
                                (i32.and
                                  (local.tee $l6
                                    (i32.load offset=1049720
                                      (i32.const 0)))
                                  (local.tee $p0
                                    (i32.shl
                                      (i32.const 1)
                                      (i32.shr_u
                                        (local.get $p0)
                                        (i32.const 3))))))
                              (i32.store offset=1049720
                                (i32.const 0)
                                (i32.or
                                  (local.get $l6)
                                  (local.get $p0)))
                              (local.set $p0
                                (local.get $l7))
                              (br $B69))
                            (local.set $p0
                              (i32.load offset=8
                                (local.get $l7))))
                          (i32.store offset=8
                            (local.get $l7)
                            (local.get $l2))
                          (i32.store offset=12
                            (local.get $p0)
                            (local.get $l2))
                          (i32.store offset=12
                            (local.get $l2)
                            (local.get $l7))
                          (i32.store offset=8
                            (local.get $l2)
                            (local.get $p0))
                          (br $B46))
                        (i32.store
                          (local.get $p0)
                          (local.get $l6))
                        (i32.store offset=4
                          (local.get $p0)
                          (i32.add
                            (i32.load offset=4
                              (local.get $p0))
                            (local.get $l9)))
                        (i32.store offset=4
                          (local.tee $l7
                            (i32.add
                              (i32.and
                                (i32.add
                                  (local.get $l6)
                                  (i32.const 15))
                                (i32.const -8))
                              (i32.const -8)))
                          (i32.or
                            (local.get $l3)
                            (i32.const 3)))
                        (local.set $l3
                          (i32.sub
                            (local.tee $l2
                              (i32.add
                                (i32.and
                                  (i32.add
                                    (local.get $l8)
                                    (i32.const 15))
                                  (i32.const -8))
                                (i32.const -8)))
                            (local.tee $p0
                              (i32.add
                                (local.get $l7)
                                (local.get $l3)))))
                        (br_if $B49
                          (i32.eq
                            (local.get $l2)
                            (i32.load offset=1049740
                              (i32.const 0))))
                        (br_if $B48
                          (i32.eq
                            (local.get $l2)
                            (i32.load offset=1049736
                              (i32.const 0))))
                        (block $B71
                          (br_if $B71
                            (i32.ne
                              (i32.and
                                (local.tee $l6
                                  (i32.load offset=4
                                    (local.get $l2)))
                                (i32.const 3))
                              (i32.const 1)))
                          (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$12unlink_chunk17h6c7a0664360897f7E
                            (local.get $l2)
                            (local.tee $l6
                              (i32.and
                                (local.get $l6)
                                (i32.const -8))))
                          (local.set $l3
                            (i32.add
                              (local.get $l6)
                              (local.get $l3)))
                          (local.set $l6
                            (i32.load offset=4
                              (local.tee $l2
                                (i32.add
                                  (local.get $l2)
                                  (local.get $l6))))))
                        (i32.store offset=4
                          (local.get $l2)
                          (i32.and
                            (local.get $l6)
                            (i32.const -2)))
                        (i32.store offset=4
                          (local.get $p0)
                          (i32.or
                            (local.get $l3)
                            (i32.const 1)))
                        (i32.store
                          (i32.add
                            (local.get $p0)
                            (local.get $l3))
                          (local.get $l3))
                        (block $B72
                          (br_if $B72
                            (i32.lt_u
                              (local.get $l3)
                              (i32.const 256)))
                          (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$18insert_large_chunk17h5f84d09c81f6adaaE
                            (local.get $p0)
                            (local.get $l3))
                          (br $B47))
                        (local.set $l2
                          (i32.add
                            (i32.and
                              (local.get $l3)
                              (i32.const 248))
                            (i32.const 1049456)))
                        (block $B73
                          (block $B74
                            (br_if $B74
                              (i32.and
                                (local.tee $l6
                                  (i32.load offset=1049720
                                    (i32.const 0)))
                                (local.tee $l3
                                  (i32.shl
                                    (i32.const 1)
                                    (i32.shr_u
                                      (local.get $l3)
                                      (i32.const 3))))))
                            (i32.store offset=1049720
                              (i32.const 0)
                              (i32.or
                                (local.get $l6)
                                (local.get $l3)))
                            (local.set $l3
                              (local.get $l2))
                            (br $B73))
                          (local.set $l3
                            (i32.load offset=8
                              (local.get $l2))))
                        (i32.store offset=8
                          (local.get $l2)
                          (local.get $p0))
                        (i32.store offset=12
                          (local.get $l3)
                          (local.get $p0))
                        (i32.store offset=12
                          (local.get $p0)
                          (local.get $l2))
                        (i32.store offset=8
                          (local.get $p0)
                          (local.get $l3))
                        (br $B47))
                      (i32.store offset=1049732
                        (i32.const 0)
                        (local.tee $l2
                          (i32.sub
                            (local.get $p0)
                            (local.get $l3))))
                      (i32.store offset=1049740
                        (i32.const 0)
                        (local.tee $l7
                          (i32.add
                            (local.tee $p0
                              (i32.load offset=1049740
                                (i32.const 0)))
                            (local.get $l3))))
                      (i32.store offset=4
                        (local.get $l7)
                        (i32.or
                          (local.get $l2)
                          (i32.const 1)))
                      (i32.store offset=4
                        (local.get $p0)
                        (i32.or
                          (local.get $l3)
                          (i32.const 3)))
                      (local.set $p0
                        (i32.add
                          (local.get $p0)
                          (i32.const 8)))
                      (br $B0))
                    (local.set $l2
                      (i32.load offset=1049736
                        (i32.const 0)))
                    (block $B75
                      (block $B76
                        (br_if $B76
                          (i32.gt_u
                            (local.tee $l7
                              (i32.sub
                                (local.get $p0)
                                (local.get $l3)))
                            (i32.const 15)))
                        (i32.store offset=1049736
                          (i32.const 0)
                          (i32.const 0))
                        (i32.store offset=1049728
                          (i32.const 0)
                          (i32.const 0))
                        (i32.store offset=4
                          (local.get $l2)
                          (i32.or
                            (local.get $p0)
                            (i32.const 3)))
                        (i32.store offset=4
                          (local.tee $p0
                            (i32.add
                              (local.get $l2)
                              (local.get $p0)))
                          (i32.or
                            (i32.load offset=4
                              (local.get $p0))
                            (i32.const 1)))
                        (br $B75))
                      (i32.store offset=1049728
                        (i32.const 0)
                        (local.get $l7))
                      (i32.store offset=1049736
                        (i32.const 0)
                        (local.tee $l6
                          (i32.add
                            (local.get $l2)
                            (local.get $l3))))
                      (i32.store offset=4
                        (local.get $l6)
                        (i32.or
                          (local.get $l7)
                          (i32.const 1)))
                      (i32.store
                        (i32.add
                          (local.get $l2)
                          (local.get $p0))
                        (local.get $l7))
                      (i32.store offset=4
                        (local.get $l2)
                        (i32.or
                          (local.get $l3)
                          (i32.const 3))))
                    (local.set $p0
                      (i32.add
                        (local.get $l2)
                        (i32.const 8)))
                    (br $B0))
                  (i32.store offset=4
                    (local.get $p0)
                    (i32.add
                      (local.get $l8)
                      (local.get $l9)))
                  (i32.store offset=1049740
                    (i32.const 0)
                    (local.tee $l7
                      (i32.add
                        (local.tee $l2
                          (i32.and
                            (i32.add
                              (local.tee $p0
                                (i32.load offset=1049740
                                  (i32.const 0)))
                              (i32.const 15))
                            (i32.const -8)))
                        (i32.const -8))))
                  (i32.store offset=1049732
                    (i32.const 0)
                    (local.tee $l6
                      (i32.add
                        (i32.add
                          (i32.sub
                            (local.get $p0)
                            (local.get $l2))
                          (local.tee $l2
                            (i32.add
                              (i32.load offset=1049732
                                (i32.const 0))
                              (local.get $l9))))
                        (i32.const 8))))
                  (i32.store offset=4
                    (local.get $l7)
                    (i32.or
                      (local.get $l6)
                      (i32.const 1)))
                  (i32.store offset=4
                    (i32.add
                      (local.get $p0)
                      (local.get $l2))
                    (i32.const 40))
                  (i32.store offset=1049752
                    (i32.const 0)
                    (i32.const 2097152))
                  (br $B46))
                (i32.store offset=1049740
                  (i32.const 0)
                  (local.get $p0))
                (i32.store offset=1049732
                  (i32.const 0)
                  (local.tee $l3
                    (i32.add
                      (i32.load offset=1049732
                        (i32.const 0))
                      (local.get $l3))))
                (i32.store offset=4
                  (local.get $p0)
                  (i32.or
                    (local.get $l3)
                    (i32.const 1)))
                (br $B47))
              (i32.store offset=1049736
                (i32.const 0)
                (local.get $p0))
              (i32.store offset=1049728
                (i32.const 0)
                (local.tee $l3
                  (i32.add
                    (i32.load offset=1049728
                      (i32.const 0))
                    (local.get $l3))))
              (i32.store offset=4
                (local.get $p0)
                (i32.or
                  (local.get $l3)
                  (i32.const 1)))
              (i32.store
                (i32.add
                  (local.get $p0)
                  (local.get $l3))
                (local.get $l3)))
            (local.set $p0
              (i32.add
                (local.get $l7)
                (i32.const 8)))
            (br $B0))
          (local.set $p0
            (i32.const 0))
          (br_if $B0
            (i32.le_u
              (local.tee $l2
                (i32.load offset=1049732
                  (i32.const 0)))
              (local.get $l3)))
          (i32.store offset=1049732
            (i32.const 0)
            (local.tee $l2
              (i32.sub
                (local.get $l2)
                (local.get $l3))))
          (i32.store offset=1049740
            (i32.const 0)
            (local.tee $l7
              (i32.add
                (local.tee $p0
                  (i32.load offset=1049740
                    (i32.const 0)))
                (local.get $l3))))
          (i32.store offset=4
            (local.get $l7)
            (i32.or
              (local.get $l2)
              (i32.const 1)))
          (i32.store offset=4
            (local.get $p0)
            (i32.or
              (local.get $l3)
              (i32.const 3)))
          (local.set $p0
            (i32.add
              (local.get $p0)
              (i32.const 8)))
          (br $B0))
        (i32.store offset=24
          (local.get $p0)
          (local.get $l5))
        (block $B77
          (br_if $B77
            (i32.eqz
              (local.tee $l6
                (i32.load offset=16
                  (local.get $l7)))))
          (i32.store offset=16
            (local.get $p0)
            (local.get $l6))
          (i32.store offset=24
            (local.get $l6)
            (local.get $p0)))
        (br_if $B1
          (i32.eqz
            (local.tee $l6
              (i32.load offset=20
                (local.get $l7)))))
        (i32.store offset=20
          (local.get $p0)
          (local.get $l6))
        (i32.store offset=24
          (local.get $l6)
          (local.get $p0)))
      (block $B78
        (block $B79
          (br_if $B79
            (i32.lt_u
              (local.get $l2)
              (i32.const 16)))
          (i32.store offset=4
            (local.get $l7)
            (i32.or
              (local.get $l3)
              (i32.const 3)))
          (i32.store offset=4
            (local.tee $p0
              (i32.add
                (local.get $l7)
                (local.get $l3)))
            (i32.or
              (local.get $l2)
              (i32.const 1)))
          (i32.store
            (i32.add
              (local.get $p0)
              (local.get $l2))
            (local.get $l2))
          (block $B80
            (br_if $B80
              (i32.lt_u
                (local.get $l2)
                (i32.const 256)))
            (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$18insert_large_chunk17h5f84d09c81f6adaaE
              (local.get $p0)
              (local.get $l2))
            (br $B78))
          (local.set $l3
            (i32.add
              (i32.and
                (local.get $l2)
                (i32.const 248))
              (i32.const 1049456)))
          (block $B81
            (block $B82
              (br_if $B82
                (i32.and
                  (local.tee $l6
                    (i32.load offset=1049720
                      (i32.const 0)))
                  (local.tee $l2
                    (i32.shl
                      (i32.const 1)
                      (i32.shr_u
                        (local.get $l2)
                        (i32.const 3))))))
              (i32.store offset=1049720
                (i32.const 0)
                (i32.or
                  (local.get $l6)
                  (local.get $l2)))
              (local.set $l2
                (local.get $l3))
              (br $B81))
            (local.set $l2
              (i32.load offset=8
                (local.get $l3))))
          (i32.store offset=8
            (local.get $l3)
            (local.get $p0))
          (i32.store offset=12
            (local.get $l2)
            (local.get $p0))
          (i32.store offset=12
            (local.get $p0)
            (local.get $l3))
          (i32.store offset=8
            (local.get $p0)
            (local.get $l2))
          (br $B78))
        (i32.store offset=4
          (local.get $l7)
          (i32.or
            (local.tee $p0
              (i32.add
                (local.get $l2)
                (local.get $l3)))
            (i32.const 3)))
        (i32.store offset=4
          (local.tee $p0
            (i32.add
              (local.get $l7)
              (local.get $p0)))
          (i32.or
            (i32.load offset=4
              (local.get $p0))
            (i32.const 1))))
      (local.set $p0
        (i32.add
          (local.get $l7)
          (i32.const 8))))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l1)
        (i32.const 16)))
    (local.get $p0))
  (func $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$8memalign17hbbefa886b37a8ca9E (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    (local.set $l2
      (i32.const 0))
    (block $B0
      (br_if $B0
        (i32.le_u
          (i32.sub
            (i32.const -65587)
            (local.tee $p0
              (select
                (local.get $p0)
                (i32.const 16)
                (i32.gt_u
                  (local.get $p0)
                  (i32.const 16)))))
          (local.get $p1)))
      (br_if $B0
        (i32.eqz
          (local.tee $p1
            (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$6malloc17hb720925448de7b1dE
              (i32.add
                (i32.add
                  (local.get $p0)
                  (local.tee $l3
                    (select
                      (i32.const 16)
                      (i32.and
                        (i32.add
                          (local.get $p1)
                          (i32.const 11))
                        (i32.const -8))
                      (i32.lt_u
                        (local.get $p1)
                        (i32.const 11)))))
                (i32.const 12))))))
      (local.set $l2
        (i32.add
          (local.get $p1)
          (i32.const -8)))
      (block $B1
        (block $B2
          (br_if $B2
            (i32.and
              (local.tee $l4
                (i32.add
                  (local.get $p0)
                  (i32.const -1)))
              (local.get $p1)))
          (local.set $p0
            (local.get $l2))
          (br $B1))
        (local.set $l4
          (i32.sub
            (i32.and
              (local.tee $l6
                (i32.load
                  (local.tee $l5
                    (i32.add
                      (local.get $p1)
                      (i32.const -4)))))
              (i32.const -8))
            (local.tee $p1
              (i32.sub
                (local.tee $p0
                  (i32.add
                    (local.tee $p1
                      (i32.add
                        (i32.and
                          (i32.add
                            (local.get $l4)
                            (local.get $p1))
                          (i32.sub
                            (i32.const 0)
                            (local.get $p0)))
                        (i32.const -8)))
                    (select
                      (i32.const 0)
                      (local.get $p0)
                      (i32.gt_u
                        (i32.sub
                          (local.get $p1)
                          (local.get $l2))
                        (i32.const 16)))))
                (local.get $l2)))))
        (block $B3
          (br_if $B3
            (i32.eqz
              (i32.and
                (local.get $l6)
                (i32.const 3))))
          (i32.store offset=4
            (local.get $p0)
            (i32.or
              (i32.or
                (local.get $l4)
                (i32.and
                  (i32.load offset=4
                    (local.get $p0))
                  (i32.const 1)))
              (i32.const 2)))
          (i32.store offset=4
            (local.tee $l4
              (i32.add
                (local.get $p0)
                (local.get $l4)))
            (i32.or
              (i32.load offset=4
                (local.get $l4))
              (i32.const 1)))
          (i32.store
            (local.get $l5)
            (i32.or
              (i32.or
                (local.get $p1)
                (i32.and
                  (i32.load
                    (local.get $l5))
                  (i32.const 1)))
              (i32.const 2)))
          (i32.store offset=4
            (local.tee $l4
              (i32.add
                (local.get $l2)
                (local.get $p1)))
            (i32.or
              (i32.load offset=4
                (local.get $l4))
              (i32.const 1)))
          (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$13dispose_chunk17h93817601d12c9b57E
            (local.get $l2)
            (local.get $p1))
          (br $B1))
        (local.set $l2
          (i32.load
            (local.get $l2)))
        (i32.store offset=4
          (local.get $p0)
          (local.get $l4))
        (i32.store
          (local.get $p0)
          (i32.add
            (local.get $l2)
            (local.get $p1))))
      (block $B4
        (br_if $B4
          (i32.eqz
            (i32.and
              (local.tee $p1
                (i32.load offset=4
                  (local.get $p0)))
              (i32.const 3))))
        (br_if $B4
          (i32.le_u
            (local.tee $l2
              (i32.and
                (local.get $p1)
                (i32.const -8)))
            (i32.add
              (local.get $l3)
              (i32.const 16))))
        (i32.store offset=4
          (local.get $p0)
          (i32.or
            (i32.or
              (local.get $l3)
              (i32.and
                (local.get $p1)
                (i32.const 1)))
            (i32.const 2)))
        (i32.store offset=4
          (local.tee $p1
            (i32.add
              (local.get $p0)
              (local.get $l3)))
          (i32.or
            (local.tee $l3
              (i32.sub
                (local.get $l2)
                (local.get $l3)))
            (i32.const 3)))
        (i32.store offset=4
          (local.tee $l2
            (i32.add
              (local.get $p0)
              (local.get $l2)))
          (i32.or
            (i32.load offset=4
              (local.get $l2))
            (i32.const 1)))
        (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$13dispose_chunk17h93817601d12c9b57E
          (local.get $p1)
          (local.get $l3)))
      (local.set $l2
        (i32.add
          (local.get $p0)
          (i32.const 8))))
    (local.get $l2))
  (func $_ZN3std3sys9backtrace26__rust_end_short_backtrace17h8e8868764214f28dE (type $t3) (param $p0 i32)
    (call $_ZN3std9panicking19begin_panic_handler28_$u7b$$u7b$closure$u7d$$u7d$17h3c2bc8468c50b1ceE
      (local.get $p0))
    (unreachable))
  (func $_ZN3std9panicking19begin_panic_handler28_$u7b$$u7b$closure$u7d$$u7d$17h3c2bc8468c50b1ceE (type $t3) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32)
    (global.set $__stack_pointer
      (local.tee $l1
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (local.set $l3
      (i32.load offset=12
        (local.tee $l2
          (i32.load
            (local.get $p0)))))
    (block $B0
      (block $B1
        (block $B2
          (block $B3
            (br_table $B3 $B2 $B1
              (i32.load offset=4
                (local.get $l2))))
          (br_if $B1
            (local.get $l3))
          (local.set $l2
            (i32.const 1))
          (local.set $l3
            (i32.const 0))
          (br $B0))
        (br_if $B1
          (local.get $l3))
        (local.set $l3
          (i32.load offset=4
            (local.tee $l2
              (i32.load
                (local.get $l2)))))
        (local.set $l2
          (i32.load
            (local.get $l2)))
        (br $B0))
      (i32.store
        (local.get $l1)
        (i32.const -2147483648))
      (i32.store offset=12
        (local.get $l1)
        (local.get $p0))
      (call $_ZN3std9panicking20rust_panic_with_hook17heb1fa7c95b92daf7E
        (local.get $l1)
        (i32.const 1048956)
        (i32.load offset=4
          (local.get $p0))
        (i32.load8_u offset=8
          (local.tee $p0
            (i32.load offset=8
              (local.get $p0))))
        (i32.load8_u offset=9
          (local.get $p0)))
      (unreachable))
    (i32.store offset=4
      (local.get $l1)
      (local.get $l3))
    (i32.store
      (local.get $l1)
      (local.get $l2))
    (call $_ZN3std9panicking20rust_panic_with_hook17heb1fa7c95b92daf7E
      (local.get $l1)
      (i32.const 1048928)
      (i32.load offset=4
        (local.get $p0))
      (i32.load8_u offset=8
        (local.tee $p0
          (i32.load offset=8
            (local.get $p0))))
      (i32.load8_u offset=9
        (local.get $p0)))
    (unreachable))
  (func $_ZN3std5alloc24default_alloc_error_hook17h858a662c91e8db67E (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    (global.set $__stack_pointer
      (local.tee $l2
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 48))))
    (block $B0
      (br_if $B0
        (i32.eqz
          (i32.load8_u offset=1049288
            (i32.const 0))))
      (i32.store offset=12
        (local.get $l2)
        (i32.const 2))
      (i32.store offset=8
        (local.get $l2)
        (i32.const 1048848))
      (i64.store offset=20 align=4
        (local.get $l2)
        (i64.const 1))
      (i32.store offset=44
        (local.get $l2)
        (local.get $p1))
      (i64.store offset=32
        (local.get $l2)
        (i64.or
          (i64.shl
            (i64.extend_i32_u
              (i32.const 1))
            (i64.const 32))
          (i64.extend_i32_u
            (i32.add
              (local.get $l2)
              (i32.const 44)))))
      (i32.store offset=16
        (local.get $l2)
        (i32.add
          (local.get $l2)
          (i32.const 32)))
      (call $_ZN4core9panicking9panic_fmt17h067fb97c138f603dE
        (i32.add
          (local.get $l2)
          (i32.const 8))
        (i32.const 1048880))
      (unreachable))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l2)
        (i32.const 48))))
  (func $__rdl_alloc (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (block $B0
      (br_if $B0
        (i32.lt_u
          (local.get $p1)
          (i32.const 9)))
      (return
        (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$8memalign17hbbefa886b37a8ca9E
          (local.get $p1)
          (local.get $p0))))
    (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$6malloc17hb720925448de7b1dE
      (local.get $p0)))
  (func $__rdl_dealloc (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32)
    (block $B0
      (block $B1
        (br_if $B1
          (i32.lt_u
            (local.tee $l4
              (i32.and
                (local.tee $l3
                  (i32.load
                    (i32.add
                      (local.get $p0)
                      (i32.const -4))))
                (i32.const -8)))
            (i32.add
              (select
                (i32.const 4)
                (i32.const 8)
                (local.tee $l3
                  (i32.and
                    (local.get $l3)
                    (i32.const 3))))
              (local.get $p1))))
        (block $B2
          (br_if $B2
            (i32.eqz
              (local.get $l3)))
          (br_if $B0
            (i32.gt_u
              (local.get $l4)
              (i32.add
                (local.get $p1)
                (i32.const 39)))))
        (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$4free17hc3311d3fb11cee48E
          (local.get $p0))
        (return))
      (call $_ZN4core9panicking5panic17h9851d4d319da0e79E
        (i32.const 1048685)
        (i32.const 46)
        (i32.const 1048732))
      (unreachable))
    (call $_ZN4core9panicking5panic17h9851d4d319da0e79E
      (i32.const 1048748)
      (i32.const 46)
      (i32.const 1048796))
    (unreachable))
  (func $__rdl_realloc (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    (block $B0
      (block $B1
        (block $B2
          (block $B3
            (block $B4
              (br_if $B4
                (i32.lt_u
                  (local.tee $l6
                    (i32.and
                      (local.tee $l5
                        (i32.load
                          (local.tee $l4
                            (i32.add
                              (local.get $p0)
                              (i32.const -4)))))
                      (i32.const -8)))
                  (i32.add
                    (select
                      (i32.const 4)
                      (i32.const 8)
                      (local.tee $l7
                        (i32.and
                          (local.get $l5)
                          (i32.const 3))))
                    (local.get $p1))))
              (local.set $l8
                (i32.add
                  (local.get $p1)
                  (i32.const 39)))
              (block $B5
                (br_if $B5
                  (i32.eqz
                    (local.get $l7)))
                (br_if $B3
                  (i32.gt_u
                    (local.get $l6)
                    (local.get $l8))))
              (block $B6
                (block $B7
                  (block $B8
                    (br_if $B8
                      (i32.lt_u
                        (local.get $p2)
                        (i32.const 9)))
                    (br_if $B7
                      (local.tee $p2
                        (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$8memalign17hbbefa886b37a8ca9E
                          (local.get $p2)
                          (local.get $p3))))
                    (return
                      (i32.const 0)))
                  (local.set $p2
                    (i32.const 0))
                  (br_if $B6
                    (i32.gt_u
                      (local.get $p3)
                      (i32.const -65588)))
                  (local.set $p1
                    (select
                      (i32.const 16)
                      (i32.and
                        (i32.add
                          (local.get $p3)
                          (i32.const 11))
                        (i32.const -8))
                      (i32.lt_u
                        (local.get $p3)
                        (i32.const 11))))
                  (block $B9
                    (block $B10
                      (br_if $B10
                        (local.get $l7))
                      (br_if $B9
                        (i32.lt_u
                          (local.get $p1)
                          (i32.const 256)))
                      (br_if $B9
                        (i32.lt_u
                          (local.get $l6)
                          (i32.or
                            (local.get $p1)
                            (i32.const 4))))
                      (br_if $B9
                        (i32.ge_u
                          (i32.sub
                            (local.get $l6)
                            (local.get $p1))
                          (i32.const 131073)))
                      (return
                        (local.get $p0)))
                    (local.set $l7
                      (i32.add
                        (local.tee $l8
                          (i32.add
                            (local.get $p0)
                            (i32.const -8)))
                        (local.get $l6)))
                    (block $B11
                      (block $B12
                        (block $B13
                          (block $B14
                            (block $B15
                              (br_if $B15
                                (i32.ge_u
                                  (local.get $l6)
                                  (local.get $p1)))
                              (br_if $B11
                                (i32.eq
                                  (local.get $l7)
                                  (i32.load offset=1049740
                                    (i32.const 0))))
                              (br_if $B13
                                (i32.eq
                                  (local.get $l7)
                                  (i32.load offset=1049736
                                    (i32.const 0))))
                              (br_if $B9
                                (i32.and
                                  (local.tee $l5
                                    (i32.load offset=4
                                      (local.get $l7)))
                                  (i32.const 2)))
                              (br_if $B9
                                (i32.lt_u
                                  (local.tee $l5
                                    (i32.add
                                      (local.tee $l9
                                        (i32.and
                                          (local.get $l5)
                                          (i32.const -8)))
                                      (local.get $l6)))
                                  (local.get $p1)))
                              (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$12unlink_chunk17h6c7a0664360897f7E
                                (local.get $l7)
                                (local.get $l9))
                              (br_if $B14
                                (i32.lt_u
                                  (local.tee $p3
                                    (i32.sub
                                      (local.get $l5)
                                      (local.get $p1)))
                                  (i32.const 16)))
                              (i32.store
                                (local.get $l4)
                                (i32.or
                                  (i32.or
                                    (local.get $p1)
                                    (i32.and
                                      (i32.load
                                        (local.get $l4))
                                      (i32.const 1)))
                                  (i32.const 2)))
                              (i32.store offset=4
                                (local.tee $p1
                                  (i32.add
                                    (local.get $l8)
                                    (local.get $p1)))
                                (i32.or
                                  (local.get $p3)
                                  (i32.const 3)))
                              (i32.store offset=4
                                (local.tee $p2
                                  (i32.add
                                    (local.get $l8)
                                    (local.get $l5)))
                                (i32.or
                                  (i32.load offset=4
                                    (local.get $p2))
                                  (i32.const 1)))
                              (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$13dispose_chunk17h93817601d12c9b57E
                                (local.get $p1)
                                (local.get $p3))
                              (return
                                (local.get $p0)))
                            (br_if $B12
                              (i32.gt_u
                                (local.tee $p3
                                  (i32.sub
                                    (local.get $l6)
                                    (local.get $p1)))
                                (i32.const 15)))
                            (return
                              (local.get $p0)))
                          (i32.store
                            (local.get $l4)
                            (i32.or
                              (i32.or
                                (local.get $l5)
                                (i32.and
                                  (i32.load
                                    (local.get $l4))
                                  (i32.const 1)))
                              (i32.const 2)))
                          (i32.store offset=4
                            (local.tee $p1
                              (i32.add
                                (local.get $l8)
                                (local.get $l5)))
                            (i32.or
                              (i32.load offset=4
                                (local.get $p1))
                              (i32.const 1)))
                          (return
                            (local.get $p0)))
                        (br_if $B9
                          (i32.lt_u
                            (local.tee $l7
                              (i32.add
                                (i32.load offset=1049728
                                  (i32.const 0))
                                (local.get $l6)))
                            (local.get $p1)))
                        (block $B16
                          (block $B17
                            (br_if $B17
                              (i32.gt_u
                                (local.tee $p3
                                  (i32.sub
                                    (local.get $l7)
                                    (local.get $p1)))
                                (i32.const 15)))
                            (i32.store
                              (local.get $l4)
                              (i32.or
                                (i32.or
                                  (i32.and
                                    (local.get $l5)
                                    (i32.const 1))
                                  (local.get $l7))
                                (i32.const 2)))
                            (i32.store offset=4
                              (local.tee $p1
                                (i32.add
                                  (local.get $l8)
                                  (local.get $l7)))
                              (i32.or
                                (i32.load offset=4
                                  (local.get $p1))
                                (i32.const 1)))
                            (local.set $p3
                              (i32.const 0))
                            (local.set $p1
                              (i32.const 0))
                            (br $B16))
                          (i32.store
                            (local.get $l4)
                            (i32.or
                              (i32.or
                                (local.get $p1)
                                (i32.and
                                  (local.get $l5)
                                  (i32.const 1)))
                              (i32.const 2)))
                          (i32.store offset=4
                            (local.tee $p1
                              (i32.add
                                (local.get $l8)
                                (local.get $p1)))
                            (i32.or
                              (local.get $p3)
                              (i32.const 1)))
                          (i32.store
                            (local.tee $p2
                              (i32.add
                                (local.get $l8)
                                (local.get $l7)))
                            (local.get $p3))
                          (i32.store offset=4
                            (local.get $p2)
                            (i32.and
                              (i32.load offset=4
                                (local.get $p2))
                              (i32.const -2))))
                        (i32.store offset=1049736
                          (i32.const 0)
                          (local.get $p1))
                        (i32.store offset=1049728
                          (i32.const 0)
                          (local.get $p3))
                        (return
                          (local.get $p0)))
                      (i32.store
                        (local.get $l4)
                        (i32.or
                          (i32.or
                            (local.get $p1)
                            (i32.and
                              (local.get $l5)
                              (i32.const 1)))
                          (i32.const 2)))
                      (i32.store offset=4
                        (local.tee $p1
                          (i32.add
                            (local.get $l8)
                            (local.get $p1)))
                        (i32.or
                          (local.get $p3)
                          (i32.const 3)))
                      (i32.store offset=4
                        (local.get $l7)
                        (i32.or
                          (i32.load offset=4
                            (local.get $l7))
                          (i32.const 1)))
                      (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$13dispose_chunk17h93817601d12c9b57E
                        (local.get $p1)
                        (local.get $p3))
                      (return
                        (local.get $p0)))
                    (br_if $B0
                      (i32.gt_u
                        (local.tee $l7
                          (i32.add
                            (i32.load offset=1049732
                              (i32.const 0))
                            (local.get $l6)))
                        (local.get $p1))))
                  (br_if $B6
                    (i32.eqz
                      (local.tee $p1
                        (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$6malloc17hb720925448de7b1dE
                          (local.get $p3)))))
                  (local.set $p1
                    (call $memcpy
                      (local.get $p1)
                      (local.get $p0)
                      (select
                        (local.tee $p2
                          (i32.add
                            (select
                              (i32.const -4)
                              (i32.const -8)
                              (i32.and
                                (local.tee $p2
                                  (i32.load
                                    (local.get $l4)))
                                (i32.const 3)))
                            (i32.and
                              (local.get $p2)
                              (i32.const -8))))
                        (local.get $p3)
                        (i32.lt_u
                          (local.get $p2)
                          (local.get $p3)))))
                  (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$4free17hc3311d3fb11cee48E
                    (local.get $p0))
                  (return
                    (local.get $p1)))
                (drop
                  (call $memcpy
                    (local.get $p2)
                    (local.get $p0)
                    (select
                      (local.get $p1)
                      (local.get $p3)
                      (i32.lt_u
                        (local.get $p1)
                        (local.get $p3)))))
                (br_if $B2
                  (i32.lt_u
                    (local.tee $l7
                      (i32.and
                        (local.tee $p3
                          (i32.load
                            (local.get $l4)))
                        (i32.const -8)))
                    (i32.add
                      (select
                        (i32.const 4)
                        (i32.const 8)
                        (local.tee $p3
                          (i32.and
                            (local.get $p3)
                            (i32.const 3))))
                      (local.get $p1))))
                (block $B18
                  (br_if $B18
                    (i32.eqz
                      (local.get $p3)))
                  (br_if $B1
                    (i32.gt_u
                      (local.get $l7)
                      (local.get $l8))))
                (call $_ZN8dlmalloc8dlmalloc17Dlmalloc$LT$A$GT$4free17hc3311d3fb11cee48E
                  (local.get $p0)))
              (return
                (local.get $p2)))
            (call $_ZN4core9panicking5panic17h9851d4d319da0e79E
              (i32.const 1048685)
              (i32.const 46)
              (i32.const 1048732))
            (unreachable))
          (call $_ZN4core9panicking5panic17h9851d4d319da0e79E
            (i32.const 1048748)
            (i32.const 46)
            (i32.const 1048796))
          (unreachable))
        (call $_ZN4core9panicking5panic17h9851d4d319da0e79E
          (i32.const 1048685)
          (i32.const 46)
          (i32.const 1048732))
        (unreachable))
      (call $_ZN4core9panicking5panic17h9851d4d319da0e79E
        (i32.const 1048748)
        (i32.const 46)
        (i32.const 1048796))
      (unreachable))
    (i32.store
      (local.get $l4)
      (i32.or
        (i32.or
          (local.get $p1)
          (i32.and
            (local.get $l5)
            (i32.const 1)))
        (i32.const 2)))
    (i32.store offset=4
      (local.tee $p3
        (i32.add
          (local.get $l8)
          (local.get $p1)))
      (i32.or
        (local.tee $p1
          (i32.sub
            (local.get $l7)
            (local.get $p1)))
        (i32.const 1)))
    (i32.store offset=1049732
      (i32.const 0)
      (local.get $p1))
    (i32.store offset=1049740
      (i32.const 0)
      (local.get $p3))
    (local.get $p0))
  (func $_ZN3std9panicking11panic_count8increase17h8e04cbbe4e6e3ecfE (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32)
    (local.set $l1
      (i32.const 0))
    (i32.store offset=1049308
      (i32.const 0)
      (i32.add
        (local.tee $l2
          (i32.load offset=1049308
            (i32.const 0)))
        (i32.const 1)))
    (block $B0
      (br_if $B0
        (i32.lt_s
          (local.get $l2)
          (i32.const 0)))
      (local.set $l1
        (i32.const 1))
      (br_if $B0
        (i32.load8_u offset=1049768
          (i32.const 0)))
      (i32.store8 offset=1049768
        (i32.const 0)
        (local.get $p0))
      (i32.store offset=1049764
        (i32.const 0)
        (i32.add
          (i32.load offset=1049764
            (i32.const 0))
          (i32.const 1)))
      (local.set $l1
        (i32.const 2)))
    (local.get $l1))
  (func $rust_begin_unwind (type $t3) (param $p0 i32)
    (local $l1 i32) (local $l2 i64)
    (global.set $__stack_pointer
      (local.tee $l1
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (local.set $l2
      (i64.load align=4
        (local.get $p0)))
    (i32.store offset=12
      (local.get $l1)
      (local.get $p0))
    (i64.store offset=4 align=4
      (local.get $l1)
      (local.get $l2))
    (call $_ZN3std3sys9backtrace26__rust_end_short_backtrace17h8e8868764214f28dE
      (i32.add
        (local.get $l1)
        (i32.const 4)))
    (unreachable))
  (func $_ZN102_$LT$std..panicking..begin_panic_handler..FormatStringPayload$u20$as$u20$core..panic..PanicPayload$GT$8take_box17h0974c4d840e18588E (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i64)
    (global.set $__stack_pointer
      (local.tee $l2
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 64))))
    (block $B0
      (br_if $B0
        (i32.ne
          (i32.load
            (local.get $p1))
          (i32.const -2147483648)))
      (local.set $l3
        (i32.load offset=12
          (local.get $p1)))
      (i32.store
        (local.tee $l4
          (i32.add
            (i32.add
              (local.get $l2)
              (i32.const 28))
            (i32.const 8)))
        (i32.const 0))
      (i64.store offset=28 align=4
        (local.get $l2)
        (i64.const 4294967296))
      (i64.store
        (i32.add
          (i32.add
            (local.get $l2)
            (i32.const 40))
          (i32.const 8))
        (i64.load align=4
          (i32.add
            (local.tee $l3
              (i32.load
                (local.get $l3)))
            (i32.const 8))))
      (i64.store
        (i32.add
          (i32.add
            (local.get $l2)
            (i32.const 40))
          (i32.const 16))
        (i64.load align=4
          (i32.add
            (local.get $l3)
            (i32.const 16))))
      (i64.store offset=40
        (local.get $l2)
        (i64.load align=4
          (local.get $l3)))
      (drop
        (call $_ZN4core3fmt5write17h298882761c3c0a18E
          (i32.add
            (local.get $l2)
            (i32.const 28))
          (i32.const 1048620)
          (i32.add
            (local.get $l2)
            (i32.const 40))))
      (i32.store
        (i32.add
          (i32.add
            (local.get $l2)
            (i32.const 16))
          (i32.const 8))
        (local.tee $l3
          (i32.load
            (local.get $l4))))
      (i64.store offset=16
        (local.get $l2)
        (local.tee $l5
          (i64.load offset=28 align=4
            (local.get $l2))))
      (i32.store
        (i32.add
          (local.get $p1)
          (i32.const 8))
        (local.get $l3))
      (i64.store align=4
        (local.get $p1)
        (local.get $l5)))
    (local.set $l5
      (i64.load align=4
        (local.get $p1)))
    (i64.store align=4
      (local.get $p1)
      (i64.const 4294967296))
    (i32.store
      (local.tee $l3
        (i32.add
          (local.get $l2)
          (i32.const 8)))
      (i32.load
        (local.tee $p1
          (i32.add
            (local.get $p1)
            (i32.const 8)))))
    (i32.store
      (local.get $p1)
      (i32.const 0))
    (drop
      (i32.load8_u offset=1049289
        (i32.const 0)))
    (i64.store
      (local.get $l2)
      (local.get $l5))
    (block $B1
      (br_if $B1
        (local.tee $p1
          (call $__rust_alloc
            (i32.const 12)
            (i32.const 4))))
      (call $_ZN5alloc5alloc18handle_alloc_error17hce180d57c01eeed3E
        (i32.const 4)
        (i32.const 12))
      (unreachable))
    (i64.store align=4
      (local.get $p1)
      (i64.load
        (local.get $l2)))
    (i32.store
      (i32.add
        (local.get $p1)
        (i32.const 8))
      (i32.load
        (local.get $l3)))
    (i32.store offset=4
      (local.get $p0)
      (i32.const 1048896))
    (i32.store
      (local.get $p0)
      (local.get $p1))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l2)
        (i32.const 64))))
  (func $_ZN102_$LT$std..panicking..begin_panic_handler..FormatStringPayload$u20$as$u20$core..panic..PanicPayload$GT$3get17hcf9e5ec89c6f5452E (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i64)
    (global.set $__stack_pointer
      (local.tee $l2
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 48))))
    (block $B0
      (br_if $B0
        (i32.ne
          (i32.load
            (local.get $p1))
          (i32.const -2147483648)))
      (local.set $l3
        (i32.load offset=12
          (local.get $p1)))
      (i32.store
        (local.tee $l4
          (i32.add
            (i32.add
              (local.get $l2)
              (i32.const 12))
            (i32.const 8)))
        (i32.const 0))
      (i64.store offset=12 align=4
        (local.get $l2)
        (i64.const 4294967296))
      (i64.store
        (i32.add
          (i32.add
            (local.get $l2)
            (i32.const 24))
          (i32.const 8))
        (i64.load align=4
          (i32.add
            (local.tee $l3
              (i32.load
                (local.get $l3)))
            (i32.const 8))))
      (i64.store
        (i32.add
          (i32.add
            (local.get $l2)
            (i32.const 24))
          (i32.const 16))
        (i64.load align=4
          (i32.add
            (local.get $l3)
            (i32.const 16))))
      (i64.store offset=24
        (local.get $l2)
        (i64.load align=4
          (local.get $l3)))
      (drop
        (call $_ZN4core3fmt5write17h298882761c3c0a18E
          (i32.add
            (local.get $l2)
            (i32.const 12))
          (i32.const 1048620)
          (i32.add
            (local.get $l2)
            (i32.const 24))))
      (i32.store
        (i32.add
          (local.get $l2)
          (i32.const 8))
        (local.tee $l3
          (i32.load
            (local.get $l4))))
      (i64.store
        (local.get $l2)
        (local.tee $l5
          (i64.load offset=12 align=4
            (local.get $l2))))
      (i32.store
        (i32.add
          (local.get $p1)
          (i32.const 8))
        (local.get $l3))
      (i64.store align=4
        (local.get $p1)
        (local.get $l5)))
    (i32.store offset=4
      (local.get $p0)
      (i32.const 1048896))
    (i32.store
      (local.get $p0)
      (local.get $p1))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l2)
        (i32.const 48))))
  (func $_ZN95_$LT$std..panicking..begin_panic_handler..FormatStringPayload$u20$as$u20$core..fmt..Display$GT$3fmt17hc6b149a08104ba5cE (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    (global.set $__stack_pointer
      (local.tee $l2
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 32))))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.eq
            (i32.load
              (local.get $p0))
            (i32.const -2147483648)))
        (local.set $p0
          (call $_ZN4core3fmt9Formatter9write_str17h07cdad31e426547dE
            (local.get $p1)
            (i32.load offset=4
              (local.get $p0))
            (i32.load offset=8
              (local.get $p0))))
        (br $B0))
      (i64.store
        (i32.add
          (i32.add
            (local.get $l2)
            (i32.const 8))
          (i32.const 8))
        (i64.load align=4
          (i32.add
            (local.tee $p0
              (i32.load
                (i32.load offset=12
                  (local.get $p0))))
            (i32.const 8))))
      (i64.store
        (i32.add
          (i32.add
            (local.get $l2)
            (i32.const 8))
          (i32.const 16))
        (i64.load align=4
          (i32.add
            (local.get $p0)
            (i32.const 16))))
      (i64.store offset=8
        (local.get $l2)
        (i64.load align=4
          (local.get $p0)))
      (local.set $p0
        (call $_ZN4core3fmt5write17h298882761c3c0a18E
          (i32.load offset=20
            (local.get $p1))
          (i32.load offset=24
            (local.get $p1))
          (i32.add
            (local.get $l2)
            (i32.const 8)))))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l2)
        (i32.const 32)))
    (local.get $p0))
  (func $_ZN99_$LT$std..panicking..begin_panic_handler..StaticStrPayload$u20$as$u20$core..panic..PanicPayload$GT$8take_box17h0880b9f8a9aad3e3E (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32)
    (drop
      (i32.load8_u offset=1049289
        (i32.const 0)))
    (local.set $l2
      (i32.load offset=4
        (local.get $p1)))
    (local.set $l3
      (i32.load
        (local.get $p1)))
    (block $B0
      (br_if $B0
        (local.tee $p1
          (call $__rust_alloc
            (i32.const 8)
            (i32.const 4))))
      (call $_ZN5alloc5alloc18handle_alloc_error17hce180d57c01eeed3E
        (i32.const 4)
        (i32.const 8))
      (unreachable))
    (i32.store offset=4
      (local.get $p1)
      (local.get $l2))
    (i32.store
      (local.get $p1)
      (local.get $l3))
    (i32.store offset=4
      (local.get $p0)
      (i32.const 1048912))
    (i32.store
      (local.get $p0)
      (local.get $p1)))
  (func $_ZN99_$LT$std..panicking..begin_panic_handler..StaticStrPayload$u20$as$u20$core..panic..PanicPayload$GT$3get17h6a831050ede36d61E (type $t0) (param $p0 i32) (param $p1 i32)
    (i32.store offset=4
      (local.get $p0)
      (i32.const 1048912))
    (i32.store
      (local.get $p0)
      (local.get $p1)))
  (func $_ZN99_$LT$std..panicking..begin_panic_handler..StaticStrPayload$u20$as$u20$core..panic..PanicPayload$GT$6as_str17hf8625a0e1d276a5eE (type $t0) (param $p0 i32) (param $p1 i32)
    (i64.store
      (local.get $p0)
      (i64.load align=4
        (local.get $p1))))
  (func $_ZN92_$LT$std..panicking..begin_panic_handler..StaticStrPayload$u20$as$u20$core..fmt..Display$GT$3fmt17h8c7501c69f0d32a6E (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (call $_ZN4core3fmt9Formatter9write_str17h07cdad31e426547dE
      (local.get $p1)
      (i32.load
        (local.get $p0))
      (i32.load offset=4
        (local.get $p0))))
  (func $_ZN3std9panicking20rust_panic_with_hook17heb1fa7c95b92daf7E (type $t8) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32)
    (local $l5 i32) (local $l6 i32)
    (global.set $__stack_pointer
      (local.tee $l5
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 32))))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.eq
            (local.tee $l6
              (i32.and
                (call $_ZN3std9panicking11panic_count8increase17h8e04cbbe4e6e3ecfE
                  (i32.const 1))
                (i32.const 255)))
            (i32.const 2)))
        (br_if $B0
          (i32.eqz
            (i32.and
              (local.get $l6)
              (i32.const 1))))
        (call_indirect $T0 (type $t0)
          (i32.add
            (local.get $l5)
            (i32.const 8))
          (local.get $p0)
          (i32.load offset=24
            (local.get $p1)))
        (unreachable))
      (br_if $B0
        (i32.le_s
          (local.tee $l6
            (i32.load offset=1049296
              (i32.const 0)))
          (i32.const -1)))
      (i32.store offset=1049296
        (i32.const 0)
        (i32.add
          (local.get $l6)
          (i32.const 1)))
      (block $B2
        (br_if $B2
          (i32.eqz
            (i32.load offset=1049300
              (i32.const 0))))
        (call_indirect $T0 (type $t0)
          (local.get $l5)
          (local.get $p0)
          (i32.load offset=20
            (local.get $p1)))
        (i32.store8 offset=29
          (local.get $l5)
          (local.get $p4))
        (i32.store8 offset=28
          (local.get $l5)
          (local.get $p3))
        (i32.store offset=24
          (local.get $l5)
          (local.get $p2))
        (i64.store offset=16 align=4
          (local.get $l5)
          (i64.load
            (local.get $l5)))
        (call_indirect $T0 (type $t0)
          (i32.load offset=1049300
            (i32.const 0))
          (i32.add
            (local.get $l5)
            (i32.const 16))
          (i32.load offset=20
            (i32.load offset=1049304
              (i32.const 0))))
        (local.set $l6
          (i32.add
            (i32.load offset=1049296
              (i32.const 0))
            (i32.const -1))))
      (i32.store offset=1049296
        (i32.const 0)
        (local.get $l6))
      (i32.store8 offset=1049768
        (i32.const 0)
        (i32.const 0))
      (br_if $B0
        (i32.eqz
          (local.get $p3)))
      (call $rust_panic
        (local.get $p0)
        (local.get $p1)))
    (unreachable))
  (func $rust_panic (type $t0) (param $p0 i32) (param $p1 i32)
    (drop
      (call $__rust_start_panic
        (local.get $p0)
        (local.get $p1)))
    (unreachable))
  (func $__rg_oom (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    (call_indirect $T0 (type $t0)
      (local.get $p1)
      (local.get $p0)
      (select
        (local.tee $l2
          (i32.load offset=1049292
            (i32.const 0)))
        (i32.const 2)
        (local.get $l2)))
    (unreachable))
  (func $__rust_start_panic (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (unreachable))
  (func $_ZN61_$LT$dlmalloc..sys..System$u20$as$u20$dlmalloc..Allocator$GT$5alloc17hf5fdd2c850785749E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32)
    (local.set $l3
      (memory.grow
        (i32.shr_u
          (local.get $p2)
          (i32.const 16))))
    (i32.store offset=8
      (local.get $p0)
      (i32.const 0))
    (i32.store offset=4
      (local.get $p0)
      (select
        (i32.const 0)
        (i32.and
          (local.get $p2)
          (i32.const -65536))
        (local.tee $p2
          (i32.eq
            (local.get $l3)
            (i32.const -1)))))
    (i32.store
      (local.get $p0)
      (select
        (i32.const 0)
        (i32.shl
          (local.get $l3)
          (i32.const 16))
        (local.get $p2))))
  (func $_ZN5alloc7raw_vec17capacity_overflow17hea589cb3c2c0f181E (type $t5)
    (local $l0 i32)
    (global.set $__stack_pointer
      (local.tee $l0
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 32))))
    (i32.store offset=24
      (local.get $l0)
      (i32.const 0))
    (i32.store offset=12
      (local.get $l0)
      (i32.const 1))
    (i32.store offset=8
      (local.get $l0)
      (i32.const 1049004))
    (i64.store offset=16 align=4
      (local.get $l0)
      (i64.const 4))
    (call $_ZN4core9panicking9panic_fmt17h067fb97c138f603dE
      (i32.add
        (local.get $l0)
        (i32.const 8))
      (i32.const 1049032))
    (unreachable))
  (func $_ZN5alloc7raw_vec12handle_error17hf3853b1ce4c4ed17E (type $t0) (param $p0 i32) (param $p1 i32)
    (block $B0
      (br_if $B0
        (local.get $p0))
      (call $_ZN5alloc7raw_vec17capacity_overflow17hea589cb3c2c0f181E)
      (unreachable))
    (call $_ZN5alloc5alloc18handle_alloc_error17hce180d57c01eeed3E
      (local.get $p0)
      (local.get $p1))
    (unreachable))
  (func $_ZN5alloc5alloc18handle_alloc_error17hce180d57c01eeed3E (type $t0) (param $p0 i32) (param $p1 i32)
    (call $__rust_alloc_error_handler
      (local.get $p1)
      (local.get $p0))
    (unreachable))
  (func $_ZN4core9panicking5panic17h9851d4d319da0e79E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 32))))
    (i32.store offset=16
      (local.get $l3)
      (i32.const 0))
    (i32.store offset=4
      (local.get $l3)
      (i32.const 1))
    (i64.store offset=8 align=4
      (local.get $l3)
      (i64.const 4))
    (i32.store offset=28
      (local.get $l3)
      (local.get $p1))
    (i32.store offset=24
      (local.get $l3)
      (local.get $p0))
    (i32.store
      (local.get $l3)
      (i32.add
        (local.get $l3)
        (i32.const 24)))
    (call $_ZN4core9panicking9panic_fmt17h067fb97c138f603dE
      (local.get $l3)
      (local.get $p2))
    (unreachable))
  (func $_ZN4core9panicking9panic_fmt17h067fb97c138f603dE (type $t0) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    (global.set $__stack_pointer
      (local.tee $l2
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (i32.store16 offset=12
      (local.get $l2)
      (i32.const 1))
    (i32.store offset=8
      (local.get $l2)
      (local.get $p1))
    (i32.store offset=4
      (local.get $l2)
      (local.get $p0))
    (call $rust_begin_unwind
      (i32.add
        (local.get $l2)
        (i32.const 4)))
    (unreachable))
  (func $_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$3fmt17h74ae4fc23831434cE (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (call $_ZN4core3fmt3num3imp21_$LT$impl$u20$u32$GT$4_fmt17h1c2522662e3ec3daE
      (i32.load
        (local.get $p0))
      (i32.const 1)
      (local.get $p1)))
  (func $_ZN4core3fmt5write17h298882761c3c0a18E (type $t1) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 48))))
    (i32.store8 offset=44
      (local.get $l3)
      (i32.const 3))
    (i32.store offset=28
      (local.get $l3)
      (i32.const 32))
    (local.set $l4
      (i32.const 0))
    (i32.store offset=40
      (local.get $l3)
      (i32.const 0))
    (i32.store offset=36
      (local.get $l3)
      (local.get $p1))
    (i32.store offset=32
      (local.get $l3)
      (local.get $p0))
    (i32.store offset=20
      (local.get $l3)
      (i32.const 0))
    (i32.store offset=12
      (local.get $l3)
      (i32.const 0))
    (block $B0
      (block $B1
        (block $B2
          (block $B3
            (block $B4
              (br_if $B4
                (local.tee $l5
                  (i32.load offset=16
                    (local.get $p2))))
              (br_if $B3
                (i32.eqz
                  (local.tee $p0
                    (i32.load offset=12
                      (local.get $p2)))))
              (local.set $l6
                (i32.add
                  (local.tee $p1
                    (i32.load offset=8
                      (local.get $p2)))
                  (i32.shl
                    (local.get $p0)
                    (i32.const 3))))
              (local.set $l4
                (i32.add
                  (i32.and
                    (i32.add
                      (local.get $p0)
                      (i32.const -1))
                    (i32.const 536870911))
                  (i32.const 1)))
              (local.set $p0
                (i32.load
                  (local.get $p2)))
              (loop $L5
                (block $B6
                  (br_if $B6
                    (i32.eqz
                      (local.tee $l7
                        (i32.load
                          (i32.add
                            (local.get $p0)
                            (i32.const 4))))))
                  (br_if $B2
                    (call_indirect $T0 (type $t1)
                      (i32.load offset=32
                        (local.get $l3))
                      (i32.load
                        (local.get $p0))
                      (local.get $l7)
                      (i32.load offset=12
                        (i32.load offset=36
                          (local.get $l3))))))
                (br_if $B2
                  (call_indirect $T0 (type $t2)
                    (i32.load
                      (local.get $p1))
                    (i32.add
                      (local.get $l3)
                      (i32.const 12))
                    (i32.load offset=4
                      (local.get $p1))))
                (local.set $p0
                  (i32.add
                    (local.get $p0)
                    (i32.const 8)))
                (br_if $L5
                  (i32.ne
                    (local.tee $p1
                      (i32.add
                        (local.get $p1)
                        (i32.const 8)))
                    (local.get $l6)))
                (br $B3)))
            (br_if $B3
              (i32.eqz
                (local.tee $p1
                  (i32.load offset=20
                    (local.get $p2)))))
            (local.set $l8
              (i32.shl
                (local.get $p1)
                (i32.const 5)))
            (local.set $l4
              (i32.add
                (i32.and
                  (i32.add
                    (local.get $p1)
                    (i32.const -1))
                  (i32.const 134217727))
                (i32.const 1)))
            (local.set $l9
              (i32.load offset=8
                (local.get $p2)))
            (local.set $p0
              (i32.load
                (local.get $p2)))
            (local.set $l7
              (i32.const 0))
            (loop $L7
              (block $B8
                (br_if $B8
                  (i32.eqz
                    (local.tee $p1
                      (i32.load
                        (i32.add
                          (local.get $p0)
                          (i32.const 4))))))
                (br_if $B2
                  (call_indirect $T0 (type $t1)
                    (i32.load offset=32
                      (local.get $l3))
                    (i32.load
                      (local.get $p0))
                    (local.get $p1)
                    (i32.load offset=12
                      (i32.load offset=36
                        (local.get $l3))))))
              (i32.store offset=28
                (local.get $l3)
                (i32.load
                  (i32.add
                    (local.tee $p1
                      (i32.add
                        (local.get $l5)
                        (local.get $l7)))
                    (i32.const 16))))
              (i32.store8 offset=44
                (local.get $l3)
                (i32.load8_u
                  (i32.add
                    (local.get $p1)
                    (i32.const 28))))
              (i32.store offset=40
                (local.get $l3)
                (i32.load
                  (i32.add
                    (local.get $p1)
                    (i32.const 24))))
              (local.set $l6
                (i32.load
                  (i32.add
                    (local.get $p1)
                    (i32.const 12))))
              (local.set $l10
                (i32.const 0))
              (local.set $l11
                (i32.const 0))
              (block $B9
                (block $B10
                  (block $B11
                    (br_table $B10 $B11 $B9 $B10
                      (i32.load
                        (i32.add
                          (local.get $p1)
                          (i32.const 8)))))
                  (local.set $l12
                    (i32.shl
                      (local.get $l6)
                      (i32.const 3)))
                  (local.set $l11
                    (i32.const 0))
                  (br_if $B9
                    (i32.load
                      (local.tee $l12
                        (i32.add
                          (local.get $l9)
                          (local.get $l12)))))
                  (local.set $l6
                    (i32.load offset=4
                      (local.get $l12))))
                (local.set $l11
                  (i32.const 1)))
              (i32.store offset=16
                (local.get $l3)
                (local.get $l6))
              (i32.store offset=12
                (local.get $l3)
                (local.get $l11))
              (local.set $l6
                (i32.load
                  (i32.add
                    (local.get $p1)
                    (i32.const 4))))
              (block $B12
                (block $B13
                  (block $B14
                    (br_table $B13 $B14 $B12 $B13
                      (i32.load
                        (local.get $p1))))
                  (local.set $l11
                    (i32.shl
                      (local.get $l6)
                      (i32.const 3)))
                  (br_if $B12
                    (i32.load
                      (local.tee $l11
                        (i32.add
                          (local.get $l9)
                          (local.get $l11)))))
                  (local.set $l6
                    (i32.load offset=4
                      (local.get $l11))))
                (local.set $l10
                  (i32.const 1)))
              (i32.store offset=24
                (local.get $l3)
                (local.get $l6))
              (i32.store offset=20
                (local.get $l3)
                (local.get $l10))
              (br_if $B2
                (call_indirect $T0 (type $t2)
                  (i32.load
                    (local.tee $p1
                      (i32.add
                        (local.get $l9)
                        (i32.shl
                          (i32.load
                            (i32.add
                              (local.get $p1)
                              (i32.const 20)))
                          (i32.const 3)))))
                  (i32.add
                    (local.get $l3)
                    (i32.const 12))
                  (i32.load offset=4
                    (local.get $p1))))
              (local.set $p0
                (i32.add
                  (local.get $p0)
                  (i32.const 8)))
              (br_if $L7
                (i32.ne
                  (local.get $l8)
                  (local.tee $l7
                    (i32.add
                      (local.get $l7)
                      (i32.const 32)))))))
          (br_if $B1
            (i32.ge_u
              (local.get $l4)
              (i32.load offset=4
                (local.get $p2))))
          (br_if $B1
            (i32.eqz
              (call_indirect $T0 (type $t1)
                (i32.load offset=32
                  (local.get $l3))
                (i32.load
                  (local.tee $p1
                    (i32.add
                      (i32.load
                        (local.get $p2))
                      (i32.shl
                        (local.get $l4)
                        (i32.const 3)))))
                (i32.load offset=4
                  (local.get $p1))
                (i32.load offset=12
                  (i32.load offset=36
                    (local.get $l3)))))))
        (local.set $p1
          (i32.const 1))
        (br $B0))
      (local.set $p1
        (i32.const 0)))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l3)
        (i32.const 48)))
    (local.get $p1))
  (func $_ZN4core3fmt9Formatter12pad_integral17hae04407fd78149bdE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (param $p5 i32) (result i32)
    (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32)
    (block $B0
      (block $B1
        (br_if $B1
          (local.get $p1))
        (local.set $l6
          (i32.add
            (local.get $p5)
            (i32.const 1)))
        (local.set $l7
          (i32.load offset=28
            (local.get $p0)))
        (local.set $l8
          (i32.const 45))
        (br $B0))
      (local.set $l8
        (select
          (i32.const 43)
          (i32.const 1114112)
          (local.tee $p1
            (i32.and
              (local.tee $l7
                (i32.load offset=28
                  (local.get $p0)))
              (i32.const 1)))))
      (local.set $l6
        (i32.add
          (local.get $p1)
          (local.get $p5))))
    (block $B2
      (block $B3
        (br_if $B3
          (i32.and
            (local.get $l7)
            (i32.const 4)))
        (local.set $p2
          (i32.const 0))
        (br $B2))
      (block $B4
        (block $B5
          (br_if $B5
            (i32.lt_u
              (local.get $p3)
              (i32.const 16)))
          (local.set $p1
            (call $_ZN4core3str5count14do_count_chars17h1fd17070321ff5a4E
              (local.get $p2)
              (local.get $p3)))
          (br $B4))
        (block $B6
          (br_if $B6
            (local.get $p3))
          (local.set $p1
            (i32.const 0))
          (br $B4))
        (local.set $l9
          (i32.and
            (local.get $p3)
            (i32.const 3)))
        (block $B7
          (block $B8
            (br_if $B8
              (i32.ge_u
                (local.get $p3)
                (i32.const 4)))
            (local.set $p1
              (i32.const 0))
            (local.set $l10
              (i32.const 0))
            (br $B7))
          (local.set $l11
            (i32.and
              (local.get $p3)
              (i32.const 12)))
          (local.set $p1
            (i32.const 0))
          (local.set $l10
            (i32.const 0))
          (loop $L9
            (local.set $p1
              (i32.add
                (i32.add
                  (i32.add
                    (i32.add
                      (local.get $p1)
                      (i32.gt_s
                        (i32.load8_s
                          (local.tee $l12
                            (i32.add
                              (local.get $p2)
                              (local.get $l10))))
                        (i32.const -65)))
                    (i32.gt_s
                      (i32.load8_s
                        (i32.add
                          (local.get $l12)
                          (i32.const 1)))
                      (i32.const -65)))
                  (i32.gt_s
                    (i32.load8_s
                      (i32.add
                        (local.get $l12)
                        (i32.const 2)))
                    (i32.const -65)))
                (i32.gt_s
                  (i32.load8_s
                    (i32.add
                      (local.get $l12)
                      (i32.const 3)))
                  (i32.const -65))))
            (br_if $L9
              (i32.ne
                (local.get $l11)
                (local.tee $l10
                  (i32.add
                    (local.get $l10)
                    (i32.const 4)))))))
        (br_if $B4
          (i32.eqz
            (local.get $l9)))
        (local.set $l12
          (i32.add
            (local.get $p2)
            (local.get $l10)))
        (loop $L10
          (local.set $p1
            (i32.add
              (local.get $p1)
              (i32.gt_s
                (i32.load8_s
                  (local.get $l12))
                (i32.const -65))))
          (local.set $l12
            (i32.add
              (local.get $l12)
              (i32.const 1)))
          (br_if $L10
            (local.tee $l9
              (i32.add
                (local.get $l9)
                (i32.const -1))))))
      (local.set $l6
        (i32.add
          (local.get $p1)
          (local.get $l6))))
    (block $B11
      (br_if $B11
        (i32.load
          (local.get $p0)))
      (block $B12
        (br_if $B12
          (i32.eqz
            (call $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h7f483018a4cc8ab7E
              (local.tee $p1
                (i32.load offset=20
                  (local.get $p0)))
              (local.tee $l12
                (i32.load offset=24
                  (local.get $p0)))
              (local.get $l8)
              (local.get $p2)
              (local.get $p3))))
        (return
          (i32.const 1)))
      (return
        (call_indirect $T0 (type $t1)
          (local.get $p1)
          (local.get $p4)
          (local.get $p5)
          (i32.load offset=12
            (local.get $l12)))))
    (block $B13
      (block $B14
        (block $B15
          (block $B16
            (br_if $B16
              (i32.gt_u
                (local.tee $p1
                  (i32.load offset=4
                    (local.get $p0)))
                (local.get $l6)))
            (br_if $B15
              (i32.eqz
                (call $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h7f483018a4cc8ab7E
                  (local.tee $p1
                    (i32.load offset=20
                      (local.get $p0)))
                  (local.tee $l12
                    (i32.load offset=24
                      (local.get $p0)))
                  (local.get $l8)
                  (local.get $p2)
                  (local.get $p3))))
            (return
              (i32.const 1)))
          (br_if $B14
            (i32.eqz
              (i32.and
                (local.get $l7)
                (i32.const 8))))
          (local.set $l9
            (i32.load offset=16
              (local.get $p0)))
          (i32.store offset=16
            (local.get $p0)
            (i32.const 48))
          (local.set $l7
            (i32.load8_u offset=32
              (local.get $p0)))
          (local.set $l11
            (i32.const 1))
          (i32.store8 offset=32
            (local.get $p0)
            (i32.const 1))
          (br_if $B13
            (call $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h7f483018a4cc8ab7E
              (local.tee $l12
                (i32.load offset=20
                  (local.get $p0)))
              (local.tee $l10
                (i32.load offset=24
                  (local.get $p0)))
              (local.get $l8)
              (local.get $p2)
              (local.get $p3)))
          (local.set $p1
            (i32.add
              (i32.sub
                (local.get $p1)
                (local.get $l6))
              (i32.const 1)))
          (block $B17
            (loop $L18
              (br_if $B17
                (i32.eqz
                  (local.tee $p1
                    (i32.add
                      (local.get $p1)
                      (i32.const -1)))))
              (br_if $L18
                (i32.eqz
                  (call_indirect $T0 (type $t2)
                    (local.get $l12)
                    (i32.const 48)
                    (i32.load offset=16
                      (local.get $l10))))))
            (return
              (i32.const 1)))
          (block $B19
            (br_if $B19
              (i32.eqz
                (call_indirect $T0 (type $t1)
                  (local.get $l12)
                  (local.get $p4)
                  (local.get $p5)
                  (i32.load offset=12
                    (local.get $l10)))))
            (return
              (i32.const 1)))
          (i32.store8 offset=32
            (local.get $p0)
            (local.get $l7))
          (i32.store offset=16
            (local.get $p0)
            (local.get $l9))
          (return
            (i32.const 0)))
        (local.set $l11
          (call_indirect $T0 (type $t1)
            (local.get $p1)
            (local.get $p4)
            (local.get $p5)
            (i32.load offset=12
              (local.get $l12))))
        (br $B13))
      (local.set $l6
        (i32.sub
          (local.get $p1)
          (local.get $l6)))
      (block $B20
        (block $B21
          (block $B22
            (br_table $B20 $B22 $B21 $B22 $B20
              (local.tee $p1
                (i32.load8_u offset=32
                  (local.get $p0)))))
          (local.set $p1
            (local.get $l6))
          (local.set $l6
            (i32.const 0))
          (br $B20))
        (local.set $p1
          (i32.shr_u
            (local.get $l6)
            (i32.const 1)))
        (local.set $l6
          (i32.shr_u
            (i32.add
              (local.get $l6)
              (i32.const 1))
            (i32.const 1))))
      (local.set $p1
        (i32.add
          (local.get $p1)
          (i32.const 1)))
      (local.set $l9
        (i32.load offset=16
          (local.get $p0)))
      (local.set $l12
        (i32.load offset=24
          (local.get $p0)))
      (local.set $l10
        (i32.load offset=20
          (local.get $p0)))
      (block $B23
        (loop $L24
          (br_if $B23
            (i32.eqz
              (local.tee $p1
                (i32.add
                  (local.get $p1)
                  (i32.const -1)))))
          (br_if $L24
            (i32.eqz
              (call_indirect $T0 (type $t2)
                (local.get $l10)
                (local.get $l9)
                (i32.load offset=16
                  (local.get $l12))))))
        (return
          (i32.const 1)))
      (local.set $l11
        (i32.const 1))
      (br_if $B13
        (call $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h7f483018a4cc8ab7E
          (local.get $l10)
          (local.get $l12)
          (local.get $l8)
          (local.get $p2)
          (local.get $p3)))
      (br_if $B13
        (call_indirect $T0 (type $t1)
          (local.get $l10)
          (local.get $p4)
          (local.get $p5)
          (i32.load offset=12
            (local.get $l12))))
      (local.set $p1
        (i32.const 0))
      (loop $L25
        (block $B26
          (br_if $B26
            (i32.ne
              (local.get $l6)
              (local.get $p1)))
          (return
            (i32.lt_u
              (local.get $l6)
              (local.get $l6))))
        (local.set $p1
          (i32.add
            (local.get $p1)
            (i32.const 1)))
        (br_if $L25
          (i32.eqz
            (call_indirect $T0 (type $t2)
              (local.get $l10)
              (local.get $l9)
              (i32.load offset=16
                (local.get $l12))))))
      (return
        (i32.lt_u
          (i32.add
            (local.get $p1)
            (i32.const -1))
          (local.get $l6))))
    (local.get $l11))
  (func $_ZN4core3str5count14do_count_chars17h1fd17070321ff5a4E (type $t2) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    (block $B0
      (block $B1
        (br_if $B1
          (i32.lt_u
            (local.get $p1)
            (local.tee $l3
              (i32.sub
                (local.tee $l2
                  (i32.and
                    (i32.add
                      (local.get $p0)
                      (i32.const 3))
                    (i32.const -4)))
                (local.get $p0)))))
        (br_if $B1
          (i32.lt_u
            (local.tee $l4
              (i32.sub
                (local.get $p1)
                (local.get $l3)))
            (i32.const 4)))
        (local.set $l5
          (i32.and
            (local.get $l4)
            (i32.const 3)))
        (local.set $l6
          (i32.const 0))
        (local.set $p1
          (i32.const 0))
        (block $B2
          (br_if $B2
            (local.tee $l7
              (i32.eq
                (local.get $l2)
                (local.get $p0))))
          (local.set $p1
            (i32.const 0))
          (block $B3
            (block $B4
              (br_if $B4
                (i32.le_u
                  (local.tee $l8
                    (i32.sub
                      (local.get $p0)
                      (local.get $l2)))
                  (i32.const -4)))
              (local.set $l9
                (i32.const 0))
              (br $B3))
            (local.set $l9
              (i32.const 0))
            (loop $L5
              (local.set $p1
                (i32.add
                  (i32.add
                    (i32.add
                      (i32.add
                        (local.get $p1)
                        (i32.gt_s
                          (i32.load8_s
                            (local.tee $l2
                              (i32.add
                                (local.get $p0)
                                (local.get $l9))))
                          (i32.const -65)))
                      (i32.gt_s
                        (i32.load8_s
                          (i32.add
                            (local.get $l2)
                            (i32.const 1)))
                        (i32.const -65)))
                    (i32.gt_s
                      (i32.load8_s
                        (i32.add
                          (local.get $l2)
                          (i32.const 2)))
                      (i32.const -65)))
                  (i32.gt_s
                    (i32.load8_s
                      (i32.add
                        (local.get $l2)
                        (i32.const 3)))
                    (i32.const -65))))
              (br_if $L5
                (local.tee $l9
                  (i32.add
                    (local.get $l9)
                    (i32.const 4))))))
          (br_if $B2
            (local.get $l7))
          (local.set $l2
            (i32.add
              (local.get $p0)
              (local.get $l9)))
          (loop $L6
            (local.set $p1
              (i32.add
                (local.get $p1)
                (i32.gt_s
                  (i32.load8_s
                    (local.get $l2))
                  (i32.const -65))))
            (local.set $l2
              (i32.add
                (local.get $l2)
                (i32.const 1)))
            (br_if $L6
              (local.tee $l8
                (i32.add
                  (local.get $l8)
                  (i32.const 1))))))
        (local.set $l9
          (i32.add
            (local.get $p0)
            (local.get $l3)))
        (block $B7
          (br_if $B7
            (i32.eqz
              (local.get $l5)))
          (local.set $l6
            (i32.gt_s
              (i32.load8_s
                (local.tee $l2
                  (i32.add
                    (local.get $l9)
                    (i32.and
                      (local.get $l4)
                      (i32.const -4)))))
              (i32.const -65)))
          (br_if $B7
            (i32.eq
              (local.get $l5)
              (i32.const 1)))
          (local.set $l6
            (i32.add
              (local.get $l6)
              (i32.gt_s
                (i32.load8_s offset=1
                  (local.get $l2))
                (i32.const -65))))
          (br_if $B7
            (i32.eq
              (local.get $l5)
              (i32.const 2)))
          (local.set $l6
            (i32.add
              (local.get $l6)
              (i32.gt_s
                (i32.load8_s offset=2
                  (local.get $l2))
                (i32.const -65)))))
        (local.set $l3
          (i32.shr_u
            (local.get $l4)
            (i32.const 2)))
        (local.set $l8
          (i32.add
            (local.get $l6)
            (local.get $p1)))
        (loop $L8
          (local.set $l4
            (local.get $l9))
          (br_if $B0
            (i32.eqz
              (local.get $l3)))
          (local.set $l7
            (i32.and
              (local.tee $l6
                (select
                  (local.get $l3)
                  (i32.const 192)
                  (i32.lt_u
                    (local.get $l3)
                    (i32.const 192))))
              (i32.const 3)))
          (local.set $l5
            (i32.shl
              (local.get $l6)
              (i32.const 2)))
          (local.set $l2
            (i32.const 0))
          (block $B9
            (br_if $B9
              (i32.lt_u
                (local.get $l3)
                (i32.const 4)))
            (local.set $p0
              (i32.add
                (local.get $l4)
                (i32.and
                  (local.get $l5)
                  (i32.const 1008))))
            (local.set $l2
              (i32.const 0))
            (local.set $p1
              (local.get $l4))
            (loop $L10
              (local.set $l2
                (i32.add
                  (i32.and
                    (i32.or
                      (i32.shr_u
                        (i32.xor
                          (local.tee $l9
                            (i32.load offset=12
                              (local.get $p1)))
                          (i32.const -1))
                        (i32.const 7))
                      (i32.shr_u
                        (local.get $l9)
                        (i32.const 6)))
                    (i32.const 16843009))
                  (i32.add
                    (i32.and
                      (i32.or
                        (i32.shr_u
                          (i32.xor
                            (local.tee $l9
                              (i32.load offset=8
                                (local.get $p1)))
                            (i32.const -1))
                          (i32.const 7))
                        (i32.shr_u
                          (local.get $l9)
                          (i32.const 6)))
                      (i32.const 16843009))
                    (i32.add
                      (i32.and
                        (i32.or
                          (i32.shr_u
                            (i32.xor
                              (local.tee $l9
                                (i32.load offset=4
                                  (local.get $p1)))
                              (i32.const -1))
                            (i32.const 7))
                          (i32.shr_u
                            (local.get $l9)
                            (i32.const 6)))
                        (i32.const 16843009))
                      (i32.add
                        (i32.and
                          (i32.or
                            (i32.shr_u
                              (i32.xor
                                (local.tee $l9
                                  (i32.load
                                    (local.get $p1)))
                                (i32.const -1))
                              (i32.const 7))
                            (i32.shr_u
                              (local.get $l9)
                              (i32.const 6)))
                          (i32.const 16843009))
                        (local.get $l2))))))
              (br_if $L10
                (i32.ne
                  (local.tee $p1
                    (i32.add
                      (local.get $p1)
                      (i32.const 16)))
                  (local.get $p0)))))
          (local.set $l3
            (i32.sub
              (local.get $l3)
              (local.get $l6)))
          (local.set $l9
            (i32.add
              (local.get $l4)
              (local.get $l5)))
          (local.set $l8
            (i32.add
              (i32.shr_u
                (i32.mul
                  (i32.add
                    (i32.and
                      (i32.shr_u
                        (local.get $l2)
                        (i32.const 8))
                      (i32.const 16711935))
                    (i32.and
                      (local.get $l2)
                      (i32.const 16711935)))
                  (i32.const 65537))
                (i32.const 16))
              (local.get $l8)))
          (br_if $L8
            (i32.eqz
              (local.get $l7))))
        (local.set $p1
          (i32.and
            (i32.or
              (i32.shr_u
                (i32.xor
                  (local.tee $p1
                    (i32.load
                      (local.tee $l2
                        (i32.add
                          (local.get $l4)
                          (i32.shl
                            (i32.and
                              (local.get $l6)
                              (i32.const 252))
                            (i32.const 2))))))
                  (i32.const -1))
                (i32.const 7))
              (i32.shr_u
                (local.get $p1)
                (i32.const 6)))
            (i32.const 16843009)))
        (block $B11
          (br_if $B11
            (i32.eq
              (local.get $l7)
              (i32.const 1)))
          (local.set $p1
            (i32.add
              (i32.and
                (i32.or
                  (i32.shr_u
                    (i32.xor
                      (local.tee $l9
                        (i32.load offset=4
                          (local.get $l2)))
                      (i32.const -1))
                    (i32.const 7))
                  (i32.shr_u
                    (local.get $l9)
                    (i32.const 6)))
                (i32.const 16843009))
              (local.get $p1)))
          (br_if $B11
            (i32.eq
              (local.get $l7)
              (i32.const 2)))
          (local.set $p1
            (i32.add
              (i32.and
                (i32.or
                  (i32.shr_u
                    (i32.xor
                      (local.tee $l2
                        (i32.load offset=8
                          (local.get $l2)))
                      (i32.const -1))
                    (i32.const 7))
                  (i32.shr_u
                    (local.get $l2)
                    (i32.const 6)))
                (i32.const 16843009))
              (local.get $p1))))
        (return
          (i32.add
            (i32.shr_u
              (i32.mul
                (i32.add
                  (i32.and
                    (i32.shr_u
                      (local.get $p1)
                      (i32.const 8))
                    (i32.const 459007))
                  (i32.and
                    (local.get $p1)
                    (i32.const 16711935)))
                (i32.const 65537))
              (i32.const 16))
            (local.get $l8))))
      (block $B12
        (br_if $B12
          (local.get $p1))
        (return
          (i32.const 0)))
      (local.set $l9
        (i32.and
          (local.get $p1)
          (i32.const 3)))
      (block $B13
        (block $B14
          (br_if $B14
            (i32.ge_u
              (local.get $p1)
              (i32.const 4)))
          (local.set $l8
            (i32.const 0))
          (local.set $l2
            (i32.const 0))
          (br $B13))
        (local.set $l3
          (i32.and
            (local.get $p1)
            (i32.const -4)))
        (local.set $l8
          (i32.const 0))
        (local.set $l2
          (i32.const 0))
        (loop $L15
          (local.set $l8
            (i32.add
              (i32.add
                (i32.add
                  (i32.add
                    (local.get $l8)
                    (i32.gt_s
                      (i32.load8_s
                        (local.tee $p1
                          (i32.add
                            (local.get $p0)
                            (local.get $l2))))
                      (i32.const -65)))
                  (i32.gt_s
                    (i32.load8_s
                      (i32.add
                        (local.get $p1)
                        (i32.const 1)))
                    (i32.const -65)))
                (i32.gt_s
                  (i32.load8_s
                    (i32.add
                      (local.get $p1)
                      (i32.const 2)))
                  (i32.const -65)))
              (i32.gt_s
                (i32.load8_s
                  (i32.add
                    (local.get $p1)
                    (i32.const 3)))
                (i32.const -65))))
          (br_if $L15
            (i32.ne
              (local.get $l3)
              (local.tee $l2
                (i32.add
                  (local.get $l2)
                  (i32.const 4)))))))
      (br_if $B0
        (i32.eqz
          (local.get $l9)))
      (local.set $p1
        (i32.add
          (local.get $p0)
          (local.get $l2)))
      (loop $L16
        (local.set $l8
          (i32.add
            (local.get $l8)
            (i32.gt_s
              (i32.load8_s
                (local.get $p1))
              (i32.const -65))))
        (local.set $p1
          (i32.add
            (local.get $p1)
            (i32.const 1)))
        (br_if $L16
          (local.tee $l9
            (i32.add
              (local.get $l9)
              (i32.const -1))))))
    (local.get $l8))
  (func $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h7f483018a4cc8ab7E (type $t11) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (result i32)
    (block $B0
      (br_if $B0
        (i32.eq
          (local.get $p2)
          (i32.const 1114112)))
      (br_if $B0
        (i32.eqz
          (call_indirect $T0 (type $t2)
            (local.get $p0)
            (local.get $p2)
            (i32.load offset=16
              (local.get $p1)))))
      (return
        (i32.const 1)))
    (block $B1
      (br_if $B1
        (local.get $p3))
      (return
        (i32.const 0)))
    (call_indirect $T0 (type $t1)
      (local.get $p0)
      (local.get $p3)
      (local.get $p4)
      (i32.load offset=12
        (local.get $p1))))
  (func $_ZN4core3fmt9Formatter9write_str17h07cdad31e426547dE (type $t1) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (call_indirect $T0 (type $t1)
      (i32.load offset=20
        (local.get $p0))
      (local.get $p1)
      (local.get $p2)
      (i32.load offset=12
        (i32.load offset=24
          (local.get $p0)))))
  (func $_ZN4core9panicking11panic_const24panic_const_add_overflow17h76ec5bef6e5a6f3eE (type $t3) (param $p0 i32)
    (local $l1 i32)
    (global.set $__stack_pointer
      (local.tee $l1
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 32))))
    (i32.store offset=24
      (local.get $l1)
      (i32.const 0))
    (i32.store offset=12
      (local.get $l1)
      (i32.const 1))
    (i32.store offset=8
      (local.get $l1)
      (i32.const 1049076))
    (i64.store offset=16 align=4
      (local.get $l1)
      (i64.const 4))
    (call $_ZN4core9panicking9panic_fmt17h067fb97c138f603dE
      (i32.add
        (local.get $l1)
        (i32.const 8))
      (local.get $p0))
    (unreachable))
  (func $_ZN4core3fmt3num3imp21_$LT$impl$u20$u32$GT$4_fmt17h1c2522662e3ec3daE (type $t1) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (local.set $l4
      (i32.const 10))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.ge_u
            (local.get $p0)
            (i32.const 10000)))
        (local.set $l5
          (local.get $p0))
        (br $B0))
      (local.set $l4
        (i32.const 10))
      (loop $L2
        (i32.store16 align=1
          (i32.add
            (local.tee $l6
              (i32.add
                (i32.add
                  (local.get $l3)
                  (i32.const 6))
                (local.get $l4)))
            (i32.const -4))
          (i32.load16_u align=1
            (i32.add
              (i32.shl
                (local.tee $l8
                  (i32.div_u
                    (i32.and
                      (local.tee $l7
                        (i32.sub
                          (local.get $p0)
                          (i32.mul
                            (local.tee $l5
                              (i32.div_u
                                (local.get $p0)
                                (i32.const 10000)))
                            (i32.const 10000))))
                      (i32.const 65535))
                    (i32.const 100)))
                (i32.const 1))
              (i32.const 1049084))))
        (i32.store16 align=1
          (i32.add
            (local.get $l6)
            (i32.const -2))
          (i32.load16_u align=1
            (i32.add
              (i32.shl
                (i32.and
                  (i32.sub
                    (local.get $l7)
                    (i32.mul
                      (local.get $l8)
                      (i32.const 100)))
                  (i32.const 65535))
                (i32.const 1))
              (i32.const 1049084))))
        (local.set $l4
          (i32.add
            (local.get $l4)
            (i32.const -4)))
        (local.set $l6
          (i32.gt_u
            (local.get $p0)
            (i32.const 99999999)))
        (local.set $p0
          (local.get $l5))
        (br_if $L2
          (local.get $l6))))
    (block $B3
      (block $B4
        (br_if $B4
          (i32.gt_u
            (local.get $l5)
            (i32.const 99)))
        (local.set $p0
          (local.get $l5))
        (br $B3))
      (i32.store16 align=1
        (i32.add
          (i32.add
            (local.get $l3)
            (i32.const 6))
          (local.tee $l4
            (i32.add
              (local.get $l4)
              (i32.const -2))))
        (i32.load16_u align=1
          (i32.add
            (i32.shl
              (i32.and
                (i32.sub
                  (local.get $l5)
                  (i32.mul
                    (local.tee $p0
                      (i32.div_u
                        (i32.and
                          (local.get $l5)
                          (i32.const 65535))
                        (i32.const 100)))
                    (i32.const 100)))
                (i32.const 65535))
              (i32.const 1))
            (i32.const 1049084)))))
    (block $B5
      (block $B6
        (br_if $B6
          (i32.lt_u
            (local.get $p0)
            (i32.const 10)))
        (i32.store16 align=1
          (i32.add
            (i32.add
              (local.get $l3)
              (i32.const 6))
            (local.tee $l4
              (i32.add
                (local.get $l4)
                (i32.const -2))))
          (i32.load16_u align=1
            (i32.add
              (i32.shl
                (local.get $p0)
                (i32.const 1))
              (i32.const 1049084))))
        (br $B5))
      (i32.store8
        (i32.add
          (i32.add
            (local.get $l3)
            (i32.const 6))
          (local.tee $l4
            (i32.add
              (local.get $l4)
              (i32.const -1))))
        (i32.or
          (local.get $p0)
          (i32.const 48))))
    (local.set $p0
      (call $_ZN4core3fmt9Formatter12pad_integral17hae04407fd78149bdE
        (local.get $p2)
        (local.get $p1)
        (i32.const 1)
        (i32.const 0)
        (i32.add
          (i32.add
            (local.get $l3)
            (i32.const 6))
          (local.get $l4))
        (i32.sub
          (i32.const 10)
          (local.get $l4))))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l3)
        (i32.const 16)))
    (local.get $p0))
  (func $memcpy (type $t1) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32)
    (block $B0
      (block $B1
        (br_if $B1
          (i32.ge_u
            (local.get $p2)
            (i32.const 16)))
        (local.set $l3
          (local.get $p0))
        (br $B0))
      (local.set $l5
        (i32.add
          (local.get $p0)
          (local.tee $l4
            (i32.and
              (i32.sub
                (i32.const 0)
                (local.get $p0))
              (i32.const 3)))))
      (block $B2
        (br_if $B2
          (i32.eqz
            (local.get $l4)))
        (local.set $l3
          (local.get $p0))
        (local.set $l6
          (local.get $p1))
        (loop $L3
          (i32.store8
            (local.get $l3)
            (i32.load8_u
              (local.get $l6)))
          (local.set $l6
            (i32.add
              (local.get $l6)
              (i32.const 1)))
          (br_if $L3
            (i32.lt_u
              (local.tee $l3
                (i32.add
                  (local.get $l3)
                  (i32.const 1)))
              (local.get $l5)))))
      (local.set $l3
        (i32.add
          (local.get $l5)
          (local.tee $l8
            (i32.and
              (local.tee $l7
                (i32.sub
                  (local.get $p2)
                  (local.get $l4)))
              (i32.const -4)))))
      (block $B4
        (block $B5
          (br_if $B5
            (i32.eqz
              (i32.and
                (local.tee $l9
                  (i32.add
                    (local.get $p1)
                    (local.get $l4)))
                (i32.const 3))))
          (br_if $B4
            (i32.lt_s
              (local.get $l8)
              (i32.const 1)))
          (local.set $p2
            (i32.and
              (local.tee $l6
                (i32.shl
                  (local.get $l9)
                  (i32.const 3)))
              (i32.const 24)))
          (local.set $p1
            (i32.add
              (local.tee $l10
                (i32.and
                  (local.get $l9)
                  (i32.const -4)))
              (i32.const 4)))
          (local.set $l4
            (i32.and
              (i32.sub
                (i32.const 0)
                (local.get $l6))
              (i32.const 24)))
          (local.set $l6
            (i32.load
              (local.get $l10)))
          (loop $L6
            (i32.store
              (local.get $l5)
              (i32.or
                (i32.shr_u
                  (local.get $l6)
                  (local.get $p2))
                (i32.shl
                  (local.tee $l6
                    (i32.load
                      (local.get $p1)))
                  (local.get $l4))))
            (local.set $p1
              (i32.add
                (local.get $p1)
                (i32.const 4)))
            (br_if $L6
              (i32.lt_u
                (local.tee $l5
                  (i32.add
                    (local.get $l5)
                    (i32.const 4)))
                (local.get $l3)))
            (br $B4)))
        (br_if $B4
          (i32.lt_s
            (local.get $l8)
            (i32.const 1)))
        (local.set $p1
          (local.get $l9))
        (loop $L7
          (i32.store
            (local.get $l5)
            (i32.load
              (local.get $p1)))
          (local.set $p1
            (i32.add
              (local.get $p1)
              (i32.const 4)))
          (br_if $L7
            (i32.lt_u
              (local.tee $l5
                (i32.add
                  (local.get $l5)
                  (i32.const 4)))
              (local.get $l3)))))
      (local.set $p2
        (i32.and
          (local.get $l7)
          (i32.const 3)))
      (local.set $p1
        (i32.add
          (local.get $l9)
          (local.get $l8))))
    (block $B8
      (br_if $B8
        (i32.eqz
          (local.get $p2)))
      (local.set $l5
        (i32.add
          (local.get $l3)
          (local.get $p2)))
      (loop $L9
        (i32.store8
          (local.get $l3)
          (i32.load8_u
            (local.get $p1)))
        (local.set $p1
          (i32.add
            (local.get $p1)
            (i32.const 1)))
        (br_if $L9
          (i32.lt_u
            (local.tee $l3
              (i32.add
                (local.get $l3)
                (i32.const 1)))
            (local.get $l5)))))
    (local.get $p0))
  (table $T0 18 18 funcref)
  (memory $memory (export "memory") 17)
  (global $__stack_pointer (mut i32) (i32.const 1048576))
  (global $A (export "A") i32 (i32.const 1049284))
  (global $__data_end (export "__data_end") i32 (i32.const 1049769))
  (global $__heap_base (export "__heap_base") i32 (i32.const 1049776))
  (elem $e0 (i32.const 1) func $_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$3fmt17h74ae4fc23831434cE $_ZN3std5alloc24default_alloc_error_hook17h858a662c91e8db67E $_ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17hcbd303fab6b1dcf7E $_ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$9write_str17hf0fb92960288353aE $_ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$10write_char17h3b4d45a179ad00f2E $_ZN4core3fmt5Write9write_fmt17h0e60a00aadf60017E $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17hde63666261ad548fE $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h229dd4e49c45a9d9E $_ZN92_$LT$std..panicking..begin_panic_handler..StaticStrPayload$u20$as$u20$core..fmt..Display$GT$3fmt17h8c7501c69f0d32a6E $_ZN99_$LT$std..panicking..begin_panic_handler..StaticStrPayload$u20$as$u20$core..panic..PanicPayload$GT$8take_box17h0880b9f8a9aad3e3E $_ZN99_$LT$std..panicking..begin_panic_handler..StaticStrPayload$u20$as$u20$core..panic..PanicPayload$GT$3get17h6a831050ede36d61E $_ZN99_$LT$std..panicking..begin_panic_handler..StaticStrPayload$u20$as$u20$core..panic..PanicPayload$GT$6as_str17hf8625a0e1d276a5eE $_ZN4core3ptr77drop_in_place$LT$std..panicking..begin_panic_handler..FormatStringPayload$GT$17h3cfdc40d9ec2a053E $_ZN95_$LT$std..panicking..begin_panic_handler..FormatStringPayload$u20$as$u20$core..fmt..Display$GT$3fmt17hc6b149a08104ba5cE $_ZN102_$LT$std..panicking..begin_panic_handler..FormatStringPayload$u20$as$u20$core..panic..PanicPayload$GT$8take_box17h0974c4d840e18588E $_ZN102_$LT$std..panicking..begin_panic_handler..FormatStringPayload$u20$as$u20$core..panic..PanicPayload$GT$3get17hcf9e5ec89c6f5452E $_ZN4core5panic12PanicPayload6as_str17h3f59927b7c7bd59eE)
  (data $.rodata (i32.const 1048576) "src/lib.rs\00\00\00\00\10\00\0a\00\00\00\1a\00\00\00\05\00\00\00\00\00\10\00\0a\00\00\00\1f\00\00\00\0c\00\00\00\03\00\00\00\0c\00\00\00\04\00\00\00\04\00\00\00\05\00\00\00\06\00\00\00/rust/deps/dlmalloc-0.2.6/src/dlmalloc.rsassertion failed: psize >= size + min_overhead\00D\00\10\00)\00\00\00\a8\04\00\00\09\00\00\00assertion failed: psize <= size + max_overhead\00\00D\00\10\00)\00\00\00\ae\04\00\00\0d\00\00\00memory allocation of  bytes failed\00\00\ec\00\10\00\15\00\00\00\01\01\10\00\0d\00\00\00std/src/alloc.rs \01\10\00\10\00\00\00c\01\00\00\09\00\00\00\03\00\00\00\0c\00\00\00\04\00\00\00\07\00\00\00\00\00\00\00\08\00\00\00\04\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\04\00\00\00\09\00\00\00\0a\00\00\00\0b\00\00\00\0c\00\00\00\0d\00\00\00\10\00\00\00\04\00\00\00\0e\00\00\00\0f\00\00\00\10\00\00\00\11\00\00\00capacity overflow\00\00\00\98\01\10\00\11\00\00\00alloc/src/raw_vec.rs\b4\01\10\00\14\00\00\00\18\00\00\00\05\00\00\00attempt to add with overflow\d8\01\10\00\1c\00\00\0000010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899"))
