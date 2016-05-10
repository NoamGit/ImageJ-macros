function action(input, output, filename){
	open(input + filename);
	print("Proccesing filename  - " + filename);
	run("Stack to RGB");
	run("RGB to Luminance");
	saveAs("Tiff", output + filename);
	//print("file saved");
	close();
	close();
	close();
}


input = "D:/Noam/# FINAL ANALYSIS/Sectioning/SLITE/input/";
output = "D:/Noam/# FINAL ANALYSIS/Sectioning/SLITE/output/";

setBatchMode(true); 
list = getFileList(input);
print(list[0]);
print("List Size - " +list.length);
for (i = 0; i < (list.length); i++)
		action(input, output, list[i]);
		//print(list[i]);
		//print("Proccesing itertion " + i + " filename " + list[i]);
        
setBatchMode(false);

print("DONE!");
