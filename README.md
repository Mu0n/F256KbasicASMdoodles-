# F256KsimpleASMdoodles
A collection of small assembly experiments for the F256Jr/K from Foenix Retro Systems. Compiled into .PGZ format for easy executing on the target hardware (or in the FoenixIDE emulator).

## Foenix Retro Systems
Website: https://c256foenix.com/

Foenix Retro Systems is a homebrew effort to bring 8/16/32-bit era processors in a new, reimagined retro series of computer designed by Stefany Allaire (https://twitter.com/StefanyAllaire)

## ASM 'simple doodles'
These simple examples in 65c02 compatible assembly are my first steps into discovering the machine and its graphic, sound and input capabilities.

To run these, simply copy them over (probably using an SD card) and load them with `/- 'program name.pgz'`. I'm assuming you have a recent enough version of pexec.bin in your flash firmware. A good place to start would be to fetch at least release 2023.5 from this github repository: https://github.com/FoenixRetro/f256-firmware/ 

To compile these, here's what you should have:
- 64tass from: https://sourceforge.net/projects/tass64/
- Gnu.win32 (optional) from: https://gnuwin32.sourceforge.net/packages/make.htm but I recommend using a package manager (under Windows) by copying this command line unders a cmd window: https://winget.run/pkg/GnuWin32/Make and adding its /bin/ folder to your system environment variables (add an entry to PATH)

either use the optional make command (assuming gnu.win32 is installed) while in the folder of the asm program to make use of the provided Makefile,
or adapt this command to your needs: 
> 64tass -c --output-exec=start --c256-pgz example.asm -L example.lst -o example.pgz

(this assumes your program name is "example.asm" and that you have a label inside named "start" which points to the entry point of your executable code)

## Hello World in text mode

![helloworld](https://github.com/Mu0n/F256KsimpleASMdoodles-/assets/6774826/b141857a-93dd-4965-b735-4e5280c3d218)

Should write a simple text message in the first line of text on screen, over whatever was being displayed right before executing.

### Files that are expected in the same directory:

* `helloworld.pgz`
