%% DO NOT EDIT this file manually; it is automatically
%% generated from Documentation/snippets/new
%% Make any changes in Documentation/snippets/new/
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
%% Note: this file works from version 2.19.16
\version "2.19.16"

\header {
  lsrtags = "rhythms"

  texidoc = "
New time signature styles can be defined.  The time signature in
the second measure should be upside down in both staves.
"

  doctitle = "User defined time signatures"
} % begin verbatim


#(add-simple-time-signature-style 'topsy-turvy
   (lambda (fraction)
     (make-rotate-markup 180 (make-compound-meter-markup fraction))))

<<
  \new Staff {
    \time 3/4 f'2.
    \override Score.TimeSignature.style = #'topsy-turvy
    \time 3/4 R2. \bar "|."
  }
  \new Staff {
    R2. e''
  }
>>
