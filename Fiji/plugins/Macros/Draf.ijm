	image = getImageID(); 
	selectImage(image);
	run("Plot Z-axis Profile");
	Plot.getValues(x, meanSignal);
	run("Close");
	
  	// find frames of stimulus
  	selectImage(image);
  	peaks  = findPeaks( 500, meanSignal);
	
	stim = newArray(meanSignal.length-1);
	Array.fill(stim,0);
	for (ii=0; ii<peaks.length; ii++){
		stim[peaks[ii-1]] = 1;		
	}
	Plot.create("DeltaF", "Time", "dF/F", x, DeltaF);
	
/*function findPeaks(threshold, ArrayName){ 
	peaks = newArray(0);
	for(i=0;i<ArrayName.length;i++){
		if(ArrayName[i] > threshold){
			peaks=Array.concat(peaks,i);
		}
	}
return peaks;*/
