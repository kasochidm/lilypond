
\header {
texidoc = "Ambituses can be switched off or translated by using
applyoutput.

If you want to mix per-voice and per-staff ambituses, then you have to
define you have to declare a new context type derived from the
@code{Voice} context or @code{Staff} context.  The derived context
must consist of the @code{Ambitus_engraver} and it must be accepted by
a proper parent context, in the below example the @code{Staff} context
or @code{Score} context, respectively.  The original context and the
derived context can then be used in parallel in the same score. (this is not demonstrated in this file).
"
}

\version "1.9.6"

#(define (kill-ambitus grob grob-context apply-context)
  (if (memq 'ambitus-interface (ly:get-grob-property grob 'interfaces))
   (ly:grob-suicide grob)
  ))

#(define ((shift-ambitus x) grob grob-context apply-context)
  (if (memq 'ambitus-interface (ly:get-grob-property grob 'interfaces))
   (ly:grob-translate-axis! grob x X)
  ))



voiceA = \notes \relative c'' {
  c4 a d e f2
}
voiceB = \notes \relative c' {
  es4 f g as b2 
}
\score {
  \context ChoirStaff <<
    \new Staff <<
	{
	   \applyoutput  #(shift-ambitus 1.0)
	    \voiceA
	   } \\
       {
	   \voiceB
       }
    >>
    \new Staff <<
       {  \applyoutput #kill-ambitus \voiceA } \\
       {  \applyoutput #kill-ambitus \voiceB }
    >>
  >>
  \paper {
    raggedright = ##t

    \translator {
	\VoiceContext
      \consists Ambitus_engraver
    }
    }
}
