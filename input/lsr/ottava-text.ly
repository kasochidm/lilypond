%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.38"

\header {
  lsrtags = "pitches, text"
 texidoc = "
Internally, the @code{set-octavation} function sets the properties
@code{ottavation} (for example, to @code{\"8va\"} or @code{\"8vb\"})
and @code{middleCPosition}. To override the text of the bracket, set
@code{ottavation} after invoking @code{set-octavation}.


" }
% begin verbatim
{
  #(set-octavation 1)
  \set Staff.ottavation = #"8"
  c''1
  #(set-octavation 0)
  c'1
  #(set-octavation 1)
  \set Staff.ottavation = #"Text"
  c''1
}
