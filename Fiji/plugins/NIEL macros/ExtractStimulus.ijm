//=================================================================== 
// Simple macro for extraction of stimulus peaks time out of Andor tiff files
// author: Noam Cohen 2015

macro 'ExtractStimulus'{ 
	// input dialog box 
	image = getImageID(); 
	selectImage(image);
	run("Plot Z-axis Profile");
	Plot.getValues(x, meanSignal);
	Dialog.create("ExtractStimulus");
	Dialog.addMessage("Set trashold for stimulus");
	Dialog.addNumber("treshold", 500);	
	Dialog.show();
    thresh = Dialog.getNumber();
	run("Close");
	
  	// find frames of stimulus
  	selectImage(image);
  	peaks  = findPeaks( thresh, meanSignal);
	Array.print(peaks);
	stim = newArray(meanSignal.length-1);
	Array.fill(stim,0);
	for (ii=0; ii<peaks.length; ii++){
		stim[peaks[ii]-1] = 1;		
	}
	Plot.create("DeltaF", "Time", "dF/F", x, stim);