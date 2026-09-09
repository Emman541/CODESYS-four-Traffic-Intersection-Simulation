VARIABLES
PROGRAM PLC_PRG
VAR
	iState: INT:= 1;
	
	upRed: BOOL;
	upYellow: BOOL;
	upGreen: BOOL;
	
	rightRed: BOOL;
	rightYellow: BOOL;
	rightGreen: BOOL;
	
	downRed: BOOL;
	downYellow: BOOL;
	downGreen: BOOL;
	
	leftRed: BOOL;
	leftYellow: BOOL;
	leftGreen: BOOL;
	
	tLight: TON;
	
	carSpeed: INT := 5;
	safeDistance: INT := 10;

	leftCar1: INT := -100;
	leftCar2: INT := -200;
	leftCar3: INT := -300;
	
	checkTrafficLightDistance: INT := 8;
	checkTrafficLightDownDistance: INT := -50;
	
	
	rightCar1: INT := 100;
	rightCar2: INT := 200;
	rightCar3: INT := 300;
	
	upCar1: INT := -100;
	upCar2: INT := -200;
	upCar3: INT := -300;
	
	downCar1: INT := 50;
	downCar2: INT := 100;
	downCar3: INT := 200;
END_VAR

PASCAL WRTINGS

CASE iState OF
	1: //INTERSECTIONS OF UP AND DOWN GREEN
	   //GREEN LIGHT ON
		upRed := FALSE;
		upYellow := FALSE;
		upGreen := TRUE;
		
		//RED LIGHT ON
		rightRed := TRUE;
		rightYellow := FALSE;
		rightGreen := FALSE;
		
		//GREEN LIGHT ON
		downRed := FALSE;
		downYellow := FALSE;
		downGreen := TRUE;
		
		//RED LIGHT ON
		leftRed := TRUE;
		leftYellow := FALSE;
		leftGreen := FALSE;
		
		//THE LIGHT WILL STAY ON FOR 7 SECONDS 
		tLight(IN := TRUE, PT := T#7S);

        IF tLight.Q THEN
            tLight(IN := FALSE);
            iState := 2;
        END_IF;
		
	2: //INTERSECTIONS OF UP AND DOWN YELLOW
	   //YELLOW LIGHT ON
		upRed := FALSE;
		upYellow := TRUE;
		upGreen := FALSE;
		
		//RED LIGHT ON
		rightRed := TRUE;
		rightYellow := FALSE;
		rightGreen := FALSE;
		
		//YELLOW LIGHT ON
		downRed := FALSE;
		downYellow := TRUE;
		downGreen := FALSE;
		
		//RED LIGHT ON
		leftRed := TRUE;
		leftYellow := FALSE;
		leftGreen := FALSE;
		
		//THE LIGHT WILL STAY ON FOR 1 SECOND
		tLight(IN := TRUE, PT := T#1S);

        IF tLight.Q THEN
            tLight(IN := FALSE);
            iState := 3;
        END_IF;
	
	3: //INTERSECTIONS OF LEFT AND RIGHT GREEN
	   //RED LIGHT ON
		upRed := TRUE;
		upYellow := FALSE;
		upGreen := FALSE;
		
		//GREEN LIGHT ON
		rightRed := FALSE;
		rightYellow := FALSE;
		rightGreen := TRUE;
		
		//RED LIGHT ON
		downRed := TRUE;
		downYellow := FALSE;
		downGreen := FALSE;
		
		//GREEN LIGHT ON
		leftRed := FALSE;
		leftYellow := FALSE;
		leftGreen := TRUE;
		
		//THE LIGHT WILL STAY ON FOR 10 SECONDS 
		tLight(IN := TRUE, PT := T#10S);

        IF tLight.Q THEN
            tLight(IN := FALSE);
            iState := 4;
        END_IF;
	
	4: //INTERSECTIONS OF LEFT AND RIGHT YELLOW
	   //RED LIGHT ON
		upRed := TRUE;
		upYellow := FALSE;
		upGreen := FALSE;
		
		//YELLOW LIGHT ON
		rightRed := FALSE;
		rightYellow := TRUE;
		rightGreen := FALSE;
		
		//RED LIGHT ON
		downRed := TRUE;
		downYellow := FALSE;
		downGreen := FALSE;
		
		//GREEN LIGHT ON
		leftRed := FALSE;
		leftYellow := TRUE;
		leftGreen := FALSE;
		
		//THE LIGHT WILL STAY ON FOR 1 SECONDS 
		tLight(IN := TRUE, PT := T#1S);

        IF tLight.Q THEN
            tLight(IN := FALSE);
            iState := 1;
        END_IF;



END_CASE
//LEFT TO RIGHT 
// ========================================
// CAR 1
// ========================================

IF leftCar1 < 160 THEN

    leftCar1 := leftCar1 + carSpeed;

ELSIF leftCar1 = 160 THEN

    IF leftGreen OR leftYellow THEN
        leftCar1 := leftCar1 + carSpeed;
    END_IF;

ELSE

    leftCar1 := leftCar1 + carSpeed;

END_IF;

IF leftCar1 > 1000 THEN
    leftCar1 := -100;
END_IF;


// ========================================
// CAR 2
// ========================================

// Keep 30 units behind Car 1
IF leftCar2 + safeDistance < leftCar1 THEN

    IF leftCar2 < 160 THEN

        // Before traffic light
        leftCar2 := leftCar2 + carSpeed;

    ELSIF leftCar2 = 160 THEN

        // At traffic light
        IF leftGreen OR leftYellow THEN
            leftCar2 := leftCar2 + carSpeed;
        END_IF;

    ELSE

        // Already passed traffic light
        leftCar2 := leftCar2 + carSpeed;

    END_IF;

END_IF;

IF leftCar2 > 900 THEN
    leftCar2 := -200;
END_IF;

// ========================================
// CAR 3
// ========================================

// Keep 30 units behind Car 2
IF leftCar3 + safeDistance < leftCar2 THEN

    IF leftCar3 < 160 THEN

        // Before traffic light
        leftCar3 := leftCar3 + carSpeed;

    ELSIF leftCar3 = 160 THEN

        // At traffic light
        IF leftGreen OR leftYellow THEN
            leftCar3 := leftCar3 + carSpeed;
        END_IF;

    ELSE

        // Already passed traffic light
        leftCar3 := leftCar3 + carSpeed;

    END_IF;

END_IF;

IF leftCar3 > 800 THEN
    leftCar3 := -300;
END_IF;


//RIGHT TO LEFT 
// ========================================
// RIGHT CAR 1
// ========================================

IF rightCar1 > -150 THEN

    // Approaching traffic light
    rightCar1 := rightCar1 - carSpeed;

ELSIF rightCar1 = -150 THEN

    // Check traffic light
    IF rightGreen OR rightYellow THEN
        rightCar1 := rightCar1 - carSpeed;
    END_IF;

ELSE

    // Already passed traffic light
    rightCar1 := rightCar1 - carSpeed;

END_IF;


// Reset Car 1
IF rightCar1 < -900 THEN
    rightCar1 := 100;
END_IF;


// ========================================
// RIGHT CAR 2
// ========================================

// Keep safe distance behind Car 1
IF rightCar2 - safeDistance > rightCar1 THEN

    IF rightCar2 > -150 THEN

        // Approaching traffic light
        rightCar2 := rightCar2 - carSpeed;

    ELSIF rightCar2 = -150 THEN

        // Check traffic light
        IF rightGreen OR rightYellow THEN
            rightCar2 := rightCar2 - carSpeed;
        END_IF;

    ELSE

        // Already passed traffic light
        rightCar2 := rightCar2 - carSpeed;

    END_IF;

END_IF;


// Reset Car 2
IF rightCar2 < -800 THEN
    rightCar2 := 200;
END_IF;


// ========================================
// RIGHT CAR 3
// ========================================

// Keep safe distance behind Car 2
IF rightCar3 - safeDistance > rightCar2 THEN

    IF rightCar3 > -150 THEN

        // Approaching traffic light
        rightCar3 := rightCar3 - carSpeed;

    ELSIF rightCar3 = -150 THEN

        // Check traffic light
        IF rightGreen OR rightYellow THEN
            rightCar3 := rightCar3 - carSpeed;
        END_IF;

    ELSE

        // Already passed traffic light
        rightCar3 := rightCar3 - carSpeed;

    END_IF;

END_IF;


// Reset Car 3
IF rightCar3 < -700 THEN
    rightCar3 := 300;
END_IF;

//TOP TO BOTTOM
// ========================================
// UP CAR 1
// ========================================

IF upCar1 < checkTrafficLightDistance THEN

    // Approaching traffic light
    upCar1 := upCar1 + carSpeed;

ELSIF upCar1 = checkTrafficLightDistance THEN

    // Check traffic light
    IF upGreen OR upYellow THEN
        upCar1 := upCar1 + carSpeed;
    END_IF;

ELSE

    // Already passed traffic light
    upCar1 := upCar1 + carSpeed;

END_IF;


// Reset Car 1
IF upCar1 > 900 THEN
    upCar1 := -100;
END_IF;


// ========================================
// UP CAR 2
// ========================================

// Keep 30 units behind Car 1
IF upCar2 + safeDistance < upCar1 THEN

    IF upCar2 < checkTrafficLightDistance THEN

        // Approaching traffic light
        upCar2 := upCar2 + carSpeed;

    ELSIF upCar2 = checkTrafficLightDistance THEN

        // Check traffic light
        IF upGreen OR upYellow THEN
            upCar2 := upCar2 + carSpeed;
        END_IF;

    ELSE

        // Already passed traffic light
        upCar2 := upCar2 + carSpeed;

    END_IF;

END_IF;


// Reset Car 2
IF upCar2 > 800 THEN
    upCar2 := -200;
END_IF;


// ========================================
// UP CAR 3
// ========================================

// Keep 30 units behind Car 2
IF upCar3 + safeDistance < upCar2 THEN

    IF upCar3 < checkTrafficLightDistance THEN

        // Approaching traffic light
        upCar3 := upCar3 + carSpeed;

    ELSIF upCar3 = checkTrafficLightDistance THEN

        // Check traffic light
        IF upGreen OR upYellow THEN
            upCar3 := upCar3 + carSpeed;
        END_IF;

    ELSE

        // Already passed traffic light
        upCar3 := upCar3 + carSpeed;

    END_IF;

END_IF;


// Reset Car 3
IF upCar3 > 700 THEN
    upCar3 := -300;
END_IF;


//DOWN TO UP
// ========================================
// DOWN CAR 1
// ========================================

IF downCar1 > checkTrafficLightDownDistance THEN

    // Approaching traffic light
    downCar1 := downCar1 - carSpeed;

ELSIF downCar1 = checkTrafficLightDownDistance THEN

    // Check traffic light
    IF downGreen OR downYellow THEN
        downCar1 := downCar1 - carSpeed;
    END_IF;

ELSE

    // Already passed traffic light
    downCar1 := downCar1 - carSpeed;

END_IF;


// Reset Car 1
IF downCar1 < -800 THEN
    downCar1 := 50;
END_IF;


// ========================================
// DOWN CAR 2
// ========================================

// Keep 30 units behind Car 1
IF downCar2 - safeDistance > downCar1 THEN

    IF downCar2 > checkTrafficLightDownDistance THEN

        // Approaching traffic light
        downCar2 := downCar2 - carSpeed;

    ELSIF downCar2 = checkTrafficLightDownDistance THEN

        // Check traffic light
        IF downGreen OR downYellow THEN
            downCar2 := downCar2 - carSpeed;
        END_IF;

    ELSE

        // Already passed traffic light
        downCar2 := downCar2 - carSpeed;

    END_IF;

END_IF;


// Reset Car 2
IF downCar2 < -700 THEN
    downCar2 := 100;
END_IF;


// ========================================
// DOWN CAR 3
// ========================================

// Keep 30 units behind Car 2
IF downCar3 - safeDistance > downCar2 THEN

    IF downCar3 > checkTrafficLightDownDistance THEN

        // Approaching traffic light
        downCar3 := downCar3 - carSpeed;

    ELSIF downCar3 = checkTrafficLightDownDistance THEN

        // Check traffic light
        IF downGreen OR downYellow THEN
            downCar3 := downCar3 - carSpeed;
        END_IF;

    ELSE

        // Already passed traffic light
        downCar3 := downCar3 - carSpeed;

    END_IF;

END_IF;


// Reset Car 3
IF downCar3 < -600 THEN
    downCar3 := 200;
END_IF;

