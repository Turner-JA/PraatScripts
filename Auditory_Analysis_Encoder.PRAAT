## This Praat script goes through TextGrids with an orthographic transcription
## and allows you to view all occurences of a chosen string of characters (e.g. ing, t, l etc.)

## written by James Turner
## last modified Feb 2021

## HOW TO USE THIS SCRIPT
## 1. Your data files (TextGrid orthographic transcription and sound file) into a folder somewhere on your computer
## 2. Open your TextGrid orthographic transcription in Praat using Read from file...
## 3. Open your sound file as a LongSound (not using the read from file option)
## 4. Open this script in Praat
## 5. Select your TextGrid and your LongSound File and Run this script

## WHAT THIS SCRIPT DOES
## The script will cycle through the orthographic transcription searching for the required character(s) specified by the user

############################################################################

## get info about the character(s) that are to be searched
form Search for a character
	comment Insert letter(s) that you wish to search for
	sentence Search_Segments ing
	comment Insert name under which you wish to save your annotations
	sentence SaveName Auditory_Variable_Guise.TextGrid
endform

clearinfo

## This double checks you're not overwriting a .stm file that already exists with the same name in your directory
	if fileReadable(saveName$)
		pause File 'saveName$' exists already!  Do you want to overwrite it?
	endif
	filedelete 'saveName$'
clearinfo

###### save final seg from written bit 
## this gets number of characters in the user's written bit
length = length(search_Segments$)
## find final comma in the user's written bit
finalcomma = rindex(search_Segments$, ",")
## find index of final segment
finalsegindex=length-finalcomma

## extract final segment
finalseg$ = right$(search_Segments$, finalsegindex)
finalseg$ = replace$(finalseg$, " ", "", 0)

printline finalseg$ = "'finalseg$'"

###### get preceding segments now

## save the original 
search_Segmentsorig$ = search_Segments$

segCount=1

if index (search_Segments$, ",") != 0

	## cycle through the first index up to the final comma
	for i from 1 to finalcomma+1
		segCount=segCount+1
		## find 2nd to last comma of original user's written bit
		commaplace = index (search_Segments$, ",")
		## get segment to left of last comma then remove any excess white space
		seg'i'$= left$ (search_Segments$, commaplace-1)
		seg'i'$= replace$(seg'i'$, " ", "", 0)

		test$=seg'i'$
		printline seg'i'= "'test$'"
		pause

		## replace the user's written bit 
		search_Segments$ = replace$(search_Segments$, seg'i'$, "", 0)
		search_Segments$ = replace$(search_Segments$, ",", "", 1)
			if index (search_Segments$, ",") == 0
				i=finalcomma+1
			endif
	endfor
else
endif

seg'segCount'$=finalseg$

for y from 1 to segCount
upper'y'=segCount+y
blah=upper'y'

seg'blah'$=replace_regex$(seg'y'$, "(.*)", "\U\1", 0)
endfor

#printline segCount = 'segCount'
#printline finalseg$ = 'finalseg$'
#printline seg1$ = 'seg1$'
#printline seg2$ = 'seg2$'
#printline seg3$ = 'seg3$'
#printline seg4$ = 'seg4$'
#printline seg5$ = 'seg5$'
#printline seg6$ = 'seg6$'
#printline seg7$ = 'seg7$'

#pause

############################################################## all segs saved as seg1 to segn ###################################################


## go through the selected files
tg$ = selected$("TextGrid")
sound$ = selected$("LongSound")
name$ = sound$ - ".wav"

## prompt the user which tiers contain the phones for the speaker(s) they are interested in 
select TextGrid 'tg$'

## get number of intervals on the transcription tier
ninterval = Get number of intervals... 1

## go through every interval on the transcription tier
for iinterval from 1 to ninterval
	
	select TextGrid 'tg$'
	label$ = Get label of interval... 1 iinterval
	clearinfo


for segNos from 1 to segCount
	
	testlabel$=label$
	nletters=length(label$)
	noOfsegs = 0

	## continue if segment is within the label somewhere
	if index_regex (testlabel$, seg'segNos'$) > 0
	
		## cycle through the number of letters in each interval
		for characters from 1 to nletters
		
		## where does the letter occur for the first time within the string of a given interval
		segindex = index_regex (testlabel$, seg'segNos'$)
		
		#printline segindex1 = 'segindex'
		#printline testlabel$1 = "'testlabel$'"
		#pause
		
		## save the shorter string by removing the first section
		testlabel$=right$(testlabel$, length(testlabel$)-segindex)
		
		## where does the letter occur within the rest of the string
		lastround = index_regex (testlabel$, seg'segNos'$)
		
		if lastround == 0
			characters=nletters	
		endif
		
		noOfsegs = noOfsegs+1
		endfor
		
		toprint$=seg'segNos'$
		printline Number of the following segment: "'toprint$'" within the current string is 'noOfsegs'
	
		for viewsegs from 1 to noOfsegs
			
			toprint$=seg'segNos'$
			s$ = replace$ (label$, toprint$, "('toprint$')", viewsegs)
			
			printline 's$'
		
			select TextGrid 'tg$'
			time1 = Get starting point... 1 iinterval	
 			time2 = Get end point... 1 iinterval
				
				select TextGrid 'tg$'
				plus LongSound 'sound$'
					Edit
					editor TextGrid 'tg$'
						Select... time1 time2
						#Move cursor to... time1+time2/2
						Zoom... time1 time2
						pause
						Close
					endeditor
		endfor
		select TextGrid 'tg$'
		Save as text file... 'saveName$'
	endif	
endfor


		## iteration over intervals on phone tier
endfor

printline
printline All specified letters have been analysed!
