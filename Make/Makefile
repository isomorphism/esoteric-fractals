# define some simple numbers to start from...
zero := 
one := x
two := x x
three := x x x
four := x x x x
five := x x x x x
six := x x x x x x
seven := x x x x x x x
eight := x x x x x x x x

# simple arithmetic. some of these are actually surprisingly easy! stripping 
# is important because sometimes things get confused if there is excess 
# whitespace. thanks, make! you're a pal.
INC = $(strip $(one) $(1) )
DEC = $(strip $(wordlist 2,$(words $(1)),$(1)) )
ADD = $(strip $(1) $(2) )
SUB = $(strip $(wordlist $(words $(call INC,$(2))),$(words $(1)),$(1)) )
MUL = $(strip $(foreach unit,$(1),$(2)) )
DIV = $(strip $(call SUB,$(subst $(2),$(one),$(1)),$(call MOD,$(1),$(2)) ) )
MOD = $(strip $(subst $(2),,$(1)) )

# make some more bigger numbers.
sixteen := $(call MUL,$(four),$(four))
thirtytwo := $(call MUL,$(eight),$(four))
sixtyfour := $(call MUL,$(sixteen),$(four))
onetwoeight := $(call MUL,$(sixteen),$(eight))
twofivesix := $(call MUL,$(sixteen),$(sixteen))
fiveonetwo := $(call MUL,$(twofivesix),$(two))
shittons := $(call MUL,$(twofivesix),$(twofivesix))

# now we have pseudo-real numbers, by using integers that are the "real" 
# number times $(realfactor). changing the factor trades off precision for 
# speed. not that we have much of either, really.
realfactor = $(onetwoeight)
makereal = $(strip $(call ADD,$(call MUL,$(1),$(realfactor)),$(2)) )
rINC = $(strip $(call ADD,$(1),$(realfactor)) )
rDEC = $(strip $(call SUB,$(1),$(realfactor)) )
rADD = $(strip $(call ADD,$(1),$(2)) )
rSUB = $(strip $(call SUB,$(1),$(2)) )
rMUL = $(strip $(call DIV,$(call MUL,$(1),$(2)),$(realfactor)) )
rDIV = $(strip $(call DIV,$(call MUL,$(1),$(realfactor)),$(2)) )
rSQU = $(strip $(call rMUL,$(1),$(1)))
printreal = $(words $(call DIV,$(1),$(realfactor)))+$(words $(call MOD,$(1),$(realfactor)))/$(words $(realfactor))

# signed numbers are represented by two different words for positive and 
# negative values. this lets us use filtering and text substitution to work 
# with them, while preserving all the unsigned operations above.
makesigned = $(strip $(subst $(one),$(2),$(1)))
makeunsigned = $(strip $(subst $(positive),$(one),$(subst $(negative),$(one),$(1))))
positive := p
negative := n
makepossignedreal = $(strip $(call makesigned,$(call makereal,$(1),$(zero)),$(positive)))

# ADD adds together all the positive values, then subtracts all the negative 
# values. this only works if the result is positive... so we first check to 
# see if adding the numbers gives zero, if not we negate both numbers, add 
# them together, and negate the answer. if this is still zero that's the actual 
# answer. 
rsNEG = $(strip $(subst $(one),$(negative),$(subst $(negative),$(positive),$(subst $(positive),$(one),$(1)))))
rsADD = $(strip $(if $(call rsADD2,$(1),$(2)),$(call rsADD2,$(1),$(2)),$(call rsNEG,$(call rsADD2,$(call rsNEG,$(1)),$(call rsNEG,$(2))))) )
rsADD2 = $(strip $(call SUB,$(call rADD,$(filter $(positive),$(1)),$(filter $(positive),$(2))),$(call rsNEG,$(call rADD,$(filter $(negative),$(1)),$(filter $(negative),$(2))))) )
rsSUB = $(strip $(call rsADD,$(1),$(call rsNEG,$(2))))
rsPRODSIGN = $(strip $(firstword $(subst n n,,$(subst p,,$(firstword $(1)) $(firstword $(2)))) p))

# multiplication and division just determine the sign separately, convert the 
# numbers to unsigned, use the functions above, then re-sign the answer. 
# really, could it be any simpler?
rsMUL = $(strip $(call makesigned,$(call rMUL,$(call makeunsigned,$(1)),$(call makeunsigned,$(2))),$(call rsPRODSIGN,$(1),$(2))))
rsDIV = $(strip $(call makesigned,$(call rDIV,$(call makeunsigned,$(1)),$(call makeunsigned,$(2))),$(call rsPRODSIGN,$(1),$(2))))
printrs = $(call printreal,$(call makeunsigned,$(1))) $(firstword $(1))

# imaginary numbers are represented by words ending in "j", so the above 
# functions generally still work. complex numbers are made by concatenating 
# the strings for the real and imaginary parts.
poscomplex := pj
negcomplex := nj
j := pj

