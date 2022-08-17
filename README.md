# Atmega328P_LightMeter
An assembly program for an analog light meter by using LDR sensor and step motor which runs on any Atmega328p. It gets the analog signal from the ldr and converts the signal into a digital one with builtin adc. Then we use higher 8 bit of the 10 bit output from the adc for easier comparison. Then we simply check wether it is increased or decreased, then we simply run the step motor according to the comparison result. We also record the location of step motor inside a 180 degree area of movement into the eeprom but with a delay. That delay may cause a small shift on the area of movement. If a shutdown occurs, in the next start we almost know where we were.

This program could be made with a better algorithm, but that piece of code works just fine.

As assembler, linker and flashing program, you need to use "avr-as" , "avr-objcopy" and "avrdude" on a linux distro.

For example:
avr-as -mmcu=atmega328p -c example.S -o example.o && 
avr-gcc -mmcu=atmega328p example.o -o example &&
avr-objcopy -O ihex -R .eeprom example example.hex &&
avrdude -v -p atmega328p -c arduino -P /dev/ttyUSB0 -b 115200 -D -U flash:w:example.hex:i
