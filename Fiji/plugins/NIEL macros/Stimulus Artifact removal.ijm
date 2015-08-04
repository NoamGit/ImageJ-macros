//=================================================================== 
//  This macro takes the selected ROI from the stack and subtracts its mean value from each pixel in the stack.
// This is usefull for functional imaging application's where we ask to exclude flickering stimulus artifact 
// (or any other repetative artifact) from the stack.
//  To use, put a ROI over a region that is background in all slices.  (Choose the ROI on a maximum pixel 
//  projection if features to assure only bg pixels are included.)  Run the macro. 
// author: Noam Cohen 2015

macro 'Flashing Artifact removal'{ 
	// input dialog box 
	image_to_process = getImageID(); 
	selectImage(image_to_process);
	run("Plot Z-axis Profile");
	Plot.getValues(x, meanSignal);
	Dialog.create("Artifact removal");
	Dialog.addMessage("Enter stimulus and aquisition parameters");
	Dialog.addNumber("Stimulus lenght in ms", 20);
	Dialog.addNumber("Aquisition rate in Hz", 20);
	Dialog.addNumber("Stimulus treshold value", 0);
	Dialog.addCheckbox("Overwrite current", 0);
	Dialog.show();
    stimLength = Dialog.getNumber();
    ar = Dialog.getNumber();
    stimThres = Dialog.getNumber();
    overwriteFlag = Dialog.getCheckbox();
    ar_t = 1000/ar;
    run("Close");
   	
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
   Roi.getBounds(xpos, ypos, width, height);
   image_to_process = getImageID(); 
   image_out = getImageID(); 
   if(!overwriteFlag) {
   		newImage("Subtract background based on ROI","8-bit", getWidth(), getHeight(), nSlices);
   		image_out = getImageID(); 
   		imageCalculator("copy stack",image_out,image_to_process);
   		run("Delete Slice", "delete=1"); // take out first shot
   	}  
    makeRectangle(xpos, ypos, width, height); // same selection area is chosen

	// calculate dark current
  	run("Plot Z-axis Profile");     
	Plot.getValues(x, darkCurrent);
	run("Close"); 
	
		/******* STIMULUS ARTIFACT REMOVAL ********/
			// select threshold if not selected
			/*run("Select All");
			run("Plot Z-axis Profile");
			Plot.getValues(x, meanSignal);
			run("Close");*/
			Array.getStatistics(meanSignal, min, max, mean, stdDev);
			normSignal = newArray(meanSignal.length);
  			for (ii=0; ii<normSignal.length; ii++){
      			normSignal[ii] = meanSignal[ii] - mean;		
  			}
  			run("Select All");
			if( stimThres == 0 ){
			Plot.create("stimulus times", "Time", "F", x, normSignal);
			Plot.update();
			Dialog.create("Stimulus treshold dialog box");
			Dialog.addMessage("Enter stimulus threshold value");
			Dialog.addNumber("Stimulus treshold value", 0);
			Dialog.show();
			//selectImage(image_out);
    		stimThres = Dialog.getNumber();
    		run("Close");
    		selectImage(image_out);
			}
  
			/******* DARK CURRENT REMOVAL********/
				for (i=1; i<=nSlices; i++){ 
						 run("Set Slice...", "slice="+i); 
						 run("Subtract...", "slice value="+darkCurrent[i-1]); //substract from each frame dark current
					}	  
						
		  	// find frames of stimulus
		  	selectImage(image_out);
			tol = stimThres;
		  	peaks  = findPeaks( stimThres, meanSignal);
		  	//print(peaks);
		  	
		/******* AVERAGE PEAK'S VAL ACCORDING LOCATION********/ 
		//selectImage(image_out);
	  	stimWidth = 1;
	    if (ar_t < stimLength){
	  		stimWidth = round(stimLength/ar_t);
	    }
		for (k=0; k<lengthOf(peaks); k++){
			//i=0; 
			sliceID_back = peaks[k]-2;
			sliceID_front = peaks[k]+stimWidth +2;
			run("Set Slice...", "slice="+sliceID_back);
			image_back = getImageID();
			run("Set Slice...", "slice="+sliceID_front);
			image_front = getImageID();  
			imageCalculator("average create",image_front ,image_back);
			image_mean = getImageID();
			selectImage(image_out); 	
			//run("Set Slice...", "slice="+70);	   			
			for (j=0;j<stimWidth;j++){
				sliceID = peaks[k]+j;
				run("Set Slice...", "slice="+sliceID);
				peak = getImageID(); 
				imageCalculator("copy",peak ,image_mean);
			}
			selectImage(image_mean);
			run("Close");
		}
		
}

function findPeaks(threshold, ArrayName){ 
	peaks = newArray(0);
	for(i=0;i<ArrayName.length;i++){
		if(ArrayName[i] > threshold){
			peaks=Array.concat(peaks,i);
		}
	}
return peaks;
}//end of find peaks