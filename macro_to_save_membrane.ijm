//CONVERT T WITH Z BEFORE RUNNING
//Ask user to select the image file
filePath = File.openDialog("Choose a T-series image");
if (filePath == "") {
    exit("No file selected. Exiting.");
}

// Open the selected image
open(filePath);
origTitle = getTitle();

// Get image properties correctly
getDimensions(width, height, channels, slices, frames);
print("Width: " + width + ", Height: " + height + ", Channels: " + channels + ", Z Slices: " + slices + ", Frames: " + frames);

if (channels != 2) {
    exit("Error: This macro is designed for two-channel images.");
}

// Convert stack to hyperstack (if needed)
if (frames == 1 && slices > 1) {
    print("Converting stack to hyperstack...");
    run("Stack to Hyperstack...", "order=xyczt channels=2 slices=1 frames=" + slices + " display=Color");
    getDimensions(width, height, channels, slices, frames); // Update frame count
    print("New frames count: " + frames);
}

// Set output directory (hardcoded path)
outputDir = "H:/PROJECTS-03/Agnese/20241127_cdh2xh2b_modERK_PD17/20241127_154242_Experiment/1gg/trial_mem/mem/";
print("Saving images to: " + outputDir);

// Process each time point
for (t = 1; t <= frames; t++) {
    print("Processing frame " + t + "/" + frames);
    
    // Extract just the current time point, keeping both channels
    run("Make Substack...", "frames=" + t + " channels=1-" + channels);
    
    // Save as a new image
    saveAs("Tiff", outputDir + "mem" + t-1 + ".tif");
    
    // Close temporary image
    close();
}

print("Processing complete. Images saved in: " + outputDir);