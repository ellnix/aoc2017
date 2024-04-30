(module
  (import "env" "input" (memory 1))

  (import "env" "debug_func"
    (func $debug(param i32)))

  (func $incr (param i32) (result i32)
    (i32.add (local.get 0) (i32.const 1))
  )

  (func (export "solve") 
  (param $ptr i32) (param $len i32)
  (result i32)
    (local $last i32)
    (local $cur i32)
    (local $total i32)

    (local.set $last 
      (i32.load8_u (i32.sub (local.get $len) (i32.const 1)))
    )

    (loop $sum_loop
      (local.set $cur (i32.load8_u (local.get $ptr)))

      (if (i32.eq (local.get $cur) (local.get $last))
      (then 
        (local.set $total 
          (i32.add 
            (local.get $total) 
            (i32.sub (local.get $cur) (i32.const 48))
          )
        ) 
      ))

      (local.set $last (local.get $cur))
      (local.set $ptr (call $incr (local.get $ptr)))

      (if (i32.ne (local.get $ptr) (local.get $len))
      (then (br $sum_loop)))
    )

    (local.get $total)
  )
)
