
run("Trainable Weka Segmentation");
selectWindow("Trainable Weka Segmentation v2.2.1");
call("trainableSegmentation.Weka_Segmentation.saveFeatureStack", "C:\\Users\\noambox\\Documents\\NielFiji-repo\\Fiji\\Self Customized Parameters\\Classifier Data\\", "feature-stack_AVR3.tif");
call("trainableSegmentation.Weka_Segmentation.setFeature", "Gaussian_blur=false");
call("trainableSegmentation.Weka_Segmentation.setFeature", "Sobel_filter=false");
call("trainableSegmentation.Weka_Segmentation.setFeature", "Lipschitz=true");
call("trainableSegmentation.Weka_Segmentation.setFeature", "Kuwahara=true");
call("trainableSegmentation.Weka_Segmentation.setFeature", "Gabor=true");
call("trainableSegmentation.Weka_Segmentation.setMembranePatchSize", "9");
call("trainableSegmentation.Weka_Segmentation.setMinimumSigma", "6.0");
call("trainableSegmentation.Weka_Segmentation.setMaximumSigma", "18.0");
call("trainableSegmentation.Weka_Segmentation.changeClassName", "0", "cell");
call("trainableSegmentation.Weka_Segmentation.changeClassName", "1", "back");
call("trainableSegmentation.Weka_Segmentation.setClassHomogenization", "true");