# getting the real and imaginary components is fun and easy!
# everything else, not so much.
makecomplex = $(strip $(1) $(subst $(positive),$(poscomplex),$(subst $(negative),$(negcomplex),$(2))))
cREAL = $(strip $(filter-out %j,$(1)) )
cIMAG = $(strip $(subst $(poscomplex),$(positive),$(subst $(negcomplex),$(negative),$(filter %j,$(1)) )))
cMUL = $(strip $(call makecomplex,$(call rsSUB,$(call rsMUL,$(call cREAL,$(1)),$(call cREAL,$(2))),$(call rsMUL,$(call cIMAG,$(1)),$(call cIMAG,$(2)))),$(call rsADD,$(call rsMUL,$(call cREAL,$(1)),$(call cIMAG,$(2))),$(call rsMUL,$(call cIMAG,$(1)),$(call cREAL,$(2))))))
cADD = $(strip $(call makecomplex,$(call rsADD,$(call cREAL,$(1)),$(call cREAL,$(2))),$(call rsADD,$(call cIMAG,$(1)),$(call cIMAG,$(2)))))
printcomplex = $(call printrs,$(call cREAL,$(1))) + $(call printrs,$(call cIMAG,$(1)))j

# this is the square of the absolute value. purely a convenience  method for 
# perpetrating egregious mandelbrottage.
cSQDIST = $(strip $(call rADD,$(call rSQU,$(call makeunsigned,$(call cREAL,$(1)))),$(call rSQU,$(call makeunsigned,$(call cIMAG,$(1))))))


# parameters for the m-set
MAXITER := $(sixtyfour)
MAXDIST := $(call makereal,$(four),$(zero))
MAXROW := $(sixtyfour)
MAXCOL := $(onetwoeight)

two.zero = $(call makereal,$(two),$(zero))
two.five = $(call makereal,$(two),$(sixtyfour))
one.five = $(call makereal,$(one),$(sixtyfour))

# (MandelbrotIter Z C i)
# if iter is max, return zero; if outside circle return iter; otherwise continue
# notes:
#   - subtracting i from MAXITER is zero (and false) if i >= MAXITER
#   - subtracting (cSQDIST Z) from MAXDIST is zero (and false) if Z is outside 
#     the radius-2 circle
MandelbrotIter = $(if $(call SUB,$(MAXITER),$(3)),$(if $(call rSUB,$(MAXDIST),$(call cSQDIST,$(1))),$(call MandelbrotIter,$(call MandelFunc,$(1),$(2)),$(2),$(call INC,$(3))),$(3)),$(zero))

# (MandelFunc Z C)
# Z = Z^2 + C
# after all this lead-up, the function itself is kind of anticlimactic.
MandelFunc = $(strip $(call cADD,$(call cMUL,$(1),$(1)),$(2)))

# aw hells yeah, we are getting some awesome ascii art right here.
# . , - + % O @ 
pointtypes := . . , - - - - - - - - - - + + + + + + + + + + + + + + + + + % % % % % % % % % % % % O O O O O O O O O O O O O O O O O O O O O O O O O O O O O
RenderPoint = $(if $(1),$(word $(words $(1)),$(pointtypes)),@)
# wait, no, that looks stupid. 
# oh well.

# only set these if this is the top level. this feels like a dirty hack, which 
# is kinda funny given everything above.
ifeq ($(MAKELEVEL),0)
row := $(MAXROW)
col := $(MAXCOL)
MINX := $(strip $(call makesigned,$(two.five),$(negative)))
MINY := $(strip $(call makesigned,$(two.zero),$(negative)))
MAXX := $(strip $(call makesigned,$(one.five),$(positive)))
MAXY := $(strip $(call makesigned,$(two.zero),$(positive)))
STEPX := $(call rsDIV,$(call rsSUB,$(MAXX),$(MINX)),$(call makesigned,$(call makereal,$(MAXCOL),$(zero)),$(positive)))
STEPY := $(call rsDIV,$(call rsSUB,$(MAXY),$(MINY)),$(call makesigned,$(call makereal,$(MAXROW),$(zero)),$(positive)))
endif

# export stuff that recursive calls will need.
export row
export col
export MINX
export MINY
export STEPX
export STEPY


# figure out where we are right now in the complex plane.
realC = $(strip $(call rsADD,$(MINX),$(call rsMUL,$(STEPX),$(call makepossignedreal,$(call SUB,$(MAXCOL),$(col))))))
imagC = $(strip $(call rsADD,$(MINY),$(call rsMUL,$(STEPY),$(call makepossignedreal,$(call SUB,$(MAXROW),$(row))))))
C = $(call makecomplex,$(realC),$(imagC))

# main target 
#   reinvokes targetting a row, then reinvokes itself with row incremented.
brot : row := $(call DEC,$(row))
brot : col := $(MAXCOL)
brot : 
ifneq ($(strip $(row)), $(strip $(zero)))
	@$(MAKE) -es brotrow
	@echo 
	@$(MAKE) -es brot
else
	@echo 
endif

# row target 
#   reinvokes targetting a point, then reinvokes itself with column incremented.
brotrow : col := $(call DEC,$(col))
brotrow :
ifneq ($(strip $(col)), $(strip $(zero)))
	@$(MAKE) -es brotpoint
	@$(MAKE) -es brotrow
endif

# point target 
#   performs the mandelbrot iteration on the current complex point and prints 
#   the result. see, that wasn't so bad!
brotpoint: 
	@echo -n $(call RenderPoint,$(call MandelbrotIter,$(C),$(C),$(one)))

