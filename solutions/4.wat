(module
  (import "env" "input" (memory 2))

  (import "env" "debug_func"
    (func $debug(param i32)))

  (import "env" "print_memory_8"
    (func $print_memory_8(param i32 i32)))

  (import "env" "print_memory_32"
    (func $print_memory_32(param i32 i32)))

  (global $words i32 (i32.const 40000))
  (global $words_len (mut i32) (i32.const 0))

  (func $push_words (param $n i32)
    (i32.store 
      (i32.add (global.get $words) (i32.mul (global.get $words_len) (i32.const 4)))
      (local.get $n)
    )
    (global.set $words_len (i32.add (global.get $words_len) (i32.const 1)))
  )

  (func $fetch_words (param $n i32) (result i32)
    (i32.load 
      (i32.add (global.get $words) (i32.mul (local.get $n) (i32.const 4)))
    )
  )

  (func $words_identical 
        (param $word_i i32)(param $word_i_len i32)
        (param $word_j i32)(param $word_j_len i32)
        (result i32)
    (local $i i32)
    (local $char_i i32)
    (local $char_j i32)
    (local $different i32)
    

    (if (result i32)(i32.eq (local.get $word_i_len) (local.get $word_j_len))
      (then
        (block $found_difference
          (loop $char_loop
            (local.set $char_i (i32.load8_u (i32.add (local.get $word_i) (local.get $i))))
            (local.set $char_j (i32.load8_u (i32.add (local.get $word_j) (local.get $i))))

            (if (i32.ne (local.get $char_i) (local.get $char_j))
              (then
                (local.set $different (i32.const 1))
                (br $found_difference))
            )

            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (if (i32.lt_u (local.get $i) (local.get $word_i_len))
              (br $char_loop))
          ))
        (i32.sub (i32.const 1) (local.get $different))
      )
      (else
        (i32.const 0)
      )
    )
  )

  (func $no_dups (result i32)
    (local $i i32)
    (local $j i32)
    (local $word_i i32)
    (local $word_i_len i32)
    (local $word_j i32)
    (local $word_j_len i32)
    (local $any_dups i32)

    (block $found_dup
      (loop $word_loop
        (local.set $j (local.get $i))

        (local.set $word_i (call $fetch_words (local.get $i)))
        (local.set $word_i_len (call $fetch_words (i32.add (local.get $i) (i32.const 1))))


        (block $j_words_end
          (loop $dup_loop
            (local.set $j (i32.add (local.get $j) (i32.const 2)))
            (if (i32.gt_u (local.get $j) (i32.sub (global.get $words_len) (i32.const 1)))
              (br $j_words_end))

            (local.set $word_j (call $fetch_words (local.get $j)))
            (local.set $word_j_len (call $fetch_words (i32.add (local.get $j) (i32.const 1))))

            (if (call $words_identical (local.get $word_i) (local.get $word_i_len) (local.get $word_j) (local.get $word_j_len))
              (then
                (local.set $any_dups (i32.const 1))
                (br $j_words_end)
              ))

            (br $dup_loop)
          )
        )

        (local.set $i (i32.add (local.get $i) (i32.const 2)))

        (if (i32.lt_u (local.get $i) (i32.sub (global.get $words_len) (i32.const 1)))
          (br $word_loop))
      )
    )

    (i32.sub (i32.const 1) (local.get $any_dups))
  )

  (func (export "part1")(param $ptr i32)(param $len i32)(result i32)
    (local $i i32)
    (local $current_byte i32)
    (local $word_start i32)
    (local $valid_count i32)

    (local.set $i (local.get $ptr))

    (loop $byte_loop
      (local.set $current_byte (i32.load8_u (local.get $i)))

      ;; Space is 32 in ASCII, Newline is 10
      (if (i32.or (i32.eq (local.get $current_byte) (i32.const 32)) (i32.eq (local.get $current_byte) (i32.const 10)))
        (then
          (call $push_words (local.get $word_start))
          (call $push_words (i32.sub (local.get $i) (local.get $word_start)))
          (local.set $word_start (i32.add (local.get $i) (i32.const 1)))
        ))

      ;; Newline is 10 in ASCII
      (if (i32.eq (local.get $current_byte) (i32.const 10))
        (then 
          (; (call $print_memory_8 (i32.const 0) (i32.const 100)) ;)
          (; (call $print_memory_32 (i32.const 10000) (i32.const 20)) ;)

          (local.set $valid_count (i32.add (local.get $valid_count) (call $no_dups)))
          (global.set $words_len (i32.const 0))
        ))

      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (if (i32.gt_s (local.get $len) (local.get $i))
        (br $byte_loop))
    )

    (local.get $valid_count)
  )

  (func $write_subject (param $i i32) (param $len i32)
    (local $start i32)
    (local $c i32)

    (local.set $start (i32.add (global.get $words) (i32.mul (global.get $words_len) (i32.const 4))))

    (loop $each_char
      (i32.store8
        (i32.add (local.get $start) (local.get $c))
        (i32.load8_u (local.get $i))
      )

      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (local.set $c (i32.add (local.get $c) (i32.const 1)))

      (if (i32.lt_u (local.get $i) (local.get $len))
        (br $each_char))
    )
  )

  (func $eliminate_char (param $char i32) (param $len i32)
    (local $start i32)
    (local $c i32)
    (local $orig_char i32)

    (local.set $start (i32.add (global.get $words) (i32.mul (global.get $words_len) (i32.const 4))))

    (block $eliminated
      (loop $each_char
        (local.set $orig_char (i32.load8_u (i32.add (local.get $start) (local.get $c))))

        (if (i32.eq (local.get $orig_char) (local.get $char))
          (then
            (i32.store8 (i32.add (local.get $start) (local.get $c)) (i32.const 0))
            (br $eliminated)
          ))
        (local.set $c (i32.add (local.get $c) (i32.const 1)))

        (if (i32.lt_u (local.get $c) (local.get $len))
          (br $each_char))
      )
    )
  )

  (func $subject_empty (param $len i32) (result i32)
    (local $start i32)
    (local $c i32)
    (local $char i32)
    (local $non_zero_char i32)

    (local.set $start (i32.add (global.get $words) (i32.mul (global.get $words_len) (i32.const 4))))

    (block $found_non_zero
      (loop $each_char
        (local.set $char (i32.load8_u (i32.add (local.get $start) (local.get $c))))

        (local.set $c (i32.add (local.get $c) (i32.const 1)))

        (if (i32.ne (local.get $char) (i32.const 0))
          (local.set $non_zero_char (i32.const 1))
          (br $found_non_zero)
        )

        (if (i32.lt_u (local.get $c) (local.get $len))
          (br $each_char))
      )
    )

    (i32.sub (i32.const 1) (local.get $non_zero_char))
  )

  (func $words_anagrams 
        (param $word_i i32)(param $word_i_len i32)
        (param $word_j i32)(param $word_j_len i32)
        (result i32)
    (local $i i32)
    (local $char_j i32)
    (local $anagram i32)

    (call $write_subject (local.get $word_i) (local.get $word_i_len))

    (if 
      (i32.eq (local.get $word_i_len) (local.get $word_j_len))
      (then
        (loop $char_loop
          (local.set $char_j (i32.load8_u (i32.add (local.get $word_j) (local.get $i))))

          (call $eliminate_char (local.get $char_j) (local.get $word_j_len))

          (local.set $i (i32.add (local.get $i) (i32.const 1)))
          (if (i32.lt_u (local.get $i) (local.get $word_j_len))
            (br $char_loop))
        )

        (if (call $subject_empty (local.get $word_j_len))
          (then (local.set $anagram (i32.const 1)))
          (else (local.set $anagram (i32.const 0))))
      )
      (else
        (local.set $anagram (i32.const 0))
      )
    )

    (i32.sub (i32.const 1) (local.get $anagram))
  )

  (func $no_anagrams (result i32)
    (local $i i32)
    (local $j i32)
    (local $word_i i32)
    (local $word_i_len i32)
    (local $word_j i32)
    (local $word_j_len i32)
    (local $any_anagrams i32)

    (block $found_dup
      (loop $word_loop
        (local.set $j (local.get $i))

        (local.set $word_i (call $fetch_words (local.get $i)))
        (local.set $word_i_len (call $fetch_words (i32.add (local.get $i) (i32.const 1))))


        (block $j_words_end
          (loop $dup_loop
            (local.set $j (i32.add (local.get $j) (i32.const 2)))
            (if (i32.gt_u (local.get $j) (i32.sub (global.get $words_len) (i32.const 1)))
              (br $j_words_end))

            (local.set $word_j (call $fetch_words (local.get $j)))
            (local.set $word_j_len (call $fetch_words (i32.add (local.get $j) (i32.const 1))))

            (if (call $words_anagrams (local.get $word_i) (local.get $word_i_len) (local.get $word_j) (local.get $word_j_len))
              (then
                (call $debug (local.get $word_i))
                (call $debug (local.get $word_j))
                (local.set $any_anagrams (i32.const 1))
                (br $j_words_end)
              ))

            (br $dup_loop)
          )
        )

        (local.set $i (i32.add (local.get $i) (i32.const 2)))

        (if (i32.lt_u (local.get $i) (i32.sub (global.get $words_len) (i32.const 1)))
          (br $word_loop))
      )
    )

    (i32.sub (i32.const 1) (local.get $any_anagrams))
  )

  (func (export "part2")(param $ptr i32)(param $len i32)(result i32)
    (local $i i32)
    (local $current_byte i32)
    (local $word_start i32)
    (local $valid_count i32)

    (local.set $i (local.get $ptr))

    (loop $byte_loop
      (local.set $current_byte (i32.load8_u (local.get $i)))

      ;; Space is 32 in ASCII, Newline is 10
      (if (i32.or (i32.eq (local.get $current_byte) (i32.const 32)) (i32.eq (local.get $current_byte) (i32.const 10)))
        (then
          (call $push_words (local.get $word_start))
          (call $push_words (i32.sub (local.get $i) (local.get $word_start)))
          (local.set $word_start (i32.add (local.get $i) (i32.const 1)))
        ))

      ;; Newline is 10 in ASCII
      (if (i32.eq (local.get $current_byte) (i32.const 10))
        (then 
          (call $print_memory_8 (i32.const 0) (i32.const 100))
          (call $print_memory_32 (i32.const 10000) (i32.const 20))

          (local.set $valid_count (i32.add (local.get $valid_count) (call $no_anagrams)))
          (global.set $words_len (i32.const 0))
        ))

      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (if (i32.gt_s (local.get $len) (local.get $i))
        (br $byte_loop))
    )

    (local.get $valid_count)
  )

)
