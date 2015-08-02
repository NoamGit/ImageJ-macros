// Calibrate 10X full FOV

//makeLine(0, 5, 1000, 5);
//makeLine(250, 5,0 ,5 ); // binnig 4X4

makeLine(5, 0, 5, 250); // binnig 4X4
//makeLine(5, 0, 5, 1000); // binnig 1X1

//run("Set Scale...", "known=890 unit=um global"); // for 10X
run("Set Scale...", "known=490 unit=um global");// for 20X

