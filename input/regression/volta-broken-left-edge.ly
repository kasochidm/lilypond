\version "2.1.22"

\header {
texidoc ="Broken volta spanners behave correctly at their left edge in all cases."

}

%{


I recently discovered that although the following patch seemed to fix
the original complaint that it causes other problems (the following
tests were done in 1.3.116.

I have attached a file which has several break-volta interactions.

With the test file and unmodified 1.3.116 I see the following:

Bar 3 - 1st volta spanner centered on first note - prefer it to start
	closer to key signature (can live with this)
Bar 6 - 1st volta continuation - perfect
Bar 9 - 2nd volta spanner starts on left edge of key signature - prefer
	it to start right of key signature
Bar 12 	1st volta starts between first two slurred notes in measure -
	this is not acceptable
Bar 17	like above with hairpin.
Bar 23	like above (I had expected this to be OK)
Bar 20	2nd volta continuation perfect

With the test file and 1.3.116 modified as below I see the following:

Bar 3	Perfect
Bar 6	1st volta continuation starts with staff - oops
Bar 9  	2nd volta starts on papers left margin - OOPS!
Bar 12	Perfect
Bar 17 	Perfect
Bar 20	2nd volta continuation starts with staff - oops
Bar 23	Perfect

%}

voiceB = \notes {
    \clef bass
     \set Staff.instrument = "Bass"
     \set Staff.instr = "B"
     \key f \minor 
     \time 4/4  
    f1
    \repeat  volta 2
    {
        f1    \break
    }
    \alternative
    {
        { 	
	  f1 f g \break   
	  f e d  \break   
	}
        {   
	    f1      | 
	}
    }
}
voiceC = \notes {
    \repeat volta 2
    {
f f 
     \break
    }
    \alternative
    {
        f
        { f f }
    }
}

voiceD = \notes {
    \repeat volta 2
    {
f f 
     \break
    }
    \alternative
    {
        {	f
	}
        {	f f \break f 
        }
    }
}
voiceE = \notes {
    \repeat volta 2
    {
f f\break
    }
    \alternative
    {
        {	
	 f

	}
        {	
	  f f 
        }
    }
}
\score{
        \notes <<


	\new Staff
	{
	    \voiceB 
	    \voiceC
	    \break
	    \voiceD
	    \voiceE
	}

    >>
	\paper { raggedright =##t }
}

