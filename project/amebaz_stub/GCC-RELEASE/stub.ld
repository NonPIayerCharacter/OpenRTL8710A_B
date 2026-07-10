

ENTRY(Reset_Handler)

INCLUDE "export-rom_symbol_v01.txt"

MEMORY
{
	BOOTLOADER_RAM (rwx)  : 	ORIGIN = 0x10002000, LENGTH = 0x6000/*0x3C000*/
}



SECTIONS
{
	/* image1 entry, this section should in RAM and fixed address for ROM */
	.ram_image1.entry :
	{
		__ram_image1_text_start__ = .;
		__ram_start_table_start__ = .;
		KEEP(*(SORT(.image1.entry.data*)))
		__ram_start_table_end__ = .;

		__image1_validate_code__ = .;
		KEEP(*(.image1.validate.rodata*))
		KEEP(*(.image1.export.symb*))
	} > BOOTLOADER_RAM

	.text . :
	{
		*(.text*)
		*(.rodata*)
	} > BOOTLOADER_RAM

	.data . :
	{
		__ram_image1_data_start__ = .;
		KEEP(*(.data*))
		__ram_image1_data_end__ = .;
	
		__ram_image1_text_end__ = .;
	} > BOOTLOADER_RAM

	.bss . :
	{
		__image1_bss_start__ = .;
		KEEP(*(.bss*))
		__image1_bss_end__ = .;
	} > BOOTLOADER_RAM
}

SECTIONS 
{ 
	/* Bootloader symbol list */  
  boot_export_symbol = 0x10002020;  
} 
