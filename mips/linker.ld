ENTRY(__start)
SECTIONS
{
  .text :
  {
    . = ALIGN(8);
    KEEP(*(.multiboot))
    *(.text)
  }
}

