# Bad Apple!! Synthesizer V Script
 A Synthesizer V script for showing the Bad Apple!! video (or anything that follows the format)
# How to use
 1. Clone the repository.
 2. Save a .svp in the repository.
 3. Add `badapple.lua` in your Synthesizer V Pro scripts folder (usually located in `Documents/Dreamtonics/scripts`)
 4. Put C4 at the bottom of the Piano Roll.
 5. Run the script.
# process_frames.py
 This was used to generate the frame data in the `lua_frames` folder. It requires `Pillow`, `numpy` and `tqdm` to run. It looks for a `frames` directory relative to the script filled with the frames of any video and converts it to the format that the script accepts. Do whatever you want with this.