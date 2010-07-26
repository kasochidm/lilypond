%% Do not edit this file; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.13.29"

\header {
  lsrtags = "rhythms"

%% Translation of GIT committish: 0b55335aeca1de539bf1125b717e0c21bb6fa31b
  texidoces = "

Es posible aplicar la barrita que cruza la barra de las
acciaccaturas, en otras situaciones.

"

  doctitlees = "Utilizar la barra que tacha las notas de adorno con notas normales"


%% Translation of GIT committish: 374d57cf9b68ddf32a95409ce08ba75816900f6b
  texidocfr = "
Le trait que l'on trouve sur les hampes des acciaccatures peut
être appliqué dans d'autres situations.

"

  doctitlefr = "Utilisation de hampe barrée pour une note normale"

  texidoc = "
The slash through the stem found in acciaccaturas can be applied in
other situations.

"
  doctitle = "Using grace note slashes with normal heads"
} % begin verbatim

\relative c'' {
  \override Stem #'stroke-style = #"grace"
  c8( d2) e8( f4)
}

