filename=getTitle();
run("Duplicate...", "duplicate");
//Set area in pixels
run("Set Scale...", "distance=0 known=0 unit=pixel");


//filename1 will be the area selection mask
filename1=filename+"-1"
selectWindow(filename1);
run("Gaussian Blur...", "sigma=1 stack");
run("Split Channels");
UVmask="C1-"+filename1;
GREENmask="C2-"+filename1;
close("C3-"+filename1);
selectWindow(UVmask);
setThreshold(5, 1e30);
run("Make Binary", "method=Default background=Default black");
selectWindow(GREENmask);
setThreshold(5, 1e30);
run("Make Binary", "method=Default background=Default black");
imageCalculator("AND create stack", UVmask,GREENmask);
AREAmask="Result of "+UVmask;
//close(UVmask);
//close(GREENmask);


//Apply AREA mask to orignal images
selectWindow(filename);
run("Split Channels");
close("C3-"+filename);
UV="C1-"+filename;
GREEN="C2-"+filename;
selectWindow(UV);
setSlice(1);
selectWindow(AREAmask);
		//run("Invert", "stack");
setSlice(1);
run("Set Measurements...", "area mean limit display redirect=None decimal=3");

	//Run analysis for UV stack
	for (i = 0; i < nSlices; i++) {
		sliceN=getSliceNumber();
		print(sliceN);
	selectWindow(AREAmask);
	run("Create Selection");
	run("Measure");
	roiManager("Add");
	run("Next Slice [>]");
	selectWindow(UV);
			sliceN2=getSliceNumber();
		print(sliceN2);
	roiManager("Select", 0);
	run("Measure");
	current=getValue("results.count")-1;
	mean1= getResult("Mean", current);
	Thr=mean1*1;
	setThreshold(Thr, 1e30);
	run("Measure");
	roiManager("reset");run("Set Scale...", "distance=0 known=0 unit=pixel");
	run("Next Slice [>]");
	resetThreshold();
	}
selectWindow(AREAmask);
setSlice(1);
selectWindow(GREEN);
setSlice(1);

	//Run analysis for 488 stack
	for (i = 0; i < nSlices; i++) {
	selectWindow(AREAmask);
	run("Create Selection");
	run("Measure");
	roiManager("Add");
	run("Next Slice [>]");
	selectWindow(GREEN);
	roiManager("Select", 0);
	run("Measure");
	current=getValue("results.count")-1;
	mean1= getResult("Mean", current);
	Thr=mean1*1;
	setThreshold(Thr, 1e30);
	run("Measure");
	roiManager("reset");
	run("Next Slice [>]");
	resetThreshold();
	}
	

	
	roiManager("reset");
//	run("Close");
