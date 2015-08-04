// This Macro flips the Stack to it's original orientation 
// deletes a  slice and runs Kalman

run("Delete Slice");
run("Rotate 90 Degrees Left");
run("Flip Horizontally", "stack");
run("Kalman Stack Filter", "acquisition_noise=0.05 bias=0.80");
