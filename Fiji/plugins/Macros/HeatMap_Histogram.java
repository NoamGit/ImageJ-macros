/* 
This plugin counts pixels for each gray value in a 8-bit or 16-bit image in the defined interval. 
Author: Samuel Péan & M. Austenfeld 
*/ 

import java.awt.*; 
import ij.plugin.*; 
import ij.*; 
import ij.gui.*; 
import ij.process.*; 
import ij.measure.ResultsTable; 
import ij.gui.GenericDialog; 

public class HeatMap_Histogram implements PlugIn { 

        public double pixelCount = 0;// The variable for the pixel count! 
        public int min = 0;// The min value for the pixel count! 
        public int max = 256;// The max value for the pixel count! 
        public String[] BarLoc = {"Upper Right", "Lower Right","Lower Left","Upper Left"};
        public String BarLocTemp;
        public String[] FillCol = {"None", "White", "Light Gray", "Dark Gray", "Black", "Red", "Green", "Blue", "Yellow"};
        public String FillColTemp;
        public String[] LabCol = { "None", "White", "Light Gray", "Dark Gray", "Black", "Red", "Green", "Blue", "Yellow" };
        public String LabColTemp;
        public int NumLab=5;
        public int NumDec=0;
        public int FontSize=12;
        public double zoom=1;
        public boolean bold=false;
        public String boldTemp;
        public String title;
        public String title2;  
        public String title3;
        public String ImgDir;
        public String ImgName;
 

        public void run(String arg) { 
                ImagePlus imp = WindowManager.getCurrentImage(); 
                title=imp.getTitle();
                title2= (title + " - HeatMap");
                title3=(title + " - HeatMap & Bar");
                if (imp != null) { 

                	/*We proof if the image is an 8-bit or 16-bit image!*/ 
                                     ImageProcessor im= imp.getProcessor() ; 
                        if (im instanceof ShortProcessor||im instanceof ByteProcessor ) { 
                                /*We create a dialog!*/ 
                                GenericDialog gd = new GenericDialog("Count Pixels"); 
                                gd.addNumericField("Min: ", min, 0); 
                                gd.addNumericField("Max: ", max, 0);
                                gd.addChoice("Bar location", BarLoc, BarLoc[0]);
                                gd.addChoice("Fill color", FillCol, FillCol[0]);
                                gd.addChoice("Text color", LabCol, LabCol[0]);
                                gd.addNumericField("Number of Label: ", NumLab, 0); 
                                gd.addNumericField("Number of Decimal: ", NumDec, 0); 
                                gd.addNumericField("Font size: ", FontSize, 0); 
                                gd.addNumericField("Zoom: ", zoom, 0); 
                                gd.addCheckbox("Bold label", bold);
                                
                                gd.addMessage("Please install Thermal.lut in the imagej/luts folder !!!");
                                gd.addMessage("http://www.samuelpean.com / contact@samuelpean.com");
                                
                                gd.showDialog(); 
                                if (gd.wasCanceled()) 
                                        return; 

                                /*We get the values from the dialog!*/ 
                                min = (int) gd.getNextNumber(); 
                                max = (int) gd.getNextNumber(); 
                                BarLocTemp =gd.getNextChoice();
                                FillColTemp=gd.getNextChoice();
                                LabColTemp=gd.getNextChoice();
                                NumLab = (int) gd.getNextNumber(); 
                                NumDec = (int) gd.getNextNumber(); 
                                FontSize = (int) gd.getNextNumber(); 
                                zoom = gd.getNextNumber(); 
                                bold = gd.getNextBoolean();
                                
                                if (bold) 
                                {
                                	boldTemp="bold";
                                }
                                

                                /*We create a results table!*/ 
                                ResultsTable rt = ResultsTable.getResultsTable(); 
                                rt.reset(); 
                                
                                
                                IJ.run("Duplicate...", "title=["+title+" - HeatMap]"); 
                                IJ.run("8-bit");

                                /*Get the active image !*/ 

                                        /*Get the image processor of the image !*/ 
                                        ImageProcessor ip = imp.getProcessor(); 
                                        int w = ip.getWidth(); 
                                        int h = ip.getHeight(); 

                                        int histo[]=ip.getHistogram();
                                        /*We loop through all pixels in a stack image!*/
                                        for (int v = 0; v < h; v++) {
                                                for (int u = 0; u < w; u++) {

                                                        /*Get the pixel value!*/
                                                        int i = ip.getPixel(u, v);

                                                        /*All values which match the interval are counted!*/
                                                        if (i >= min && i <= max) {

                                                                pixelCount++;

                                                        }

                                                }
                                                IJ.showProgress((double)(v+1)/h);
                                        }
                                
                                        
                                          for (int j=0; j<256; j++) { 
                                          	  
                                          	   rt.incrementCounter(); 
                                          	   rt.addValue("Value", j); 
                                          	  if (j>=min && j<=max) {
                                          	  	 
                                          	  	  /*We add the counted values to the results table!*/ 
                                          	  	rt.addValue("Count Raw", histo[j]);
                                          	  	double Rel = (histo[j]/pixelCount);
                                          	  	rt.addValue("Count Rel", Rel);
                                          	  }
                                          	  else{
                                          	  	  rt.addValue("Count Raw", -1); 
                                          	  	  rt.addValue("Count Rel", -1); 
                                          	  }
                                          	  
                                          	  IJ.showProgress((double)(j+1)/256);
                                          } 
                                        
                                
                                         IJ.run("thermal");
                                         IJ.run("Calibration Bar...", "location=["+BarLocTemp+"] fill="+FillColTemp+" label="+LabColTemp+" number="+NumLab+" decimal="+NumDec+" font="+FontSize+" zoom="+zoom+" "+boldTemp);
                                         rt.show("Results"); 
                                
                        } 

                        else { 
                                
                                                IJ.showMessage("Requires an 8-bit or 16-bit image !"); 
                        } 

                } else { 
                        
                                    IJ.showMessage("No image opened !"); 
                } 

        } 

}
