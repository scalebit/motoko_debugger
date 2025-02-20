(module
  (type (;0;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;1;) (func (param i32 i32 i32)))
  (type (;2;) (func (param i32 i32 i32) (result i32)))
  (type (;3;) (func (result i32)))
  (type (;4;) (func (param i32 i32 i32 i32)))
  (type (;5;) (func (param i32) (result i32)))
  (type (;6;) (func (param i32 i32) (result i32)))
  (type (;7;) (func (param i64) (result i32)))
  (type (;8;) (func (param i32) (result i64)))
  (type (;9;) (func (param i32 i32)))
  (type (;10;) (func (param i32)))
  (type (;11;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;12;) (func (param f64 f64) (result f64)))
  (type (;13;) (func (param f64) (result f64)))
  (type (;14;) (func (param f64) (result i32)))
  (type (;15;) (func))
  (type (;16;) (func (param i64 i64) (result i64)))
  (type (;17;) (func (result i32)))
  (type (;18;) (func (param i32 i32 i32) (result i32)))
  (type (;19;) (func (param i32) (result i32)))
  (type (;20;) (func (param i32 i32)))
  (type (;21;) (func))
  (type (;22;) (func (param i32 i32 i32)))
  (type (;23;) (func (param i32)))
  (type (;24;) (func (param i32 i32 i32 i32)))
  (type (;25;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;26;) (func (param i32 i32) (result i32)))
  (type (;27;) (func (param i32) (result i64)))
  (type (;28;) (func (param i64) (result i32)))
  (type (;29;) (func (param f64) (result i32)))
  (type (;30;) (func (param f64 f64) (result f64)))
  (type (;31;) (func (param f64) (result f64)))
  (type (;32;) (func (param i32 i64)))
  (type (;33;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;34;) (func (param f64 i32) (result f64)))
  (type (;35;) (func (param i32 i32 i32 i32 i32)))
  (type (;36;) (func (param i64 i32) (result i32)))
  (type (;37;) (func (param i32) (result f64)))
  (type (;38;) (func (param i32 f64) (result f64)))
  (type (;39;) (func (param f64 i32) (result i32)))
  (type (;40;) (func (param f64 f64 i32) (result f64)))
  (type (;41;) (func))
  (import "wasi_unstable" "fd_write" (func (;0;) (type 0)))
  (func $alloc_bytes (type 5) (param $n i32) (result i32)
    local.get $n
    i32.const 3
    i32.add
    i32.const 4
    i32.div_u
    call $alloc_words)
  (func $alloc_words (type 5) (param $n i32) (result i32)
    global.get 0
    i32.const -1
    i32.add
    local.get $n
    i32.const 4
    i32.mul
    i64.extend_i32_u
    global.get 1
    i64.add
    global.set 1
    global.get 0
    local.get $n
    i32.const 4
    i32.mul
    i32.add
    global.set 0
    global.get 0
    call $grow_memory)
  (func $grow_memory (type 10) (param $ptr i32)
    (local $pages_needed i32)
    local.get $ptr
    i32.const 65536
    i32.div_u
    i32.const 1
    i32.add
    memory.size
    i32.sub
    local.tee $pages_needed
    i32.const 0
    i32.gt_s
    if  ;; label = @1
      local.get $pages_needed
      memory.grow
      i32.const 0
      i32.lt_s
      if  ;; label = @2
        i32.const 65540
        i32.const 19
        call $print_ptr
        unreachable
      end
    end)
  (func $print_ptr (type 9) (param $ptr i32) (param $len i32)
    (local $io_vec i32)
    global.get 4
    i32.const 24
    i32.sub
    global.set 4
    global.get 4
    local.tee $io_vec
    local.get $ptr
    i32.store
    local.get $io_vec
    local.get $len
    i32.store offset=4
    local.get $io_vec
    local.get $io_vec
    i32.const 16
    i32.add
    i32.store offset=8
    local.get $io_vec
    i32.const 1
    i32.store offset=12
    local.get $io_vec
    i32.const 10
    i32.store8 offset=16
    i32.const 1
    local.get $io_vec
    i32.const 1
    local.get $io_vec
    i32.const 20
    i32.add
    call 0
    drop
    i32.const 1
    local.get $io_vec
    i32.const 8
    i32.add
    i32.const 1
    local.get $io_vec
    i32.const 20
    i32.add
    call 0
    drop
    global.get 4
    i32.const 24
    i32.add
    global.set 4)
  (func $bigint_trap (type 15)
    i32.const 65560
    i32.const 21
    call $print_ptr
    unreachable)
  (func $rts_trap (type 9) (param $str i32) (param $len i32)
    local.get $str
    local.get $len
    call $print_ptr
    unreachable)
  (func $@immut_array_get (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-44.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-44.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-44.3_clos
    i32.const 27
    i32.store offset=5
    local.get $anon-func-44.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-44.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-44.3_clos)
  (func $@mut_array_get (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-46.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-46.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-46.3_clos
    i32.const 26
    i32.store offset=5
    local.get $anon-func-46.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-46.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-46.3_clos)
  (func $@immut_array_size (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-48.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-48.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-48.3_clos
    i32.const 25
    i32.store offset=5
    local.get $anon-func-48.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-48.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-48.3_clos)
  (func $@mut_array_size (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-50.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-50.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-50.3_clos
    i32.const 24
    i32.store offset=5
    local.get $anon-func-50.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-50.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-50.3_clos)
  (func $@mut_array_put (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-52.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-52.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-52.3_clos
    i32.const 23
    i32.store offset=5
    local.get $anon-func-52.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-52.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-52.3_clos)
  (func $@immut_array_keys (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-54.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-54.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-54.3_clos
    i32.const 22
    i32.store offset=5
    local.get $anon-func-54.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-54.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-54.3_clos)
  (func $@mut_array_keys (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-60.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-60.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-60.3_clos
    i32.const 20
    i32.store offset=5
    local.get $anon-func-60.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-60.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-60.3_clos)
  (func $@immut_array_vals (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-66.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-66.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-66.3_clos
    i32.const 18
    i32.store offset=5
    local.get $anon-func-66.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-66.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-66.3_clos)
  (func $@mut_array_vals (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-72.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-72.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-72.3_clos
    i32.const 16
    i32.store offset=5
    local.get $anon-func-72.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-72.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-72.3_clos)
  (func $@blob_size (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-78.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-78.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-78.3_clos
    i32.const 14
    i32.store offset=5
    local.get $anon-func-78.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-78.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-78.3_clos)
  (func $@blob_bytes (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-80.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-80.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-80.3_clos
    i32.const 13
    i32.store offset=5
    local.get $anon-func-80.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-80.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-80.3_clos)
  (func $@text_size (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-91.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-91.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-91.3_clos
    i32.const 11
    i32.store offset=5
    local.get $anon-func-91.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-91.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-91.3_clos)
  (func $@text_chars (type 6) (param $clos i32) (param $xs i32) (result i32)
    (local $anon-func-93.3_clos i32)
    i32.const 4
    call $alloc_words
    local.tee $anon-func-93.3_clos
    i32.const 7
    i32.store offset=1
    local.get $anon-func-93.3_clos
    i32.const 10
    i32.store offset=5
    local.get $anon-func-93.3_clos
    i32.const 1
    i32.store offset=9
    local.get $anon-func-93.3_clos
    local.get $xs
    i32.store offset=13
    local.get $anon-func-93.3_clos)
  (func $@text_of_num (type 11) (param $clos i32) (param $x i32) (param $base i32) (param $sep i32) (param $digits i32) (result i32)
    (local $text i32) (local $n i32) (local $i i32) (local $rem i32) (local $clos.1 i32)
    i32.const 66195
    local.set $text
    local.get $x
    local.tee $n
    i32.const 0
    call $B_eq
    if  ;; label = @1
      i32.const 66003
      return
    end
    i32.const 0
    local.set $i
    block (result i32)  ;; label = @1
      loop  ;; label = @2
        local.get $n
        i32.const 0
        call $B_gt
        if  ;; label = @3
          local.get $n
          local.get $base
          call $B_rem
          local.set $rem
          local.get $sep
          i32.const 0
          call $B_gt
          if (result i32)  ;; label = @4
            local.get $i
            local.get $sep
            call $B_eq
          else
            i32.const 0
          end
          if  ;; label = @4
            i32.const 66183
            local.get $text
            call $text_concat
            local.set $text
            i32.const 0
            local.set $i
          end
          local.get $digits
          local.tee $clos.1
          local.get $rem
          local.get $clos.1
          i32.load offset=5
          call_indirect (type 6)
          local.get $text
          call $text_concat
          local.set $text
          local.get $n
          local.get $base
          call $B_div
          local.set $n
          local.get $i
          i32.const 4
          call $B_add
          local.set $i
        else
          i32.const 1
          br 2 (;@1;)
        end
        br 0 (;@2;)
      end
      unreachable
    end
    drop
    local.get $text)
  (func $@left_pad (type 0) (param $clos i32) (param $pad i32) (param $char i32) (param $t i32) (result i32)
    (local $clos.1 i32) (local $i i32) (local $text i32) (local $clos.2 i32)
    local.get $pad
    i32.const 0
    local.get $t
    call $@text_size
    local.tee $clos.1
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 5)
    call $B_gt
    if (result i32)  ;; label = @1
      local.get $pad
      i32.const 0
      local.get $t
      call $@text_size
      local.tee $clos.2
      local.get $clos.2
      i32.load offset=5
      call_indirect (type 5)
      call $B_sub
      local.set $i
      local.get $t
      local.set $text
      block (result i32)  ;; label = @2
        loop  ;; label = @3
          local.get $i
          i32.const 0
          call $B_gt
          if  ;; label = @4
            local.get $char
            local.get $text
            call $text_concat
            local.set $text
            local.get $i
            i32.const 4
            call $B_sub
            local.set $i
          else
            i32.const 1
            br 2 (;@2;)
          end
          br 0 (;@3;)
        end
        unreachable
      end
      drop
      local.get $text
    else
      local.get $t
    end)
  (func $@digits_dec (type 6) (param $clos i32) (param $x i32) (result i32)
    (local $a i32)
    local.get $x
    i32.const 192
    call $B_add
    local.tee $a
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i32.const 1
      i32.shr_s
    else
      local.get $a
      call $bigint_to_word32_wrap
    end
    call $Word32->Char
    i32.const 8
    i32.shr_u
    call $text_singleton)
  (func $@text_of_Nat (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    local.get $x
    i32.const 40
    i32.const 12
    i32.const 66139
    call $@text_of_num)
  (func $@text_of_Int (type 6) (param $clos i32) (param $x i32) (result i32)
    (local $a i32) (local $a.1 i32)
    local.get $x
    i32.const 0
    call $B_eq
    if (result i32)  ;; label = @1
      i32.const 66003
    else
      local.get $x
      i32.const 0
      call $B_lt
      if (result i32)  ;; label = @2
        i32.const 66127
      else
        i32.const 66115
      end
      i32.const 0
      local.get $x
      local.tee $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        local.tee $a.1
        i32.const 1
        i32.and
        if (result i32)  ;; label = @3
          local.get $a.1
          i32.const 1
          i32.eq
          if (result i32)  ;; label = @4
            i32.const 1073741824
            call $bigint_of_word32
          else
            local.get $a.1
            i32.const -1
            i32.xor
            i32.const 2
            i32.add
          end
        else
          local.get $a.1
        end
      else
        local.get $a
        call $bigint_abs
      end
      call $@text_of_Nat
      call $text_concat
    end)
  (func $@digits_hex (type 6) (param $clos i32) (param $x i32) (result i32)
    (local $a i32)
    local.get $x
    local.get $x
    i32.const 40
    call $B_lt
    if (result i32)  ;; label = @1
      i32.const 192
    else
      i32.const 220
    end
    call $B_add
    local.tee $a
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i32.const 1
      i32.shr_s
    else
      local.get $a
      call $bigint_to_word32_wrap
    end
    call $Word32->Char
    i32.const 8
    i32.shr_u
    call $text_singleton)
  (func $@text_of_Word (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 66079
    i32.const 0
    local.get $x
    i32.const 64
    i32.const 16
    i32.const 66015
    call $@text_of_num
    call $text_concat)
  (func $@int64ToInt (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i64)
    local.get $n
    call $unbox_i64
    local.tee $a
    local.get $a
    i64.const 1
    i64.shl
    i64.xor
    i64.const -2147483648
    i64.and
    i64.eqz
    if (result i32)  ;; label = @1
      local.get $a
      i64.const 1
      i64.shl
      i32.wrap_i64
      i32.const 1
      i32.rotl
    else
      local.get $a
      call $bigint_of_word64_signed
    end)
  (func $@int32ToInt (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    call $unbox_i32
    local.tee $a
    local.get $a
    i32.const 1
    i32.shl
    i32.xor
    i32.const -2147483648
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      call $bigint_of_word32_signed
    else
      local.get $a
      i32.const 1
      i32.shl
      i32.const 1
      i32.rotl
    end)
  (func $@int16ToInt (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    i32.const 16
    i32.shr_s
    local.tee $a
    local.get $a
    i32.const 1
    i32.shl
    i32.xor
    i32.const -2147483648
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      call $bigint_of_word32_signed
    else
      local.get $a
      i32.const 1
      i32.shl
      i32.const 1
      i32.rotl
    end)
  (func $@int8ToInt (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    i32.const 24
    i32.shr_s
    local.tee $a
    local.get $a
    i32.const 1
    i32.shl
    i32.xor
    i32.const -2147483648
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      call $bigint_of_word32_signed
    else
      local.get $a
      i32.const 1
      i32.shl
      i32.const 1
      i32.rotl
    end)
  (func $@nat64ToNat (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i64)
    local.get $n
    call $unbox_i64
    local.tee $a
    i64.const -1073741824
    i64.and
    i64.eqz
    if (result i32)  ;; label = @1
      local.get $a
      i32.wrap_i64
      i32.const 2
      i32.rotl
    else
      local.get $a
      call $bigint_of_word64
    end)
  (func $@nat32ToNat (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    call $unbox_i32
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $@nat16ToNat (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    i32.const 16
    i32.shr_u
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $@nat8ToNat (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    i32.const 24
    i32.shr_u
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $@word64ToNat (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i64)
    local.get $n
    call $unbox_i64
    local.tee $a
    i64.const -1073741824
    i64.and
    i64.eqz
    if (result i32)  ;; label = @1
      local.get $a
      i32.wrap_i64
      i32.const 2
      i32.rotl
    else
      local.get $a
      call $bigint_of_word64
    end)
  (func $@word32ToNat (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    call $unbox_i32
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $@word16ToNat (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    i32.const 16
    i32.shr_u
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $@word8ToNat (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $a i32)
    local.get $n
    i32.const 24
    i32.shr_u
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $@text_of_Nat8 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@nat8ToNat
    call $@text_of_Nat)
  (func $@text_of_Nat16 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@nat16ToNat
    call $@text_of_Nat)
  (func $@text_of_Nat32 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@nat32ToNat
    call $@text_of_Nat)
  (func $@text_of_Nat64 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@nat64ToNat
    call $@text_of_Nat)
  (func $@text_of_Int8 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@int8ToInt
    call $@text_of_Int)
  (func $@text_of_Int16 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@int16ToInt
    call $@text_of_Int)
  (func $@text_of_Int32 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@int32ToInt
    call $@text_of_Int)
  (func $@text_of_Int64 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@int64ToInt
    call $@text_of_Int)
  (func $@text_of_Word8 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@word8ToNat
    call $@text_of_Word)
  (func $@text_of_Word16 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@word16ToNat
    call $@text_of_Word)
  (func $@text_of_Word32 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@word32ToNat
    call $@text_of_Word)
  (func $@text_of_Word64 (type 6) (param $clos i32) (param $x i32) (result i32)
    i32.const 0
    i32.const 0
    local.get $x
    call $@word64ToNat
    call $@text_of_Word)
  (func $@text_of_Float (type 6) (param $clos i32) (param $x i32) (result i32)
    local.get $x
    f64.load offset=5 align=4
    call $float_fmt)
  (func $@text_of_Bool (type 6) (param $clos i32) (param $b i32) (result i32)
    local.get $b
    if (result i32)  ;; label = @1
      i32.const 66067
    else
      i32.const 66051
    end)
  (func $@text_of_Text (type 6) (param $clos i32) (param $t i32) (result i32)
    i32.const 65991
    local.get $t
    call $text_concat
    i32.const 65991
    call $text_concat)
  (func $@text_of_Char (type 6) (param $clos i32) (param $c i32) (result i32)
    i32.const 66039
    local.get $c
    i32.const 8
    i32.shr_u
    call $text_singleton
    call $text_concat
    i32.const 66039
    call $text_concat)
  (func $@text_of_Blob (type 6) (param $clos i32) (param $blob i32) (result i32)
    (local $t i32) (local $$nxt/0 i32) (local $clos.1 i32) (local $switch_in i32) (local $switch_out i32) (local $b i32) (local $opt_scrut i32) (local $clos.2 i32)
    i32.const 65991
    local.set $t
    i32.const 0
    local.get $blob
    call $@blob_bytes
    local.tee $clos.2
    local.get $clos.2
    i32.load offset=5
    call_indirect (type 5)
    i32.const 1224901875
    call $obj_idx
    i32.load offset=1
    local.set $$nxt/0
    block (result i32)  ;; label = @1
      loop  ;; label = @2
        local.get $$nxt/0
        local.tee $clos.1
        local.get $clos.1
        i32.load offset=5
        call_indirect (type 5)
        local.set $switch_in
        block (result i32)  ;; label = @3
          local.get $switch_in
          i32.const 5
          i32.eq
          if  ;; label = @4
          else
            i32.const 0
            br 1 (;@3;)
          end
          i32.const 1
          br 2 (;@1;)
        end
        if  ;; label = @3
        else
          block (result i32)  ;; label = @4
            local.get $switch_in
            local.tee $opt_scrut
            i32.const 5
            i32.ne
            if  ;; label = @5
              local.get $opt_scrut
              i32.load offset=5
              local.set $b
            else
              i32.const 0
              br 1 (;@4;)
            end
            local.get $t
            i32.const 66027
            i32.const 0
            i32.const 8
            i32.const 66003
            i32.const 0
            i32.const 0
            local.get $b
            call $@word8ToNat
            i32.const 64
            i32.const 0
            i32.const 66015
            call $@text_of_num
            call $@left_pad
            call $text_concat
            call $text_concat
            local.set $t
            i32.const 1
            local.set $switch_out
            i32.const 1
          end
          if  ;; label = @4
          else
            i32.const 65680
            i32.const 14
            call $print_ptr
            unreachable
          end
        end
        br 0 (;@2;)
      end
      unreachable
    end
    drop
    local.get $t
    i32.const 65991
    call $text_concat
    local.tee $t
    return)
  (func $@text_has_parens (type 6) (param $clos i32) (param $t i32) (result i32)
    (local $clos.1 i32) (local $clos.2 i32) (local $switch_in i32) (local $switch_out i32) (local $opt_scrut i32)
    i32.const 0
    local.get $t
    call $@text_chars
    local.tee $clos.1
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 5)
    i32.const 1224901875
    call $obj_idx
    i32.load offset=1
    local.tee $clos.2
    local.get $clos.2
    i32.load offset=5
    call_indirect (type 5)
    local.set $switch_in
    block (result i32)  ;; label = @1
      local.get $switch_in
      local.tee $opt_scrut
      i32.const 5
      i32.ne
      if  ;; label = @2
        local.get $opt_scrut
        i32.load offset=5
        i32.const 10240
        i32.eq
        if  ;; label = @3
        else
          i32.const 0
          br 2 (;@1;)
        end
      else
        i32.const 0
        br 1 (;@1;)
      end
      i32.const 1
      local.set $switch_out
      i32.const 1
    end
    if  ;; label = @1
    else
      i32.const 0
      local.set $switch_out
    end
    local.get $switch_out)
  (func $@text_needs_parens (type 6) (param $clos i32) (param $t i32) (result i32)
    (local $clos.1 i32) (local $clos.2 i32) (local $switch_in i32) (local $switch_out i32) (local $opt_scrut i32) (local $alt_scrut i32) (local $alt_scrut.1 i32) (local $alt_scrut.2 i32)
    i32.const 0
    local.get $t
    call $@text_chars
    local.tee $clos.1
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 5)
    i32.const 1224901875
    call $obj_idx
    i32.load offset=1
    local.tee $clos.2
    local.get $clos.2
    i32.load offset=5
    call_indirect (type 5)
    local.set $switch_in
    block (result i32)  ;; label = @1
      local.get $switch_in
      local.tee $opt_scrut
      i32.const 5
      i32.ne
      if  ;; label = @2
        local.get $opt_scrut
        i32.load offset=5
        local.set $alt_scrut.2
        block (result i32)  ;; label = @3
          local.get $alt_scrut.2
          local.set $alt_scrut.1
          block (result i32)  ;; label = @4
            local.get $alt_scrut.1
            local.set $alt_scrut
            block (result i32)  ;; label = @5
              local.get $alt_scrut
              i32.const 11008
              i32.eq
              if  ;; label = @6
              else
                i32.const 0
                br 1 (;@5;)
              end
              i32.const 1
            end
            if  ;; label = @5
            else
              local.get $alt_scrut
              i32.const 11520
              i32.eq
              if  ;; label = @6
              else
                i32.const 0
                br 2 (;@4;)
              end
            end
            i32.const 1
          end
          if  ;; label = @4
          else
            local.get $alt_scrut.1
            i32.const 16128
            i32.eq
            if  ;; label = @5
            else
              i32.const 0
              br 2 (;@3;)
            end
          end
          i32.const 1
        end
        if  ;; label = @3
        else
          local.get $alt_scrut.2
          i32.const 8960
          i32.eq
          if  ;; label = @4
          else
            i32.const 0
            br 3 (;@1;)
          end
        end
      else
        i32.const 0
        br 1 (;@1;)
      end
      i32.const 1
      local.set $switch_out
      i32.const 1
    end
    if  ;; label = @1
    else
      i32.const 0
      local.set $switch_out
    end
    local.get $switch_out)
  (func $@text_of_option (type 2) (param $clos i32) (param $f i32) (param $x i32) (result i32)
    (local $switch_in i32) (local $switch_out i32) (local $y i32) (local $opt_scrut i32) (local $fy i32) (local $clos.1 i32)
    local.get $x
    local.set $switch_in
    block (result i32)  ;; label = @1
      local.get $switch_in
      local.tee $opt_scrut
      i32.const 5
      i32.ne
      if  ;; label = @2
        local.get $opt_scrut
        i32.load offset=5
        local.set $y
      else
        i32.const 0
        br 1 (;@1;)
      end
      local.get $f
      local.tee $clos.1
      local.get $y
      local.get $clos.1
      i32.load offset=5
      call_indirect (type 6)
      local.set $fy
      i32.const 0
      local.get $fy
      call $@text_needs_parens
      if (result i32)  ;; label = @2
        i32.const 65967
        local.get $fy
        call $text_concat
        i32.const 65931
        call $text_concat
      else
        i32.const 65979
        local.get $fy
        call $text_concat
      end
      local.set $switch_out
      i32.const 1
    end
    if  ;; label = @1
    else
      block (result i32)  ;; label = @2
        local.get $switch_in
        i32.const 5
        i32.eq
        if  ;; label = @3
        else
          i32.const 0
          br 1 (;@2;)
        end
        i32.const 65955
        local.set $switch_out
        i32.const 1
      end
      if  ;; label = @2
      else
        i32.const 65680
        i32.const 14
        call $print_ptr
        unreachable
      end
    end
    local.get $switch_out)
  (func $@text_of_variant (type 0) (param $clos i32) (param $l i32) (param $f i32) (param $x i32) (result i32)
    (local $fx i32) (local $clos.1 i32)
    local.get $f
    local.tee $clos.1
    local.get $x
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 6)
    local.tee $fx
    i32.const 65907
    call $Text.compare_eq
    if (result i32)  ;; label = @1
      i32.const 65919
      local.get $l
      call $text_concat
    else
      i32.const 0
      local.get $fx
      call $@text_has_parens
      if (result i32)  ;; label = @2
        i32.const 65919
        local.get $l
        call $text_concat
        local.get $fx
        call $text_concat
      else
        i32.const 65919
        local.get $l
        call $text_concat
        i32.const 65943
        call $text_concat
        local.get $fx
        call $text_concat
        i32.const 65931
        call $text_concat
      end
    end)
  (func $@text_of_array (type 2) (param $clos i32) (param $f i32) (param $xs i32) (result i32)
    (local $text i32) (local $first i32) (local $$nxt/1 i32) (local $clos.1 i32) (local $switch_in i32) (local $switch_out i32) (local $x i32) (local $opt_scrut i32) (local $clos.2 i32) (local $clos.3 i32)
    i32.const 65895
    local.set $text
    i32.const 1
    local.set $first
    i32.const 0
    local.get $xs
    call $@immut_array_vals
    local.tee $clos.3
    local.get $clos.3
    i32.load offset=5
    call_indirect (type 5)
    i32.const 1224901875
    call $obj_idx
    i32.load offset=1
    local.set $$nxt/1
    block (result i32)  ;; label = @1
      loop  ;; label = @2
        local.get $$nxt/1
        local.tee $clos.1
        local.get $clos.1
        i32.load offset=5
        call_indirect (type 5)
        local.set $switch_in
        block (result i32)  ;; label = @3
          local.get $switch_in
          i32.const 5
          i32.eq
          if  ;; label = @4
          else
            i32.const 0
            br 1 (;@3;)
          end
          i32.const 1
          br 2 (;@1;)
        end
        if  ;; label = @3
        else
          block (result i32)  ;; label = @4
            local.get $switch_in
            local.tee $opt_scrut
            i32.const 5
            i32.ne
            if  ;; label = @5
              local.get $opt_scrut
              i32.load offset=5
              local.set $x
            else
              i32.const 0
              br 1 (;@4;)
            end
            local.get $first
            if  ;; label = @5
              i32.const 0
              local.set $first
            else
              local.get $text
              i32.const 65831
              call $text_concat
              local.set $text
            end
            local.get $text
            local.get $f
            local.tee $clos.2
            local.get $x
            local.get $clos.2
            i32.load offset=5
            call_indirect (type 6)
            call $text_concat
            local.set $text
            i32.const 1
            local.set $switch_out
            i32.const 1
          end
          if  ;; label = @4
          else
            i32.const 65680
            i32.const 14
            call $print_ptr
            unreachable
          end
        end
        br 0 (;@2;)
      end
      unreachable
    end
    drop
    local.get $text
    i32.const 65807
    call $text_concat)
  (func $@text_of_array_mut (type 2) (param $clos i32) (param $f i32) (param $xs i32) (result i32)
    (local $text i32) (local $first i32) (local $$nxt/2 i32) (local $clos.1 i32) (local $switch_in i32) (local $switch_out i32) (local $x i32) (local $opt_scrut i32) (local $clos.2 i32) (local $clos.3 i32)
    i32.const 65883
    local.set $text
    i32.const 1
    local.set $first
    i32.const 0
    local.get $xs
    call $@mut_array_vals
    local.tee $clos.3
    local.get $clos.3
    i32.load offset=5
    call_indirect (type 5)
    i32.const 1224901875
    call $obj_idx
    i32.load offset=1
    local.set $$nxt/2
    block (result i32)  ;; label = @1
      loop  ;; label = @2
        local.get $$nxt/2
        local.tee $clos.1
        local.get $clos.1
        i32.load offset=5
        call_indirect (type 5)
        local.set $switch_in
        block (result i32)  ;; label = @3
          local.get $switch_in
          i32.const 5
          i32.eq
          if  ;; label = @4
          else
            i32.const 0
            br 1 (;@3;)
          end
          i32.const 1
          br 2 (;@1;)
        end
        if  ;; label = @3
        else
          block (result i32)  ;; label = @4
            local.get $switch_in
            local.tee $opt_scrut
            i32.const 5
            i32.ne
            if  ;; label = @5
              local.get $opt_scrut
              i32.load offset=5
              local.set $x
            else
              i32.const 0
              br 1 (;@4;)
            end
            local.get $first
            if  ;; label = @5
              i32.const 0
              local.set $first
              local.get $text
              i32.const 65819
              call $text_concat
              local.set $text
            else
              local.get $text
              i32.const 65831
              call $text_concat
              local.set $text
            end
            local.get $text
            local.get $f
            local.tee $clos.2
            local.get $x
            local.get $clos.2
            i32.load offset=5
            call_indirect (type 6)
            call $text_concat
            local.set $text
            i32.const 1
            local.set $switch_out
            i32.const 1
          end
          if  ;; label = @4
          else
            i32.const 65680
            i32.const 14
            call $print_ptr
            unreachable
          end
        end
        br 0 (;@2;)
      end
      unreachable
    end
    drop
    local.get $text
    i32.const 65807
    call $text_concat)
  (func $@new_async (type 10) (param $clos i32)
    (local $result i32) (local $heap_object i32) (local $ks i32) (local $heap_object.1 i32) (local $rs i32) (local $heap_object.2 i32) (local $fulfill i32) (local $fail i32) (local $enqueue i32) (local $enqueue_clos i32) (local $fail_clos i32) (local $fulfill_clos i32) (local $new_val i32) (local $new_val.1 i32) (local $new_val.2 i32)
    i32.const 2
    call $alloc_words
    local.tee $heap_object
    i32.const 6
    i32.store offset=1
    local.get $heap_object
    i32.const 0
    i32.store offset=5
    local.get $heap_object
    local.set $result
    i32.const 2
    call $alloc_words
    local.tee $heap_object.1
    i32.const 6
    i32.store offset=1
    local.get $heap_object.1
    i32.const 0
    i32.store offset=5
    local.get $heap_object.1
    local.set $ks
    i32.const 2
    call $alloc_words
    local.tee $heap_object.2
    i32.const 6
    i32.store offset=1
    local.get $heap_object.2
    i32.const 0
    i32.store offset=5
    local.get $heap_object.2
    local.set $rs
    i32.const 5
    local.set $new_val.2
    local.get $result
    local.get $new_val.2
    i32.store offset=5
    i32.const 65751
    local.set $new_val.1
    local.get $ks
    local.get $new_val.1
    i32.store offset=5
    i32.const 65739
    local.set $new_val
    local.get $rs
    local.get $new_val
    i32.store offset=5
    i32.const 6
    call $alloc_words
    local.tee $fulfill_clos
    i32.const 7
    i32.store offset=1
    local.get $fulfill_clos
    i32.const 6
    i32.store offset=5
    local.get $fulfill_clos
    i32.const 3
    i32.store offset=9
    local.get $fulfill_clos
    local.get $ks
    i32.store offset=13
    local.get $fulfill_clos
    local.get $result
    i32.store offset=17
    local.get $fulfill_clos
    local.get $rs
    i32.store offset=21
    local.get $fulfill_clos
    local.set $fulfill
    i32.const 6
    call $alloc_words
    local.tee $fail_clos
    i32.const 7
    i32.store offset=1
    local.get $fail_clos
    i32.const 5
    i32.store offset=5
    local.get $fail_clos
    i32.const 3
    i32.store offset=9
    local.get $fail_clos
    local.get $ks
    i32.store offset=13
    local.get $fail_clos
    local.get $result
    i32.store offset=17
    local.get $fail_clos
    local.get $rs
    i32.store offset=21
    local.get $fail_clos
    local.set $fail
    i32.const 6
    call $alloc_words
    local.tee $enqueue_clos
    i32.const 7
    i32.store offset=1
    local.get $enqueue_clos
    i32.const 2
    i32.store offset=5
    local.get $enqueue_clos
    i32.const 3
    i32.store offset=9
    local.get $enqueue_clos
    local.get $ks
    i32.store offset=13
    local.get $enqueue_clos
    local.get $result
    i32.store offset=17
    local.get $enqueue_clos
    local.get $rs
    i32.store offset=21
    local.get $enqueue_clos
    local.tee $enqueue
    local.get $fulfill
    local.get $fail
    global.set 5
    global.set 6
    global.set 7)
  (func $fib (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $switch_in i32) (local $switch_out i32)
    local.get $n
    local.set $switch_in
    block (result i32)  ;; label = @1
      local.get $switch_in
      i32.const 0
      i32.eq
      if  ;; label = @2
      else
        i32.const 0
        br 1 (;@1;)
      end
      i32.const 0
      local.set $switch_out
      i32.const 1
    end
    if  ;; label = @1
    else
      block (result i32)  ;; label = @2
        local.get $switch_in
        i32.const 65536
        i32.eq
        if  ;; label = @3
        else
          i32.const 0
          br 1 (;@2;)
        end
        i32.const 65536
        local.set $switch_out
        i32.const 1
      end
      if  ;; label = @2
      else
        i32.const 0
        local.get $n
        i32.const 131072
        call $sub<Nat16>
        call $fib
        i32.const 0
        local.get $n
        i32.const 65536
        call $sub<Nat16>
        call $fib
        call $add<Nat16>
        local.set $switch_out
      end
    end
    local.get $switch_out)
  (func $add<Nat16> (type 6) (param $a i32) (param $b i32) (result i32)
    (local $res i32)
    local.get $a
    i32.const 16
    i32.shr_u
    local.get $b
    i32.const 16
    i32.shr_u
    i32.add
    local.tee $res
    i32.const -65536
    i32.and
    if  ;; label = @1
      i32.const 65660
      i32.const 19
      call $print_ptr
      unreachable
    end
    local.get $res
    i32.const 16
    i32.shl)
  (func $sub<Nat16> (type 6) (param $a i32) (param $b i32) (result i32)
    (local $res i32)
    local.get $a
    i32.const 16
    i32.shr_u
    local.get $b
    i32.const 16
    i32.shr_u
    i32.sub
    local.tee $res
    i32.const -65536
    i32.and
    if  ;; label = @1
      i32.const 65660
      i32.const 19
      call $print_ptr
      unreachable
    end
    local.get $res
    i32.const 16
    i32.shl)
  (func $anon-func-294.16 (type 9) (param $clos i32) (param $$ignored0/0 i32))
  (func $anon-func-295.16 (type 9) (param $clos i32) (param $$ignored0/1 i32))
  (func $anon-func-332.15 (type 9) (param $clos i32) (param $e i32)
    (local $r i32) (local $rs_ i32) (local $clos.1 i32) (local $clos.2 i32)
    local.get $clos
    i32.load offset=13
    local.set $r
    local.get $clos
    i32.load offset=17
    local.tee $rs_
    local.tee $clos.2
    local.get $e
    local.get $clos.2
    i32.load offset=5
    call_indirect (type 9)
    local.get $r
    local.tee $clos.1
    local.get $e
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 9))
  (func $anon-func-330.15 (type 9) (param $clos i32) (param $t i32)
    (local $k i32) (local $ks_ i32) (local $clos.1 i32) (local $clos.2 i32)
    local.get $clos
    i32.load offset=13
    local.set $k
    local.get $clos
    i32.load offset=17
    local.tee $ks_
    local.tee $clos.2
    local.get $t
    local.get $clos.2
    i32.load offset=5
    call_indirect (type 9)
    local.get $k
    local.tee $clos.1
    local.get $t
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 9))
  (func $enqueue (type 1) (param $clos i32) (param $k i32) (param $r i32)
    (local $ks i32) (local $result i32) (local $rs i32) (local $switch_in i32) (local $switch_out i32) (local $t i32) (local $opt_scrut i32) (local $e i32) (local $opt_scrut.1 i32) (local $clos.1 i32) (local $clos.2 i32) (local $ks_ i32) (local $rs_ i32) (local $new_val i32) (local $anon-func-332.15_clos i32) (local $new_val.1 i32) (local $anon-func-330.15_clos i32) (local $tag_scrut i32) (local $tag_scrut.1 i32)
    local.get $clos
    i32.load offset=13
    local.set $ks
    local.get $clos
    i32.load offset=17
    local.set $result
    local.get $clos
    i32.load offset=21
    local.set $rs
    local.get $result
    i32.load offset=5
    local.set $switch_in
    block (result i32)  ;; label = @1
      local.get $switch_in
      i32.const 5
      i32.eq
      if  ;; label = @2
      else
        i32.const 0
        br 1 (;@1;)
      end
      local.get $ks
      i32.load offset=5
      local.set $ks_
      i32.const 5
      call $alloc_words
      local.tee $anon-func-330.15_clos
      i32.const 7
      i32.store offset=1
      local.get $anon-func-330.15_clos
      i32.const 1
      i32.store offset=5
      local.get $anon-func-330.15_clos
      i32.const 2
      i32.store offset=9
      local.get $anon-func-330.15_clos
      local.get $k
      i32.store offset=13
      local.get $anon-func-330.15_clos
      local.get $ks_
      i32.store offset=17
      local.get $anon-func-330.15_clos
      local.set $new_val.1
      local.get $ks
      local.get $new_val.1
      i32.store offset=5
      local.get $rs
      i32.load offset=5
      local.set $rs_
      i32.const 5
      call $alloc_words
      local.tee $anon-func-332.15_clos
      i32.const 7
      i32.store offset=1
      local.get $anon-func-332.15_clos
      i32.const 0
      i32.store offset=5
      local.get $anon-func-332.15_clos
      i32.const 2
      i32.store offset=9
      local.get $anon-func-332.15_clos
      local.get $r
      i32.store offset=13
      local.get $anon-func-332.15_clos
      local.get $rs_
      i32.store offset=17
      local.get $anon-func-332.15_clos
      local.set $new_val
      local.get $rs
      local.get $new_val
      i32.store offset=5
      i32.const 1
      local.set $switch_out
      i32.const 1
    end
    if  ;; label = @1
    else
      block (result i32)  ;; label = @2
        local.get $switch_in
        local.tee $opt_scrut
        i32.const 5
        i32.ne
        if  ;; label = @3
          local.get $opt_scrut
          i32.load offset=5
          local.tee $tag_scrut.1
          i32.load offset=5
          i32.const 24860
          i32.eq
          if  ;; label = @4
            local.get $tag_scrut.1
            i32.load offset=9
            local.set $t
          else
            i32.const 0
            br 2 (;@2;)
          end
        else
          i32.const 0
          br 1 (;@2;)
        end
        local.get $k
        local.tee $clos.2
        local.get $t
        local.get $clos.2
        i32.load offset=5
        call_indirect (type 9)
        i32.const 1
        local.set $switch_out
        i32.const 1
      end
      if  ;; label = @2
      else
        block (result i32)  ;; label = @3
          local.get $switch_in
          local.tee $opt_scrut.1
          i32.const 5
          i32.ne
          if  ;; label = @4
            local.get $opt_scrut.1
            i32.load offset=5
            local.tee $tag_scrut
            i32.load offset=5
            i32.const 1932118984
            i32.eq
            if  ;; label = @5
              local.get $tag_scrut
              i32.load offset=9
              local.set $e
            else
              i32.const 0
              br 2 (;@3;)
            end
          else
            i32.const 0
            br 1 (;@3;)
          end
          local.get $r
          local.tee $clos.1
          local.get $e
          local.get $clos.1
          i32.load offset=5
          call_indirect (type 9)
          i32.const 1
          local.set $switch_out
          i32.const 1
        end
        if  ;; label = @3
        else
          i32.const 65680
          i32.const 14
          call $print_ptr
          unreachable
        end
      end
    end)
  (func $fail (type 9) (param $clos i32) (param $e i32)
    (local $ks i32) (local $result i32) (local $rs i32) (local $switch_in i32) (local $switch_out i32) (local $opt_scrut i32) (local $rs_ i32) (local $clos.1 i32) (local $new_val i32) (local $new_val.1 i32) (local $new_val.2 i32) (local $heap_object i32) (local $heap_object.1 i32)
    local.get $clos
    i32.load offset=13
    local.set $ks
    local.get $clos
    i32.load offset=17
    local.set $result
    local.get $clos
    i32.load offset=21
    local.set $rs
    local.get $result
    i32.load offset=5
    local.set $switch_in
    block (result i32)  ;; label = @1
      local.get $switch_in
      i32.const 5
      i32.eq
      if  ;; label = @2
      else
        i32.const 0
        br 1 (;@1;)
      end
      i32.const 2
      call $alloc_words
      local.tee $heap_object.1
      i32.const 8
      i32.store offset=1
      local.get $heap_object.1
      i32.const 3
      call $alloc_words
      local.tee $heap_object
      i32.const 9
      i32.store offset=1
      local.get $heap_object
      i32.const 1932118984
      i32.store offset=5
      local.get $heap_object
      local.get $e
      i32.store offset=9
      local.get $heap_object
      i32.store offset=5
      local.get $heap_object.1
      local.set $new_val.2
      local.get $result
      local.get $new_val.2
      i32.store offset=5
      local.get $rs
      i32.load offset=5
      local.set $rs_
      i32.const 65751
      local.set $new_val.1
      local.get $ks
      local.get $new_val.1
      i32.store offset=5
      i32.const 65739
      local.set $new_val
      local.get $rs
      local.get $new_val
      i32.store offset=5
      local.get $rs_
      local.tee $clos.1
      local.get $e
      local.get $clos.1
      i32.load offset=5
      call_indirect (type 9)
      i32.const 1
      local.set $switch_out
      i32.const 1
    end
    if  ;; label = @1
    else
      block (result i32)  ;; label = @2
        local.get $switch_in
        local.tee $opt_scrut
        i32.const 5
        i32.ne
        if  ;; label = @3
        else
          i32.const 0
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 65696
          i32.const 41
          call $print_ptr
          unreachable
        end
        i32.const 1
        local.set $switch_out
        i32.const 1
      end
      if  ;; label = @2
      else
        i32.const 65680
        i32.const 14
        call $print_ptr
        unreachable
      end
    end)
  (func $fulfill (type 9) (param $clos i32) (param $t i32)
    (local $ks i32) (local $result i32) (local $rs i32) (local $switch_in i32) (local $switch_out i32) (local $opt_scrut i32) (local $ks_ i32) (local $clos.1 i32) (local $new_val i32) (local $new_val.1 i32) (local $new_val.2 i32) (local $heap_object i32) (local $heap_object.1 i32)
    local.get $clos
    i32.load offset=13
    local.set $ks
    local.get $clos
    i32.load offset=17
    local.set $result
    local.get $clos
    i32.load offset=21
    local.set $rs
    local.get $result
    i32.load offset=5
    local.set $switch_in
    block (result i32)  ;; label = @1
      local.get $switch_in
      i32.const 5
      i32.eq
      if  ;; label = @2
      else
        i32.const 0
        br 1 (;@1;)
      end
      i32.const 2
      call $alloc_words
      local.tee $heap_object.1
      i32.const 8
      i32.store offset=1
      local.get $heap_object.1
      i32.const 3
      call $alloc_words
      local.tee $heap_object
      i32.const 9
      i32.store offset=1
      local.get $heap_object
      i32.const 24860
      i32.store offset=5
      local.get $heap_object
      local.get $t
      i32.store offset=9
      local.get $heap_object
      i32.store offset=5
      local.get $heap_object.1
      local.set $new_val.2
      local.get $result
      local.get $new_val.2
      i32.store offset=5
      local.get $ks
      i32.load offset=5
      local.set $ks_
      i32.const 65751
      local.set $new_val.1
      local.get $ks
      local.get $new_val.1
      i32.store offset=5
      i32.const 65739
      local.set $new_val
      local.get $rs
      local.get $new_val
      i32.store offset=5
      local.get $ks_
      local.tee $clos.1
      local.get $t
      local.get $clos.1
      i32.load offset=5
      call_indirect (type 9)
      i32.const 1
      local.set $switch_out
      i32.const 1
    end
    if  ;; label = @1
    else
      block (result i32)  ;; label = @2
        local.get $switch_in
        local.tee $opt_scrut
        i32.const 5
        i32.ne
        if  ;; label = @3
        else
          i32.const 0
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 65764
          i32.const 41
          call $print_ptr
          unreachable
        end
        i32.const 1
        local.set $switch_out
        i32.const 1
      end
      if  ;; label = @2
      else
        i32.const 65680
        i32.const 14
        call $print_ptr
        unreachable
      end
    end)
  (func $obj_idx (type 6) (param $x i32) (param $hash i32) (result i32)
    (local $h_ptr i32) (local $n i32) (local $i i32)
    local.get $x
    i32.load offset=9
    local.set $h_ptr
    local.get $x
    i32.load offset=5
    local.set $n
    i32.const 0
    local.set $i
    loop  ;; label = @1
      local.get $i
      local.get $n
      i32.lt_u
      if  ;; label = @2
        local.get $i
        i32.const 4
        i32.mul
        local.get $h_ptr
        i32.add
        i32.load offset=1
        local.get $hash
        i32.eq
        if  ;; label = @3
          local.get $i
          i32.const 3
          i32.add
          i32.const 4
          i32.mul
          local.get $x
          i32.add
          return
        end
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br 1 (;@1;)
      end
    end
    i32.const 65844
    i32.const 38
    call $print_ptr
    unreachable)
  (func $Text.compare_eq (type 6) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    call $text_compare
    i32.const 0
    i32.eq)
  (func $unbox_i32 (type 5) (param $n i32) (result i32)
    local.get $n
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $n
      i32.const 2
      i32.shr_u
    else
      local.get $n
      i32.load offset=5
    end)
  (func $is_unboxed (type 5) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.and
    i32.eqz)
  (func $unbox_i64 (type 8) (param $n i32) (result i64)
    local.get $n
    call $is_unboxed
    if (result i64)  ;; label = @1
      local.get $n
      i32.const 2
      i32.shr_u
      i64.extend_i32_u
    else
      local.get $n
      i64.load offset=5 align=4
    end)
  (func $Word32->Char (type 5) (param $n i32) (result i32)
    local.get $n
    i32.const 55296
    i32.ge_u
    local.get $n
    i32.const 57344
    i32.lt_u
    i32.and
    local.get $n
    i32.const 1114111
    i32.gt_u
    i32.or
    if  ;; label = @1
      i32.const 66092
      i32.const 22
      call $print_ptr
      unreachable
    end
    local.get $n
    i32.const 8
    i32.shl)
  (func $B_add (type 6) (param $a i32) (param $b i32) (result i32)
    (local $res i32) (local $res64 i64)
    local.get $a
    local.get $b
    i32.or
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      local.get $b
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      i64.add
      local.tee $res64
      local.get $res64
      i64.const 1
      i64.shl
      i64.xor
      i64.const -4294967296
      i64.and
      i64.eqz
      if (result i32)  ;; label = @2
        local.get $res64
        i32.wrap_i64
        i32.const 1
        i32.rotl
      else
        local.get $res64
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      end
    else
      local.get $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $a
      end
      local.get $b
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $b
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $b
      end
      call $bigint_add
      local.tee $res
      call $bigint_2complement_bits
      i32.const 31
      i32.le_u
      if (result i32)  ;; label = @2
        local.get $res
        call $bigint_to_word32_wrap
        i32.const 1
        i32.shl
        i32.const 1
        i32.rotl
      else
        local.get $res
      end
    end)
  (func $B_lt (type 6) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.or
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      local.get $b
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      i64.lt_s
    else
      local.get $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $a
      end
      local.get $b
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $b
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $b
      end
      call $bigint_lt
    end)
  (func $B_eq (type 6) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.or
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      local.get $b
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      i64.eq
    else
      local.get $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $a
      end
      local.get $b
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $b
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $b
      end
      call $bigint_eq
    end)
  (func $B_gt (type 6) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.or
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      local.get $b
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      i64.gt_s
    else
      local.get $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $a
      end
      local.get $b
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $b
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $b
      end
      call $bigint_gt
    end)
  (func $B_sub (type 6) (param $a i32) (param $b i32) (result i32)
    (local $res i32) (local $res64 i64)
    local.get $a
    local.get $b
    i32.or
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      local.get $b
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      call $nat_sub
      local.tee $res64
      local.get $res64
      i64.const 1
      i64.shl
      i64.xor
      i64.const -4294967296
      i64.and
      i64.eqz
      if (result i32)  ;; label = @2
        local.get $res64
        i32.wrap_i64
        i32.const 1
        i32.rotl
      else
        local.get $res64
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      end
    else
      local.get $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $a
      end
      local.get $b
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $b
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $b
      end
      call $bigint_sub
      call $assert_nonneg
      local.tee $res
      call $bigint_2complement_bits
      i32.const 31
      i32.le_u
      if (result i32)  ;; label = @2
        local.get $res
        call $bigint_to_word32_wrap
        i32.const 1
        i32.shl
        i32.const 1
        i32.rotl
      else
        local.get $res
      end
    end)
  (func $assert_nonneg (type 5) (param $n i32) (result i32)
    local.get $n
    call $bigint_isneg
    if  ;; label = @1
      i32.const 66152
      i32.const 29
      call $print_ptr
      unreachable
    end
    local.get $n)
  (func $nat_sub (type 16) (param $n1 i64) (param $n2 i64) (result i64)
    local.get $n1
    local.get $n2
    i64.lt_u
    if  ;; label = @1
      i32.const 66152
      i32.const 29
      call $print_ptr
      unreachable
    end
    local.get $n1
    local.get $n2
    i64.sub)
  (func $B_div (type 6) (param $a i32) (param $b i32) (result i32)
    (local $res i32) (local $res64 i64)
    local.get $a
    local.get $b
    i32.or
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      local.get $b
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      i64.div_u
      i64.const 1
      i64.shl
      local.tee $res64
      local.get $res64
      i64.const 1
      i64.shl
      i64.xor
      i64.const -4294967296
      i64.and
      i64.eqz
      if (result i32)  ;; label = @2
        local.get $res64
        i32.wrap_i64
        i32.const 1
        i32.rotl
      else
        local.get $res64
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      end
    else
      local.get $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $a
      end
      local.get $b
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $b
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $b
      end
      call $bigint_div
      local.tee $res
      call $bigint_2complement_bits
      i32.const 31
      i32.le_u
      if (result i32)  ;; label = @2
        local.get $res
        call $bigint_to_word32_wrap
        i32.const 1
        i32.shl
        i32.const 1
        i32.rotl
      else
        local.get $res
      end
    end)
  (func $B_rem (type 6) (param $a i32) (param $b i32) (result i32)
    (local $res i32) (local $res64 i64)
    local.get $a
    local.get $b
    i32.or
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      local.get $b
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      i64.rem_u
      local.tee $res64
      local.get $res64
      i64.const 1
      i64.shl
      i64.xor
      i64.const -4294967296
      i64.and
      i64.eqz
      if (result i32)  ;; label = @2
        local.get $res64
        i32.wrap_i64
        i32.const 1
        i32.rotl
      else
        local.get $res64
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      end
    else
      local.get $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $a
      end
      local.get $b
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $b
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $b
      end
      call $bigint_rem
      local.tee $res
      call $bigint_2complement_bits
      i32.const 31
      i32.le_u
      if (result i32)  ;; label = @2
        local.get $res
        call $bigint_to_word32_wrap
        i32.const 1
        i32.shl
        i32.const 1
        i32.rotl
      else
        local.get $res
      end
    end)
  (func $next (type 5) (param $clos i32) (result i32)
    (local $i i32) (local $heap_object i32)
    local.get $clos
    i32.load offset=13
    local.tee $i
    call $text_iter_done
    if (result i32)  ;; label = @1
      i32.const 5
    else
      i32.const 2
      call $alloc_words
      local.tee $heap_object
      i32.const 8
      i32.store offset=1
      local.get $heap_object
      local.get $i
      call $text_iter_next
      i32.const 8
      i32.shl
      i32.store offset=5
      local.get $heap_object
    end)
  (func $anon-func-93.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $i i32) (local $next i32) (local $obj i32) (local $next_clos i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    call $text_iter
    local.set $i
    i32.const 4
    call $alloc_words
    local.tee $next_clos
    i32.const 7
    i32.store offset=1
    local.get $next_clos
    i32.const 9
    i32.store offset=5
    local.get $next_clos
    i32.const 1
    i32.store offset=9
    local.get $next_clos
    local.get $i
    i32.store offset=13
    local.get $next_clos
    local.set $next
    i32.const 4
    call $alloc_words
    local.tee $obj
    i32.const 1
    i32.store offset=1
    local.get $obj
    i32.const 1
    i32.store offset=5
    local.get $obj
    i32.const 66203
    i32.store offset=9
    local.get $obj
    local.get $next
    i32.store offset=13
    local.get $obj)
  (func $anon-func-91.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $a i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    call $text_len
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $next.1 (type 5) (param $clos i32) (result i32)
    (local $i i32) (local $heap_object i32)
    local.get $clos
    i32.load offset=13
    local.tee $i
    call $blob_iter_done
    if (result i32)  ;; label = @1
      i32.const 5
    else
      i32.const 2
      call $alloc_words
      local.tee $heap_object
      i32.const 8
      i32.store offset=1
      local.get $heap_object
      local.get $i
      call $blob_iter_next
      i32.const 24
      i32.shl
      i32.store offset=5
      local.get $heap_object
    end)
  (func $anon-func-80.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $i i32) (local $next i32) (local $obj i32) (local $next_clos i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    call $blob_iter
    local.set $i
    i32.const 4
    call $alloc_words
    local.tee $next_clos
    i32.const 7
    i32.store offset=1
    local.get $next_clos
    i32.const 12
    i32.store offset=5
    local.get $next_clos
    i32.const 1
    i32.store offset=9
    local.get $next_clos
    local.get $i
    i32.store offset=13
    local.get $next_clos
    local.set $next
    i32.const 4
    call $alloc_words
    local.tee $obj
    i32.const 1
    i32.store offset=1
    local.get $obj
    i32.const 1
    i32.store offset=5
    local.get $obj
    i32.const 66203
    i32.store offset=9
    local.get $obj
    local.get $next
    i32.store offset=13
    local.get $obj)
  (func $anon-func-78.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $a i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    i32.load offset=5
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $B_ge (type 6) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.or
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      local.get $b
      i32.const 1
      i32.rotr
      i64.extend_i32_s
      i64.ge_s
    else
      local.get $a
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $a
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $a
      end
      local.get $b
      call $is_unboxed
      if (result i32)  ;; label = @2
        local.get $b
        i32.const 1
        i32.rotr
        i64.extend_i32_s
        i64.const 1
        i64.shr_s
        call $bigint_of_word64_signed
      else
        local.get $b
      end
      call $bigint_ge
    end)
  (func $Array.idx_bigint (type 6) (param $array i32) (param $idx i32) (result i32)
    (local $a i32) (local $err_msg i32)
    local.get $array
    local.get $idx
    i32.const 66235
    local.set $err_msg
    local.tee $a
    call $is_unboxed
    if (result i32)  ;; label = @1
      local.get $a
      i32.const 1
      i32.rotr
      i32.const 1
      i32.shr_s
    else
      local.get $a
      local.get $err_msg
      call $bigint_to_word32_trap_with
    end
    call $Array.idx)
  (func $Array.idx (type 6) (param $array i32) (param $idx i32) (result i32)
    local.get $idx
    local.get $array
    i32.load offset=5
    i32.lt_u
    if  ;; label = @1
    else
      i32.const 66208
      i32.const 25
      call $print_ptr
      unreachable
    end
    local.get $idx
    i32.const 2
    i32.add
    i32.const 4
    i32.mul
    local.get $array
    i32.add)
  (func $next.2 (type 5) (param $clos i32) (result i32)
    (local $i i32) (local $l i32) (local $xs i32) (local $j i32) (local $heap_object i32) (local $new_val i32)
    local.get $clos
    i32.load offset=13
    local.set $i
    local.get $clos
    i32.load offset=17
    local.set $l
    local.get $clos
    i32.load offset=21
    local.set $xs
    local.get $i
    i32.load offset=5
    local.get $l
    call $B_ge
    if (result i32)  ;; label = @1
      i32.const 5
    else
      local.get $i
      i32.load offset=5
      local.set $j
      local.get $i
      i32.load offset=5
      i32.const 4
      call $B_add
      local.set $new_val
      local.get $i
      local.get $new_val
      i32.store offset=5
      i32.const 2
      call $alloc_words
      local.tee $heap_object
      i32.const 8
      i32.store offset=1
      local.get $heap_object
      local.get $xs
      local.get $j
      call $Array.idx_bigint
      i32.load offset=1
      i32.store offset=5
      local.get $heap_object
    end)
  (func $anon-func-72.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $i i32) (local $heap_object i32) (local $l i32) (local $next i32) (local $obj i32) (local $next_clos i32) (local $clos.1 i32) (local $new_val i32)
    local.get $clos
    i32.load offset=13
    local.set $xs
    i32.const 2
    call $alloc_words
    local.tee $heap_object
    i32.const 6
    i32.store offset=1
    local.get $heap_object
    i32.const 0
    i32.store offset=5
    local.get $heap_object
    local.set $i
    i32.const 0
    local.set $new_val
    local.get $i
    local.get $new_val
    i32.store offset=5
    i32.const 0
    local.get $xs
    call $@mut_array_size
    local.tee $clos.1
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 5)
    local.set $l
    i32.const 6
    call $alloc_words
    local.tee $next_clos
    i32.const 7
    i32.store offset=1
    local.get $next_clos
    i32.const 15
    i32.store offset=5
    local.get $next_clos
    i32.const 3
    i32.store offset=9
    local.get $next_clos
    local.get $i
    i32.store offset=13
    local.get $next_clos
    local.get $l
    i32.store offset=17
    local.get $next_clos
    local.get $xs
    i32.store offset=21
    local.get $next_clos
    local.set $next
    i32.const 4
    call $alloc_words
    local.tee $obj
    i32.const 1
    i32.store offset=1
    local.get $obj
    i32.const 1
    i32.store offset=5
    local.get $obj
    i32.const 66203
    i32.store offset=9
    local.get $obj
    local.get $next
    i32.store offset=13
    local.get $obj)
  (func $next.3 (type 5) (param $clos i32) (result i32)
    (local $i i32) (local $l i32) (local $xs i32) (local $j i32) (local $heap_object i32) (local $new_val i32)
    local.get $clos
    i32.load offset=13
    local.set $i
    local.get $clos
    i32.load offset=17
    local.set $l
    local.get $clos
    i32.load offset=21
    local.set $xs
    local.get $i
    i32.load offset=5
    local.get $l
    call $B_ge
    if (result i32)  ;; label = @1
      i32.const 5
    else
      local.get $i
      i32.load offset=5
      local.set $j
      local.get $i
      i32.load offset=5
      i32.const 4
      call $B_add
      local.set $new_val
      local.get $i
      local.get $new_val
      i32.store offset=5
      i32.const 2
      call $alloc_words
      local.tee $heap_object
      i32.const 8
      i32.store offset=1
      local.get $heap_object
      local.get $xs
      local.get $j
      call $Array.idx_bigint
      i32.load offset=1
      i32.store offset=5
      local.get $heap_object
    end)
  (func $anon-func-66.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $i i32) (local $heap_object i32) (local $l i32) (local $next i32) (local $obj i32) (local $next_clos i32) (local $clos.1 i32) (local $new_val i32)
    local.get $clos
    i32.load offset=13
    local.set $xs
    i32.const 2
    call $alloc_words
    local.tee $heap_object
    i32.const 6
    i32.store offset=1
    local.get $heap_object
    i32.const 0
    i32.store offset=5
    local.get $heap_object
    local.set $i
    i32.const 0
    local.set $new_val
    local.get $i
    local.get $new_val
    i32.store offset=5
    i32.const 0
    local.get $xs
    call $@immut_array_size
    local.tee $clos.1
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 5)
    local.set $l
    i32.const 6
    call $alloc_words
    local.tee $next_clos
    i32.const 7
    i32.store offset=1
    local.get $next_clos
    i32.const 17
    i32.store offset=5
    local.get $next_clos
    i32.const 3
    i32.store offset=9
    local.get $next_clos
    local.get $i
    i32.store offset=13
    local.get $next_clos
    local.get $l
    i32.store offset=17
    local.get $next_clos
    local.get $xs
    i32.store offset=21
    local.get $next_clos
    local.set $next
    i32.const 4
    call $alloc_words
    local.tee $obj
    i32.const 1
    i32.store offset=1
    local.get $obj
    i32.const 1
    i32.store offset=5
    local.get $obj
    i32.const 66203
    i32.store offset=9
    local.get $obj
    local.get $next
    i32.store offset=13
    local.get $obj)
  (func $next.4 (type 5) (param $clos i32) (result i32)
    (local $i i32) (local $l i32) (local $j i32) (local $heap_object i32) (local $new_val i32)
    local.get $clos
    i32.load offset=13
    local.set $i
    local.get $clos
    i32.load offset=17
    local.set $l
    local.get $i
    i32.load offset=5
    local.get $l
    call $B_ge
    if (result i32)  ;; label = @1
      i32.const 5
    else
      local.get $i
      i32.load offset=5
      local.set $j
      local.get $i
      i32.load offset=5
      i32.const 4
      call $B_add
      local.set $new_val
      local.get $i
      local.get $new_val
      i32.store offset=5
      i32.const 2
      call $alloc_words
      local.tee $heap_object
      i32.const 8
      i32.store offset=1
      local.get $heap_object
      local.get $j
      i32.store offset=5
      local.get $heap_object
    end)
  (func $anon-func-60.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $i i32) (local $heap_object i32) (local $l i32) (local $next i32) (local $obj i32) (local $next_clos i32) (local $clos.1 i32) (local $new_val i32)
    local.get $clos
    i32.load offset=13
    local.set $xs
    i32.const 2
    call $alloc_words
    local.tee $heap_object
    i32.const 6
    i32.store offset=1
    local.get $heap_object
    i32.const 0
    i32.store offset=5
    local.get $heap_object
    local.set $i
    i32.const 0
    local.set $new_val
    local.get $i
    local.get $new_val
    i32.store offset=5
    i32.const 0
    local.get $xs
    call $@mut_array_size
    local.tee $clos.1
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 5)
    local.set $l
    i32.const 5
    call $alloc_words
    local.tee $next_clos
    i32.const 7
    i32.store offset=1
    local.get $next_clos
    i32.const 19
    i32.store offset=5
    local.get $next_clos
    i32.const 2
    i32.store offset=9
    local.get $next_clos
    local.get $i
    i32.store offset=13
    local.get $next_clos
    local.get $l
    i32.store offset=17
    local.get $next_clos
    local.set $next
    i32.const 4
    call $alloc_words
    local.tee $obj
    i32.const 1
    i32.store offset=1
    local.get $obj
    i32.const 1
    i32.store offset=5
    local.get $obj
    i32.const 66203
    i32.store offset=9
    local.get $obj
    local.get $next
    i32.store offset=13
    local.get $obj)
  (func $next.5 (type 5) (param $clos i32) (result i32)
    (local $i i32) (local $l i32) (local $j i32) (local $heap_object i32) (local $new_val i32)
    local.get $clos
    i32.load offset=13
    local.set $i
    local.get $clos
    i32.load offset=17
    local.set $l
    local.get $i
    i32.load offset=5
    local.get $l
    call $B_ge
    if (result i32)  ;; label = @1
      i32.const 5
    else
      local.get $i
      i32.load offset=5
      local.set $j
      local.get $i
      i32.load offset=5
      i32.const 4
      call $B_add
      local.set $new_val
      local.get $i
      local.get $new_val
      i32.store offset=5
      i32.const 2
      call $alloc_words
      local.tee $heap_object
      i32.const 8
      i32.store offset=1
      local.get $heap_object
      local.get $j
      i32.store offset=5
      local.get $heap_object
    end)
  (func $anon-func-54.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $i i32) (local $heap_object i32) (local $l i32) (local $next i32) (local $obj i32) (local $next_clos i32) (local $clos.1 i32) (local $new_val i32)
    local.get $clos
    i32.load offset=13
    local.set $xs
    i32.const 2
    call $alloc_words
    local.tee $heap_object
    i32.const 6
    i32.store offset=1
    local.get $heap_object
    i32.const 0
    i32.store offset=5
    local.get $heap_object
    local.set $i
    i32.const 0
    local.set $new_val
    local.get $i
    local.get $new_val
    i32.store offset=5
    i32.const 0
    local.get $xs
    call $@immut_array_size
    local.tee $clos.1
    local.get $clos.1
    i32.load offset=5
    call_indirect (type 5)
    local.set $l
    i32.const 5
    call $alloc_words
    local.tee $next_clos
    i32.const 7
    i32.store offset=1
    local.get $next_clos
    i32.const 21
    i32.store offset=5
    local.get $next_clos
    i32.const 2
    i32.store offset=9
    local.get $next_clos
    local.get $i
    i32.store offset=13
    local.get $next_clos
    local.get $l
    i32.store offset=17
    local.get $next_clos
    local.set $next
    i32.const 4
    call $alloc_words
    local.tee $obj
    i32.const 1
    i32.store offset=1
    local.get $obj
    i32.const 1
    i32.store offset=5
    local.get $obj
    i32.const 66203
    i32.store offset=9
    local.get $obj
    local.get $next
    i32.store offset=13
    local.get $obj)
  (func $anon-func-52.3 (type 1) (param $clos i32) (param $n i32) (param $x i32)
    (local $xs i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    local.get $n
    call $Array.idx_bigint
    local.get $x
    i32.store offset=1)
  (func $anon-func-50.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $a i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    i32.load offset=5
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $anon-func-48.3 (type 5) (param $clos i32) (result i32)
    (local $xs i32) (local $a i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    i32.load offset=5
    local.tee $a
    i32.const -1073741824
    i32.and
    if (result i32)  ;; label = @1
      local.get $a
      i64.extend_i32_u
      call $bigint_of_word64
    else
      local.get $a
      i32.const 2
      i32.rotl
    end)
  (func $anon-func-46.3 (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $xs i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    local.get $n
    call $Array.idx_bigint
    i32.load offset=1)
  (func $anon-func-44.3 (type 6) (param $clos i32) (param $n i32) (result i32)
    (local $xs i32)
    local.get $clos
    i32.load offset=13
    local.tee $xs
    local.get $n
    call $Array.idx_bigint
    i32.load offset=1)
  (func $start (type 15)
    i32.const 0
    i32.const 655360
    call $fib
    i32.const 3604480
    i32.eq
    if  ;; label = @1
    else
      i32.const 65584
      i32.const 73
      call $print_ptr
      unreachable
    end)
  (func $trans_state4 (type 15)
    block  ;; label = @1
      i32.const 65536
      i32.load
      i32.const 3
      i32.eq
      if  ;; label = @2
        br 1 (;@1;)
      end
      i32.const 65536
      i32.load
      i32.const 5
      i32.eq
      if  ;; label = @2
        br 1 (;@1;)
      end
      i32.const 65536
      i32.load
      i32.const 10
      i32.eq
      if  ;; label = @2
        br 1 (;@1;)
      end
      i32.const 66272
      i32.const 46
      call $print_ptr
      unreachable
    end
    i32.const 65536
    i32.const 4
    i32.store)
  (func $trans_state3 (type 15)
    block  ;; label = @1
      i32.const 65536
      i32.load
      i32.const 0
      i32.eq
      if  ;; label = @2
        br 1 (;@1;)
      end
      i32.const 66320
      i32.const 48
      call $print_ptr
      unreachable
    end
    i32.const 65536
    i32.const 3
    i32.store)
  (func $_start (type 15)
    call $trans_state3
    call $start
    call $trans_state4)
  (func $rts_start (type 15)
    global.get 8
    global.set 0
    i32.const 65536
    i32.const 0
    i32.store)
  (func $__wasm_call_ctors (type 21)
    call $__wasm_apply_relocs)
  (func $__wasm_apply_relocs (type 21)
    i32.const 66384
    i32.const 28
    i32.add
    i32.const 66384
    i32.const 24
    i32.add
    i32.store
    i32.const 66384
    i32.const 32
    i32.add
    i32.const 28
    i32.const 0
    i32.add
    i32.store)
  (func $alloc_blob (type 19) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 8
    i32.add
    call $alloc_bytes
    local.tee 1
    i32.const 5
    i32.add
    local.get 0
    i32.store
    local.get 1
    i32.const 1
    i32.add
    i32.const 10
    i32.store
    local.get 1)
  (func $alloc (type 19) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 8
    i32.add
    call $alloc_bytes
    local.tee 1
    i32.const 5
    i32.add
    local.get 0
    i32.store
    local.get 1
    i32.const 1
    i32.add
    i32.const 10
    i32.store
    local.get 1
    i32.const 9
    i32.add)
  (func $as_memcpy (type 22) (param i32 i32 i32)
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 0
        local.get 1
        i32.load8_u
        i32.store8
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end)
  (func $as_memcmp (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 3
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          local.get 0
          i32.load8_u
          local.tee 4
          local.get 1
          i32.load8_u
          local.tee 5
          i32.ne
          br_if 1 (;@2;)
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 2
          i32.const -1
          i32.add
          local.tee 2
          i32.eqz
          br_if 2 (;@1;)
          br 0 (;@3;)
        end
      end
      local.get 4
      local.get 5
      i32.sub
      local.set 3
    end
    local.get 3)
  (func $as_strlen (type 19) (param i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 1
    loop  ;; label = @1
      local.get 0
      local.get 1
      i32.add
      local.set 2
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      local.set 1
      local.get 2
      i32.load8_u
      br_if 0 (;@1;)
    end
    local.get 3
    i32.const -1
    i32.add)
  (func $trap_with_prefix (type 20) (param i32 i32)
    (local i32 i32 i32 i32 i32)
    global.get 4
    local.tee 2
    drop
    i32.const -1
    local.set 3
    loop  ;; label = @1
      local.get 0
      local.get 3
      i32.add
      local.set 4
      local.get 3
      i32.const 1
      i32.add
      local.tee 5
      local.set 3
      local.get 4
      i32.const 1
      i32.add
      i32.load8_u
      br_if 0 (;@1;)
    end
    i32.const 0
    local.set 3
    loop  ;; label = @1
      local.get 1
      local.get 3
      i32.add
      local.set 6
      local.get 3
      i32.const 1
      i32.add
      local.tee 4
      local.set 3
      local.get 6
      i32.load8_u
      br_if 0 (;@1;)
    end
    local.get 2
    local.get 5
    local.get 4
    i32.add
    local.tee 6
    i32.const 14
    i32.add
    i32.const -16
    i32.and
    i32.sub
    local.tee 3
    global.set 4
    local.get 3
    local.get 0
    local.get 5
    call $as_memcpy
    local.get 3
    local.get 5
    i32.add
    local.get 1
    local.get 4
    i32.const -1
    i32.add
    call $as_memcpy
    local.get 3
    local.get 6
    i32.const -1
    i32.add
    call $rts_trap
    unreachable)
  (func $idl_trap_with (type 23) (param i32)
    i32.const 66384
    i32.const 0
    i32.add
    local.get 0
    call $trap_with_prefix
    unreachable)
  (func $rts_trap_with (type 23) (param i32)
    i32.const 66384
    i32.const 12
    i32.add
    local.get 0
    call $trap_with_prefix
    unreachable)
  (func $get_version (type 17) (result i32)
    i32.const 66384
    i32.const 28
    i32.add
    i32.load
    call $text_of_cstr)
  (func $version (type 17) (result i32)
    i32.const 66384
    i32.const 32
    i32.add
    i32.load
    call_indirect (type 17))
  (func $leb128_encode (type 20) (param i32 i32)
    (local i32 i32)
    local.get 1
    local.get 0
    i32.store8
    block  ;; label = @1
      local.get 0
      i32.const 7
      i32.shr_u
      local.tee 2
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        local.get 2
        i32.store8 offset=1
        local.get 1
        local.get 0
        i32.const 128
        i32.or
        i32.store8
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 2
        local.set 0
        local.get 2
        i32.const 7
        i32.shr_u
        local.tee 3
        local.set 2
        local.get 3
        br_if 0 (;@2;)
      end
    end)
  (func $sleb128_encode (type 20) (param i32 i32)
    local.get 1
    local.get 0
    i32.const 127
    i32.and
    i32.store8
    block  ;; label = @1
      local.get 0
      i32.const 64
      i32.add
      i32.const 128
      i32.lt_u
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        local.get 0
        i32.const 128
        i32.or
        i32.store8
        local.get 1
        local.get 0
        i32.const 7
        i32.shr_s
        local.tee 0
        i32.const 127
        i32.and
        i32.store8 offset=1
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 0
        i32.const 64
        i32.add
        i32.const 128
        i32.ge_u
        br_if 0 (;@2;)
      end
    end)
  (func $read_u32_of_leb128 (type 19) (param i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 1
    i32.const 0
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 0
          call $read_byte
          local.set 3
          block  ;; label = @4
            local.get 1
            i32.eqz
            br_if 0 (;@4;)
            local.get 3
            i32.eqz
            br_if 2 (;@2;)
          end
          block  ;; label = @4
            local.get 1
            i32.const 28
            i32.ne
            br_if 0 (;@4;)
            local.get 3
            i32.const 16
            i32.ge_u
            br_if 3 (;@1;)
          end
          local.get 3
          i32.const 127
          i32.and
          local.get 1
          i32.shl
          local.get 2
          i32.add
          local.set 2
          local.get 1
          i32.const 7
          i32.add
          local.set 1
          local.get 3
          i32.const 128
          i32.and
          br_if 0 (;@3;)
        end
        local.get 2
        return
      end
      i32.const 66384
      i32.const 36
      i32.add
      call $idl_trap_with
      unreachable
    end
    i32.const 66384
    i32.const 58
    i32.add
    call $idl_trap_with
    unreachable)
  (func $read_i32_of_sleb128 (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    i32.const 0
    local.set 1
    i32.const 0
    local.set 2
    i32.const 0
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 0
          call $read_byte
          local.set 4
          block  ;; label = @4
            local.get 1
            i32.eqz
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 1
              i32.const 28
              i32.ne
              br_if 0 (;@5;)
              local.get 4
              i32.const 240
              i32.and
              local.tee 5
              i32.eqz
              br_if 0 (;@5;)
              local.get 5
              i32.const 112
              i32.ne
              br_if 3 (;@2;)
            end
            local.get 4
            i32.const 127
            i32.eq
            local.get 4
            i32.eqz
            local.get 3
            i32.const 1
            i32.and
            select
            i32.const 1
            i32.eq
            br_if 3 (;@1;)
          end
          local.get 4
          i32.const 64
          i32.and
          local.tee 6
          i32.const 6
          i32.shr_u
          local.set 3
          local.get 4
          i32.const 127
          i32.and
          local.get 1
          i32.shl
          local.get 2
          i32.add
          local.set 2
          local.get 1
          i32.const 7
          i32.add
          local.tee 5
          local.set 1
          local.get 4
          i32.const 128
          i32.and
          br_if 0 (;@3;)
        end
        i32.const 0
        i32.const -1
        local.get 5
        i32.shl
        i32.const 0
        local.get 6
        select
        local.get 5
        i32.const 31
        i32.gt_u
        select
        local.get 2
        i32.or
        return
      end
      i32.const 66384
      i32.const 58
      i32.add
      call $idl_trap_with
      unreachable
    end
    i32.const 66384
    i32.const 36
    i32.add
    call $idl_trap_with
    unreachable)
  (func $parse_idl_header (type 24) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            i32.load
            local.get 1
            i32.load offset=4
            i32.eq
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 1
              call $read_word
              i32.const 1279543620
              i32.ne
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 1
                call $read_u32_of_leb128
                local.tee 4
                i32.const -1
                i32.le_s
                br_if 0 (;@6;)
                block  ;; label = @7
                  local.get 1
                  i32.load
                  local.get 4
                  i32.add
                  local.get 1
                  i32.load offset=4
                  i32.ge_u
                  br_if 0 (;@7;)
                  local.get 4
                  i32.const 2
                  i32.shl
                  call $alloc
                  local.set 5
                  local.get 1
                  i32.load
                  local.set 6
                  local.get 4
                  i32.const 1
                  i32.lt_s
                  br_if 6 (;@1;)
                  i32.const 0
                  local.set 7
                  loop  ;; label = @8
                    local.get 5
                    local.get 7
                    i32.const 2
                    i32.shl
                    i32.add
                    local.get 6
                    i32.store
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 1
                        call $read_i32_of_sleb128
                        local.tee 6
                        i32.const 1
                        i32.ne
                        br_if 0 (;@10;)
                        local.get 0
                        i32.eqz
                        br_if 0 (;@10;)
                        block  ;; label = @11
                          block  ;; label = @12
                            local.get 1
                            call $read_i32_of_sleb128
                            local.tee 6
                            i32.const -1
                            i32.gt_s
                            br_if 0 (;@12;)
                            local.get 6
                            i32.const -18
                            i32.gt_s
                            br_if 3 (;@9;)
                            local.get 6
                            i32.const -24
                            i32.ne
                            br_if 1 (;@11;)
                            br 3 (;@9;)
                          end
                          local.get 6
                          local.get 4
                          i32.lt_u
                          br_if 2 (;@9;)
                        end
                        i32.const 66384
                        i32.const 402
                        i32.add
                        call $idl_trap_with
                        unreachable
                      end
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 6
                                i32.const 0
                                i32.ge_s
                                br_if 0 (;@14;)
                                local.get 6
                                i32.const -18
                                i32.gt_s
                                br_if 1 (;@13;)
                                local.get 6
                                i32.const -24
                                i32.eq
                                br_if 1 (;@13;)
                                block  ;; label = @15
                                  local.get 6
                                  i32.const 23
                                  i32.add
                                  local.tee 6
                                  i32.const 5
                                  i32.gt_u
                                  br_if 0 (;@15;)
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              local.get 6
                                              br_table 5 (;@16;) 4 (;@17;) 3 (;@18;) 2 (;@19;) 1 (;@20;) 0 (;@21;) 5 (;@16;)
                                            end
                                            block  ;; label = @21
                                              block  ;; label = @22
                                                local.get 1
                                                call $read_i32_of_sleb128
                                                local.tee 6
                                                i32.const -1
                                                i32.gt_s
                                                br_if 0 (;@22;)
                                                local.get 6
                                                i32.const -18
                                                i32.gt_s
                                                br_if 13 (;@9;)
                                                local.get 6
                                                i32.const -24
                                                i32.ne
                                                br_if 1 (;@21;)
                                                br 13 (;@9;)
                                              end
                                              local.get 6
                                              local.get 4
                                              i32.lt_u
                                              br_if 12 (;@9;)
                                            end
                                            i32.const 66384
                                            i32.const 402
                                            i32.add
                                            call $idl_trap_with
                                            unreachable
                                          end
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              local.get 1
                                              call $read_i32_of_sleb128
                                              local.tee 6
                                              i32.const -1
                                              i32.gt_s
                                              br_if 0 (;@21;)
                                              local.get 6
                                              i32.const -18
                                              i32.gt_s
                                              br_if 12 (;@9;)
                                              local.get 6
                                              i32.const -24
                                              i32.ne
                                              br_if 1 (;@20;)
                                              br 12 (;@9;)
                                            end
                                            local.get 6
                                            local.get 4
                                            i32.lt_u
                                            br_if 11 (;@9;)
                                          end
                                          i32.const 66384
                                          i32.const 402
                                          i32.add
                                          call $idl_trap_with
                                          unreachable
                                        end
                                        local.get 1
                                        call $read_u32_of_leb128
                                        local.tee 8
                                        i32.eqz
                                        br_if 9 (;@9;)
                                        loop  ;; label = @19
                                          local.get 1
                                          call $read_u32_of_leb128
                                          drop
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              local.get 1
                                              call $read_i32_of_sleb128
                                              local.tee 6
                                              i32.const -1
                                              i32.gt_s
                                              br_if 0 (;@21;)
                                              local.get 6
                                              i32.const -18
                                              i32.gt_s
                                              br_if 1 (;@20;)
                                              local.get 6
                                              i32.const -24
                                              i32.eq
                                              br_if 1 (;@20;)
                                              br 19 (;@2;)
                                            end
                                            local.get 6
                                            local.get 4
                                            i32.ge_u
                                            br_if 18 (;@2;)
                                          end
                                          local.get 8
                                          i32.const -1
                                          i32.add
                                          local.tee 8
                                          br_if 0 (;@19;)
                                          br 10 (;@9;)
                                        end
                                      end
                                      local.get 1
                                      call $read_u32_of_leb128
                                      local.tee 8
                                      i32.eqz
                                      br_if 8 (;@9;)
                                      loop  ;; label = @18
                                        local.get 1
                                        call $read_u32_of_leb128
                                        drop
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            local.get 1
                                            call $read_i32_of_sleb128
                                            local.tee 6
                                            i32.const -1
                                            i32.gt_s
                                            br_if 0 (;@20;)
                                            local.get 6
                                            i32.const -18
                                            i32.gt_s
                                            br_if 1 (;@19;)
                                            local.get 6
                                            i32.const -24
                                            i32.eq
                                            br_if 1 (;@19;)
                                            br 17 (;@3;)
                                          end
                                          local.get 6
                                          local.get 4
                                          i32.ge_u
                                          br_if 16 (;@3;)
                                        end
                                        local.get 8
                                        i32.const -1
                                        i32.add
                                        local.tee 8
                                        br_if 0 (;@18;)
                                        br 9 (;@9;)
                                      end
                                    end
                                    local.get 1
                                    call $read_u32_of_leb128
                                    local.tee 8
                                    i32.eqz
                                    br_if 6 (;@10;)
                                    loop  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          local.get 1
                                          call $read_i32_of_sleb128
                                          local.tee 6
                                          i32.const -1
                                          i32.gt_s
                                          br_if 0 (;@19;)
                                          local.get 6
                                          i32.const -18
                                          i32.gt_s
                                          br_if 1 (;@18;)
                                          local.get 6
                                          i32.const -24
                                          i32.eq
                                          br_if 1 (;@18;)
                                          br 8 (;@11;)
                                        end
                                        local.get 6
                                        local.get 4
                                        i32.ge_u
                                        br_if 7 (;@11;)
                                      end
                                      local.get 8
                                      i32.const -1
                                      i32.add
                                      local.tee 8
                                      i32.eqz
                                      br_if 7 (;@10;)
                                      br 0 (;@17;)
                                    end
                                  end
                                  local.get 1
                                  call $read_u32_of_leb128
                                  local.tee 8
                                  i32.eqz
                                  br_if 6 (;@9;)
                                  loop  ;; label = @16
                                    local.get 1
                                    local.get 1
                                    call $read_u32_of_leb128
                                    local.get 1
                                    i32.load
                                    i32.add
                                    i32.store
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        local.get 1
                                        call $read_i32_of_sleb128
                                        local.tee 6
                                        i32.const -1
                                        i32.gt_s
                                        br_if 0 (;@18;)
                                        local.get 6
                                        i32.const -18
                                        i32.gt_s
                                        br_if 1 (;@17;)
                                        local.get 6
                                        i32.const -24
                                        i32.eq
                                        br_if 1 (;@17;)
                                        br 6 (;@12;)
                                      end
                                      local.get 6
                                      local.get 4
                                      i32.ge_u
                                      br_if 5 (;@12;)
                                    end
                                    local.get 8
                                    i32.const -1
                                    i32.add
                                    local.tee 8
                                    br_if 0 (;@16;)
                                    br 7 (;@9;)
                                  end
                                end
                                local.get 1
                                local.get 1
                                call $read_u32_of_leb128
                                call $advance
                                br 5 (;@9;)
                              end
                              i32.const 66384
                              i32.const 146
                              i32.add
                              call $idl_trap_with
                              unreachable
                            end
                            i32.const 66384
                            i32.const 165
                            i32.add
                            call $idl_trap_with
                            unreachable
                          end
                          i32.const 66384
                          i32.const 402
                          i32.add
                          call $idl_trap_with
                          unreachable
                        end
                        i32.const 66384
                        i32.const 402
                        i32.add
                        call $idl_trap_with
                        unreachable
                      end
                      block  ;; label = @10
                        local.get 1
                        call $read_u32_of_leb128
                        local.tee 8
                        i32.eqz
                        br_if 0 (;@10;)
                        block  ;; label = @11
                          loop  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 1
                                call $read_i32_of_sleb128
                                local.tee 6
                                i32.const -1
                                i32.gt_s
                                br_if 0 (;@14;)
                                local.get 6
                                i32.const -18
                                i32.gt_s
                                br_if 1 (;@13;)
                                local.get 6
                                i32.const -24
                                i32.eq
                                br_if 1 (;@13;)
                                br 3 (;@11;)
                              end
                              local.get 6
                              local.get 4
                              i32.ge_u
                              br_if 2 (;@11;)
                            end
                            local.get 8
                            i32.const -1
                            i32.add
                            local.tee 8
                            i32.eqz
                            br_if 2 (;@10;)
                            br 0 (;@12;)
                          end
                        end
                        i32.const 66384
                        i32.const 402
                        i32.add
                        call $idl_trap_with
                        unreachable
                      end
                      local.get 1
                      call $read_u32_of_leb128
                      local.tee 6
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 1
                      local.get 1
                      i32.load
                      local.get 6
                      i32.add
                      i32.store
                    end
                    local.get 1
                    i32.load
                    local.set 6
                    local.get 7
                    i32.const 1
                    i32.add
                    local.tee 7
                    local.get 4
                    i32.ne
                    br_if 0 (;@8;)
                    br 7 (;@1;)
                  end
                end
                i32.const 66384
                i32.const 131
                i32.add
                call $idl_trap_with
                unreachable
              end
              i32.const 66384
              i32.const 103
              i32.add
              call $idl_trap_with
              unreachable
            end
            i32.const 66384
            i32.const 83
            i32.add
            call $idl_trap_with
            unreachable
          end
          i32.const 66384
          i32.const 71
          i32.add
          call $idl_trap_with
          unreachable
        end
        i32.const 66384
        i32.const 402
        i32.add
        call $idl_trap_with
        unreachable
      end
      i32.const 66384
      i32.const 402
      i32.add
      call $idl_trap_with
      unreachable
    end
    local.get 3
    local.get 6
    i32.store
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        call $read_u32_of_leb128
        local.tee 7
        i32.eqz
        br_if 0 (;@2;)
        loop  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              call $read_i32_of_sleb128
              local.tee 6
              i32.const -1
              i32.gt_s
              br_if 0 (;@5;)
              local.get 6
              i32.const -18
              i32.gt_s
              br_if 1 (;@4;)
              local.get 6
              i32.const -24
              i32.eq
              br_if 1 (;@4;)
              br 4 (;@1;)
            end
            local.get 6
            local.get 4
            i32.ge_u
            br_if 3 (;@1;)
          end
          local.get 7
          i32.const -1
          i32.add
          local.tee 7
          br_if 0 (;@3;)
        end
      end
      local.get 2
      local.get 5
      i32.store
      return
    end
    i32.const 66384
    i32.const 402
    i32.add
    call $idl_trap_with
    unreachable)
  (func $skip_leb128 (type 23) (param i32)
    loop  ;; label = @1
      local.get 0
      call $read_byte
      i32.const 24
      i32.shl
      i32.const 24
      i32.shr_s
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
    end)
  (func $skip_any (type 24) (param i32 i32 i32 i32)
    (local i32 i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 4
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const 101
          i32.ge_s
          br_if 0 (;@3;)
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 2
                i32.const -1
                i32.gt_s
                br_if 0 (;@6;)
                block  ;; label = @7
                  local.get 2
                  i32.const 24
                  i32.add
                  local.tee 2
                  i32.const 23
                  i32.gt_u
                  br_if 0 (;@7;)
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 2
                                br_table 6 (;@8;) 7 (;@7;) 7 (;@7;) 7 (;@7;) 7 (;@7;) 7 (;@7;) 7 (;@7;) 5 (;@9;) 10 (;@4;) 4 (;@10;) 3 (;@11;) 2 (;@12;) 3 (;@11;) 2 (;@12;) 1 (;@13;) 9 (;@5;) 3 (;@11;) 2 (;@12;) 1 (;@13;) 9 (;@5;) 0 (;@14;) 0 (;@14;) 9 (;@5;) 10 (;@4;) 6 (;@8;)
                              end
                              loop  ;; label = @14
                                local.get 0
                                call $read_byte
                                i32.const 24
                                i32.shl
                                i32.const 24
                                i32.shr_s
                                i32.const 0
                                i32.lt_s
                                br_if 0 (;@14;)
                                br 10 (;@4;)
                              end
                            end
                            local.get 0
                            i32.const 2
                            call $advance
                            br 8 (;@4;)
                          end
                          local.get 0
                          i32.const 4
                          call $advance
                          br 7 (;@4;)
                        end
                        local.get 0
                        i32.const 8
                        call $advance
                        br 6 (;@4;)
                      end
                      local.get 0
                      local.get 0
                      call $read_u32_of_leb128
                      call $advance
                      br 5 (;@4;)
                    end
                    i32.const 66384
                    i32.const 229
                    i32.add
                    call $idl_trap_with
                    unreachable
                  end
                  local.get 0
                  call $read_byte
                  i32.eqz
                  br_if 3 (;@4;)
                  local.get 0
                  local.get 0
                  call $read_u32_of_leb128
                  call $advance
                  br 3 (;@4;)
                end
                i32.const 66384
                i32.const 257
                i32.add
                call $idl_trap_with
                unreachable
              end
              local.get 4
              local.get 0
              i32.load offset=4
              i32.store offset=12
              local.get 4
              local.get 1
              local.get 2
              i32.const 2
              i32.shl
              i32.add
              i32.load
              i32.store offset=8
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 4
                      i32.const 8
                      i32.add
                      call $read_i32_of_sleb128
                      local.tee 5
                      i32.const 23
                      i32.add
                      local.tee 6
                      i32.const 5
                      i32.le_u
                      br_if 0 (;@9;)
                      local.get 5
                      i32.const 1
                      i32.eq
                      br_if 1 (;@8;)
                      local.get 0
                      call $read_u32_of_leb128
                      local.set 2
                      local.get 0
                      call $read_u32_of_leb128
                      local.set 1
                      local.get 0
                      local.get 2
                      call $advance
                      local.get 1
                      i32.eqz
                      br_if 3 (;@6;)
                      i32.const 66384
                      i32.const 372
                      i32.add
                      call $idl_trap_with
                      unreachable
                    end
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 6
                                br_table 5 (;@9;) 4 (;@10;) 3 (;@11;) 2 (;@12;) 1 (;@13;) 0 (;@14;) 5 (;@9;)
                              end
                              local.get 4
                              i32.const 8
                              i32.add
                              call $read_i32_of_sleb128
                              local.set 2
                              local.get 0
                              call $read_byte
                              i32.eqz
                              br_if 7 (;@6;)
                              local.get 0
                              local.get 1
                              local.get 2
                              i32.const 0
                              call $skip_any
                              br 7 (;@6;)
                            end
                            local.get 4
                            i32.const 8
                            i32.add
                            call $read_i32_of_sleb128
                            local.set 6
                            local.get 0
                            call $read_u32_of_leb128
                            local.tee 2
                            i32.eqz
                            br_if 6 (;@6;)
                            loop  ;; label = @13
                              local.get 0
                              local.get 1
                              local.get 6
                              i32.const 0
                              call $skip_any
                              local.get 2
                              i32.const -1
                              i32.add
                              local.tee 2
                              br_if 0 (;@13;)
                              br 7 (;@6;)
                            end
                          end
                          local.get 4
                          i32.const 8
                          i32.add
                          call $read_u32_of_leb128
                          local.tee 6
                          i32.eqz
                          br_if 5 (;@6;)
                          local.get 3
                          i32.const 1
                          i32.add
                          local.set 5
                          loop  ;; label = @12
                            local.get 4
                            i32.const 8
                            i32.add
                            call $read_byte
                            i32.const 24
                            i32.shl
                            i32.const 24
                            i32.shr_s
                            i32.const 0
                            i32.lt_s
                            br_if 0 (;@12;)
                            local.get 4
                            i32.const 8
                            i32.add
                            call $read_i32_of_sleb128
                            local.tee 3
                            local.get 2
                            i32.eq
                            br_if 10 (;@2;)
                            local.get 0
                            local.get 1
                            local.get 3
                            local.get 5
                            call $skip_any
                            local.get 6
                            i32.const -1
                            i32.add
                            local.tee 6
                            br_if 0 (;@12;)
                            br 6 (;@6;)
                          end
                        end
                        local.get 4
                        i32.const 8
                        i32.add
                        call $read_u32_of_leb128
                        local.set 6
                        local.get 0
                        call $read_u32_of_leb128
                        local.tee 2
                        local.get 6
                        i32.ge_u
                        br_if 9 (;@1;)
                        loop  ;; label = @11
                          local.get 4
                          i32.const 8
                          i32.add
                          call $read_byte
                          i32.const 24
                          i32.shl
                          i32.const 24
                          i32.shr_s
                          i32.const 0
                          i32.lt_s
                          br_if 0 (;@11;)
                          local.get 2
                          i32.eqz
                          br_if 4 (;@7;)
                          loop  ;; label = @12
                            local.get 4
                            i32.const 8
                            i32.add
                            call $read_byte
                            i32.const 24
                            i32.shl
                            i32.const 24
                            i32.shr_s
                            i32.const 0
                            i32.lt_s
                            br_if 0 (;@12;)
                          end
                          local.get 2
                          i32.const -1
                          i32.add
                          local.set 2
                          br 0 (;@11;)
                        end
                      end
                      i32.const 66384
                      i32.const 339
                      i32.add
                      call $idl_trap_with
                      unreachable
                    end
                    i32.const 66384
                    i32.const 354
                    i32.add
                    call $idl_trap_with
                    unreachable
                  end
                  local.get 4
                  i32.const 8
                  i32.add
                  call $read_i32_of_sleb128
                  local.set 2
                  block  ;; label = @8
                    local.get 0
                    call $read_byte
                    br_if 0 (;@8;)
                    local.get 0
                    i32.const 8
                    call $advance
                    local.get 0
                    local.get 1
                    local.get 2
                    i32.const 0
                    call $skip_any
                    br 2 (;@6;)
                  end
                  local.get 0
                  i32.const 4
                  call $advance
                  br 1 (;@6;)
                end
                local.get 0
                local.get 1
                local.get 4
                i32.const 8
                i32.add
                call $read_i32_of_sleb128
                i32.const 0
                call $skip_any
              end
              local.get 4
              i32.const 16
              i32.add
              global.set 4
              return
            end
            local.get 0
            i32.const 1
            call $advance
          end
          local.get 4
          i32.const 16
          i32.add
          global.set 4
          return
        end
        i32.const 66384
        i32.const 194
        i32.add
        call $idl_trap_with
        unreachable
      end
      i32.const 66384
      i32.const 280
      i32.add
      call $idl_trap_with
      unreachable
    end
    i32.const 66384
    i32.const 307
    i32.add
    call $idl_trap_with
    unreachable)
  (func $find_field (type 25) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32)
    i32.const 0
    local.set 5
    block  ;; label = @1
      local.get 4
      i32.load
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 0
        i32.load
        local.set 5
        block  ;; label = @3
          local.get 0
          call $read_u32_of_leb128
          local.tee 6
          local.get 3
          i32.lt_u
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 6
            local.get 3
            i32.ne
            br_if 0 (;@4;)
            local.get 4
            local.get 4
            i32.load
            i32.const -1
            i32.add
            i32.store
            i32.const 1
            return
          end
          local.get 0
          local.get 5
          i32.store
          i32.const 0
          return
        end
        i32.const 0
        local.set 5
        local.get 1
        local.get 2
        local.get 0
        call $read_i32_of_sleb128
        i32.const 0
        call $skip_any
        local.get 4
        local.get 4
        i32.load
        i32.const -1
        i32.add
        local.tee 6
        i32.store
        local.get 6
        br_if 0 (;@2;)
      end
    end
    local.get 5)
  (func $skip_fields (type 24) (param i32 i32 i32 i32)
    (local i32)
    block  ;; label = @1
      local.get 3
      i32.load8_u
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 0
        call $read_byte
        i32.const 24
        i32.shl
        i32.const 24
        i32.shr_s
        i32.const 0
        i32.lt_s
        br_if 0 (;@2;)
        local.get 1
        local.get 2
        local.get 0
        call $read_i32_of_sleb128
        i32.const 0
        call $skip_any
        local.get 3
        local.get 3
        i32.load8_u
        i32.const -1
        i32.add
        local.tee 4
        i32.store8
        local.get 4
        i32.const 255
        i32.and
        br_if 0 (;@2;)
      end
    end)
  (func $mp_calloc (type 26) (param i32 i32) (result i32)
    (local i32)
    local.get 1
    local.get 0
    i32.mul
    local.tee 0
    call $alloc
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      local.set 1
      loop  ;; label = @2
        local.get 1
        i32.const 0
        i32.store8
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 0
        i32.const -1
        i32.add
        local.tee 0
        br_if 0 (;@2;)
      end
    end
    local.get 2)
  (func $mp_realloc (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const -8
      i32.add
      i32.load
      i32.const 10
      i32.ne
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 0
        i32.const -9
        i32.add
        i32.const 5
        i32.add
        local.tee 3
        i32.load
        local.tee 4
        local.get 2
        i32.ge_u
        br_if 0 (;@2;)
        local.get 2
        call $alloc
        local.set 2
        local.get 3
        i32.load
        local.get 1
        i32.ne
        br_if 1 (;@1;)
        local.get 2
        local.get 0
        local.get 1
        call $as_memcpy
        local.get 2
        return
      end
      local.get 4
      local.get 2
      i32.ne
      br_if 0 (;@1;)
      local.get 0
      return
    end
    call $bigint_trap
    unreachable)
  (func $mp_free (type 20) (param i32 i32))
  (func $bigint_alloc (type 17) (result i32)
    (local i32)
    i32.const 20
    call $alloc_bytes
    local.tee 0
    i32.const 1
    i32.add
    i32.const 13
    i32.store
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      call $mp_init
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 0)
  (func $bigint_of_word32 (type 19) (param i32) (result i32)
    (local i32)
    call $bigint_alloc
    local.tee 1
    i32.const 5
    i32.add
    local.get 0
    call $mp_set_u32
    local.get 1)
  (func $bigint_of_word32_signed (type 19) (param i32) (result i32)
    (local i32)
    call $bigint_alloc
    local.tee 1
    i32.const 5
    i32.add
    local.get 0
    call $mp_set_i32
    local.get 1)
  (func $bigint_to_word32_wrap (type 19) (param i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    call $mp_get_i32)
  (func $bigint_to_word32_trap (type 19) (param i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 13
      i32.add
      i32.load
      br_if 0 (;@1;)
      local.get 0
      i32.const 5
      i32.add
      local.tee 0
      call $mp_count_bits
      i32.const 33
      i32.ge_s
      br_if 0 (;@1;)
      local.get 0
      call $mp_get_i32
      return
    end
    call $bigint_trap
    unreachable)
  (func $bigint_to_word32_trap_with (type 26) (param i32 i32) (result i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.const 13
        i32.add
        i32.load
        br_if 0 (;@2;)
        local.get 0
        i32.const 5
        i32.add
        local.tee 0
        call $mp_count_bits
        i32.const 33
        i32.lt_s
        br_if 1 (;@1;)
      end
      local.get 1
      i32.const 9
      i32.add
      local.get 1
      i32.const 5
      i32.add
      i32.load
      call $rts_trap
      unreachable
    end
    local.get 0
    call $mp_get_i32)
  (func $bigint_to_word32_signed_trap (type 19) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      local.tee 1
      call $mp_count_bits
      i32.const 33
      i32.ge_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 1
      i32.add
      i32.load offset=12
      local.set 2
      local.get 1
      call $mp_get_mag_u32
      local.set 0
      block  ;; label = @2
        local.get 2
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 0
        i32.le_s
        br_if 1 (;@1;)
        i32.const 0
        local.get 0
        i32.sub
        return
      end
      local.get 0
      i32.const -1
      i32.le_s
      br_if 0 (;@1;)
      local.get 0
      return
    end
    call $bigint_trap
    unreachable)
  (func $bigint_to_word64_wrap (type 27) (param i32) (result i64)
    local.get 0
    i32.const 5
    i32.add
    call $mp_get_i64)
  (func $bigint_to_word64_trap (type 27) (param i32) (result i64)
    block  ;; label = @1
      local.get 0
      i32.const 13
      i32.add
      i32.load
      br_if 0 (;@1;)
      local.get 0
      i32.const 5
      i32.add
      local.tee 0
      call $mp_count_bits
      i32.const 65
      i32.ge_s
      br_if 0 (;@1;)
      local.get 0
      call $mp_get_i64
      return
    end
    call $bigint_trap
    unreachable)
  (func $bigint_to_word64_signed_trap (type 27) (param i32) (result i64)
    (local i32 i64)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      local.tee 1
      call $mp_count_bits
      i32.const 65
      i32.ge_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 1
      i32.add
      i32.load offset=12
      local.set 0
      local.get 1
      call $mp_get_mag_u64
      local.set 2
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        i64.const 0
        i64.le_s
        br_if 1 (;@1;)
        i64.const 0
        local.get 2
        i64.sub
        return
      end
      local.get 2
      i64.const -1
      i64.le_s
      br_if 0 (;@1;)
      local.get 2
      return
    end
    call $bigint_trap
    unreachable)
  (func $bigint_of_word64 (type 28) (param i64) (result i32)
    (local i32)
    call $bigint_alloc
    local.tee 1
    i32.const 5
    i32.add
    local.get 0
    call $mp_set_u64
    local.get 1)
  (func $bigint_of_word64_signed (type 28) (param i64) (result i32)
    (local i32)
    call $bigint_alloc
    local.tee 1
    i32.const 5
    i32.add
    local.get 0
    call $mp_set_i64
    local.get 1)
  (func $bigint_eq (type 26) (param i32 i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    local.get 1
    i32.const 5
    i32.add
    call $mp_cmp
    i32.eqz)
  (func $bigint_ne (type 26) (param i32 i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    local.get 1
    i32.const 5
    i32.add
    call $mp_cmp
    i32.const 0
    i32.ne)
  (func $bigint_lt (type 26) (param i32 i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    local.get 1
    i32.const 5
    i32.add
    call $mp_cmp
    i32.const 31
    i32.shr_u)
  (func $bigint_gt (type 26) (param i32 i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    local.get 1
    i32.const 5
    i32.add
    call $mp_cmp
    i32.const 0
    i32.gt_s)
  (func $bigint_le (type 26) (param i32 i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    local.get 1
    i32.const 5
    i32.add
    call $mp_cmp
    i32.const 1
    i32.lt_s)
  (func $bigint_ge (type 26) (param i32 i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    local.get 1
    i32.const 5
    i32.add
    call $mp_cmp
    i32.const -1
    i32.xor
    i32.const 31
    i32.shr_u)
  (func $bigint_add (type 26) (param i32 i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      local.get 1
      i32.const 5
      i32.add
      call $bigint_alloc
      local.tee 0
      i32.const 5
      i32.add
      call $mp_add
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 0)
  (func $bigint_sub (type 26) (param i32 i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      local.get 1
      i32.const 5
      i32.add
      call $bigint_alloc
      local.tee 0
      i32.const 5
      i32.add
      call $mp_sub
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 0)
  (func $bigint_mul (type 26) (param i32 i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      local.get 1
      i32.const 5
      i32.add
      call $bigint_alloc
      local.tee 0
      i32.const 5
      i32.add
      call $mp_mul
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 0)
  (func $bigint_pow (type 26) (param i32 i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      local.get 1
      call $bigint_to_word32_trap
      call $bigint_alloc
      local.tee 1
      i32.const 5
      i32.add
      call $mp_expt_u32
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 1)
  (func $bigint_div (type 26) (param i32 i32) (result i32)
    (local i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 2
    global.set 4
    call $bigint_alloc
    local.set 3
    block  ;; label = @1
      local.get 2
      call $mp_init
      br_if 0 (;@1;)
      local.get 0
      i32.const 5
      i32.add
      local.get 1
      i32.const 5
      i32.add
      local.get 3
      i32.const 5
      i32.add
      local.get 2
      call $mp_div
      br_if 0 (;@1;)
      local.get 2
      i32.const 16
      i32.add
      global.set 4
      local.get 3
      return
    end
    call $bigint_trap
    unreachable)
  (func $bigint_rem (type 26) (param i32 i32) (result i32)
    (local i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 2
    global.set 4
    call $bigint_alloc
    local.set 3
    block  ;; label = @1
      local.get 2
      call $mp_init
      br_if 0 (;@1;)
      local.get 0
      i32.const 5
      i32.add
      local.get 1
      i32.const 5
      i32.add
      local.get 2
      local.get 3
      i32.const 5
      i32.add
      call $mp_div
      br_if 0 (;@1;)
      local.get 2
      i32.const 16
      i32.add
      global.set 4
      local.get 3
      return
    end
    call $bigint_trap
    unreachable)
  (func $bigint_neg (type 19) (param i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      call $bigint_alloc
      local.tee 0
      i32.const 5
      i32.add
      call $mp_neg
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 0)
  (func $bigint_abs (type 19) (param i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      call $bigint_alloc
      local.tee 0
      i32.const 5
      i32.add
      call $mp_abs
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 0)
  (func $bigint_isneg (type 19) (param i32) (result i32)
    local.get 0
    i32.const 13
    i32.add
    i32.load
    i32.const 0
    i32.ne)
  (func $bigint_lsh (type 26) (param i32 i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      local.get 1
      call $bigint_alloc
      local.tee 0
      i32.const 5
      i32.add
      call $mp_mul_2d
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 0)
  (func $bigint_count_bits (type 19) (param i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    call $mp_count_bits)
  (func $bigint_leb128_size (type 19) (param i32) (result i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      local.tee 0
      i32.load
      br_if 0 (;@1;)
      i32.const 1
      return
    end
    local.get 0
    call $mp_count_bits
    i32.const 6
    i32.add
    i32.const 7
    i32.div_s)
  (func $bigint_leb128_encode_go (type 22) (param i32 i32 i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=8
        br_if 0 (;@2;)
        local.get 1
        local.get 0
        call $mp_get_i32
        i32.store8
        local.get 0
        i32.const 7
        local.get 0
        i32.const 0
        call $mp_div_2d
        br_if 0 (;@2;)
        loop  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.load
              i32.eqz
              br_if 0 (;@5;)
              local.get 1
              i32.load8_u
              local.set 3
              br 1 (;@4;)
            end
            local.get 2
            i32.eqz
            br_if 3 (;@1;)
            local.get 1
            i32.load8_u
            local.tee 3
            i32.const 64
            i32.and
            i32.eqz
            br_if 3 (;@1;)
          end
          local.get 1
          local.get 3
          i32.const 128
          i32.or
          i32.store8
          local.get 1
          local.get 0
          call $mp_get_i32
          i32.store8 offset=1
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 0
          i32.const 7
          local.get 0
          i32.const 0
          call $mp_div_2d
          i32.eqz
          br_if 0 (;@3;)
        end
      end
      call $bigint_trap
      unreachable
    end)
  (func $bigint_leb128_encode (type 20) (param i32 i32)
    (local i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 2
    global.set 4
    block  ;; label = @1
      local.get 2
      local.get 0
      i32.const 5
      i32.add
      call $mp_init_copy
      i32.eqz
      br_if 0 (;@1;)
      call $bigint_trap
      unreachable
    end
    local.get 2
    local.get 1
    i32.const 0
    call $bigint_leb128_encode_go
    local.get 2
    i32.const 16
    i32.add
    global.set 4)
  (func $bigint_2complement_bits (type 19) (param i32) (result i32)
    (local i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 1
    global.set 4
    local.get 0
    i32.const 5
    i32.add
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 13
          i32.add
          i32.load
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          local.get 2
          call $mp_init_copy
          br_if 2 (;@1;)
          local.get 1
          call $mp_incr
          br_if 2 (;@1;)
          local.get 1
          call $mp_count_bits
          local.set 0
          br 1 (;@2;)
        end
        local.get 2
        call $mp_count_bits
        local.set 0
      end
      local.get 1
      i32.const 16
      i32.add
      global.set 4
      local.get 0
      i32.const 1
      i32.add
      return
    end
    call $bigint_trap
    unreachable)
  (func $bigint_sleb128_size (type 19) (param i32) (result i32)
    local.get 0
    call $bigint_2complement_bits
    i32.const 6
    i32.add
    i32.const 7
    i32.div_s)
  (func $bigint_sleb128_encode (type 20) (param i32 i32)
    (local i32)
    global.get 4
    i32.const 32
    i32.sub
    local.tee 2
    global.set 4
    block  ;; label = @1
      local.get 2
      i32.const 16
      i32.add
      local.get 0
      i32.const 5
      i32.add
      call $mp_init_copy
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.load offset=24
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          call $bigint_2complement_bits
          local.set 0
          local.get 2
          call $mp_init
          br_if 2 (;@1;)
          local.get 2
          local.get 0
          i32.const 6
          i32.add
          local.tee 0
          local.get 0
          i32.const 7
          i32.rem_s
          i32.sub
          call $mp_2expt
          br_if 2 (;@1;)
          local.get 2
          i32.const 16
          i32.add
          local.get 2
          local.get 2
          i32.const 16
          i32.add
          call $mp_add
          br_if 2 (;@1;)
          local.get 2
          i32.const 16
          i32.add
          local.get 1
          i32.const 0
          call $bigint_leb128_encode_go
          br 1 (;@2;)
        end
        local.get 2
        i32.const 16
        i32.add
        local.get 1
        i32.const 1
        call $bigint_leb128_encode_go
      end
      local.get 2
      i32.const 32
      i32.add
      global.set 4
      return
    end
    call $bigint_trap
    unreachable)
  (func $bigint_leb128_decode (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 1
    global.set 4
    call $bigint_alloc
    local.tee 2
    i32.const 5
    i32.add
    local.tee 3
    call $mp_zero
    block  ;; label = @1
      local.get 1
      call $mp_init
      br_if 0 (;@1;)
      i32.const 0
      local.set 4
      block  ;; label = @2
        block  ;; label = @3
          loop  ;; label = @4
            local.get 0
            call $read_byte
            local.set 5
            block  ;; label = @5
              local.get 4
              i32.eqz
              br_if 0 (;@5;)
              local.get 5
              i32.eqz
              br_if 2 (;@3;)
            end
            local.get 4
            i32.const -7
            i32.ge_u
            br_if 2 (;@2;)
            local.get 1
            local.get 5
            i32.const 127
            i32.and
            call $mp_set_u32
            local.get 1
            local.get 4
            local.get 1
            call $mp_mul_2d
            br_if 3 (;@1;)
            local.get 3
            local.get 1
            local.get 3
            call $mp_add
            br_if 3 (;@1;)
            local.get 4
            i32.const 7
            i32.add
            local.set 4
            local.get 5
            i32.const 128
            i32.and
            br_if 0 (;@4;)
          end
          local.get 1
          i32.const 16
          i32.add
          global.set 4
          local.get 2
          return
        end
        i32.const 66384
        i32.const 424
        i32.add
        call $idl_trap_with
        unreachable
      end
      i32.const 66384
      i32.const 446
      i32.add
      call $idl_trap_with
      unreachable
    end
    call $bigint_trap
    unreachable)
  (func $bigint_sleb128_decode (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 32
    i32.sub
    local.tee 1
    global.set 4
    call $bigint_alloc
    local.tee 2
    i32.const 5
    i32.add
    local.tee 3
    call $mp_zero
    block  ;; label = @1
      local.get 1
      i32.const 16
      i32.add
      call $mp_init
      br_if 0 (;@1;)
      i32.const 0
      local.set 4
      i32.const 0
      local.set 5
      block  ;; label = @2
        block  ;; label = @3
          loop  ;; label = @4
            local.get 0
            call $read_byte
            local.set 6
            i32.const 7
            local.set 7
            block  ;; label = @5
              local.get 4
              i32.eqz
              br_if 0 (;@5;)
              local.get 6
              i32.const 127
              i32.eq
              local.get 6
              i32.eqz
              local.get 5
              i32.const 1
              i32.and
              select
              i32.const 1
              i32.eq
              br_if 2 (;@3;)
              local.get 4
              i32.const -7
              i32.ge_u
              br_if 3 (;@2;)
              local.get 4
              i32.const 7
              i32.add
              local.set 7
            end
            local.get 1
            i32.const 16
            i32.add
            local.get 6
            i32.const 127
            i32.and
            call $mp_set_u32
            local.get 1
            i32.const 16
            i32.add
            local.get 4
            local.get 1
            i32.const 16
            i32.add
            call $mp_mul_2d
            br_if 3 (;@1;)
            local.get 3
            local.get 1
            i32.const 16
            i32.add
            local.get 3
            call $mp_add
            br_if 3 (;@1;)
            local.get 6
            i32.const 64
            i32.and
            local.tee 8
            i32.const 6
            i32.shr_u
            local.set 5
            local.get 7
            local.set 4
            local.get 6
            i32.const 128
            i32.and
            br_if 0 (;@4;)
          end
          block  ;; label = @4
            local.get 8
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            call $mp_init
            br_if 3 (;@1;)
            local.get 1
            local.get 7
            call $mp_2expt
            br_if 3 (;@1;)
            local.get 3
            local.get 1
            local.get 3
            call $mp_sub
            br_if 3 (;@1;)
          end
          local.get 1
          i32.const 32
          i32.add
          global.set 4
          local.get 2
          return
        end
        i32.const 66384
        i32.const 424
        i32.add
        call $idl_trap_with
        unreachable
      end
      i32.const 66384
      i32.const 446
      i32.add
      call $idl_trap_with
      unreachable
    end
    call $bigint_trap
    unreachable)
  (func $float_fmt (type 29) (param f64) (result i32)
    (local i32 i32)
    global.get 4
    i32.const 80
    i32.sub
    local.tee 1
    global.set 4
    local.get 1
    local.get 0
    f64.store
    local.get 1
    i32.const 16
    i32.add
    local.get 1
    i32.const 16
    i32.add
    i32.const 50
    i32.const 66384
    i32.const 468
    i32.add
    local.get 1
    call $snprintf
    call $text_of_ptr_size
    local.set 2
    local.get 1
    i32.const 80
    i32.add
    global.set 4
    local.get 2)
  (func $float_pow (type 30) (param f64 f64) (result f64)
    local.get 0
    local.get 1
    call $pow)
  (func $float_sin (type 31) (param f64) (result f64)
    local.get 0
    call $sin)
  (func $float_cos (type 31) (param f64) (result f64)
    local.get 0
    call $cos)
  (func $float_tan (type 31) (param f64) (result f64)
    local.get 0
    call $tan)
  (func $float_arcsin (type 31) (param f64) (result f64)
    local.get 0
    call $asin)
  (func $float_arccos (type 31) (param f64) (result f64)
    local.get 0
    call $acos)
  (func $float_arctan (type 31) (param f64) (result f64)
    local.get 0
    call $atan)
  (func $float_arctan2 (type 30) (param f64 f64) (result f64)
    local.get 0
    local.get 1
    call $atan2)
  (func $float_exp (type 31) (param f64) (result f64)
    local.get 0
    call $exp)
  (func $float_log (type 31) (param f64) (result f64)
    local.get 0
    call $log)
  (func $read_byte (type 19) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 1
      local.get 0
      i32.load offset=4
      i32.lt_u
      br_if 0 (;@1;)
      i32.const 66384
      i32.const 471
      i32.add
      call $idl_trap_with
      unreachable
    end
    local.get 0
    local.get 1
    i32.const 1
    i32.add
    i32.store
    local.get 1
    i32.load8_u)
  (func $read_word (type 19) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 1
      i32.const 4
      i32.add
      local.tee 2
      local.get 0
      i32.load offset=4
      i32.le_u
      br_if 0 (;@1;)
      i32.const 66384
      i32.const 495
      i32.add
      call $idl_trap_with
      unreachable
    end
    local.get 0
    local.get 2
    i32.store
    local.get 1
    i32.load)
  (func $advance (type 20) (param i32 i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.get 0
      i32.load
      local.tee 2
      i32.sub
      local.get 1
      i32.ge_u
      br_if 0 (;@1;)
      i32.const 66384
      i32.const 519
      i32.add
      call $idl_trap_with
      unreachable
    end
    local.get 0
    local.get 2
    local.get 1
    i32.add
    i32.store)
  (func $utf8_check (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 3
    global.set 4
    local.get 0
    local.get 1
    i32.add
    local.tee 4
    i32.const -3
    i32.add
    local.set 5
    local.get 0
    local.set 1
    loop (result i32)  ;; label = @1
      local.get 1
      local.set 6
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            local.get 5
            i32.lt_u
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 1
              local.get 4
              i32.ne
              br_if 0 (;@5;)
              local.get 4
              local.set 1
              br 2 (;@3;)
            end
            local.get 3
            i32.const 0
            i32.store offset=12 align=1
            local.get 3
            i32.const 12
            i32.add
            local.get 1
            local.get 4
            local.get 1
            i32.sub
            call $as_memcpy
            local.get 3
            i32.const 12
            i32.add
            local.set 6
          end
          i32.const 1
          local.set 7
          local.get 6
          i32.load8_u
          local.tee 8
          i32.const 128
          i32.and
          i32.eqz
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 8
            i32.const 8
            i32.shl
            local.get 6
            i32.load8_u offset=1
            i32.or
            local.tee 7
            i32.const 57536
            i32.and
            i32.const 49280
            i32.ne
            br_if 0 (;@4;)
            i32.const 2
            local.set 7
            local.get 8
            i32.const 30
            i32.and
            br_if 2 (;@2;)
            br 1 (;@3;)
          end
          block  ;; label = @4
            local.get 7
            i32.const 8
            i32.shl
            local.tee 7
            local.get 6
            i32.load8_u offset=2
            i32.or
            local.tee 8
            i32.const 15777984
            i32.and
            i32.const 14712960
            i32.ne
            br_if 0 (;@4;)
            local.get 7
            i32.const 991232
            i32.and
            local.tee 6
            i32.eqz
            br_if 1 (;@3;)
            i32.const 3
            local.set 7
            local.get 6
            i32.const 860160
            i32.ne
            br_if 2 (;@2;)
            br 1 (;@3;)
          end
          local.get 8
          i32.const 8
          i32.shl
          local.tee 8
          local.get 6
          i32.load8_u offset=3
          i32.or
          i32.const -121585472
          i32.and
          i32.const -260013952
          i32.ne
          br_if 0 (;@3;)
          i32.const 4
          local.set 7
          local.get 8
          i32.const 120586240
          i32.and
          i32.const -1
          i32.add
          i32.const 67108864
          i32.lt_u
          br_if 1 (;@2;)
        end
        block  ;; label = @3
          local.get 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          local.get 1
          local.get 0
          i32.sub
          i32.store
        end
        local.get 3
        i32.const 16
        i32.add
        global.set 4
        local.get 1
        local.get 4
        i32.eq
        return
      end
      local.get 1
      local.get 7
      i32.add
      local.set 1
      br 0 (;@1;)
    end)
  (func $utf8_validate (type 20) (param i32 i32)
    block  ;; label = @1
      local.get 0
      local.get 1
      i32.const 0
      call $utf8_check
      i32.eqz
      br_if 0 (;@1;)
      return
    end
    i32.const 66384
    i32.const 541
    i32.add
    call $idl_trap_with
    unreachable)
  (func $remember_closure (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 66384
        i32.const 568
        i32.add
        i32.load
        local.tee 1
        br_if 0 (;@2;)
        i32.const 66384
        local.tee 2
        i32.const 568
        i32.add
        i32.const 258
        call $alloc_words
        local.tee 3
        i32.store
        local.get 2
        i32.const 572
        i32.add
        i32.const 0
        i32.store
        local.get 3
        i32.const 1
        i32.add
        i64.const 1099511627779
        i64.store align=4
        i32.const 8
        local.set 2
        loop  ;; label = @3
          local.get 3
          local.get 2
          i32.add
          i32.const 1
          i32.add
          local.get 2
          i32.const -4
          i32.add
          i32.store
          i32.const 66384
          i32.const 568
          i32.add
          i32.load
          local.set 3
          local.get 2
          i32.const 4
          i32.add
          local.tee 2
          i32.const 1028
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 3
        i32.const 1029
        i32.add
        i32.const -4
        i32.store
        i32.const 0
        local.set 2
        br 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 66384
        i32.const 572
        i32.add
        i32.load
        local.tee 2
        i32.const -4
        i32.eq
        br_if 0 (;@2;)
        local.get 1
        local.set 3
        br 1 (;@1;)
      end
      local.get 1
      i32.const 5
      i32.add
      i32.load
      local.tee 4
      i32.const 1
      i32.shl
      local.tee 5
      i32.const 2
      i32.add
      call $alloc_words
      local.tee 3
      i32.const 5
      i32.add
      local.get 5
      i32.store
      local.get 3
      i32.const 1
      i32.add
      local.tee 6
      i32.const 3
      i32.store
      block  ;; label = @2
        local.get 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        i32.const 1
        i32.add
        i32.const 8
        i32.add
        local.set 2
        local.get 6
        i32.const 8
        i32.add
        local.set 1
        local.get 4
        local.set 7
        loop  ;; label = @3
          local.get 1
          local.get 2
          i32.load
          i32.store
          local.get 2
          i32.const 4
          i32.add
          local.set 2
          local.get 1
          i32.const 4
          i32.add
          local.set 1
          local.get 7
          i32.const -1
          i32.add
          local.tee 7
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 4
        i32.const 1
        i32.add
        local.get 5
        i32.ge_u
        br_if 0 (;@2;)
        local.get 4
        i32.const -1
        i32.add
        local.set 1
        local.get 4
        i32.const 2
        i32.shl
        i32.const 4
        i32.add
        local.set 2
        loop  ;; label = @3
          local.get 6
          local.get 2
          i32.add
          i32.const 4
          i32.add
          local.get 2
          i32.store
          local.get 2
          i32.const 4
          i32.add
          local.set 2
          local.get 1
          i32.const -1
          i32.add
          local.tee 1
          br_if 0 (;@3;)
        end
      end
      local.get 6
      local.get 5
      i32.const 2
      i32.shl
      i32.const 4
      i32.or
      i32.add
      i32.const 66384
      local.tee 1
      i32.const 572
      i32.add
      local.tee 7
      i32.load
      i32.store
      local.get 7
      local.get 4
      i32.const 2
      i32.shl
      local.tee 2
      i32.store
      local.get 1
      i32.const 568
      i32.add
      local.get 3
      i32.store
    end
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.and
      br_if 0 (;@1;)
      i32.const 66384
      i32.const 576
      i32.add
      call $rts_trap_with
      unreachable
    end
    i32.const 66384
    local.tee 1
    i32.const 632
    i32.add
    local.tee 7
    local.get 7
    i32.load
    i32.const 1
    i32.add
    i32.store
    local.get 1
    i32.const 572
    i32.add
    local.get 2
    i32.const 2
    i32.shr_u
    local.tee 2
    i32.const 2
    i32.shl
    local.get 3
    i32.add
    i32.const 9
    i32.add
    local.tee 3
    i32.load
    i32.store
    local.get 3
    local.get 0
    i32.store
    local.get 2)
  (func $recall_closure (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 66384
          i32.const 568
          i32.add
          i32.load
          local.tee 1
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          i32.const 5
          i32.add
          i32.load
          local.get 0
          i32.le_u
          br_if 1 (;@2;)
          i32.const 66384
          local.tee 2
          i32.const 572
          i32.add
          local.tee 3
          i32.load
          local.set 4
          local.get 3
          local.get 0
          i32.const 2
          i32.shl
          local.tee 0
          i32.store
          local.get 2
          i32.const 632
          i32.add
          local.tee 2
          local.get 2
          i32.load
          i32.const -1
          i32.add
          i32.store
          local.get 0
          local.get 1
          i32.const 1
          i32.add
          i32.add
          i32.const 8
          i32.add
          local.tee 1
          i32.load
          local.set 0
          local.get 1
          local.get 4
          i32.store
          local.get 0
          i32.const 2
          i32.and
          i32.eqz
          br_if 2 (;@1;)
          local.get 0
          return
        end
        i32.const 66384
        i32.const 636
        i32.add
        call $rts_trap_with
        unreachable
      end
      i32.const 66384
      i32.const 679
      i32.add
      call $rts_trap_with
      unreachable
    end
    i32.const 66384
    i32.const 722
    i32.add
    call $rts_trap_with
    unreachable)
  (func $closure_count (type 17) (result i32)
    i32.const 66384
    i32.const 632
    i32.add
    i32.load)
  (func $closure_table_loc (type 17) (result i32)
    i32.const 66384
    i32.const 568
    i32.add
    i32.const -1
    i32.add)
  (func $closure_table_size (type 17) (result i32)
    (local i32)
    block  ;; label = @1
      i32.const 66384
      i32.const 568
      i32.add
      i32.load
      local.tee 0
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 0
    i32.const 5
    i32.add
    i32.load)
  (func $text_of_ptr_size (type 26) (param i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 1
      i32.const 1073741824
      i32.lt_u
      br_if 0 (;@1;)
      i32.const 66384
      i32.const 827
      i32.add
      call $rts_trap_with
      unreachable
    end
    local.get 1
    call $alloc_blob
    local.tee 2
    i32.const 9
    i32.add
    local.get 0
    local.get 1
    call $as_memcpy
    local.get 2)
  (func $text_of_cstr (type 19) (param i32) (result i32)
    local.get 0
    local.get 0
    call $as_strlen
    call $text_of_ptr_size)
  (func $text_concat (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      i32.load
      local.tee 2
      br_if 0 (;@1;)
      local.get 1
      return
    end
    block  ;; label = @1
      local.get 1
      i32.const 5
      i32.add
      i32.load
      local.tee 3
      br_if 0 (;@1;)
      local.get 0
      return
    end
    block  ;; label = @1
      local.get 3
      local.get 2
      i32.add
      local.tee 4
      i32.const 8
      i32.gt_u
      br_if 0 (;@1;)
      local.get 4
      call $alloc_blob
      local.tee 4
      i32.const 9
      i32.add
      local.tee 5
      local.get 0
      i32.const 1
      i32.add
      i32.const 8
      i32.add
      local.get 2
      call $as_memcpy
      local.get 5
      local.get 2
      i32.add
      local.get 1
      i32.const 1
      i32.add
      i32.const 8
      i32.add
      local.get 3
      call $as_memcpy
      local.get 4
      return
    end
    block  ;; label = @1
      local.get 4
      i32.const 1073741824
      i32.ge_u
      br_if 0 (;@1;)
      i32.const 4
      call $alloc_words
      local.tee 2
      i32.const 13
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const 9
      i32.add
      local.get 0
      i32.store
      local.get 2
      i32.const 5
      i32.add
      local.get 4
      i32.store
      local.get 2
      i32.const 1
      i32.add
      i32.const 14
      i32.store
      local.get 2
      return
    end
    i32.const 66384
    i32.const 765
    i32.add
    call $rts_trap_with
    unreachable)
  (func $text_to_buf (type 20) (param i32 i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 2
    block  ;; label = @1
      loop  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 1
          i32.add
          local.tee 3
          i32.load
          i32.const 10
          i32.ne
          br_if 0 (;@3;)
          local.get 1
          local.get 0
          i32.const 9
          i32.add
          local.get 3
          i32.load offset=4
          call $as_memcpy
          local.get 2
          i32.eqz
          br_if 2 (;@1;)
          local.get 2
          i32.load
          local.set 0
          local.get 2
          local.set 1
          local.get 2
          i32.load offset=4
          local.set 2
          br 1 (;@2;)
        end
        local.get 1
        local.get 3
        i32.load offset=8
        local.tee 0
        i32.const 5
        i32.add
        i32.load
        i32.add
        local.set 4
        block  ;; label = @3
          local.get 3
          i32.load offset=12
          local.tee 3
          i32.const 5
          i32.add
          i32.load
          i32.const 7
          i32.gt_u
          br_if 0 (;@3;)
          local.get 3
          local.get 4
          call $text_to_buf
          br 1 (;@2;)
        end
        local.get 4
        local.get 2
        i32.store offset=4
        local.get 4
        local.get 3
        i32.store
        local.get 4
        local.set 2
        br 0 (;@2;)
      end
    end)
  (func $blob_of_text (type 19) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i32.const 1
      i32.add
      i32.load
      i32.const 10
      i32.ne
      br_if 0 (;@1;)
      local.get 0
      return
    end
    block  ;; label = @1
      local.get 0
      i32.const 5
      i32.add
      i32.load
      local.tee 1
      i32.const 1073741824
      i32.ge_u
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      call $alloc_blob
      local.tee 1
      i32.const 9
      i32.add
      call $text_to_buf
      local.get 1
      return
    end
    i32.const 66384
    i32.const 827
    i32.add
    call $rts_trap_with
    unreachable)
  (func $text_size (type 19) (param i32) (result i32)
    local.get 0
    i32.const 5
    i32.add
    i32.load)
  (func $blob_compare (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i32.const 9
    i32.add
    local.get 1
    i32.const 9
    i32.add
    local.get 0
    i32.const 5
    i32.add
    i32.load
    local.tee 0
    local.get 1
    i32.const 5
    i32.add
    i32.load
    local.tee 1
    local.get 0
    local.get 1
    i32.lt_u
    local.tee 2
    select
    call $as_memcmp
    local.tee 3
    i32.const -1
    local.get 3
    select
    local.tee 4
    local.get 4
    local.get 0
    local.get 1
    i32.gt_u
    local.get 3
    select
    local.get 2
    select)
  (func $text_compare (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 0
      local.get 1
      i32.const 0
      local.get 0
      i32.const 5
      i32.add
      i32.load
      local.tee 2
      local.get 1
      i32.const 5
      i32.add
      i32.load
      local.tee 3
      local.get 2
      local.get 3
      i32.lt_u
      local.tee 4
      select
      call $text_compare_range
      local.tee 0
      br_if 0 (;@1;)
      i32.const 1
      i32.const -1
      i32.const 0
      local.get 4
      select
      local.get 2
      local.get 3
      i32.gt_u
      select
      return
    end
    local.get 0)
  (func $text_compare_range (type 25) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      loop  ;; label = @2
        local.get 0
        i32.const 9
        i32.add
        local.set 5
        local.get 0
        i32.const 1
        i32.add
        local.set 6
        loop  ;; label = @3
          local.get 4
          local.get 1
          i32.add
          local.set 7
          local.get 6
          i32.load
          local.set 8
          block  ;; label = @4
            loop  ;; label = @5
              local.get 4
              local.get 3
              i32.add
              local.set 9
              loop  ;; label = @6
                local.get 2
                local.set 10
                block  ;; label = @7
                  local.get 8
                  i32.const 14
                  i32.ne
                  local.tee 11
                  br_if 0 (;@7;)
                  local.get 1
                  local.get 5
                  i32.load
                  i32.const 5
                  i32.add
                  i32.load
                  local.tee 12
                  i32.lt_u
                  br_if 0 (;@7;)
                  local.get 1
                  local.get 12
                  i32.sub
                  local.set 1
                  local.get 6
                  i32.load offset=12
                  local.set 0
                  local.get 10
                  local.set 2
                  br 5 (;@2;)
                end
                block  ;; label = @7
                  local.get 10
                  i32.const 1
                  i32.add
                  local.tee 12
                  i32.load
                  i32.const 14
                  i32.ne
                  local.tee 2
                  br_if 0 (;@7;)
                  local.get 3
                  local.get 12
                  i32.load offset=8
                  i32.const 5
                  i32.add
                  i32.load
                  local.tee 13
                  i32.lt_u
                  br_if 0 (;@7;)
                  local.get 3
                  local.get 13
                  i32.sub
                  local.set 3
                  local.get 12
                  i32.load offset=12
                  local.set 2
                  br 2 (;@5;)
                end
                block  ;; label = @7
                  local.get 11
                  br_if 0 (;@7;)
                  local.get 5
                  i32.load
                  local.tee 13
                  i32.const 5
                  i32.add
                  i32.load
                  local.get 7
                  i32.lt_u
                  br_if 0 (;@7;)
                  local.get 13
                  local.set 0
                  local.get 10
                  local.set 2
                  br 5 (;@2;)
                end
                block  ;; label = @7
                  local.get 2
                  i32.eqz
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 2
                  br 3 (;@4;)
                end
                local.get 12
                i32.load offset=8
                local.tee 2
                i32.const 5
                i32.add
                i32.load
                local.get 9
                i32.ge_u
                br_if 0 (;@6;)
              end
            end
            i32.const 1
            local.set 2
          end
          block  ;; label = @4
            local.get 11
            br_if 0 (;@4;)
            local.get 5
            i32.load
            local.tee 12
            local.get 1
            local.get 10
            local.get 3
            local.get 12
            i32.const 5
            i32.add
            i32.load
            local.get 1
            i32.sub
            local.tee 12
            call $text_compare_range
            local.tee 11
            br_if 3 (;@1;)
            local.get 4
            local.get 12
            i32.sub
            local.set 4
            local.get 12
            local.get 3
            i32.add
            local.set 3
            local.get 6
            i32.load offset=12
            local.set 0
            i32.const 0
            local.set 1
            local.get 10
            local.set 2
            br 2 (;@2;)
          end
          block  ;; label = @4
            local.get 2
            i32.eqz
            br_if 0 (;@4;)
            local.get 0
            local.get 1
            local.get 12
            i32.load offset=8
            local.tee 2
            local.get 3
            local.get 2
            i32.const 5
            i32.add
            i32.load
            local.get 3
            i32.sub
            local.tee 2
            call $text_compare_range
            local.tee 11
            br_if 3 (;@1;)
            local.get 4
            local.get 2
            i32.sub
            local.set 4
            local.get 2
            local.get 1
            i32.add
            local.set 1
            local.get 12
            i32.load offset=12
            local.set 2
            i32.const 0
            local.set 3
            br 1 (;@3;)
          end
        end
      end
      local.get 5
      local.get 1
      i32.add
      local.get 12
      local.get 3
      i32.add
      i32.const 8
      i32.add
      local.get 4
      call $as_memcmp
      local.set 11
    end
    local.get 11)
  (func $text_len (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 1
      i32.add
      local.tee 1
      i32.load
      i32.const 10
      i32.ne
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 1
        i32.load offset=4
        local.tee 2
        br_if 0 (;@2;)
        i32.const 0
        return
      end
      local.get 0
      i32.const 9
      i32.add
      local.set 3
      i32.const 0
      local.set 0
      i32.const 0
      local.set 1
      loop  ;; label = @2
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 3
        local.get 1
        i32.add
        i32.load8_u
        local.tee 4
        i32.const 24
        i32.shl
        i32.const -1
        i32.xor
        i32.clz
        i32.const 0
        local.get 4
        select
        local.tee 4
        i32.const 1
        local.get 4
        select
        local.get 1
        i32.add
        local.tee 1
        local.get 2
        i32.lt_u
        br_if 0 (;@2;)
      end
      local.get 0
      return
    end
    local.get 1
    i32.load offset=8
    call $text_len
    local.get 1
    i32.load offset=12
    call $text_len
    i32.add)
  (func $text_singleton (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 1
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.const 128
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 0
        local.set 2
        i32.const 127
        local.set 3
        br 1 (;@1;)
      end
      i32.const 127
      local.set 3
      i32.const 0
      local.set 2
      loop  ;; label = @2
        local.get 1
        i32.const 12
        i32.add
        local.get 2
        i32.add
        local.get 0
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8
        i32.const 1
        i32.const 2
        local.get 2
        select
        local.set 4
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        local.get 0
        i32.const 6
        i32.shr_u
        local.tee 0
        local.get 3
        local.get 4
        i32.shr_s
        local.tee 3
        i32.gt_u
        br_if 0 (;@2;)
      end
    end
    local.get 1
    i32.const 12
    i32.add
    local.get 2
    i32.add
    local.get 0
    local.get 3
    i32.and
    local.get 3
    i32.const 1
    i32.shl
    i32.const 254
    i32.xor
    i32.or
    local.tee 0
    i32.store8
    block  ;; label = @1
      local.get 2
      i32.const 1073741823
      i32.ge_u
      br_if 0 (;@1;)
      local.get 2
      i32.const 1
      i32.add
      call $alloc_blob
      local.tee 4
      i32.const 9
      i32.add
      local.get 0
      i32.store8
      block  ;; label = @2
        local.get 2
        i32.eqz
        br_if 0 (;@2;)
        local.get 4
        i32.const 1
        i32.add
        i32.const 9
        i32.add
        local.set 0
        local.get 1
        i32.const 12
        i32.add
        i32.const -1
        i32.add
        local.set 3
        loop  ;; label = @3
          local.get 0
          local.get 3
          local.get 2
          i32.add
          i32.load8_u
          i32.store8
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 2
          i32.const -1
          i32.add
          local.tee 2
          br_if 0 (;@3;)
        end
      end
      local.get 1
      i32.const 16
      i32.add
      global.set 4
      local.get 4
      return
    end
    i32.const 66384
    i32.const 827
    i32.add
    call $rts_trap_with
    unreachable)
  (func $text_iter (type 19) (param i32) (result i32)
    (local i32)
    i32.const 5
    call $alloc_words
    local.tee 1
    i32.const 13
    i32.add
    i64.const 0
    i64.store align=4
    local.get 1
    i32.const 1
    i32.add
    i32.const 3
    i32.store
    local.get 1
    i32.const 9
    i32.add
    local.get 0
    local.get 1
    i32.const 17
    i32.add
    call $find_leaf
    i32.store
    local.get 1)
  (func $find_leaf (type 26) (param i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i32.const 1
      i32.add
      local.tee 2
      i32.load
      i32.const 14
      i32.ne
      br_if 0 (;@1;)
      loop  ;; label = @2
        i32.const 4
        call $alloc_words
        local.tee 0
        i32.const 1
        i32.add
        i32.const 3
        i32.store
        local.get 0
        i32.const 9
        i32.add
        local.get 2
        i32.load offset=12
        i32.store
        local.get 0
        i32.const 13
        i32.add
        local.get 1
        i32.load
        i32.store
        local.get 1
        local.get 0
        i32.store
        local.get 2
        i32.load offset=8
        local.tee 0
        i32.const 1
        i32.add
        local.tee 2
        i32.load
        i32.const 14
        i32.eq
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $text_iter_done (type 19) (param i32) (result i32)
    (local i32)
    i32.const 0
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.const 13
      i32.add
      i32.load
      i32.const 2
      i32.shr_u
      local.get 0
      i32.const 9
      i32.add
      i32.load
      i32.const 5
      i32.add
      i32.load
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 17
      i32.add
      i32.load
      i32.eqz
      local.set 1
    end
    local.get 1)
  (func $text_iter_next (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    i32.const 1
    local.set 1
    local.get 0
    i32.const 1
    i32.add
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 13
          i32.add
          i32.load
          i32.const 2
          i32.shr_u
          local.tee 3
          local.get 0
          i32.const 9
          i32.add
          i32.load
          local.tee 0
          i32.const 5
          i32.add
          i32.load
          i32.ge_u
          br_if 0 (;@3;)
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          br 1 (;@2;)
        end
        local.get 2
        i32.const 16
        i32.add
        local.set 4
        loop  ;; label = @3
          local.get 4
          i32.load
          local.tee 5
          i32.eqz
          br_if 2 (;@1;)
          block  ;; label = @4
            block  ;; label = @5
              local.get 5
              i32.const 9
              i32.add
              local.tee 6
              i32.load
              local.tee 3
              i32.const 1
              i32.add
              local.tee 0
              i32.load
              i32.const 14
              i32.ne
              br_if 0 (;@5;)
              local.get 6
              local.get 0
              i32.load offset=12
              i32.store
              local.get 2
              i32.const 0
              i32.store offset=12
              local.get 2
              local.get 0
              i32.load offset=8
              local.get 4
              call $find_leaf
              local.tee 0
              i32.store offset=8
              local.get 0
              i32.const 1
              i32.add
              local.set 0
              local.get 2
              i32.load offset=12
              local.set 6
              br 1 (;@4;)
            end
            local.get 2
            local.get 3
            i32.store offset=8
            i32.const 0
            local.set 6
            local.get 2
            i32.const 0
            i32.store offset=12
            local.get 2
            local.get 5
            i32.const 13
            i32.add
            i32.load
            i32.store offset=16
          end
          local.get 6
          i32.const 2
          i32.shr_u
          local.tee 3
          local.get 0
          i32.load offset=4
          i32.ge_u
          br_if 0 (;@3;)
        end
      end
      i32.const -1
      i32.const 8
      local.get 0
      local.get 3
      i32.add
      local.tee 6
      i32.const 8
      i32.add
      i32.load8_s
      local.tee 0
      i32.const 24
      i32.shl
      i32.const -1
      i32.xor
      i32.clz
      i32.const 0
      local.get 0
      i32.const 255
      i32.and
      select
      local.tee 4
      i32.sub
      i32.shl
      i32.const -1
      i32.xor
      local.get 0
      i32.and
      local.set 5
      block  ;; label = @2
        local.get 4
        i32.const 2
        i32.lt_u
        br_if 0 (;@2;)
        local.get 6
        i32.const 9
        i32.add
        local.set 0
        i32.const -1
        local.set 6
        loop  ;; label = @3
          local.get 5
          i32.const 6
          i32.shl
          local.get 0
          i32.load8_u
          i32.const 63
          i32.and
          i32.or
          local.set 5
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 4
          local.get 6
          i32.const -1
          i32.add
          local.tee 6
          i32.add
          i32.const 2
          i32.add
          i32.const 2
          i32.gt_s
          br_if 0 (;@3;)
        end
        i32.const 0
        local.get 6
        i32.sub
        local.set 1
      end
      local.get 2
      local.get 1
      local.get 3
      i32.add
      i32.const 2
      i32.shl
      i32.store offset=12
      local.get 5
      return
    end
    i32.const 66384
    i32.const 793
    i32.add
    call $rts_trap_with
    unreachable)
  (func $compute_crc32 (type 19) (param i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 1
      i32.add
      local.tee 1
      i32.load
      i32.const 10
      i32.ne
      br_if 0 (;@1;)
      i32.const 0
      local.set 2
      block  ;; label = @2
        local.get 1
        i32.const 8
        i32.add
        local.tee 0
        local.get 1
        i32.load offset=4
        local.tee 3
        i32.add
        local.get 0
        i32.le_u
        br_if 0 (;@2;)
        i32.const -1
        local.set 1
        loop  ;; label = @3
          i32.const 66384
          i32.const 896
          i32.add
          local.get 1
          i32.const 255
          i32.and
          local.get 0
          i32.load8_u
          i32.xor
          i32.const 2
          i32.shl
          i32.add
          i32.load
          local.get 1
          i32.const 8
          i32.shr_u
          i32.xor
          local.set 1
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 3
          i32.const -1
          i32.add
          local.tee 3
          br_if 0 (;@3;)
        end
        local.get 1
        i32.const -1
        i32.xor
        local.set 2
      end
      local.get 2
      return
    end
    i32.const 66384
    i32.const 854
    i32.add
    call $rts_trap_with
    unreachable)
  (func $blob_iter (type 19) (param i32) (result i32)
    (local i32)
    i32.const 4
    call $alloc_words
    local.tee 1
    i32.const 13
    i32.add
    i32.const 0
    i32.store
    local.get 1
    i32.const 9
    i32.add
    local.get 0
    i32.store
    local.get 1
    i32.const 1
    i32.add
    i32.const 3
    i32.store
    local.get 1)
  (func $blob_iter_done (type 19) (param i32) (result i32)
    local.get 0
    i32.const 13
    i32.add
    i32.load
    i32.const 2
    i32.shr_u
    local.get 0
    i32.const 9
    i32.add
    i32.load
    i32.const 5
    i32.add
    i32.load
    i32.ge_u)
  (func $blob_iter_next (type 19) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 13
    i32.add
    local.tee 1
    local.get 1
    i32.load
    local.tee 1
    i32.const 4
    i32.add
    i32.const -4
    i32.and
    i32.store
    local.get 0
    i32.const 9
    i32.add
    i32.load
    local.get 1
    i32.const 2
    i32.shr_u
    i32.add
    i32.const 9
    i32.add
    i32.load8_u)
  (func $blob_of_ic_url (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call $blob_of_text
            local.tee 1
            i32.const 5
            i32.add
            i32.load
            local.tee 0
            i32.const 2
            i32.le_u
            br_if 0 (;@4;)
            local.get 1
            i32.const 1
            i32.add
            local.tee 1
            i32.load8_u offset=8
            i32.const 32
            i32.or
            i32.const 105
            i32.ne
            br_if 1 (;@3;)
            local.get 1
            i32.const 8
            i32.add
            local.tee 2
            i32.load8_u offset=1
            i32.const 32
            i32.or
            i32.const 99
            i32.ne
            br_if 1 (;@3;)
            local.get 1
            i32.const 10
            i32.add
            i32.load8_u
            i32.const 255
            i32.and
            i32.const 58
            i32.ne
            br_if 1 (;@3;)
            local.get 2
            local.get 0
            i32.add
            local.set 3
            local.get 0
            i32.const -3
            i32.add
            local.set 1
            local.get 0
            i32.const -5
            i32.add
            local.set 4
            local.get 2
            i32.const 3
            i32.add
            local.tee 2
            local.set 0
            block  ;; label = @5
              loop  ;; label = @6
                local.get 1
                i32.eqz
                br_if 1 (;@5;)
                local.get 1
                i32.const -1
                i32.add
                local.set 1
                local.get 0
                i32.load8_u
                local.set 5
                local.get 0
                i32.const 1
                i32.add
                local.tee 6
                local.set 0
                local.get 5
                i32.const -48
                i32.add
                i32.const 255
                i32.and
                i32.const 10
                i32.lt_u
                br_if 0 (;@6;)
                local.get 6
                local.set 0
                local.get 5
                i32.const -65
                i32.add
                i32.const 255
                i32.and
                i32.const 6
                i32.lt_u
                br_if 0 (;@6;)
              end
              i32.const 66384
              i32.const 2072
              i32.add
              call $rts_trap_with
              unreachable
            end
            local.get 4
            i32.const 1
            i32.and
            br_if 2 (;@2;)
            local.get 4
            i32.const 1
            i32.shr_u
            local.tee 6
            call $alloc_blob
            local.tee 7
            i32.const 9
            i32.add
            local.set 5
            block  ;; label = @5
              local.get 4
              i32.eqz
              br_if 0 (;@5;)
              local.get 5
              local.set 0
              loop  ;; label = @6
                local.get 0
                i32.const 9
                i32.const 0
                local.get 2
                i32.load8_u
                local.tee 1
                i32.const -48
                i32.add
                i32.const 255
                i32.and
                i32.const 9
                i32.gt_u
                select
                local.get 1
                i32.add
                i32.const 4
                i32.shl
                i32.const -48
                i32.const -55
                local.get 2
                i32.const 1
                i32.add
                i32.load8_u
                local.tee 1
                i32.const -48
                i32.add
                i32.const 255
                i32.and
                i32.const 10
                i32.lt_u
                select
                local.get 1
                i32.add
                i32.or
                i32.store8
                local.get 2
                i32.const 2
                i32.add
                local.set 2
                local.get 0
                i32.const 1
                i32.add
                local.set 0
                local.get 4
                i32.const -2
                i32.add
                local.tee 4
                br_if 0 (;@6;)
              end
            end
            local.get 5
            local.get 6
            call $compute_crc8
            i32.const 9
            i32.const 0
            local.get 3
            i32.const -2
            i32.add
            local.tee 0
            i32.load8_u
            local.tee 1
            i32.const -48
            i32.add
            i32.const 255
            i32.and
            i32.const 9
            i32.gt_u
            select
            local.get 1
            i32.add
            i32.const 4
            i32.shl
            i32.const -48
            i32.const -55
            local.get 0
            i32.load8_u offset=1
            local.tee 0
            i32.const -48
            i32.add
            i32.const 255
            i32.and
            i32.const 10
            i32.lt_u
            select
            local.get 0
            i32.add
            i32.or
            i32.const 255
            i32.and
            i32.ne
            br_if 3 (;@1;)
            local.get 7
            return
          end
          i32.const 66384
          i32.const 1920
          i32.add
          call $rts_trap_with
          unreachable
        end
        i32.const 66384
        i32.const 2028
        i32.add
        call $rts_trap_with
        unreachable
      end
      i32.const 66384
      i32.const 1946
      i32.add
      call $rts_trap_with
      unreachable
    end
    i32.const 66384
    i32.const 1994
    i32.add
    call $rts_trap_with
    unreachable)
  (func $compute_crc8 (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        br_if 0 (;@2;)
        i32.const 0
        local.set 2
        br 1 (;@1;)
      end
      i32.const 0
      local.set 3
      i32.const 0
      local.set 2
      loop  ;; label = @2
        local.get 0
        local.get 3
        i32.add
        i32.load8_u
        local.get 2
        i32.xor
        local.set 2
        i32.const 8
        local.set 4
        loop  ;; label = @3
          local.get 2
          i32.const 1
          i32.shl
          i32.const 510
          i32.and
          local.tee 5
          i32.const 7
          i32.xor
          local.get 5
          local.get 2
          i32.const 128
          i32.and
          select
          local.set 2
          local.get 4
          i32.const -1
          i32.add
          local.tee 4
          br_if 0 (;@3;)
        end
        local.get 3
        i32.const 1
        i32.add
        local.tee 3
        local.get 1
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 2
    i32.const 255
    i32.and)
  (func $ic_url_of_blob (type 19) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    i32.const 66384
    local.set 1
    local.get 0
    i32.const 5
    i32.add
    i32.load
    local.tee 2
    i32.const 1
    i32.shl
    i32.const 5
    i32.add
    call $alloc_blob
    local.tee 3
    i32.const 9
    i32.add
    local.get 1
    i32.const 2024
    i32.add
    i32.const 3
    call $as_memcpy
    local.get 0
    i32.const 9
    i32.add
    local.set 4
    local.get 0
    i32.const 1
    i32.add
    local.set 5
    local.get 3
    i32.const 12
    i32.add
    local.set 0
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      local.set 1
      loop  ;; label = @2
        local.get 0
        local.get 1
        i32.load8_u
        local.tee 6
        i32.const 4
        i32.shr_u
        local.tee 7
        i32.const 48
        i32.or
        local.get 7
        i32.const 55
        i32.add
        local.get 6
        i32.const 160
        i32.lt_u
        select
        i32.store8
        local.get 0
        i32.const 1
        i32.add
        local.get 1
        i32.load8_u
        i32.const 15
        i32.and
        local.tee 6
        i32.const 48
        i32.or
        local.get 6
        i32.const 55
        i32.add
        local.get 6
        i32.const 10
        i32.lt_u
        select
        i32.store8
        local.get 0
        i32.const 2
        i32.add
        local.set 0
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    local.get 0
    local.get 4
    local.get 5
    i32.load offset=4
    call $compute_crc8
    local.tee 1
    i32.const 15
    i32.and
    local.tee 6
    i32.const 48
    i32.or
    local.get 6
    i32.const 55
    i32.add
    local.get 6
    i32.const 10
    i32.lt_u
    select
    i32.store8 offset=1
    local.get 0
    local.get 1
    i32.const 4
    i32.shr_u
    local.tee 6
    i32.const 48
    i32.or
    local.get 6
    i32.const 55
    i32.add
    local.get 1
    i32.const 160
    i32.lt_u
    select
    i32.store8
    local.get 3)
  (func $mp_init (type 19) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 32
    i32.const 4
    call $mp_calloc
    local.tee 1
    i32.store offset=12
    block  ;; label = @1
      local.get 1
      br_if 0 (;@1;)
      i32.const -2
      return
    end
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    i64.const 137438953472
    i64.store align=4
    i32.const 0)
  (func $mp_add (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=8
      local.tee 3
      local.get 1
      i32.load offset=8
      local.tee 4
      i32.ne
      br_if 0 (;@1;)
      local.get 2
      local.get 3
      i32.store offset=8
      local.get 0
      local.get 1
      local.get 2
      call $s_mp_add
      return
    end
    block  ;; label = @1
      local.get 0
      local.get 1
      call $mp_cmp_mag
      i32.const -1
      i32.ne
      br_if 0 (;@1;)
      local.get 2
      local.get 4
      i32.store offset=8
      local.get 1
      local.get 0
      local.get 2
      call $s_mp_sub
      return
    end
    local.get 2
    local.get 3
    i32.store offset=8
    local.get 0
    local.get 1
    local.get 2
    call $s_mp_sub)
  (func $mp_sub (type 18) (param i32 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=8
      local.tee 3
      local.get 1
      i32.load offset=8
      i32.eq
      br_if 0 (;@1;)
      local.get 2
      local.get 3
      i32.store offset=8
      local.get 0
      local.get 1
      local.get 2
      call $s_mp_add
      return
    end
    block  ;; label = @1
      local.get 0
      local.get 1
      call $mp_cmp_mag
      i32.const -1
      i32.eq
      br_if 0 (;@1;)
      local.get 2
      local.get 3
      i32.store offset=8
      local.get 0
      local.get 1
      local.get 2
      call $s_mp_sub
      return
    end
    local.get 2
    local.get 3
    i32.eqz
    i32.store offset=8
    local.get 1
    local.get 0
    local.get 2
    call $s_mp_sub)
  (func $mp_mul (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    local.get 1
    i32.load offset=8
    local.set 3
    local.get 0
    i32.load offset=8
    local.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load
        local.tee 5
        local.get 1
        i32.load
        local.tee 6
        local.get 5
        local.get 6
        i32.gt_s
        select
        local.tee 7
        local.get 5
        local.get 6
        local.get 5
        local.get 6
        i32.lt_s
        select
        local.tee 8
        i32.const 1
        i32.shl
        i32.lt_s
        br_if 0 (;@2;)
        local.get 8
        i32.const 80
        i32.lt_s
        br_if 0 (;@2;)
        local.get 7
        i32.const 160
        i32.lt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        local.get 2
        call $s_mp_balance_mul
        local.set 5
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 8
        i32.const 350
        i32.lt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        local.get 2
        call $s_mp_toom_mul
        local.set 5
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 8
        i32.const 80
        i32.lt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        local.get 2
        call $s_mp_karatsuba_mul
        local.set 5
        br 1 (;@1;)
      end
      local.get 6
      local.get 5
      i32.add
      local.tee 6
      i32.const 1
      i32.add
      local.set 5
      block  ;; label = @2
        local.get 6
        i32.const 510
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        local.get 2
        local.get 5
        call $s_mp_mul_digs_fast
        local.set 5
        br 1 (;@1;)
      end
      local.get 0
      local.get 1
      local.get 2
      local.get 5
      call $s_mp_mul_digs
      local.set 5
    end
    local.get 2
    local.get 4
    local.get 3
    i32.ne
    local.get 2
    i32.load
    i32.const 0
    i32.gt_s
    i32.and
    i32.store offset=8
    local.get 5)
  (func $mp_zero (type 23) (param i32)
    (local i32)
    local.get 0
    i32.const 0
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=8
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.tee 1
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 1
      i32.const 1
      i32.add
      local.set 1
      local.get 0
      i32.load offset=12
      local.set 0
      loop  ;; label = @2
        local.get 0
        i32.const 0
        i32.store
        local.get 0
        i32.const 4
        i32.add
        local.set 0
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        i32.const 1
        i32.gt_s
        br_if 0 (;@2;)
      end
    end)
  (func $mp_cmp (type 26) (param i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=8
      local.tee 2
      local.get 1
      i32.load offset=8
      i32.eq
      br_if 0 (;@1;)
      i32.const -1
      i32.const 1
      local.get 2
      i32.const 1
      i32.eq
      select
      return
    end
    block  ;; label = @1
      local.get 2
      i32.const 1
      i32.ne
      br_if 0 (;@1;)
      local.get 1
      local.get 0
      call $mp_cmp_mag
      return
    end
    local.get 0
    local.get 1
    call $mp_cmp_mag)
  (func $mp_set_u32 (type 20) (param i32 i32)
    (local i32 i32 i32)
    local.get 0
    i32.load offset=12
    local.set 2
    i32.const 0
    local.set 3
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      i32.const 0
      local.set 3
      local.get 2
      local.set 4
      loop  ;; label = @2
        local.get 4
        local.get 1
        i32.const 268435455
        i32.and
        i32.store
        local.get 4
        i32.const 4
        i32.add
        local.set 4
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 1
        i32.const 28
        i32.shr_u
        local.tee 1
        br_if 0 (;@2;)
      end
    end
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    local.get 3
    i32.store
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.get 3
      i32.sub
      local.tee 1
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 1
      i32.const 1
      i32.add
      local.set 4
      local.get 2
      local.get 3
      i32.const 2
      i32.shl
      i32.add
      local.set 1
      loop  ;; label = @2
        local.get 1
        i32.const 0
        i32.store
        local.get 1
        i32.const 4
        i32.add
        local.set 1
        local.get 4
        i32.const -1
        i32.add
        local.tee 4
        i32.const 1
        i32.gt_s
        br_if 0 (;@2;)
      end
    end)
  (func $mp_set_i32 (type 20) (param i32 i32)
    (local i32)
    local.get 0
    local.get 1
    local.get 1
    i32.const 31
    i32.shr_s
    local.tee 2
    i32.add
    local.get 2
    i32.xor
    call $mp_set_u32
    block  ;; label = @1
      local.get 1
      i32.const -1
      i32.gt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 1
      i32.store offset=8
    end)
  (func $mp_get_i32 (type 19) (param i32) (result i32)
    (local i32)
    i32.const 0
    local.get 0
    call $mp_get_mag_u32
    local.tee 1
    i32.sub
    local.get 1
    local.get 0
    i32.load offset=8
    i32.const 1
    i32.eq
    select)
  (func $mp_get_mag_u32 (type 19) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 1
      i32.const 2
      local.get 1
      i32.const 2
      i32.lt_u
      select
      local.tee 1
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 1
    i32.const 2
    i32.shl
    local.set 1
    local.get 0
    i32.load offset=12
    i32.const -4
    i32.add
    local.set 2
    i32.const 0
    local.set 0
    loop  ;; label = @1
      local.get 2
      local.get 1
      i32.add
      i32.load
      local.get 0
      i32.const 28
      i32.shl
      i32.or
      local.set 0
      local.get 1
      i32.const -4
      i32.add
      local.tee 1
      br_if 0 (;@1;)
    end
    local.get 0)
  (func $mp_set_u64 (type 32) (param i32 i64)
    (local i32 i32 i32)
    local.get 0
    i32.load offset=12
    local.set 2
    i32.const 0
    local.set 3
    block  ;; label = @1
      local.get 1
      i64.eqz
      br_if 0 (;@1;)
      i32.const 0
      local.set 3
      local.get 2
      local.set 4
      loop  ;; label = @2
        local.get 4
        local.get 1
        i32.wrap_i64
        i32.const 268435455
        i32.and
        i32.store
        local.get 4
        i32.const 4
        i32.add
        local.set 4
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 1
        i64.const 28
        i64.shr_u
        local.tee 1
        i64.const 0
        i64.ne
        br_if 0 (;@2;)
      end
    end
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    local.get 3
    i32.store
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.get 3
      i32.sub
      local.tee 4
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 4
      i32.const 1
      i32.add
      local.set 0
      local.get 2
      local.get 3
      i32.const 2
      i32.shl
      i32.add
      local.set 4
      loop  ;; label = @2
        local.get 4
        i32.const 0
        i32.store
        local.get 4
        i32.const 4
        i32.add
        local.set 4
        local.get 0
        i32.const -1
        i32.add
        local.tee 0
        i32.const 1
        i32.gt_s
        br_if 0 (;@2;)
      end
    end)
  (func $mp_set_i64 (type 32) (param i32 i64)
    (local i64)
    local.get 0
    local.get 1
    local.get 1
    i64.const 63
    i64.shr_s
    local.tee 2
    i64.add
    local.get 2
    i64.xor
    call $mp_set_u64
    block  ;; label = @1
      local.get 1
      i64.const -1
      i64.gt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 1
      i32.store offset=8
    end)
  (func $mp_get_i64 (type 27) (param i32) (result i64)
    (local i64)
    i64.const 0
    local.get 0
    call $mp_get_mag_u64
    local.tee 1
    i64.sub
    local.get 1
    local.get 0
    i32.load offset=8
    i32.const 1
    i32.eq
    select)
  (func $mp_get_mag_u64 (type 27) (param i32) (result i64)
    (local i32 i64)
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 1
      i32.const 3
      local.get 1
      i32.const 3
      i32.lt_u
      select
      local.tee 1
      br_if 0 (;@1;)
      i64.const 0
      return
    end
    local.get 1
    i32.const 2
    i32.shl
    local.set 1
    local.get 0
    i32.load offset=12
    i32.const -4
    i32.add
    local.set 0
    i64.const 0
    local.set 2
    loop  ;; label = @1
      local.get 2
      i64.const 28
      i64.shl
      local.get 0
      local.get 1
      i32.add
      i64.load32_u
      i64.or
      local.set 2
      local.get 1
      i32.const -4
      i32.add
      local.tee 1
      br_if 0 (;@1;)
    end
    local.get 2)
  (func $mp_div (type 33) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i32)
    global.get 4
    i32.const 80
    i32.sub
    local.tee 4
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load
        br_if 0 (;@2;)
        i32.const -3
        local.set 5
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        local.get 1
        call $mp_cmp_mag
        i32.const -1
        i32.ne
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            br_if 0 (;@4;)
            i32.const 0
            local.set 5
            br 1 (;@3;)
          end
          local.get 0
          local.get 3
          call $mp_copy
          local.set 5
        end
        local.get 2
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        call $mp_zero
        br 1 (;@1;)
      end
      local.get 4
      i32.const 64
      i32.add
      local.get 0
      i32.load
      i32.const 2
      i32.add
      call $mp_init_size
      local.tee 5
      br_if 0 (;@1;)
      local.get 4
      local.get 0
      i32.load
      i32.const 2
      i32.add
      i32.store offset=64
      block  ;; label = @2
        local.get 4
        i32.const 16
        i32.add
        call $mp_init
        local.tee 5
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 4
          call $mp_init
          local.tee 5
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 4
            i32.const 48
            i32.add
            local.get 0
            call $mp_init_copy
            local.tee 5
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 4
              i32.const 32
              i32.add
              local.get 1
              call $mp_init_copy
              local.tee 5
              br_if 0 (;@5;)
              i32.const 0
              local.set 6
              local.get 4
              i32.const 0
              i32.store offset=40
              local.get 4
              i32.const 0
              i32.store offset=56
              local.get 1
              i32.load offset=8
              local.set 7
              local.get 0
              i32.load offset=8
              local.set 8
              block  ;; label = @6
                block  ;; label = @7
                  local.get 4
                  i32.const 32
                  i32.add
                  call $mp_count_bits
                  i32.const 28
                  i32.rem_s
                  local.tee 1
                  i32.const 26
                  i32.gt_s
                  br_if 0 (;@7;)
                  local.get 4
                  i32.const 48
                  i32.add
                  i32.const 27
                  local.get 1
                  i32.sub
                  local.tee 6
                  local.get 4
                  i32.const 48
                  i32.add
                  call $mp_mul_2d
                  local.tee 5
                  br_if 1 (;@6;)
                  local.get 4
                  i32.const 32
                  i32.add
                  local.get 6
                  local.get 4
                  i32.const 32
                  i32.add
                  call $mp_mul_2d
                  local.tee 5
                  br_if 1 (;@6;)
                end
                local.get 4
                i32.const 32
                i32.add
                local.get 4
                i32.load offset=48
                local.tee 9
                i32.const -1
                i32.add
                local.tee 10
                local.get 4
                i32.load offset=32
                local.tee 11
                i32.const -1
                i32.add
                local.tee 12
                i32.sub
                local.tee 13
                call $mp_lshd
                local.tee 5
                br_if 0 (;@6;)
                local.get 8
                local.get 7
                i32.ne
                local.set 14
                local.get 13
                i32.const 2
                i32.shl
                local.set 7
                block  ;; label = @7
                  loop  ;; label = @8
                    local.get 4
                    i32.const 48
                    i32.add
                    local.get 4
                    i32.const 32
                    i32.add
                    call $mp_cmp
                    i32.const -1
                    i32.eq
                    br_if 1 (;@7;)
                    local.get 4
                    i32.load offset=76
                    local.get 7
                    i32.add
                    local.tee 1
                    local.get 1
                    i32.load
                    i32.const 1
                    i32.add
                    i32.store
                    local.get 4
                    i32.const 48
                    i32.add
                    local.get 4
                    i32.const 32
                    i32.add
                    local.get 4
                    i32.const 48
                    i32.add
                    call $mp_sub
                    local.tee 5
                    i32.eqz
                    br_if 0 (;@8;)
                    br 2 (;@6;)
                  end
                end
                local.get 4
                i32.const 32
                i32.add
                local.get 13
                call $mp_rshd
                local.get 4
                i32.load offset=48
                local.set 1
                block  ;; label = @7
                  local.get 9
                  local.get 11
                  i32.le_s
                  br_if 0 (;@7;)
                  local.get 11
                  i32.const -2
                  i32.add
                  i32.const 2
                  i32.shl
                  local.set 15
                  loop  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 10
                        local.tee 13
                        local.get 1
                        i32.le_s
                        br_if 0 (;@10;)
                        local.get 13
                        i32.const -1
                        i32.add
                        local.set 10
                        br 1 (;@9;)
                      end
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 4
                          i32.load offset=60
                          local.tee 5
                          local.get 13
                          i32.const 2
                          i32.shl
                          local.tee 16
                          i32.add
                          i32.load
                          local.tee 7
                          local.get 4
                          i32.load offset=44
                          local.get 12
                          i32.const 2
                          i32.shl
                          local.tee 9
                          i32.add
                          i32.load
                          local.tee 8
                          i32.ne
                          br_if 0 (;@11;)
                          i32.const 268435455
                          local.set 5
                          local.get 4
                          i32.load offset=76
                          local.tee 1
                          local.get 13
                          local.get 11
                          i32.sub
                          local.tee 17
                          i32.const 2
                          i32.shl
                          i32.add
                          i32.const 268435455
                          i32.store
                          local.get 13
                          i32.const -1
                          i32.add
                          local.set 10
                          br 1 (;@10;)
                        end
                        local.get 4
                        i32.load offset=76
                        local.tee 1
                        local.get 13
                        local.get 11
                        i32.sub
                        local.tee 17
                        i32.const 2
                        i32.shl
                        i32.add
                        local.get 7
                        i64.extend_i32_u
                        i64.const 28
                        i64.shl
                        local.get 5
                        local.get 13
                        i32.const -1
                        i32.add
                        local.tee 10
                        i32.const 2
                        i32.shl
                        i32.add
                        i64.load32_u
                        i64.or
                        local.get 8
                        i64.extend_i32_u
                        i64.div_u
                        local.tee 18
                        i64.const 268435455
                        local.get 18
                        i64.const 268435455
                        i64.lt_u
                        select
                        i32.wrap_i64
                        local.tee 5
                        i32.store
                      end
                      local.get 1
                      local.get 17
                      i32.const 2
                      i32.shl
                      local.tee 7
                      i32.add
                      local.get 5
                      i32.const 1
                      i32.add
                      i32.const 268435455
                      i32.and
                      local.tee 5
                      i32.store
                      local.get 13
                      i32.const -2
                      i32.add
                      local.set 19
                      loop  ;; label = @10
                        local.get 1
                        local.get 7
                        i32.add
                        local.get 5
                        i32.const -1
                        i32.add
                        i32.const 268435455
                        i32.and
                        i32.store
                        local.get 4
                        i32.const 16
                        i32.add
                        call $mp_zero
                        i32.const 0
                        local.set 1
                        local.get 4
                        i32.load offset=44
                        local.set 5
                        block  ;; label = @11
                          local.get 11
                          i32.const 2
                          i32.lt_s
                          br_if 0 (;@11;)
                          local.get 5
                          local.get 15
                          i32.add
                          i32.load
                          local.set 1
                        end
                        local.get 4
                        i32.load offset=28
                        local.tee 8
                        local.get 1
                        i32.store
                        local.get 8
                        local.get 5
                        local.get 9
                        i32.add
                        i32.load
                        i32.store offset=4
                        local.get 4
                        i32.const 2
                        i32.store offset=16
                        local.get 4
                        i32.const 16
                        i32.add
                        local.get 4
                        i32.load offset=76
                        local.get 7
                        i32.add
                        i32.load
                        local.get 4
                        i32.const 16
                        i32.add
                        call $mp_mul_d
                        local.tee 5
                        br_if 4 (;@6;)
                        i32.const 0
                        local.set 8
                        local.get 4
                        i32.load offset=60
                        local.set 1
                        block  ;; label = @11
                          local.get 13
                          i32.const 2
                          i32.lt_s
                          br_if 0 (;@11;)
                          local.get 1
                          local.get 19
                          i32.const 2
                          i32.shl
                          i32.add
                          i32.load
                          local.set 8
                        end
                        local.get 4
                        i32.load offset=12
                        local.tee 5
                        local.get 8
                        i32.store
                        local.get 5
                        local.get 1
                        local.get 10
                        i32.const 2
                        i32.shl
                        i32.add
                        i32.load
                        i32.store offset=4
                        local.get 5
                        local.get 1
                        local.get 16
                        i32.add
                        i32.load
                        i32.store offset=8
                        local.get 4
                        i32.const 3
                        i32.store
                        local.get 4
                        i32.const 16
                        i32.add
                        local.get 4
                        call $mp_cmp_mag
                        local.set 8
                        local.get 4
                        i32.load offset=76
                        local.tee 1
                        local.get 7
                        i32.add
                        i32.load
                        local.set 5
                        local.get 8
                        i32.const 1
                        i32.eq
                        br_if 0 (;@10;)
                      end
                      local.get 4
                      i32.const 32
                      i32.add
                      local.get 5
                      local.get 4
                      i32.const 16
                      i32.add
                      call $mp_mul_d
                      local.tee 5
                      br_if 3 (;@6;)
                      local.get 4
                      i32.const 16
                      i32.add
                      local.get 17
                      call $mp_lshd
                      local.tee 5
                      br_if 3 (;@6;)
                      local.get 4
                      i32.const 48
                      i32.add
                      local.get 4
                      i32.const 16
                      i32.add
                      local.get 4
                      i32.const 48
                      i32.add
                      call $mp_sub
                      local.tee 5
                      br_if 3 (;@6;)
                      local.get 4
                      i32.load offset=56
                      i32.const 1
                      i32.ne
                      br_if 0 (;@9;)
                      local.get 4
                      i32.const 32
                      i32.add
                      local.get 4
                      i32.const 16
                      i32.add
                      call $mp_copy
                      local.tee 5
                      br_if 3 (;@6;)
                      local.get 4
                      i32.const 16
                      i32.add
                      local.get 17
                      call $mp_lshd
                      local.tee 5
                      br_if 3 (;@6;)
                      local.get 4
                      i32.const 48
                      i32.add
                      local.get 4
                      i32.const 16
                      i32.add
                      local.get 4
                      i32.const 48
                      i32.add
                      call $mp_add
                      local.tee 5
                      br_if 3 (;@6;)
                      local.get 4
                      i32.load offset=76
                      local.get 7
                      i32.add
                      local.tee 1
                      local.get 1
                      i32.load
                      i32.const -1
                      i32.add
                      i32.const 268435455
                      i32.and
                      i32.store
                    end
                    local.get 4
                    i32.load offset=48
                    local.set 1
                    local.get 13
                    local.get 11
                    i32.gt_s
                    br_if 0 (;@8;)
                  end
                end
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 1
                    br_if 0 (;@8;)
                    i32.const 0
                    local.set 1
                    br 1 (;@7;)
                  end
                  local.get 0
                  i32.load offset=8
                  local.set 1
                end
                local.get 4
                local.get 1
                i32.store offset=56
                block  ;; label = @7
                  local.get 2
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 4
                  i32.const 64
                  i32.add
                  call $mp_clamp
                  local.get 4
                  i32.const 64
                  i32.add
                  local.get 2
                  call $mp_exch
                  local.get 2
                  local.get 14
                  i32.store offset=8
                end
                block  ;; label = @7
                  local.get 3
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 4
                  i32.const 48
                  i32.add
                  local.get 6
                  local.get 4
                  i32.const 48
                  i32.add
                  i32.const 0
                  call $mp_div_2d
                  local.tee 5
                  br_if 1 (;@6;)
                  local.get 4
                  i32.const 48
                  i32.add
                  local.get 3
                  call $mp_exch
                end
                i32.const 0
                local.set 5
              end
              local.get 4
              i32.const 32
              i32.add
              call $mp_clear
            end
            local.get 4
            i32.const 48
            i32.add
            call $mp_clear
          end
          local.get 4
          call $mp_clear
        end
        local.get 4
        i32.const 16
        i32.add
        call $mp_clear
      end
      local.get 4
      i32.const 64
      i32.add
      call $mp_clear
    end
    local.get 4
    i32.const 80
    i32.add
    global.set 4
    local.get 5)
  (func $mp_init_copy (type 26) (param i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      local.get 1
      i32.load
      call $mp_init_size
      local.tee 2
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 1
        local.get 0
        call $mp_copy
        local.tee 2
        br_if 0 (;@2;)
        i32.const 0
        return
      end
      local.get 0
      call $mp_clear
    end
    local.get 2)
  (func $mp_neg (type 26) (param i32 i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        local.get 1
        i32.eq
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        call $mp_copy
        local.tee 2
        br_if 1 (;@1;)
      end
      i32.const 0
      local.set 2
      i32.const 0
      local.set 3
      block  ;; label = @2
        local.get 1
        i32.load
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.load offset=8
        i32.eqz
        local.set 3
      end
      local.get 1
      local.get 3
      i32.store offset=8
    end
    local.get 2)
  (func $mp_abs (type 26) (param i32 i32) (result i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        local.get 1
        i32.eq
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        call $mp_copy
        local.tee 0
        br_if 1 (;@1;)
      end
      i32.const 0
      local.set 0
      local.get 1
      i32.const 0
      i32.store offset=8
    end
    local.get 0)
  (func $mp_2expt (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    call $mp_zero
    block  ;; label = @1
      local.get 0
      local.get 1
      i32.const 28
      i32.div_s
      local.tee 2
      i32.const 1
      i32.add
      local.tee 3
      call $mp_grow
      local.tee 4
      br_if 0 (;@1;)
      local.get 0
      local.get 3
      i32.store
      local.get 0
      i32.load offset=12
      local.get 2
      i32.const 2
      i32.shl
      i32.add
      i32.const 1
      local.get 1
      local.get 2
      i32.const 28
      i32.mul
      i32.sub
      i32.shl
      i32.store
    end
    local.get 4)
  (func $mp_expt_u32 (type 18) (param i32 i32 i32) (result i32)
    (local i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 3
    global.set 4
    block  ;; label = @1
      local.get 3
      local.get 0
      call $mp_init_copy
      local.tee 0
      br_if 0 (;@1;)
      local.get 2
      i32.const 1
      call $mp_set
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.eqz
          br_if 0 (;@3;)
          loop  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.const 1
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              local.get 2
              local.get 3
              local.get 2
              call $mp_mul
              local.tee 0
              br_if 3 (;@2;)
            end
            block  ;; label = @5
              local.get 1
              i32.const 2
              i32.lt_u
              br_if 0 (;@5;)
              local.get 3
              local.get 3
              call $mp_sqr
              local.tee 0
              br_if 3 (;@2;)
            end
            local.get 1
            i32.const 1
            i32.shr_u
            local.tee 1
            br_if 0 (;@4;)
          end
        end
        i32.const 0
        local.set 0
      end
      local.get 3
      call $mp_clear
    end
    local.get 3
    i32.const 16
    i32.add
    global.set 4
    local.get 0)
  (func $mp_set (type 20) (param i32 i32)
    (local i32 i32)
    local.get 0
    i32.load offset=12
    local.tee 2
    local.get 1
    i32.const 268435455
    i32.and
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    local.get 2
    i32.load
    i32.const 0
    i32.ne
    local.tee 3
    i32.store
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.get 3
      i32.sub
      local.tee 0
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 1
      i32.add
      local.set 1
      local.get 2
      local.get 3
      i32.const 2
      i32.shl
      i32.add
      local.set 0
      loop  ;; label = @2
        local.get 0
        i32.const 0
        i32.store
        local.get 0
        i32.const 4
        i32.add
        local.set 0
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        i32.const 1
        i32.gt_s
        br_if 0 (;@2;)
      end
    end)
  (func $mp_sqr (type 26) (param i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load
        local.tee 2
        i32.const 400
        i32.lt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        call $s_mp_toom_sqr
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 2
        i32.const 120
        i32.lt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        call $s_mp_karatsuba_sqr
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 2
        i32.const 1
        i32.shl
        i32.const 1
        i32.or
        i32.const 511
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        call $s_mp_sqr_fast
        local.set 0
        br 1 (;@1;)
      end
      local.get 0
      local.get 1
      call $s_mp_sqr
      local.set 0
    end
    local.get 1
    i32.const 0
    i32.store offset=8
    local.get 0)
  (func $s_mp_add (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    local.get 0
    i32.load
    local.tee 3
    local.get 1
    i32.load
    local.tee 4
    local.get 3
    local.get 4
    i32.gt_s
    local.tee 5
    select
    local.tee 6
    i32.const 1
    i32.add
    local.set 7
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=4
        local.get 6
        i32.gt_s
        br_if 0 (;@2;)
        local.get 2
        local.get 7
        call $mp_grow
        local.tee 8
        br_if 1 (;@1;)
      end
      local.get 2
      i32.load
      local.set 9
      local.get 2
      local.get 7
      i32.store
      local.get 2
      i32.load offset=12
      local.set 7
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          local.get 3
          local.get 5
          select
          local.tee 10
          i32.const 1
          i32.ge_s
          br_if 0 (;@3;)
          i32.const 0
          local.set 3
          i32.const 0
          local.set 8
          br 1 (;@2;)
        end
        local.get 0
        i32.load offset=12
        local.set 4
        local.get 1
        i32.load offset=12
        local.set 8
        i32.const 0
        local.set 11
        i32.const 0
        local.set 3
        loop  ;; label = @3
          local.get 7
          local.get 4
          i32.load
          local.get 3
          i32.add
          local.get 8
          i32.load
          i32.add
          local.tee 3
          i32.const 268435455
          i32.and
          i32.store
          local.get 7
          i32.const 4
          i32.add
          local.set 7
          local.get 8
          i32.const 4
          i32.add
          local.set 8
          local.get 4
          i32.const 4
          i32.add
          local.set 4
          local.get 3
          i32.const 28
          i32.shr_u
          local.set 3
          local.get 11
          i32.const 1
          i32.add
          local.tee 11
          local.get 10
          i32.lt_s
          br_if 0 (;@3;)
        end
        local.get 10
        local.set 8
      end
      block  ;; label = @2
        local.get 10
        local.get 6
        i32.eq
        br_if 0 (;@2;)
        local.get 8
        local.get 6
        i32.ge_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        local.get 5
        select
        i32.load offset=12
        local.get 8
        i32.const 2
        i32.shl
        i32.add
        local.set 4
        loop  ;; label = @3
          local.get 7
          local.get 4
          i32.load
          local.get 3
          i32.add
          local.tee 3
          i32.const 268435455
          i32.and
          i32.store
          local.get 4
          i32.const 4
          i32.add
          local.set 4
          local.get 7
          i32.const 4
          i32.add
          local.set 7
          local.get 3
          i32.const 28
          i32.shr_u
          local.set 3
          local.get 8
          i32.const 1
          i32.add
          local.tee 8
          local.get 6
          i32.lt_s
          br_if 0 (;@3;)
        end
      end
      local.get 7
      local.get 3
      i32.store
      block  ;; label = @2
        local.get 9
        local.get 2
        i32.load
        i32.sub
        local.tee 3
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 7
        i32.const 4
        i32.add
        local.set 7
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        loop  ;; label = @3
          local.get 7
          i32.const 0
          i32.store
          local.get 7
          i32.const 4
          i32.add
          local.set 7
          local.get 3
          i32.const -1
          i32.add
          local.tee 3
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 2
      call $mp_clamp
      i32.const 0
      local.set 8
    end
    local.get 8)
  (func $mp_cmp_mag (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    i32.const 1
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 3
      local.get 1
      i32.load
      local.tee 4
      i32.gt_s
      br_if 0 (;@1;)
      i32.const -1
      local.set 2
      local.get 3
      local.get 4
      i32.lt_s
      br_if 0 (;@1;)
      i32.const 0
      local.set 2
      local.get 3
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.load offset=12
      local.get 3
      i32.const -1
      i32.add
      i32.const 2
      i32.shl
      local.tee 4
      i32.add
      local.set 0
      local.get 1
      i32.load offset=12
      local.get 4
      i32.add
      local.set 1
      loop  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load
          local.tee 4
          local.get 1
          i32.load
          local.tee 5
          i32.le_u
          br_if 0 (;@3;)
          i32.const 1
          return
        end
        block  ;; label = @3
          local.get 4
          local.get 5
          i32.ge_u
          br_if 0 (;@3;)
          i32.const -1
          return
        end
        local.get 1
        i32.const -4
        i32.add
        local.set 1
        local.get 0
        i32.const -4
        i32.add
        local.set 0
        local.get 3
        i32.const -1
        i32.add
        local.tee 3
        br_if 0 (;@2;)
      end
    end
    local.get 2)
  (func $s_mp_sub (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    local.get 1
    i32.load
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 2
        local.get 4
        call $mp_grow
        local.tee 5
        br_if 1 (;@1;)
      end
      local.get 2
      i32.load
      local.set 6
      local.get 2
      local.get 4
      i32.store
      local.get 2
      i32.load offset=12
      local.set 5
      local.get 0
      i32.load offset=12
      local.set 0
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const 1
          i32.ge_s
          br_if 0 (;@3;)
          i32.const 0
          local.set 1
          i32.const 0
          local.set 3
          br 1 (;@2;)
        end
        local.get 1
        i32.load offset=12
        local.set 7
        i32.const 0
        local.set 1
        local.get 3
        local.set 8
        loop  ;; label = @3
          local.get 5
          local.get 0
          i32.load
          local.get 7
          i32.load
          i32.sub
          local.get 1
          i32.sub
          local.tee 1
          i32.const 268435455
          i32.and
          i32.store
          local.get 5
          i32.const 4
          i32.add
          local.set 5
          local.get 7
          i32.const 4
          i32.add
          local.set 7
          local.get 0
          i32.const 4
          i32.add
          local.set 0
          local.get 1
          i32.const 31
          i32.shr_u
          local.set 1
          local.get 8
          i32.const -1
          i32.add
          local.tee 8
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 3
        local.get 4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 4
        local.get 3
        i32.sub
        local.set 7
        loop  ;; label = @3
          local.get 5
          local.get 0
          i32.load
          local.get 1
          i32.sub
          local.tee 1
          i32.const 268435455
          i32.and
          i32.store
          local.get 5
          i32.const 4
          i32.add
          local.set 5
          local.get 0
          i32.const 4
          i32.add
          local.set 0
          local.get 1
          i32.const 31
          i32.shr_u
          local.set 1
          local.get 7
          i32.const -1
          i32.add
          local.tee 7
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 6
        local.get 2
        i32.load
        i32.sub
        local.tee 0
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        loop  ;; label = @3
          local.get 5
          i32.const 0
          i32.store
          local.get 5
          i32.const 4
          i32.add
          local.set 5
          local.get 0
          i32.const -1
          i32.add
          local.tee 0
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 2
      call $mp_clamp
      i32.const 0
      local.set 5
    end
    local.get 5)
  (func $mp_grow (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.tee 3
      local.get 1
      i32.ge_s
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 0
        i32.load offset=12
        local.get 3
        i32.const 2
        i32.shl
        local.get 1
        i32.const 2
        i32.shl
        call $mp_realloc
        local.tee 3
        br_if 0 (;@2;)
        i32.const -2
        return
      end
      local.get 0
      local.get 3
      i32.store offset=12
      local.get 0
      i32.load offset=4
      local.set 4
      local.get 0
      local.get 1
      i32.store offset=4
      local.get 1
      local.get 4
      i32.sub
      local.tee 0
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      local.get 4
      i32.const 2
      i32.shl
      i32.add
      local.set 0
      loop  ;; label = @2
        i32.const 0
        local.set 2
        local.get 0
        i32.const 0
        i32.store
        local.get 0
        i32.const 4
        i32.add
        local.set 0
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        i32.const 1
        i32.gt_s
        br_if 0 (;@2;)
      end
    end
    local.get 2)
  (func $mp_clamp (type 23) (param i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load
        local.tee 1
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 1
        i32.const 2
        i32.shl
        local.get 0
        i32.load offset=12
        i32.add
        i32.const -4
        i32.add
        local.set 2
        loop  ;; label = @3
          local.get 2
          i32.load
          br_if 2 (;@1;)
          local.get 0
          local.get 1
          i32.const -1
          i32.add
          local.tee 1
          i32.store
          local.get 2
          i32.const -4
          i32.add
          local.set 2
          local.get 1
          i32.const 1
          i32.add
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 1
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      i32.store offset=8
    end)
  (func $mp_init_size (type 26) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    local.get 1
    i32.const 3
    local.get 1
    i32.const 3
    i32.gt_s
    select
    local.tee 2
    i32.const 4
    call $mp_calloc
    local.tee 1
    i32.store offset=12
    block  ;; label = @1
      local.get 1
      br_if 0 (;@1;)
      i32.const -2
      return
    end
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0
    i32.const 0
    i32.store
    i32.const 0)
  (func $mp_exch (type 20) (param i32 i32)
    (local i64 i64 i32)
    global.get 4
    i32.const 16
    i32.sub
    drop
    local.get 0
    i64.load align=4
    local.set 2
    local.get 0
    local.get 1
    i64.load align=4
    i64.store align=4
    local.get 0
    i32.const 8
    i32.add
    local.tee 0
    i64.load align=4
    local.set 3
    local.get 0
    local.get 1
    i32.const 8
    i32.add
    local.tee 4
    i64.load align=4
    i64.store align=4
    local.get 1
    local.get 2
    i64.store align=4
    local.get 4
    local.get 3
    i64.store align=4)
  (func $mp_clear (type 23) (param i32)
    (local i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=12
      local.tee 1
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 0
        i32.load offset=4
        i32.const 2
        i32.shl
        local.tee 2
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        local.get 2
        i32.sub
        local.set 3
        local.get 1
        local.set 4
        loop  ;; label = @3
          local.get 4
          i32.const 0
          i32.store8
          local.get 4
          i32.const 1
          i32.add
          local.set 4
          local.get 3
          i32.const 1
          i32.add
          local.tee 5
          local.get 3
          i32.ge_u
          local.set 6
          local.get 5
          local.set 3
          local.get 6
          br_if 0 (;@3;)
        end
      end
      local.get 1
      local.get 2
      call $mp_free
      local.get 0
      i64.const 0
      i64.store align=4
      local.get 0
      i64.const 0
      i64.store offset=8 align=4
    end)
  (func $mp_copy (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        local.get 1
        i32.eq
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 1
          i32.load offset=4
          local.get 0
          i32.load
          local.tee 2
          i32.ge_s
          br_if 0 (;@3;)
          local.get 1
          local.get 2
          call $mp_grow
          local.tee 3
          br_if 2 (;@1;)
          local.get 0
          i32.load
          local.set 2
        end
        local.get 1
        i32.load offset=12
        local.set 3
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.const 1
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 0
            local.set 4
            br 1 (;@3;)
          end
          local.get 0
          i32.load offset=12
          local.set 5
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 3
            local.get 5
            i32.load
            i32.store
            local.get 3
            i32.const 4
            i32.add
            local.set 3
            local.get 5
            i32.const 4
            i32.add
            local.set 5
            local.get 4
            i32.const 1
            i32.add
            local.tee 4
            local.get 0
            i32.load
            local.tee 2
            i32.lt_s
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 1
          i32.load
          local.get 4
          i32.sub
          local.tee 5
          i32.const 1
          i32.lt_s
          br_if 0 (;@3;)
          local.get 5
          i32.const 1
          i32.add
          local.set 5
          loop  ;; label = @4
            local.get 3
            i32.const 0
            i32.store
            local.get 3
            i32.const 4
            i32.add
            local.set 3
            local.get 5
            i32.const -1
            i32.add
            local.tee 5
            i32.const 1
            i32.gt_s
            br_if 0 (;@4;)
          end
          local.get 0
          i32.load
          local.set 2
        end
        local.get 1
        local.get 2
        i32.store
        local.get 1
        local.get 0
        i32.load offset=8
        i32.store offset=8
      end
      i32.const 0
      local.set 3
    end
    local.get 3)
  (func $mp_count_bits (type 19) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 1
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 1
    i32.const -1
    i32.add
    local.tee 2
    i32.const 28
    i32.mul
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.load offset=12
      local.get 2
      i32.const 2
      i32.shl
      i32.add
      i32.load
      local.tee 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      local.get 0
      i32.clz
      i32.sub
      i32.const 32
      i32.add
      local.set 1
    end
    local.get 1)
  (func $mp_mul_2d (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        local.get 2
        i32.eq
        br_if 0 (;@2;)
        local.get 0
        local.get 2
        call $mp_copy
        local.tee 0
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 2
        i32.load offset=4
        local.get 2
        i32.load
        local.get 1
        i32.const 28
        i32.div_s
        local.tee 3
        i32.add
        local.tee 0
        i32.gt_s
        br_if 0 (;@2;)
        local.get 2
        local.get 0
        i32.const 1
        i32.add
        call $mp_grow
        local.tee 0
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 1
        i32.const 28
        i32.lt_s
        br_if 0 (;@2;)
        local.get 2
        local.get 3
        call $mp_lshd
        local.tee 0
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 1
        local.get 3
        i32.const 28
        i32.mul
        i32.sub
        local.tee 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        i32.load
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        i32.const 28
        local.get 4
        i32.sub
        local.set 5
        i32.const -1
        local.get 4
        i32.shl
        i32.const -1
        i32.xor
        local.set 6
        i32.const 0
        local.set 3
        i32.const 0
        local.set 1
        local.get 2
        i32.load offset=12
        local.tee 7
        local.set 0
        loop  ;; label = @3
          local.get 0
          local.get 0
          i32.load
          local.tee 8
          local.get 4
          i32.shl
          local.get 1
          i32.or
          i32.const 268435455
          i32.and
          i32.store
          local.get 0
          i32.const 4
          i32.add
          local.set 0
          local.get 8
          local.get 5
          i32.shr_u
          local.get 6
          i32.and
          local.set 1
          local.get 3
          i32.const 1
          i32.add
          local.tee 3
          local.get 2
          i32.load
          local.tee 8
          i32.lt_s
          br_if 0 (;@3;)
        end
        local.get 1
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 8
        i32.const 1
        i32.add
        i32.store
        local.get 7
        local.get 8
        i32.const 2
        i32.shl
        i32.add
        local.get 1
        i32.store
      end
      local.get 2
      call $mp_clamp
      i32.const 0
      local.set 0
    end
    local.get 0)
  (func $mp_rshd (type 20) (param i32 i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 0
        i32.load
        local.get 1
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        call $mp_zero
        return
      end
      local.get 1
      i32.const 2
      i32.shl
      local.set 2
      local.get 0
      i32.load offset=12
      local.set 3
      i32.const 0
      local.set 4
      loop  ;; label = @2
        local.get 3
        local.get 3
        local.get 2
        i32.add
        i32.load
        i32.store
        local.get 3
        i32.const 4
        i32.add
        local.set 3
        local.get 4
        i32.const 1
        i32.add
        local.tee 4
        local.get 0
        i32.load
        local.tee 5
        local.get 1
        i32.sub
        i32.lt_s
        br_if 0 (;@2;)
      end
      block  ;; label = @2
        local.get 5
        local.get 4
        i32.sub
        local.tee 4
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 4
        i32.const 1
        i32.add
        local.set 4
        loop  ;; label = @3
          local.get 3
          i32.const 0
          i32.store
          local.get 3
          i32.const 4
          i32.add
          local.set 3
          local.get 4
          i32.const -1
          i32.add
          local.tee 4
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
        local.get 0
        i32.load
        local.set 5
      end
      local.get 0
      local.get 5
      local.get 1
      i32.sub
      i32.store
    end)
  (func $mp_mul_d (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i64 i64)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 3
        i32.gt_s
        br_if 0 (;@2;)
        local.get 2
        local.get 3
        i32.const 1
        i32.add
        call $mp_grow
        local.tee 4
        br_if 1 (;@1;)
        local.get 0
        i32.load
        local.set 3
      end
      local.get 2
      local.get 0
      i32.load offset=8
      i32.store offset=8
      local.get 2
      i32.load offset=12
      local.set 4
      local.get 2
      i32.load
      local.set 5
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const 1
          i32.ge_s
          br_if 0 (;@3;)
          i32.const -1
          local.set 3
          i32.const 0
          local.set 1
          br 1 (;@2;)
        end
        local.get 1
        i64.extend_i32_u
        local.set 6
        local.get 0
        i32.load offset=12
        local.set 3
        i64.const 0
        local.set 7
        i32.const 0
        local.set 1
        loop  ;; label = @3
          local.get 4
          local.get 3
          i64.load32_u
          local.get 6
          i64.mul
          local.get 7
          i64.const 4294967295
          i64.and
          i64.add
          local.tee 7
          i32.wrap_i64
          i32.const 268435455
          i32.and
          i32.store
          local.get 7
          i64.const 28
          i64.shr_u
          local.set 7
          local.get 4
          i32.const 4
          i32.add
          local.set 4
          local.get 3
          i32.const 4
          i32.add
          local.set 3
          local.get 1
          i32.const 1
          i32.add
          local.tee 1
          local.get 0
          i32.load
          i32.lt_s
          br_if 0 (;@3;)
        end
        local.get 1
        i32.const -1
        i32.xor
        local.set 3
        local.get 7
        i32.wrap_i64
        local.set 1
      end
      local.get 4
      local.get 1
      i32.store
      block  ;; label = @2
        local.get 5
        local.get 3
        i32.add
        local.tee 3
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 4
        i32.const 4
        i32.add
        local.set 4
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        loop  ;; label = @3
          local.get 4
          i32.const 0
          i32.store
          local.get 4
          i32.const 4
          i32.add
          local.set 4
          local.get 3
          i32.const -1
          i32.add
          local.tee 3
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 2
      local.get 0
      i32.load
      i32.const 1
      i32.add
      i32.store
      local.get 2
      call $mp_clamp
      i32.const 0
      local.set 4
    end
    local.get 4)
  (func $mp_div_2d (type 33) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    local.get 0
    local.get 2
    call $mp_copy
    local.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 0
        i32.gt_s
        br_if 0 (;@2;)
        local.get 3
        i32.eqz
        br_if 1 (;@1;)
        local.get 3
        call $mp_zero
        local.get 4
        return
      end
      local.get 4
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 3
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        local.get 3
        call $mp_mod_2d
        local.tee 4
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 1
        i32.const 28
        i32.lt_s
        br_if 0 (;@2;)
        local.get 2
        local.get 1
        i32.const 28
        i32.div_u
        call $mp_rshd
      end
      block  ;; label = @2
        local.get 1
        i32.const 28
        i32.rem_u
        local.tee 5
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        i32.load
        local.tee 1
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        i32.const 28
        local.get 5
        i32.sub
        local.set 6
        i32.const -1
        local.get 5
        i32.shl
        i32.const -1
        i32.xor
        local.set 7
        local.get 2
        i32.load offset=12
        local.get 1
        i32.const -1
        i32.add
        i32.const 2
        i32.shl
        i32.add
        local.set 4
        i32.const 0
        local.set 0
        loop  ;; label = @3
          local.get 4
          local.get 4
          i32.load
          local.tee 3
          local.get 5
          i32.shr_u
          local.get 0
          local.get 6
          i32.shl
          i32.or
          i32.store
          local.get 4
          i32.const -4
          i32.add
          local.set 4
          local.get 3
          local.get 7
          i32.and
          local.set 0
          local.get 1
          i32.const -1
          i32.add
          local.tee 1
          i32.const 0
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 2
      call $mp_clamp
      i32.const 0
      local.set 4
    end
    local.get 4)
  (func $mp_mod_2d (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const 0
      i32.gt_s
      br_if 0 (;@1;)
      local.get 2
      call $mp_zero
      i32.const 0
      return
    end
    local.get 0
    i32.load
    local.set 3
    local.get 0
    local.get 2
    call $mp_copy
    local.set 4
    block  ;; label = @1
      local.get 3
      i32.const 28
      i32.mul
      local.get 1
      i32.le_s
      br_if 0 (;@1;)
      local.get 4
      br_if 0 (;@1;)
      i32.const 0
      local.set 4
      local.get 2
      i32.load offset=12
      local.set 5
      block  ;; label = @2
        local.get 2
        i32.load
        local.get 1
        i32.const 28
        i32.div_u
        local.tee 3
        local.get 1
        local.get 3
        i32.const 28
        i32.mul
        i32.sub
        local.tee 6
        i32.const 0
        i32.ne
        i32.add
        local.tee 1
        i32.sub
        local.tee 0
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 5
        local.get 1
        i32.const 2
        i32.shl
        i32.add
        local.set 1
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        loop  ;; label = @3
          local.get 1
          i32.const 0
          i32.store
          local.get 1
          i32.const 4
          i32.add
          local.set 1
          local.get 0
          i32.const -1
          i32.add
          local.tee 0
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 5
      local.get 3
      i32.const 2
      i32.shl
      i32.add
      local.tee 1
      local.get 1
      i32.load
      i32.const -1
      local.get 6
      i32.shl
      i32.const -1
      i32.xor
      i32.and
      i32.store
      local.get 2
      call $mp_clamp
    end
    local.get 4)
  (func $s_mp_balance_mul (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 96
    i32.sub
    local.tee 3
    global.set 4
    local.get 0
    i32.load
    local.tee 4
    local.get 1
    i32.load
    local.tee 5
    local.get 4
    local.get 5
    i32.gt_s
    select
    local.get 4
    local.get 5
    local.get 4
    local.get 5
    i32.lt_s
    select
    local.tee 6
    i32.div_s
    local.set 7
    block  ;; label = @1
      local.get 3
      i32.const 80
      i32.add
      local.get 6
      i32.const 2
      i32.add
      call $mp_init_size
      local.tee 8
      br_if 0 (;@1;)
      local.get 3
      i32.const 0
      i32.store offset=20
      local.get 3
      local.get 3
      i32.const 32
      i32.add
      i32.store offset=16
      block  ;; label = @2
        local.get 3
        i32.const 64
        i32.add
        local.get 3
        i32.const 16
        i32.add
        call $mp_init_multi
        local.tee 8
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        i32.const 80
        i32.add
        call $mp_clear
        br 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          local.get 5
          i32.ge_s
          br_if 0 (;@3;)
          local.get 3
          i32.const 48
          i32.add
          i32.const 8
          i32.add
          local.get 0
          i32.const 8
          i32.add
          i64.load align=4
          i64.store
          local.get 3
          local.get 0
          i64.load align=4
          i64.store offset=48
          local.get 1
          i32.load offset=12
          local.set 9
          local.get 1
          i32.load
          local.set 10
          br 1 (;@2;)
        end
        local.get 3
        i32.const 48
        i32.add
        i32.const 8
        i32.add
        local.get 1
        i32.const 8
        i32.add
        i64.load align=4
        i64.store
        local.get 3
        local.get 1
        i64.load align=4
        i64.store offset=48
        local.get 0
        i32.load offset=12
        local.set 9
        local.get 0
        i32.load
        local.set 10
      end
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 7
            i32.const 1
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 0
            local.set 7
            i32.const 0
            local.set 1
            br 1 (;@3;)
          end
          local.get 6
          i32.const 1
          i32.lt_s
          local.set 11
          i32.const 0
          local.set 1
          i32.const 0
          local.set 0
          loop  ;; label = @4
            local.get 3
            i32.const 0
            i32.store offset=80
            block  ;; label = @5
              local.get 11
              br_if 0 (;@5;)
              local.get 9
              local.get 1
              i32.const 2
              i32.shl
              i32.add
              local.set 8
              i32.const 0
              local.set 5
              local.get 3
              i32.load offset=92
              local.set 4
              loop  ;; label = @6
                local.get 4
                local.get 8
                i32.load
                i32.store
                local.get 3
                local.get 3
                i32.load offset=80
                i32.const 1
                i32.add
                i32.store offset=80
                local.get 4
                i32.const 4
                i32.add
                local.set 4
                local.get 8
                i32.const 4
                i32.add
                local.set 8
                local.get 5
                i32.const 1
                i32.add
                local.tee 5
                local.get 6
                i32.lt_s
                br_if 0 (;@6;)
              end
              local.get 1
              local.get 5
              i32.add
              local.set 1
            end
            local.get 3
            i32.const 80
            i32.add
            call $mp_clamp
            local.get 3
            i32.const 80
            i32.add
            local.get 3
            i32.const 48
            i32.add
            local.get 3
            i32.const 64
            i32.add
            call $mp_mul
            local.tee 8
            br_if 2 (;@2;)
            local.get 3
            i32.const 64
            i32.add
            local.get 0
            local.get 6
            i32.mul
            call $mp_lshd
            local.tee 8
            br_if 2 (;@2;)
            local.get 3
            i32.const 32
            i32.add
            local.get 3
            i32.const 64
            i32.add
            local.get 3
            i32.const 32
            i32.add
            call $mp_add
            local.tee 8
            br_if 2 (;@2;)
            local.get 0
            i32.const 1
            i32.add
            local.tee 0
            local.get 7
            i32.ne
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 10
          local.get 1
          i32.le_s
          br_if 0 (;@3;)
          local.get 3
          i32.const 0
          i32.store offset=80
          local.get 10
          local.get 1
          i32.sub
          local.set 5
          local.get 9
          local.get 1
          i32.const 2
          i32.shl
          i32.add
          local.set 8
          local.get 3
          i32.load offset=92
          local.set 4
          loop  ;; label = @4
            local.get 4
            local.get 8
            i32.load
            i32.store
            local.get 3
            local.get 3
            i32.load offset=80
            i32.const 1
            i32.add
            i32.store offset=80
            local.get 4
            i32.const 4
            i32.add
            local.set 4
            local.get 8
            i32.const 4
            i32.add
            local.set 8
            local.get 5
            i32.const -1
            i32.add
            local.tee 5
            br_if 0 (;@4;)
          end
          local.get 3
          i32.const 80
          i32.add
          call $mp_clamp
          local.get 3
          i32.const 80
          i32.add
          local.get 3
          i32.const 48
          i32.add
          local.get 3
          i32.const 64
          i32.add
          call $mp_mul
          local.tee 8
          br_if 1 (;@2;)
          local.get 3
          i32.const 64
          i32.add
          local.get 7
          local.get 6
          i32.mul
          call $mp_lshd
          local.tee 8
          br_if 1 (;@2;)
          local.get 3
          i32.const 32
          i32.add
          local.get 3
          i32.const 64
          i32.add
          local.get 3
          i32.const 32
          i32.add
          call $mp_add
          local.tee 8
          br_if 1 (;@2;)
        end
        local.get 3
        i32.const 32
        i32.add
        local.get 2
        call $mp_exch
        i32.const 0
        local.set 8
      end
      local.get 3
      i32.const 0
      i32.store offset=8
      local.get 3
      local.get 3
      i32.const 32
      i32.add
      i32.store offset=4
      local.get 3
      local.get 3
      i32.const 64
      i32.add
      i32.store
      local.get 3
      i32.const 80
      i32.add
      local.get 3
      call $mp_clear_multi
    end
    local.get 3
    i32.const 96
    i32.add
    global.set 4
    local.get 8)
  (func $s_mp_toom_mul (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 176
    i32.sub
    local.tee 3
    global.set 4
    local.get 3
    i32.const 0
    i32.store offset=24
    local.get 3
    local.get 3
    i32.const 144
    i32.add
    i32.store offset=16
    local.get 3
    local.get 3
    i32.const 128
    i32.add
    i32.store offset=20
    block  ;; label = @1
      local.get 3
      i32.const 160
      i32.add
      local.get 3
      i32.const 16
      i32.add
      call $mp_init_multi
      local.tee 4
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 3
        i32.const 112
        i32.add
        local.get 0
        i32.load
        local.tee 4
        local.get 1
        i32.load
        local.tee 5
        local.get 4
        local.get 5
        i32.lt_s
        select
        local.tee 6
        i32.const 3
        i32.div_s
        local.tee 7
        call $mp_init_size
        local.tee 4
        br_if 0 (;@2;)
        i32.const 0
        local.set 8
        block  ;; label = @3
          local.get 6
          i32.const 3
          i32.lt_s
          br_if 0 (;@3;)
          local.get 0
          i32.load offset=12
          local.set 4
          local.get 3
          i32.load offset=124
          local.set 5
          local.get 7
          local.set 8
          loop  ;; label = @4
            local.get 5
            local.get 4
            i32.load
            i32.store
            local.get 3
            local.get 3
            i32.load offset=112
            i32.const 1
            i32.add
            i32.store offset=112
            local.get 4
            i32.const 4
            i32.add
            local.set 4
            local.get 5
            i32.const 4
            i32.add
            local.set 5
            local.get 8
            i32.const -1
            i32.add
            local.tee 8
            br_if 0 (;@4;)
          end
          local.get 7
          local.set 8
        end
        local.get 3
        i32.const 112
        i32.add
        call $mp_clamp
        block  ;; label = @3
          local.get 3
          i32.const 96
          i32.add
          local.get 7
          call $mp_init_size
          local.tee 4
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 8
            local.get 7
            i32.const 1
            i32.shl
            local.tee 9
            i32.ge_s
            br_if 0 (;@4;)
            local.get 8
            local.get 9
            i32.sub
            local.set 4
            local.get 0
            i32.load offset=12
            local.get 8
            i32.const 2
            i32.shl
            i32.add
            local.set 5
            local.get 3
            i32.load offset=108
            local.get 8
            local.get 7
            i32.sub
            i32.const 2
            i32.shl
            i32.add
            local.set 8
            loop  ;; label = @5
              local.get 8
              local.get 5
              i32.load
              i32.store
              local.get 3
              local.get 3
              i32.load offset=96
              i32.const 1
              i32.add
              i32.store offset=96
              local.get 5
              i32.const 4
              i32.add
              local.set 5
              local.get 8
              i32.const 4
              i32.add
              local.set 8
              local.get 4
              i32.const 1
              i32.add
              local.tee 10
              local.get 4
              i32.ge_u
              local.set 11
              local.get 10
              local.set 4
              local.get 11
              br_if 0 (;@5;)
            end
            local.get 9
            local.set 8
          end
          local.get 3
          i32.const 96
          i32.add
          call $mp_clamp
          block  ;; label = @4
            local.get 3
            i32.const 80
            i32.add
            local.get 0
            i32.load
            local.get 9
            i32.sub
            call $mp_init_size
            local.tee 4
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 8
              local.get 0
              i32.load
              i32.ge_s
              br_if 0 (;@5;)
              local.get 0
              i32.load offset=12
              local.get 8
              i32.const 2
              i32.shl
              i32.add
              local.set 4
              local.get 3
              i32.load offset=92
              local.get 8
              local.get 9
              i32.sub
              i32.const 2
              i32.shl
              i32.add
              local.set 5
              loop  ;; label = @6
                local.get 5
                local.get 4
                i32.load
                i32.store
                local.get 3
                local.get 3
                i32.load offset=80
                i32.const 1
                i32.add
                i32.store offset=80
                local.get 4
                i32.const 4
                i32.add
                local.set 4
                local.get 5
                i32.const 4
                i32.add
                local.set 5
                local.get 8
                i32.const 1
                i32.add
                local.tee 8
                local.get 0
                i32.load
                i32.lt_s
                br_if 0 (;@6;)
              end
            end
            local.get 3
            i32.const 80
            i32.add
            call $mp_clamp
            block  ;; label = @5
              local.get 3
              i32.const 64
              i32.add
              local.get 7
              call $mp_init_size
              local.tee 4
              br_if 0 (;@5;)
              i32.const 0
              local.set 8
              block  ;; label = @6
                local.get 6
                i32.const 3
                i32.lt_s
                br_if 0 (;@6;)
                local.get 1
                i32.load offset=12
                local.set 4
                local.get 3
                i32.load offset=76
                local.set 5
                local.get 7
                local.set 8
                loop  ;; label = @7
                  local.get 5
                  local.get 4
                  i32.load
                  i32.store
                  local.get 3
                  local.get 3
                  i32.load offset=64
                  i32.const 1
                  i32.add
                  i32.store offset=64
                  local.get 4
                  i32.const 4
                  i32.add
                  local.set 4
                  local.get 5
                  i32.const 4
                  i32.add
                  local.set 5
                  local.get 8
                  i32.const -1
                  i32.add
                  local.tee 8
                  br_if 0 (;@7;)
                end
                local.get 7
                local.set 8
              end
              local.get 3
              i32.const 64
              i32.add
              call $mp_clamp
              block  ;; label = @6
                local.get 3
                i32.const 48
                i32.add
                local.get 7
                call $mp_init_size
                local.tee 4
                br_if 0 (;@6;)
                i32.const 0
                local.get 9
                i32.sub
                local.set 11
                block  ;; label = @7
                  local.get 8
                  local.get 9
                  i32.ge_s
                  br_if 0 (;@7;)
                  local.get 8
                  local.get 9
                  i32.sub
                  local.set 4
                  local.get 1
                  i32.load offset=12
                  local.get 8
                  i32.const 2
                  i32.shl
                  i32.add
                  local.set 5
                  local.get 3
                  i32.load offset=60
                  local.get 8
                  local.get 7
                  i32.sub
                  i32.const 2
                  i32.shl
                  i32.add
                  local.set 8
                  loop  ;; label = @8
                    local.get 8
                    local.get 5
                    i32.load
                    i32.store
                    local.get 3
                    local.get 3
                    i32.load offset=48
                    i32.const 1
                    i32.add
                    i32.store offset=48
                    local.get 5
                    i32.const 4
                    i32.add
                    local.set 5
                    local.get 8
                    i32.const 4
                    i32.add
                    local.set 8
                    local.get 4
                    i32.const 1
                    i32.add
                    local.tee 0
                    local.get 4
                    i32.ge_u
                    local.set 10
                    local.get 0
                    local.set 4
                    local.get 10
                    br_if 0 (;@8;)
                  end
                  local.get 9
                  local.set 8
                end
                local.get 3
                i32.const 48
                i32.add
                call $mp_clamp
                block  ;; label = @7
                  local.get 3
                  i32.const 32
                  i32.add
                  local.get 11
                  local.get 1
                  i32.load
                  i32.add
                  call $mp_init_size
                  local.tee 4
                  br_if 0 (;@7;)
                  block  ;; label = @8
                    local.get 8
                    local.get 1
                    i32.load
                    i32.ge_s
                    br_if 0 (;@8;)
                    local.get 1
                    i32.load offset=12
                    local.get 8
                    i32.const 2
                    i32.shl
                    i32.add
                    local.set 4
                    local.get 3
                    i32.load offset=44
                    local.get 8
                    local.get 9
                    i32.sub
                    i32.const 2
                    i32.shl
                    i32.add
                    local.set 5
                    loop  ;; label = @9
                      local.get 5
                      local.get 4
                      i32.load
                      i32.store
                      local.get 3
                      local.get 3
                      i32.load offset=32
                      i32.const 1
                      i32.add
                      i32.store offset=32
                      local.get 4
                      i32.const 4
                      i32.add
                      local.set 4
                      local.get 5
                      i32.const 4
                      i32.add
                      local.set 5
                      local.get 8
                      i32.const 1
                      i32.add
                      local.tee 8
                      local.get 1
                      i32.load
                      i32.lt_s
                      br_if 0 (;@9;)
                    end
                  end
                  local.get 3
                  i32.const 32
                  i32.add
                  call $mp_clamp
                  block  ;; label = @8
                    local.get 3
                    i32.const 80
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 128
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 128
                    i32.add
                    local.get 3
                    i32.const 112
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 2
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 2
                    local.get 3
                    i32.const 64
                    i32.add
                    local.get 3
                    i32.const 160
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 160
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 3
                    i32.const 160
                    i32.add
                    call $mp_mul
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 128
                    i32.add
                    local.get 3
                    i32.const 80
                    i32.add
                    local.get 3
                    i32.const 128
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 128
                    i32.add
                    local.get 3
                    i32.const 128
                    i32.add
                    call $mp_mul_2
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 128
                    i32.add
                    local.get 3
                    i32.const 112
                    i32.add
                    local.get 3
                    i32.const 128
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 2
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 2
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 2
                    local.get 2
                    call $mp_mul_2
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 2
                    local.get 3
                    i32.const 64
                    i32.add
                    local.get 2
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 128
                    i32.add
                    local.get 2
                    local.get 3
                    i32.const 144
                    i32.add
                    call $mp_mul
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 80
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 112
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 64
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    call $mp_mul
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 80
                    i32.add
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    call $mp_mul
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    i32.const 0
                    call $mp_div_3
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 160
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    call $mp_div_2
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 112
                    i32.add
                    local.get 3
                    i32.const 64
                    i32.add
                    local.get 3
                    i32.const 112
                    i32.add
                    call $mp_mul
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 160
                    i32.add
                    local.get 3
                    i32.const 112
                    i32.add
                    local.get 3
                    i32.const 160
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 3
                    i32.const 160
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    call $mp_div_2
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 160
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 160
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 160
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 160
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 128
                    i32.add
                    call $mp_mul_2
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 3
                    i32.const 128
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    call $mp_sub
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 7
                    i32.const 2
                    i32.shl
                    call $mp_lshd
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 7
                    i32.const 3
                    i32.mul
                    call $mp_lshd
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 144
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 160
                    i32.add
                    local.get 9
                    call $mp_lshd
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 160
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 7
                    call $mp_lshd
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    call $mp_add
                    local.tee 4
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 112
                    i32.add
                    local.get 2
                    call $mp_add
                    local.set 4
                  end
                  local.get 3
                  i32.const 32
                  i32.add
                  call $mp_clear
                end
                local.get 3
                i32.const 48
                i32.add
                call $mp_clear
              end
              local.get 3
              i32.const 64
              i32.add
              call $mp_clear
            end
            local.get 3
            i32.const 80
            i32.add
            call $mp_clear
          end
          local.get 3
          i32.const 96
          i32.add
          call $mp_clear
        end
        local.get 3
        i32.const 112
        i32.add
        call $mp_clear
      end
      local.get 3
      i32.const 0
      i32.store offset=8
      local.get 3
      local.get 3
      i32.const 128
      i32.add
      i32.store offset=4
      local.get 3
      local.get 3
      i32.const 144
      i32.add
      i32.store
      local.get 3
      i32.const 160
      i32.add
      local.get 3
      call $mp_clear_multi
    end
    local.get 3
    i32.const 176
    i32.add
    global.set 4
    local.get 4)
  (func $s_mp_toom_sqr (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 64
    i32.sub
    local.tee 2
    global.set 4
    block  ;; label = @1
      local.get 2
      i32.const 48
      i32.add
      call $mp_init
      local.tee 3
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 2
        i32.const 32
        i32.add
        local.get 0
        i32.load
        local.tee 4
        i32.const 3
        i32.div_s
        local.tee 5
        call $mp_init_size
        local.tee 3
        br_if 0 (;@2;)
        local.get 2
        local.get 5
        i32.store offset=32
        block  ;; label = @3
          local.get 2
          i32.const 16
          i32.add
          local.get 5
          call $mp_init_size
          local.tee 3
          br_if 0 (;@3;)
          local.get 2
          local.get 5
          i32.store offset=16
          block  ;; label = @4
            local.get 2
            local.get 0
            i32.load
            local.get 5
            i32.const 1
            i32.shl
            i32.sub
            call $mp_init_size
            local.tee 3
            br_if 0 (;@4;)
            local.get 0
            i32.load offset=12
            local.set 3
            i32.const 0
            local.set 6
            block  ;; label = @5
              local.get 4
              i32.const 3
              i32.lt_s
              br_if 0 (;@5;)
              local.get 2
              i32.load offset=44
              local.set 4
              local.get 5
              local.set 6
              loop  ;; label = @6
                local.get 4
                local.get 3
                i32.load
                i32.store
                local.get 4
                i32.const 4
                i32.add
                local.set 4
                local.get 3
                i32.const 4
                i32.add
                local.set 3
                local.get 6
                i32.const -1
                i32.add
                local.tee 6
                br_if 0 (;@6;)
              end
              local.get 5
              local.set 6
            end
            block  ;; label = @5
              local.get 6
              local.get 5
              i32.const 1
              i32.shl
              local.tee 7
              i32.ge_s
              br_if 0 (;@5;)
              local.get 6
              local.get 7
              i32.sub
              local.set 4
              local.get 2
              i32.load offset=28
              local.set 6
              loop  ;; label = @6
                local.get 6
                local.get 3
                i32.load
                i32.store
                local.get 6
                i32.const 4
                i32.add
                local.set 6
                local.get 3
                i32.const 4
                i32.add
                local.set 3
                local.get 4
                i32.const 1
                i32.add
                local.tee 8
                local.get 4
                i32.ge_u
                local.set 9
                local.get 8
                local.set 4
                local.get 9
                br_if 0 (;@6;)
              end
              local.get 7
              local.set 6
            end
            block  ;; label = @5
              local.get 6
              local.get 0
              i32.load
              i32.ge_s
              br_if 0 (;@5;)
              local.get 2
              i32.load offset=12
              local.set 4
              loop  ;; label = @6
                local.get 4
                local.get 3
                i32.load
                i32.store
                local.get 2
                local.get 2
                i32.load
                i32.const 1
                i32.add
                i32.store
                local.get 4
                i32.const 4
                i32.add
                local.set 4
                local.get 3
                i32.const 4
                i32.add
                local.set 3
                local.get 6
                i32.const 1
                i32.add
                local.tee 6
                local.get 0
                i32.load
                i32.lt_s
                br_if 0 (;@6;)
              end
            end
            local.get 2
            i32.const 32
            i32.add
            call $mp_clamp
            local.get 2
            i32.const 16
            i32.add
            call $mp_clamp
            local.get 2
            call $mp_clamp
            block  ;; label = @5
              local.get 2
              i32.const 32
              i32.add
              local.get 2
              i32.const 48
              i32.add
              call $mp_sqr
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 32
              i32.add
              local.get 2
              local.get 2
              i32.const 32
              i32.add
              call $mp_add
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 32
              i32.add
              local.get 2
              i32.const 16
              i32.add
              local.get 1
              call $mp_sub
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 32
              i32.add
              local.get 2
              i32.const 16
              i32.add
              local.get 2
              i32.const 32
              i32.add
              call $mp_add
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 32
              i32.add
              local.get 2
              i32.const 32
              i32.add
              call $mp_sqr
              local.tee 3
              br_if 0 (;@5;)
              local.get 1
              local.get 1
              call $mp_sqr
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 16
              i32.add
              local.get 2
              local.get 2
              i32.const 16
              i32.add
              call $mp_mul
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 16
              i32.add
              local.get 2
              i32.const 16
              i32.add
              call $mp_mul_2
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              local.get 2
              call $mp_sqr
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 32
              i32.add
              local.get 1
              local.get 1
              call $mp_add
              local.tee 3
              br_if 0 (;@5;)
              local.get 1
              local.get 1
              call $mp_div_2
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 32
              i32.add
              local.get 1
              local.get 2
              i32.const 32
              i32.add
              call $mp_sub
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 32
              i32.add
              local.get 2
              i32.const 16
              i32.add
              local.get 2
              i32.const 32
              i32.add
              call $mp_sub
              local.tee 3
              br_if 0 (;@5;)
              local.get 1
              local.get 2
              local.get 1
              call $mp_sub
              local.tee 3
              br_if 0 (;@5;)
              local.get 1
              local.get 2
              i32.const 48
              i32.add
              local.get 1
              call $mp_sub
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              local.get 5
              i32.const 2
              i32.shl
              call $mp_lshd
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 16
              i32.add
              local.get 5
              i32.const 3
              i32.mul
              call $mp_lshd
              local.tee 3
              br_if 0 (;@5;)
              local.get 1
              local.get 7
              call $mp_lshd
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              i32.const 32
              i32.add
              local.get 5
              call $mp_lshd
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              local.get 2
              i32.const 16
              i32.add
              local.get 2
              call $mp_add
              local.tee 3
              br_if 0 (;@5;)
              local.get 2
              local.get 1
              local.get 1
              call $mp_add
              local.tee 3
              br_if 0 (;@5;)
              local.get 1
              local.get 2
              i32.const 32
              i32.add
              local.get 1
              call $mp_add
              local.tee 3
              br_if 0 (;@5;)
              local.get 1
              local.get 2
              i32.const 48
              i32.add
              local.get 1
              call $mp_add
              local.set 3
            end
            local.get 2
            call $mp_clear
          end
          local.get 2
          i32.const 16
          i32.add
          call $mp_clear
        end
        local.get 2
        i32.const 32
        i32.add
        call $mp_clear
      end
      local.get 2
      i32.const 48
      i32.add
      call $mp_clear
    end
    local.get 2
    i32.const 64
    i32.add
    global.set 4
    local.get 3)
  (func $s_mp_karatsuba_sqr (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 96
    i32.sub
    local.tee 2
    global.set 4
    i32.const -2
    local.set 3
    block  ;; label = @1
      local.get 2
      i32.const 80
      i32.add
      local.get 0
      i32.load
      local.tee 4
      i32.const 1
      i32.shr_s
      local.tee 5
      call $mp_init_size
      br_if 0 (;@1;)
      i32.const -2
      local.set 3
      block  ;; label = @2
        local.get 2
        i32.const 64
        i32.add
        local.get 0
        i32.load
        local.get 5
        i32.sub
        call $mp_init_size
        br_if 0 (;@2;)
        i32.const -2
        local.set 3
        block  ;; label = @3
          local.get 2
          i32.const 48
          i32.add
          local.get 0
          i32.load
          i32.const 1
          i32.shl
          call $mp_init_size
          br_if 0 (;@3;)
          i32.const -2
          local.set 3
          block  ;; label = @4
            local.get 2
            i32.const 32
            i32.add
            local.get 0
            i32.load
            i32.const 1
            i32.shl
            call $mp_init_size
            br_if 0 (;@4;)
            i32.const -2
            local.set 3
            block  ;; label = @5
              local.get 2
              i32.const 16
              i32.add
              local.get 4
              i32.const -2
              i32.and
              local.tee 6
              call $mp_init_size
              br_if 0 (;@5;)
              i32.const -2
              local.set 3
              block  ;; label = @6
                local.get 2
                local.get 0
                i32.load
                local.get 5
                i32.sub
                i32.const 1
                i32.shl
                call $mp_init_size
                br_if 0 (;@6;)
                local.get 0
                i32.load offset=12
                local.set 3
                block  ;; label = @7
                  local.get 4
                  i32.const 2
                  i32.lt_s
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 7
                  local.get 2
                  i32.load offset=92
                  local.set 4
                  loop  ;; label = @8
                    local.get 4
                    local.get 3
                    i32.load
                    i32.store
                    local.get 4
                    i32.const 4
                    i32.add
                    local.set 4
                    local.get 3
                    i32.const 4
                    i32.add
                    local.set 3
                    local.get 7
                    i32.const 1
                    i32.add
                    local.tee 7
                    local.get 5
                    i32.lt_s
                    br_if 0 (;@8;)
                  end
                end
                block  ;; label = @7
                  local.get 5
                  local.get 0
                  i32.load
                  local.tee 8
                  i32.ge_s
                  br_if 0 (;@7;)
                  local.get 2
                  i32.load offset=76
                  local.set 4
                  local.get 5
                  local.set 7
                  loop  ;; label = @8
                    local.get 4
                    local.get 3
                    i32.load
                    i32.store
                    local.get 4
                    i32.const 4
                    i32.add
                    local.set 4
                    local.get 3
                    i32.const 4
                    i32.add
                    local.set 3
                    local.get 7
                    i32.const 1
                    i32.add
                    local.tee 7
                    local.get 0
                    i32.load
                    local.tee 8
                    i32.lt_s
                    br_if 0 (;@8;)
                  end
                end
                local.get 2
                local.get 5
                i32.store offset=80
                local.get 2
                local.get 8
                local.get 5
                i32.sub
                i32.store offset=64
                local.get 2
                i32.const 80
                i32.add
                call $mp_clamp
                i32.const -2
                local.set 3
                block  ;; label = @7
                  local.get 2
                  i32.const 80
                  i32.add
                  local.get 2
                  i32.const 16
                  i32.add
                  call $mp_sqr
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 64
                  i32.add
                  local.get 2
                  call $mp_sqr
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 64
                  i32.add
                  local.get 2
                  i32.const 80
                  i32.add
                  local.get 2
                  i32.const 48
                  i32.add
                  call $s_mp_add
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 2
                  i32.const 48
                  i32.add
                  call $mp_sqr
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 16
                  i32.add
                  local.get 2
                  local.get 2
                  i32.const 32
                  i32.add
                  call $s_mp_add
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 2
                  i32.const 32
                  i32.add
                  local.get 2
                  i32.const 48
                  i32.add
                  call $s_mp_sub
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 5
                  call $mp_lshd
                  br_if 0 (;@7;)
                  local.get 2
                  local.get 6
                  call $mp_lshd
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 16
                  i32.add
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 2
                  i32.const 48
                  i32.add
                  call $mp_add
                  br_if 0 (;@7;)
                  i32.const -2
                  i32.const 0
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 2
                  local.get 1
                  call $mp_add
                  select
                  local.set 3
                end
                local.get 2
                call $mp_clear
              end
              local.get 2
              i32.const 16
              i32.add
              call $mp_clear
            end
            local.get 2
            i32.const 32
            i32.add
            call $mp_clear
          end
          local.get 2
          i32.const 48
          i32.add
          call $mp_clear
        end
        local.get 2
        i32.const 64
        i32.add
        call $mp_clear
      end
      local.get 2
      i32.const 80
      i32.add
      call $mp_clear
    end
    local.get 2
    i32.const 96
    i32.add
    global.set 4
    local.get 3)
  (func $s_mp_sqr_fast (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i32 i64)
    global.get 4
    i32.const 2048
    i32.sub
    local.tee 2
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 3
        i32.const 1
        i32.shl
        local.tee 4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 1
        local.get 4
        call $mp_grow
        local.tee 5
        br_if 1 (;@1;)
      end
      i32.const 0
      local.set 6
      local.get 0
      i32.load
      local.set 7
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const 0
          i32.gt_s
          br_if 0 (;@3;)
          local.get 1
          i32.load
          local.set 8
          local.get 1
          local.get 7
          i32.const 1
          i32.shl
          i32.store
          local.get 1
          i32.load offset=12
          local.set 0
          br 1 (;@2;)
        end
        local.get 7
        i32.const -1
        i32.add
        local.set 9
        local.get 0
        i32.load offset=12
        local.set 10
        i64.const 0
        local.set 11
        i32.const 0
        local.set 12
        loop  ;; label = @3
          i64.const 0
          local.set 13
          block  ;; label = @4
            local.get 12
            local.get 9
            local.get 7
            local.get 12
            i32.gt_s
            select
            local.tee 5
            i32.const 1
            i32.add
            local.tee 6
            local.get 7
            local.get 12
            local.get 5
            i32.sub
            local.tee 0
            i32.sub
            local.tee 8
            local.get 8
            local.get 5
            i32.gt_s
            select
            local.tee 8
            local.get 6
            local.get 0
            i32.sub
            i32.const 1
            i32.shr_s
            local.tee 6
            local.get 8
            local.get 6
            i32.lt_s
            select
            local.tee 8
            i32.const 1
            i32.lt_s
            br_if 0 (;@4;)
            local.get 10
            local.get 0
            i32.const 2
            i32.shl
            i32.add
            local.set 0
            local.get 10
            local.get 5
            i32.const 2
            i32.shl
            i32.add
            local.set 5
            i32.const 0
            local.set 6
            i64.const 0
            local.set 13
            loop  ;; label = @5
              local.get 5
              i64.load32_u
              local.get 0
              i64.load32_u
              i64.mul
              local.get 13
              i64.add
              local.set 13
              local.get 5
              i32.const -4
              i32.add
              local.set 5
              local.get 0
              i32.const 4
              i32.add
              local.set 0
              local.get 6
              i32.const 1
              i32.add
              local.tee 6
              local.get 8
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          local.get 13
          i64.const 1
          i64.shl
          local.get 11
          i64.add
          local.set 13
          block  ;; label = @4
            local.get 12
            i32.const 1
            i32.and
            br_if 0 (;@4;)
            local.get 10
            local.get 12
            i32.const 1
            i32.shl
            i32.const -4
            i32.and
            i32.add
            i64.load32_u
            local.tee 11
            local.get 11
            i64.mul
            local.get 13
            i64.add
            local.set 13
          end
          local.get 2
          local.get 12
          i32.const 2
          i32.shl
          i32.add
          local.get 13
          i32.wrap_i64
          i32.const 268435455
          i32.and
          i32.store
          local.get 13
          i64.const 28
          i64.shr_u
          local.set 11
          local.get 12
          i32.const 1
          i32.add
          local.tee 12
          local.get 4
          i32.lt_s
          br_if 0 (;@3;)
        end
        local.get 1
        i32.load
        local.set 8
        local.get 1
        local.get 7
        i32.const 1
        i32.shl
        i32.store
        local.get 1
        i32.load offset=12
        local.set 0
        i32.const 0
        local.set 6
        local.get 3
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 2
        local.set 5
        loop  ;; label = @3
          local.get 0
          local.get 5
          i32.load
          i32.const 268435455
          i32.and
          i32.store
          local.get 5
          i32.const 4
          i32.add
          local.set 5
          local.get 0
          i32.const 4
          i32.add
          local.set 0
          local.get 6
          i32.const 1
          i32.add
          local.tee 6
          local.get 4
          i32.lt_s
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 8
        local.get 6
        i32.sub
        local.tee 5
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 5
        i32.const 1
        i32.add
        local.set 5
        loop  ;; label = @3
          local.get 0
          i32.const 0
          i32.store
          local.get 0
          i32.const 4
          i32.add
          local.set 0
          local.get 5
          i32.const -1
          i32.add
          local.tee 5
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 1
      call $mp_clamp
      i32.const 0
      local.set 5
    end
    local.get 2
    i32.const 2048
    i32.add
    global.set 4
    local.get 5)
  (func $s_mp_sqr (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i64)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 2
    global.set 4
    block  ;; label = @1
      local.get 2
      local.get 0
      i32.load
      local.tee 3
      i32.const 1
      i32.shl
      i32.const 1
      i32.or
      local.tee 4
      call $mp_init_size
      local.tee 5
      br_if 0 (;@1;)
      local.get 2
      local.get 4
      i32.store
      block  ;; label = @2
        local.get 3
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 3
        i32.const -1
        i32.add
        local.set 6
        local.get 0
        i32.load offset=12
        local.tee 7
        i32.const 4
        i32.add
        local.set 8
        i32.const 0
        local.set 9
        local.get 2
        i32.load offset=12
        local.set 10
        loop  ;; label = @3
          local.get 10
          local.get 9
          i32.const 3
          i32.shl
          local.tee 5
          i32.add
          local.tee 0
          local.get 7
          local.get 9
          i32.const 2
          i32.shl
          i32.add
          local.tee 4
          i64.load32_u
          local.tee 11
          local.get 11
          i64.mul
          local.get 0
          i64.load32_u
          i64.add
          local.tee 11
          i32.wrap_i64
          i32.const 268435455
          i32.and
          i32.store
          local.get 11
          i64.const 28
          i64.shr_u
          local.set 11
          local.get 10
          local.get 5
          i32.const 4
          i32.or
          i32.add
          local.set 5
          block  ;; label = @4
            local.get 9
            i32.const 1
            i32.add
            local.tee 9
            local.get 3
            i32.ge_s
            br_if 0 (;@4;)
            local.get 4
            i64.load32_u
            i64.const 1
            i64.shl
            local.set 12
            local.get 8
            local.set 0
            local.get 6
            local.set 4
            loop  ;; label = @5
              local.get 5
              local.get 11
              i64.const 4294967295
              i64.and
              local.get 5
              i64.load32_u
              i64.add
              local.get 12
              local.get 0
              i64.load32_u
              i64.mul
              i64.add
              local.tee 11
              i32.wrap_i64
              i32.const 268435455
              i32.and
              i32.store
              local.get 11
              i64.const 28
              i64.shr_u
              local.set 11
              local.get 0
              i32.const 4
              i32.add
              local.set 0
              local.get 5
              i32.const 4
              i32.add
              local.set 5
              local.get 4
              i32.const -1
              i32.add
              local.tee 4
              br_if 0 (;@5;)
            end
          end
          block  ;; label = @4
            local.get 11
            i32.wrap_i64
            i32.eqz
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 5
              local.get 11
              i64.const 4294967295
              i64.and
              local.get 5
              i64.load32_u
              i64.add
              local.tee 11
              i32.wrap_i64
              i32.const 268435455
              i32.and
              i32.store
              local.get 5
              i32.const 4
              i32.add
              local.set 5
              local.get 11
              i64.const 28
              i64.shr_u
              local.tee 11
              i64.eqz
              i32.eqz
              br_if 0 (;@5;)
            end
          end
          local.get 8
          i32.const 4
          i32.add
          local.set 8
          local.get 6
          i32.const -1
          i32.add
          local.set 6
          local.get 9
          local.get 3
          i32.ne
          br_if 0 (;@3;)
        end
      end
      local.get 2
      call $mp_clamp
      local.get 2
      local.get 1
      call $mp_exch
      local.get 2
      call $mp_clear
      i32.const 0
      local.set 5
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 4
    local.get 5)
  (func $s_mp_karatsuba_mul (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 112
    i32.sub
    local.tee 3
    global.set 4
    i32.const -2
    local.set 4
    block  ;; label = @1
      local.get 3
      i32.const 96
      i32.add
      local.get 0
      i32.load
      local.tee 5
      local.get 1
      i32.load
      local.tee 6
      local.get 5
      local.get 6
      i32.lt_s
      select
      local.tee 6
      i32.const 1
      i32.shr_s
      local.tee 5
      call $mp_init_size
      br_if 0 (;@1;)
      i32.const -2
      local.set 4
      block  ;; label = @2
        local.get 3
        i32.const 80
        i32.add
        local.get 0
        i32.load
        local.get 5
        i32.sub
        call $mp_init_size
        br_if 0 (;@2;)
        i32.const -2
        local.set 4
        block  ;; label = @3
          local.get 3
          i32.const 64
          i32.add
          local.get 5
          call $mp_init_size
          br_if 0 (;@3;)
          i32.const -2
          local.set 4
          block  ;; label = @4
            local.get 3
            i32.const 48
            i32.add
            local.get 1
            i32.load
            local.get 5
            i32.sub
            call $mp_init_size
            br_if 0 (;@4;)
            i32.const -2
            local.set 4
            block  ;; label = @5
              local.get 3
              i32.const 32
              i32.add
              local.get 6
              i32.const -2
              i32.and
              local.tee 7
              call $mp_init_size
              br_if 0 (;@5;)
              i32.const -2
              local.set 4
              block  ;; label = @6
                local.get 3
                i32.const 16
                i32.add
                local.get 7
                call $mp_init_size
                br_if 0 (;@6;)
                i32.const -2
                local.set 4
                block  ;; label = @7
                  local.get 3
                  local.get 7
                  call $mp_init_size
                  br_if 0 (;@7;)
                  local.get 3
                  local.get 5
                  i32.store offset=96
                  local.get 3
                  local.get 5
                  i32.store offset=64
                  local.get 3
                  local.get 0
                  i32.load
                  local.tee 8
                  local.get 5
                  i32.sub
                  i32.store offset=80
                  local.get 3
                  local.get 1
                  i32.load
                  local.get 5
                  i32.sub
                  i32.store offset=48
                  local.get 1
                  i32.load offset=12
                  local.set 4
                  local.get 0
                  i32.load offset=12
                  local.set 9
                  block  ;; label = @8
                    local.get 6
                    i32.const 2
                    i32.lt_s
                    br_if 0 (;@8;)
                    i32.const 0
                    local.set 10
                    local.get 3
                    i32.load offset=108
                    local.set 6
                    local.get 3
                    i32.load offset=76
                    local.set 8
                    loop  ;; label = @9
                      local.get 6
                      local.get 9
                      i32.load
                      i32.store
                      local.get 8
                      local.get 4
                      i32.load
                      i32.store
                      local.get 8
                      i32.const 4
                      i32.add
                      local.set 8
                      local.get 4
                      i32.const 4
                      i32.add
                      local.set 4
                      local.get 6
                      i32.const 4
                      i32.add
                      local.set 6
                      local.get 9
                      i32.const 4
                      i32.add
                      local.set 9
                      local.get 10
                      i32.const 1
                      i32.add
                      local.tee 10
                      local.get 5
                      i32.lt_s
                      br_if 0 (;@9;)
                    end
                    local.get 0
                    i32.load
                    local.set 8
                  end
                  block  ;; label = @8
                    local.get 5
                    local.get 8
                    i32.ge_s
                    br_if 0 (;@8;)
                    local.get 3
                    i32.load offset=92
                    local.set 6
                    local.get 5
                    local.set 8
                    loop  ;; label = @9
                      local.get 6
                      local.get 9
                      i32.load
                      i32.store
                      local.get 6
                      i32.const 4
                      i32.add
                      local.set 6
                      local.get 9
                      i32.const 4
                      i32.add
                      local.set 9
                      local.get 8
                      i32.const 1
                      i32.add
                      local.tee 8
                      local.get 0
                      i32.load
                      i32.lt_s
                      br_if 0 (;@9;)
                    end
                  end
                  block  ;; label = @8
                    local.get 5
                    local.get 1
                    i32.load
                    i32.ge_s
                    br_if 0 (;@8;)
                    local.get 3
                    i32.load offset=60
                    local.set 0
                    local.get 5
                    local.set 6
                    loop  ;; label = @9
                      local.get 0
                      local.get 4
                      i32.load
                      i32.store
                      local.get 0
                      i32.const 4
                      i32.add
                      local.set 0
                      local.get 4
                      i32.const 4
                      i32.add
                      local.set 4
                      local.get 6
                      i32.const 1
                      i32.add
                      local.tee 6
                      local.get 1
                      i32.load
                      i32.lt_s
                      br_if 0 (;@9;)
                    end
                  end
                  local.get 3
                  i32.const 96
                  i32.add
                  call $mp_clamp
                  local.get 3
                  i32.const 64
                  i32.add
                  call $mp_clamp
                  i32.const -2
                  local.set 4
                  block  ;; label = @8
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 64
                    i32.add
                    local.get 3
                    i32.const 16
                    i32.add
                    call $mp_mul
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 80
                    i32.add
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    call $mp_mul
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 80
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 32
                    i32.add
                    call $s_mp_add
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 48
                    i32.add
                    local.get 3
                    i32.const 64
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    call $s_mp_add
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 32
                    i32.add
                    call $mp_mul
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 16
                    i32.add
                    local.get 3
                    local.get 3
                    i32.const 96
                    i32.add
                    call $mp_add
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 3
                    i32.const 96
                    i32.add
                    local.get 3
                    i32.const 32
                    i32.add
                    call $s_mp_sub
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 5
                    call $mp_lshd
                    br_if 0 (;@8;)
                    local.get 3
                    local.get 7
                    call $mp_lshd
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 16
                    i32.add
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 3
                    i32.const 32
                    i32.add
                    call $mp_add
                    br_if 0 (;@8;)
                    i32.const -2
                    i32.const 0
                    local.get 3
                    i32.const 32
                    i32.add
                    local.get 3
                    local.get 2
                    call $mp_add
                    select
                    local.set 4
                  end
                  local.get 3
                  call $mp_clear
                end
                local.get 3
                i32.const 16
                i32.add
                call $mp_clear
              end
              local.get 3
              i32.const 32
              i32.add
              call $mp_clear
            end
            local.get 3
            i32.const 48
            i32.add
            call $mp_clear
          end
          local.get 3
          i32.const 64
          i32.add
          call $mp_clear
        end
        local.get 3
        i32.const 80
        i32.add
        call $mp_clear
      end
      local.get 3
      i32.const 96
      i32.add
      call $mp_clear
    end
    local.get 3
    i32.const 112
    i32.add
    global.set 4
    local.get 4)
  (func $s_mp_mul_digs_fast (type 33) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i64)
    global.get 4
    i32.const 2048
    i32.sub
    local.tee 4
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=4
        local.get 3
        i32.ge_s
        br_if 0 (;@2;)
        local.get 2
        local.get 3
        call $mp_grow
        local.tee 5
        br_if 1 (;@1;)
      end
      i32.const 0
      local.set 6
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          local.get 1
          i32.load
          local.tee 7
          local.get 0
          i32.load
          local.tee 8
          i32.add
          local.tee 5
          local.get 5
          local.get 3
          i32.gt_s
          select
          local.tee 9
          i32.const 0
          i32.gt_s
          br_if 0 (;@3;)
          local.get 2
          i32.load
          local.set 0
          local.get 2
          local.get 9
          i32.store
          local.get 2
          i32.load offset=12
          local.set 3
          br 1 (;@2;)
        end
        local.get 7
        i32.const -1
        i32.add
        local.set 10
        local.get 1
        i32.load offset=12
        local.set 11
        local.get 0
        i32.load offset=12
        local.set 12
        i64.const 0
        local.set 13
        i32.const 0
        local.set 0
        loop  ;; label = @3
          block  ;; label = @4
            local.get 0
            local.get 10
            local.get 7
            local.get 0
            i32.gt_s
            select
            local.tee 5
            i32.const 1
            i32.add
            local.get 8
            local.get 0
            local.get 5
            i32.sub
            local.tee 1
            i32.sub
            local.tee 3
            local.get 3
            local.get 5
            i32.gt_s
            select
            local.tee 6
            i32.const 1
            i32.lt_s
            br_if 0 (;@4;)
            local.get 12
            local.get 1
            i32.const 2
            i32.shl
            i32.add
            local.set 3
            local.get 11
            local.get 5
            i32.const 2
            i32.shl
            i32.add
            local.set 5
            loop  ;; label = @5
              local.get 5
              i64.load32_u
              local.get 3
              i64.load32_u
              i64.mul
              local.get 13
              i64.add
              local.set 13
              local.get 5
              i32.const -4
              i32.add
              local.set 5
              local.get 3
              i32.const 4
              i32.add
              local.set 3
              local.get 6
              i32.const -1
              i32.add
              local.tee 6
              br_if 0 (;@5;)
            end
          end
          local.get 4
          local.get 0
          i32.const 2
          i32.shl
          i32.add
          local.get 13
          i32.wrap_i64
          i32.const 268435455
          i32.and
          i32.store
          local.get 13
          i64.const 28
          i64.shr_u
          local.set 13
          local.get 0
          i32.const 1
          i32.add
          local.tee 0
          local.get 9
          i32.lt_s
          br_if 0 (;@3;)
        end
        local.get 2
        i32.load
        local.set 0
        local.get 2
        local.get 9
        i32.store
        local.get 2
        i32.load offset=12
        local.set 3
        i32.const 0
        local.set 6
        local.get 9
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 4
        local.set 5
        loop  ;; label = @3
          local.get 3
          local.get 5
          i32.load
          i32.store
          local.get 5
          i32.const 4
          i32.add
          local.set 5
          local.get 3
          i32.const 4
          i32.add
          local.set 3
          local.get 6
          i32.const 1
          i32.add
          local.tee 6
          local.get 9
          i32.lt_s
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 0
        local.get 6
        i32.sub
        local.tee 5
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 5
        i32.const 1
        i32.add
        local.set 5
        loop  ;; label = @3
          local.get 3
          i32.const 0
          i32.store
          local.get 3
          i32.const 4
          i32.add
          local.set 3
          local.get 5
          i32.const -1
          i32.add
          local.tee 5
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 2
      call $mp_clamp
      i32.const 0
      local.set 5
    end
    local.get 4
    i32.const 2048
    i32.add
    global.set 4
    local.get 5)
  (func $s_mp_mul_digs (type 33) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i64)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 4
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.const 511
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        i32.load
        local.tee 5
        local.get 1
        i32.load
        local.tee 6
        local.get 5
        local.get 6
        i32.lt_s
        select
        i32.const 255
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 1
        local.get 2
        local.get 3
        call $s_mp_mul_digs_fast
        local.set 5
        br 1 (;@1;)
      end
      local.get 4
      local.get 3
      call $mp_init_size
      local.tee 5
      br_if 0 (;@1;)
      local.get 4
      local.get 3
      i32.store
      block  ;; label = @2
        local.get 0
        i32.load
        local.tee 7
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 1
        i32.load offset=12
        local.set 8
        local.get 0
        i32.load offset=12
        local.set 9
        i32.const 0
        local.set 10
        local.get 4
        i32.load offset=12
        local.set 11
        local.get 3
        local.set 12
        loop  ;; label = @3
          local.get 11
          local.get 10
          i32.const 2
          i32.shl
          local.tee 6
          i32.add
          local.set 5
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.load
              local.tee 13
              local.get 3
              local.get 10
              i32.sub
              local.tee 0
              local.get 13
              local.get 0
              i32.lt_s
              select
              local.tee 14
              i32.const 1
              i32.ge_s
              br_if 0 (;@5;)
              i32.const 0
              local.set 0
              i32.const 0
              local.set 6
              br 1 (;@4;)
            end
            local.get 9
            local.get 6
            i32.add
            i64.load32_u
            local.set 15
            i32.const 0
            local.set 6
            i64.const 0
            local.set 16
            local.get 8
            local.set 0
            loop  ;; label = @5
              local.get 5
              local.get 16
              i64.const 4294967295
              i64.and
              local.get 5
              i64.load32_u
              i64.add
              local.get 0
              i64.load32_u
              local.get 15
              i64.mul
              i64.add
              local.tee 16
              i32.wrap_i64
              i32.const 268435455
              i32.and
              i32.store
              local.get 16
              i64.const 28
              i64.shr_u
              local.set 16
              local.get 5
              i32.const 4
              i32.add
              local.set 5
              local.get 0
              i32.const 4
              i32.add
              local.set 0
              local.get 6
              i32.const 1
              i32.add
              local.tee 6
              local.get 14
              i32.lt_s
              br_if 0 (;@5;)
            end
            local.get 13
            local.get 12
            local.get 13
            local.get 12
            i32.lt_s
            select
            local.set 0
            local.get 16
            i32.wrap_i64
            local.set 6
          end
          block  ;; label = @4
            local.get 0
            local.get 10
            i32.add
            local.get 3
            i32.ge_s
            br_if 0 (;@4;)
            local.get 5
            local.get 6
            i32.store
          end
          local.get 12
          i32.const -1
          i32.add
          local.set 12
          local.get 10
          i32.const 1
          i32.add
          local.tee 10
          local.get 7
          i32.ne
          br_if 0 (;@3;)
        end
      end
      local.get 4
      call $mp_clamp
      local.get 4
      local.get 2
      call $mp_exch
      local.get 4
      call $mp_clear
      i32.const 0
      local.set 5
    end
    local.get 4
    i32.const 16
    i32.add
    global.set 4
    local.get 5)
  (func $mp_init_multi (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 2
    global.set 4
    local.get 2
    local.get 1
    i32.store offset=12
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        local.set 3
        local.get 0
        local.set 4
        loop  ;; label = @3
          block  ;; label = @4
            local.get 4
            call $mp_init
            i32.eqz
            br_if 0 (;@4;)
            local.get 2
            local.get 1
            i32.store offset=8
            block  ;; label = @5
              local.get 3
              i32.eqz
              br_if 0 (;@5;)
              loop  ;; label = @6
                local.get 0
                call $mp_clear
                local.get 2
                local.get 2
                i32.load offset=8
                local.tee 4
                i32.const 4
                i32.add
                i32.store offset=8
                local.get 3
                i32.const 1
                i32.add
                local.tee 1
                local.get 3
                i32.ge_u
                local.set 5
                local.get 4
                i32.load
                local.set 0
                local.get 1
                local.set 3
                local.get 5
                br_if 0 (;@6;)
              end
            end
            i32.const -2
            local.set 3
            br 3 (;@1;)
          end
          local.get 2
          local.get 2
          i32.load offset=12
          local.tee 4
          i32.const 4
          i32.add
          i32.store offset=12
          local.get 3
          i32.const -1
          i32.add
          local.set 3
          local.get 4
          i32.load
          local.tee 4
          br_if 0 (;@3;)
        end
      end
      i32.const 0
      local.set 3
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 4
    local.get 3)
  (func $mp_clear_multi (type 20) (param i32 i32)
    (local i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 2
    global.set 4
    local.get 2
    local.get 1
    i32.store offset=12
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 0
        call $mp_clear
        local.get 2
        local.get 2
        i32.load offset=12
        local.tee 0
        i32.const 4
        i32.add
        i32.store offset=12
        local.get 0
        i32.load
        local.tee 0
        br_if 0 (;@2;)
      end
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 4)
  (func $mp_mul_2 (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 2
        i32.gt_s
        br_if 0 (;@2;)
        local.get 1
        local.get 2
        i32.const 1
        i32.add
        call $mp_grow
        local.tee 2
        br_if 1 (;@1;)
        local.get 0
        i32.load
        local.set 2
      end
      local.get 1
      i32.load
      local.set 3
      local.get 1
      local.get 2
      i32.store
      local.get 1
      i32.load offset=12
      local.set 4
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load
            i32.const 1
            i32.lt_s
            br_if 0 (;@4;)
            local.get 0
            i32.load offset=12
            local.set 5
            i32.const 0
            local.set 6
            local.get 4
            local.set 2
            i32.const 0
            local.set 7
            loop  ;; label = @5
              local.get 2
              local.get 5
              i32.load
              local.tee 8
              i32.const 1
              i32.shl
              i32.const 268435454
              i32.and
              local.get 6
              i32.or
              i32.store
              local.get 2
              i32.const 4
              i32.add
              local.set 2
              local.get 5
              i32.const 4
              i32.add
              local.set 5
              local.get 8
              i32.const 27
              i32.shr_u
              local.set 6
              local.get 7
              i32.const 1
              i32.add
              local.tee 7
              local.get 0
              i32.load
              i32.lt_s
              br_if 0 (;@5;)
            end
            local.get 6
            br_if 1 (;@3;)
          end
          local.get 1
          i32.load
          local.set 2
          br 1 (;@2;)
        end
        local.get 2
        i32.const 1
        i32.store
        local.get 1
        local.get 1
        i32.load
        i32.const 1
        i32.add
        local.tee 2
        i32.store
      end
      block  ;; label = @2
        local.get 3
        local.get 2
        i32.sub
        local.tee 5
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 5
        i32.const 1
        i32.add
        local.set 5
        local.get 4
        local.get 2
        i32.const 2
        i32.shl
        i32.add
        local.set 2
        loop  ;; label = @3
          local.get 2
          i32.const 0
          i32.store
          local.get 2
          i32.const 4
          i32.add
          local.set 2
          local.get 5
          i32.const -1
          i32.add
          local.tee 5
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 1
      local.get 0
      i32.load offset=8
      i32.store offset=8
      i32.const 0
      local.set 2
    end
    local.get 2)
  (func $mp_div_2 (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 2
        i32.ge_s
        br_if 0 (;@2;)
        local.get 1
        local.get 2
        call $mp_grow
        local.tee 2
        br_if 1 (;@1;)
        local.get 0
        i32.load
        local.set 2
      end
      local.get 1
      i32.load
      local.set 3
      local.get 1
      local.get 2
      i32.store
      local.get 1
      i32.load offset=12
      local.set 4
      block  ;; label = @2
        local.get 2
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 2
        i32.const 1
        i32.add
        local.set 5
        local.get 4
        local.get 2
        i32.const 2
        i32.shl
        i32.const -4
        i32.add
        local.tee 6
        i32.add
        local.set 2
        local.get 0
        i32.load offset=12
        local.get 6
        i32.add
        local.set 6
        i32.const 0
        local.set 7
        loop  ;; label = @3
          local.get 2
          local.get 6
          i32.load
          local.tee 8
          i32.const 1
          i32.shr_u
          local.get 7
          i32.const 27
          i32.shl
          i32.or
          i32.store
          local.get 2
          i32.const -4
          i32.add
          local.set 2
          local.get 6
          i32.const -4
          i32.add
          local.set 6
          local.get 8
          i32.const 1
          i32.and
          local.set 7
          local.get 5
          i32.const -1
          i32.add
          local.tee 5
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
        local.get 1
        i32.load
        local.set 2
      end
      block  ;; label = @2
        local.get 3
        local.get 2
        i32.sub
        local.tee 6
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 6
        i32.const 1
        i32.add
        local.set 6
        local.get 4
        local.get 2
        i32.const 2
        i32.shl
        i32.add
        local.set 2
        loop  ;; label = @3
          local.get 2
          i32.const 0
          i32.store
          local.get 2
          i32.const 4
          i32.add
          local.set 2
          local.get 6
          i32.const -1
          i32.add
          local.tee 6
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 1
      local.get 0
      i32.load offset=8
      i32.store offset=8
      local.get 1
      call $mp_clamp
      i32.const 0
      local.set 2
    end
    local.get 2)
  (func $mp_div_3 (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i64 i32 i64 i64 i64)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 3
    global.set 4
    block  ;; label = @1
      local.get 3
      local.get 0
      i32.load
      call $mp_init_size
      local.tee 4
      br_if 0 (;@1;)
      local.get 3
      local.get 0
      i32.load
      local.tee 5
      i32.store
      local.get 3
      local.get 0
      i32.load offset=8
      i32.store offset=8
      block  ;; label = @2
        block  ;; label = @3
          local.get 5
          i32.const 1
          i32.ge_s
          br_if 0 (;@3;)
          i64.const 0
          local.set 6
          br 1 (;@2;)
        end
        local.get 5
        i32.const 1
        i32.add
        local.set 7
        local.get 0
        i32.load offset=12
        local.get 5
        i32.const 2
        i32.shl
        i32.const -4
        i32.add
        local.tee 5
        i32.add
        local.set 0
        local.get 3
        i32.load offset=12
        local.get 5
        i32.add
        local.set 5
        i64.const 0
        local.set 6
        loop  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 6
              i64.const 28
              i64.shl
              local.get 0
              i64.load32_u
              i64.or
              local.tee 8
              i64.const 3
              i64.ge_u
              br_if 0 (;@5;)
              i64.const 0
              local.set 9
              local.get 8
              local.set 6
              br 1 (;@4;)
            end
            local.get 8
            i64.const 89478485
            i64.mul
            i64.const 28
            i64.shr_u
            local.tee 9
            i64.const -3
            i64.mul
            local.tee 10
            local.get 8
            i64.add
            local.tee 6
            i64.const 3
            i64.lt_u
            br_if 0 (;@4;)
            local.get 10
            local.get 8
            i64.add
            i64.const -3
            i64.add
            local.tee 8
            local.get 8
            i64.const 3
            i64.div_u
            local.tee 8
            i64.const -3
            i64.mul
            i64.add
            local.set 6
            local.get 9
            local.get 8
            i64.add
            i64.const 1
            i64.add
            local.set 9
          end
          local.get 5
          local.get 9
          i64.store32
          local.get 0
          i32.const -4
          i32.add
          local.set 0
          local.get 5
          i32.const -4
          i32.add
          local.set 5
          local.get 7
          i32.const -1
          i32.add
          local.tee 7
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 2
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 6
        i64.store32
      end
      block  ;; label = @2
        local.get 1
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        call $mp_clamp
        local.get 3
        local.get 1
        call $mp_exch
      end
      local.get 3
      call $mp_clear
    end
    local.get 3
    i32.const 16
    i32.add
    global.set 4
    local.get 4)
  (func $mp_lshd (type 26) (param i32 i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 2
    block  ;; label = @1
      local.get 1
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.load
      local.tee 3
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 0
        i32.load offset=4
        local.get 3
        local.get 1
        i32.add
        local.tee 2
        i32.ge_s
        br_if 0 (;@2;)
        local.get 0
        local.get 2
        call $mp_grow
        local.tee 2
        br_if 1 (;@1;)
        local.get 0
        i32.load
        local.tee 3
        local.get 1
        i32.add
        local.set 2
      end
      local.get 0
      local.get 2
      i32.store
      local.get 0
      i32.load offset=12
      local.set 4
      block  ;; label = @2
        local.get 3
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 4
        local.get 2
        i32.const 2
        i32.shl
        i32.add
        i32.const -4
        i32.add
        local.set 0
        i32.const 0
        local.get 1
        i32.const 2
        i32.shl
        i32.sub
        local.set 3
        loop  ;; label = @3
          local.get 0
          local.get 0
          local.get 3
          i32.add
          i32.load
          i32.store
          local.get 0
          i32.const -4
          i32.add
          local.set 0
          local.get 2
          i32.const -1
          i32.add
          local.tee 2
          local.get 1
          i32.gt_s
          br_if 0 (;@3;)
        end
        local.get 1
        i32.const 1
        i32.ge_s
        br_if 0 (;@2;)
        i32.const 0
        return
      end
      local.get 1
      i32.const 1
      i32.add
      local.set 0
      loop  ;; label = @2
        i32.const 0
        local.set 2
        local.get 4
        i32.const 0
        i32.store
        local.get 4
        i32.const 4
        i32.add
        local.set 4
        local.get 0
        i32.const -1
        i32.add
        local.tee 0
        i32.const 1
        i32.gt_s
        br_if 0 (;@2;)
      end
    end
    local.get 2)
  (func $mp_incr (type 19) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load
        br_if 0 (;@2;)
        local.get 0
        i32.const 1
        call $mp_set
        br 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load offset=8
          i32.const 1
          i32.ne
          br_if 0 (;@3;)
          local.get 0
          i32.const 0
          i32.store offset=8
          local.get 0
          call $mp_decr
          local.tee 1
          br_if 1 (;@2;)
          local.get 0
          i32.load
          i32.eqz
          br_if 2 (;@1;)
          local.get 0
          i32.const 1
          i32.store offset=8
          br 2 (;@1;)
        end
        block  ;; label = @3
          local.get 0
          i32.load offset=12
          local.tee 1
          i32.load
          local.tee 2
          i32.const 268435454
          i32.gt_u
          br_if 0 (;@3;)
          local.get 1
          local.get 2
          i32.const 1
          i32.add
          i32.store
          br 2 (;@1;)
        end
        local.get 0
        i32.const 1
        local.get 0
        call $mp_add_d
        local.set 1
      end
      local.get 1
      return
    end
    i32.const 0)
  (func $mp_decr (type 19) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load
        br_if 0 (;@2;)
        local.get 0
        i32.const 1
        call $mp_set
        local.get 0
        i32.const 1
        i32.store offset=8
        br 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load offset=8
          i32.const 1
          i32.ne
          br_if 0 (;@3;)
          local.get 0
          i32.const 0
          i32.store offset=8
          local.get 0
          call $mp_incr
          local.tee 1
          br_if 1 (;@2;)
          local.get 0
          i32.load
          i32.eqz
          br_if 2 (;@1;)
          local.get 0
          i32.const 1
          i32.store offset=8
          br 2 (;@1;)
        end
        block  ;; label = @3
          local.get 0
          i32.load offset=12
          local.tee 1
          i32.load
          local.tee 2
          i32.const 2
          i32.lt_u
          br_if 0 (;@3;)
          local.get 1
          local.get 2
          i32.const -1
          i32.add
          i32.store
          br 2 (;@1;)
        end
        local.get 0
        i32.const 1
        local.get 0
        call $mp_sub_d
        local.set 1
      end
      local.get 1
      return
    end
    i32.const 0)
  (func $mp_add_d (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 3
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 4
        i32.gt_s
        br_if 0 (;@2;)
        local.get 2
        local.get 4
        i32.const 1
        i32.add
        call $mp_grow
        local.tee 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.load offset=8
              local.tee 6
              i32.const 1
              i32.ne
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 0
                i32.load
                i32.const 1
                i32.gt_s
                br_if 0 (;@6;)
                local.get 0
                i32.load offset=12
                i32.load
                local.get 1
                i32.ge_u
                br_if 0 (;@6;)
                local.get 0
                i32.const 12
                i32.add
                local.set 5
                local.get 2
                i32.load offset=12
                local.set 4
                local.get 2
                i32.load
                local.set 7
                br 2 (;@4;)
              end
              local.get 3
              i32.const 8
              i32.add
              local.tee 4
              local.get 0
              i32.const 8
              i32.add
              i64.load align=4
              i64.store
              local.get 4
              i32.const 0
              i32.store
              local.get 3
              local.get 0
              i64.load align=4
              i64.store
              local.get 3
              local.get 1
              local.get 2
              call $mp_sub_d
              local.set 5
              local.get 2
              i32.const 1
              i32.store offset=8
              br 3 (;@2;)
            end
            local.get 0
            i32.const 12
            i32.add
            local.set 5
            local.get 2
            i32.load offset=12
            local.set 4
            local.get 2
            i32.load
            local.set 7
            local.get 6
            br_if 0 (;@4;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.load
                i32.const 1
                i32.ge_s
                br_if 0 (;@6;)
                i32.const 1
                local.set 8
                br 1 (;@5;)
              end
              local.get 5
              i32.load
              local.set 6
              i32.const 1
              local.set 5
              loop  ;; label = @6
                local.get 4
                local.get 6
                i32.load
                local.get 1
                i32.add
                local.tee 1
                i32.const 268435455
                i32.and
                i32.store
                local.get 4
                i32.const 4
                i32.add
                local.set 4
                local.get 6
                i32.const 4
                i32.add
                local.set 6
                local.get 1
                i32.const 28
                i32.shr_u
                local.set 1
                local.get 5
                local.get 0
                i32.load
                i32.lt_s
                local.set 9
                local.get 5
                i32.const 1
                i32.add
                local.tee 8
                local.set 5
                local.get 9
                br_if 0 (;@6;)
              end
            end
            local.get 4
            local.get 1
            i32.store
            local.get 2
            local.get 0
            i32.load
            i32.const 1
            i32.add
            i32.store
            br 1 (;@3;)
          end
          i32.const 1
          local.set 8
          local.get 2
          i32.const 1
          i32.store
          block  ;; label = @4
            local.get 0
            i32.load
            i32.const 1
            i32.ne
            br_if 0 (;@4;)
            local.get 1
            local.get 5
            i32.load
            i32.load
            i32.sub
            local.set 1
          end
          local.get 4
          local.get 1
          i32.store
        end
        i32.const 0
        local.set 5
        local.get 2
        i32.const 0
        i32.store offset=8
        local.get 7
        local.get 8
        i32.sub
        local.tee 6
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 4
        i32.const 4
        i32.add
        local.set 4
        local.get 6
        i32.const 1
        i32.add
        local.set 6
        loop  ;; label = @3
          local.get 4
          i32.const 0
          i32.store
          local.get 4
          i32.const 4
          i32.add
          local.set 4
          local.get 6
          i32.const -1
          i32.add
          local.tee 6
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 2
      call $mp_clamp
    end
    local.get 3
    i32.const 16
    i32.add
    global.set 4
    local.get 5)
  (func $mp_sub_d (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 3
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 4
        i32.gt_s
        br_if 0 (;@2;)
        local.get 2
        local.get 4
        i32.const 1
        i32.add
        call $mp_grow
        local.tee 4
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.load offset=8
        i32.const 1
        i32.ne
        br_if 0 (;@2;)
        local.get 3
        i32.const 8
        i32.add
        local.tee 4
        local.get 0
        i32.const 8
        i32.add
        i64.load align=4
        i64.store
        local.get 4
        i32.const 0
        i32.store
        local.get 3
        local.get 0
        i64.load align=4
        i64.store
        local.get 3
        local.get 1
        local.get 2
        call $mp_add_d
        local.set 4
        local.get 2
        i32.const 1
        i32.store offset=8
        local.get 2
        call $mp_clamp
        br 1 (;@1;)
      end
      local.get 2
      i32.load offset=12
      local.set 4
      local.get 0
      i32.load offset=12
      local.set 5
      local.get 2
      i32.load
      local.set 6
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load
          local.tee 7
          i32.const 1
          i32.gt_u
          br_if 0 (;@3;)
          block  ;; label = @4
            block  ;; label = @5
              local.get 7
              br_table 1 (;@4;) 0 (;@5;) 1 (;@4;)
            end
            local.get 5
            i32.load
            local.tee 8
            local.get 1
            i32.gt_u
            br_if 1 (;@3;)
            local.get 1
            local.get 8
            i32.sub
            local.set 1
          end
          local.get 4
          local.get 1
          i32.store
          i32.const 1
          local.set 7
          local.get 2
          i32.const 1
          i32.store
          local.get 2
          i32.const 1
          i32.store offset=8
          local.get 4
          i32.const 4
          i32.add
          local.set 4
          br 1 (;@2;)
        end
        local.get 2
        local.get 7
        i32.store
        i32.const 0
        local.set 7
        local.get 2
        i32.const 0
        i32.store offset=8
        local.get 0
        i32.load
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        i32.const 0
        local.set 7
        loop  ;; label = @3
          local.get 4
          local.get 5
          i32.load
          local.get 1
          i32.sub
          local.tee 1
          i32.const 268435455
          i32.and
          i32.store
          local.get 4
          i32.const 4
          i32.add
          local.set 4
          local.get 5
          i32.const 4
          i32.add
          local.set 5
          local.get 1
          i32.const 31
          i32.shr_u
          local.set 1
          local.get 7
          i32.const 1
          i32.add
          local.tee 7
          local.get 0
          i32.load
          i32.lt_s
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 6
        local.get 7
        i32.sub
        local.tee 5
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 5
        i32.const 1
        i32.add
        local.set 5
        loop  ;; label = @3
          local.get 4
          i32.const 0
          i32.store
          local.get 4
          i32.const 4
          i32.add
          local.set 4
          local.get 5
          i32.const -1
          i32.add
          local.tee 5
          i32.const 1
          i32.gt_s
          br_if 0 (;@3;)
        end
      end
      local.get 2
      call $mp_clamp
      i32.const 0
      local.set 4
    end
    local.get 3
    i32.const 16
    i32.add
    global.set 4
    local.get 4)
  (func $pow (type 30) (param f64 f64) (result f64)
    (local i64 i32 i32 i32 i64 i32 i32 i64 f64 f64 f64 f64 f64 f64 f64 f64 f64 i32)
    local.get 1
    i64.reinterpret_f64
    local.tee 2
    i64.const 52
    i64.shr_u
    i32.wrap_i64
    local.tee 3
    i32.const 2047
    i32.and
    local.tee 4
    i32.const -958
    i32.add
    local.set 5
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i64.reinterpret_f64
            local.tee 6
            i64.const 52
            i64.shr_u
            i32.wrap_i64
            local.tee 7
            i32.const -1
            i32.add
            i32.const 2045
            i32.gt_u
            br_if 0 (;@4;)
            i32.const 0
            local.set 8
            local.get 5
            i32.const 128
            i32.lt_u
            br_if 1 (;@3;)
          end
          block  ;; label = @4
            local.get 2
            i64.const 1
            i64.shl
            local.tee 9
            i64.const -1
            i64.add
            i64.const -9007199254740993
            i64.lt_u
            br_if 0 (;@4;)
            f64.const 0x1p+0 (;=1;)
            local.set 10
            local.get 6
            i64.const 4607182418800017408
            i64.eq
            br_if 2 (;@2;)
            local.get 9
            i64.eqz
            br_if 2 (;@2;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 6
                i64.const 1
                i64.shl
                local.tee 6
                i64.const -9007199254740992
                i64.gt_u
                br_if 0 (;@6;)
                local.get 9
                i64.const -9007199254740991
                i64.lt_u
                br_if 1 (;@5;)
              end
              local.get 0
              local.get 1
              f64.add
              return
            end
            local.get 6
            i64.const 9214364837600034816
            i64.eq
            br_if 2 (;@2;)
            f64.const 0x0p+0 (;=0;)
            local.get 1
            local.get 1
            f64.mul
            local.get 2
            i64.const 63
            i64.shr_u
            i32.wrap_i64
            i32.const 1
            i32.xor
            local.get 6
            i64.const 9214364837600034816
            i64.lt_u
            i32.eq
            select
            return
          end
          block  ;; label = @4
            local.get 6
            i64.const 1
            i64.shl
            i64.const -1
            i64.add
            i64.const -9007199254740993
            i64.lt_u
            br_if 0 (;@4;)
            local.get 0
            local.get 0
            f64.mul
            local.set 10
            block  ;; label = @5
              local.get 6
              i64.const -1
              i64.gt_s
              br_if 0 (;@5;)
              local.get 4
              i32.const -1023
              i32.add
              i32.const 52
              i32.gt_u
              br_if 0 (;@5;)
              local.get 10
              local.get 10
              local.get 10
              f64.neg
              i64.const 1
              i32.const 1075
              local.get 4
              i32.sub
              i64.extend_i32_u
              i64.shl
              local.tee 6
              i64.const -1
              i64.add
              local.get 2
              i64.and
              i64.const 0
              i64.ne
              select
              local.get 6
              local.get 2
              i64.and
              i64.eqz
              select
              local.set 10
            end
            local.get 2
            i64.const -1
            i64.gt_s
            br_if 2 (;@2;)
            f64.const 0x1p+0 (;=1;)
            local.get 10
            f64.div
            return
          end
          i32.const 0
          local.set 8
          block  ;; label = @4
            local.get 6
            i64.const -1
            i64.gt_s
            br_if 0 (;@4;)
            local.get 4
            i32.const 1023
            i32.lt_u
            br_if 3 (;@1;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 4
                i32.const 1075
                i32.gt_u
                br_if 0 (;@6;)
                i64.const 1
                i32.const 1075
                local.get 4
                i32.sub
                i64.extend_i32_u
                i64.shl
                local.tee 9
                i64.const -1
                i64.add
                local.get 2
                i64.and
                i64.const 0
                i64.ne
                br_if 5 (;@1;)
                i32.const 262144
                local.set 8
                local.get 9
                local.get 2
                i64.and
                i64.const 0
                i64.ne
                br_if 1 (;@5;)
              end
              i32.const 0
              local.set 8
            end
            local.get 7
            i32.const 2047
            i32.and
            local.set 7
            local.get 6
            i64.const 9223372036854775807
            i64.and
            local.set 6
          end
          block  ;; label = @4
            local.get 5
            i32.const 128
            i32.lt_u
            br_if 0 (;@4;)
            f64.const 0x1p+0 (;=1;)
            local.set 10
            local.get 4
            i32.const 958
            i32.lt_u
            br_if 2 (;@2;)
            local.get 6
            i64.const 4607182418800017408
            i64.eq
            br_if 2 (;@2;)
            block  ;; label = @5
              local.get 3
              i32.const 2048
              i32.lt_u
              local.get 6
              i64.const 4607182418800017409
              i64.lt_u
              i32.eq
              br_if 0 (;@5;)
              i32.const 0
              call $__math_oflow
              return
            end
            i32.const 0
            call $__math_uflow
            return
          end
          local.get 7
          br_if 0 (;@3;)
          local.get 0
          f64.const 0x1p+52 (;=4.5036e+15;)
          f64.mul
          i64.reinterpret_f64
          i64.const 9223372036854775807
          i64.and
          i64.const -234187180623265792
          i64.add
          local.set 6
        end
        block  ;; label = @3
          local.get 2
          i64.const -134217728
          i64.and
          f64.reinterpret_i64
          local.tee 11
          i32.const 66384
          i32.const 2120
          i32.add
          local.tee 5
          local.get 6
          i64.const -4604531861337669632
          i64.add
          local.tee 2
          i64.const 45
          i64.shr_u
          i32.wrap_i64
          i32.const 127
          i32.and
          i32.const 5
          i32.shl
          i32.add
          local.tee 4
          i32.const 88
          i32.add
          f64.load
          local.get 5
          f64.load
          local.get 2
          i64.const 52
          i64.shr_s
          i32.wrap_i64
          f64.convert_i32_s
          local.tee 12
          f64.mul
          f64.add
          local.tee 13
          local.get 4
          i32.const 72
          i32.add
          f64.load
          local.tee 0
          local.get 6
          local.get 2
          i64.const -4503599627370496
          i64.and
          i64.sub
          local.tee 6
          f64.reinterpret_i64
          local.get 6
          i64.const 2147483648
          i64.add
          i64.const -4294967296
          i64.and
          f64.reinterpret_i64
          local.tee 10
          f64.sub
          f64.mul
          local.tee 14
          local.get 0
          local.get 10
          f64.mul
          f64.const -0x1p+0 (;=-1;)
          f64.add
          local.tee 10
          f64.add
          local.tee 0
          f64.add
          local.tee 15
          local.get 10
          local.get 10
          local.get 5
          f64.load offset=16
          local.tee 16
          f64.mul
          local.tee 17
          f64.mul
          local.tee 10
          f64.add
          local.tee 18
          local.get 10
          local.get 15
          local.get 18
          f64.sub
          f64.add
          local.get 14
          local.get 17
          local.get 16
          local.get 0
          f64.mul
          local.tee 10
          f64.add
          f64.mul
          local.get 4
          i32.const 96
          i32.add
          f64.load
          local.get 5
          f64.load offset=8
          local.get 12
          f64.mul
          f64.add
          local.get 0
          local.get 13
          local.get 15
          f64.sub
          f64.add
          f64.add
          f64.add
          f64.add
          local.get 0
          local.get 0
          local.get 10
          f64.mul
          local.tee 10
          f64.mul
          local.get 5
          i32.const 24
          i32.add
          f64.load
          local.get 0
          local.get 5
          i32.const 32
          i32.add
          f64.load
          f64.mul
          f64.add
          local.get 10
          local.get 5
          i32.const 40
          i32.add
          f64.load
          local.get 0
          local.get 5
          i32.const 48
          i32.add
          f64.load
          f64.mul
          f64.add
          local.get 10
          local.get 5
          i32.const 56
          i32.add
          f64.load
          local.get 0
          local.get 5
          i32.const 64
          i32.add
          f64.load
          f64.mul
          f64.add
          f64.mul
          f64.add
          f64.mul
          f64.add
          f64.mul
          f64.add
          local.tee 12
          f64.add
          local.tee 0
          i64.reinterpret_f64
          i64.const -134217728
          i64.and
          f64.reinterpret_i64
          local.tee 10
          f64.mul
          local.tee 15
          i64.reinterpret_f64
          local.tee 6
          i64.const 52
          i64.shr_u
          i32.wrap_i64
          i32.const 2047
          i32.and
          local.tee 4
          i32.const -969
          i32.add
          i32.const 63
          i32.lt_u
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 4
            i32.const 968
            i32.gt_u
            br_if 0 (;@4;)
            f64.const -0x1p+0 (;=-1;)
            f64.const 0x1p+0 (;=1;)
            local.get 8
            select
            return
          end
          local.get 4
          i32.const 1033
          i32.lt_u
          local.set 5
          i32.const 0
          local.set 4
          local.get 5
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 6
            i64.const -1
            i64.gt_s
            br_if 0 (;@4;)
            local.get 8
            call $__math_uflow
            return
          end
          local.get 8
          call $__math_oflow
          return
        end
        i32.const 66384
        i32.const 6416
        i32.add
        local.tee 5
        i32.const 112
        i32.add
        local.tee 7
        local.get 15
        local.get 5
        f64.load
        f64.mul
        local.get 5
        f64.load offset=8
        local.tee 13
        f64.add
        local.tee 14
        i64.reinterpret_f64
        local.tee 6
        i32.wrap_i64
        local.tee 19
        i32.const 4
        i32.shl
        i32.const 2032
        i32.and
        local.tee 3
        i32.add
        f64.load
        local.get 1
        local.get 11
        f64.sub
        local.get 10
        f64.mul
        local.get 12
        local.get 18
        local.get 0
        f64.sub
        f64.add
        local.get 0
        local.get 10
        f64.sub
        f64.add
        local.get 1
        f64.mul
        f64.add
        local.get 14
        local.get 13
        f64.sub
        local.tee 0
        local.get 5
        f64.load offset=24
        f64.mul
        local.get 15
        local.get 5
        f64.load offset=16
        local.get 0
        f64.mul
        f64.add
        f64.add
        f64.add
        local.tee 0
        f64.add
        local.get 0
        local.get 0
        f64.mul
        local.tee 1
        local.get 5
        f64.load offset=32
        local.get 0
        local.get 5
        i32.const 40
        i32.add
        f64.load
        f64.mul
        f64.add
        f64.mul
        f64.add
        local.get 1
        local.get 1
        f64.mul
        local.get 5
        i32.const 48
        i32.add
        f64.load
        local.get 0
        local.get 5
        i32.const 56
        i32.add
        f64.load
        f64.mul
        f64.add
        f64.mul
        f64.add
        local.set 0
        local.get 7
        local.get 3
        i32.const 8
        i32.or
        i32.add
        i64.load
        local.get 6
        local.get 8
        i64.extend_i32_u
        i64.add
        i64.const 45
        i64.shl
        i64.add
        local.set 6
        block  ;; label = @3
          local.get 4
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 19
            i32.const 0
            i32.lt_s
            br_if 0 (;@4;)
            local.get 0
            local.get 6
            i64.const -4544132024016830464
            i64.add
            f64.reinterpret_i64
            local.tee 1
            f64.mul
            local.get 1
            f64.add
            f64.const 0x1p+1009 (;=5.48612e+303;)
            f64.mul
            return
          end
          block  ;; label = @4
            local.get 0
            local.get 6
            i64.const 4602678819172646912
            i64.add
            local.tee 6
            f64.reinterpret_i64
            local.tee 1
            f64.mul
            local.tee 10
            local.get 1
            f64.add
            local.tee 0
            f64.abs
            f64.const 0x1p+0 (;=1;)
            f64.lt
            i32.const 1
            i32.xor
            br_if 0 (;@4;)
            local.get 6
            i64.const -9223372036854775808
            i64.and
            f64.reinterpret_i64
            local.get 0
            f64.const -0x1p+0 (;=-1;)
            f64.const 0x1p+0 (;=1;)
            local.get 0
            f64.const 0x0p+0 (;=0;)
            f64.lt
            select
            local.tee 15
            f64.add
            local.tee 18
            local.get 10
            local.get 1
            local.get 0
            f64.sub
            f64.add
            local.get 0
            local.get 15
            local.get 18
            f64.sub
            f64.add
            f64.add
            f64.add
            local.get 15
            f64.sub
            local.tee 0
            local.get 0
            f64.const 0x0p+0 (;=0;)
            f64.eq
            select
            local.set 0
          end
          local.get 0
          f64.const 0x1p-1022 (;=2.22507e-308;)
          f64.mul
          return
        end
        local.get 0
        local.get 6
        f64.reinterpret_i64
        local.tee 1
        f64.mul
        local.get 1
        f64.add
        local.set 10
      end
      local.get 10
      return
    end
    local.get 0
    call $__math_invalid)
  (func $sin (type 31) (param f64) (result f64)
    (local i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 1
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.reinterpret_f64
        i64.const 32
        i64.shr_u
        i32.wrap_i64
        i32.const 2147483647
        i32.and
        local.tee 2
        i32.const 1072243195
        i32.gt_u
        br_if 0 (;@2;)
        local.get 2
        i32.const 1045430272
        i32.lt_u
        br_if 1 (;@1;)
        local.get 0
        f64.const 0x0p+0 (;=0;)
        i32.const 0
        call $__sin
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 2
        i32.const 2146435072
        i32.lt_u
        br_if 0 (;@2;)
        local.get 0
        local.get 0
        f64.sub
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        local.get 1
        call $__rem_pio2
        i32.const 3
        i32.and
        local.tee 2
        i32.const 2
        i32.gt_u
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              br_table 0 (;@5;) 1 (;@4;) 2 (;@3;) 0 (;@5;)
            end
            local.get 1
            f64.load
            local.get 1
            f64.load offset=8
            i32.const 1
            call $__sin
            local.set 0
            br 3 (;@1;)
          end
          local.get 1
          f64.load
          local.get 1
          f64.load offset=8
          call $__cos
          local.set 0
          br 2 (;@1;)
        end
        local.get 1
        f64.load
        local.get 1
        f64.load offset=8
        i32.const 1
        call $__sin
        f64.neg
        local.set 0
        br 1 (;@1;)
      end
      local.get 1
      f64.load
      local.get 1
      f64.load offset=8
      call $__cos
      f64.neg
      local.set 0
    end
    local.get 1
    i32.const 16
    i32.add
    global.set 4
    local.get 0)
  (func $cos (type 31) (param f64) (result f64)
    (local i32 i32 f64)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 1
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.reinterpret_f64
        i64.const 32
        i64.shr_u
        i32.wrap_i64
        i32.const 2147483647
        i32.and
        local.tee 2
        i32.const 1072243195
        i32.gt_u
        br_if 0 (;@2;)
        f64.const 0x1p+0 (;=1;)
        local.set 3
        local.get 2
        i32.const 1044816030
        i32.lt_u
        br_if 1 (;@1;)
        local.get 0
        f64.const 0x0p+0 (;=0;)
        call $__cos
        local.set 3
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 2
        i32.const 2146435072
        i32.lt_u
        br_if 0 (;@2;)
        local.get 0
        local.get 0
        f64.sub
        local.set 3
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        local.get 1
        call $__rem_pio2
        i32.const 3
        i32.and
        local.tee 2
        i32.const 2
        i32.gt_u
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              br_table 0 (;@5;) 1 (;@4;) 2 (;@3;) 0 (;@5;)
            end
            local.get 1
            f64.load
            local.get 1
            f64.load offset=8
            call $__cos
            local.set 3
            br 3 (;@1;)
          end
          local.get 1
          f64.load
          local.get 1
          f64.load offset=8
          i32.const 1
          call $__sin
          f64.neg
          local.set 3
          br 2 (;@1;)
        end
        local.get 1
        f64.load
        local.get 1
        f64.load offset=8
        call $__cos
        f64.neg
        local.set 3
        br 1 (;@1;)
      end
      local.get 1
      f64.load
      local.get 1
      f64.load offset=8
      i32.const 1
      call $__sin
      local.set 3
    end
    local.get 1
    i32.const 16
    i32.add
    global.set 4
    local.get 3)
  (func $tan (type 31) (param f64) (result f64)
    (local i32 i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 1
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.reinterpret_f64
        i64.const 32
        i64.shr_u
        i32.wrap_i64
        i32.const 2147483647
        i32.and
        local.tee 2
        i32.const 1072243195
        i32.gt_u
        br_if 0 (;@2;)
        local.get 2
        i32.const 1044381696
        i32.lt_u
        br_if 1 (;@1;)
        local.get 0
        f64.const 0x0p+0 (;=0;)
        i32.const 0
        call $__tan
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 2
        i32.const 2146435072
        i32.lt_u
        br_if 0 (;@2;)
        local.get 0
        local.get 0
        f64.sub
        local.set 0
        br 1 (;@1;)
      end
      local.get 0
      local.get 1
      call $__rem_pio2
      local.set 2
      local.get 1
      f64.load
      local.get 1
      f64.load offset=8
      local.get 2
      i32.const 1
      i32.and
      call $__tan
      local.set 0
    end
    local.get 1
    i32.const 16
    i32.add
    global.set 4
    local.get 0)
  (func $asin (type 31) (param f64) (result f64)
    (local i64 i32 f64 f64 f64)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i64.reinterpret_f64
          local.tee 1
          i64.const 32
          i64.shr_u
          i32.wrap_i64
          i32.const 2147483647
          i32.and
          local.tee 2
          i32.const 1072693248
          i32.lt_u
          br_if 0 (;@3;)
          local.get 2
          i32.const -1072693248
          i32.add
          local.get 1
          i32.wrap_i64
          i32.or
          br_if 1 (;@2;)
          local.get 0
          f64.const 0x1.921fb54442d18p+0 (;=1.5708;)
          f64.mul
          f64.const 0x1p-120 (;=7.52316e-37;)
          f64.add
          return
        end
        block  ;; label = @3
          local.get 2
          i32.const 1071644671
          i32.gt_u
          br_if 0 (;@3;)
          local.get 2
          i32.const -1048576
          i32.add
          i32.const 1044381696
          i32.lt_u
          br_if 2 (;@1;)
          local.get 0
          local.get 0
          f64.mul
          local.tee 3
          local.get 3
          local.get 3
          local.get 3
          local.get 3
          local.get 3
          f64.const 0x1.23de10dfdf709p-15 (;=3.47933e-05;)
          f64.mul
          f64.const 0x1.9efe07501b288p-11 (;=0.000791535;)
          f64.add
          f64.mul
          f64.const -0x1.48228b5688f3bp-5 (;=-0.0400555;)
          f64.add
          f64.mul
          f64.const 0x1.9c1550e884455p-3 (;=0.201213;)
          f64.add
          f64.mul
          f64.const -0x1.4d61203eb6f7dp-2 (;=-0.325566;)
          f64.add
          f64.mul
          f64.const 0x1.5555555555555p-3 (;=0.166667;)
          f64.add
          f64.mul
          local.get 3
          local.get 3
          local.get 3
          local.get 3
          f64.const 0x1.3b8c5b12e9282p-4 (;=0.0770382;)
          f64.mul
          f64.const -0x1.6066c1b8d0159p-1 (;=-0.688284;)
          f64.add
          f64.mul
          f64.const 0x1.02ae59c598ac8p+1 (;=2.02095;)
          f64.add
          f64.mul
          f64.const -0x1.33a271c8a2d4bp+1 (;=-2.40339;)
          f64.add
          f64.mul
          f64.const 0x1p+0 (;=1;)
          f64.add
          f64.div
          local.get 0
          f64.mul
          local.get 0
          f64.add
          return
        end
        f64.const 0x1p+0 (;=1;)
        local.get 0
        f64.abs
        f64.sub
        f64.const 0x1p-1 (;=0.5;)
        f64.mul
        local.tee 0
        local.get 0
        local.get 0
        local.get 0
        local.get 0
        local.get 0
        f64.const 0x1.23de10dfdf709p-15 (;=3.47933e-05;)
        f64.mul
        f64.const 0x1.9efe07501b288p-11 (;=0.000791535;)
        f64.add
        f64.mul
        f64.const -0x1.48228b5688f3bp-5 (;=-0.0400555;)
        f64.add
        f64.mul
        f64.const 0x1.9c1550e884455p-3 (;=0.201213;)
        f64.add
        f64.mul
        f64.const -0x1.4d61203eb6f7dp-2 (;=-0.325566;)
        f64.add
        f64.mul
        f64.const 0x1.5555555555555p-3 (;=0.166667;)
        f64.add
        f64.mul
        local.get 0
        local.get 0
        local.get 0
        local.get 0
        f64.const 0x1.3b8c5b12e9282p-4 (;=0.0770382;)
        f64.mul
        f64.const -0x1.6066c1b8d0159p-1 (;=-0.688284;)
        f64.add
        f64.mul
        f64.const 0x1.02ae59c598ac8p+1 (;=2.02095;)
        f64.add
        f64.mul
        f64.const -0x1.33a271c8a2d4bp+1 (;=-2.40339;)
        f64.add
        f64.mul
        f64.const 0x1p+0 (;=1;)
        f64.add
        f64.div
        local.set 4
        local.get 0
        f64.sqrt
        local.set 3
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.const 1072640819
            i32.lt_u
            br_if 0 (;@4;)
            f64.const 0x1.921fb54442d18p+0 (;=1.5708;)
            local.get 3
            local.get 3
            local.get 4
            f64.mul
            f64.add
            local.tee 0
            local.get 0
            f64.add
            f64.const -0x1.1a62633145c07p-54 (;=-6.12323e-17;)
            f64.add
            f64.sub
            local.set 0
            br 1 (;@3;)
          end
          f64.const 0x1.921fb54442d18p-1 (;=0.785398;)
          local.get 3
          i64.reinterpret_f64
          i64.const -4294967296
          i64.and
          f64.reinterpret_i64
          local.tee 5
          local.get 5
          f64.add
          f64.sub
          local.get 3
          local.get 3
          f64.add
          local.get 4
          f64.mul
          f64.const 0x1.1a62633145c07p-54 (;=6.12323e-17;)
          local.get 0
          local.get 5
          local.get 5
          f64.mul
          f64.sub
          local.get 3
          local.get 5
          f64.add
          f64.div
          local.tee 0
          local.get 0
          f64.add
          f64.sub
          f64.sub
          f64.sub
          f64.const 0x1.921fb54442d18p-1 (;=0.785398;)
          f64.add
          local.set 0
        end
        local.get 0
        f64.neg
        local.get 0
        local.get 1
        i64.const 0
        i64.lt_s
        select
        return
      end
      f64.const 0x0p+0 (;=0;)
      local.get 0
      local.get 0
      f64.sub
      f64.div
      local.set 0
    end
    local.get 0)
  (func $acos (type 31) (param f64) (result f64)
    (local i64 i32 f64 f64)
    block  ;; label = @1
      local.get 0
      i64.reinterpret_f64
      local.tee 1
      i64.const 32
      i64.shr_u
      i32.wrap_i64
      i32.const 2147483647
      i32.and
      local.tee 2
      i32.const 1072693248
      i32.lt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 2
        i32.const -1072693248
        i32.add
        local.get 1
        i32.wrap_i64
        i32.or
        br_if 0 (;@2;)
        f64.const 0x1.921fb54442d18p+1 (;=3.14159;)
        f64.const 0x0p+0 (;=0;)
        local.get 1
        i64.const 0
        i64.lt_s
        select
        return
      end
      f64.const 0x0p+0 (;=0;)
      local.get 0
      local.get 0
      f64.sub
      f64.div
      return
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.const 1071644671
        i32.gt_u
        br_if 0 (;@2;)
        f64.const 0x1.921fb54442d18p+0 (;=1.5708;)
        local.set 3
        local.get 2
        i32.const 1012924417
        i32.lt_u
        br_if 1 (;@1;)
        f64.const 0x1.1a62633145c07p-54 (;=6.12323e-17;)
        local.get 0
        local.get 0
        f64.mul
        local.tee 3
        local.get 3
        local.get 3
        local.get 3
        local.get 3
        local.get 3
        f64.const 0x1.23de10dfdf709p-15 (;=3.47933e-05;)
        f64.mul
        f64.const 0x1.9efe07501b288p-11 (;=0.000791535;)
        f64.add
        f64.mul
        f64.const -0x1.48228b5688f3bp-5 (;=-0.0400555;)
        f64.add
        f64.mul
        f64.const 0x1.9c1550e884455p-3 (;=0.201213;)
        f64.add
        f64.mul
        f64.const -0x1.4d61203eb6f7dp-2 (;=-0.325566;)
        f64.add
        f64.mul
        f64.const 0x1.5555555555555p-3 (;=0.166667;)
        f64.add
        f64.mul
        local.get 3
        local.get 3
        local.get 3
        local.get 3
        f64.const 0x1.3b8c5b12e9282p-4 (;=0.0770382;)
        f64.mul
        f64.const -0x1.6066c1b8d0159p-1 (;=-0.688284;)
        f64.add
        f64.mul
        f64.const 0x1.02ae59c598ac8p+1 (;=2.02095;)
        f64.add
        f64.mul
        f64.const -0x1.33a271c8a2d4bp+1 (;=-2.40339;)
        f64.add
        f64.mul
        f64.const 0x1p+0 (;=1;)
        f64.add
        f64.div
        local.get 0
        f64.mul
        f64.sub
        local.get 0
        f64.sub
        f64.const 0x1.921fb54442d18p+0 (;=1.5708;)
        f64.add
        return
      end
      block  ;; label = @2
        local.get 1
        i64.const -1
        i64.gt_s
        br_if 0 (;@2;)
        f64.const 0x1.921fb54442d18p+0 (;=1.5708;)
        local.get 0
        f64.const 0x1p+0 (;=1;)
        f64.add
        f64.const 0x1p-1 (;=0.5;)
        f64.mul
        local.tee 0
        f64.sqrt
        local.tee 3
        local.get 3
        local.get 0
        local.get 0
        local.get 0
        local.get 0
        local.get 0
        local.get 0
        f64.const 0x1.23de10dfdf709p-15 (;=3.47933e-05;)
        f64.mul
        f64.const 0x1.9efe07501b288p-11 (;=0.000791535;)
        f64.add
        f64.mul
        f64.const -0x1.48228b5688f3bp-5 (;=-0.0400555;)
        f64.add
        f64.mul
        f64.const 0x1.9c1550e884455p-3 (;=0.201213;)
        f64.add
        f64.mul
        f64.const -0x1.4d61203eb6f7dp-2 (;=-0.325566;)
        f64.add
        f64.mul
        f64.const 0x1.5555555555555p-3 (;=0.166667;)
        f64.add
        f64.mul
        local.get 0
        local.get 0
        local.get 0
        local.get 0
        f64.const 0x1.3b8c5b12e9282p-4 (;=0.0770382;)
        f64.mul
        f64.const -0x1.6066c1b8d0159p-1 (;=-0.688284;)
        f64.add
        f64.mul
        f64.const 0x1.02ae59c598ac8p+1 (;=2.02095;)
        f64.add
        f64.mul
        f64.const -0x1.33a271c8a2d4bp+1 (;=-2.40339;)
        f64.add
        f64.mul
        f64.const 0x1p+0 (;=1;)
        f64.add
        f64.div
        f64.mul
        f64.const -0x1.1a62633145c07p-54 (;=-6.12323e-17;)
        f64.add
        f64.add
        f64.sub
        local.tee 0
        local.get 0
        f64.add
        return
      end
      f64.const 0x1p+0 (;=1;)
      local.get 0
      f64.sub
      f64.const 0x1p-1 (;=0.5;)
      f64.mul
      local.tee 0
      local.get 0
      f64.sqrt
      local.tee 4
      i64.reinterpret_f64
      i64.const -4294967296
      i64.and
      f64.reinterpret_i64
      local.tee 3
      local.get 3
      f64.mul
      f64.sub
      local.get 4
      local.get 3
      f64.add
      f64.div
      local.get 4
      local.get 0
      local.get 0
      local.get 0
      local.get 0
      local.get 0
      local.get 0
      f64.const 0x1.23de10dfdf709p-15 (;=3.47933e-05;)
      f64.mul
      f64.const 0x1.9efe07501b288p-11 (;=0.000791535;)
      f64.add
      f64.mul
      f64.const -0x1.48228b5688f3bp-5 (;=-0.0400555;)
      f64.add
      f64.mul
      f64.const 0x1.9c1550e884455p-3 (;=0.201213;)
      f64.add
      f64.mul
      f64.const -0x1.4d61203eb6f7dp-2 (;=-0.325566;)
      f64.add
      f64.mul
      f64.const 0x1.5555555555555p-3 (;=0.166667;)
      f64.add
      f64.mul
      local.get 0
      local.get 0
      local.get 0
      local.get 0
      f64.const 0x1.3b8c5b12e9282p-4 (;=0.0770382;)
      f64.mul
      f64.const -0x1.6066c1b8d0159p-1 (;=-0.688284;)
      f64.add
      f64.mul
      f64.const 0x1.02ae59c598ac8p+1 (;=2.02095;)
      f64.add
      f64.mul
      f64.const -0x1.33a271c8a2d4bp+1 (;=-2.40339;)
      f64.add
      f64.mul
      f64.const 0x1p+0 (;=1;)
      f64.add
      f64.div
      f64.mul
      f64.add
      local.get 3
      f64.add
      local.tee 0
      local.get 0
      f64.add
      local.set 3
    end
    local.get 3)
  (func $atan (type 31) (param f64) (result f64)
    (local i64 i32 i32 f64 f64 f64)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.reinterpret_f64
        local.tee 1
        i64.const 32
        i64.shr_u
        i32.wrap_i64
        i32.const 2147483647
        i32.and
        local.tee 2
        i32.const 1141899264
        i32.lt_u
        br_if 0 (;@2;)
        local.get 0
        local.get 0
        f64.ne
        br_if 1 (;@1;)
        f64.const -0x1.921fb54442d18p+0 (;=-1.5708;)
        f64.const 0x1.921fb54442d18p+0 (;=1.5708;)
        local.get 1
        i64.const 0
        i64.lt_s
        select
        return
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.const 1071382527
          i32.gt_u
          br_if 0 (;@3;)
          i32.const -1
          local.set 3
          local.get 2
          i32.const 1044381696
          i32.ge_u
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        local.get 0
        f64.abs
        local.set 0
        block  ;; label = @3
          local.get 2
          i32.const 1072889855
          i32.gt_u
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 2
            i32.const 1072037887
            i32.gt_u
            br_if 0 (;@4;)
            local.get 0
            local.get 0
            f64.add
            f64.const -0x1p+0 (;=-1;)
            f64.add
            local.get 0
            f64.const 0x1p+1 (;=2;)
            f64.add
            f64.div
            local.set 0
            i32.const 0
            local.set 3
            br 2 (;@2;)
          end
          local.get 0
          f64.const -0x1p+0 (;=-1;)
          f64.add
          local.get 0
          f64.const 0x1p+0 (;=1;)
          f64.add
          f64.div
          local.set 0
          i32.const 1
          local.set 3
          br 1 (;@2;)
        end
        block  ;; label = @3
          local.get 2
          i32.const 1073971199
          i32.gt_u
          br_if 0 (;@3;)
          local.get 0
          f64.const -0x1.8p+0 (;=-1.5;)
          f64.add
          local.get 0
          f64.const 0x1.8p+0 (;=1.5;)
          f64.mul
          f64.const 0x1p+0 (;=1;)
          f64.add
          f64.div
          local.set 0
          i32.const 2
          local.set 3
          br 1 (;@2;)
        end
        f64.const -0x1p+0 (;=-1;)
        local.get 0
        f64.div
        local.set 0
        i32.const 3
        local.set 3
      end
      local.get 0
      local.get 0
      f64.mul
      local.tee 4
      local.get 4
      f64.mul
      local.tee 5
      local.get 5
      local.get 5
      local.get 5
      local.get 5
      f64.const -0x1.2b4442c6a6c2fp-5 (;=-0.0365316;)
      f64.mul
      f64.const -0x1.dde2d52defd9ap-5 (;=-0.0583357;)
      f64.add
      f64.mul
      f64.const -0x1.3b0f2af749a6dp-4 (;=-0.0769188;)
      f64.add
      f64.mul
      f64.const -0x1.c71c6fe231671p-4 (;=-0.111111;)
      f64.add
      f64.mul
      f64.const -0x1.999999998ebc4p-3 (;=-0.2;)
      f64.add
      f64.mul
      local.set 6
      local.get 4
      local.get 5
      local.get 5
      local.get 5
      local.get 5
      local.get 5
      f64.const 0x1.0ad3ae322da11p-6 (;=0.0162858;)
      f64.mul
      f64.const 0x1.97b4b24760debp-5 (;=0.0497688;)
      f64.add
      f64.mul
      f64.const 0x1.10d66a0d03d51p-4 (;=0.0666107;)
      f64.add
      f64.mul
      f64.const 0x1.745cdc54c206ep-4 (;=0.0909089;)
      f64.add
      f64.mul
      f64.const 0x1.24924920083ffp-3 (;=0.142857;)
      f64.add
      f64.mul
      f64.const 0x1.555555555550dp-2 (;=0.333333;)
      f64.add
      f64.mul
      local.set 5
      block  ;; label = @2
        local.get 3
        i32.const -1
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 0
        local.get 6
        local.get 5
        f64.add
        f64.mul
        f64.sub
        return
      end
      i32.const 66384
      local.tee 2
      i32.const 6288
      i32.add
      local.get 3
      i32.const 3
      i32.shl
      local.tee 3
      i32.add
      f64.load
      local.get 0
      local.get 6
      local.get 5
      f64.add
      f64.mul
      local.get 2
      i32.const 6320
      i32.add
      local.get 3
      i32.add
      f64.load
      f64.sub
      local.get 0
      f64.sub
      f64.sub
      local.tee 0
      f64.neg
      local.get 0
      local.get 1
      i64.const 0
      i64.lt_s
      select
      local.set 0
    end
    local.get 0)
  (func $atan2 (type 30) (param f64 f64) (result f64)
    (local i64 i32 i32 i32 i32 i32 f64)
    block  ;; label = @1
      local.get 1
      local.get 1
      f64.eq
      local.get 0
      local.get 0
      f64.eq
      i32.and
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      f64.add
      return
    end
    block  ;; label = @1
      local.get 1
      i64.reinterpret_f64
      local.tee 2
      i64.const 32
      i64.shr_u
      i32.wrap_i64
      local.tee 3
      i32.const -1072693248
      i32.add
      local.get 2
      i32.wrap_i64
      local.tee 4
      i32.or
      br_if 0 (;@1;)
      local.get 0
      call $atan
      return
    end
    local.get 2
    i64.const 62
    i64.shr_u
    i32.wrap_i64
    i32.const 2
    i32.and
    local.tee 5
    local.get 0
    i64.reinterpret_f64
    local.tee 2
    i64.const 63
    i64.shr_u
    i32.wrap_i64
    i32.or
    local.set 6
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i64.const 32
          i64.shr_u
          i32.wrap_i64
          i32.const 2147483647
          i32.and
          local.tee 7
          local.get 2
          i32.wrap_i64
          i32.or
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 6
            br_table 3 (;@1;) 3 (;@1;) 2 (;@2;) 0 (;@4;) 3 (;@1;)
          end
          f64.const -0x1.921fb54442d18p+1 (;=-3.14159;)
          return
        end
        block  ;; label = @3
          local.get 3
          i32.const 2147483647
          i32.and
          local.tee 3
          local.get 4
          i32.or
          br_if 0 (;@3;)
          f64.const -0x1.921fb54442d18p+0 (;=-1.5708;)
          f64.const 0x1.921fb54442d18p+0 (;=1.5708;)
          local.get 2
          i64.const 0
          i64.lt_s
          select
          return
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            i32.const 2146435072
            i32.ne
            br_if 0 (;@4;)
            local.get 7
            i32.const 2146435072
            i32.ne
            br_if 1 (;@3;)
            i32.const 66384
            i32.const 6352
            i32.add
            local.get 6
            i32.const 3
            i32.shl
            i32.add
            f64.load
            return
          end
          block  ;; label = @4
            block  ;; label = @5
              local.get 7
              i32.const 2146435072
              i32.eq
              br_if 0 (;@5;)
              local.get 3
              i32.const 67108864
              i32.add
              local.get 7
              i32.ge_u
              br_if 1 (;@4;)
            end
            f64.const -0x1.921fb54442d18p+0 (;=-1.5708;)
            f64.const 0x1.921fb54442d18p+0 (;=1.5708;)
            local.get 2
            i64.const 0
            i64.lt_s
            select
            return
          end
          block  ;; label = @4
            block  ;; label = @5
              local.get 5
              i32.eqz
              br_if 0 (;@5;)
              f64.const 0x0p+0 (;=0;)
              local.set 8
              local.get 7
              i32.const 67108864
              i32.add
              local.get 3
              i32.lt_u
              br_if 1 (;@4;)
            end
            local.get 0
            local.get 1
            f64.div
            f64.abs
            call $atan
            local.set 8
          end
          block  ;; label = @4
            local.get 6
            i32.const 2
            i32.gt_u
            br_if 0 (;@4;)
            local.get 8
            local.set 0
            block  ;; label = @5
              block  ;; label = @6
                local.get 6
                br_table 5 (;@1;) 0 (;@6;) 1 (;@5;) 5 (;@1;)
              end
              local.get 8
              f64.neg
              return
            end
            f64.const 0x1.921fb54442d18p+1 (;=3.14159;)
            local.get 8
            f64.const -0x1.1a62633145c07p-53 (;=-1.22465e-16;)
            f64.add
            f64.sub
            return
          end
          local.get 8
          f64.const -0x1.1a62633145c07p-53 (;=-1.22465e-16;)
          f64.add
          f64.const -0x1.921fb54442d18p+1 (;=-3.14159;)
          f64.add
          return
        end
        i32.const 66384
        i32.const 6384
        i32.add
        local.get 6
        i32.const 3
        i32.shl
        i32.add
        f64.load
        return
      end
      f64.const 0x1.921fb54442d18p+1 (;=3.14159;)
      local.set 0
    end
    local.get 0)
  (func $exp (type 31) (param f64) (result f64)
    (local i64 i32 i32 f64 i32 f64 i32 i32 f64)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i64.reinterpret_f64
          local.tee 1
          i64.const 52
          i64.shr_u
          i32.wrap_i64
          i32.const 2047
          i32.and
          local.tee 2
          i32.const -969
          i32.add
          i32.const 63
          i32.ge_u
          br_if 0 (;@3;)
          local.get 2
          local.set 3
          br 1 (;@2;)
        end
        f64.const 0x1p+0 (;=1;)
        local.set 4
        local.get 2
        i32.const 969
        i32.lt_u
        br_if 1 (;@1;)
        i32.const 0
        local.set 3
        local.get 2
        i32.const 1033
        i32.lt_u
        br_if 0 (;@2;)
        f64.const 0x0p+0 (;=0;)
        local.set 4
        local.get 1
        i64.const -4503599627370496
        i64.eq
        br_if 1 (;@1;)
        block  ;; label = @3
          local.get 2
          i32.const 2047
          i32.ne
          br_if 0 (;@3;)
          local.get 0
          f64.const 0x1p+0 (;=1;)
          f64.add
          return
        end
        block  ;; label = @3
          local.get 1
          i64.const -1
          i64.gt_s
          br_if 0 (;@3;)
          i32.const 0
          call $__math_uflow
          return
        end
        i32.const 0
        call $__math_oflow
        return
      end
      i32.const 66384
      i32.const 6416
      i32.add
      local.tee 2
      i32.const 112
      i32.add
      local.tee 5
      local.get 2
      f64.load
      local.get 0
      f64.mul
      local.get 2
      f64.load offset=8
      local.tee 4
      f64.add
      local.tee 6
      i64.reinterpret_f64
      local.tee 1
      i32.wrap_i64
      local.tee 7
      i32.const 4
      i32.shl
      i32.const 2032
      i32.and
      local.tee 8
      i32.add
      f64.load
      local.get 6
      local.get 4
      f64.sub
      local.tee 4
      local.get 2
      f64.load offset=24
      f64.mul
      local.get 2
      f64.load offset=16
      local.get 4
      f64.mul
      local.get 0
      f64.add
      f64.add
      local.tee 0
      f64.add
      local.get 0
      local.get 0
      f64.mul
      local.tee 4
      local.get 2
      f64.load offset=32
      local.get 0
      local.get 2
      i32.const 40
      i32.add
      f64.load
      f64.mul
      f64.add
      f64.mul
      f64.add
      local.get 4
      local.get 4
      f64.mul
      local.get 2
      i32.const 48
      i32.add
      f64.load
      local.get 0
      local.get 2
      i32.const 56
      i32.add
      f64.load
      f64.mul
      f64.add
      f64.mul
      f64.add
      local.set 0
      local.get 5
      local.get 8
      i32.const 8
      i32.or
      i32.add
      i64.load
      local.get 1
      i64.const 45
      i64.shl
      i64.add
      local.set 1
      block  ;; label = @2
        local.get 3
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 7
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          local.get 0
          local.get 1
          i64.const -4544132024016830464
          i64.add
          f64.reinterpret_i64
          local.tee 4
          f64.mul
          local.get 4
          f64.add
          f64.const 0x1p+1009 (;=5.48612e+303;)
          f64.mul
          return
        end
        block  ;; label = @3
          local.get 0
          local.get 1
          i64.const 4602678819172646912
          i64.add
          f64.reinterpret_i64
          local.tee 4
          f64.mul
          local.tee 6
          local.get 4
          f64.add
          local.tee 0
          f64.const 0x1p+0 (;=1;)
          f64.lt
          i32.const 1
          i32.xor
          br_if 0 (;@3;)
          local.get 0
          f64.const 0x1p+0 (;=1;)
          f64.add
          local.tee 9
          local.get 6
          local.get 4
          local.get 0
          f64.sub
          f64.add
          local.get 0
          f64.const 0x1p+0 (;=1;)
          local.get 9
          f64.sub
          f64.add
          f64.add
          f64.add
          f64.const -0x1p+0 (;=-1;)
          f64.add
          local.set 0
        end
        local.get 0
        f64.const 0x1p-1022 (;=2.22507e-308;)
        f64.mul
        return
      end
      local.get 0
      local.get 1
      f64.reinterpret_i64
      local.tee 4
      f64.mul
      local.get 4
      f64.add
      local.set 4
    end
    local.get 4)
  (func $log (type 31) (param f64) (result f64)
    (local i64 f64 i32 f64 f64 f64 i64 i32)
    block  ;; label = @1
      local.get 0
      i64.reinterpret_f64
      local.tee 1
      i64.const -4606619468846596096
      i64.add
      i64.const 854320534781951
      i64.gt_u
      br_if 0 (;@1;)
      local.get 0
      f64.const -0x1p+0 (;=-1;)
      f64.add
      local.tee 0
      local.get 0
      local.get 0
      f64.const 0x1p+27 (;=1.34218e+08;)
      f64.mul
      local.tee 2
      f64.add
      local.get 2
      f64.sub
      local.tee 2
      local.get 2
      f64.mul
      i32.const 66384
      i32.const 8576
      i32.add
      local.tee 3
      f64.load offset=56
      local.tee 4
      f64.mul
      local.tee 5
      f64.add
      local.tee 6
      local.get 0
      local.get 2
      f64.add
      local.get 0
      local.get 2
      f64.sub
      local.get 4
      f64.mul
      f64.mul
      local.get 5
      local.get 0
      local.get 6
      f64.sub
      f64.add
      f64.add
      local.get 0
      local.get 0
      local.get 0
      f64.mul
      local.tee 2
      f64.mul
      local.tee 4
      local.get 3
      i32.const 64
      i32.add
      f64.load
      local.get 0
      local.get 3
      i32.const 72
      i32.add
      f64.load
      f64.mul
      f64.add
      local.get 2
      local.get 3
      i32.const 80
      i32.add
      f64.load
      f64.mul
      f64.add
      local.get 4
      local.get 3
      i32.const 88
      i32.add
      f64.load
      local.get 0
      local.get 3
      i32.const 96
      i32.add
      f64.load
      f64.mul
      f64.add
      local.get 2
      local.get 3
      i32.const 104
      i32.add
      f64.load
      f64.mul
      f64.add
      local.get 4
      local.get 3
      i32.const 112
      i32.add
      f64.load
      local.get 0
      local.get 3
      i32.const 120
      i32.add
      f64.load
      f64.mul
      f64.add
      local.get 2
      local.get 3
      i32.const 128
      i32.add
      f64.load
      f64.mul
      f64.add
      local.get 4
      local.get 3
      i32.const 136
      i32.add
      f64.load
      f64.mul
      f64.add
      f64.mul
      f64.add
      f64.mul
      f64.add
      f64.mul
      f64.add
      f64.add
      return
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i64.const 48
        i64.shr_u
        i32.wrap_i64
        local.tee 3
        i32.const -16
        i32.add
        i32.const 32736
        i32.lt_u
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 1
          i64.const 9223372036854775807
          i64.and
          i64.const 0
          i64.ne
          br_if 0 (;@3;)
          i32.const 1
          call $__math_divzero
          return
        end
        local.get 1
        i64.const 9218868437227405312
        i64.eq
        br_if 1 (;@1;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            i32.const 32768
            i32.and
            br_if 0 (;@4;)
            local.get 3
            i32.const 32752
            i32.and
            i32.const 32752
            i32.ne
            br_if 1 (;@3;)
          end
          local.get 0
          call $__math_invalid
          return
        end
        local.get 0
        f64.const 0x1p+52 (;=4.5036e+15;)
        f64.mul
        i64.reinterpret_f64
        i64.const -234187180623265792
        i64.add
        local.set 1
      end
      i32.const 66384
      i32.const 8576
      i32.add
      local.tee 3
      local.get 1
      i64.const -4604367669032910848
      i64.add
      local.tee 7
      i64.const 45
      i64.shr_u
      i32.wrap_i64
      i32.const 127
      i32.and
      i32.const 4
      i32.shl
      i32.add
      local.tee 8
      i32.const 152
      i32.add
      f64.load
      local.get 3
      f64.load
      local.get 7
      i64.const 52
      i64.shr_s
      i32.wrap_i64
      f64.convert_i32_s
      local.tee 4
      f64.mul
      f64.add
      local.tee 5
      local.get 8
      i32.const 144
      i32.add
      f64.load
      local.get 1
      local.get 7
      i64.const -4503599627370496
      i64.and
      i64.sub
      f64.reinterpret_i64
      local.get 8
      i32.const 2192
      i32.add
      f64.load
      f64.sub
      local.get 8
      i32.const 2200
      i32.add
      f64.load
      f64.sub
      f64.mul
      local.tee 0
      f64.add
      local.tee 6
      local.get 3
      f64.load offset=16
      local.get 0
      local.get 0
      f64.mul
      local.tee 2
      f64.mul
      local.get 3
      f64.load offset=8
      local.get 4
      f64.mul
      local.get 0
      local.get 5
      local.get 6
      f64.sub
      f64.add
      f64.add
      f64.add
      local.get 0
      local.get 2
      f64.mul
      local.get 3
      i32.const 24
      i32.add
      f64.load
      local.get 0
      local.get 3
      i32.const 32
      i32.add
      f64.load
      f64.mul
      f64.add
      local.get 2
      local.get 3
      i32.const 40
      i32.add
      f64.load
      local.get 0
      local.get 3
      i32.const 48
      i32.add
      f64.load
      f64.mul
      f64.add
      f64.mul
      f64.add
      f64.mul
      f64.add
      f64.add
      local.set 0
    end
    local.get 0)
  (func $floor (type 31) (param f64) (result f64)
    (local i64 i32 f64)
    block  ;; label = @1
      local.get 0
      f64.const 0x0p+0 (;=0;)
      f64.eq
      br_if 0 (;@1;)
      local.get 0
      i64.reinterpret_f64
      local.tee 1
      i64.const 52
      i64.shr_u
      i32.wrap_i64
      i32.const 2047
      i32.and
      local.tee 2
      i32.const 1074
      i32.gt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 2
        i32.const 1022
        i32.gt_u
        br_if 0 (;@2;)
        local.get 1
        i64.const 63
        i64.shr_s
        i32.wrap_i64
        f64.convert_i32_s
        return
      end
      local.get 0
      f64.const -0x1p+52 (;=-4.5036e+15;)
      f64.add
      f64.const 0x1p+52 (;=4.5036e+15;)
      f64.add
      local.get 0
      f64.const 0x1p+52 (;=4.5036e+15;)
      f64.add
      f64.const -0x1p+52 (;=-4.5036e+15;)
      f64.add
      local.get 1
      i64.const 0
      i64.lt_s
      select
      local.get 0
      f64.sub
      local.tee 3
      local.get 0
      f64.add
      local.set 0
      local.get 3
      f64.const 0x0p+0 (;=0;)
      f64.gt
      i32.const 1
      i32.xor
      br_if 0 (;@1;)
      local.get 0
      f64.const -0x1p+0 (;=-1;)
      f64.add
      local.set 0
    end
    local.get 0)
  (func $scalbn (type 34) (param f64 i32) (result f64)
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 1024
        i32.lt_s
        br_if 0 (;@2;)
        local.get 0
        f64.const 0x1p+1023 (;=8.98847e+307;)
        f64.mul
        local.set 0
        block  ;; label = @3
          local.get 1
          i32.const 2047
          i32.ge_s
          br_if 0 (;@3;)
          local.get 1
          i32.const -1023
          i32.add
          local.set 1
          br 2 (;@1;)
        end
        local.get 0
        f64.const 0x1p+1023 (;=8.98847e+307;)
        f64.mul
        local.set 0
        local.get 1
        i32.const 3069
        local.get 1
        i32.const 3069
        i32.lt_s
        select
        i32.const -2046
        i32.add
        local.set 1
        br 1 (;@1;)
      end
      local.get 1
      i32.const -1023
      i32.gt_s
      br_if 0 (;@1;)
      local.get 0
      f64.const 0x1p-969 (;=2.00417e-292;)
      f64.mul
      local.set 0
      block  ;; label = @2
        local.get 1
        i32.const -1992
        i32.le_s
        br_if 0 (;@2;)
        local.get 1
        i32.const 969
        i32.add
        local.set 1
        br 1 (;@1;)
      end
      local.get 0
      f64.const 0x1p-969 (;=2.00417e-292;)
      f64.mul
      local.set 0
      local.get 1
      i32.const -2960
      local.get 1
      i32.const -2960
      i32.gt_s
      select
      i32.const 1938
      i32.add
      local.set 1
    end
    local.get 0
    local.get 1
    i32.const 1023
    i32.add
    i64.extend_i32_u
    i64.const 52
    i64.shl
    f64.reinterpret_i64
    f64.mul)
  (func $frexp (type 34) (param f64 i32) (result f64)
    (local i64 i32)
    block  ;; label = @1
      local.get 0
      i64.reinterpret_f64
      local.tee 2
      i64.const 52
      i64.shr_u
      i32.wrap_i64
      i32.const 2047
      i32.and
      local.tee 3
      i32.const 2047
      i32.eq
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 3
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            f64.const 0x0p+0 (;=0;)
            f64.ne
            br_if 0 (;@4;)
            i32.const 0
            local.set 3
            br 1 (;@3;)
          end
          local.get 0
          f64.const 0x1p+64 (;=1.84467e+19;)
          f64.mul
          local.get 1
          call $frexp
          local.set 0
          local.get 1
          i32.load
          i32.const -64
          i32.add
          local.set 3
        end
        local.get 1
        local.get 3
        i32.store
        local.get 0
        return
      end
      local.get 1
      local.get 3
      i32.const -1022
      i32.add
      i32.store
      local.get 2
      i64.const -9218868437227405313
      i64.and
      i64.const 4602678819172646912
      i64.or
      f64.reinterpret_i64
      local.set 0
    end
    local.get 0)
  (func $strnlen (type 26) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    i32.const 0
    local.get 1
    call $memchr
    local.tee 2
    local.get 0
    i32.sub
    local.get 1
    local.get 2
    select)
  (func $memchr (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    local.get 2
    i32.const 0
    i32.ne
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.eqz
            br_if 0 (;@4;)
            local.get 0
            i32.const 3
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            i32.const 255
            i32.and
            local.set 4
            loop  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.load8_u
                local.get 4
                i32.ne
                br_if 0 (;@6;)
                local.get 2
                local.set 5
                br 4 (;@2;)
              end
              local.get 2
              i32.const 1
              i32.ne
              local.set 3
              local.get 2
              i32.const -1
              i32.add
              local.set 5
              local.get 0
              i32.const 1
              i32.add
              local.set 0
              local.get 2
              i32.const 1
              i32.eq
              br_if 2 (;@3;)
              local.get 5
              local.set 2
              local.get 0
              i32.const 3
              i32.and
              br_if 0 (;@5;)
              br 2 (;@3;)
            end
          end
          local.get 2
          local.set 5
        end
        local.get 3
        i32.eqz
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.load8_u
        local.get 1
        i32.const 255
        i32.and
        i32.eq
        br_if 0 (;@2;)
        local.get 5
        i32.const 4
        i32.lt_u
        br_if 0 (;@2;)
        local.get 1
        i32.const 255
        i32.and
        i32.const 16843009
        i32.mul
        local.set 3
        local.get 5
        i32.const -4
        i32.add
        local.tee 2
        i32.const 3
        i32.and
        local.set 4
        local.get 2
        i32.const -4
        i32.and
        local.get 0
        i32.add
        i32.const 4
        i32.add
        local.set 6
        loop  ;; label = @3
          local.get 0
          i32.load
          local.get 3
          i32.xor
          local.tee 2
          i32.const -1
          i32.xor
          local.get 2
          i32.const -16843009
          i32.add
          i32.and
          i32.const -2139062144
          i32.and
          br_if 1 (;@2;)
          local.get 0
          i32.const 4
          i32.add
          local.set 0
          local.get 5
          i32.const -4
          i32.add
          local.tee 5
          i32.const 3
          i32.gt_u
          br_if 0 (;@3;)
        end
        local.get 4
        local.set 5
        local.get 6
        local.set 0
      end
      local.get 5
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.const 255
      i32.and
      local.set 2
      loop  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u
          local.get 2
          i32.ne
          br_if 0 (;@3;)
          local.get 0
          return
        end
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 5
        i32.const -1
        i32.add
        local.tee 5
        br_if 0 (;@2;)
      end
    end
    i32.const 0)
  (func $memset (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i64)
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.store8
      local.get 2
      local.get 0
      i32.add
      local.tee 3
      i32.const -1
      i32.add
      local.get 1
      i32.store8
      local.get 2
      i32.const 3
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.store8 offset=2
      local.get 0
      local.get 1
      i32.store8 offset=1
      local.get 3
      i32.const -3
      i32.add
      local.get 1
      i32.store8
      local.get 3
      i32.const -2
      i32.add
      local.get 1
      i32.store8
      local.get 2
      i32.const 7
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.store8 offset=3
      local.get 3
      i32.const -4
      i32.add
      local.get 1
      i32.store8
      local.get 2
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      local.get 0
      i32.sub
      i32.const 3
      i32.and
      local.tee 4
      i32.add
      local.tee 3
      local.get 1
      i32.const 255
      i32.and
      i32.const 16843009
      i32.mul
      local.tee 1
      i32.store
      local.get 3
      local.get 2
      local.get 4
      i32.sub
      i32.const -4
      i32.and
      local.tee 4
      i32.add
      local.tee 2
      i32.const -4
      i32.add
      local.get 1
      i32.store
      local.get 4
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      local.get 3
      local.get 1
      i32.store offset=8
      local.get 3
      local.get 1
      i32.store offset=4
      local.get 2
      i32.const -8
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -12
      i32.add
      local.get 1
      i32.store
      local.get 4
      i32.const 25
      i32.lt_u
      br_if 0 (;@1;)
      local.get 3
      local.get 1
      i32.store offset=24
      local.get 3
      local.get 1
      i32.store offset=20
      local.get 3
      local.get 1
      i32.store offset=16
      local.get 3
      local.get 1
      i32.store offset=12
      local.get 2
      i32.const -16
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -20
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -24
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -28
      i32.add
      local.get 1
      i32.store
      local.get 4
      local.get 3
      i32.const 4
      i32.and
      i32.const 24
      i32.or
      local.tee 5
      i32.sub
      local.tee 2
      i32.const 32
      i32.lt_u
      br_if 0 (;@1;)
      local.get 1
      i64.extend_i32_u
      local.tee 6
      i64.const 32
      i64.shl
      local.get 6
      i64.or
      local.set 6
      local.get 3
      local.get 5
      i32.add
      local.set 1
      loop  ;; label = @2
        local.get 1
        local.get 6
        i64.store
        local.get 1
        i32.const 24
        i32.add
        local.get 6
        i64.store
        local.get 1
        i32.const 16
        i32.add
        local.get 6
        i64.store
        local.get 1
        i32.const 8
        i32.add
        local.get 6
        i64.store
        local.get 1
        i32.const 32
        i32.add
        local.set 1
        local.get 2
        i32.const -32
        i32.add
        local.tee 2
        i32.const 31
        i32.gt_u
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $memcpy (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        i32.const 3
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        local.set 3
        loop  ;; label = @3
          local.get 3
          local.get 1
          i32.load8_u
          i32.store8
          local.get 2
          i32.const -1
          i32.add
          local.set 4
          local.get 3
          i32.const 1
          i32.add
          local.set 3
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 2
          i32.const 1
          i32.eq
          br_if 2 (;@1;)
          local.get 4
          local.set 2
          local.get 1
          i32.const 3
          i32.and
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      local.get 2
      local.set 4
      local.get 0
      local.set 3
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.const 3
        i32.and
        local.tee 2
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 4
            i32.const 16
            i32.ge_u
            br_if 0 (;@4;)
            local.get 4
            local.set 2
            br 1 (;@3;)
          end
          local.get 4
          i32.const -16
          i32.add
          local.set 2
          loop  ;; label = @4
            local.get 3
            local.get 1
            i32.load
            i32.store
            local.get 3
            i32.const 4
            i32.add
            local.get 1
            i32.const 4
            i32.add
            i32.load
            i32.store
            local.get 3
            i32.const 8
            i32.add
            local.get 1
            i32.const 8
            i32.add
            i32.load
            i32.store
            local.get 3
            i32.const 12
            i32.add
            local.get 1
            i32.const 12
            i32.add
            i32.load
            i32.store
            local.get 3
            i32.const 16
            i32.add
            local.set 3
            local.get 1
            i32.const 16
            i32.add
            local.set 1
            local.get 4
            i32.const -16
            i32.add
            local.tee 4
            i32.const 15
            i32.gt_u
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 2
          i32.const 8
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 3
          local.get 1
          i64.load align=4
          i64.store align=4
          local.get 1
          i32.const 8
          i32.add
          local.set 1
          local.get 3
          i32.const 8
          i32.add
          local.set 3
        end
        block  ;; label = @3
          local.get 2
          i32.const 4
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 3
          local.get 1
          i32.load
          i32.store
          local.get 1
          i32.const 4
          i32.add
          local.set 1
          local.get 3
          i32.const 4
          i32.add
          local.set 3
        end
        block  ;; label = @3
          local.get 2
          i32.const 2
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 3
          local.get 1
          i32.load8_u
          i32.store8
          local.get 3
          local.get 1
          i32.load8_u offset=1
          i32.store8 offset=1
          local.get 3
          i32.const 2
          i32.add
          local.set 3
          local.get 1
          i32.const 2
          i32.add
          local.set 1
        end
        local.get 2
        i32.const 1
        i32.and
        i32.eqz
        br_if 1 (;@1;)
        local.get 3
        local.get 1
        i32.load8_u
        i32.store8
        local.get 0
        return
      end
      block  ;; label = @2
        local.get 4
        i32.const 32
        i32.lt_u
        br_if 0 (;@2;)
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        i32.const 2
        i32.gt_u
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              br_table 0 (;@5;) 1 (;@4;) 2 (;@3;) 0 (;@5;)
            end
            local.get 3
            local.get 1
            i32.load8_u offset=1
            i32.store8 offset=1
            local.get 3
            local.get 1
            i32.load
            local.tee 5
            i32.store8
            local.get 3
            local.get 1
            i32.load8_u offset=2
            i32.store8 offset=2
            local.get 4
            i32.const -3
            i32.add
            local.set 6
            local.get 3
            i32.const 3
            i32.add
            local.set 7
            local.get 4
            i32.const -20
            i32.add
            i32.const -16
            i32.and
            local.set 8
            i32.const 0
            local.set 2
            loop  ;; label = @5
              local.get 7
              local.get 2
              i32.add
              local.tee 3
              local.get 1
              local.get 2
              i32.add
              local.tee 9
              i32.const 4
              i32.add
              i32.load
              local.tee 10
              i32.const 8
              i32.shl
              local.get 5
              i32.const 24
              i32.shr_u
              i32.or
              i32.store
              local.get 3
              i32.const 4
              i32.add
              local.get 9
              i32.const 8
              i32.add
              i32.load
              local.tee 5
              i32.const 8
              i32.shl
              local.get 10
              i32.const 24
              i32.shr_u
              i32.or
              i32.store
              local.get 3
              i32.const 8
              i32.add
              local.get 9
              i32.const 12
              i32.add
              i32.load
              local.tee 10
              i32.const 8
              i32.shl
              local.get 5
              i32.const 24
              i32.shr_u
              i32.or
              i32.store
              local.get 3
              i32.const 12
              i32.add
              local.get 9
              i32.const 16
              i32.add
              i32.load
              local.tee 5
              i32.const 8
              i32.shl
              local.get 10
              i32.const 24
              i32.shr_u
              i32.or
              i32.store
              local.get 2
              i32.const 16
              i32.add
              local.set 2
              local.get 6
              i32.const -16
              i32.add
              local.tee 6
              i32.const 16
              i32.gt_u
              br_if 0 (;@5;)
            end
            local.get 7
            local.get 2
            i32.add
            local.set 3
            local.get 1
            local.get 2
            i32.add
            i32.const 3
            i32.add
            local.set 1
            local.get 4
            local.get 8
            i32.sub
            i32.const -19
            i32.add
            local.set 4
            br 2 (;@2;)
          end
          local.get 3
          local.get 1
          i32.load
          local.tee 5
          i32.store8
          local.get 3
          local.get 1
          i32.load8_u offset=1
          i32.store8 offset=1
          local.get 4
          i32.const -2
          i32.add
          local.set 6
          local.get 3
          i32.const 2
          i32.add
          local.set 7
          local.get 4
          i32.const -20
          i32.add
          i32.const -16
          i32.and
          local.set 8
          i32.const 0
          local.set 2
          loop  ;; label = @4
            local.get 7
            local.get 2
            i32.add
            local.tee 3
            local.get 1
            local.get 2
            i32.add
            local.tee 9
            i32.const 4
            i32.add
            i32.load
            local.tee 10
            i32.const 16
            i32.shl
            local.get 5
            i32.const 16
            i32.shr_u
            i32.or
            i32.store
            local.get 3
            i32.const 4
            i32.add
            local.get 9
            i32.const 8
            i32.add
            i32.load
            local.tee 5
            i32.const 16
            i32.shl
            local.get 10
            i32.const 16
            i32.shr_u
            i32.or
            i32.store
            local.get 3
            i32.const 8
            i32.add
            local.get 9
            i32.const 12
            i32.add
            i32.load
            local.tee 10
            i32.const 16
            i32.shl
            local.get 5
            i32.const 16
            i32.shr_u
            i32.or
            i32.store
            local.get 3
            i32.const 12
            i32.add
            local.get 9
            i32.const 16
            i32.add
            i32.load
            local.tee 5
            i32.const 16
            i32.shl
            local.get 10
            i32.const 16
            i32.shr_u
            i32.or
            i32.store
            local.get 2
            i32.const 16
            i32.add
            local.set 2
            local.get 6
            i32.const -16
            i32.add
            local.tee 6
            i32.const 17
            i32.gt_u
            br_if 0 (;@4;)
          end
          local.get 7
          local.get 2
          i32.add
          local.set 3
          local.get 1
          local.get 2
          i32.add
          i32.const 2
          i32.add
          local.set 1
          local.get 4
          local.get 8
          i32.sub
          i32.const -18
          i32.add
          local.set 4
          br 1 (;@2;)
        end
        local.get 3
        local.get 1
        i32.load
        local.tee 5
        i32.store8
        local.get 4
        i32.const -1
        i32.add
        local.set 6
        local.get 3
        i32.const 1
        i32.add
        local.set 7
        local.get 4
        i32.const -20
        i32.add
        i32.const -16
        i32.and
        local.set 8
        i32.const 0
        local.set 2
        loop  ;; label = @3
          local.get 7
          local.get 2
          i32.add
          local.tee 3
          local.get 1
          local.get 2
          i32.add
          local.tee 9
          i32.const 4
          i32.add
          i32.load
          local.tee 10
          i32.const 24
          i32.shl
          local.get 5
          i32.const 8
          i32.shr_u
          i32.or
          i32.store
          local.get 3
          i32.const 4
          i32.add
          local.get 9
          i32.const 8
          i32.add
          i32.load
          local.tee 5
          i32.const 24
          i32.shl
          local.get 10
          i32.const 8
          i32.shr_u
          i32.or
          i32.store
          local.get 3
          i32.const 8
          i32.add
          local.get 9
          i32.const 12
          i32.add
          i32.load
          local.tee 10
          i32.const 24
          i32.shl
          local.get 5
          i32.const 8
          i32.shr_u
          i32.or
          i32.store
          local.get 3
          i32.const 12
          i32.add
          local.get 9
          i32.const 16
          i32.add
          i32.load
          local.tee 5
          i32.const 24
          i32.shl
          local.get 10
          i32.const 8
          i32.shr_u
          i32.or
          i32.store
          local.get 2
          i32.const 16
          i32.add
          local.set 2
          local.get 6
          i32.const -16
          i32.add
          local.tee 6
          i32.const 18
          i32.gt_u
          br_if 0 (;@3;)
        end
        local.get 7
        local.get 2
        i32.add
        local.set 3
        local.get 1
        local.get 2
        i32.add
        i32.const 1
        i32.add
        local.set 1
        local.get 4
        local.get 8
        i32.sub
        i32.const -17
        i32.add
        local.set 4
      end
      block  ;; label = @2
        local.get 4
        i32.const 16
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        local.get 1
        i32.load16_u align=1
        i32.store16 align=1
        local.get 3
        local.get 1
        i32.load8_u offset=2
        i32.store8 offset=2
        local.get 3
        local.get 1
        i32.load8_u offset=3
        i32.store8 offset=3
        local.get 3
        local.get 1
        i32.load8_u offset=4
        i32.store8 offset=4
        local.get 3
        local.get 1
        i32.load8_u offset=5
        i32.store8 offset=5
        local.get 3
        local.get 1
        i32.load8_u offset=6
        i32.store8 offset=6
        local.get 3
        local.get 1
        i32.load8_u offset=7
        i32.store8 offset=7
        local.get 3
        local.get 1
        i32.load8_u offset=8
        i32.store8 offset=8
        local.get 3
        local.get 1
        i32.load8_u offset=9
        i32.store8 offset=9
        local.get 3
        local.get 1
        i32.load8_u offset=10
        i32.store8 offset=10
        local.get 3
        local.get 1
        i32.load8_u offset=11
        i32.store8 offset=11
        local.get 3
        local.get 1
        i32.load8_u offset=12
        i32.store8 offset=12
        local.get 3
        local.get 1
        i32.load8_u offset=13
        i32.store8 offset=13
        local.get 3
        local.get 1
        i32.load8_u offset=14
        i32.store8 offset=14
        local.get 3
        local.get 1
        i32.load8_u offset=15
        i32.store8 offset=15
        local.get 3
        i32.const 16
        i32.add
        local.set 3
        local.get 1
        i32.const 16
        i32.add
        local.set 1
      end
      block  ;; label = @2
        local.get 4
        i32.const 8
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        local.get 1
        i32.load8_u
        i32.store8
        local.get 3
        local.get 1
        i32.load8_u offset=1
        i32.store8 offset=1
        local.get 3
        local.get 1
        i32.load8_u offset=2
        i32.store8 offset=2
        local.get 3
        local.get 1
        i32.load8_u offset=3
        i32.store8 offset=3
        local.get 3
        local.get 1
        i32.load8_u offset=4
        i32.store8 offset=4
        local.get 3
        local.get 1
        i32.load8_u offset=5
        i32.store8 offset=5
        local.get 3
        local.get 1
        i32.load8_u offset=6
        i32.store8 offset=6
        local.get 3
        local.get 1
        i32.load8_u offset=7
        i32.store8 offset=7
        local.get 3
        i32.const 8
        i32.add
        local.set 3
        local.get 1
        i32.const 8
        i32.add
        local.set 1
      end
      block  ;; label = @2
        local.get 4
        i32.const 4
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        local.get 1
        i32.load8_u
        i32.store8
        local.get 3
        local.get 1
        i32.load8_u offset=1
        i32.store8 offset=1
        local.get 3
        local.get 1
        i32.load8_u offset=2
        i32.store8 offset=2
        local.get 3
        local.get 1
        i32.load8_u offset=3
        i32.store8 offset=3
        local.get 3
        i32.const 4
        i32.add
        local.set 3
        local.get 1
        i32.const 4
        i32.add
        local.set 1
      end
      block  ;; label = @2
        local.get 4
        i32.const 2
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        local.get 1
        i32.load8_u
        i32.store8
        local.get 3
        local.get 1
        i32.load8_u offset=1
        i32.store8 offset=1
        local.get 3
        i32.const 2
        i32.add
        local.set 3
        local.get 1
        i32.const 2
        i32.add
        local.set 1
      end
      local.get 4
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 3
      local.get 1
      i32.load8_u
      i32.store8
    end
    local.get 0)
  (func $snprintf (type 33) (param i32 i32 i32 i32) (result i32)
    (local i32)
    global.get 4
    i32.const 16
    i32.sub
    local.tee 4
    global.set 4
    local.get 4
    local.get 3
    i32.store offset=12
    local.get 0
    local.get 1
    local.get 2
    local.get 3
    call $vsnprintf
    local.set 3
    local.get 4
    i32.const 16
    i32.add
    global.set 4
    local.get 3)
  (func $vsnprintf (type 33) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32)
    global.get 4
    i32.const 128
    i32.sub
    local.tee 4
    global.set 4
    i32.const -1
    local.set 5
    local.get 4
    local.get 1
    i32.const -1
    i32.add
    local.tee 6
    i32.const 0
    local.get 6
    local.get 1
    i32.lt_u
    local.tee 6
    select
    i32.store offset=116
    local.get 4
    local.get 0
    local.get 4
    i32.const 126
    i32.add
    local.get 6
    select
    local.tee 0
    i32.store offset=112
    local.get 4
    i32.const 0
    i32.const 112
    call $memset
    local.tee 4
    i32.const -1
    i32.store offset=64
    local.get 4
    i32.const 28
    i32.const 1
    i32.add
    i32.store offset=32
    local.get 4
    local.get 4
    i32.const 112
    i32.add
    i32.store offset=68
    local.get 4
    local.get 4
    i32.const 127
    i32.add
    i32.store offset=40
    block  ;; label = @1
      local.get 1
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      i32.store8
      local.get 4
      local.get 2
      local.get 3
      call $vfprintf
      local.set 5
    end
    local.get 4
    i32.const 128
    i32.add
    global.set 4
    local.get 5)
  (func $sn_write (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=68
      local.tee 3
      i32.load offset=4
      local.tee 4
      local.get 0
      i32.load offset=20
      local.get 0
      i32.load offset=24
      local.tee 5
      i32.sub
      local.tee 6
      local.get 4
      local.get 6
      i32.lt_u
      select
      local.tee 6
      i32.eqz
      br_if 0 (;@1;)
      local.get 3
      i32.load
      local.get 5
      local.get 6
      call $memcpy
      drop
      local.get 3
      local.get 3
      i32.load
      local.get 6
      i32.add
      i32.store
      local.get 3
      local.get 3
      i32.load offset=4
      local.get 6
      i32.sub
      local.tee 4
      i32.store offset=4
    end
    local.get 3
    i32.load
    local.set 6
    block  ;; label = @1
      local.get 4
      local.get 2
      local.get 4
      local.get 2
      i32.lt_u
      select
      local.tee 4
      i32.eqz
      br_if 0 (;@1;)
      local.get 6
      local.get 1
      local.get 4
      call $memcpy
      drop
      local.get 3
      local.get 3
      i32.load
      local.get 4
      i32.add
      local.tee 6
      i32.store
      local.get 3
      local.get 3
      i32.load offset=4
      local.get 4
      i32.sub
      i32.store offset=4
    end
    local.get 6
    i32.const 0
    i32.store8
    local.get 0
    local.get 0
    i32.load offset=40
    local.tee 3
    i32.store offset=24
    local.get 0
    local.get 3
    i32.store offset=20
    local.get 2)
  (func $vfprintf (type 18) (param i32 i32 i32) (result i32)
    (local i32 i32)
    global.get 4
    i32.const 208
    i32.sub
    local.tee 3
    global.set 4
    local.get 3
    local.get 2
    i32.store offset=204
    local.get 3
    i32.const 160
    i32.add
    i32.const 0
    i32.const 40
    call $memset
    drop
    local.get 3
    local.get 3
    i32.load offset=204
    i32.store offset=200
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        local.get 1
        local.get 3
        i32.const 200
        i32.add
        local.get 3
        i32.const 80
        i32.add
        local.get 3
        i32.const 160
        i32.add
        call $printf_core
        i32.const 0
        i32.ge_s
        br_if 0 (;@2;)
        i32.const -1
        local.set 0
        br 1 (;@1;)
      end
      local.get 0
      i32.load
      local.set 2
      block  ;; label = @2
        local.get 0
        i32.load offset=60
        i32.const 0
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 2
        i32.const -33
        i32.and
        i32.store
      end
      local.get 2
      i32.const 32
      i32.and
      local.set 2
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load offset=44
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          local.get 1
          local.get 3
          i32.const 200
          i32.add
          local.get 3
          i32.const 80
          i32.add
          local.get 3
          i32.const 160
          i32.add
          call $printf_core
          local.set 1
          br 1 (;@2;)
        end
        local.get 0
        i32.const 80
        i32.store offset=44
        local.get 0
        i32.const 0
        i32.store offset=24
        local.get 0
        i64.const 0
        i64.store offset=16
        local.get 0
        i32.load offset=40
        local.set 4
        local.get 0
        local.get 3
        i32.store offset=40
        local.get 0
        local.get 1
        local.get 3
        i32.const 200
        i32.add
        local.get 3
        i32.const 80
        i32.add
        local.get 3
        i32.const 160
        i32.add
        call $printf_core
        local.set 1
        local.get 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 0
        i32.const 0
        local.get 0
        i32.load offset=32
        call_indirect (type 18)
        drop
        local.get 0
        i32.const 0
        i32.store offset=44
        local.get 0
        local.get 4
        i32.store offset=40
        local.get 0
        i32.const 0
        i32.store offset=24
        local.get 0
        i32.const 0
        i32.store offset=16
        local.get 0
        i32.load offset=20
        local.set 4
        local.get 0
        i32.const 0
        i32.store offset=20
        local.get 1
        i32.const -1
        local.get 4
        select
        local.set 1
      end
      local.get 0
      local.get 0
      i32.load
      local.tee 4
      local.get 2
      i32.or
      i32.store
      i32.const -1
      local.get 1
      local.get 4
      i32.const 32
      i32.and
      select
      local.set 0
    end
    local.get 3
    i32.const 208
    i32.add
    global.set 4
    local.get 0)
  (func $printf_core (type 25) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 f64 i32 i32 f64 i32 i32 i32 i64 i64 i32)
    global.get 4
    i32.const 624
    i32.sub
    local.tee 5
    global.set 4
    local.get 5
    i32.const 55
    i32.add
    local.set 6
    i32.const -2
    local.get 5
    i32.const 80
    i32.add
    i32.sub
    local.set 7
    local.get 5
    i32.const 68
    i32.add
    i32.const 11
    i32.add
    local.set 8
    local.get 5
    i32.const 80
    i32.add
    i32.const 8
    i32.or
    local.set 9
    local.get 5
    i32.const 80
    i32.add
    i32.const 9
    i32.or
    local.set 10
    local.get 5
    i32.const 400
    i32.add
    local.set 11
    local.get 5
    i32.const 68
    i32.add
    i32.const 12
    i32.add
    local.set 12
    local.get 5
    i32.const 56
    i32.add
    local.set 13
    i32.const 0
    local.set 14
    i32.const 0
    local.set 15
    i32.const 0
    local.set 16
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 1
          local.set 17
          local.get 16
          i32.const 2147483647
          local.get 15
          i32.sub
          i32.gt_s
          br_if 1 (;@2;)
          local.get 16
          local.get 15
          i32.add
          local.set 15
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 17
                      i32.load8_u
                      local.tee 16
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 17
                      local.set 1
                      loop  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 16
                              i32.const 255
                              i32.and
                              local.tee 16
                              i32.eqz
                              br_if 0 (;@13;)
                              local.get 16
                              i32.const 37
                              i32.ne
                              br_if 2 (;@11;)
                              local.get 1
                              local.set 18
                              local.get 1
                              local.set 16
                              loop  ;; label = @14
                                block  ;; label = @15
                                  local.get 16
                                  i32.const 1
                                  i32.add
                                  i32.load8_u
                                  i32.const 37
                                  i32.eq
                                  br_if 0 (;@15;)
                                  local.get 16
                                  local.set 1
                                  br 3 (;@12;)
                                end
                                local.get 18
                                i32.const 1
                                i32.add
                                local.set 18
                                local.get 16
                                i32.load8_u offset=2
                                local.set 19
                                local.get 16
                                i32.const 2
                                i32.add
                                local.tee 1
                                local.set 16
                                local.get 19
                                i32.const 37
                                i32.eq
                                br_if 0 (;@14;)
                                br 2 (;@12;)
                              end
                            end
                            local.get 1
                            local.set 18
                          end
                          i32.const -1
                          local.set 19
                          local.get 18
                          local.get 17
                          i32.sub
                          local.tee 16
                          i32.const 2147483647
                          local.get 15
                          i32.sub
                          local.tee 20
                          i32.gt_s
                          br_if 10 (;@1;)
                          block  ;; label = @12
                            local.get 0
                            i32.eqz
                            br_if 0 (;@12;)
                            local.get 0
                            i32.load8_u
                            i32.const 32
                            i32.and
                            br_if 0 (;@12;)
                            local.get 0
                            local.get 17
                            local.get 16
                            local.get 0
                            i32.load offset=32
                            call_indirect (type 18)
                            drop
                          end
                          local.get 16
                          br_if 8 (;@3;)
                          local.get 1
                          i32.const 1
                          i32.add
                          local.set 16
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 1
                              i32.load8_s offset=1
                              local.tee 21
                              i32.const -48
                              i32.add
                              local.tee 19
                              i32.const 9
                              i32.le_u
                              br_if 0 (;@13;)
                              i32.const -1
                              local.set 22
                              br 1 (;@12;)
                            end
                            local.get 1
                            i32.const 3
                            i32.add
                            local.get 16
                            local.get 1
                            i32.load8_u offset=2
                            i32.const 36
                            i32.eq
                            local.tee 18
                            select
                            local.set 16
                            i32.const 1
                            local.get 14
                            local.get 18
                            select
                            local.set 14
                            local.get 19
                            i32.const -1
                            local.get 18
                            select
                            local.set 22
                            local.get 1
                            i32.const 3
                            i32.const 1
                            local.get 18
                            select
                            i32.add
                            i32.load8_s
                            local.set 21
                          end
                          i32.const 0
                          local.set 18
                          local.get 21
                          i32.const -32
                          i32.add
                          local.tee 1
                          i32.const 31
                          i32.gt_u
                          br_if 3 (;@8;)
                          i32.const 1
                          local.get 1
                          i32.shl
                          local.tee 19
                          i32.const 75913
                          i32.and
                          i32.eqz
                          br_if 3 (;@8;)
                          i32.const 0
                          local.set 18
                          loop  ;; label = @12
                            local.get 16
                            i32.const 1
                            i32.add
                            local.set 1
                            local.get 19
                            local.get 18
                            i32.or
                            local.set 18
                            local.get 16
                            i32.load8_s offset=1
                            local.tee 21
                            i32.const -32
                            i32.add
                            local.tee 19
                            i32.const 31
                            i32.gt_u
                            br_if 5 (;@7;)
                            local.get 1
                            local.set 16
                            i32.const 1
                            local.get 19
                            i32.shl
                            local.tee 19
                            i32.const 75913
                            i32.and
                            br_if 0 (;@12;)
                            br 5 (;@7;)
                          end
                        end
                        local.get 1
                        i32.load8_u offset=1
                        local.set 16
                        local.get 1
                        i32.const 1
                        i32.add
                        local.set 1
                        br 0 (;@10;)
                      end
                    end
                    local.get 15
                    local.set 19
                    local.get 0
                    br_if 7 (;@1;)
                    local.get 14
                    i32.eqz
                    br_if 2 (;@6;)
                    local.get 3
                    i32.const 8
                    i32.add
                    local.set 16
                    local.get 4
                    i32.const 4
                    i32.add
                    local.set 1
                    i32.const 0
                    local.set 18
                    block  ;; label = @9
                      loop  ;; label = @10
                        local.get 1
                        i32.load
                        local.tee 19
                        i32.eqz
                        br_if 1 (;@9;)
                        local.get 16
                        local.get 19
                        local.get 2
                        call $pop_arg
                        local.get 16
                        i32.const 8
                        i32.add
                        local.set 16
                        local.get 1
                        i32.const 4
                        i32.add
                        local.set 1
                        i32.const 1
                        local.set 19
                        local.get 18
                        i32.const 1
                        i32.add
                        local.tee 18
                        i32.const 9
                        i32.ne
                        br_if 0 (;@10;)
                        br 9 (;@1;)
                      end
                    end
                    i32.const 1
                    local.set 19
                    local.get 18
                    i32.const 1
                    i32.add
                    i32.const 9
                    i32.gt_u
                    br_if 7 (;@1;)
                    loop  ;; label = @9
                      local.get 1
                      i32.load
                      br_if 7 (;@2;)
                      local.get 1
                      i32.const 4
                      i32.add
                      local.set 1
                      i32.const 1
                      local.set 19
                      local.get 18
                      i32.const 1
                      i32.add
                      local.tee 18
                      i32.const 8
                      i32.gt_u
                      br_if 8 (;@1;)
                      br 0 (;@9;)
                    end
                  end
                  local.get 16
                  local.set 1
                end
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 21
                    i32.const 42
                    i32.ne
                    br_if 0 (;@8;)
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 1
                        i32.load8_s offset=1
                        i32.const -48
                        i32.add
                        local.tee 16
                        i32.const 9
                        i32.gt_u
                        br_if 0 (;@10;)
                        local.get 1
                        i32.load8_u offset=2
                        i32.const 36
                        i32.ne
                        br_if 0 (;@10;)
                        local.get 4
                        local.get 16
                        i32.const 2
                        i32.shl
                        i32.add
                        i32.const 10
                        i32.store
                        local.get 1
                        i32.const 3
                        i32.add
                        local.set 21
                        local.get 1
                        i32.load8_s offset=1
                        i32.const 3
                        i32.shl
                        local.get 3
                        i32.add
                        i32.const -384
                        i32.add
                        i32.load
                        local.set 23
                        i32.const 1
                        local.set 14
                        br 1 (;@9;)
                      end
                      local.get 14
                      br_if 7 (;@2;)
                      local.get 1
                      i32.const 1
                      i32.add
                      local.set 21
                      block  ;; label = @10
                        local.get 0
                        br_if 0 (;@10;)
                        i32.const 0
                        local.set 23
                        i32.const 0
                        local.set 14
                        br 3 (;@7;)
                      end
                      local.get 2
                      local.get 2
                      i32.load
                      local.tee 1
                      i32.const 4
                      i32.add
                      i32.store
                      local.get 1
                      i32.load
                      local.set 23
                      i32.const 0
                      local.set 14
                    end
                    local.get 23
                    i32.const -1
                    i32.gt_s
                    br_if 1 (;@7;)
                    i32.const 0
                    local.get 23
                    i32.sub
                    local.set 23
                    local.get 18
                    i32.const 8192
                    i32.or
                    local.set 18
                    br 1 (;@7;)
                  end
                  i32.const 0
                  local.set 23
                  block  ;; label = @8
                    local.get 21
                    i32.const -48
                    i32.add
                    local.tee 19
                    i32.const 9
                    i32.le_u
                    br_if 0 (;@8;)
                    local.get 1
                    local.set 21
                    br 1 (;@7;)
                  end
                  i32.const 0
                  local.set 16
                  loop  ;; label = @8
                    i32.const -1
                    local.set 23
                    block  ;; label = @9
                      local.get 16
                      i32.const 214748364
                      i32.gt_u
                      br_if 0 (;@9;)
                      i32.const -1
                      local.get 16
                      i32.const 10
                      i32.mul
                      local.tee 16
                      local.get 19
                      i32.add
                      local.get 19
                      i32.const 2147483647
                      local.get 16
                      i32.sub
                      i32.gt_s
                      select
                      local.set 23
                    end
                    local.get 1
                    i32.load8_s offset=1
                    local.set 19
                    local.get 1
                    i32.const 1
                    i32.add
                    local.tee 21
                    local.set 1
                    local.get 23
                    local.set 16
                    local.get 19
                    i32.const -48
                    i32.add
                    local.tee 19
                    i32.const 10
                    i32.lt_u
                    br_if 0 (;@8;)
                  end
                  local.get 23
                  i32.const 0
                  i32.lt_s
                  br_if 5 (;@2;)
                end
                i32.const 0
                local.set 16
                i32.const -1
                local.set 24
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 21
                    i32.load8_u
                    i32.const 46
                    i32.eq
                    br_if 0 (;@8;)
                    local.get 21
                    local.set 1
                    i32.const 0
                    local.set 25
                    br 1 (;@7;)
                  end
                  block  ;; label = @8
                    local.get 21
                    i32.load8_s offset=1
                    local.tee 19
                    i32.const 42
                    i32.ne
                    br_if 0 (;@8;)
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 21
                        i32.load8_s offset=2
                        i32.const -48
                        i32.add
                        local.tee 1
                        i32.const 9
                        i32.gt_u
                        br_if 0 (;@10;)
                        local.get 21
                        i32.load8_u offset=3
                        i32.const 36
                        i32.ne
                        br_if 0 (;@10;)
                        local.get 4
                        local.get 1
                        i32.const 2
                        i32.shl
                        i32.add
                        i32.const 10
                        i32.store
                        local.get 21
                        i32.const 4
                        i32.add
                        local.set 1
                        local.get 21
                        i32.load8_s offset=2
                        i32.const 3
                        i32.shl
                        local.get 3
                        i32.add
                        i32.const -384
                        i32.add
                        i32.load
                        local.set 24
                        br 1 (;@9;)
                      end
                      local.get 14
                      br_if 7 (;@2;)
                      local.get 21
                      i32.const 2
                      i32.add
                      local.set 1
                      block  ;; label = @10
                        local.get 0
                        br_if 0 (;@10;)
                        i32.const 0
                        local.set 24
                        br 1 (;@9;)
                      end
                      local.get 2
                      local.get 2
                      i32.load
                      local.tee 19
                      i32.const 4
                      i32.add
                      i32.store
                      local.get 19
                      i32.load
                      local.set 24
                    end
                    local.get 24
                    i32.const -1
                    i32.xor
                    i32.const 31
                    i32.shr_u
                    local.set 25
                    br 1 (;@7;)
                  end
                  local.get 21
                  i32.const 1
                  i32.add
                  local.set 1
                  block  ;; label = @8
                    local.get 19
                    i32.const -48
                    i32.add
                    local.tee 26
                    i32.const 9
                    i32.le_u
                    br_if 0 (;@8;)
                    i32.const 1
                    local.set 25
                    i32.const 0
                    local.set 24
                    br 1 (;@7;)
                  end
                  i32.const 0
                  local.set 21
                  local.get 1
                  local.set 19
                  loop  ;; label = @8
                    i32.const -1
                    local.set 24
                    block  ;; label = @9
                      local.get 21
                      i32.const 214748364
                      i32.gt_u
                      br_if 0 (;@9;)
                      i32.const -1
                      local.get 21
                      i32.const 10
                      i32.mul
                      local.tee 1
                      local.get 26
                      i32.add
                      local.get 26
                      i32.const 2147483647
                      local.get 1
                      i32.sub
                      i32.gt_s
                      select
                      local.set 24
                    end
                    i32.const 1
                    local.set 25
                    local.get 19
                    i32.load8_s offset=1
                    local.set 26
                    local.get 19
                    i32.const 1
                    i32.add
                    local.tee 1
                    local.set 19
                    local.get 24
                    local.set 21
                    local.get 26
                    i32.const -48
                    i32.add
                    local.tee 26
                    i32.const 10
                    i32.lt_u
                    br_if 0 (;@8;)
                  end
                end
                loop  ;; label = @7
                  local.get 16
                  local.set 21
                  local.get 1
                  i32.load8_s
                  i32.const -65
                  i32.add
                  local.tee 16
                  i32.const 57
                  i32.gt_u
                  br_if 5 (;@2;)
                  local.get 1
                  i32.const 1
                  i32.add
                  local.set 1
                  i32.const 66384
                  i32.const 12848
                  i32.add
                  local.get 21
                  i32.const 58
                  i32.mul
                  i32.add
                  local.get 16
                  i32.add
                  i32.load8_u
                  local.tee 16
                  i32.const -1
                  i32.add
                  i32.const 8
                  i32.lt_u
                  br_if 0 (;@7;)
                end
                local.get 16
                i32.eqz
                br_if 4 (;@2;)
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 16
                      i32.const 27
                      i32.ne
                      br_if 0 (;@9;)
                      i32.const -1
                      local.set 19
                      local.get 22
                      i32.const -1
                      i32.le_s
                      br_if 1 (;@8;)
                      br 8 (;@1;)
                    end
                    local.get 22
                    i32.const 0
                    i32.lt_s
                    br_if 1 (;@7;)
                    local.get 4
                    local.get 22
                    i32.const 2
                    i32.shl
                    i32.add
                    local.get 16
                    i32.store
                    local.get 5
                    local.get 3
                    local.get 22
                    i32.const 3
                    i32.shl
                    i32.add
                    i64.load
                    i64.store offset=56
                  end
                  i32.const 0
                  local.set 16
                  local.get 0
                  i32.eqz
                  br_if 4 (;@3;)
                  br 3 (;@4;)
                end
                local.get 0
                br_if 1 (;@5;)
              end
              i32.const 0
              local.set 19
              br 4 (;@1;)
            end
            local.get 5
            i32.const 56
            i32.add
            local.get 16
            local.get 2
            call $pop_arg
          end
          local.get 18
          i32.const -65537
          i32.and
          local.tee 26
          local.get 18
          local.get 18
          i32.const 8192
          i32.and
          select
          local.set 22
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              block  ;; label = @22
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    local.get 1
                                                    i32.const -1
                                                    i32.add
                                                    i32.load8_s
                                                    local.tee 16
                                                    i32.const -33
                                                    i32.and
                                                    local.get 16
                                                    local.get 16
                                                    i32.const 15
                                                    i32.and
                                                    i32.const 3
                                                    i32.eq
                                                    select
                                                    local.get 16
                                                    local.get 21
                                                    select
                                                    local.tee 27
                                                    i32.const -83
                                                    i32.add
                                                    local.tee 16
                                                    i32.const 37
                                                    i32.le_u
                                                    br_if 0 (;@24;)
                                                    local.get 27
                                                    i32.const -65
                                                    i32.add
                                                    local.tee 16
                                                    i32.const 6
                                                    i32.gt_u
                                                    br_if 1 (;@23;)
                                                    block  ;; label = @25
                                                      local.get 16
                                                      br_table 3 (;@22;) 2 (;@23;) 0 (;@25;) 2 (;@23;) 3 (;@22;) 3 (;@22;) 3 (;@22;) 3 (;@22;)
                                                    end
                                                    local.get 5
                                                    i32.const 0
                                                    i32.store offset=12
                                                    local.get 5
                                                    local.get 5
                                                    i64.load offset=56
                                                    i64.store32 offset=8
                                                    local.get 5
                                                    local.get 5
                                                    i32.const 8
                                                    i32.add
                                                    i32.store offset=56
                                                    i32.const -1
                                                    local.set 24
                                                    local.get 5
                                                    i32.const 8
                                                    i32.add
                                                    local.set 18
                                                    br 4 (;@20;)
                                                  end
                                                  local.get 16
                                                  br_table 2 (;@21;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 13 (;@10;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 1 (;@22;) 0 (;@23;) 9 (;@14;) 10 (;@13;) 1 (;@22;) 1 (;@22;) 1 (;@22;) 0 (;@23;) 10 (;@13;) 0 (;@23;) 0 (;@23;) 0 (;@23;) 7 (;@16;) 14 (;@9;) 11 (;@12;) 12 (;@11;) 0 (;@23;) 0 (;@23;) 6 (;@17;) 0 (;@23;) 15 (;@8;) 0 (;@23;) 0 (;@23;) 13 (;@10;) 2 (;@21;)
                                                end
                                                i32.const 66384
                                                i32.const 12816
                                                i32.add
                                                local.set 28
                                                i32.const 0
                                                local.set 21
                                                br 17 (;@5;)
                                              end
                                              i32.const -1
                                              local.set 19
                                              block  ;; label = @22
                                                local.get 24
                                                i32.const -1
                                                i32.gt_s
                                                br_if 0 (;@22;)
                                                local.get 25
                                                br_if 21 (;@1;)
                                              end
                                              local.get 5
                                              f64.load offset=56
                                              local.set 29
                                              local.get 5
                                              i32.const 0
                                              i32.store offset=108
                                              block  ;; label = @22
                                                block  ;; label = @23
                                                  local.get 29
                                                  i64.reinterpret_f64
                                                  i64.const -1
                                                  i64.gt_s
                                                  br_if 0 (;@23;)
                                                  i32.const 66384
                                                  i32.const 13424
                                                  i32.add
                                                  local.set 30
                                                  local.get 29
                                                  f64.neg
                                                  local.set 29
                                                  i32.const 1
                                                  local.set 31
                                                  br 1 (;@22;)
                                                end
                                                i32.const 66384
                                                local.set 16
                                                block  ;; label = @23
                                                  local.get 22
                                                  i32.const 2048
                                                  i32.and
                                                  i32.eqz
                                                  br_if 0 (;@23;)
                                                  local.get 16
                                                  i32.const 13424
                                                  i32.add
                                                  i32.const 3
                                                  i32.add
                                                  local.set 30
                                                  i32.const 1
                                                  local.set 31
                                                  br 1 (;@22;)
                                                end
                                                i32.const 66384
                                                i32.const 13424
                                                i32.add
                                                local.tee 16
                                                i32.const 6
                                                i32.add
                                                local.get 16
                                                i32.const 1
                                                i32.add
                                                local.get 22
                                                i32.const 1
                                                i32.and
                                                local.tee 31
                                                select
                                                local.set 30
                                              end
                                              block  ;; label = @22
                                                block  ;; label = @23
                                                  local.get 29
                                                  f64.abs
                                                  local.tee 32
                                                  f64.const inf (;=inf;)
                                                  f64.ne
                                                  local.get 32
                                                  local.get 32
                                                  f64.eq
                                                  i32.and
                                                  br_if 0 (;@23;)
                                                  local.get 0
                                                  i32.const 32
                                                  local.get 23
                                                  local.get 31
                                                  i32.const 3
                                                  i32.add
                                                  local.tee 16
                                                  local.get 26
                                                  call $pad
                                                  i32.const 66384
                                                  local.set 18
                                                  block  ;; label = @24
                                                    local.get 0
                                                    i32.load
                                                    local.tee 17
                                                    i32.const 32
                                                    i32.and
                                                    br_if 0 (;@24;)
                                                    local.get 0
                                                    local.get 30
                                                    local.get 31
                                                    local.get 0
                                                    i32.load offset=32
                                                    call_indirect (type 18)
                                                    drop
                                                    local.get 0
                                                    i32.load
                                                    local.set 17
                                                  end
                                                  block  ;; label = @24
                                                    local.get 17
                                                    i32.const 32
                                                    i32.and
                                                    br_if 0 (;@24;)
                                                    local.get 0
                                                    local.get 18
                                                    i32.const 13451
                                                    i32.add
                                                    local.get 18
                                                    i32.const 13455
                                                    i32.add
                                                    local.get 27
                                                    i32.const 32
                                                    i32.and
                                                    i32.const 5
                                                    i32.shr_u
                                                    local.tee 17
                                                    select
                                                    local.get 18
                                                    i32.const 13443
                                                    i32.add
                                                    local.get 18
                                                    i32.const 13447
                                                    i32.add
                                                    local.get 17
                                                    select
                                                    local.get 29
                                                    local.get 29
                                                    f64.ne
                                                    select
                                                    i32.const 3
                                                    local.get 0
                                                    i32.load offset=32
                                                    call_indirect (type 18)
                                                    drop
                                                  end
                                                  local.get 0
                                                  i32.const 32
                                                  local.get 23
                                                  local.get 16
                                                  local.get 22
                                                  i32.const 8192
                                                  i32.xor
                                                  call $pad
                                                  local.get 23
                                                  local.get 16
                                                  local.get 16
                                                  local.get 23
                                                  i32.lt_s
                                                  select
                                                  local.set 16
                                                  br 1 (;@22;)
                                                end
                                                block  ;; label = @23
                                                  local.get 29
                                                  local.get 5
                                                  i32.const 108
                                                  i32.add
                                                  call $frexp
                                                  local.tee 29
                                                  local.get 29
                                                  f64.add
                                                  local.tee 29
                                                  f64.const 0x0p+0 (;=0;)
                                                  f64.eq
                                                  br_if 0 (;@23;)
                                                  local.get 5
                                                  local.get 5
                                                  i32.load offset=108
                                                  i32.const -1
                                                  i32.add
                                                  i32.store offset=108
                                                end
                                                block  ;; label = @23
                                                  local.get 27
                                                  i32.const 32
                                                  i32.or
                                                  local.tee 33
                                                  i32.const 97
                                                  i32.ne
                                                  br_if 0 (;@23;)
                                                  local.get 30
                                                  i32.const 9
                                                  i32.add
                                                  local.get 30
                                                  local.get 27
                                                  i32.const 32
                                                  i32.and
                                                  local.tee 20
                                                  select
                                                  local.set 28
                                                  block  ;; label = @24
                                                    local.get 24
                                                    i32.const 11
                                                    i32.gt_u
                                                    br_if 0 (;@24;)
                                                    i32.const 12
                                                    local.get 24
                                                    i32.sub
                                                    i32.eqz
                                                    br_if 0 (;@24;)
                                                    local.get 24
                                                    i32.const -12
                                                    i32.add
                                                    local.set 16
                                                    f64.const 0x1p+4 (;=16;)
                                                    local.set 32
                                                    loop  ;; label = @25
                                                      local.get 32
                                                      f64.const 0x1p+4 (;=16;)
                                                      f64.mul
                                                      local.set 32
                                                      local.get 16
                                                      i32.const 1
                                                      i32.add
                                                      local.tee 18
                                                      local.get 16
                                                      i32.ge_u
                                                      local.set 17
                                                      local.get 18
                                                      local.set 16
                                                      local.get 17
                                                      br_if 0 (;@25;)
                                                    end
                                                    block  ;; label = @25
                                                      local.get 28
                                                      i32.load8_u
                                                      i32.const 45
                                                      i32.ne
                                                      br_if 0 (;@25;)
                                                      local.get 32
                                                      local.get 29
                                                      f64.neg
                                                      local.get 32
                                                      f64.sub
                                                      f64.add
                                                      f64.neg
                                                      local.set 29
                                                      br 1 (;@24;)
                                                    end
                                                    local.get 29
                                                    local.get 32
                                                    f64.add
                                                    local.get 32
                                                    f64.sub
                                                    local.set 29
                                                  end
                                                  block  ;; label = @24
                                                    local.get 5
                                                    i32.load offset=108
                                                    local.tee 16
                                                    local.get 16
                                                    i32.const 31
                                                    i32.shr_s
                                                    local.tee 16
                                                    i32.add
                                                    local.get 16
                                                    i32.xor
                                                    i64.extend_i32_u
                                                    local.get 12
                                                    call $fmt_u
                                                    local.tee 16
                                                    local.get 12
                                                    i32.ne
                                                    br_if 0 (;@24;)
                                                    local.get 5
                                                    i32.const 48
                                                    i32.store8 offset=79
                                                    local.get 8
                                                    local.set 16
                                                  end
                                                  local.get 31
                                                  i32.const 2
                                                  i32.or
                                                  local.set 26
                                                  local.get 5
                                                  i32.load offset=108
                                                  local.set 18
                                                  local.get 16
                                                  i32.const -2
                                                  i32.add
                                                  local.tee 25
                                                  local.get 27
                                                  i32.const 15
                                                  i32.add
                                                  i32.store8
                                                  local.get 16
                                                  i32.const -1
                                                  i32.add
                                                  i32.const 45
                                                  i32.const 43
                                                  local.get 18
                                                  i32.const 0
                                                  i32.lt_s
                                                  select
                                                  i32.store8
                                                  local.get 22
                                                  i32.const 8
                                                  i32.and
                                                  local.set 21
                                                  local.get 5
                                                  i32.const 80
                                                  i32.add
                                                  local.set 18
                                                  loop  ;; label = @24
                                                    local.get 18
                                                    local.set 16
                                                    i32.const 66384
                                                    i32.const 13408
                                                    i32.add
                                                    local.set 17
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        local.get 29
                                                        f64.abs
                                                        f64.const 0x1p+31 (;=2.14748e+09;)
                                                        f64.lt
                                                        i32.eqz
                                                        br_if 0 (;@26;)
                                                        local.get 29
                                                        i32.trunc_f64_s
                                                        local.set 18
                                                        br 1 (;@25;)
                                                      end
                                                      i32.const -2147483648
                                                      local.set 18
                                                    end
                                                    local.get 16
                                                    local.get 17
                                                    local.get 18
                                                    i32.add
                                                    i32.load8_u
                                                    local.get 20
                                                    i32.or
                                                    i32.store8
                                                    local.get 29
                                                    local.get 18
                                                    f64.convert_i32_s
                                                    f64.sub
                                                    f64.const 0x1p+4 (;=16;)
                                                    f64.mul
                                                    local.set 29
                                                    block  ;; label = @25
                                                      local.get 16
                                                      i32.const 1
                                                      i32.add
                                                      local.tee 18
                                                      local.get 5
                                                      i32.const 80
                                                      i32.add
                                                      i32.sub
                                                      i32.const 1
                                                      i32.ne
                                                      br_if 0 (;@25;)
                                                      block  ;; label = @26
                                                        local.get 21
                                                        br_if 0 (;@26;)
                                                        local.get 24
                                                        i32.const 0
                                                        i32.gt_s
                                                        br_if 0 (;@26;)
                                                        local.get 29
                                                        f64.const 0x0p+0 (;=0;)
                                                        f64.eq
                                                        br_if 1 (;@25;)
                                                      end
                                                      local.get 16
                                                      i32.const 46
                                                      i32.store8 offset=1
                                                      local.get 16
                                                      i32.const 2
                                                      i32.add
                                                      local.set 18
                                                    end
                                                    local.get 29
                                                    f64.const 0x0p+0 (;=0;)
                                                    f64.ne
                                                    br_if 0 (;@24;)
                                                  end
                                                  i32.const -1
                                                  local.set 16
                                                  i32.const 2147483645
                                                  local.get 26
                                                  local.get 12
                                                  local.get 25
                                                  i32.sub
                                                  local.tee 21
                                                  i32.add
                                                  local.tee 20
                                                  i32.sub
                                                  local.get 24
                                                  i32.lt_s
                                                  br_if 1 (;@22;)
                                                  local.get 0
                                                  i32.const 32
                                                  local.get 23
                                                  local.get 20
                                                  local.get 24
                                                  i32.const 2
                                                  i32.add
                                                  local.get 18
                                                  local.get 5
                                                  i32.const 80
                                                  i32.add
                                                  i32.sub
                                                  local.tee 17
                                                  local.get 7
                                                  local.get 18
                                                  i32.add
                                                  local.get 24
                                                  i32.lt_s
                                                  select
                                                  local.get 17
                                                  local.get 24
                                                  select
                                                  local.tee 18
                                                  i32.add
                                                  local.tee 16
                                                  local.get 22
                                                  call $pad
                                                  block  ;; label = @24
                                                    local.get 0
                                                    i32.load8_u
                                                    i32.const 32
                                                    i32.and
                                                    br_if 0 (;@24;)
                                                    local.get 0
                                                    local.get 28
                                                    local.get 26
                                                    local.get 0
                                                    i32.load offset=32
                                                    call_indirect (type 18)
                                                    drop
                                                  end
                                                  local.get 0
                                                  i32.const 48
                                                  local.get 23
                                                  local.get 16
                                                  local.get 22
                                                  i32.const 65536
                                                  i32.xor
                                                  call $pad
                                                  block  ;; label = @24
                                                    local.get 0
                                                    i32.load8_u
                                                    i32.const 32
                                                    i32.and
                                                    br_if 0 (;@24;)
                                                    local.get 0
                                                    local.get 5
                                                    i32.const 80
                                                    i32.add
                                                    local.get 17
                                                    local.get 0
                                                    i32.load offset=32
                                                    call_indirect (type 18)
                                                    drop
                                                  end
                                                  local.get 0
                                                  i32.const 48
                                                  local.get 18
                                                  local.get 17
                                                  i32.sub
                                                  i32.const 0
                                                  i32.const 0
                                                  call $pad
                                                  block  ;; label = @24
                                                    local.get 0
                                                    i32.load8_u
                                                    i32.const 32
                                                    i32.and
                                                    br_if 0 (;@24;)
                                                    local.get 0
                                                    local.get 25
                                                    local.get 21
                                                    local.get 0
                                                    i32.load offset=32
                                                    call_indirect (type 18)
                                                    drop
                                                  end
                                                  local.get 0
                                                  i32.const 32
                                                  local.get 23
                                                  local.get 16
                                                  local.get 22
                                                  i32.const 8192
                                                  i32.xor
                                                  call $pad
                                                  local.get 23
                                                  local.get 16
                                                  local.get 16
                                                  local.get 23
                                                  i32.lt_s
                                                  select
                                                  local.set 16
                                                  br 1 (;@22;)
                                                end
                                                local.get 24
                                                i32.const 0
                                                i32.lt_s
                                                local.set 16
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    local.get 29
                                                    f64.const 0x0p+0 (;=0;)
                                                    f64.ne
                                                    br_if 0 (;@24;)
                                                    local.get 5
                                                    i32.load offset=108
                                                    local.set 20
                                                    br 1 (;@23;)
                                                  end
                                                  local.get 5
                                                  local.get 5
                                                  i32.load offset=108
                                                  i32.const -28
                                                  i32.add
                                                  local.tee 20
                                                  i32.store offset=108
                                                  local.get 29
                                                  f64.const 0x1p+28 (;=2.68435e+08;)
                                                  f64.mul
                                                  local.set 29
                                                end
                                                i32.const 6
                                                local.get 24
                                                local.get 16
                                                select
                                                local.set 34
                                                local.get 5
                                                i32.const 112
                                                i32.add
                                                local.get 11
                                                local.get 20
                                                i32.const 0
                                                i32.lt_s
                                                select
                                                local.tee 35
                                                local.set 17
                                                loop  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      local.get 29
                                                      f64.const 0x1p+32 (;=4.29497e+09;)
                                                      f64.lt
                                                      local.get 29
                                                      f64.const 0x0p+0 (;=0;)
                                                      f64.ge
                                                      i32.and
                                                      i32.eqz
                                                      br_if 0 (;@25;)
                                                      local.get 29
                                                      i32.trunc_f64_u
                                                      local.set 16
                                                      br 1 (;@24;)
                                                    end
                                                    i32.const 0
                                                    local.set 16
                                                  end
                                                  local.get 17
                                                  local.get 16
                                                  i32.store
                                                  local.get 17
                                                  i32.const 4
                                                  i32.add
                                                  local.set 17
                                                  local.get 29
                                                  local.get 16
                                                  f64.convert_i32_u
                                                  f64.sub
                                                  f64.const 0x1.dcd65p+29 (;=1e+09;)
                                                  f64.mul
                                                  local.tee 29
                                                  f64.const 0x0p+0 (;=0;)
                                                  f64.ne
                                                  br_if 0 (;@23;)
                                                end
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    local.get 20
                                                    i32.const 1
                                                    i32.ge_s
                                                    br_if 0 (;@24;)
                                                    local.get 17
                                                    local.set 16
                                                    local.get 35
                                                    local.set 18
                                                    br 1 (;@23;)
                                                  end
                                                  local.get 35
                                                  local.set 18
                                                  loop  ;; label = @24
                                                    local.get 20
                                                    i32.const 29
                                                    local.get 20
                                                    i32.const 29
                                                    i32.lt_s
                                                    select
                                                    local.set 20
                                                    block  ;; label = @25
                                                      local.get 17
                                                      i32.const -4
                                                      i32.add
                                                      local.tee 16
                                                      local.get 18
                                                      i32.lt_u
                                                      br_if 0 (;@25;)
                                                      local.get 20
                                                      i64.extend_i32_u
                                                      local.set 36
                                                      i64.const 0
                                                      local.set 37
                                                      loop  ;; label = @26
                                                        local.get 16
                                                        local.get 16
                                                        i64.load32_u
                                                        local.get 36
                                                        i64.shl
                                                        local.get 37
                                                        i64.const 4294967295
                                                        i64.and
                                                        i64.add
                                                        local.tee 37
                                                        local.get 37
                                                        i64.const 1000000000
                                                        i64.div_u
                                                        local.tee 37
                                                        i64.const 1000000000
                                                        i64.mul
                                                        i64.sub
                                                        i64.store32
                                                        local.get 16
                                                        i32.const -4
                                                        i32.add
                                                        local.tee 16
                                                        local.get 18
                                                        i32.ge_u
                                                        br_if 0 (;@26;)
                                                      end
                                                      local.get 37
                                                      i32.wrap_i64
                                                      local.tee 16
                                                      i32.eqz
                                                      br_if 0 (;@25;)
                                                      local.get 18
                                                      i32.const -4
                                                      i32.add
                                                      local.tee 18
                                                      local.get 16
                                                      i32.store
                                                    end
                                                    block  ;; label = @25
                                                      loop  ;; label = @26
                                                        local.get 17
                                                        local.tee 16
                                                        local.get 18
                                                        i32.le_u
                                                        br_if 1 (;@25;)
                                                        local.get 16
                                                        i32.const -4
                                                        i32.add
                                                        local.tee 17
                                                        i32.load
                                                        i32.eqz
                                                        br_if 0 (;@26;)
                                                      end
                                                    end
                                                    local.get 5
                                                    local.get 5
                                                    i32.load offset=108
                                                    local.get 20
                                                    i32.sub
                                                    local.tee 20
                                                    i32.store offset=108
                                                    local.get 16
                                                    local.set 17
                                                    local.get 20
                                                    i32.const 0
                                                    i32.gt_s
                                                    br_if 0 (;@24;)
                                                  end
                                                end
                                                block  ;; label = @23
                                                  local.get 20
                                                  i32.const -1
                                                  i32.gt_s
                                                  br_if 0 (;@23;)
                                                  local.get 34
                                                  i32.const 25
                                                  i32.add
                                                  i32.const 9
                                                  i32.div_u
                                                  i32.const 1
                                                  i32.add
                                                  local.set 28
                                                  loop  ;; label = @24
                                                    i32.const 9
                                                    i32.const 0
                                                    local.get 20
                                                    i32.sub
                                                    local.get 20
                                                    i32.const -9
                                                    i32.lt_s
                                                    select
                                                    local.set 24
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        local.get 18
                                                        local.get 16
                                                        i32.lt_u
                                                        br_if 0 (;@26;)
                                                        local.get 18
                                                        local.get 18
                                                        i32.const 4
                                                        i32.add
                                                        local.get 18
                                                        i32.load
                                                        select
                                                        local.set 18
                                                        br 1 (;@25;)
                                                      end
                                                      i32.const 1000000000
                                                      local.get 24
                                                      i32.shr_u
                                                      local.set 26
                                                      i32.const -1
                                                      local.get 24
                                                      i32.shl
                                                      i32.const -1
                                                      i32.xor
                                                      local.set 25
                                                      i32.const 0
                                                      local.set 20
                                                      local.get 18
                                                      local.set 17
                                                      loop  ;; label = @26
                                                        local.get 17
                                                        local.get 17
                                                        i32.load
                                                        local.tee 21
                                                        local.get 24
                                                        i32.shr_u
                                                        local.get 20
                                                        i32.add
                                                        i32.store
                                                        local.get 21
                                                        local.get 25
                                                        i32.and
                                                        local.get 26
                                                        i32.mul
                                                        local.set 20
                                                        local.get 17
                                                        i32.const 4
                                                        i32.add
                                                        local.tee 17
                                                        local.get 16
                                                        i32.lt_u
                                                        br_if 0 (;@26;)
                                                      end
                                                      local.get 18
                                                      local.get 18
                                                      i32.const 4
                                                      i32.add
                                                      local.get 18
                                                      i32.load
                                                      select
                                                      local.set 18
                                                      local.get 20
                                                      i32.eqz
                                                      br_if 0 (;@25;)
                                                      local.get 16
                                                      local.get 20
                                                      i32.store
                                                      local.get 16
                                                      i32.const 4
                                                      i32.add
                                                      local.set 16
                                                    end
                                                    local.get 5
                                                    local.get 5
                                                    i32.load offset=108
                                                    local.get 24
                                                    i32.add
                                                    local.tee 20
                                                    i32.store offset=108
                                                    local.get 35
                                                    local.get 18
                                                    local.get 33
                                                    i32.const 102
                                                    i32.eq
                                                    select
                                                    local.tee 17
                                                    local.get 28
                                                    i32.const 2
                                                    i32.shl
                                                    i32.add
                                                    local.get 16
                                                    local.get 16
                                                    local.get 17
                                                    i32.sub
                                                    i32.const 2
                                                    i32.shr_s
                                                    local.get 28
                                                    i32.gt_s
                                                    select
                                                    local.set 16
                                                    local.get 20
                                                    i32.const 0
                                                    i32.lt_s
                                                    br_if 0 (;@24;)
                                                  end
                                                end
                                                i32.const 0
                                                local.set 20
                                                block  ;; label = @23
                                                  local.get 18
                                                  local.get 16
                                                  i32.ge_u
                                                  br_if 0 (;@23;)
                                                  local.get 35
                                                  local.get 18
                                                  i32.sub
                                                  i32.const 2
                                                  i32.shr_s
                                                  i32.const 9
                                                  i32.mul
                                                  local.set 20
                                                  local.get 18
                                                  i32.load
                                                  local.tee 21
                                                  i32.const 10
                                                  i32.lt_u
                                                  br_if 0 (;@23;)
                                                  i32.const 10
                                                  local.set 17
                                                  loop  ;; label = @24
                                                    local.get 20
                                                    i32.const 1
                                                    i32.add
                                                    local.set 20
                                                    local.get 21
                                                    local.get 17
                                                    i32.const 10
                                                    i32.mul
                                                    local.tee 17
                                                    i32.ge_u
                                                    br_if 0 (;@24;)
                                                  end
                                                end
                                                block  ;; label = @23
                                                  local.get 34
                                                  i32.const 0
                                                  local.get 20
                                                  local.get 33
                                                  i32.const 102
                                                  i32.eq
                                                  select
                                                  local.tee 21
                                                  i32.sub
                                                  local.get 34
                                                  i32.const 0
                                                  i32.ne
                                                  local.get 33
                                                  i32.const 103
                                                  i32.eq
                                                  local.tee 26
                                                  i32.and
                                                  local.tee 25
                                                  i32.sub
                                                  local.tee 17
                                                  local.get 16
                                                  local.get 35
                                                  i32.sub
                                                  i32.const 2
                                                  i32.shr_s
                                                  i32.const 9
                                                  i32.mul
                                                  i32.const -9
                                                  i32.add
                                                  i32.ge_s
                                                  br_if 0 (;@23;)
                                                  local.get 17
                                                  i32.const 9216
                                                  i32.add
                                                  local.tee 28
                                                  i32.const 9
                                                  i32.div_s
                                                  local.tee 33
                                                  i32.const 2
                                                  i32.shl
                                                  local.get 35
                                                  i32.add
                                                  local.tee 38
                                                  i32.const -4092
                                                  i32.add
                                                  local.set 24
                                                  i32.const 10
                                                  local.set 17
                                                  block  ;; label = @24
                                                    local.get 28
                                                    local.get 33
                                                    i32.const 9
                                                    i32.mul
                                                    local.tee 33
                                                    i32.sub
                                                    i32.const 7
                                                    i32.gt_s
                                                    br_if 0 (;@24;)
                                                    local.get 34
                                                    i32.const 0
                                                    local.get 25
                                                    i32.sub
                                                    i32.add
                                                    local.get 21
                                                    i32.sub
                                                    local.get 33
                                                    i32.sub
                                                    i32.const 9215
                                                    i32.add
                                                    local.set 21
                                                    i32.const 10
                                                    local.set 17
                                                    loop  ;; label = @25
                                                      local.get 17
                                                      i32.const 10
                                                      i32.mul
                                                      local.set 17
                                                      local.get 21
                                                      i32.const 1
                                                      i32.add
                                                      local.tee 21
                                                      i32.const 7
                                                      i32.lt_s
                                                      br_if 0 (;@25;)
                                                    end
                                                  end
                                                  local.get 24
                                                  i32.load
                                                  local.tee 25
                                                  local.get 25
                                                  local.get 17
                                                  i32.div_u
                                                  local.tee 28
                                                  local.get 17
                                                  i32.mul
                                                  i32.sub
                                                  local.set 21
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      local.get 24
                                                      i32.const 4
                                                      i32.add
                                                      local.tee 33
                                                      local.get 16
                                                      i32.ne
                                                      br_if 0 (;@25;)
                                                      local.get 21
                                                      i32.eqz
                                                      br_if 1 (;@24;)
                                                    end
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        local.get 28
                                                        i32.const 1
                                                        i32.and
                                                        br_if 0 (;@26;)
                                                        f64.const 0x1p+53 (;=9.0072e+15;)
                                                        local.set 29
                                                        local.get 24
                                                        local.get 18
                                                        i32.le_u
                                                        br_if 1 (;@25;)
                                                        local.get 17
                                                        i32.const 1000000000
                                                        i32.ne
                                                        br_if 1 (;@25;)
                                                        local.get 24
                                                        i32.const -4
                                                        i32.add
                                                        i32.load8_u
                                                        i32.const 1
                                                        i32.and
                                                        i32.eqz
                                                        br_if 1 (;@25;)
                                                      end
                                                      f64.const 0x1.0000000000001p+53 (;=9.0072e+15;)
                                                      local.set 29
                                                    end
                                                    f64.const 0x1p-1 (;=0.5;)
                                                    f64.const 0x1p+0 (;=1;)
                                                    f64.const 0x1.8p+0 (;=1.5;)
                                                    local.get 21
                                                    local.get 17
                                                    i32.const 1
                                                    i32.shr_u
                                                    local.tee 28
                                                    i32.eq
                                                    select
                                                    f64.const 0x1.8p+0 (;=1.5;)
                                                    local.get 33
                                                    local.get 16
                                                    i32.eq
                                                    select
                                                    local.get 21
                                                    local.get 28
                                                    i32.lt_u
                                                    select
                                                    local.set 32
                                                    block  ;; label = @25
                                                      local.get 31
                                                      i32.eqz
                                                      br_if 0 (;@25;)
                                                      local.get 30
                                                      i32.load8_u
                                                      i32.const 45
                                                      i32.ne
                                                      br_if 0 (;@25;)
                                                      local.get 32
                                                      f64.neg
                                                      local.set 32
                                                      local.get 29
                                                      f64.neg
                                                      local.set 29
                                                    end
                                                    local.get 24
                                                    local.get 25
                                                    local.get 21
                                                    i32.sub
                                                    local.tee 21
                                                    i32.store
                                                    local.get 29
                                                    local.get 32
                                                    f64.add
                                                    local.get 29
                                                    f64.eq
                                                    br_if 0 (;@24;)
                                                    local.get 24
                                                    local.get 21
                                                    local.get 17
                                                    i32.add
                                                    local.tee 17
                                                    i32.store
                                                    block  ;; label = @25
                                                      local.get 17
                                                      i32.const 1000000000
                                                      i32.lt_u
                                                      br_if 0 (;@25;)
                                                      local.get 38
                                                      i32.const -4096
                                                      i32.add
                                                      local.set 17
                                                      loop  ;; label = @26
                                                        local.get 17
                                                        i32.const 4
                                                        i32.add
                                                        i32.const 0
                                                        i32.store
                                                        block  ;; label = @27
                                                          local.get 17
                                                          local.get 18
                                                          i32.ge_u
                                                          br_if 0 (;@27;)
                                                          local.get 18
                                                          i32.const -4
                                                          i32.add
                                                          local.tee 18
                                                          i32.const 0
                                                          i32.store
                                                        end
                                                        local.get 17
                                                        local.get 17
                                                        i32.load
                                                        i32.const 1
                                                        i32.add
                                                        local.tee 20
                                                        i32.store
                                                        local.get 17
                                                        i32.const -4
                                                        i32.add
                                                        local.set 17
                                                        local.get 20
                                                        i32.const 999999999
                                                        i32.gt_u
                                                        br_if 0 (;@26;)
                                                      end
                                                      local.get 17
                                                      i32.const 4
                                                      i32.add
                                                      local.set 24
                                                    end
                                                    local.get 35
                                                    local.get 18
                                                    i32.sub
                                                    i32.const 2
                                                    i32.shr_s
                                                    i32.const 9
                                                    i32.mul
                                                    local.set 20
                                                    local.get 18
                                                    i32.load
                                                    local.tee 21
                                                    i32.const 10
                                                    i32.lt_u
                                                    br_if 0 (;@24;)
                                                    i32.const 10
                                                    local.set 17
                                                    loop  ;; label = @25
                                                      local.get 20
                                                      i32.const 1
                                                      i32.add
                                                      local.set 20
                                                      local.get 21
                                                      local.get 17
                                                      i32.const 10
                                                      i32.mul
                                                      local.tee 17
                                                      i32.ge_u
                                                      br_if 0 (;@25;)
                                                    end
                                                  end
                                                  local.get 24
                                                  i32.const 4
                                                  i32.add
                                                  local.tee 17
                                                  local.get 16
                                                  local.get 16
                                                  local.get 17
                                                  i32.gt_u
                                                  select
                                                  local.set 16
                                                end
                                                block  ;; label = @23
                                                  loop  ;; label = @24
                                                    block  ;; label = @25
                                                      local.get 16
                                                      local.tee 17
                                                      local.get 18
                                                      i32.gt_u
                                                      br_if 0 (;@25;)
                                                      i32.const 0
                                                      local.set 28
                                                      br 2 (;@23;)
                                                    end
                                                    local.get 17
                                                    i32.const -4
                                                    i32.add
                                                    local.tee 16
                                                    i32.load
                                                    i32.eqz
                                                    br_if 0 (;@24;)
                                                  end
                                                  i32.const 1
                                                  local.set 28
                                                end
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    local.get 26
                                                    br_if 0 (;@24;)
                                                    local.get 22
                                                    i32.const 8
                                                    i32.and
                                                    local.set 26
                                                    br 1 (;@23;)
                                                  end
                                                  local.get 20
                                                  i32.const -1
                                                  i32.xor
                                                  i32.const -1
                                                  local.get 34
                                                  i32.const 1
                                                  local.get 34
                                                  select
                                                  local.tee 16
                                                  local.get 20
                                                  i32.gt_s
                                                  local.get 20
                                                  i32.const -5
                                                  i32.gt_s
                                                  i32.and
                                                  local.tee 21
                                                  select
                                                  local.get 16
                                                  i32.add
                                                  local.set 34
                                                  i32.const -1
                                                  i32.const -2
                                                  local.get 21
                                                  select
                                                  local.get 27
                                                  i32.add
                                                  local.set 27
                                                  local.get 22
                                                  i32.const 8
                                                  i32.and
                                                  local.tee 26
                                                  br_if 0 (;@23;)
                                                  i32.const 9
                                                  local.set 16
                                                  block  ;; label = @24
                                                    local.get 28
                                                    i32.eqz
                                                    br_if 0 (;@24;)
                                                    local.get 17
                                                    i32.const -4
                                                    i32.add
                                                    i32.load
                                                    local.tee 24
                                                    i32.eqz
                                                    br_if 0 (;@24;)
                                                    i32.const 0
                                                    local.set 16
                                                    local.get 24
                                                    i32.const 10
                                                    i32.rem_u
                                                    br_if 0 (;@24;)
                                                    i32.const 10
                                                    local.set 21
                                                    i32.const 0
                                                    local.set 16
                                                    loop  ;; label = @25
                                                      local.get 16
                                                      i32.const 1
                                                      i32.add
                                                      local.set 16
                                                      local.get 24
                                                      local.get 21
                                                      i32.const 10
                                                      i32.mul
                                                      local.tee 21
                                                      i32.rem_u
                                                      i32.eqz
                                                      br_if 0 (;@25;)
                                                    end
                                                  end
                                                  local.get 17
                                                  local.get 35
                                                  i32.sub
                                                  i32.const 2
                                                  i32.shr_s
                                                  i32.const 9
                                                  i32.mul
                                                  i32.const -9
                                                  i32.add
                                                  local.set 21
                                                  block  ;; label = @24
                                                    local.get 27
                                                    i32.const 32
                                                    i32.or
                                                    i32.const 102
                                                    i32.ne
                                                    br_if 0 (;@24;)
                                                    i32.const 0
                                                    local.set 26
                                                    local.get 34
                                                    local.get 21
                                                    local.get 16
                                                    i32.sub
                                                    local.tee 16
                                                    i32.const 0
                                                    local.get 16
                                                    i32.const 0
                                                    i32.gt_s
                                                    select
                                                    local.tee 16
                                                    local.get 34
                                                    local.get 16
                                                    i32.lt_s
                                                    select
                                                    local.set 34
                                                    br 1 (;@23;)
                                                  end
                                                  i32.const 0
                                                  local.set 26
                                                  local.get 34
                                                  local.get 21
                                                  local.get 20
                                                  i32.add
                                                  local.get 16
                                                  i32.sub
                                                  local.tee 16
                                                  i32.const 0
                                                  local.get 16
                                                  i32.const 0
                                                  i32.gt_s
                                                  select
                                                  local.tee 16
                                                  local.get 34
                                                  local.get 16
                                                  i32.lt_s
                                                  select
                                                  local.set 34
                                                end
                                                i32.const -1
                                                local.set 16
                                                local.get 34
                                                i32.const 2147483645
                                                i32.const 2147483646
                                                local.get 34
                                                local.get 26
                                                i32.or
                                                local.tee 25
                                                select
                                                i32.gt_s
                                                br_if 0 (;@22;)
                                                local.get 34
                                                local.get 25
                                                i32.const 0
                                                i32.ne
                                                i32.add
                                                i32.const 1
                                                i32.add
                                                local.set 33
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    local.get 27
                                                    i32.const 32
                                                    i32.or
                                                    i32.const 102
                                                    i32.ne
                                                    local.tee 38
                                                    br_if 0 (;@24;)
                                                    local.get 20
                                                    i32.const 2147483647
                                                    local.get 33
                                                    i32.sub
                                                    i32.gt_s
                                                    br_if 2 (;@22;)
                                                    local.get 20
                                                    i32.const 0
                                                    local.get 20
                                                    i32.const 0
                                                    i32.gt_s
                                                    select
                                                    local.set 20
                                                    br 1 (;@23;)
                                                  end
                                                  block  ;; label = @24
                                                    local.get 12
                                                    local.get 20
                                                    local.get 20
                                                    i32.const 31
                                                    i32.shr_s
                                                    local.tee 16
                                                    i32.add
                                                    local.get 16
                                                    i32.xor
                                                    i64.extend_i32_u
                                                    local.get 12
                                                    call $fmt_u
                                                    local.tee 21
                                                    i32.sub
                                                    i32.const 1
                                                    i32.gt_s
                                                    br_if 0 (;@24;)
                                                    local.get 21
                                                    i32.const -1
                                                    i32.add
                                                    local.set 16
                                                    loop  ;; label = @25
                                                      local.get 16
                                                      i32.const 48
                                                      i32.store8
                                                      local.get 12
                                                      local.get 16
                                                      i32.sub
                                                      local.set 21
                                                      local.get 16
                                                      i32.const -1
                                                      i32.add
                                                      local.tee 24
                                                      local.set 16
                                                      local.get 21
                                                      i32.const 2
                                                      i32.lt_s
                                                      br_if 0 (;@25;)
                                                    end
                                                    local.get 24
                                                    i32.const 1
                                                    i32.add
                                                    local.set 21
                                                  end
                                                  local.get 21
                                                  i32.const -2
                                                  i32.add
                                                  local.tee 24
                                                  local.get 27
                                                  i32.store8
                                                  i32.const -1
                                                  local.set 16
                                                  local.get 21
                                                  i32.const -1
                                                  i32.add
                                                  i32.const 45
                                                  i32.const 43
                                                  local.get 20
                                                  i32.const 0
                                                  i32.lt_s
                                                  select
                                                  i32.store8
                                                  local.get 12
                                                  local.get 24
                                                  i32.sub
                                                  local.tee 20
                                                  i32.const 2147483647
                                                  local.get 33
                                                  i32.sub
                                                  i32.gt_s
                                                  br_if 1 (;@22;)
                                                end
                                                i32.const -1
                                                local.set 16
                                                local.get 20
                                                local.get 33
                                                i32.add
                                                local.tee 20
                                                local.get 31
                                                i32.const 2147483647
                                                i32.xor
                                                i32.gt_s
                                                br_if 0 (;@22;)
                                                local.get 0
                                                i32.const 32
                                                local.get 23
                                                local.get 20
                                                local.get 31
                                                i32.add
                                                local.tee 27
                                                local.get 22
                                                call $pad
                                                block  ;; label = @23
                                                  local.get 0
                                                  i32.load8_u
                                                  i32.const 32
                                                  i32.and
                                                  br_if 0 (;@23;)
                                                  local.get 0
                                                  local.get 30
                                                  local.get 31
                                                  local.get 0
                                                  i32.load offset=32
                                                  call_indirect (type 18)
                                                  drop
                                                end
                                                local.get 0
                                                i32.const 48
                                                local.get 23
                                                local.get 27
                                                local.get 22
                                                i32.const 65536
                                                i32.xor
                                                call $pad
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        local.get 38
                                                        br_if 0 (;@26;)
                                                        local.get 35
                                                        local.get 18
                                                        local.get 18
                                                        local.get 35
                                                        i32.gt_u
                                                        select
                                                        local.tee 20
                                                        local.set 18
                                                        loop  ;; label = @27
                                                          local.get 18
                                                          i64.load32_u
                                                          local.get 10
                                                          call $fmt_u
                                                          local.set 16
                                                          block  ;; label = @28
                                                            block  ;; label = @29
                                                              local.get 18
                                                              local.get 20
                                                              i32.eq
                                                              br_if 0 (;@29;)
                                                              local.get 16
                                                              local.get 5
                                                              i32.const 80
                                                              i32.add
                                                              i32.le_u
                                                              br_if 1 (;@28;)
                                                              loop  ;; label = @30
                                                                local.get 16
                                                                i32.const -1
                                                                i32.add
                                                                local.tee 16
                                                                i32.const 48
                                                                i32.store8
                                                                local.get 16
                                                                local.get 5
                                                                i32.const 80
                                                                i32.add
                                                                i32.gt_u
                                                                br_if 0 (;@30;)
                                                                br 2 (;@28;)
                                                              end
                                                            end
                                                            local.get 16
                                                            local.get 10
                                                            i32.ne
                                                            br_if 0 (;@28;)
                                                            local.get 5
                                                            i32.const 48
                                                            i32.store8 offset=88
                                                            local.get 9
                                                            local.set 16
                                                          end
                                                          block  ;; label = @28
                                                            local.get 0
                                                            i32.load8_u
                                                            i32.const 32
                                                            i32.and
                                                            br_if 0 (;@28;)
                                                            local.get 0
                                                            local.get 16
                                                            local.get 10
                                                            local.get 16
                                                            i32.sub
                                                            local.get 0
                                                            i32.load offset=32
                                                            call_indirect (type 18)
                                                            drop
                                                          end
                                                          local.get 18
                                                          i32.const 4
                                                          i32.add
                                                          local.tee 18
                                                          local.get 35
                                                          i32.le_u
                                                          br_if 0 (;@27;)
                                                        end
                                                        block  ;; label = @27
                                                          local.get 25
                                                          i32.eqz
                                                          br_if 0 (;@27;)
                                                          local.get 0
                                                          i32.load8_u
                                                          i32.const 32
                                                          i32.and
                                                          br_if 0 (;@27;)
                                                          local.get 0
                                                          i32.const 66384
                                                          i32.const 13459
                                                          i32.add
                                                          i32.const 1
                                                          local.get 0
                                                          i32.load offset=32
                                                          call_indirect (type 18)
                                                          drop
                                                        end
                                                        local.get 34
                                                        i32.const 1
                                                        i32.lt_s
                                                        br_if 1 (;@25;)
                                                        local.get 18
                                                        local.get 17
                                                        i32.ge_u
                                                        br_if 1 (;@25;)
                                                        loop  ;; label = @27
                                                          block  ;; label = @28
                                                            local.get 18
                                                            i64.load32_u
                                                            local.get 10
                                                            call $fmt_u
                                                            local.tee 16
                                                            local.get 5
                                                            i32.const 80
                                                            i32.add
                                                            i32.le_u
                                                            br_if 0 (;@28;)
                                                            loop  ;; label = @29
                                                              local.get 16
                                                              i32.const -1
                                                              i32.add
                                                              local.tee 16
                                                              i32.const 48
                                                              i32.store8
                                                              local.get 16
                                                              local.get 5
                                                              i32.const 80
                                                              i32.add
                                                              i32.gt_u
                                                              br_if 0 (;@29;)
                                                            end
                                                          end
                                                          block  ;; label = @28
                                                            local.get 0
                                                            i32.load8_u
                                                            i32.const 32
                                                            i32.and
                                                            br_if 0 (;@28;)
                                                            local.get 0
                                                            local.get 16
                                                            local.get 34
                                                            i32.const 9
                                                            local.get 34
                                                            i32.const 9
                                                            i32.lt_s
                                                            select
                                                            local.get 0
                                                            i32.load offset=32
                                                            call_indirect (type 18)
                                                            drop
                                                          end
                                                          local.get 34
                                                          i32.const -9
                                                          i32.add
                                                          local.set 16
                                                          local.get 34
                                                          i32.const 10
                                                          i32.lt_s
                                                          br_if 3 (;@24;)
                                                          local.get 16
                                                          local.set 34
                                                          local.get 18
                                                          i32.const 4
                                                          i32.add
                                                          local.tee 18
                                                          local.get 17
                                                          i32.lt_u
                                                          br_if 0 (;@27;)
                                                          br 3 (;@24;)
                                                        end
                                                      end
                                                      block  ;; label = @26
                                                        local.get 34
                                                        i32.const 0
                                                        i32.lt_s
                                                        br_if 0 (;@26;)
                                                        local.get 17
                                                        local.get 18
                                                        i32.const 4
                                                        i32.add
                                                        local.get 28
                                                        select
                                                        local.set 21
                                                        local.get 18
                                                        local.set 17
                                                        loop  ;; label = @27
                                                          block  ;; label = @28
                                                            local.get 17
                                                            i64.load32_u
                                                            local.get 10
                                                            call $fmt_u
                                                            local.tee 16
                                                            local.get 10
                                                            i32.ne
                                                            br_if 0 (;@28;)
                                                            local.get 5
                                                            i32.const 48
                                                            i32.store8 offset=88
                                                            local.get 9
                                                            local.set 16
                                                          end
                                                          block  ;; label = @28
                                                            block  ;; label = @29
                                                              local.get 17
                                                              local.get 18
                                                              i32.eq
                                                              br_if 0 (;@29;)
                                                              local.get 16
                                                              local.get 5
                                                              i32.const 80
                                                              i32.add
                                                              i32.le_u
                                                              br_if 1 (;@28;)
                                                              loop  ;; label = @30
                                                                local.get 16
                                                                i32.const -1
                                                                i32.add
                                                                local.tee 16
                                                                i32.const 48
                                                                i32.store8
                                                                local.get 16
                                                                local.get 5
                                                                i32.const 80
                                                                i32.add
                                                                i32.gt_u
                                                                br_if 0 (;@30;)
                                                                br 2 (;@28;)
                                                              end
                                                            end
                                                            block  ;; label = @29
                                                              local.get 0
                                                              i32.load8_u
                                                              i32.const 32
                                                              i32.and
                                                              br_if 0 (;@29;)
                                                              local.get 0
                                                              local.get 16
                                                              i32.const 1
                                                              local.get 0
                                                              i32.load offset=32
                                                              call_indirect (type 18)
                                                              drop
                                                            end
                                                            local.get 16
                                                            i32.const 1
                                                            i32.add
                                                            local.set 16
                                                            block  ;; label = @29
                                                              local.get 26
                                                              br_if 0 (;@29;)
                                                              local.get 34
                                                              i32.const 1
                                                              i32.lt_s
                                                              br_if 1 (;@28;)
                                                            end
                                                            local.get 0
                                                            i32.load8_u
                                                            i32.const 32
                                                            i32.and
                                                            br_if 0 (;@28;)
                                                            local.get 0
                                                            i32.const 66384
                                                            i32.const 13459
                                                            i32.add
                                                            i32.const 1
                                                            local.get 0
                                                            i32.load offset=32
                                                            call_indirect (type 18)
                                                            drop
                                                          end
                                                          local.get 10
                                                          local.get 16
                                                          i32.sub
                                                          local.set 20
                                                          block  ;; label = @28
                                                            local.get 0
                                                            i32.load8_u
                                                            i32.const 32
                                                            i32.and
                                                            br_if 0 (;@28;)
                                                            local.get 0
                                                            local.get 16
                                                            local.get 20
                                                            local.get 34
                                                            local.get 34
                                                            local.get 20
                                                            i32.gt_s
                                                            select
                                                            local.get 0
                                                            i32.load offset=32
                                                            call_indirect (type 18)
                                                            drop
                                                          end
                                                          local.get 34
                                                          local.get 20
                                                          i32.sub
                                                          local.set 34
                                                          local.get 17
                                                          i32.const 4
                                                          i32.add
                                                          local.tee 17
                                                          local.get 21
                                                          i32.ge_u
                                                          br_if 1 (;@26;)
                                                          local.get 34
                                                          i32.const -1
                                                          i32.gt_s
                                                          br_if 0 (;@27;)
                                                        end
                                                      end
                                                      local.get 0
                                                      i32.const 48
                                                      local.get 34
                                                      i32.const 18
                                                      i32.add
                                                      i32.const 18
                                                      i32.const 0
                                                      call $pad
                                                      local.get 0
                                                      i32.load8_u
                                                      i32.const 32
                                                      i32.and
                                                      br_if 2 (;@23;)
                                                      local.get 0
                                                      local.get 24
                                                      local.get 12
                                                      local.get 24
                                                      i32.sub
                                                      local.get 0
                                                      i32.load offset=32
                                                      call_indirect (type 18)
                                                      drop
                                                      br 2 (;@23;)
                                                    end
                                                    local.get 34
                                                    local.set 16
                                                  end
                                                  local.get 0
                                                  i32.const 48
                                                  local.get 16
                                                  i32.const 9
                                                  i32.add
                                                  i32.const 9
                                                  i32.const 0
                                                  call $pad
                                                end
                                                local.get 0
                                                i32.const 32
                                                local.get 23
                                                local.get 27
                                                local.get 22
                                                i32.const 8192
                                                i32.xor
                                                call $pad
                                                local.get 23
                                                local.get 27
                                                local.get 27
                                                local.get 23
                                                i32.lt_s
                                                select
                                                local.set 16
                                              end
                                              local.get 16
                                              i32.const 0
                                              i32.ge_s
                                              br_if 18 (;@3;)
                                              br 20 (;@1;)
                                            end
                                            local.get 5
                                            i32.load offset=56
                                            local.set 18
                                            local.get 24
                                            i32.eqz
                                            br_if 1 (;@19;)
                                          end
                                          local.get 18
                                          i32.load
                                          local.tee 19
                                          i32.eqz
                                          br_if 0 (;@19;)
                                          local.get 18
                                          i32.const 4
                                          i32.add
                                          local.set 20
                                          i32.const 0
                                          local.set 16
                                          loop  ;; label = @20
                                            local.get 5
                                            i32.const 4
                                            i32.add
                                            local.get 19
                                            call $wctomb
                                            local.tee 17
                                            i32.const 0
                                            i32.lt_s
                                            br_if 2 (;@18;)
                                            local.get 17
                                            local.get 24
                                            local.get 16
                                            i32.sub
                                            i32.gt_u
                                            br_if 2 (;@18;)
                                            local.get 24
                                            local.get 17
                                            local.get 16
                                            i32.add
                                            local.tee 16
                                            i32.le_u
                                            br_if 2 (;@18;)
                                            local.get 20
                                            i32.load
                                            local.set 19
                                            local.get 20
                                            i32.const 4
                                            i32.add
                                            local.set 20
                                            local.get 19
                                            i32.eqz
                                            br_if 2 (;@18;)
                                            br 0 (;@20;)
                                          end
                                        end
                                        i32.const 0
                                        local.set 16
                                        i32.const 0
                                        local.set 17
                                      end
                                      i32.const -1
                                      local.set 19
                                      local.get 17
                                      local.get 16
                                      i32.or
                                      i32.const 0
                                      i32.lt_s
                                      br_if 16 (;@1;)
                                      local.get 0
                                      i32.const 32
                                      local.get 23
                                      local.get 16
                                      local.get 22
                                      call $pad
                                      block  ;; label = @18
                                        local.get 16
                                        i32.eqz
                                        br_if 0 (;@18;)
                                        i32.const 0
                                        local.set 19
                                        loop  ;; label = @19
                                          local.get 18
                                          i32.load
                                          local.tee 17
                                          i32.eqz
                                          br_if 1 (;@18;)
                                          local.get 5
                                          i32.const 4
                                          i32.add
                                          local.get 17
                                          call $wctomb
                                          local.tee 17
                                          local.get 19
                                          i32.add
                                          local.tee 19
                                          local.get 16
                                          i32.gt_u
                                          br_if 1 (;@18;)
                                          block  ;; label = @20
                                            local.get 0
                                            i32.load8_u
                                            i32.const 32
                                            i32.and
                                            br_if 0 (;@20;)
                                            local.get 0
                                            local.get 5
                                            i32.const 4
                                            i32.add
                                            local.get 17
                                            local.get 0
                                            i32.load offset=32
                                            call_indirect (type 18)
                                            drop
                                          end
                                          local.get 18
                                          i32.const 4
                                          i32.add
                                          local.set 18
                                          local.get 19
                                          local.get 16
                                          i32.lt_u
                                          br_if 0 (;@19;)
                                        end
                                      end
                                      local.get 0
                                      i32.const 32
                                      local.get 23
                                      local.get 16
                                      local.get 22
                                      i32.const 8192
                                      i32.xor
                                      call $pad
                                      local.get 23
                                      local.get 16
                                      local.get 23
                                      local.get 16
                                      i32.gt_s
                                      select
                                      local.set 16
                                      br 14 (;@3;)
                                    end
                                    i32.const 66384
                                    local.set 16
                                    local.get 5
                                    i32.load offset=56
                                    local.tee 18
                                    local.get 16
                                    i32.const 12826
                                    i32.add
                                    local.get 18
                                    select
                                    local.set 17
                                    br 1 (;@15;)
                                  end
                                  i32.const 0
                                  call $strerror
                                  local.set 17
                                end
                                i32.const 66384
                                local.set 19
                                i32.const 0
                                local.set 21
                                local.get 17
                                local.get 17
                                i32.const 2147483647
                                local.get 24
                                local.get 24
                                i32.const 0
                                i32.lt_s
                                select
                                call $strnlen
                                local.tee 18
                                i32.add
                                local.set 16
                                block  ;; label = @15
                                  block  ;; label = @16
                                    local.get 24
                                    i32.const -1
                                    i32.le_s
                                    br_if 0 (;@16;)
                                    local.get 19
                                    i32.const 12816
                                    i32.add
                                    local.set 28
                                    br 1 (;@15;)
                                  end
                                  i32.const 66384
                                  local.set 19
                                  local.get 16
                                  i32.load8_u
                                  br_if 13 (;@2;)
                                  local.get 19
                                  i32.const 12816
                                  i32.add
                                  local.set 28
                                end
                                local.get 26
                                local.set 22
                                local.get 18
                                local.set 24
                                br 10 (;@4;)
                              end
                              local.get 5
                              local.get 5
                              i64.load offset=56
                              i64.store8 offset=55
                              i32.const 66384
                              i32.const 12816
                              i32.add
                              local.set 28
                              i32.const 0
                              local.set 21
                              i32.const 1
                              local.set 24
                              local.get 26
                              local.set 22
                              local.get 13
                              local.set 16
                              local.get 6
                              local.set 17
                              br 9 (;@4;)
                            end
                            block  ;; label = @13
                              local.get 5
                              i64.load offset=56
                              local.tee 37
                              i64.const -1
                              i64.gt_s
                              br_if 0 (;@13;)
                              local.get 5
                              i64.const 0
                              local.get 37
                              i64.sub
                              local.tee 37
                              i64.store offset=56
                              i32.const 66384
                              i32.const 12816
                              i32.add
                              local.set 28
                              i32.const 1
                              local.set 21
                              br 6 (;@7;)
                            end
                            i32.const 66384
                            local.set 16
                            block  ;; label = @13
                              local.get 22
                              i32.const 2048
                              i32.and
                              i32.eqz
                              br_if 0 (;@13;)
                              i32.const 1
                              local.set 21
                              local.get 16
                              i32.const 12816
                              i32.add
                              i32.const 1
                              i32.add
                              local.set 28
                              br 6 (;@7;)
                            end
                            i32.const 66384
                            i32.const 12816
                            i32.add
                            local.tee 16
                            i32.const 2
                            i32.add
                            local.get 16
                            local.get 22
                            i32.const 1
                            i32.and
                            local.tee 21
                            select
                            local.set 28
                            br 5 (;@7;)
                          end
                          local.get 13
                          local.set 17
                          block  ;; label = @12
                            local.get 5
                            i64.load offset=56
                            local.tee 37
                            i64.eqz
                            br_if 0 (;@12;)
                            local.get 13
                            local.set 17
                            loop  ;; label = @13
                              local.get 17
                              i32.const -1
                              i32.add
                              local.tee 17
                              local.get 37
                              i32.wrap_i64
                              i32.const 7
                              i32.and
                              i32.const 48
                              i32.or
                              i32.store8
                              local.get 37
                              i64.const 3
                              i64.shr_u
                              local.tee 37
                              i64.const 0
                              i64.ne
                              br_if 0 (;@13;)
                            end
                          end
                          i32.const 66384
                          local.set 16
                          i32.const 0
                          local.set 21
                          block  ;; label = @12
                            local.get 22
                            i32.const 8
                            i32.and
                            br_if 0 (;@12;)
                            local.get 16
                            i32.const 12816
                            i32.add
                            local.set 28
                            br 6 (;@6;)
                          end
                          local.get 24
                          local.get 13
                          local.get 17
                          i32.sub
                          local.tee 16
                          i32.const 1
                          i32.add
                          local.get 24
                          local.get 16
                          i32.gt_s
                          select
                          local.set 24
                          i32.const 66384
                          i32.const 12816
                          i32.add
                          local.set 28
                          br 5 (;@6;)
                        end
                        local.get 24
                        i32.const 8
                        local.get 24
                        i32.const 8
                        i32.gt_u
                        select
                        local.set 24
                        local.get 22
                        i32.const 8
                        i32.or
                        local.set 22
                        i32.const 120
                        local.set 27
                      end
                      i32.const 66384
                      local.set 16
                      i32.const 0
                      local.set 21
                      block  ;; label = @10
                        local.get 5
                        i64.load offset=56
                        local.tee 37
                        i64.eqz
                        i32.eqz
                        br_if 0 (;@10;)
                        local.get 16
                        i32.const 12816
                        i32.add
                        local.set 28
                        local.get 13
                        local.set 17
                        br 4 (;@6;)
                      end
                      local.get 27
                      i32.const 32
                      i32.and
                      local.set 16
                      local.get 13
                      local.set 17
                      loop  ;; label = @10
                        local.get 17
                        i32.const -1
                        i32.add
                        local.tee 17
                        i32.const 66384
                        i32.const 13408
                        i32.add
                        local.get 37
                        i32.wrap_i64
                        i32.const 15
                        i32.and
                        i32.add
                        i32.load8_u
                        local.get 16
                        i32.or
                        i32.store8
                        local.get 37
                        i64.const 4
                        i64.shr_u
                        local.tee 37
                        i64.const 0
                        i64.ne
                        br_if 0 (;@10;)
                      end
                      i32.const 66384
                      i32.const 12816
                      i32.add
                      local.set 28
                      local.get 22
                      i32.const 8
                      i32.and
                      i32.eqz
                      br_if 3 (;@6;)
                      local.get 5
                      i64.load offset=56
                      i64.eqz
                      br_if 3 (;@6;)
                      i32.const 66384
                      i32.const 12816
                      i32.add
                      local.get 27
                      i32.const 4
                      i32.shr_s
                      i32.add
                      local.set 28
                      i32.const 2
                      local.set 21
                      br 3 (;@6;)
                    end
                    i32.const 0
                    local.set 16
                    local.get 21
                    i32.const 255
                    i32.and
                    local.tee 18
                    i32.const 7
                    i32.gt_u
                    br_if 5 (;@3;)
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  local.get 18
                                  br_table 0 (;@15;) 1 (;@14;) 2 (;@13;) 3 (;@12;) 4 (;@11;) 12 (;@3;) 5 (;@10;) 6 (;@9;) 0 (;@15;)
                                end
                                local.get 5
                                i32.load offset=56
                                local.get 15
                                i32.store
                                br 11 (;@3;)
                              end
                              local.get 5
                              i32.load offset=56
                              local.get 15
                              i32.store
                              br 10 (;@3;)
                            end
                            local.get 5
                            i32.load offset=56
                            local.get 15
                            i64.extend_i32_s
                            i64.store
                            br 9 (;@3;)
                          end
                          local.get 5
                          i32.load offset=56
                          local.get 15
                          i32.store16
                          br 8 (;@3;)
                        end
                        local.get 5
                        i32.load offset=56
                        local.get 15
                        i32.store8
                        br 7 (;@3;)
                      end
                      local.get 5
                      i32.load offset=56
                      local.get 15
                      i32.store
                      br 6 (;@3;)
                    end
                    local.get 5
                    i32.load offset=56
                    local.get 15
                    i64.extend_i32_s
                    i64.store
                    br 5 (;@3;)
                  end
                  i32.const 66384
                  i32.const 12816
                  i32.add
                  local.set 28
                  i32.const 0
                  local.set 21
                  local.get 5
                  i64.load offset=56
                  local.set 37
                end
                local.get 37
                local.get 13
                call $fmt_u
                local.set 17
              end
              block  ;; label = @6
                local.get 25
                i32.eqz
                br_if 0 (;@6;)
                local.get 24
                i32.const 0
                i32.lt_s
                br_if 4 (;@2;)
              end
              local.get 22
              i32.const -65537
              i32.and
              local.get 22
              local.get 25
              select
              local.set 22
              local.get 5
              i64.load offset=56
              local.set 37
              block  ;; label = @6
                local.get 24
                br_if 0 (;@6;)
                local.get 37
                i64.eqz
                i32.eqz
                br_if 0 (;@6;)
                i32.const 0
                local.set 24
                local.get 13
                local.set 16
                local.get 13
                local.set 17
                br 2 (;@4;)
              end
              local.get 24
              local.get 13
              local.get 17
              i32.sub
              local.get 37
              i64.eqz
              i32.add
              local.tee 16
              local.get 24
              local.get 16
              i32.gt_s
              select
              local.set 24
            end
            local.get 13
            local.set 16
          end
          local.get 16
          local.get 17
          i32.sub
          local.tee 26
          local.get 24
          local.get 24
          local.get 26
          i32.lt_s
          select
          local.tee 24
          i32.const 2147483647
          local.get 21
          i32.sub
          i32.gt_s
          br_if 1 (;@2;)
          i32.const -1
          local.set 19
          local.get 24
          local.get 21
          i32.add
          local.tee 18
          local.get 23
          local.get 23
          local.get 18
          i32.lt_s
          select
          local.tee 16
          local.get 20
          i32.gt_s
          br_if 2 (;@1;)
          local.get 0
          i32.const 32
          local.get 16
          local.get 18
          local.get 22
          call $pad
          block  ;; label = @4
            local.get 0
            i32.load8_u
            i32.const 32
            i32.and
            br_if 0 (;@4;)
            local.get 0
            local.get 28
            local.get 21
            local.get 0
            i32.load offset=32
            call_indirect (type 18)
            drop
          end
          local.get 0
          i32.const 48
          local.get 16
          local.get 18
          local.get 22
          i32.const 65536
          i32.xor
          call $pad
          local.get 0
          i32.const 48
          local.get 24
          local.get 26
          i32.const 0
          call $pad
          block  ;; label = @4
            local.get 0
            i32.load8_u
            i32.const 32
            i32.and
            br_if 0 (;@4;)
            local.get 0
            local.get 17
            local.get 26
            local.get 0
            i32.load offset=32
            call_indirect (type 18)
            drop
          end
          local.get 0
          i32.const 32
          local.get 16
          local.get 18
          local.get 22
          i32.const 8192
          i32.xor
          call $pad
          br 0 (;@3;)
        end
      end
      i32.const -1
      local.set 19
    end
    local.get 5
    i32.const 624
    i32.add
    global.set 4
    local.get 19)
  (func $pop_arg (type 22) (param i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const -9
      i32.add
      local.tee 1
      i32.const 17
      i32.gt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          local.get 1
                                          br_table 17 (;@2;) 0 (;@19;) 1 (;@18;) 4 (;@15;) 2 (;@17;) 3 (;@16;) 5 (;@14;) 6 (;@13;) 7 (;@12;) 8 (;@11;) 9 (;@10;) 10 (;@9;) 11 (;@8;) 12 (;@7;) 13 (;@6;) 14 (;@5;) 15 (;@4;) 16 (;@3;) 17 (;@2;)
                                        end
                                        local.get 2
                                        local.get 2
                                        i32.load
                                        local.tee 1
                                        i32.const 4
                                        i32.add
                                        i32.store
                                        local.get 0
                                        local.get 1
                                        i64.load32_s
                                        i64.store
                                        return
                                      end
                                      local.get 2
                                      local.get 2
                                      i32.load
                                      local.tee 1
                                      i32.const 4
                                      i32.add
                                      i32.store
                                      local.get 0
                                      local.get 1
                                      i64.load32_u
                                      i64.store
                                      return
                                    end
                                    local.get 2
                                    local.get 2
                                    i32.load
                                    local.tee 1
                                    i32.const 4
                                    i32.add
                                    i32.store
                                    local.get 0
                                    local.get 1
                                    i64.load32_s
                                    i64.store
                                    return
                                  end
                                  local.get 2
                                  local.get 2
                                  i32.load
                                  local.tee 1
                                  i32.const 4
                                  i32.add
                                  i32.store
                                  local.get 0
                                  local.get 1
                                  i64.load32_u
                                  i64.store
                                  return
                                end
                                local.get 2
                                local.get 2
                                i32.load
                                i32.const 7
                                i32.add
                                i32.const -8
                                i32.and
                                local.tee 1
                                i32.const 8
                                i32.add
                                i32.store
                                local.get 0
                                local.get 1
                                i64.load
                                i64.store
                                return
                              end
                              local.get 2
                              local.get 2
                              i32.load
                              local.tee 1
                              i32.const 4
                              i32.add
                              i32.store
                              local.get 0
                              local.get 1
                              i64.load16_s
                              i64.store
                              return
                            end
                            local.get 2
                            local.get 2
                            i32.load
                            local.tee 1
                            i32.const 4
                            i32.add
                            i32.store
                            local.get 0
                            local.get 1
                            i64.load16_u
                            i64.store
                            return
                          end
                          local.get 2
                          local.get 2
                          i32.load
                          local.tee 1
                          i32.const 4
                          i32.add
                          i32.store
                          local.get 0
                          local.get 1
                          i64.load8_s
                          i64.store
                          return
                        end
                        local.get 2
                        local.get 2
                        i32.load
                        local.tee 1
                        i32.const 4
                        i32.add
                        i32.store
                        local.get 0
                        local.get 1
                        i64.load8_u
                        i64.store
                        return
                      end
                      local.get 2
                      local.get 2
                      i32.load
                      i32.const 7
                      i32.add
                      i32.const -8
                      i32.and
                      local.tee 1
                      i32.const 8
                      i32.add
                      i32.store
                      local.get 0
                      local.get 1
                      i64.load
                      i64.store
                      return
                    end
                    local.get 2
                    local.get 2
                    i32.load
                    local.tee 1
                    i32.const 4
                    i32.add
                    i32.store
                    local.get 0
                    local.get 1
                    i64.load32_u
                    i64.store
                    return
                  end
                  local.get 2
                  local.get 2
                  i32.load
                  i32.const 7
                  i32.add
                  i32.const -8
                  i32.and
                  local.tee 1
                  i32.const 8
                  i32.add
                  i32.store
                  local.get 0
                  local.get 1
                  i64.load
                  i64.store
                  return
                end
                local.get 2
                local.get 2
                i32.load
                i32.const 7
                i32.add
                i32.const -8
                i32.and
                local.tee 1
                i32.const 8
                i32.add
                i32.store
                local.get 0
                local.get 1
                i64.load
                i64.store
                return
              end
              local.get 2
              local.get 2
              i32.load
              local.tee 1
              i32.const 4
              i32.add
              i32.store
              local.get 0
              local.get 1
              i64.load32_s
              i64.store
              return
            end
            local.get 2
            local.get 2
            i32.load
            local.tee 1
            i32.const 4
            i32.add
            i32.store
            local.get 0
            local.get 1
            i64.load32_u
            i64.store
            return
          end
          local.get 2
          local.get 2
          i32.load
          i32.const 7
          i32.add
          i32.const -8
          i32.and
          local.tee 1
          i32.const 8
          i32.add
          i32.store
          local.get 0
          local.get 1
          i64.load
          i64.store
          return
        end
        call $long_double_not_supported
        unreachable
      end
      local.get 2
      local.get 2
      i32.load
      local.tee 1
      i32.const 4
      i32.add
      i32.store
      local.get 0
      local.get 1
      i32.load
      i32.store
    end)
  (func $pad (type 35) (param i32 i32 i32 i32 i32)
    (local i32 i32 i32)
    global.get 4
    i32.const 256
    i32.sub
    local.tee 5
    global.set 4
    block  ;; label = @1
      local.get 2
      local.get 3
      i32.le_s
      br_if 0 (;@1;)
      local.get 4
      i32.const 73728
      i32.and
      br_if 0 (;@1;)
      local.get 5
      local.get 1
      local.get 2
      local.get 3
      i32.sub
      local.tee 4
      i32.const 256
      local.get 4
      i32.const 256
      i32.lt_u
      local.tee 6
      select
      call $memset
      drop
      local.get 0
      i32.load
      local.tee 7
      i32.const 32
      i32.and
      local.set 1
      block  ;; label = @2
        block  ;; label = @3
          local.get 6
          br_if 0 (;@3;)
          local.get 1
          i32.eqz
          local.set 1
          local.get 2
          local.get 3
          i32.sub
          local.set 3
          loop  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.const 1
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              local.get 0
              local.get 5
              i32.const 256
              local.get 0
              i32.load offset=32
              call_indirect (type 18)
              drop
              local.get 0
              i32.load
              local.set 7
            end
            local.get 7
            i32.const 32
            i32.and
            local.tee 2
            i32.eqz
            local.set 1
            local.get 4
            i32.const -256
            i32.add
            local.tee 4
            i32.const 255
            i32.gt_u
            br_if 0 (;@4;)
          end
          local.get 2
          br_if 2 (;@1;)
          local.get 3
          i32.const 255
          i32.and
          local.set 4
          br 1 (;@2;)
        end
        local.get 1
        br_if 1 (;@1;)
      end
      local.get 0
      local.get 5
      local.get 4
      local.get 0
      i32.load offset=32
      call_indirect (type 18)
      drop
    end
    local.get 5
    i32.const 256
    i32.add
    global.set 4)
  (func $fmt_u (type 36) (param i64 i32) (result i32)
    (local i64 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.const 4294967296
        i64.ge_u
        br_if 0 (;@2;)
        local.get 0
        local.set 2
        br 1 (;@1;)
      end
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 0
        local.get 0
        i64.const 10
        i64.div_u
        local.tee 2
        i64.const 10
        i64.mul
        i64.sub
        i32.wrap_i64
        i32.const 48
        i32.or
        i32.store8
        local.get 0
        i64.const 42949672959
        i64.gt_u
        local.set 3
        local.get 2
        local.set 0
        local.get 3
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      i32.wrap_i64
      local.tee 3
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 3
        local.get 3
        i32.const 10
        i32.div_u
        local.tee 4
        i32.const 10
        i32.mul
        i32.sub
        i32.const 48
        i32.or
        i32.store8
        local.get 3
        i32.const 9
        i32.gt_u
        local.set 5
        local.get 4
        local.set 3
        local.get 5
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $long_double_not_supported (type 21)
    (local i32)
    i32.const 66384
    local.tee 0
    i32.const 13312
    i32.add
    local.get 0
    i32.const 0
    i32.add
    call $fputs
    drop
    call $abort
    unreachable)
  (func $__math_oflow (type 37) (param i32) (result f64)
    local.get 0
    f64.const 0x1p+769 (;=3.10504e+231;)
    call $__math_xflow)
  (func $__math_uflow (type 37) (param i32) (result f64)
    local.get 0
    f64.const 0x1p-767 (;=1.28823e-231;)
    call $__math_xflow)
  (func $__math_xflow (type 38) (param i32 f64) (result f64)
    local.get 1
    f64.neg
    local.get 1
    local.get 0
    select
    local.get 1
    f64.mul)
  (func $__math_divzero (type 37) (param i32) (result f64)
    f64.const -inf (;=-inf;)
    f64.const inf (;=inf;)
    local.get 0
    select)
  (func $__math_invalid (type 31) (param f64) (result f64)
    local.get 0
    local.get 0
    f64.sub
    local.tee 0
    local.get 0
    f64.div)
  (func $__rem_pio2 (type 39) (param f64 i32) (result i32)
    (local i32 i64 i32 i32 f64 f64 f64 i32 f64 i32)
    global.get 4
    i32.const 48
    i32.sub
    local.tee 2
    global.set 4
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i64.reinterpret_f64
            local.tee 3
            i64.const 32
            i64.shr_u
            i32.wrap_i64
            local.tee 4
            i32.const 2147483647
            i32.and
            local.tee 5
            i32.const 1074752122
            i32.gt_u
            br_if 0 (;@4;)
            local.get 4
            i32.const 1048575
            i32.and
            i32.const 598523
            i32.eq
            br_if 1 (;@3;)
            block  ;; label = @5
              local.get 5
              i32.const 1073928572
              i32.gt_u
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 3
                i64.const 0
                i64.lt_s
                br_if 0 (;@6;)
                local.get 1
                local.get 0
                f64.const -0x1.921fb544p+0 (;=-1.5708;)
                f64.add
                local.tee 0
                f64.const -0x1.0b4611a626331p-34 (;=-6.0771e-11;)
                f64.add
                local.tee 6
                f64.store
                local.get 1
                local.get 0
                local.get 6
                f64.sub
                f64.const -0x1.0b4611a626331p-34 (;=-6.0771e-11;)
                f64.add
                f64.store offset=8
                i32.const 1
                local.set 4
                br 5 (;@1;)
              end
              local.get 1
              local.get 0
              f64.const 0x1.921fb544p+0 (;=1.5708;)
              f64.add
              local.tee 0
              f64.const 0x1.0b4611a626331p-34 (;=6.0771e-11;)
              f64.add
              local.tee 6
              f64.store
              local.get 1
              local.get 0
              local.get 6
              f64.sub
              f64.const 0x1.0b4611a626331p-34 (;=6.0771e-11;)
              f64.add
              f64.store offset=8
              i32.const -1
              local.set 4
              br 4 (;@1;)
            end
            block  ;; label = @5
              local.get 3
              i64.const 0
              i64.lt_s
              br_if 0 (;@5;)
              local.get 1
              local.get 0
              f64.const -0x1.921fb544p+1 (;=-3.14159;)
              f64.add
              local.tee 0
              f64.const -0x1.0b4611a626331p-33 (;=-1.21542e-10;)
              f64.add
              local.tee 6
              f64.store
              local.get 1
              local.get 0
              local.get 6
              f64.sub
              f64.const -0x1.0b4611a626331p-33 (;=-1.21542e-10;)
              f64.add
              f64.store offset=8
              i32.const 2
              local.set 4
              br 4 (;@1;)
            end
            local.get 1
            local.get 0
            f64.const 0x1.921fb544p+1 (;=3.14159;)
            f64.add
            local.tee 0
            f64.const 0x1.0b4611a626331p-33 (;=1.21542e-10;)
            f64.add
            local.tee 6
            f64.store
            local.get 1
            local.get 0
            local.get 6
            f64.sub
            f64.const 0x1.0b4611a626331p-33 (;=1.21542e-10;)
            f64.add
            f64.store offset=8
            i32.const -2
            local.set 4
            br 3 (;@1;)
          end
          block  ;; label = @4
            local.get 5
            i32.const 1075594811
            i32.gt_u
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 5
              i32.const 1075183036
              i32.gt_u
              br_if 0 (;@5;)
              local.get 5
              i32.const 1074977148
              i32.eq
              br_if 2 (;@3;)
              block  ;; label = @6
                local.get 3
                i64.const 0
                i64.lt_s
                br_if 0 (;@6;)
                local.get 1
                local.get 0
                f64.const -0x1.2d97c7f3p+2 (;=-4.71239;)
                f64.add
                local.tee 0
                f64.const -0x1.90e91a79394cap-33 (;=-1.82313e-10;)
                f64.add
                local.tee 6
                f64.store
                local.get 1
                local.get 0
                local.get 6
                f64.sub
                f64.const -0x1.90e91a79394cap-33 (;=-1.82313e-10;)
                f64.add
                f64.store offset=8
                i32.const 3
                local.set 4
                br 5 (;@1;)
              end
              local.get 1
              local.get 0
              f64.const 0x1.2d97c7f3p+2 (;=4.71239;)
              f64.add
              local.tee 0
              f64.const 0x1.90e91a79394cap-33 (;=1.82313e-10;)
              f64.add
              local.tee 6
              f64.store
              local.get 1
              local.get 0
              local.get 6
              f64.sub
              f64.const 0x1.90e91a79394cap-33 (;=1.82313e-10;)
              f64.add
              f64.store offset=8
              i32.const -3
              local.set 4
              br 4 (;@1;)
            end
            local.get 5
            i32.const 1075388923
            i32.eq
            br_if 1 (;@3;)
            block  ;; label = @5
              local.get 3
              i64.const 0
              i64.lt_s
              br_if 0 (;@5;)
              local.get 1
              local.get 0
              f64.const -0x1.921fb544p+2 (;=-6.28319;)
              f64.add
              local.tee 0
              f64.const -0x1.0b4611a626331p-32 (;=-2.43084e-10;)
              f64.add
              local.tee 6
              f64.store
              local.get 1
              local.get 0
              local.get 6
              f64.sub
              f64.const -0x1.0b4611a626331p-32 (;=-2.43084e-10;)
              f64.add
              f64.store offset=8
              i32.const 4
              local.set 4
              br 4 (;@1;)
            end
            local.get 1
            local.get 0
            f64.const 0x1.921fb544p+2 (;=6.28319;)
            f64.add
            local.tee 0
            f64.const 0x1.0b4611a626331p-32 (;=2.43084e-10;)
            f64.add
            local.tee 6
            f64.store
            local.get 1
            local.get 0
            local.get 6
            f64.sub
            f64.const 0x1.0b4611a626331p-32 (;=2.43084e-10;)
            f64.add
            f64.store offset=8
            i32.const -4
            local.set 4
            br 3 (;@1;)
          end
          local.get 5
          i32.const 1094263290
          i32.gt_u
          br_if 1 (;@2;)
        end
        local.get 1
        local.get 0
        local.get 0
        f64.const 0x1.45f306dc9c883p-1 (;=0.63662;)
        f64.mul
        f64.const 0x1.8p+52 (;=6.7554e+15;)
        f64.add
        f64.const -0x1.8p+52 (;=-6.7554e+15;)
        f64.add
        local.tee 6
        f64.const -0x1.921fb544p+0 (;=-1.5708;)
        f64.mul
        f64.add
        local.tee 7
        local.get 6
        f64.const 0x1.0b4611a626331p-34 (;=6.0771e-11;)
        f64.mul
        local.tee 8
        f64.sub
        local.tee 0
        f64.store
        local.get 5
        i32.const 20
        i32.shr_u
        local.tee 9
        local.get 0
        i64.reinterpret_f64
        i64.const 52
        i64.shr_u
        i32.wrap_i64
        i32.const 2047
        i32.and
        i32.sub
        i32.const 17
        i32.lt_s
        local.set 5
        block  ;; label = @3
          block  ;; label = @4
            local.get 6
            f64.abs
            f64.const 0x1p+31 (;=2.14748e+09;)
            f64.lt
            i32.eqz
            br_if 0 (;@4;)
            local.get 6
            i32.trunc_f64_s
            local.set 4
            br 1 (;@3;)
          end
          i32.const -2147483648
          local.set 4
        end
        block  ;; label = @3
          local.get 5
          br_if 0 (;@3;)
          local.get 1
          local.get 7
          local.get 6
          f64.const 0x1.0b4611a6p-34 (;=6.0771e-11;)
          f64.mul
          local.tee 0
          f64.sub
          local.tee 10
          local.get 6
          f64.const 0x1.3198a2e037073p-69 (;=2.02227e-21;)
          f64.mul
          local.get 7
          local.get 10
          f64.sub
          local.get 0
          f64.sub
          f64.sub
          local.tee 8
          f64.sub
          local.tee 0
          f64.store
          block  ;; label = @4
            local.get 9
            local.get 0
            i64.reinterpret_f64
            i64.const 52
            i64.shr_u
            i32.wrap_i64
            i32.const 2047
            i32.and
            i32.sub
            i32.const 50
            i32.ge_s
            br_if 0 (;@4;)
            local.get 10
            local.set 7
            br 1 (;@3;)
          end
          local.get 1
          local.get 10
          local.get 6
          f64.const 0x1.3198a2ep-69 (;=2.02227e-21;)
          f64.mul
          local.tee 0
          f64.sub
          local.tee 7
          local.get 6
          f64.const 0x1.b839a252049c1p-104 (;=8.47843e-32;)
          f64.mul
          local.get 10
          local.get 7
          f64.sub
          local.get 0
          f64.sub
          f64.sub
          local.tee 8
          f64.sub
          local.tee 0
          f64.store
        end
        local.get 1
        local.get 7
        local.get 0
        f64.sub
        local.get 8
        f64.sub
        f64.store offset=8
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 5
        i32.const 2146435072
        i32.lt_u
        br_if 0 (;@2;)
        local.get 1
        local.get 0
        local.get 0
        f64.sub
        local.tee 0
        f64.store
        local.get 1
        local.get 0
        f64.store offset=8
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      local.get 3
      i64.const 4503599627370495
      i64.and
      i64.const 4710765210229538816
      i64.or
      f64.reinterpret_i64
      local.set 0
      i32.const 0
      local.set 4
      loop  ;; label = @2
        local.get 2
        i32.const 16
        i32.add
        local.get 4
        local.tee 9
        i32.const 3
        i32.shl
        i32.add
        local.set 4
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            f64.abs
            f64.const 0x1p+31 (;=2.14748e+09;)
            f64.lt
            i32.eqz
            br_if 0 (;@4;)
            local.get 0
            i32.trunc_f64_s
            local.set 11
            br 1 (;@3;)
          end
          i32.const -2147483648
          local.set 11
        end
        local.get 4
        local.get 11
        f64.convert_i32_s
        local.tee 6
        f64.store
        local.get 0
        local.get 6
        f64.sub
        f64.const 0x1p+24 (;=1.67772e+07;)
        f64.mul
        local.set 0
        i32.const 1
        local.set 4
        local.get 9
        i32.eqz
        br_if 0 (;@2;)
      end
      local.get 2
      local.get 0
      f64.store offset=32
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          f64.const 0x0p+0 (;=0;)
          f64.eq
          br_if 0 (;@3;)
          i32.const 2
          local.set 9
          br 1 (;@2;)
        end
        local.get 2
        i32.const 16
        i32.add
        i32.const 8
        i32.or
        local.set 4
        i32.const 2
        local.set 9
        loop  ;; label = @3
          local.get 9
          i32.const -1
          i32.add
          local.set 9
          local.get 4
          f64.load
          local.set 0
          local.get 4
          i32.const -8
          i32.add
          local.set 4
          local.get 0
          f64.const 0x0p+0 (;=0;)
          f64.eq
          br_if 0 (;@3;)
        end
      end
      local.get 2
      i32.const 16
      i32.add
      local.get 2
      local.get 5
      i32.const 20
      i32.shr_u
      i32.const -1046
      i32.add
      local.get 9
      i32.const 1
      i32.add
      i32.const 1
      call $__rem_pio2_large
      local.set 4
      local.get 2
      f64.load
      local.set 0
      block  ;; label = @2
        local.get 3
        i64.const -1
        i64.gt_s
        br_if 0 (;@2;)
        local.get 1
        local.get 0
        f64.neg
        f64.store
        local.get 1
        local.get 2
        f64.load offset=8
        f64.neg
        f64.store offset=8
        i32.const 0
        local.get 4
        i32.sub
        local.set 4
        br 1 (;@1;)
      end
      local.get 1
      local.get 0
      f64.store
      local.get 1
      local.get 2
      i64.load offset=8
      i64.store offset=8
    end
    local.get 2
    i32.const 48
    i32.add
    global.set 4
    local.get 4)
  (func $__rem_pio2_large (type 25) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 f64 i32 i32 i32 i32 i32 i32 i32 f64 i32 i32 i32 f64 f64)
    global.get 4
    i32.const 560
    i32.sub
    local.tee 5
    global.set 4
    i32.const 0
    local.set 6
    local.get 2
    local.get 2
    i32.const -3
    i32.add
    i32.const 24
    i32.div_s
    local.tee 7
    i32.const 0
    local.get 7
    i32.const 0
    i32.gt_s
    select
    local.tee 8
    i32.const -24
    i32.mul
    i32.add
    local.set 9
    block  ;; label = @1
      i32.const 66384
      i32.const 13472
      i32.add
      local.get 4
      i32.const 2
      i32.shl
      i32.add
      i32.load
      local.tee 10
      local.get 3
      i32.const -1
      i32.add
      local.tee 2
      i32.add
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 8
      local.get 3
      i32.sub
      i32.const 2
      i32.shl
      i32.const 66384
      i32.const 13488
      i32.add
      i32.add
      i32.const 4
      i32.add
      local.set 11
      local.get 10
      local.get 3
      i32.add
      local.set 12
      local.get 8
      local.get 2
      i32.sub
      local.set 2
      local.get 5
      i32.const 320
      i32.add
      local.set 7
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            f64.const 0x0p+0 (;=0;)
            local.set 13
            br 1 (;@3;)
          end
          local.get 11
          i32.load
          f64.convert_i32_s
          local.set 13
        end
        local.get 7
        local.get 13
        f64.store
        local.get 7
        i32.const 8
        i32.add
        local.set 7
        local.get 11
        i32.const 4
        i32.add
        local.set 11
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        local.get 12
        i32.const -1
        i32.add
        local.tee 12
        br_if 0 (;@2;)
      end
    end
    local.get 9
    i32.const -24
    i32.add
    local.set 14
    local.get 3
    i32.const 3
    i32.shl
    local.get 5
    i32.const 320
    i32.add
    i32.add
    i32.const -8
    i32.add
    local.set 12
    local.get 3
    i32.const 1
    i32.lt_s
    local.set 15
    loop  ;; label = @1
      f64.const 0x0p+0 (;=0;)
      local.set 13
      block  ;; label = @2
        local.get 15
        br_if 0 (;@2;)
        local.get 0
        local.set 2
        local.get 3
        local.set 11
        local.get 12
        local.set 7
        loop  ;; label = @3
          local.get 13
          local.get 2
          f64.load
          local.get 7
          f64.load
          f64.mul
          f64.add
          local.set 13
          local.get 2
          i32.const 8
          i32.add
          local.set 2
          local.get 7
          i32.const -8
          i32.add
          local.set 7
          local.get 11
          i32.const -1
          i32.add
          local.tee 11
          br_if 0 (;@3;)
        end
      end
      local.get 5
      local.get 6
      i32.const 3
      i32.shl
      i32.add
      local.get 13
      f64.store
      local.get 12
      i32.const 8
      i32.add
      local.set 12
      local.get 6
      local.get 10
      i32.lt_s
      local.set 2
      local.get 6
      i32.const 1
      i32.add
      local.set 6
      local.get 2
      br_if 0 (;@1;)
    end
    i32.const 23
    local.get 14
    i32.sub
    local.set 16
    i32.const 24
    local.get 14
    i32.sub
    local.set 17
    local.get 10
    i32.const 2
    i32.shl
    local.get 5
    i32.const 480
    i32.add
    i32.add
    i32.const -4
    i32.add
    local.set 18
    local.get 5
    i32.const 480
    i32.add
    i32.const -4
    i32.add
    local.set 19
    local.get 5
    i32.const -8
    i32.add
    local.set 20
    local.get 10
    local.set 2
    block  ;; label = @1
      loop  ;; label = @2
        local.get 5
        local.get 2
        i32.const 3
        i32.shl
        local.tee 7
        i32.add
        f64.load
        local.set 13
        block  ;; label = @3
          local.get 2
          i32.const 1
          i32.lt_s
          local.tee 15
          br_if 0 (;@3;)
          local.get 2
          i32.const 1
          i32.add
          local.set 6
          local.get 20
          local.get 7
          i32.add
          local.set 7
          local.get 5
          i32.const 480
          i32.add
          local.set 11
          loop  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 13
                f64.const 0x1p-24 (;=5.96046e-08;)
                f64.mul
                local.tee 21
                f64.abs
                f64.const 0x1p+31 (;=2.14748e+09;)
                f64.lt
                i32.eqz
                br_if 0 (;@6;)
                local.get 21
                i32.trunc_f64_s
                local.set 12
                br 1 (;@5;)
              end
              i32.const -2147483648
              local.set 12
            end
            block  ;; label = @5
              block  ;; label = @6
                local.get 13
                local.get 12
                f64.convert_i32_s
                local.tee 21
                f64.const -0x1p+24 (;=-1.67772e+07;)
                f64.mul
                f64.add
                local.tee 13
                f64.abs
                f64.const 0x1p+31 (;=2.14748e+09;)
                f64.lt
                i32.eqz
                br_if 0 (;@6;)
                local.get 13
                i32.trunc_f64_s
                local.set 12
                br 1 (;@5;)
              end
              i32.const -2147483648
              local.set 12
            end
            local.get 11
            local.get 12
            i32.store
            local.get 11
            i32.const 4
            i32.add
            local.set 11
            local.get 7
            f64.load
            local.get 21
            f64.add
            local.set 13
            local.get 7
            i32.const -8
            i32.add
            local.set 7
            local.get 6
            i32.const -1
            i32.add
            local.tee 6
            i32.const 1
            i32.gt_s
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 13
            local.get 14
            call $scalbn
            local.tee 13
            local.get 13
            f64.const 0x1p-3 (;=0.125;)
            f64.mul
            call $floor
            f64.const -0x1p+3 (;=-8;)
            f64.mul
            f64.add
            local.tee 13
            f64.abs
            f64.const 0x1p+31 (;=2.14748e+09;)
            f64.lt
            i32.eqz
            br_if 0 (;@4;)
            local.get 13
            i32.trunc_f64_s
            local.set 22
            br 1 (;@3;)
          end
          i32.const -2147483648
          local.set 22
        end
        local.get 13
        local.get 22
        f64.convert_i32_s
        f64.sub
        local.set 13
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 14
                  i32.const 1
                  i32.lt_s
                  local.tee 23
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 2
                  i32.shl
                  local.get 5
                  i32.const 480
                  i32.add
                  i32.add
                  i32.const -4
                  i32.add
                  local.tee 7
                  local.get 7
                  i32.load
                  local.tee 7
                  local.get 7
                  local.get 17
                  i32.shr_s
                  local.tee 7
                  local.get 17
                  i32.shl
                  i32.sub
                  local.tee 11
                  i32.store
                  local.get 11
                  local.get 16
                  i32.shr_s
                  local.set 24
                  local.get 7
                  local.get 22
                  i32.add
                  local.set 22
                  br 1 (;@6;)
                end
                local.get 14
                br_if 1 (;@5;)
                local.get 2
                i32.const 2
                i32.shl
                local.get 5
                i32.const 480
                i32.add
                i32.add
                i32.const -4
                i32.add
                i32.load
                i32.const 23
                i32.shr_s
                local.set 24
              end
              local.get 24
              i32.const 1
              i32.lt_s
              br_if 2 (;@3;)
              br 1 (;@4;)
            end
            i32.const 2
            local.set 24
            local.get 13
            f64.const 0x1p-1 (;=0.5;)
            f64.ge
            i32.const 1
            i32.xor
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            local.set 24
            br 1 (;@3;)
          end
          block  ;; label = @4
            block  ;; label = @5
              local.get 15
              i32.eqz
              br_if 0 (;@5;)
              i32.const 0
              local.set 15
              br 1 (;@4;)
            end
            i32.const 0
            local.set 15
            local.get 5
            i32.const 480
            i32.add
            local.set 7
            local.get 2
            local.set 12
            loop  ;; label = @5
              local.get 7
              i32.load
              local.set 11
              i32.const 16777215
              local.set 6
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 15
                    br_if 0 (;@8;)
                    local.get 11
                    i32.eqz
                    br_if 1 (;@7;)
                    i32.const 1
                    local.set 15
                    i32.const 16777216
                    local.set 6
                  end
                  local.get 7
                  local.get 6
                  local.get 11
                  i32.sub
                  i32.store
                  br 1 (;@6;)
                end
                i32.const 0
                local.set 15
              end
              local.get 7
              i32.const 4
              i32.add
              local.set 7
              local.get 12
              i32.const -1
              i32.add
              local.tee 12
              br_if 0 (;@5;)
            end
          end
          block  ;; label = @4
            local.get 23
            br_if 0 (;@4;)
            local.get 14
            i32.const -1
            i32.add
            local.tee 7
            i32.const 1
            i32.gt_u
            br_if 0 (;@4;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 7
                br_table 0 (;@6;) 1 (;@5;) 0 (;@6;)
              end
              local.get 2
              i32.const 2
              i32.shl
              local.get 5
              i32.const 480
              i32.add
              i32.add
              i32.const -4
              i32.add
              local.tee 7
              local.get 7
              i32.load
              i32.const 8388607
              i32.and
              i32.store
              br 1 (;@4;)
            end
            local.get 2
            i32.const 2
            i32.shl
            local.get 5
            i32.const 480
            i32.add
            i32.add
            i32.const -4
            i32.add
            local.tee 7
            local.get 7
            i32.load
            i32.const 4194303
            i32.and
            i32.store
          end
          local.get 22
          i32.const 1
          i32.add
          local.set 22
          local.get 24
          i32.const 2
          i32.ne
          br_if 0 (;@3;)
          f64.const 0x1p+0 (;=1;)
          local.get 13
          f64.sub
          local.set 13
          i32.const 2
          local.set 24
          local.get 15
          i32.eqz
          br_if 0 (;@3;)
          local.get 13
          f64.const 0x1p+0 (;=1;)
          local.get 14
          call $scalbn
          f64.sub
          local.set 13
        end
        block  ;; label = @3
          local.get 13
          f64.const 0x0p+0 (;=0;)
          f64.ne
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 2
            local.get 10
            i32.le_s
            br_if 0 (;@4;)
            local.get 19
            local.get 2
            i32.const 2
            i32.shl
            i32.add
            local.set 7
            i32.const 0
            local.set 11
            local.get 2
            local.set 6
            loop  ;; label = @5
              local.get 7
              i32.load
              local.get 11
              i32.or
              local.set 11
              local.get 7
              i32.const -4
              i32.add
              local.set 7
              local.get 6
              i32.const -1
              i32.add
              local.tee 6
              local.get 10
              i32.gt_s
              br_if 0 (;@5;)
            end
            local.get 11
            i32.eqz
            br_if 0 (;@4;)
            local.get 5
            i32.const 480
            i32.add
            local.get 2
            i32.const 2
            i32.shl
            i32.add
            i32.const -4
            i32.add
            local.set 7
            local.get 14
            local.set 9
            loop  ;; label = @5
              local.get 2
              i32.const -1
              i32.add
              local.set 2
              local.get 9
              i32.const -24
              i32.add
              local.set 9
              local.get 7
              i32.load
              local.set 11
              local.get 7
              i32.const -4
              i32.add
              local.set 7
              local.get 11
              i32.eqz
              br_if 0 (;@5;)
              br 4 (;@1;)
            end
          end
          local.get 18
          local.set 7
          local.get 2
          local.set 12
          loop  ;; label = @4
            local.get 12
            i32.const 1
            i32.add
            local.set 12
            local.get 7
            i32.load
            local.set 11
            local.get 7
            i32.const -4
            i32.add
            local.set 7
            local.get 11
            i32.eqz
            br_if 0 (;@4;)
          end
          local.get 5
          i32.const 320
          i32.add
          local.get 3
          local.get 2
          i32.add
          i32.const 3
          i32.shl
          i32.add
          local.set 15
          loop  ;; label = @4
            local.get 5
            i32.const 320
            i32.add
            local.get 2
            local.get 3
            i32.add
            i32.const 3
            i32.shl
            i32.add
            i32.const 66384
            i32.const 13488
            i32.add
            local.get 2
            i32.const 1
            i32.add
            local.tee 6
            local.get 8
            i32.add
            i32.const 2
            i32.shl
            i32.add
            i32.load
            f64.convert_i32_s
            f64.store
            f64.const 0x0p+0 (;=0;)
            local.set 13
            block  ;; label = @5
              local.get 3
              i32.const 1
              i32.lt_s
              br_if 0 (;@5;)
              local.get 0
              local.set 2
              local.get 15
              local.set 7
              local.get 3
              local.set 11
              loop  ;; label = @6
                local.get 13
                local.get 2
                f64.load
                local.get 7
                f64.load
                f64.mul
                f64.add
                local.set 13
                local.get 2
                i32.const 8
                i32.add
                local.set 2
                local.get 7
                i32.const -8
                i32.add
                local.set 7
                local.get 11
                i32.const -1
                i32.add
                local.tee 11
                br_if 0 (;@6;)
              end
            end
            local.get 5
            local.get 6
            i32.const 3
            i32.shl
            i32.add
            local.get 13
            f64.store
            local.get 15
            i32.const 8
            i32.add
            local.set 15
            local.get 6
            local.set 2
            local.get 6
            local.get 12
            i32.lt_s
            br_if 0 (;@4;)
          end
          local.get 12
          local.set 2
          br 1 (;@2;)
        end
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 13
          i32.const 0
          local.get 14
          i32.sub
          call $scalbn
          local.tee 13
          f64.const 0x1p+24 (;=1.67772e+07;)
          f64.ge
          i32.const 1
          i32.xor
          br_if 0 (;@3;)
          local.get 2
          i32.const 2
          i32.shl
          local.set 11
          block  ;; label = @4
            block  ;; label = @5
              local.get 13
              f64.const 0x1p-24 (;=5.96046e-08;)
              f64.mul
              local.tee 21
              f64.abs
              f64.const 0x1p+31 (;=2.14748e+09;)
              f64.lt
              i32.eqz
              br_if 0 (;@5;)
              local.get 21
              i32.trunc_f64_s
              local.set 7
              br 1 (;@4;)
            end
            i32.const -2147483648
            local.set 7
          end
          local.get 5
          i32.const 480
          i32.add
          local.get 11
          i32.add
          local.set 11
          block  ;; label = @4
            block  ;; label = @5
              local.get 13
              local.get 7
              f64.convert_i32_s
              f64.const -0x1p+24 (;=-1.67772e+07;)
              f64.mul
              f64.add
              local.tee 13
              f64.abs
              f64.const 0x1p+31 (;=2.14748e+09;)
              f64.lt
              i32.eqz
              br_if 0 (;@5;)
              local.get 13
              i32.trunc_f64_s
              local.set 6
              br 1 (;@4;)
            end
            i32.const -2147483648
            local.set 6
          end
          local.get 11
          local.get 6
          i32.store
          local.get 2
          i32.const 1
          i32.add
          local.set 2
          br 1 (;@2;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 13
            f64.abs
            f64.const 0x1p+31 (;=2.14748e+09;)
            f64.lt
            i32.eqz
            br_if 0 (;@4;)
            local.get 13
            i32.trunc_f64_s
            local.set 7
            br 1 (;@3;)
          end
          i32.const -2147483648
          local.set 7
        end
        local.get 14
        local.set 9
      end
      local.get 5
      i32.const 480
      i32.add
      local.get 2
      i32.const 2
      i32.shl
      i32.add
      local.get 7
      i32.store
    end
    f64.const 0x1p+0 (;=1;)
    local.get 9
    call $scalbn
    local.set 13
    block  ;; label = @1
      local.get 2
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 2
      i32.const 1
      i32.add
      local.set 6
      local.get 5
      i32.const 480
      i32.add
      local.get 2
      i32.const 2
      i32.shl
      i32.add
      local.set 7
      local.get 5
      local.get 2
      i32.const 3
      i32.shl
      i32.add
      local.set 11
      loop  ;; label = @2
        local.get 11
        local.get 13
        local.get 7
        i32.load
        f64.convert_i32_s
        f64.mul
        f64.store
        local.get 7
        i32.const -4
        i32.add
        local.set 7
        local.get 11
        i32.const -8
        i32.add
        local.set 11
        local.get 13
        f64.const 0x1p-24 (;=5.96046e-08;)
        f64.mul
        local.set 13
        local.get 6
        i32.const -1
        i32.add
        local.tee 6
        i32.const 0
        i32.gt_s
        br_if 0 (;@2;)
      end
      local.get 2
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 5
      local.get 2
      i32.const 3
      i32.shl
      i32.add
      local.set 12
      local.get 2
      local.set 7
      loop  ;; label = @2
        local.get 2
        local.get 7
        local.tee 15
        i32.sub
        local.set 3
        f64.const 0x0p+0 (;=0;)
        local.set 13
        i32.const 0
        local.set 7
        i32.const 0
        local.set 11
        block  ;; label = @3
          loop  ;; label = @4
            local.get 13
            local.get 12
            local.get 7
            i32.add
            f64.load
            i32.const 66384
            i32.const 16256
            i32.add
            local.get 7
            i32.add
            f64.load
            f64.mul
            f64.add
            local.set 13
            local.get 11
            local.get 10
            i32.ge_s
            br_if 1 (;@3;)
            local.get 7
            i32.const 8
            i32.add
            local.set 7
            local.get 11
            local.get 3
            i32.lt_u
            local.set 6
            local.get 11
            i32.const 1
            i32.add
            local.set 11
            local.get 6
            br_if 0 (;@4;)
          end
        end
        local.get 5
        i32.const 160
        i32.add
        local.get 3
        i32.const 3
        i32.shl
        i32.add
        local.get 13
        f64.store
        local.get 12
        i32.const -8
        i32.add
        local.set 12
        local.get 15
        i32.const -1
        i32.add
        local.set 7
        local.get 15
        i32.const 0
        i32.gt_s
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 4
      i32.const 3
      i32.gt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 4
              br_table 1 (;@4;) 2 (;@3;) 2 (;@3;) 0 (;@5;) 1 (;@4;)
            end
            f64.const 0x0p+0 (;=0;)
            local.set 25
            block  ;; label = @5
              local.get 2
              i32.const 1
              i32.lt_s
              br_if 0 (;@5;)
              local.get 2
              i32.const 1
              i32.add
              local.set 11
              local.get 5
              i32.const 160
              i32.add
              local.get 2
              i32.const 3
              i32.shl
              i32.add
              local.tee 6
              i32.const -8
              i32.add
              local.set 7
              local.get 6
              f64.load
              local.set 13
              loop  ;; label = @6
                local.get 7
                local.get 7
                f64.load
                local.tee 26
                local.get 13
                f64.add
                local.tee 21
                f64.store
                local.get 7
                i32.const 8
                i32.add
                local.get 13
                local.get 26
                local.get 21
                f64.sub
                f64.add
                f64.store
                local.get 7
                i32.const -8
                i32.add
                local.set 7
                local.get 21
                local.set 13
                local.get 11
                i32.const -1
                i32.add
                local.tee 11
                i32.const 1
                i32.gt_s
                br_if 0 (;@6;)
              end
              local.get 2
              i32.const 2
              i32.lt_s
              br_if 0 (;@5;)
              local.get 2
              i32.const 1
              i32.add
              local.set 11
              local.get 5
              i32.const 160
              i32.add
              local.get 2
              i32.const 3
              i32.shl
              i32.add
              local.tee 6
              i32.const -8
              i32.add
              local.set 7
              local.get 6
              f64.load
              local.set 13
              loop  ;; label = @6
                local.get 7
                local.get 7
                f64.load
                local.tee 26
                local.get 13
                f64.add
                local.tee 21
                f64.store
                local.get 7
                i32.const 8
                i32.add
                local.get 13
                local.get 26
                local.get 21
                f64.sub
                f64.add
                f64.store
                local.get 7
                i32.const -8
                i32.add
                local.set 7
                local.get 21
                local.set 13
                local.get 11
                i32.const -1
                i32.add
                local.tee 11
                i32.const 2
                i32.gt_s
                br_if 0 (;@6;)
              end
              local.get 2
              i32.const 2
              i32.lt_s
              br_if 0 (;@5;)
              local.get 2
              i32.const 1
              i32.add
              local.set 7
              local.get 5
              i32.const 160
              i32.add
              local.get 2
              i32.const 3
              i32.shl
              i32.add
              local.set 2
              f64.const 0x0p+0 (;=0;)
              local.set 25
              loop  ;; label = @6
                local.get 25
                local.get 2
                f64.load
                f64.add
                local.set 25
                local.get 2
                i32.const -8
                i32.add
                local.set 2
                local.get 7
                i32.const -1
                i32.add
                local.tee 7
                i32.const 2
                i32.gt_s
                br_if 0 (;@6;)
              end
            end
            local.get 5
            f64.load offset=160
            local.set 13
            local.get 24
            br_if 2 (;@2;)
            local.get 1
            local.get 13
            f64.store
            local.get 1
            local.get 25
            f64.store offset=16
            local.get 1
            local.get 5
            i64.load offset=168
            i64.store offset=8
            br 3 (;@1;)
          end
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              i32.const 0
              i32.ge_s
              br_if 0 (;@5;)
              f64.const 0x0p+0 (;=0;)
              local.set 13
              br 1 (;@4;)
            end
            local.get 2
            i32.const 1
            i32.add
            local.set 7
            local.get 5
            i32.const 160
            i32.add
            local.get 2
            i32.const 3
            i32.shl
            i32.add
            local.set 2
            f64.const 0x0p+0 (;=0;)
            local.set 13
            loop  ;; label = @5
              local.get 13
              local.get 2
              f64.load
              f64.add
              local.set 13
              local.get 2
              i32.const -8
              i32.add
              local.set 2
              local.get 7
              i32.const -1
              i32.add
              local.tee 7
              i32.const 0
              i32.gt_s
              br_if 0 (;@5;)
            end
          end
          local.get 1
          local.get 13
          f64.neg
          local.get 13
          local.get 24
          select
          f64.store
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            f64.const 0x0p+0 (;=0;)
            local.set 13
            br 1 (;@3;)
          end
          local.get 2
          i32.const 1
          i32.add
          local.set 11
          local.get 5
          i32.const 160
          i32.add
          local.get 2
          i32.const 3
          i32.shl
          i32.add
          local.set 7
          f64.const 0x0p+0 (;=0;)
          local.set 13
          loop  ;; label = @4
            local.get 13
            local.get 7
            f64.load
            f64.add
            local.set 13
            local.get 7
            i32.const -8
            i32.add
            local.set 7
            local.get 11
            i32.const -1
            i32.add
            local.tee 11
            i32.const 0
            i32.gt_s
            br_if 0 (;@4;)
          end
        end
        local.get 1
        local.get 13
        f64.neg
        local.get 13
        local.get 24
        select
        f64.store
        local.get 5
        f64.load offset=160
        local.get 13
        f64.sub
        local.set 13
        block  ;; label = @3
          local.get 2
          i32.const 1
          i32.lt_s
          br_if 0 (;@3;)
          local.get 5
          i32.const 160
          i32.add
          i32.const 8
          i32.or
          local.set 7
          loop  ;; label = @4
            local.get 13
            local.get 7
            f64.load
            f64.add
            local.set 13
            local.get 7
            i32.const 8
            i32.add
            local.set 7
            local.get 2
            i32.const -1
            i32.add
            local.tee 2
            br_if 0 (;@4;)
          end
        end
        local.get 1
        local.get 13
        f64.neg
        local.get 13
        local.get 24
        select
        f64.store offset=8
        br 1 (;@1;)
      end
      local.get 1
      local.get 13
      f64.neg
      f64.store
      local.get 1
      local.get 25
      f64.neg
      f64.store offset=16
      local.get 1
      local.get 5
      f64.load offset=168
      f64.neg
      f64.store offset=8
    end
    local.get 5
    i32.const 560
    i32.add
    global.set 4
    local.get 22
    i32.const 7
    i32.and)
  (func $__sin (type 40) (param f64 f64 i32) (result f64)
    (local f64 f64 f64)
    local.get 0
    local.get 0
    f64.mul
    local.tee 3
    local.get 3
    local.get 3
    f64.mul
    f64.mul
    local.get 3
    f64.const 0x1.5d93a5acfd57cp-33 (;=1.58969e-10;)
    f64.mul
    f64.const -0x1.ae5e68a2b9cebp-26 (;=-2.50508e-08;)
    f64.add
    f64.mul
    local.get 3
    local.get 3
    f64.const 0x1.71de357b1fe7dp-19 (;=2.75573e-06;)
    f64.mul
    f64.const -0x1.a01a019c161d5p-13 (;=-0.000198413;)
    f64.add
    f64.mul
    f64.const 0x1.111111110f8a6p-7 (;=0.00833333;)
    f64.add
    f64.add
    local.set 4
    local.get 3
    local.get 0
    f64.mul
    local.set 5
    block  ;; label = @1
      local.get 2
      br_if 0 (;@1;)
      local.get 5
      local.get 3
      local.get 4
      f64.mul
      f64.const -0x1.5555555555549p-3 (;=-0.166667;)
      f64.add
      f64.mul
      local.get 0
      f64.add
      return
    end
    local.get 0
    local.get 3
    local.get 1
    f64.const 0x1p-1 (;=0.5;)
    f64.mul
    local.get 5
    local.get 4
    f64.mul
    f64.sub
    f64.mul
    local.get 1
    f64.sub
    local.get 5
    f64.const 0x1.5555555555549p-3 (;=0.166667;)
    f64.mul
    f64.add
    f64.sub)
  (func $__cos (type 30) (param f64 f64) (result f64)
    (local f64 f64 f64)
    f64.const 0x1p+0 (;=1;)
    local.get 0
    local.get 0
    f64.mul
    local.tee 2
    f64.const 0x1p-1 (;=0.5;)
    f64.mul
    local.tee 3
    f64.sub
    local.tee 4
    f64.const 0x1p+0 (;=1;)
    local.get 4
    f64.sub
    local.get 3
    f64.sub
    local.get 2
    local.get 2
    local.get 2
    local.get 2
    f64.const 0x1.a01a019cb159p-16 (;=2.48016e-05;)
    f64.mul
    f64.const -0x1.6c16c16c15177p-10 (;=-0.00138889;)
    f64.add
    f64.mul
    f64.const 0x1.555555555554cp-5 (;=0.0416667;)
    f64.add
    f64.mul
    local.get 2
    local.get 2
    f64.mul
    local.tee 3
    local.get 3
    f64.mul
    local.get 2
    local.get 2
    f64.const -0x1.8fae9be8838d4p-37 (;=-1.13596e-11;)
    f64.mul
    f64.const 0x1.1ee9ebdb4b1c4p-29 (;=2.08757e-09;)
    f64.add
    f64.mul
    f64.const -0x1.27e4f809c52adp-22 (;=-2.75573e-07;)
    f64.add
    f64.mul
    f64.add
    f64.mul
    local.get 0
    local.get 1
    f64.mul
    f64.sub
    f64.add
    f64.add)
  (func $__tan (type 40) (param f64 f64 i32) (result f64)
    (local i64 i32 i32 f64 f64 f64)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.reinterpret_f64
        local.tee 3
        i64.const 9223372002495037440
        i64.and
        i64.const 4604249089280835585
        i64.lt_u
        local.tee 4
        i32.eqz
        br_if 0 (;@2;)
        br 1 (;@1;)
      end
      f64.const 0x1.921fb54442d18p-1 (;=0.785398;)
      local.get 0
      f64.neg
      local.get 0
      local.get 3
      i64.const 0
      i64.lt_s
      local.tee 5
      select
      f64.sub
      f64.const 0x1.1a62633145c07p-55 (;=3.06162e-17;)
      local.get 1
      f64.neg
      local.get 1
      local.get 5
      select
      f64.sub
      f64.add
      local.set 0
      local.get 3
      i64.const 63
      i64.shr_u
      i32.wrap_i64
      local.set 5
      f64.const 0x0p+0 (;=0;)
      local.set 1
    end
    local.get 0
    local.get 0
    local.get 0
    local.get 0
    f64.mul
    local.tee 6
    f64.mul
    local.tee 7
    f64.const 0x1.5555555555563p-2 (;=0.333333;)
    f64.mul
    local.get 1
    local.get 6
    local.get 1
    local.get 7
    local.get 6
    local.get 6
    f64.mul
    local.tee 8
    local.get 8
    local.get 8
    local.get 8
    local.get 8
    f64.const -0x1.375cbdb605373p-16 (;=-1.85586e-05;)
    f64.mul
    f64.const 0x1.47e88a03792a6p-14 (;=7.81794e-05;)
    f64.add
    f64.mul
    f64.const 0x1.344d8f2f26501p-11 (;=0.000588041;)
    f64.add
    f64.mul
    f64.const 0x1.d6d22c9560328p-9 (;=0.00359208;)
    f64.add
    f64.mul
    f64.const 0x1.664f48406d637p-6 (;=0.0218695;)
    f64.add
    f64.mul
    f64.const 0x1.111111110fe7ap-3 (;=0.133333;)
    f64.add
    local.get 6
    local.get 8
    local.get 8
    local.get 8
    local.get 8
    local.get 8
    f64.const 0x1.b2a7074bf7ad4p-16 (;=2.59073e-05;)
    f64.mul
    f64.const 0x1.2b80f32f0a7e9p-14 (;=7.14072e-05;)
    f64.add
    f64.mul
    f64.const 0x1.026f71a8d1068p-12 (;=0.000246463;)
    f64.add
    f64.mul
    f64.const 0x1.7dbc8fee08315p-10 (;=0.00145621;)
    f64.add
    f64.mul
    f64.const 0x1.226e3e96e8493p-7 (;=0.00886324;)
    f64.add
    f64.mul
    f64.const 0x1.ba1ba1bb341fep-5 (;=0.0539683;)
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.add
    local.tee 6
    f64.add
    local.set 8
    block  ;; label = @1
      local.get 4
      br_if 0 (;@1;)
      i32.const 1
      local.get 2
      i32.const 1
      i32.shl
      i32.sub
      f64.convert_i32_s
      local.tee 1
      local.get 0
      local.get 6
      local.get 8
      local.get 8
      f64.mul
      local.get 8
      local.get 1
      f64.add
      f64.div
      f64.sub
      f64.add
      local.tee 8
      local.get 8
      f64.add
      f64.sub
      local.tee 8
      f64.neg
      local.get 8
      local.get 5
      select
      return
    end
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      f64.const -0x1p+0 (;=-1;)
      local.get 8
      f64.div
      local.tee 1
      local.get 8
      i64.reinterpret_f64
      i64.const -4294967296
      i64.and
      f64.reinterpret_i64
      local.tee 7
      local.get 1
      i64.reinterpret_f64
      i64.const -4294967296
      i64.and
      f64.reinterpret_i64
      local.tee 8
      f64.mul
      f64.const 0x1p+0 (;=1;)
      f64.add
      local.get 6
      local.get 7
      local.get 0
      f64.sub
      f64.sub
      local.get 8
      f64.mul
      f64.add
      f64.mul
      local.get 8
      f64.add
      local.set 8
    end
    local.get 8)
  (func $wctomb (type 26) (param i32 i32) (result i32)
    local.get 0
    i32.const 0
    i32.store8
    local.get 0)
  (func $fputs (type 26) (param i32 i32) (result i32)
    i32.const 0)
  (func $abort (type 21)
    i32.const 66384
    i32.const 16320
    i32.add
    i32.const 5
    call $rts_trap
    unreachable)
  (func $strerror (type 19) (param i32) (result i32)
    i32.const 66384
    i32.const 16326
    i32.add)
  (func $link_start (type 41)
    call $__wasm_call_ctors
    call $rts_start)
  (table (;0;) 30 30 funcref)
  (memory (;0;) 2)
  (global (;0;) (mut i32) (i32.const -559038737))
  (global (;1;) (mut i64) (i64.const 0))
  (global (;2;) (mut i64) (i64.const 0))
  (global (;3;) (mut i64) (i64.const 0))
  (global (;4;) (mut i32) (i32.const 65536))
  (global (;5;) (mut i32) (i32.const 0))
  (global (;6;) (mut i32) (i32.const 0))
  (global (;7;) (mut i32) (i32.const 0))
  (global (;8;) i32 (i32.const 82720))
  (export "_start" (func $_start))
  (export "memory" (memory 0))
  (export "table" (table 0))
  (start $link_start)
  (elem (;0;) (i32.const 8) func $@digits_dec)
  (elem (;1;) (i32.const 7) func $@digits_hex)
  (elem (;2;) (i32.const 4) func $anon-func-294.16)
  (elem (;3;) (i32.const 3) func $anon-func-295.16)
  (elem (;4;) (i32.const 0) func $anon-func-332.15)
  (elem (;5;) (i32.const 1) func $anon-func-330.15)
  (elem (;6;) (i32.const 2) func $enqueue)
  (elem (;7;) (i32.const 5) func $fail)
  (elem (;8;) (i32.const 6) func $fulfill)
  (elem (;9;) (i32.const 9) func $next)
  (elem (;10;) (i32.const 10) func $anon-func-93.3)
  (elem (;11;) (i32.const 11) func $anon-func-91.3)
  (elem (;12;) (i32.const 12) func $next.1)
  (elem (;13;) (i32.const 13) func $anon-func-80.3)
  (elem (;14;) (i32.const 14) func $anon-func-78.3)
  (elem (;15;) (i32.const 15) func $next.2)
  (elem (;16;) (i32.const 16) func $anon-func-72.3)
  (elem (;17;) (i32.const 17) func $next.3)
  (elem (;18;) (i32.const 18) func $anon-func-66.3)
  (elem (;19;) (i32.const 19) func $next.4)
  (elem (;20;) (i32.const 20) func $anon-func-60.3)
  (elem (;21;) (i32.const 21) func $next.5)
  (elem (;22;) (i32.const 22) func $anon-func-54.3)
  (elem (;23;) (i32.const 23) func $anon-func-52.3)
  (elem (;24;) (i32.const 24) func $anon-func-50.3)
  (elem (;25;) (i32.const 25) func $anon-func-48.3)
  (elem (;26;) (i32.const 26) func $anon-func-46.3)
  (elem (;27;) (i32.const 27) func $anon-func-44.3)
  (elem (;28;) (i32.const 28) func $get_version $sn_write)
  (data (;0;) (i32.const 65540) "Cannot grow memory.")
  (data (;1;) (i32.const 65560) "bigint function error")
  (data (;2;) (i32.const 65584) "assertion failed at wasmtime/tests/debug/testsuite/fib-wasm.mo:11.1-11.33")
  (data (;3;) (i32.const 65660) "arithmetic overflow")
  (data (;4;) (i32.const 65680) "pattern failed")
  (data (;5;) (i32.const 65696) "assertion failed at prelude:322.18-322.34")
  (data (;6;) (i32.const 65740) "\07\00\00\00\03\00\00\00\00\00\00\00")
  (data (;7;) (i32.const 65752) "\07\00\00\00\04\00\00\00\00\00\00\00")
  (data (;8;) (i32.const 65764) "assertion failed at prelude:309.18-309.34")
  (data (;9;) (i32.const 65808) "\0a\00\00\00\01\00\00\00]")
  (data (;10;) (i32.const 65820) "\0a\00\00\00\01\00\00\00 ")
  (data (;11;) (i32.const 65832) "\0a\00\00\00\02\00\00\00, ")
  (data (;12;) (i32.const 65844) "internal error: object field not found")
  (data (;13;) (i32.const 65884) "\0a\00\00\00\04\00\00\00[var")
  (data (;14;) (i32.const 65896) "\0a\00\00\00\01\00\00\00[")
  (data (;15;) (i32.const 65908) "\0a\00\00\00\02\00\00\00()")
  (data (;16;) (i32.const 65920) "\0a\00\00\00\01\00\00\00#")
  (data (;17;) (i32.const 65932) "\0a\00\00\00\01\00\00\00)")
  (data (;18;) (i32.const 65944) "\0a\00\00\00\01\00\00\00(")
  (data (;19;) (i32.const 65956) "\0a\00\00\00\04\00\00\00null")
  (data (;20;) (i32.const 65968) "\0a\00\00\00\02\00\00\00?(")
  (data (;21;) (i32.const 65980) "\0a\00\00\00\01\00\00\00?")
  (data (;22;) (i32.const 65992) "\0a\00\00\00\01\00\00\00\22")
  (data (;23;) (i32.const 66004) "\0a\00\00\00\01\00\00\000")
  (data (;24;) (i32.const 66016) "\07\00\00\00\07\00\00\00\00\00\00\00")
  (data (;25;) (i32.const 66028) "\0a\00\00\00\01\00\00\00\5c")
  (data (;26;) (i32.const 66040) "\0a\00\00\00\01\00\00\00'")
  (data (;27;) (i32.const 66052) "\0a\00\00\00\05\00\00\00false")
  (data (;28;) (i32.const 66068) "\0a\00\00\00\04\00\00\00true")
  (data (;29;) (i32.const 66080) "\0a\00\00\00\02\00\00\000x")
  (data (;30;) (i32.const 66092) "codepoint out of range")
  (data (;31;) (i32.const 66116) "\0a\00\00\00\01\00\00\00+")
  (data (;32;) (i32.const 66128) "\0a\00\00\00\01\00\00\00-")
  (data (;33;) (i32.const 66140) "\07\00\00\00\08\00\00\00\00\00\00\00")
  (data (;34;) (i32.const 66152) "Natural subtraction underflow")
  (data (;35;) (i32.const 66184) "\0a\00\00\00\01\00\00\00_")
  (data (;36;) (i32.const 66196) "\0a\00\00\00\00\00\00\00")
  (data (;37;) (i32.const 66204) "\f3\84\02I")
  (data (;38;) (i32.const 66208) "Array index out of bounds")
  (data (;39;) (i32.const 66236) "\0a\00\00\00\19\00\00\00Array index out of bounds")
  (data (;40;) (i32.const 66272) "internal error: unexpected state entering Idle")
  (data (;41;) (i32.const 66320) "internal error: unexpected state entering InInit")
  (data (;42;) (i32.const 66368) "\03\00\00\00\00\00\00\00")
  (data (;43;) (i32.const 66384) "IDL error: \00RTS error: \000.1\00\18\00\00\00\00\00\00\00not shortest encoding\00int overflow\00empty input\00missing magic bytes\00overflow in number of types\00too many types\00illegal type table\00primitive type in type table\00skip_any: too deeply nested record\00skip_any: encountered empty\00skip_any: unknown prim\00skip_any: recursive record\00skip_any: variant tag too large\00skip_any: func\00skip_any: service\00skip_any: skipping references\00invalid type argument\00not shortest encoding\00absurdly large number\00%f\00byte read out of buffer\00word read out of buffer\00advance out of buffer\00UTF-8 validation failure\00\00\00\00\00\00\00\fc\ff\ff\ffremember_closure: Storing unboxed literals not supports\00\00\00\00\00recall_closure: No closure table allocated\00recall_closure: Closure index out of range\00recall_closure: Closure index not in table\00text_concat: Text too large\00text_iter_next: Iter already done\00alloc_blob: Text too large\00compute_crc32: Blob expected\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\960\07w,a\0e\ee\baQ\09\99\19\c4m\07\8f\f4jp5\a5c\e9\a3\95d\9e2\88\db\0e\a4\b8\dcy\1e\e9\d5\e0\88\d9\d2\97+L\b6\09\bd|\b1~\07-\b8\e7\91\1d\bf\90d\10\b7\1d\f2 \b0jHq\b9\f3\deA\be\84}\d4\da\1a\eb\e4\ddmQ\b5\d4\f4\c7\85\d3\83V\98l\13\c0\a8kdz\f9b\fd\ec\c9e\8aO\5c\01\14\d9l\06cc=\0f\fa\f5\0d\08\8d\c8 n;^\10iL\e4A`\d5rqg\a2\d1\e4\03<G\d4\04K\fd\85\0d\d2k\b5\0a\a5\fa\a8\b55l\98\b2B\d6\c9\bb\db@\f9\bc\ac\e3l\d82u\5c\dfE\cf\0d\d6\dcY=\d1\ab\ac0\d9&:\00\deQ\80Q\d7\c8\16a\d0\bf\b5\f4\b4!#\c4\b3V\99\95\ba\cf\0f\a5\bd\b8\9e\b8\02(\08\88\05_\b2\d9\0c\c6$\e9\0b\b1\87|o/\11LhX\ab\1da\c1=-f\b6\90A\dcv\06q\db\01\bc \d2\98*\10\d5\ef\89\85\b1q\1f\b5\b6\06\a5\e4\bf\9f3\d4\b8\e8\a2\c9\07x4\f9\00\0f\8e\a8\09\96\18\98\0e\e1\bb\0dj\7f-=m\08\97ld\91\01\5cc\e6\f4Qkkbal\1c\d80e\85N\00b\f2\ed\95\06l{\a5\01\1b\c1\f4\08\82W\c4\0f\f5\c6\d9\b0eP\e9\b7\12\ea\b8\be\8b|\88\b9\fc\df\1d\ddbI-\da\15\f3|\d3\8ceL\d4\fbXa\b2M\ceQ\b5:t\00\bc\a3\e20\bb\d4A\a5\dfJ\d7\95\d8=m\c4\d1\a4\fb\f4\d6\d3j\e9iC\fc\d9n4F\88g\ad\d0\b8`\das-\04D\e5\1d\033_L\0a\aa\c9|\0d\dd<q\05P\aaA\02'\10\10\0b\be\86 \0c\c9%\b5hW\b3\85o \09\d4f\b9\9f\e4a\ce\0e\f9\de^\98\c9\d9)\22\98\d0\b0\b4\a8\d7\c7\17=\b3Y\81\0d\b4.;\5c\bd\b7\adl\ba\c0 \83\b8\ed\b6\b3\bf\9a\0c\e2\b6\03\9a\d2\b1t9G\d5\ea\afw\d2\9d\15&\db\04\83\16\dcs\12\0bc\e3\84;d\94>jm\0d\a8Zjz\0b\cf\0e\e4\9d\ff\09\93'\ae\00\0a\b1\9e\07}D\93\0f\f0\d2\a3\08\87h\f2\01\1e\fe\c2\06i]Wb\f7\cbge\80q6l\19\e7\06knv\1b\d4\fe\e0+\d3\89Zz\da\10\ccJ\ddgo\df\b9\f9\f9\ef\be\8eC\be\b7\17\d5\8e\b0`\e8\a3\d6\d6~\93\d1\a1\c4\c2\d88R\f2\dfO\f1g\bb\d1gW\bc\a6\dd\06\b5?K6\b2H\da+\0d\d8L\1b\0a\af\f6J\036`z\04A\c3\ef`\dfU\dfg\a8\ef\8en1y\beiF\8c\b3a\cb\1a\83f\bc\a0\d2o%6\e2hR\95w\0c\cc\03G\0b\bb\b9\16\02\22/&\05U\be;\ba\c5(\0b\bd\b2\92Z\b4+\04j\b3\5c\a7\ff\d7\c21\cf\d0\b5\8b\9e\d9,\1d\ae\de[\b0\c2d\9b&\f2c\ec\9c\a3ju\0a\93m\02\a9\06\09\9c?6\0e\eb\85g\07r\13W\00\05\82J\bf\95\14z\b8\e2\ae+\b1{8\1b\b6\0c\9b\8e\d2\92\0d\be\d5\e5\b7\ef\dc|!\df\db\0b\d4\d2\d3\86B\e2\d4\f1\f8\b3\ddhn\83\da\1f\cd\16\be\81[&\b9\f6\e1w\b0owG\b7\18\e6Z\08\88pj\0f\ff\ca;\06f\5c\0b\01\11\ff\9ee\8fi\aeb\f8\d3\ffkaE\cfl\16x\e2\0a\a0\ee\d2\0d\d7T\83\04N\c2\b3\039a&g\a7\f7\16`\d0MGiI\dbwn>Jj\d1\ae\dcZ\d6\d9f\0b\df@\f0;\d87S\ae\bc\a9\c5\9e\bb\de\7f\cf\b2G\e9\ff\b50\1c\f2\bd\bd\8a\c2\ba\ca0\93\b3S\a6\a3\b4$\056\d0\ba\93\06\d7\cd)W\deT\bfg\d9#.zf\b3\b8Ja\c4\02\1bh]\94+o*7\be\0b\b4\a1\8e\0c\c3\1b\df\05Z\8d\ef\02-ic_url_decode: Not an URL\00ic_url_decode: Not an even number of hex digits\00ic_url_decode: CRC-8 mismatch\00ic:\00ic_url_decode: Wrong URL scheme (not 'ic:')\00ic_url_decode: Not all uppercase hex digit\00\00\00\00\00\00\008\fa\feB.\e6?0g\c7\93W\f3.=\00\00\00\00\00\00\e0\bf`UUUUU\e5\bf\06\00\00\00\00\00\e0?NUY\99\99\99\e9?z\a4)UUU\e5\bf\e9EH\9b[I\f2\bf\c3?&\8b+\00\f0?\00\00\00\00\00\a0\f6?\00\00\00\00\00\00\00\00\00\c8\b9\f2\82,\d6\bf\80V7($\b4\fa<\00\00\00\00\00\80\f6?\00\00\00\00\00\00\00\00\00\08X\bf\bd\d1\d5\bf \f7\e0\d8\08\a5\1c\bd\00\00\00\00\00`\f6?\00\00\00\00\00\00\00\00\00XE\17wv\d5\bfmP\b6\d5\a4b#\bd\00\00\00\00\00@\f6?\00\00\00\00\00\00\00\00\00\f8-\87\ad\1a\d5\bf\d5g\b0\9e\e4\84\e6\bc\00\00\00\00\00 \f6?\00\00\00\00\00\00\00\00\00xw\95_\be\d4\bf\e0>)\93i\1b\04\bd\00\00\00\00\00\00\f6?\00\00\00\00\00\00\00\00\00`\1c\c2\8ba\d4\bf\cc\84LH/\d8\13=\00\00\00\00\00\e0\f5?\00\00\00\00\00\00\00\00\00\a8\86\860\04\d4\bf:\0b\82\ed\f3B\dc<\00\00\00\00\00\c0\f5?\00\00\00\00\00\00\00\00\00HiUL\a6\d3\bf`\94Q\86\c6\b1 =\00\00\00\00\00\a0\f5?\00\00\00\00\00\00\00\00\00\80\98\9a\ddG\d3\bf\92\80\c5\d4MY%=\00\00\00\00\00\80\f5?\00\00\00\00\00\00\00\00\00 \e1\ba\e2\e8\d2\bf\d8+\b7\99\1e{&=\00\00\00\00\00`\f5?\00\00\00\00\00\00\00\00\00\88\de\13Z\89\d2\bf?\b0\cf\b6\14\ca\15=\00\00\00\00\00`\f5?\00\00\00\00\00\00\00\00\00\88\de\13Z\89\d2\bf?\b0\cf\b6\14\ca\15=\00\00\00\00\00@\f5?\00\00\00\00\00\00\00\00\00x\cf\fbA)\d2\bfv\daS($Z\16\bd\00\00\00\00\00 \f5?\00\00\00\00\00\00\00\00\00\98i\c1\98\c8\d1\bf\04T\e7h\bc\af\1f\bd\00\00\00\00\00\00\f5?\00\00\00\00\00\00\00\00\00\a8\ab\ab\5cg\d1\bf\f0\a8\823\c6\1f\1f=\00\00\00\00\00\e0\f4?\00\00\00\00\00\00\00\00\00H\ae\f9\8b\05\d1\bffZ\05\fd\c4\a8&\bd\00\00\00\00\00\c0\f4?\00\00\00\00\00\00\00\00\00\90s\e2$\a3\d0\bf\0e\03\f4~\eek\0c\bd\00\00\00\00\00\a0\f4?\00\00\00\00\00\00\00\00\00\d0\b4\94%@\d0\bf\7f-\f4\9e\b86\f0\bc\00\00\00\00\00\a0\f4?\00\00\00\00\00\00\00\00\00\d0\b4\94%@\d0\bf\7f-\f4\9e\b86\f0\bc\00\00\00\00\00\80\f4?\00\00\00\00\00\00\00\00\00@^m\18\b9\cf\bf\87<\99\ab*W\0d=\00\00\00\00\00`\f4?\00\00\00\00\00\00\00\00\00`\dc\cb\ad\f0\ce\bf$\af\86\9c\b7&+=\00\00\00\00\00@\f4?\00\00\00\00\00\00\00\00\00\f0*n\07'\ce\bf\10\ff?TO/\17\bd\00\00\00\00\00 \f4?\00\00\00\00\00\00\00\00\00\c0Ok!\5c\cd\bf\1bh\ca\bb\91\ba!=\00\00\00\00\00\00\f4?\00\00\00\00\00\00\00\00\00\a0\9a\c7\f7\8f\cc\bf4\84\9fhOy'=\00\00\00\00\00\00\f4?\00\00\00\00\00\00\00\00\00\a0\9a\c7\f7\8f\cc\bf4\84\9fhOy'=\00\00\00\00\00\e0\f3?\00\00\00\00\00\00\00\00\00\90-t\86\c2\cb\bf\8f\b7\8b1\b0N\19=\00\00\00\00\00\c0\f3?\00\00\00\00\00\00\00\00\00\c0\80N\c9\f3\ca\bff\90\cd?cN\ba<\00\00\00\00\00\a0\f3?\00\00\00\00\00\00\00\00\00\b0\e2\1f\bc#\ca\bf\ea\c1F\dcd\8c%\bd\00\00\00\00\00\a0\f3?\00\00\00\00\00\00\00\00\00\b0\e2\1f\bc#\ca\bf\ea\c1F\dcd\8c%\bd\00\00\00\00\00\80\f3?\00\00\00\00\00\00\00\00\00P\f4\9cZR\c9\bf\e3\d4\c1\04\d9\d1*\bd\00\00\00\00\00`\f3?\00\00\00\00\00\00\00\00\00\d0 e\a0\7f\c8\bf\09\fa\db\7f\bf\bd+=\00\00\00\00\00@\f3?\00\00\00\00\00\00\00\00\00\e0\10\02\89\ab\c7\bfXJSr\90\db+=\00\00\00\00\00@\f3?\00\00\00\00\00\00\00\00\00\e0\10\02\89\ab\c7\bfXJSr\90\db+=\00\00\00\00\00 \f3?\00\00\00\00\00\00\00\00\00\d0\19\e7\0f\d6\c6\bff\e2\b2\a3j\e4\10\bd\00\00\00\00\00\00\f3?\00\00\00\00\00\00\00\00\00\90\a7p0\ff\c5\bf9P\10\9fC\9e\1e\bd\00\00\00\00\00\00\f3?\00\00\00\00\00\00\00\00\00\90\a7p0\ff\c5\bf9P\10\9fC\9e\1e\bd\00\00\00\00\00\e0\f2?\00\00\00\00\00\00\00\00\00\b0\a1\e3\e5&\c5\bf\8f[\07\90\8b\de \bd\00\00\00\00\00\c0\f2?\00\00\00\00\00\00\00\00\00\80\cbl+M\c4\bf<x5a\c1\0c\17=\00\00\00\00\00\c0\f2?\00\00\00\00\00\00\00\00\00\80\cbl+M\c4\bf<x5a\c1\0c\17=\00\00\00\00\00\a0\f2?\00\00\00\00\00\00\00\00\00\90\1e \fcq\c3\bf:T'M\86x\f1<\00\00\00\00\00\80\f2?\00\00\00\00\00\00\00\00\00\f0\1f\f8R\95\c2\bf\08\c4q\170\8d$\bd\00\00\00\00\00`\f2?\00\00\00\00\00\00\00\00\00`/\d5*\b7\c1\bf\96\a3\11\18\a4\80.\bd\00\00\00\00\00`\f2?\00\00\00\00\00\00\00\00\00`/\d5*\b7\c1\bf\96\a3\11\18\a4\80.\bd\00\00\00\00\00@\f2?\00\00\00\00\00\00\00\00\00\90\d0|~\d7\c0\bf\f4[\e8\88\96i\0a=\00\00\00\00\00@\f2?\00\00\00\00\00\00\00\00\00\90\d0|~\d7\c0\bf\f4[\e8\88\96i\0a=\00\00\00\00\00 \f2?\00\00\00\00\00\00\00\00\00\e0\db1\91\ec\bf\bf\f23\a3\5cTu%\bd\00\00\00\00\00\00\f2?\00\00\00\00\00\00\00\00\00\00+n\07'\be\bf<\00\f0*,4*=\00\00\00\00\00\00\f2?\00\00\00\00\00\00\00\00\00\00+n\07'\be\bf<\00\f0*,4*=\00\00\00\00\00\e0\f1?\00\00\00\00\00\00\00\00\00\c0[\8fT^\bc\bf\06\be_XW\0c\1d\bd\00\00\00\00\00\c0\f1?\00\00\00\00\00\00\00\00\00\e0J:m\92\ba\bf\c8\aa[\e859%=\00\00\00\00\00\c0\f1?\00\00\00\00\00\00\00\00\00\e0J:m\92\ba\bf\c8\aa[\e859%=\00\00\00\00\00\a0\f1?\00\00\00\00\00\00\00\00\00\a01\d6E\c3\b8\bfhV/M)|\13=\00\00\00\00\00\a0\f1?\00\00\00\00\00\00\00\00\00\a01\d6E\c3\b8\bfhV/M)|\13=\00\00\00\00\00\80\f1?\00\00\00\00\00\00\00\00\00`\e5\8a\d2\f0\b6\bf\das3\c97\97&\bd\00\00\00\00\00`\f1?\00\00\00\00\00\00\00\00\00 \06?\07\1b\b5\bfW^\c6a[\02\1f=\00\00\00\00\00`\f1?\00\00\00\00\00\00\00\00\00 \06?\07\1b\b5\bfW^\c6a[\02\1f=\00\00\00\00\00@\f1?\00\00\00\00\00\00\00\00\00\e0\1b\96\d7A\b3\bf\df\13\f9\cc\da^,=\00\00\00\00\00@\f1?\00\00\00\00\00\00\00\00\00\e0\1b\96\d7A\b3\bf\df\13\f9\cc\da^,=\00\00\00\00\00 \f1?\00\00\00\00\00\00\00\00\00\80\a3\ee6e\b1\bf\09\a3\8fv^|\14=\00\00\00\00\00\00\f1?\00\00\00\00\00\00\00\00\00\80\11\c00\0a\af\bf\91\8e6\83\9eY-=\00\00\00\00\00\00\f1?\00\00\00\00\00\00\00\00\00\80\11\c00\0a\af\bf\91\8e6\83\9eY-=\00\00\00\00\00\e0\f0?\00\00\00\00\00\00\00\00\00\80\19q\ddB\ab\bfLp\d6\e5z\82\1c=\00\00\00\00\00\e0\f0?\00\00\00\00\00\00\00\00\00\80\19q\ddB\ab\bfLp\d6\e5z\82\1c=\00\00\00\00\00\c0\f0?\00\00\00\00\00\00\00\00\00\c02\f6Xt\a7\bf\ee\a1\f24F\fc,\bd\00\00\00\00\00\c0\f0?\00\00\00\00\00\00\00\00\00\c02\f6Xt\a7\bf\ee\a1\f24F\fc,\bd\00\00\00\00\00\a0\f0?\00\00\00\00\00\00\00\00\00\c0\fe\b9\87\9e\a3\bf\aa\fe&\f5\b7\02\f5<\00\00\00\00\00\a0\f0?\00\00\00\00\00\00\00\00\00\c0\fe\b9\87\9e\a3\bf\aa\fe&\f5\b7\02\f5<\00\00\00\00\00\80\f0?\00\00\00\00\00\00\00\00\00\00x\0e\9b\82\9f\bf\e4\09~|&\80)\bd\00\00\00\00\00\80\f0?\00\00\00\00\00\00\00\00\00\00x\0e\9b\82\9f\bf\e4\09~|&\80)\bd\00\00\00\00\00`\f0?\00\00\00\00\00\00\00\00\00\80\d5\07\1b\b9\97\bf9\a6\fa\93T\8d(\bd\00\00\00\00\00@\f0?\00\00\00\00\00\00\00\00\00\00\fc\b0\a8\c0\8f\bf\9c\a6\d3\f6|\1e\df\bc\00\00\00\00\00@\f0?\00\00\00\00\00\00\00\00\00\00\fc\b0\a8\c0\8f\bf\9c\a6\d3\f6|\1e\df\bc\00\00\00\00\00 \f0?\00\00\00\00\00\00\00\00\00\00\10k*\e0\7f\bf\e4@\da\0d?\e2\19\bd\00\00\00\00\00 \f0?\00\00\00\00\00\00\00\00\00\00\10k*\e0\7f\bf\e4@\da\0d?\e2\19\bd\00\00\00\00\00\00\f0?\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\f0?\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\c0\ef?\00\00\00\00\00\00\00\00\00\00\89u\15\10\80?\e8+\9d\99k\c7\10\bd\00\00\00\00\00\80\ef?\00\00\00\00\00\00\00\00\00\80\93XV \90?\d2\f7\e2\06[\dc#\bd\00\00\00\00\00@\ef?\00\00\00\00\00\00\00\00\00\00\c9(%I\98?4\0cZ2\ba\a0*\bd\00\00\00\00\00\00\ef?\00\00\00\00\00\00\00\00\00@\e7\89]A\a0?S\d7\f1\5c\c0\11\01=\00\00\00\00\00\c0\ee?\00\00\00\00\00\00\00\00\00\00.\d4\aef\a4?(\fd\bdus\16,\bd\00\00\00\00\00\80\ee?\00\00\00\00\00\00\00\00\00\c0\9f\14\aa\94\a8?}&Z\d0\95y\19\bd\00\00\00\00\00@\ee?\00\00\00\00\00\00\00\00\00\c0\dd\cds\cb\ac?\07(\d8G\f2h\1a\bd\00\00\00\00\00 \ee?\00\00\00\00\00\00\00\00\00\c0\06\c01\ea\ae?{;\c9O>\11\0e\bd\00\00\00\00\00\e0\ed?\00\00\00\00\00\00\00\00\00`F\d1;\97\b1?\9b\9e\0dV]2%\bd\00\00\00\00\00\a0\ed?\00\00\00\00\00\00\00\00\00\e0\d1\a7\f5\bd\b3?\d7N\db\a5^\c8,=\00\00\00\00\00`\ed?\00\00\00\00\00\00\00\00\00\a0\97MZ\e9\b5?\1e\1d]<\06i,\bd\00\00\00\00\00@\ed?\00\00\00\00\00\00\00\00\00\c0\ea\0a\d3\00\b7?2\ed\9d\a9\8d\1e\ec<\00\00\00\00\00\00\ed?\00\00\00\00\00\00\00\00\00@Y]^3\b9?\daG\bd:\5c\11#=\00\00\00\00\00\c0\ec?\00\00\00\00\00\00\00\00\00`\ad\8d\c8j\bb?\e5h\f7+\80\90\13\bd\00\00\00\00\00\a0\ec?\00\00\00\00\00\00\00\00\00@\bc\01X\88\bc?\d3\acZ\c6\d1F&=\00\00\00\00\00`\ec?\00\00\00\00\00\00\00\00\00 \0a\839\c7\be?\e0E\e6\afh\c0-\bd\00\00\00\00\00@\ec?\00\00\00\00\00\00\00\00\00\e0\db9\91\e8\bf?\fd\0a\a1O\d64%\bd\00\00\00\00\00\00\ec?\00\00\00\00\00\00\00\00\00\e0'\82\8e\17\c1?\f2\07-\cex\ef!=\00\00\00\00\00\e0\eb?\00\00\00\00\00\00\00\00\00\f0#~+\aa\c1?4\998D\8e\a7,=\00\00\00\00\00\a0\eb?\00\00\00\00\00\00\00\00\00\80\86\0ca\d1\c2?\a1\b4\81\cbl\9d\03=\00\00\00\00\00\80\eb?\00\00\00\00\00\00\00\00\00\90\15\b0\fce\c3?\89rK#\a8/\c6<\00\00\00\00\00@\eb?\00\00\00\00\00\00\00\00\00\b03\83=\91\c4?x\b6\fdTy\83%=\00\00\00\00\00 \eb?\00\00\00\00\00\00\00\00\00\b0\a1\e4\e5'\c5?\c7}i\e5\e83&=\00\00\00\00\00\e0\ea?\00\00\00\00\00\00\00\00\00\10\8c\beNW\c6?x.<,\8b\cf\19=\00\00\00\00\00\c0\ea?\00\00\00\00\00\00\00\00\00pu\8b\12\f0\c6?\e1!\9c\e5\8d\11%\bd\00\00\00\00\00\a0\ea?\00\00\00\00\00\00\00\00\00PD\85\8d\89\c7?\05C\91p\10f\1c\bd\00\00\00\00\00`\ea?\00\00\00\00\00\00\00\00\00\009\eb\af\be\c8?\d1,\e9\aaT=\07\bd\00\00\00\00\00@\ea?\00\00\00\00\00\00\00\00\00\00\f7\dcZZ\c9?o\ff\a0X(\f2\07=\00\00\00\00\00\00\ea?\00\00\00\00\00\00\00\00\00\e0\8a<\ed\93\ca?i!VPCr(\bd\00\00\00\00\00\e0\e9?\00\00\00\00\00\00\00\00\00\d0[W\d81\cb?\aa\e1\acN\8d5\0c\bd\00\00\00\00\00\c0\e9?\00\00\00\00\00\00\00\00\00\e0;8\87\d0\cb?\b6\12TY\c4K-\bd\00\00\00\00\00\a0\e9?\00\00\00\00\00\00\00\00\00\10\f0\c6\fbo\cc?\d2+\96\c5r\ec\f1\bc\00\00\00\00\00`\e9?\00\00\00\00\00\00\00\00\00\90\d4\b0=\b1\cd?5\b0\15\f7*\ff*\bd\00\00\00\00\00@\e9?\00\00\00\00\00\00\00\00\00\10\e7\ff\0eS\ce?0\f4A`'\12\c2<\00\00\00\00\00 \e9?\00\00\00\00\00\00\00\00\00\00\dd\e4\ad\f5\ce?\11\8e\bbe\15!\ca\bc\00\00\00\00\00\00\e9?\00\00\00\00\00\00\00\00\00\b0\b3l\1c\99\cf?0\df\0c\ca\ec\cb\1b=\00\00\00\00\00\c0\e8?\00\00\00\00\00\00\00\00\00XM`8q\d0?\91N\ed\16\db\9c\f8<\00\00\00\00\00\a0\e8?\00\00\00\00\00\00\00\00\00`ag-\c4\d0?\e9\ea<\16\8b\18'=\00\00\00\00\00\80\e8?\00\00\00\00\00\00\00\00\00\e8'\82\8e\17\d1?\1c\f0\a5c\0e!,\bd\00\00\00\00\00`\e8?\00\00\00\00\00\00\00\00\00\f8\ac\cb\5ck\d1?\81\16\a5\f7\cd\9a+=\00\00\00\00\00@\e8?\00\00\00\00\00\00\00\00\00hZc\99\bf\d1?\b7\bdGQ\ed\a6,=\00\00\00\00\00 \e8?\00\00\00\00\00\00\00\00\00\b8\0emE\14\d2?\ea\baF\ba\de\87\0a=\00\00\00\00\00\e0\e7?\00\00\00\00\00\00\00\00\00\90\dc|\f0\be\d2?\f4\04PJ\fa\9c*=\00\00\00\00\00\c0\e7?\00\00\00\00\00\00\00\00\00`\d3\e1\f1\14\d3?\b8<!\d3z\e2(\bd\00\00\00\00\00\a0\e7?\00\00\00\00\00\00\00\00\00\10\bevgk\d3?\c8w\f1\b0\cdn\11=\00\00\00\00\00\80\e7?\00\00\00\00\00\00\00\00\0003wR\c2\d3?\5c\bd\06\b6T;\18=\00\00\00\00\00`\e7?\00\00\00\00\00\00\00\00\00\e8\d5#\b4\19\d4?\9d\e0\90\ec6\e4\08=\00\00\00\00\00@\e7?\00\00\00\00\00\00\00\00\00\c8q\c2\8dq\d4?u\d6g\09\ce'/\bd\00\00\00\00\00 \e7?\00\00\00\00\00\00\00\00\000\17\9e\e0\c9\d4?\a4\d8\0a\1b\89 .\bd\00\00\00\00\00\00\e7?\00\00\00\00\00\00\00\00\00\a08\07\ae\22\d5?Y\c7d\81p\be.=\00\00\00\00\00\e0\e6?\00\00\00\00\00\00\00\00\00\d0\c8S\f7{\d5?\ef@]\ee\ed\ad\1f=\00\00\00\00\00\c0\e6?\00\00\00\00\00\00\00\00\00`Y\df\bd\d5\d5?\dce\a4\08*\0b\0a\bdO\bba\05g\ac\dd?\18-DT\fb!\e9?\9b\f6\81\d2\0bs\ef?\18-DT\fb!\f9?\e2e/\22\7f+z<\07\5c\143&\a6\81<\bd\cb\f0z\88\07p<\07\5c\143&\a6\91<\18-DT\fb!\e9?\18-DT\fb!\e9\bf\d2!3\7f|\d9\02@\d2!3\7f|\d9\02\c0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\80\18-DT\fb!\09@\18-DT\fb!\09\c0\fe\82+eG\15g@\00\00\00\00\00\008C\00\00\fa\feB.v\bf:;\9e\bc\9a\f7\0c\bd\bd\fd\ff\ff\ff\ff\df?<TUUUU\c5?\91+\17\cfUU\a5?\17\d0\a4g\11\11\81?\00\00\00\00\00\00\c8B\ef9\fa\feB.\e6?$\c4\82\ff\bd\bf\ce?\b5\f4\0c\d7\08k\ac?\ccPF\d2\ab\b2\83?\84:N\9b\e0\d7U?\00\00\00\00\00\00\00\00\00\00\00\00\00\00\f0?n\bf\88\1aO;\9b<53\fb\a9=\f6\ef?]\dc\d8\9c\13`q\bca\80w>\9a\ec\ef?\d1f\87\10z^\90\bc\85\7fn\e8\15\e3\ef?\13\f6g5R\d2\8c<t\85\15\d3\b0\d9\ef?\fa\8e\f9#\80\ce\8b\bc\de\f6\dd)k\d0\ef?a\c8\e6aN\f7`<\c8\9bu\18E\c7\ef?\99\d33[\e4\a3\90<\83\f3\c6\ca>\be\ef?m{\83]\a6\9a\97<\0f\89\f9lX\b5\ef?\fc\ef\fd\92\1a\b5\8e<\f7Gr+\92\ac\ef?\d1\9c/p=\be><\a2\d1\d32\ec\a3\ef?\0bn\90\894\03j\bc\1b\d3\fe\aff\9b\ef?\0e\bd/*RV\95\bcQ[\12\d0\01\93\ef?U\eaN\8c\ef\80P\bc\cc1l\c0\bd\8a\ef?\16\f4\d5\b9#\c9\91\bc\e0-\a9\ae\9a\82\ef?\afU\5c\e9\e3\d3\80<Q\8e\a5\c8\98z\ef?H\93\a5\ea\15\1b\80\bc{Q}<\b8r\ef?=2\deU\f0\1f\8f\bc\ea\8d\8c8\f9j\ef?\bfS\13?\8c\89\8b<u\cbo\eb[c\ef?&\eb\11v\9c\d9\96\bc\d4\5c\04\84\e0[\ef?`/:>\f7\ec\9a<\aa\b9h1\87T\ef?\9d8\86\cb\82\e7\8f\bc\1d\d9\fc\22PM\ef?\8d\c3\a6DAo\8a<\d6\8cb\88;F\ef?}\04\e4\b0\05z\80<\96\dc}\91I?\ef?\94\a8\a8\e3\fd\8e\96<8bunz8\ef?}Ht\f2\18^\87<?\a6\b2O\ce1\ef?\f2\e7\1f\98+G\80<\dd|\e2eE+\ef?^\08q?{\b8\96\bc\81c\f5\e1\df$\ef?1\ab\09m\e1\f7\82<\e1\de\1f\f5\9d\1e\ef?\fa\bfo\1a\9b!=\bc\90\d9\da\d0\7f\18\ef?\b4\0a\0cr\827\8b<\0b\03\e4\a6\85\12\ef?\8f\cb\ce\89\92\14n<V/>\a9\af\0c\ef?\b6\ab\b0MuM\83<\15\b71\0a\fe\06\ef?Lt\ac\e2\01B\86<1\d8L\fcp\01\ef?J\f8\d3]9\dd\8f<\ff\16d\b2\08\fc\ee?\04[\8e;\80\a3\86\bc\f1\9f\92_\c5\f6\ee?hPK\cc\edJ\92\bc\cb\a9:7\a7\f1\ee?\8e-Q\1b\f8\07\99\bcf\d8\05m\ae\ec\ee?\d26\94>\e8\d1q\bc\f7\9f\e54\db\e7\ee?\15\1b\ce\b3\19\19\99\bc\e5\a8\13\c3-\e3\ee?mL*\a7H\9f\85<\224\12L\a6\de\ee?\8ai(z`\12\93\bc\1c\80\ac\04E\da\ee?[\89\17H\8f\a7X\bc*.\f7!\0a\d6\ee?\1b\9aIg\9b,|\bc\97\a8P\d9\f5\d1\ee?\11\ac\c2`\edcC<-\89a`\08\ce\ee?\efd\06;\09f\96<W\00\1d\edA\ca\ee?y\03\a1\da\e1\ccn<\d0<\c1\b5\a2\c6\ee?0\12\0f?\8e\ff\93<\de\d3\d7\f0*\c3\ee?\b0\afz\bb\ce\90v<'*6\d5\da\bf\ee?w\e0T\eb\bd\1d\93<\0d\dd\fd\99\b2\bc\ee?\8e\a3q\004\94\8f\bc\a7,\9dv\b2\b9\ee?I\a3\93\dc\cc\de\87\bcBf\cf\a2\da\b6\ee?_8\0f\bd\c6\dex\bc\82O\9dV+\b4\ee?\f6\5c{\ecF\12\86\bc\0f\92]\ca\a4\b1\ee?\8e\d7\fd\18\055\93<\da'\b56G\af\ee?\05\9b\8a/\b7\98{<\fd\c7\97\d4\12\ad\ee?\09T\1c\e2\e1c\90<)TH\dd\07\ab\ee?\ea\c6\19P\85\c74<\b7FY\8a&\a9\ee?5\c0d+\e62\94<H!\ad\15o\a7\ee?\9fv\99aJ\e4\8c\bc\09\dcv\b9\e1\a5\ee?\a8M\ef;\c53\8c\bc\85U:\b0~\a4\ee?\ae\e9+\89xS\84\bc \c3\cc4F\a3\ee?XXVx\dd\ce\93\bc%\22U\828\a2\ee?d\19~\80\aa\10W<s\a9L\d4U\a1\ee?(\22^\bf\ef\b3\93\bc\cd;\7ff\9e\a0\ee?\82\b94\87\ad\12j\bc\bf\da\0bu\12\a0\ee?\ee\a9m\b8\efgc\bc/\1ae<\b2\9f\ee?Q\88\e0T=\dc\80\bc\84\94Q\f9}\9f\ee?\cf>Z~d\1fx\bct_\ec\e8u\9f\ee?\b0}\8b\c0J\ee\86\bct\81\a5H\9a\9f\ee?\8a\e6U\1e2\19\86\bc\c9gBV\eb\9f\ee?\d3\d4\09^\cb\9c\90<?]\deOi\a0\ee?\1d\a5M\b9\dc2{\bc\87\01\ebs\14\a1\ee?k\c0gT\fd\ec\94<2\c10\01\ed\a1\ee?Ul\d6\ab\e1\ebe<bN\cf6\f3\a2\ee?B\cf\b3/\c5\a1\88\bc\12\1a>T'\a4\ee?47;\f1\b6i\93\bc\13\ceL\99\89\a5\ee?\1e\ff\19:\84^\80\bc\ad\c7#F\1a\a7\ee?nWr\d8P\d4\94\bc\ed\92D\9b\d9\a8\ee?\00\8a\0e[g\ad\90<\99f\8a\d9\c7\aa\ee?\b4\ea\f0\c1/\b7\8d<\db\a0*B\e5\ac\ee?\ff\e7\c5\9c`\b6e\bc\8cD\b5\162\af\ee?D_\f3Y\83\f6{<6w\15\99\ae\b1\ee?\83=\1e\a7\1f\09\93\bc\c6\ff\91\0b[\b4\ee?)\1el\8b\b8\a9]\bc\e5\c5\cd\b07\b7\ee?Y\b9\90|\f9#l\bc\0fR\c8\cbD\ba\ee?\aa\f9\f4\22CC\92\bcPN\de\9f\82\bd\ee?K\8ef\d7l\ca\85\bc\ba\07\cap\f1\c0\ee?'\ce\91+\fc\afq<\90\f0\a3\82\91\c4\ee?\bbs\0a\e15\d2m<##\e3\19c\c8\ee?c\22b\22\04\c5\87\bce\e5]{f\cc\ee?\d51\e2\e3\86\1c\8b<3-J\ec\9b\d0\ee?\15\bb\bc\d3\d1\bb\91\bc]%>\b2\03\d5\ee?\d21\ee\9c1\cc\90<X\b30\13\9e\d9\ee?\b3Zsn\84i\84<\bf\fdyUk\de\ee?\b4\9d\8e\97\cd\df\82\bcz\f3\d3\bfk\e3\ee?\873\cb\92w\1a\8c<\ad\d3Z\99\9f\e8\ee?\fa\d9\d1J\8f{\90\bcf\b6\8d)\07\ee\ee?\ba\ae\dcV\d9\c3U\bc\fb\15O\b8\a2\f3\ee?@\f6\a6=\0e\a4\90\bc:Y\e5\8dr\f9\ee?4\93\ad8\f4\d6h\bcG^\fb\f2v\ff\ee?5\8aXk\e2\ee\91\bcJ\06\a10\b0\05\ef?\cd\dd_\0a\d7\fft<\d2\c1K\90\1e\0c\ef?\ac\98\92\fa\fb\bd\91\bc\09\1e\d7[\c2\12\ef?\b3\0c\af0\aens<\9cR\85\dd\9b\19\ef?\94\fd\9f\5c2\e3\8e<z\d0\ff_\ab \ef?\acY\09\d1\8f\e0\84<K\d1W.\f1'\ef?g\1aN8\af\cdc<\b5\e7\06\94m/\ef?h\19\92l,kg<i\90\ef\dc 7\ef?\d2\b5\cc\83\18\8a\80\bc\fa\c3]U\0b?\ef?o\fa\ff?]\ad\8f\bc|\89\07J-G\ef?I\a9u8\ae\0d\90\bc\f2\89\0d\08\87O\ef?\a7\07=\a6\85\a3t<\87\a4\fb\dc\18X\ef?\0f\22@ \9e\91\82\bc\98\83\c9\16\e3`\ef?\ac\92\c1\d5PZ\8e<\852\db\03\e6i\ef?Kk\01\acY:\84<`\b4\01\f3!s\ef?\1f>\b4\07!\d5\82\bc_\9b{3\97|\ef?\c9\0dG;\b9*\89\bc)\a1\f5\14F\86\ef?\d3\88:`\04\b6t<\f6?\8b\e7.\90\ef?qr\9dQ\ec\c5\83<\83L\c7\fbQ\9a\ef?\f0\91\d3\8f\12\f7\8f\bc\da\90\a4\a2\af\a4\ef?}t#\e2\98\ae\8d\bc\f1g\8e-H\af\ef?\08 \aaA\bc\c3\8e<'Za\ee\1b\ba\ef?2\eb\a9\c3\94+\84<\97\bak7+\c5\ef?\ee\85\d11\a9d\8a<@En[v\d0\ef?\ed\e3;\e4\ba7\8e\bc\14\be\9c\ad\fd\db\ef?\9d\cd\91M;\89w<\d8\90\9e\81\c1\e7\ef?\89\cc`A\c1\05S<\f1q\8f+\c2\f3\ef?\008\fa\feB.\e6?0g\c7\93W\f3.=\01\00\00\00\00\00\e0\bf[0QUUU\d5?\90E\eb\ff\ff\ff\cf\bf\11\01\f1$\b3\99\c9?\9f\c8\06\e5uU\c5\bf\00\00\00\00\00\00\e0\bfwUUUUU\d5?\cb\fd\ff\ff\ff\ff\cf\bf\0c\dd\95\99\99\99\c9?\a7EgUUU\c5\bf0\deD\a3$I\c2?e=B\a4\ff\ff\bf\bf\ca\d6*(\84q\bc?\ffh\b0C\eb\99\b9\bf\85\d0\af\f7\82\81\b7?\cdE\d1u\13R\b5\bf\9f\de\e0\c3\f04\f7?\00\90\e6y\7f\cc\d7\bf\1f\e9,jx\13\f7?\00\00\0d\c2\eeo\d7\bf\a0\b5\fa\08`\f2\f6?\00\e0Q\13\e3\13\d7\bf}\8c\13\1f\a6\d1\f6?\00x(8[\b8\d6\bf\d1\b4\c5\0bI\b1\f6?\00x\80\90U]\d6\bf\ba\0c/3G\91\f6?\00\00\18v\d0\02\d6\bf#B\22\18\9fq\f6?\00\90\90\86\ca\a8\d5\bf\d9\1e\a5\99OR\f6?\00P\03VCO\d5\bf\c4$\8f\aaV3\f6?\00@k\c37\f6\d4\bf\14\dc\9dk\b3\14\f6?\00P\a8\fd\a7\9d\d4\bfL\5c\c6Rd\f6\f5?\00\a8\899\92E\d4\bfO,\91\b5g\d8\f5?\00\b8\b09\f4\ed\d3\bf\de\90[\cb\bc\ba\f5?\00p\8fD\ce\96\d3\bfx\1a\d9\f2a\9d\f5?\00\a0\bd\17\1e@\d3\bf\87VF\12V\80\f5?\00\80F\ef\e2\e9\d2\bf\d3k\e7\ce\97c\f5?\00\e008\1b\94\d2\bf\93\7f\a7\e2%G\f5?\00\88\da\8c\c5>\d2\bf\83E\06B\ff*\f5?\00\90')\e1\e9\d1\bf\df\bd\b2\db\22\0f\f5?\00\f8H+m\95\d1\bf\d7\de4G\8f\f3\f4?\00\f8\b9\9agA\d1\bf@(\de\cfC\d8\f4?\00\98\ef\94\d0\ed\d0\bf\c8\a3x\c0>\bd\f4?\00\10\db\18\a5\9a\d0\bf\8a%\e0\c3\7f\a2\f4?\00\b8cR\e6G\d0\bf4\84\d4$\05\88\f4?\00\f0\86E\22\eb\cf\bf\0b-\19\1b\cem\f4?\00\b0\17uJG\cf\bfT\189\d3\d9S\f4?\000\10=D\a4\ce\bfZ\84\b4D':\f4?\00\b0\e9D\0d\02\ce\bf\fb\f8\15A\b5 \f4?\00\f0w)\a2`\cd\bf\b1\f4>\da\82\07\f4?\00\90\95\04\01\c0\cc\bf\8f\feW]\8f\ee\f3?\00\10\89V) \cc\bf\e9L\0b\a0\d9\d5\f3?\00\10\81\8d\17\81\cb\bf+\c1\10\c0`\bd\f3?\00\d0\d3\cc\c9\e2\ca\bf\b8\dau+$\a5\f3?\00\90\12.@E\ca\bf\02\d0\9f\cd\22\8d\f3?\00\f0\1dhw\a8\c9\bf\1cz\84\c5[u\f3?\000Him\0c\c9\bf\e26\adI\ce]\f3?\00\c0E\a6 q\c8\bf@\d4M\98yF\f3?\000\14\b4\8f\d6\c7\bf$\cb\ff\ce\5c/\f3?\00pb<\b8<\c7\bfI\0d\a1uw\18\f3?\00`7\9b\9a\a3\c6\bf\909>7\c8\01\f3?\00\a0\b7T1\0b\c6\bfA\f8\95\bbN\eb\f2?\000$v}s\c5\bf\d1\a9\19\02\0a\d5\f2?\000\c2\8f{\dc\c4\bf*\fd\b7\a8\f9\be\f2?\00\00\d2Q,F\c4\bf\ab\1b\0cz\1c\a9\f2?\00\00\83\bc\8a\b0\c3\bf0\b5\14`r\93\f2?\00\00Ik\99\1b\c3\bf\f5\a1WW\fa}\f2?\00@\a4\90T\87\c2\bf\bf;\1d\9b\b3h\f2?\00\a0y\f8\b9\f3\c1\bf\bd\f5\8f\83\9dS\f2?\00\a0,%\c8`\c1\bf;\08\c9\aa\b7>\f2?\00 \f7W\7f\ce\c0\bf\b6@\a9+\01*\f2?\00\a0\feI\dc<\c0\bf2A\cc\96y\15\f2?\00\80K\bc\bdW\bf\bf\9b\fc\d2\1d \01\f2?\00@@\96\087\be\bf\0bHMI\f4\ec\f1?\00@\f9>\98\17\bd\bfie\8fR\f5\d8\f1?\00\a0\d8Ng\f9\bb\bf|~W\11#\c5\f1?\00`/ y\dc\ba\bf\e9&\cbt|\b1\f1?\00\80(\e7\c3\c0\b9\bf\b6\1a,\0c\01\9e\f1?\00\c0r\b3F\a6\b8\bf\bdp\b6{\b0\8a\f1?\00\00\ac\b3\01\8d\b7\bf\b6\bc\ef%\8aw\f1?\00\008E\f1t\b6\bf\da1L5\8dd\f1?\00\80\87m\0e^\b5\bf\dd_'\90\b9Q\f1?\00\e0\a1\de\5cH\b4\bfL\d22\a4\0e?\f1?\00\a0jM\d93\b3\bf\da\f9\10r\8b,\f1?\00`\c5\f8y \b2\bf1\b5\ec(0\1a\f1?\00 b\98F\0e\b1\bf\af4\84\da\fb\07\f1?\00\00\d2jl\fa\af\bf\b3kN\0f\ee\f5\f0?\00@wJ\8d\da\ad\bf\ce\9f*]\06\e4\f0?\00\00\85\e4\ec\bc\ab\bf!\a5,cD\d2\f0?\00\c0\12@\89\a1\a9\bf\1a\98\e2|\a7\c0\f0?\00\c0\023X\88\a7\bf\d16\c6\83/\af\f0?\00\80\d6g^q\a5\bf9\13\a0\98\db\9d\f0?\00\80eI\8a\5c\a3\bf\df\e7R\af\ab\8c\f0?\00@\15d\e3I\a1\bf\fb(N/\9f{\f0?\00\80\eb\82\c0r\9e\bf\19\8f5\8c\b5j\f0?\00\80RR\f1U\9a\bf,\f9\ec\a5\eeY\f0?\00\80\81\cfb=\96\bf\90,\d1\cdII\f0?\00\00\aa\8c\fb(\92\bf\a9\ad\f0\c6\c68\f0?\00\00\f9 {1\8c\bf\a92y\13e(\f0?\00\00\aa]5\19\84\bfHs\ea'$\18\f0?\00\00\ec\c2\03\12x\bf\95\b1\14\06\04\08\f0?\00\00$y\09\04`\bf\1a\fa&\f7\1f\e0\ef?\00\00\90\84\f3\efo?t\eaa\c2\1c\a1\ef?\00\00=5A\dc\87?.\99\81\b0\10c\ef?\00\80\c2\c4\a3\ce\93?\cd\ad\ee<\f6%\ef?\00\00\89\14\c1\9f\9b?\e7\13\91\03\c8\e9\ee?\00\00\11\ce\d8\b0\a1?\ab\b1\cbx\80\ae\ee?\00\c0\01\d0[\8a\a5?\9b\0c\9d\a2\1at\ee?\00\80\d8@\83\5c\a9?\b5\99\0a\83\91:\ee?\00\80W\efj'\ad?V\9a`\09\e0\01\ee?\00\c0\98\e5\98u\b0?\98\bbw\e5\01\ca\ed?\00 \0d\e3\f5S\b2?\03\91|\0b\f2\92\ed?\00\008\8b\dd.\b4?\ce\5c\fbf\ac\5c\ed?\00\c0W\87Y\06\b6?\9d\de^\aa,'\ed?\00\00j5v\da\b7?\cd,k>n\f2\ec?\00`\1cNC\ab\b9?\02y\a7\a2m\be\ec?\00`\0d\bb\c7x\bb?m\087m&\8b\ec?\00 \e72\13C\bd?\04X]\bd\94X\ec?\00`\deq1\0a\bf?\8c\9f\bb3\b5&\ec?\00@\91+\15g\c0??\e7\ec\ee\83\f5\eb?\00\b0\92\82\85G\c1?\c1\96\dbu\fd\c4\eb?\000\ca\cdn&\c2?(J\86\0c\1e\95\eb?\00P\c5\a6\d7\03\c3?,>\ef\c5\e2e\eb?\00\103<\c3\df\c3?\8b\88\c9gH7\eb?\00\80zk6\ba\c4?J0\1d!K\09\eb?\00\f0\d1(9\93\c5?~\ef\f2\85\e8\db\ea?\00\f0\18$\cdj\c6?\a2=`1\1d\af\ea?\00\90f\ec\f8@\c7?\a7X\d3?\e6\82\ea?\00\f0\1a\f5\c0\15\c8?\8bs\09\ef@W\ea?\00\80\f6T)\e9\c8?'K\ab\90*,\ea?\00@\f8\026\bb\c9?\d1\f2\93\13\a0\01\ea?\00\00,\1c\ed\8b\ca?\1b<\db$\9f\d7\e9?\00\d0\01\5cQ[\cb?\90\b1\c7\05%\ae\e9?\00\c0\bc\ccg)\cc?/\ce\97\f2.\85\e9?\00`H\d55\f6\cc?uK\a4\ee\ba\5c\e9?\00\c0F4\bd\c1\cd?8H\e7\9d\c64\e9?\00\e0\cf\b8\01\8c\ce?\e6Rg/O\0d\e9?\00\90\17\c0\09U\cf?\9d\d7\ff\8eR\e6\e8?\00\b8\1f\12l\0e\d0?|\00\cc\9f\ce\bf\e8?\00\d0\93\0e\b8q\d0?\0e\c3\be\da\c0\99\e8?\00p\86\9ek\d4\d0?\fb\17#\aa't\e8?\00\d0K3\876\d1?\08\9a\b3\ac\00O\e8?\00H#g\0d\98\d1?U>e\e8I*\e8?\00\80\cc\e0\ff\f8\d1?`\02\f4\95\01\06\e8?\00hc\d7_Y\d2?)\a3\e0c%\e2\e7?\00\a8\14\090\b9\d2?\ad\b5\dcw\b3\be\e7?\00`C\10r\18\d3?\c2%\97g\aa\9b\e7?\00\18\ecm&w\d3?W\06\17\f2\07y\e7?\000\af\fbO\d5\d3?\0c\13\d6\db\caV\e7?\00\e0/\e3\ee2\d4?k\b6O\01\00\10\e6?<[B\91l\02~<\95\b4M\03\000\e6?A]\00H\ea\bf\8d<x\d4\94\0d\00P\e6?\b7\a5\d6\86\a7\7f\8e<\adoN\07\00p\e6?L%Tk\ea\fca<\ae\0f\df\fe\ff\8f\e6?\fd\0eYL'~|\bc\bc\c5c\07\00\b0\e6?\01\da\dcHh\c1\8a\bc\f6\c1\5c\1e\00\d0\e6?\11\93I\9d\1c?\83<>\f6\05\eb\ff\ef\e6?S-\e2\1a\04\80~\bc\80\97\86\0e\00\10\e7?Ry\09qf\ff{<\12\e9g\fc\ff/\e7?$\87\bd&\e2\00\8c<j\11\81\df\ffO\e7?\d2\01\f1n\91\02n\bc\90\9cg\0f\00p\e7?t\9cT\cdq\fcg\bc5\c8~\fa\ff\8f\e7?\83\04\f5\9e\c1\be\81<\e6\c2 \fe\ff\af\e7?ed\cc)\17~p\bc\00\c9?\ed\ff\cf\e7?\1c\8b{\08r\80\80\bcv\1a&\e9\ff\ef\e7?\ae\f9\9dm(\c0\8d<\e8\a3\9c\04\00\10\e8?3L\e5Q\d2\7f\89<\8f,\93\17\000\e8?\81\f30\b6\e9\fe\8a\bc\9cs3\06\00P\e8?\bc5ek\bf\bf\89<\c6\89B \00p\e8?u{\11\f3e\bf\8b\bc\04y\f5\eb\ff\8f\e8?W\cb=\a2n\00\89\bc\df\04\bc\22\00\b0\e8?\0aK\e08\df\00}\bc\8a\1b\0c\e5\ff\cf\e8?\05\9f\ffFq\00\88\bcC\8e\91\fc\ff\ef\e8?8pz\d0{\81\83<\c7_\fa\1e\00\10\e9?\03\b4\dfv\91>\89<\b9{F\13\000\e9?v\02\98KN\80\7f<o\07\ee\e6\ffO\e9?.b\ff\d9\f0~\8f\bc\d1\12<\de\ffo\e9?\ba8&\96\aa\82p\bc\0d\8aE\f4\ff\8f\e9?\ef\a8d\91\1b\80\87\bc>.\98\dd\ff\af\e9?7\93Z\8a\e0@\87\bcf\fbI\ed\ff\cf\e9?\00\e0\9b\c1\08\ce?<Q\9c\f1 \00\f0\e9?\0a[\88'\aa?\8a\bc\06\b0E\11\00\10\ea?V\daX\99H\fft<\fa\f6\bb\07\000\ea?\18m+\8a\ab\be\8c<y\1d\97\10\00P\ea?0yx\dd\ca\fe\88<H.\f5\1d\00p\ea?\db\ab\d8=vA\8f\bcR3Y\1c\00\90\ea?\12v\c2\84\02\bf\8e\bcK>O*\00\b0\ea?_?\ff<\04\fdi\bc\d1\1e\ae\d7\ff\cf\ea?\b4p\90\12\e7>\82\bcx\04Q\ee\ff\ef\ea?\a3\de\0e\e0>\06j<[\0de\db\ff\0f\eb?\b9\0a\1f8\c8\06Z<W\ca\aa\fe\ff/\eb?\1d<#t\1e\01y\bc\dc\ba\95\d9\ffO\eb?\9f*\86h\10\ffy\bc\9ce\9e$\00p\eb?>O\86\d0E\ff\8a<@\16\87\f9\ff\8f\eb?\f9\c3\c2\96w\fe|<O\cb\04\d2\ff\af\eb?\c4+\f2\ee'\ffc\bcE\5cA\d2\ff\cf\eb?!\ea;\ee\b7\ffl\bc\df\09c\f8\ff\ef\eb?\5c\0b.\97\03A\81\bcSv\b5\e1\ff\0f\ec?\19j\b7\94d\c1\8b<\e3W\fa\f1\ff/\ec?\ed\c60\8d\ef\fed\bc$\e4\bf\dc\ffO\ec?uG\ec\bch?\84\bc\f7\b9T\ed\ffo\ec?\ec\e0S\f0\a3~\84<\d5\8f\99\eb\ff\8f\ec?\f1\92\f9\8d\06\83s<\9a!%!\00\b0\ec?\04\0e\18d\8e\fdh\bc\9cF\94\dd\ff\cf\ec?r\ea\c7\1c\be~\8e<v\c4\fd\ea\ff\ef\ec?\fe\88\9f\ad9\be\8e<+\f8\9a\16\00\10\ed?qZ\b9\a8\91}u<\1d\f7\0f\0d\000\ed?\da\c7pi\90\c1\89<\c4\0fy\ea\ffO\ed?\0c\feX\c57\0eX\bc\e5\87\dc.\00p\ed?D\0f\c1M\d6\80\7f\bc\aa\82\dc!\00\90\ed?\5c\5c\fd\94\8f|t\bc\83\02k\d8\ff\af\ed?~a!\c5\1d\7f\8c<9Gl)\00\d0\ed?S\b1\ff\b2\9e\01\88<\f5\90D\e5\ff\ef\ed?\89\ccR\c6\d2\00n<\94\f6\ab\cd\ff\0f\ee?\d2i- @\83\7f\bc\dd\c8R\db\ff/\ee?d\08\1b\ca\c1\00{<\ef\16B\f2\ffO\ee?Q\ab\94\b0\a8\ffr<\11^\8a\e8\ffo\ee?Y\be\ef\b1s\f6W\bc\0d\ff\9e\11\00\90\ee?\01\c8\0b^\8d\80\84\bcD\17\a5\df\ff\af\ee?\b5 C\d5\06\00x<\a1\7f\12\1a\00\d0\ee?\92\5cV`\f8\02P\bc\c4\bc\ba\07\00\f0\ee?\11\e65]D@\85\bc\02\8dz\f5\ff\0f\ef?\05\91\ef91\fbO\bc\c7\8a\e5\1e\000\ef?U\11s\f2\ac\81\8a<\944\82\f5\ffO\ef?C\c7\d7\d4A?\8a<kL\a9\fc\ffo\ef?ux\98\1c\f4\02b\bcA\c4\f9\e1\ff\8f\ef?K\e7w\f4\d1}w<~\e3\e0\d2\ff\af\ef?1\a3|\9a\19\01o\bc\9e\e4w\1c\00\d0\ef?\b1\ac\ceK\ee\81q<1\c3\e0\f7\ff\ef\ef?Z\87p\017\05n\bcn`e\f4\ff\0f\f0?\da\0a\1cI\ad~\8a\bcXz\86\f3\ff/\f0?\e0\b2\fc\c3i\7f\97\bc\17\0d\fc\fd\ffO\f0?[\94\cb4\fe\bf\97<\82M\cd\03\00p\f0?\cbV\e4\c0\83\00\82<\e8\cb\f2\f9\ff\8f\f0?\1au7\be\df\ffm\bce\da\0c\01\00\b0\f0?\eb&\e6\ae\7f?\91\bc8\d3\a4\01\00\d0\f0?\f7\9fHy\fa}\80<\fd\fd\da\fa\ff\ef\f0?\c0k\d6p\05\04w\bc\96\fd\ba\0b\00\10\f1?b\0bm\84\d4\80\8e<]\f4\e5\fa\ff/\f1?\ef6\fdd\fa\bf\9d<\d9\9a\d5\0d\00P\f1?\aeP\12pw\00\9a<\9aU!\0f\00p\f1?\ee\de\e3\e2\f9\fd\8d<&T'\fc\ff\8f\f1?sr;\dc0\00\91<Y<=\12\00\b0\f1?\88\01\03\80y\7f\99<\b7\9e)\f8\ff\cf\f1?g\8c\9f\ab2\f9e\bc\00\d4\8a\f4\ff\ef\f1?\eb[\a7\9d\bf\7f\93<\a4\86\8b\0c\00\10\f2?\22[\fd\91k\80\9f<\03C\85\03\000\f2?3\bf\9f\eb\c2\ff\93<\84\f6\bc\ff\ffO\f2?r..~\e7\01v<\d9!)\f5\ffo\f2?a\0c\7fv\bb\fc\7f<<:\93\14\00\90\f2?+A\02<\ca\02r\bc\13cU\14\00\b0\f2?\02\1f\f23\82\80\92\bc;R\fe\eb\ff\cf\f2?\f2\dcO8~\ff\88\bc\96\ad\b8\0b\00\f0\f2?\c5A0PQ\ff\85\bc\af\e2z\fb\ff\0f\f3?\9d(^\88q\00\81\bc\7f_\ac\fe\ff/\f3?\15\b7\b7?]\ff\91\bcVg\a6\0c\00P\f3?\bd\82\8b\22\82\7f\95<!\f7\fb\11\00p\f3?\cc\d5\0d\c4\ba\00\80<\b9/Y\f9\ff\8f\f3?Q\a7\b2-\9d?\94\bcB\d2\dd\04\00\b0\f3?\e18vpk\7f\85<W\c9\b2\f5\ff\cf\f3?1\12\bf\10:\02z<\18\b4\b0\ea\ff\ef\f3?\b0R\b1fm\7f\98<\f4\af2\15\00\10\f4?$\85\19_7\f8g<)\8bG\17\000\f4?CQ\dcr\e6\01\83<c\b4\95\e7\ffO\f4?Z\89\b2\b8i\ff\89<\e0u\04\e8\ffo\f4?T\f2\c2\9b\b1\c0\95\bc\e7\c1o\ef\ff\8f\f4?r*:\f2\09@\9b<\04\a7\be\e5\ff\af\f4?E}\0d\bf\b7\ff\94\bc\de'\10\17\00\d0\f4?=j\dcqd\c0\99\bc\e2>\f0\0f\00\f0\f4?\1cS\85\0b\89\7f\97<\d1K\dc\12\00\10\f5?6\a4fqe\04`<z'\05\16\000\f5?\092#\ce\ce\bf\96\bcLp\db\ec\ffO\f5?\d7\a1\05\05r\02\89\bc\a9T_\ef\ffo\f5?\12d\c9\0e\e6\bf\9b<\12\10\e6\17\00\90\f5?\90\ef\af\81\c5~\88<\92>\c9\03\00\b0\f5?\c0\0c\bf\0a\08A\9f\bc\bc\19I\1d\00\d0\f5?)G%\fb*\81\98\bc\89z\b8\e7\ff\ef\f5?\04i\ed\80\b7~\94\bc-+   0X0x\00(null)\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\19\00\0a\00\19\19\19\00\00\00\00\05\00\00\00\00\00\00\09\00\00\00\00\0b\00\00\00\00\00\00\00\00\19\00\11\0a\19\19\19\03\0a\07\00\01\1b\09\0b\18\00\00\09\06\0b\00\00\0b\00\06\19\00\00\00\19\19\19\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\00\00\00\00\19\00\0a\0d\19\19\19\00\0d\00\00\02\00\09\0e\00\00\00\09\00\0e\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0c\00\00\00\00\00\00\00\00\00\00\00\13\00\00\00\00\13\00\00\00\00\09\0c\00\00\00\00\00\0c\00\00\0c\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\00\00\00\00\00\00\00\00\00\00\00\0f\00\00\00\04\0f\00\00\00\00\09\10\00\00\00\00\00\10\00\00\10\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\12\00\00\00\00\00\00\00\00\00\00\00\11\00\00\00\00\11\00\00\00\00\09\12\00\00\00\00\00\12\00\00\12\00\00\1a\00\00\00\1a\1a\1a\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\1a\00\00\00\1a\1a\1a\00\00\00\00\00\00\09\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\14\00\00\00\00\00\00\00\00\00\00\00\17\00\00\00\00\17\00\00\00\00\09\14\00\00\00\00\00\14\00\00\14\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\16\00\00\00\00\00\00\00\00\00\00\00\15\00\00\00\00\15\00\00\00\00\09\16\00\00\00\00\00\16\00\00\16\00\00Support for formatting long double values is currently disabled.\0aTo enable it, .\0a\00\00\00\00\00\00\00\00\00\00\00\00\00\00\000123456789ABCDEF-0X+0X 0X-0x+0x 0x\00inf\00INF\00nan\00NAN\00.\00\00\00\00\00\00\00\00\00\00\00\00\03\00\00\00\04\00\00\00\04\00\00\00\06\00\00\00\83\f9\a2\00DNn\00\fc)\15\00\d1W'\00\dd4\f5\00b\db\c0\00<\99\95\00A\90C\00cQ\fe\00\bb\de\ab\00\b7a\c5\00:n$\00\d2MB\00I\06\e0\00\09\ea.\00\1c\92\d1\00\eb\1d\fe\00)\b1\1c\00\e8>\a7\00\f55\82\00D\bb.\00\9c\e9\84\00\b4&p\00A~_\00\d6\919\00S\839\00\9c\f49\00\8b_\84\00(\f9\bd\00\f8\1f;\00\de\ff\97\00\0f\98\05\00\11/\ef\00\0aZ\8b\00m\1fm\00\cf~6\00\09\cb'\00FO\b7\00\9ef?\00-\ea_\00\ba'u\00\e5\eb\c7\00={\f1\00\f79\07\00\92R\8a\00\fbk\ea\00\1f\b1_\00\08]\8d\000\03V\00{\fcF\00\f0\abk\00 \bc\cf\006\f4\9a\00\e3\a9\1d\00^a\91\00\08\1b\e6\00\85\99e\00\a0\14_\00\8d@h\00\80\d8\ff\00'sM\00\06\061\00\caV\15\00\c9\a8s\00{\e2`\00k\8c\c0\00\19\c4G\00\cdg\c3\00\09\e8\dc\00Y\83*\00\8bv\c4\00\a6\1c\96\00D\af\dd\00\19W\d1\00\a5>\05\00\05\07\ff\003~?\00\c22\e8\00\98O\de\00\bb}2\00&=\c3\00\1ek\ef\00\9f\f8^\005\1f:\00\7f\f2\ca\00\f1\87\1d\00|\90!\00j$|\00\d5n\fa\000-w\00\15;C\00\b5\14\c6\00\c3\19\9d\00\ad\c4\c2\00,MA\00\0c\00]\00\86}F\00\e3q-\00\9b\c6\9a\003b\00\00\b4\d2|\00\b4\a7\97\007U\d5\00\d7>\f6\00\a3\10\18\00Mv\fc\00d\9d*\00p\d7\ab\00c|\f8\00z\b0W\00\17\15\e7\00\c0IV\00;\d6\d9\00\a7\848\00$#\cb\00\d6\8aw\00ZT#\00\00\1f\b9\00\f1\0a\1b\00\19\ce\df\00\9f1\ff\00f\1ej\00\99Wa\00\ac\fbG\00~\7f\d8\00\22e\b7\002\e8\89\00\e6\bf`\00\ef\c4\cd\00l6\09\00]?\d4\00\16\de\d7\00X;\de\00\de\9b\92\00\d2\22(\00(\86\e8\00\e2XM\00\c6\ca2\00\08\e3\16\00\e0}\cb\00\17\c0P\00\f3\1d\a7\00\18\e0[\00.\134\00\83\12b\00\83H\01\00\f5\8e[\00\ad\b0\7f\00\1e\e9\f2\00HJC\00\10g\d3\00\aa\dd\d8\00\ae_B\00ja\ce\00\0a(\a4\00\d3\99\b4\00\06\a6\f2\00\5cw\7f\00\a3\c2\83\00a<\88\00\8asx\00\af\8cZ\00o\d7\bd\00-\a6c\00\f4\bf\cb\00\8d\81\ef\00&\c1g\00U\caE\00\ca\d96\00(\a8\d2\00\c2a\8d\00\12\c9w\00\04&\14\00\12F\9b\00\c4Y\c4\00\c8\c5D\00M\b2\91\00\00\17\f3\00\d4C\ad\00)I\e5\00\fd\d5\10\00\00\be\fc\00\1e\94\cc\00p\ce\ee\00\13>\f5\00\ec\f1\80\00\b3\e7\c3\00\c7\f8(\00\93\05\94\00\c1q>\00.\09\b3\00\0bE\f3\00\88\12\9c\00\ab {\00.\b5\9f\00G\92\c2\00{2/\00\0cUm\00r\a7\90\00k\e7\1f\001\cb\96\00y\16J\00Ay\e2\00\f4\df\89\00\e8\94\97\00\e2\e6\84\00\991\97\00\88\edk\00__6\00\bb\fd\0e\00H\9a\b4\00g\a4l\00qrB\00\8d]2\00\9f\15\b8\00\bc\e5\09\00\8d1%\00\f7t9\000\05\1c\00\0d\0c\01\00K\08h\00,\eeX\00G\aa\90\00t\e7\02\00\bd\d6$\00\f7}\a6\00nHr\00\9f\16\ef\00\8e\94\a6\00\b4\91\f6\00\d1SQ\00\cf\0a\f2\00 \983\00\f5K~\00\b2ch\00\dd>_\00@]\03\00\85\89\7f\00UR)\007d\c0\00m\d8\10\002H2\00[Lu\00Nq\d4\00ETn\00\0b\09\c1\00*\f5i\00\14f\d5\00'\07\9d\00]\04P\00\b4;\db\00\eav\c5\00\87\f9\17\00Ik}\00\1d'\ba\00\96i)\00\c6\cc\ac\00\ad\14T\00\90\e2j\00\88\d9\89\00,rP\00\04\a4\be\00w\07\94\00\f30p\00\00\fc'\00\eaq\a8\00f\c2I\00d\e0=\00\97\dd\83\00\a3?\97\00C\94\fd\00\0d\86\8c\001A\de\00\929\9d\00\ddp\8c\00\17\b7\e7\00\08\df;\00\157+\00\5c\80\a0\00Z\80\93\00\10\11\92\00\0f\e8\d8\00l\80\af\00\db\ffK\008\90\0f\00Y\18v\00b\a5\15\00a\cb\bb\00\c7\89\b9\00\10@\bd\00\d2\f2\04\00Iu'\00\eb\b6\f6\00\db\22\bb\00\0a\14\aa\00\89&/\00d\83v\00\09;3\00\0e\94\1a\00Q:\aa\00\1d\a3\c2\00\af\ed\ae\00\5c&\12\00m\c2M\00-z\9c\00\c0V\97\00\03?\83\00\09\f0\f6\00+@\8c\00m1\99\009\b4\07\00\0c \15\00\d8\c3[\00\f5\92\c4\00\c6\adK\00N\ca\a5\00\a77\cd\00\e6\a96\00\ab\92\94\00\ddBh\00\19c\de\00v\8c\ef\00h\8bR\00\fc\db7\00\ae\a1\ab\00\df\151\00\00\ae\a1\00\0c\fb\da\00dMf\00\ed\05\b7\00)e0\00WV\bf\00G\ff:\00j\f9\b9\00u\be\f3\00(\93\df\00\ab\800\00f\8c\f6\00\04\cb\15\00\fa\22\06\00\d9\e4\1d\00=\b3\a4\00W\1b\8f\006\cd\09\00NB\e9\00\13\be\a4\003#\b5\00\f0\aa\1a\00Oe\a8\00\d2\c1\a5\00\0b?\0f\00[x\cd\00#\f9v\00{\8b\04\00\89\17r\00\c6\a6S\00on\e2\00\ef\eb\00\00\9bJX\00\c4\da\b7\00\aaf\ba\00v\cf\cf\00\d1\02\1d\00\b1\f1-\00\8c\99\c1\00\c3\adw\00\86H\da\00\f7]\a0\00\c6\80\f4\00\ac\f0/\00\dd\ec\9a\00?\5c\bc\00\d0\dem\00\90\c7\1f\00*\db\b6\00\a3%:\00\00\af\9a\00\adS\93\00\b6W\04\00)-\b4\00K\80~\00\da\07\a7\00v\aa\0e\00{Y\a1\00\16\12*\00\dc\b7-\00\fa\e5\fd\00\89\db\fe\00\89\be\fd\00\e4vl\00\06\a9\fc\00>\80p\00\85n\15\00\fd\87\ff\00(>\07\00ag3\00*\18\86\00M\bd\ea\00\b3\e7\af\00\8fmn\00\95g9\001\bf[\00\84\d7H\000\df\16\00\c7-C\00%a5\00\c9p\ce\000\cb\b8\00\bfl\fd\00\a4\00\a2\00\05l\e4\00Z\dd\a0\00!oG\00b\12\d2\00\b9\5c\84\00paI\00kV\e0\00\99R\01\00PU7\00\1e\d5\b7\003\f1\c4\00\13n_\00]0\e4\00\85.\a9\00\1d\b2\c3\00\a126\00\08\b7\a4\00\ea\b1\d4\00\16\f7!\00\8fi\e4\00'\ffw\00\0c\03\80\00\8d@-\00O\cd\a0\00 \a5\99\00\b3\a2\d3\00/]\0a\00\b4\f9B\00\11\da\cb\00}\be\d0\00\9b\db\c1\00\ab\17\bd\00\ca\a2\81\00\08j\5c\00.U\17\00'\00U\00\7f\14\f0\00\e1\07\86\00\14\0bd\00\96A\8d\00\87\be\de\00\da\fd*\00k%\b6\00{\894\00\05\f3\fe\00\b9\bf\9e\00hjO\00J*\a8\00O\c4Z\00-\f8\bc\00\d7Z\98\00\f4\c7\95\00\0dM\8d\00 :\a6\00\a4W_\00\14?\b1\00\808\95\00\cc \01\00q\dd\86\00\c9\de\b6\00\bf`\f5\00Me\11\00\01\07k\00\8c\b0\ac\00\b2\c0\d0\00QUH\00\1e\fb\0e\00\95r\c3\00\a3\06;\00\c0@5\00\06\dc{\00\e0E\cc\00N)\fa\00\d6\ca\c8\00\e8\f3A\00|d\de\00\9bd\d8\00\d9\be1\00\a4\97\c3\00wX\d4\00i\e3\c5\00\f0\da\13\00\ba:<\00F\18F\00Uu_\00\d2\bd\f5\00n\92\c6\00\ac.]\00\0eD\ed\00\1c>B\00a\c4\87\00)\fd\e9\00\e7\d6\f3\00\22|\ca\00o\915\00\08\e0\c5\00\ff\d7\8d\00nj\e2\00\b0\fd\c6\00\93\08\c1\00|]t\00k\ad\b2\00\cdn\9d\00>r{\00\c6\11j\00\f7\cf\a9\00)s\df\00\b5\c9\ba\00\b7\00Q\00\e2\b2\0d\00t\ba$\00\e5}`\00t\d8\8a\00\0d\15,\00\81\18\0c\00~f\94\00\01)\16\00\9fzv\00\fd\fd\be\00VE\ef\00\d9~6\00\ec\d9\13\00\8b\ba\b9\00\c4\97\fc\001\a8'\00\f1n\c3\00\94\c56\00\d8\a8V\00\b4\a8\b5\00\cf\cc\0e\00\12\89-\00oW4\00,V\89\00\99\ce\e3\00\d6 \b9\00k^\aa\00>*\9c\00\11_\cc\00\fd\0bJ\00\e1\f4\fb\00\8e;m\00\e2\86,\00\e9\d4\84\00\fc\b4\a9\00\ef\ee\d1\00.5\c9\00/9a\008!D\00\1b\d9\c8\00\81\fc\0a\00\fbJj\00/\1c\d8\00S\b4\84\00N\99\8c\00T\22\cc\00*U\dc\00\c0\c6\d6\00\0b\19\96\00\1ap\b8\00i\95d\00&Z`\00?R\ee\00\7f\11\0f\00\f4\b5\11\00\fc\cb\f5\004\bc-\004\bc\ee\00\e8]\cc\00\dd^`\00g\8e\9b\00\923\ef\00\c9\17\b8\00aX\9b\00\e1W\bc\00Q\83\c6\00\d8>\10\00\ddqH\00-\1c\dd\00\af\18\a1\00!,F\00Y\f3\d7\00\d9z\98\00\9eT\c0\00O\86\fa\00V\06\fc\00\e5y\ae\00\89\226\008\ad\22\00g\93\dc\00U\e8\aa\00\82&8\00\ca\e7\9b\00Q\0d\a4\00\993\b1\00\a9\d7\0e\00i\05H\00e\b2\f0\00\7f\88\a7\00\88L\97\00\f9\d16\00!\92\b3\00{\82J\00\98\cf!\00@\9f\dc\00\dcGU\00\e1t:\00g\ebB\00\fe\9d\df\00^\d4_\00{g\a4\00\ba\acz\00U\f6\a2\00+\88#\00A\baU\00Yn\08\00!*\86\009G\83\00\89\e3\e6\00\e5\9e\d4\00I\fb@\00\ffV\e9\00\1c\0f\ca\00\c5Y\8a\00\94\fa+\00\d3\c1\c5\00\0f\c5\cf\00\dbZ\ae\00G\c5\86\00\85Cb\00!\86;\00,y\94\00\10a\87\00*L{\00\80,\1a\00C\bf\12\00\88&\90\00x<\89\00\a8\c4\e4\00\e5\db{\00\c4:\c2\00&\f4\ea\00\f7g\8a\00\0d\92\bf\00e\a3+\00=\93\b1\00\bd|\0b\00\a4Q\dc\00'\ddc\00i\e1\dd\00\9a\94\19\00\a8)\95\00h\ce(\00\09\ed\b4\00D\9f \00N\98\ca\00p\82c\00~|#\00\0f\b92\00\a7\f5\8e\00\14V\e7\00!\f1\08\00\b5\9d*\00o~M\00\a5\19Q\00\b5\f9\ab\00\82\df\d6\00\96\dda\00\166\02\00\c4:\9f\00\83\a2\a1\00r\edm\009\8dz\00\82\b8\a9\00k2\5c\00F'[\00\004\ed\00\d2\00w\00\fc\f4U\00\01YM\00\e0q\80\00\00\00\00\00\00\00\00\00\00\00\00@\fb!\f9?\00\00\00\00-Dt>\00\00\00\80\98F\f8<\00\00\00`Q\ccx;\00\00\00\80\83\1b\f09\00\00\00@ %z8\00\00\00\80\22\82\e36\00\00\00\00\1d\f3i5abort\00\00"))
