
\header { texidoc = " Staves starting and ending halfway include clefs
    and bar lines.  " }

\score {
    \new StaffGroup \notes \relative c''  <<
	\new Staff { c4  c c c \bar "||" c c c c }
	{ \skip 4 \new Staff { c c c } }
    >>
	\paper {}	       
	 }
