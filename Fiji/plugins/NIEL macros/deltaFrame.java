//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

import ij.IJ;
import ij.ImagePlus;
import ij.ImageStack;
import ij.gui.GenericDialog;
import ij.plugin.PlugIn;

public class deltaFrame implements PlugIn {
    ImagePlus imp;
    ImagePlus returnImp = new ImagePlus();
    int default_amplitude = 1;

    public deltaFrame() {
    }

    public void run(String argv) {
        this.imp = IJ.getImage();
        if(this.imp.getStackSize() == 1) {
            IJ.error("Stack required");
        } else {
            GenericDialog gd = new GenericDialog("DeltaSlice settings");
            gd.addNumericField("Gain:", (double)this.default_amplitude, 2);
            this.default_amplitude = (int)gd.getNextNumber();
            gd.showDialog();
            if(gd.wasCanceled()) {
                IJ.error("PlugIn canceled!");
            } else {
                this.returnImp = this.imp.duplicate();
                this.delta_frame();
            }
        }
    }

    private void delta_frame() {
        ImageStack returnStack = this.returnImp.createEmptyStack();
        ImageStack imp_stack = this.imp.getStack();
        Object[] imageArray = imp_stack.getImageArray();
        Object[] outputArray = new Object[imp_stack.getSize()];
        outputArray[0] = subtractByte((byte[])((byte[])imageArray[0]), (byte[])((byte[])imageArray[1]), this.default_amplitude);
        IJ.showProgress(0, imp_stack.getSize());
        returnStack.addSlice(String.valueOf(0), outputArray[0]);
        returnStack.addSlice(String.valueOf(1), outputArray[0]);

        for(int k = 1; k < imp_stack.getSize() - 1; ++k) {
            IJ.showProgress(k, imp_stack.getSize());
            outputArray[k] = subtractByte((byte[])((byte[])imageArray[k]), (byte[])((byte[])imageArray[k + 1]), this.default_amplitude);
            returnStack.addSlice(String.valueOf(k + 1), outputArray[k]);
        }

        this.returnImp.setStack(returnStack);
        this.returnImp.show();
    }

    public static Object subtractByte(byte[] a, byte[] b, int gain) {
        byte[] c = new byte[a.length];

        for(int k = 0; k < a.length; ++k) {
            int a_int = 255 & a[k];
            int b_int = 255 & b[k];
            //c[k] = (byte)(Math.multiplyExact(Math.abs(a_int - b_int), gain) & 255);
            c[k] = (byte)(Math.abs(a_int - b_int) & 255);
            if(c[k] > 127) {
                c[k] = 127;
            }
        }

        return c;
    }

    public static void main(String... args) {
        deltaFrame df = new deltaFrame();
        String path = "C:\\Users\\Noam\\Dropbox\\# graduate studies m.sc\\# SLITE\\ij - plugin data\\";
        df.imp = IJ.openImage(path + "FLASH_20msON_20Hz_SLITE_1.tif");
        String argv = "";
        df.run(argv);
    }
}
