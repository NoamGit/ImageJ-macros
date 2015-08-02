//=================================================================== 
// Add description 
// author: Noam Cohen 2015

macro 'quick DeltaF(with darkcurrent)'{ 

// checks if is stack & if a region is selected
	if(selectionType() == -1){
	// Creates Dialog box to select Roi
	setTool("oval");
	waitForUser("Delta F/F","select cell for baseline estimation");
	}

  	if (nSlices==1){
        exit("This tool requires a stack");
  	}
   
	//find f0
	image_out = getImageID(); 
	run("Plot Z-axis Profile");     
	Plot.getValues(x, profileValues);
	run("Close");
	perc = 0.05;
	numBins=  256;
	selectImage(image_out); 
	f0 = makeHistogram(numBins,profileValues,perc);

	DeltaF = newArray(profileValues.length);
	for (ii=0; ii<profileValues.length; ii++){
		DeltaF[ii] = (profileValues[ii] - f0)/f0;		
	}
	Plot.create("DeltaF", "Time", "dF/F", x, DeltaF);
	//Plot.update();//end of macro


//********************functions below here 

function makeHistogram(nBins, ArrayName, precentile){ 
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