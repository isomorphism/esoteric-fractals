@echo off

SET /a scale=1000
SET /a xstep=20
SET /a ystep=30

SET /a xmin=-2*scale
SET /a ymin=(-3*scale)/2
SET /a xmax=1*scale
SET /a ymax=(3*scale)/2

SET /a depth=16
SET /a escape=2*scale

SET /a heavy=8
SET /a mid=6
SET /a light=4

SET /a ypos=ymin
:yloop

    SET line=

    SET /a xpos=xmin
    :xloop

        SET /a zr=xpos
        SET /a zi=ypos
        SET /a count=0
        :iter
            SET /a oldreal=zr
            SET /a zr=((zr*zr)/scale)-((zi*zi)/scale)+xpos
            SET /a zi=((2*zi*oldreal)/scale)+ypos
            SET /a count=count+1
            SET /a dist=((zr*zr)+(zi*zi))/scale

        IF %count% GEQ %depth% GOTO iterdone
        IF %dist% GEQ %escape% GOTO iterdone
        GOTO :iter    
        :iterdone

                SET char=°
                IF %count% GEQ %light% SET char=±
                IF %count% GEQ %mid% SET char=²
                IF %count% GEQ %heavy% SET char=Û
        IF %count% GEQ %depth% SET char= 
        
        SET line=%line%%char%

    SET /a xpos=xpos+xstep
    IF %xpos% LSS %xmax% GOTO :xloop    

    ECHO %line%

SET /a ypos=ypos+ystep
IF %ypos% LSS %ymax% GOTO :yloop


