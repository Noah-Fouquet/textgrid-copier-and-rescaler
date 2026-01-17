# Purpose of the Script
Copy the tiers, boundaries, and labels from a reference TextGrid to new TextGrids in the TextGrid folder, automatically scaling the boundaries according to the duration of each recording present in the sound folder. This method only works when the stimulus is identical across all recordings in the experiment, such as a fixed read text or a set of sentences. This produces a rough automatic alignment that is not accurate and must be manually corrected. Its sole purpose is to provide a head start for later, precise manual alignment.

# Requirements
Here are the few requirements you will need to run the script seeamlessly:
- An annotated .TextGrid file in the root directory that will be taken as a reference to create the other TextGrid files
- A folder with the raw files
- An empty folder for the new .TextGrid

Be careful, do not put the reference TextGrid file in the TextGrid folder. The files in this folder are deleted each time you are running the script again to avoid conflict in the variables.

# License

See the [LICENSE](https://github.com/Noah-Fouquet/textgrid-copier-and-rescaler/blob/main/LICENSE) file for license rights and limitations.

# How to cite

Fouquet, N. (2025). copy-rescale_textgrid.praat (Version 1.0) [GitHub]. https://github.com/Noah-Fouquet/textgrid-copier-and-rescaler

