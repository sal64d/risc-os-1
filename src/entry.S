.section .text
.global _entry
_entry:
  la sp, stack0
  la a0, 4096

  csrr a1, mhartid
  addi a1, a1, 1
  mul a0,a0,a1
 
  add sp, sp, a0
  call kmain

# .section .init, "ax"
# .global  _entry
# 
# _entry:
# 	.cfi_startproc
# 	.cfi_undefined ra
# 
#   .option push
#   .option norelax
# 
#   la gp, __global_pointer$
# 
#   .option pop
# 
#   la sp, __stack_top
# 
#   add s0, sp, zero
#   jal zero, kmain
#   .cfi_endproc
#   .end

