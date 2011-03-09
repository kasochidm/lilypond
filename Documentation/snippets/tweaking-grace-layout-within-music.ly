%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.12.2"

\header {
  lsrtags = "rhythms, tweaks-and-overrides"

%% Translation of GIT committish: 91eeed36c877fe625d957437d22081721c8c6345
  texidoces = "

La disposición de las expresiones de adorno se puede cambiar a lo
largo de toda la música usando las funciones
@code{add-grace-property} y @code{remove-grace-property}.  El
ejemplo siguiente borra la definición de la dirección de la plica
para esta nota de adorno, de manera que las plicas no siemmpre
apuntan hacia arriba, y cambia la forma predeterminada de las
cabezas a aspas.

"

  doctitlees = "Trucar la disposición de las notas de adorno dentro de la música"



%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
  texidocde = "
Das Layout von Verzierungsausdrücken kann in der Musik verändert
werden mit den Funktionen @code{add-grace-property} und
@code{remove-grace-property}.  Das folgende Beispiel definiert
die Richtung von Hälsen (Stem) für diese Verzierung, sodass die
Hälse nicht immer nach unten zeigen, und ändert den Standardnotenkopf
in ein Kreuz.
"
  doctitlede = "Veränderung des Layouts von Verzierungen innerhalb der Noten"



%% Translation of GIT committish: 374d57cf9b68ddf32a95409ce08ba75816900f6b
  texidocfr = "
Il est possible de changer globalement la mise en forme des petites
notes dans un morceau, au moyen de la fonction
@code{add-grace-property}.  Ici, par exemple, on ôte la définition de
l'orientation des objets @code{Stem} pour toutes les petites notes,
afin que les hampes ne soient pas toujours orientées vers le haut, et on
leur préfère des têtes en forme de croix.

"
  doctitlefr = "Mise en forme des notes d'ornement"

  texidoc = "
The layout of grace expressions can be changed throughout the music
using the functions @code{add-grace-property} and
@code{remove-grace-property}. The following example undefines the
@code{Stem} direction for this grace, so that stems do not always point
up, and changes the default note heads to crosses.

"
  doctitle = "Tweaking grace layout within music"
} % begin verbatim

\relative c'' {
  \new Staff {
    #(remove-grace-property 'Voice 'Stem 'direction)
    #(add-grace-property 'Voice 'NoteHead 'style 'cross)
    \new Voice {
       \acciaccatura { f16 } g4
       \grace { d16[ e] } f4
       \appoggiatura { f,32[ g a] } e2
    }
  }
}
