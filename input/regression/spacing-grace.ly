
\version "2.1.22"
\header {
  texidoc = "Grace note spacing. Should it be tuned? "
}
	
\score {
 \notes \context Voice \relative c'' { \grace {  c16[ d] } c4 }
  \paper { raggedright = ##t}

}

