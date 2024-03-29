### Convert Praat TextGrid to .stm file which can be used in Transcriber and saved as a .trs
### Written by James Turner. Date of Completion: 30/05/2019.
### Move all your TextGrids you desire to be converted into a single folder
### The Time Stamp measurements used for the .stm file will be taken from the first tier of the TextGrid (default)
### The name of the .stm files will match your original TextGrid names
### All .stm files will be found in the same directory as your TextGrids (you may launch this script from any directory)


procedure action
	text$ = selected$("TextGrid")

	## Chop off the ".TextGrid" extension
	name$ = text$ - ".TextGrid"
	
	## Print file name to Praat Info Window
	printline 'name$'
	printline

	## Save the .stm output file as the same name as your TextGrid	
	output_file$="'name$'.stm"

	## This double checks you're not overwriting a .stm file that already exists with the same name in your directory
	if fileReadable(output_file$)
		pause File 'output_file$' exists already!  Do you want to overwrite it?
	endif
	filedelete 'output_file$'

	## Create .trs header: The following lines will be added to the start of your .stm file so that it can be opened in Transcriber
	fileappend "'output_file$'" ;; Transcriber export by stm.tcl,v 1.19 on Thu May 30 22:45:42 GMT Daylight Time 2019 with encoding ISO-8859-1'newline$'
	fileappend "'output_file$'" ;; transcribed by Anon, version 1 of 190530'newline$'
	fileappend "'output_file$'" ;;'newline$'
	fileappend "'output_file$'" ;; CATEGORY "0" "" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "O" "Overall" "Overall"'newline$'
	fileappend "'output_file$'" ;;'newline$'
	fileappend "'output_file$'" ;; CATEGORY "1" "Hub4 Focus Conditions" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "F0" "Baseline//Broadcast//Speech" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "F1" "Spontaneous//Broadcast//Speech" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "F2" "Speech Over//Telephone//Channels" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "F3" "Speech in the//Presence of//Background Music" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "F4" "Speech Under//Degraded//Acoustic Conditions" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "F5" "Speech from//Non-Native//Speakers" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "FX" "All other speech" ""'newline$'
	fileappend "'output_file$'" ;; CATEGORY "2" "Speaker Sex" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "female" "Female" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "male"   "Male" ""'newline$'
	fileappend "'output_file$'" ;; LABEL "unknown"   "Unknown" ""'newline$'
	
	## Open the TextGrid for the given stage of the loop
	select TextGrid 'name$'

	## Find number of intervals in the first tier of the TextGrid
	intN = Get number of intervals... 1
	
	## Loop through every interval in the first tier of that TextGrid
	for int from 1 to intN
		
		## Get the start time of that interval
		t1 = Get start time of interval... 1 int
		
		## Get the end time of that interval
		t2 = Get end time of interval... 1 int
		
		## Get the label of that interval
		label$ = Get label of interval... 1 int
		
		## Add this information to the Output .stm File
		if int <> intN
			fileappend "'output_file$'"	Speaker 1 inter_segment_gap 't1' 't2' <o,f0,> 'label$''newline$'
		else
			fileappend "'output_file$'"	Speaker 1 inter_segment_gap 't1' 't2' <o,f0,> 'label$'
		endif
	
	## Ends loop through intervals for a given TextGrid
	endfor
	
	## Removes Each TextGrid from Praat after .stm file is made 
	#select TextGrid 'name$'
	#Remove

endproc

## Ends loop through TextGrids in directory	
#endfor

## Removes the list of file names from Praat Console
#select Strings mytextfiles
#Remove


n_batch = numberOfSelected("TextGrid")
for i_batch to n_batch
	bsel'i_batch' = selected("TextGrid", i_batch)
endfor
for i_batch to n_batch
	select bsel'i_batch'
	call action
	new_batch'i_batch' = selected()
endfor
if n_batch >= 1
	select new_batch1
	for i_batch from 2 to n_batch
		plus new_batch'i_batch'
	endfor
endif

printline All TextGrids Successfully Converted to .stm Format!