%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.38"

\header {
  lsrtags = "expressive-marks, text"
 texidoc = "
Although the easiest way to add parentheses to a dynamic mark is to use
a @code{\\markup} block, this method has a downside: the created
objects will behave like text markups, and not like dynamics.

However, it is possible to create a similar object using the equivalent
Scheme code (as described in \"Markup programmer interface\"), combined
with the @code{make-dynamic-script} function. This way, the markup will
be regarded as a dynamic, and therefore will remain compatible with
commands such as @code{\\dynamicUp} or @code{\\dynamicDown}.


" }
% begin verbatim
\paper { ragged-right = ##t }

parenF = #(make-dynamic-script (markup #:line (#:normal-text #:italic
           #:fontsize 2 "(" #:hspace -0.8 #:dynamic "f" #:normal-text #:italic
           #:fontsize 2 ")"
          )))
{
  c''4\parenF c'' c'' \dynamicUp c''\parenF
}
