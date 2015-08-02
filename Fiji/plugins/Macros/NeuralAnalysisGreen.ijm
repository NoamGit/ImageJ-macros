// runs the neuralAnalysisCode and seperates the green channel 

run("Install...", "install=[C:\\Users\\noambox\\Documents\\FIJI IMAGEJ\\Fiji.app\\plugins\\Macros\\NeuralAnalysisKalman.ijm]");

//run("Brightness/Contrast...");

run("Stack to RGB", "frames keep");
run("Merge Channels...", "c2=after_Kalman-1.tif create keep");
run("Split Channels");
