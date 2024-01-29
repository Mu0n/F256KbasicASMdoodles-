always: helloworld.pgz

# Case-sensitive, all warnings, fail on error, detailed listings. uses the 'start' label as the start location for running code
# Does not include the KUP header to minimize confusion for pexec.bin, which is the intented way to run the compiled .pgz
# using the following on a F256Jr/K:
# /- example.pgz

OPTS = --output-exec=start --c256-pgz -C -Wall --verbose-list 

helloworld.pgz: helloworld.asm 
	64tass $(OPTS)  $^ -L $(basename $@).lst -o $@