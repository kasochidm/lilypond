
%{

Look at ly/engraver.ly for inspiration on which basicXXXXProperties
there are.

Generally, you can find interesting element properties associated with
\property in scm/generic-property.scm. For example, this file contains

	(define generic-stem-properties
	  (cons 'stem-interface
		(list
		 (list 'stemVerticalDirection dir? 'direction)
		 (list 'verticalDirection dir? 'direction)	 
		 (list 'stemLength number? 'length)
		 (list 'flagStyle string? 'flag-style)
	)))


which means that setting \property stemVerticalDirection overrides
setting \property verticalDirection, and that both have the effect of
setting `direction' in Stem object. You can use \pushproperty for
setting stem directions by doing.


	\pushproperty #'(basicStemProperties) #'direction #1

(#-1 if you want down).  

A modest amount of memory is involved each time you do a
\pushproperty. If you do \popproperty in the right order (reversed
from \pushproperty), then \popproperty doesn't cost memory.

Correct:

	\pushproperty #'(  ... ) #'symbolA #valueA
	\pushproperty #'(  ... ) #'symbolB #valueB
	\popproperty #'(  ... ) #'symbolB 
	\popproperty #'(  ... ) #'symbolA 

Incorrect (\popproperty costs memory):

	\pushproperty #'(  ... ) #'symbolA #valueA
	\pushproperty #'(  ... ) #'symbolB #valueB
	\popproperty #'(  ... ) #'symbolA 
	\popproperty #'(  ... ) #'symbolB 

You can use identifiers, eg.

    slursUp = \context Voice \pushproperty '(basicSlurProperties)
	    #'direction  #1
    slursBoth = \context Voice \popproperty '(basicSlurProperties)

%}

\score { \notes
\relative c' {
	c4-.(
	\property Voice.basicDotsProperties \push #'direction =  #-1
	\property Voice.basicStemProperties \push #'direction =  #-1
	\property Voice.noteColumnProperties \push #'direction =  #-1
	\property Voice.basicStemProperties \push #'direction =  #-1		
	
	) c4-. (
	) c4-. (	
	 \property Voice.basicSlurProperties \push #'direction =  #-1
	) c4-. (

	\property basicDotsProperties \pop  #'direction
	\property basicStemProperties \pop #'direction
	\property basicScriptProperties \pop #'direction
	\property basicTextProperties \pop #'direction

	 ) c4-.  () c4-. 
}

\paper {
\translator { \VoiceContext
	basicNoteHeadProperties \push #'font-size =  #-2
}
}
}
