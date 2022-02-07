MODULE Module1
	CONST robtarget p10:=[[-833.42,1087.24,-298.60],[0.193943,0.177191,0.0583253,-0.963114],[-1,0,-1,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
	CONST robtarget p20:=[[0.00,182.23,0.00],[0.391849,-0.180981,0.292872,-0.853186],[0,-1,0,1],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
	!CONST robtarget p30:=[[-447.86,1196.33,-413.44],[0.193943,0.177188,0.0583262,-0.963114],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
	CONST robtarget EXTREME:=[[-447.86,1196.33,-413.44],[0.193943,0.177188,0.0583262,-0.963114],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
	!CONST robtarget EXTREME10:=[[-447.86,1196.33,-413.44],[0.193943,0.177188,0.0583262,-0.963114],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
	!CONST robtarget EXTREME20:=[[-447.85,1196.33,-413.44],[0.193942,0.177189,0.058326,-0.963114],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST num SHUT_DOWN := -1;
    CONST num TO_WAIT := 0;
    CONST num TO_PAINT := 1;
    CONST num TO_INTRODUCE := 2;
    VAR speeddata drawingSpeed;
    VAR num speedLevel := 0;
    VAR num flag := 0;
    VAR bool repeat := TRUE;

    
    PERS pos tgPos{500};
    VAR num targetsNum;
    FUNC robtarget create_robtarget(pos position)
       !RETURN [position,[0.707106781,0,0,0.707106781],[1,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
      RETURN [position, [0.193943,0.177191,0.0583253,-0.963114],[-1,0,-1,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    ENDFUNC
    
    FUNC speeddata shifting(num base)
        IF base = 0 THEN RETURN v100;
        ELSEIF base = 1 THEN RETURN v300;
        ELSEIF base = 2 THEN RETURN v600;
        ELSE RETURN v1000;
        ENDIF
    ENDFUNC
    
     ! variable initialization
    FUNC bool init()
        
        drawingSpeed := shifting(speedLevel);
        targetsNum := 0;
        repeat := TRUE;
        flag := 0;
        
        RETURN TRUE;
        
    ENDFUNC
    
    ! painting process
	PROC EX_PAINT()
        
        VAR num i := 2;
        drawingSpeed := shifting(speedLevel);
        
        ! This property is important if targets are created offline/ not in RobotStudio
        ConfL \Off;
        
        ! Approaching to the canvas is always at maximum speed ( v1000 )
        !MoveL create_robtarget(tgPos{1}), shifting(3), z100, Pen_TCP\WObj:=canvas1;
        ! Do while robtarget exists..
        ! This section should be repleaced with for iteration
        MoveJ EXTREME, v1000, z50, tool0\WObj:=canvas1;
        MoveL p10, v1000, z50, tool0\WObj:=canvas1;
        MoveJ p20, v1000, z50, tool0\WObj:=canvas1;
         MoveJ EXTREME, v1000, z50, tool0\WObj:=canvas1;
        WHILE repeat DO
            
            MoveJ p20, v1000, z50, tool0\WObj:=canvas1;
             !MoveL create_robtarget(tgPos{i}), drawingSpeed, z100, Pen_TCP\WObj:=canvas1;
            i := i + 1;
            IF i > targetsNum THEN repeat := FALSE; ENDIF
            
        ENDWHILE
        
        flag := TO_WAIT;
        repeat := TRUE;
        i := 2;
        
        ! set the TCP at the starting point
        MoveJ EXTREME,shifting(3),z100,Pen_TCP\WObj:=canvas1;
        !MoveL EXTREME, shifting(3) z100, Pen_TCP\WObj:=canvas1;

	ENDPROC
    
    ! other process
    PROC EX_INTRODUCING()
        
        flag := TO_WAIT;
	ENDPROC
    
    ! main process
   
    
    PROC main()
        !Add your code here
        !MoveJ EXTREME, v1000, z50, tool0\WObj:=canvas1;
        !MoveL p10, v1000, z50, tool0\WObj:=canvas1;
        !MoveJ p20, v1000, z50, tool0\WObj:=canvas1;
        !WaitTime 0.5;
        
        IF init() = TRUE THEN
        
            ! SingArea \Wrist - solvs the 'singularity' problem
            SingArea \Wrist;
            ! set the TCP at the starting point
            MoveJ EXTREME,v1000,z100,Pen_TCP\WObj:=canvas1;
            !MoveJ EXTREME, v1000, z50, tool0\WObj:=canvas1;
            
            ! A kind of self-made event handler...
            WHILE flag > SHUT_DOWN DO
                IF flag = TO_PAINT THEN EX_PAINT; ENDIF
                IF flag = TO_INTRODUCE THEN EX_INTRODUCING; ENDIF
                WaitTime 0.2;
            ENDWHILE
        
        ENDIF
        
    ENDPROC
ENDMODULE