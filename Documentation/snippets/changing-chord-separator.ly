%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
  lsrtags = "chords"

%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
Se puede establecer el separador entre las distintas partes del
nombre de un acorde para que sea cualquier elemento de marcado.

"
  doctitlees = "Modificación del separador de acordes"


%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
  texidocde = "
Der Trenner zwischen unterschiedlichen Teilen eines Akkordsymbols kann
beliebiger Text sein.

"
  doctitlede = "Akkordsymboltrenner verändern"

%% Translation of GIT committish: 3b125956b08d27ef39cd48bfa3a2f1e1bb2ae8b4
  texidocfr = "
Le séparateur de termes d'un chiffrage peut adopter n'importe quelle
forme à l'aide d'un @emph{markup}.

"
  doctitlefr = "Personnalisation du séparateur d'accords"

  texidoc = "
The separator between different parts of a chord name can be set to any
markup.

"
  doctitle = "Changing chord separator"
} % begin verbatim

\chords {
  c:7sus4
  \set chordNameSeparator
    = \markup { \typewriter | }
  c:7sus4
}

