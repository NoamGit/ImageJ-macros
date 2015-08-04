//=================================================================== 
// Add description 
// author: Noam Cohen 2015

macro 'RemoveDarkCurrent'{ 

// checks if is stack & if a region is selected
	if(selectionType() == -1){
	// Creates Dialog box to select Roi
	setTool("rectangle");
	waitForUser("Delta F/F","Select dark current ROI and click OK");
	}

  	if (nSlices==1){
        exit("This tool requires a stack");
  	}
   
   // creates new stack
   	Roi.getBounds(x, y, width, height);
  	image_to_process = getImageID(); 
	newImage("Subtract background based on ROI","8-bit", getWidth(), getHeight(), nSlices);
	image_out = getImageID(); 
	imageCalculator("copy stack",image_out,image_to_process);
	run("Delete Slice", "delete=1"); // take out first shot  
	makeRectangle(x, y, width, height); // same selection area is chosen

	// calculate dark current
  	run("Plot Z-axis Profile");     
	Plot.getValues(x, darkCurrent);
	run("Close"); 
	
	/******* DARK CURRENT REMOVAL********/
	run("Select All");
	for (i=1; i<=nSlices; i++){ 
			 run("Set Slice...", "slice="+i); 
			 run("Subtract...", "slice value="+darkCurrent[i-1]); //substract from each frame dark current
		}	
