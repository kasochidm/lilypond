%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.12.2"

\header {
  lsrtags = "expressive-marks, text"

%% Translation of GIT committish: 91eeed36c877fe625d957437d22081721c8c6345
  texidoces = "
Este ejemplo proporciona una función para tipografiar un regulador con
texto por debajo, como @qq{molto} o @qq{poco}. El ejemplo ilustra
también cómo modificar la manera en que se imprime normalmente un
objeto, utilizando código de Scheme.

"
  doctitlees = "Centrar texto debajo de un regulador"

  texidoc = "
This example provides a function to typeset a hairpin (de)crescendo
with some additional text below it, such as @qq{molto} or @qq{poco}.
The example also illustrates how to modify the way an object is
normally printed, using some Scheme code.

"
  doctitle = "Center text below hairpin dynamics"
} % begin verbatim

hairpinWithCenteredText =
#(define-music-function (parser location text) (markup?)
#{
  \override Voice.Hairpin #'stencil = #(lambda (grob)
    (ly:stencil-aligned-to
     (ly:stencil-combine-at-edge
      (ly:stencil-aligned-to (ly:hairpin::print grob) X CENTER)
      Y DOWN
      (ly:stencil-aligned-to (grob-interpret-markup grob $text) X CENTER))
     X LEFT))
#})

hairpinMolto = \hairpinWithCenteredText \markup { \italic molto }
hairpinMore = \hairpinWithCenteredText \markup { \larger moltissimo }

\layout { ragged-right = ##f }

\relative c' {
  \hairpinMolto
  c2\< c\f
  \hairpinMore
  c2\< c\f
}
