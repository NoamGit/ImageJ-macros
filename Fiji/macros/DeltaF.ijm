//=================================================================== 
// Add description 
// author: Noam Cohen 2015

macro 'DeltaF'{ 

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

	//find f0
	image_out = getImageID(); 
	setTool("oval");
	waitForUser("Delta F/F","select cell for baseline estimation");
	run("Plot Z-axis Profile");     
	Plot.getValues(x, profileValues);
	run("Close");
	perc = 0.05;
	numBins=  256;
	selectImage(image_out); 
	f0 = findPercentile(numBins,profileValues,perc);

	DeltaF = newArray(profileValues.length);
	for (ii=0; ii<profileValues.length; ii++){
		DeltaF[ii] = (profileValues[ii] - f0)/f0;		
	}
	Plot.create("DeltaF", "Time", "dF/F", x, DeltaF);
	Plot.update();//end of macro


//********************functions below here 

function findPercentile(nBins, ArrayName, precentile){ 
	histogramBinArrayMin=newArray(nBins); 
	histogramBinArrayMax=newArray(nBins); 
	histogramBinArray=newArray(nBins); 
	histogramPlotXArray=newArray(nBins); 
	histogramPlotFreqArray=newArray(nBins); 
	Array.getStatistics(ArrayName, ArrayMin, ArrayMax, ArrayMean, ArraystdDev); 
	binSize=(ArrayMax-ArrayMin)/(nBins+1); 
	
	//set the bin values 
	for(i=0;i<nBins;i++){ 
		histogramBinArrayMin[i]=ArrayMin+(i*binSize); 
		histogramBinArrayMax[i]=ArrayMin+((i+1)*binSize); 
	} 
	
	//detrmine the number plot profile values in each bin 
	for(i=0;i<lengthOf(ArrayName);i++){ 
		chkE=ArrayName[i]; 
		for(j=0;j<nBins;j++){ 
			if(chkE>=histogramBinArrayMin[j] && chkE<histogramBinArrayMax[j]){ 
				chkBinCount=histogramBinArray[j]; 
				histogramBinArray[j]=chkBinCount+1; 
		} 
			if(chkE==ArrayMax){ 
				chkBinCount=histogramBinArray[nBins-1]; 
			} 
		} 
	} 
	
	//generates the values for plotting 
	for(i=0;i<nBins;i++){ 
		histogramPlotXArray[i]=(histogramBinArrayMin[i]+histogramBinArrayMax[i])/2;//for x axis center in the middle of the bin 
		histogramPlotFreqArray[i]=histogramBinArray[i]/(lengthOf(ArrayName)); //for y axis is number in each bin divided by the total number of plot values 
	} 
	
	// create cumulative distribution function
	cum = newArray(histogramPlotFreqArray.length); 
	cum[0] = histogramPlotFreqArray[0]; 
	for (i = 1; i < histogramPlotFreqArray.length ; i++){ 
	        cum[i] = histogramPlotFreqArray[i] + cum[i-1]; 
	}
	       
	// find percentile 
	for (i = 1; i<histogramPlotFreqArray.length; i++) {
		if (cum[i-1] <= precentile && precentile <= cum[i]) 
			// output tissue threshold: 
			return histogramPlotXArray[i]; 
		} 

}//end of makeHistogram 