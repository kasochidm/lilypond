;;; midi.scm -- scm midi variables and functions
;;;
;;;  source file of the GNU LilyPond music typesetter
;;; 
;;; (c)  2000--2003 Jan Nieuwenhuizen <janneke@gnu.org>



;;;;;;;;;;;;;;;;;;
;;; TODO:

;; this is broken: we should not ever export variables from Scheme.

;; define factor of total volume per dynamic marking
(define-public absolute-volume-alist '())
(set! absolute-volume-alist
      (append 
      '(
	("sf" . 1.00)
	("fffff" . 0.95)
	("ffff" . 0.91)
	("fff" . 0.81)
	("ff" . 0.71)
	("f" . 0.61)
	("mf" . 0.50)
	("mp" . 0.40)
	("p" . 0.30)
	("pp" . 0.20)
	("ppp" . 0.10)
	("pppp" . 0.08)
	("ppppp" . 0.05)
	)
      absolute-volume-alist))

(define-public (default-dynamic-absolute-volume s)
  (let ((entry (assoc s absolute-volume-alist)))
    (if entry
	(cdr entry))))

;; define factors of total volume of minimum and maximum volume
(define-public instrument-equalizer-alist '())
(set! instrument-equalizer-alist
      (append 
       '(
	 ("flute" . (0 . 0.7))
	 ("oboe" . (0 . 0.7))
	 ("clarinet" . (0 . 0.7))
	 ("bassoon" . (0 . 0.6))
	 ("french horn" . (0.1 . 0.7))
	 ("trumpet" . (0.1 . 0.8))
	 ("timpani" . (0.2 . 0.9))
	 ("violin" . (0.2 . 1.0))
	 ("viola" . (0.1 . 0.7))
	 ("cello" . (0.2 . 0.8))
	 ("contrabass" . (0.2 . 0.8))
	 )
       instrument-equalizer-alist))

;; (name . program+32768*(channel10 ? 1 : 0) )
(define instrument-names-alist '())
(set! instrument-names-alist
      (append
       `(
          ("acoustic grand" . ,(- 1 1))
	  ("bright acoustic" . ,(- 2 1))
	  ("electric grand" . ,(- 3 1))
	  ("honky-tonk" . ,(- 4 1))
	  ("electric piano 1" . ,(- 5 1))
	  ("electric piano 2" . ,(- 6 1))
	  ("harpsichord" . ,(- 7 1))
	  ("clav" . ,(- 8 1))

	  ; (9-16 chrom percussion)
	  ("celesta" . ,(- 9 1))
	  ("glockenspiel" . ,(- 10 1))
	  ("music box" . ,(- 11 1))
	  ("vibraphone" . ,(- 12 1))
	  ("marimba" . ,(- 13 1))
	  ("xylophone" . ,(- 14 1))
	  ("tubular bells" . ,(- 15 1))
	  ("dulcimer" . ,(- 16 1))

	  ; (17-24 organ)
	  ("drawbar organ" . ,(- 17 1))
	  ("percussive organ" . ,(- 18 1))
	  ("rock organ" . ,(- 19 1))
	  ("church organ" . ,(- 20 1))
	  ("reed organ" . ,(- 21 1))
	  ("accordion" . ,(- 22 1))
	  ("harmonica" . ,(- 23 1))
	  ("concertina" . ,(- 24 1))

	  ; (25-32 guitar)
	  ("acoustic guitar (nylon)" . ,(- 25 1))
	  ("acoustic guitar (steel)" . ,(- 26 1))
	  ("electric guitar (jazz)" . ,(- 27 1))
	  ("electric guitar (clean)" . ,(- 28 1))
	  ("electric guitar (muted)" . ,(- 29 1))
	  ("overdriven guitar" . ,(- 30 1))
	  ("distorted guitar" . ,(- 31 1))
	  ("guitar harmo(dinics" . ,(- 32 1))

	  ; (33-40 bass)
	  ("acoustic bass" . ,(- 33 1))
	  ("electric bass (finger)" . ,(- 34 1))
	  ("electric bass (pick)" . ,(- 35 1))
	  ("fretless bass" . ,(- 36 1))
	  ("slap bass 1" . ,(- 37 1))
	  ("slap bass 2" . ,(- 38 1))
	  ("synth bass 1" . ,(- 39 1))
	  ("synth bass 2" . ,(- 40 1))

	  ; (41-48 strings)
	  ("violin" . ,(- 41 1))
	  ("viola" . ,(- 42 1))
	  ("cello" . ,(- 43 1))
	  ("contrabass" . ,(- 44 1))
	  ("tremolo strings" . ,(- 45 1))
	  ("pizzicato strings" . ,(- 46 1))
	  ("orchestral strings" . ,(- 47 1))
	  ("timpani" . ,(- 48 1))

	  ; (49-56 ensemble)
	  ("string ensemble 1" . ,(- 49 1))
	  ("string ensemble 2" . ,(- 50 1))
	  ("synthstrings 1" . ,(- 51 1))
	  ("synthstrings 2" . ,(- 52 1))
	  ("choir aahs" . ,(- 53 1))
	  ("voice oohs" . ,(- 54 1))
	  ("synth voice" . ,(- 55 1))
	  ("orchestra hit" . ,(- 56 1))

	  ; (57-64 brass)
	  ("trumpet" . ,(- 57 1))
	  ("trombone" . ,(- 58 1))
	  ("tuba" . ,(- 59 1))
	  ("muted trumpet" . ,(- 60 1))
	  ("french horn" . ,(- 61 1))
	  ("brass section" . ,(- 62 1))
	  ("synthbrass 1" . ,(- 63 1))
	  ("synthbrass 2" . ,(- 64 1))

	  ; (65-72 reed)
	  ("soprano sax" . ,(- 65 1))
	  ("alto sax" . ,(- 66 1))
	  ("tenor sax" . ,(- 67 1))
	  ("baritone sax" . ,(- 68 1))
	  ("oboe" . ,(- 69 1))
	  ("english horn" . ,(- 70 1))
	  ("bassoon" . ,(- 71 1))
	  ("clarinet" . ,(- 72 1))

	  ; (73-80 pipe)
	  ("piccolo" . ,(- 73 1))
	  ("flute" . ,(- 74 1))
	  ("recorder" . ,(- 75 1))
	  ("pan flute" . ,(- 76 1))
	  ("blown bottle" . ,(- 77 1))
	  ("shakuhachi" . ,(- 78 1))
	  ("whistle" . ,(- 79 1))
	  ("ocarina" . ,(- 80 1))

	  ; (81-88 synth lead)
	  ("lead 1 (square)" . ,(- 81 1))
	  ("lead 2 (sawtooth)" . ,(- 82 1))
	  ("lead 3 (calliope)" . ,(- 83 1))
	  ("lead 4 (chiff)" . ,(- 84 1))
	  ("lead 5 (charang)" . ,(- 85 1))
	  ("lead 6 (voice)" . ,(- 86 1))
	  ("lead 7 (fifths)" . ,(- 87 1))
	  ("lead 8 (bass+lead)" . ,(- 88 1))

	  ; (89-96 synth pad)
	  ("pad 1 (new age)" . ,(- 89 1))
	  ("pad 2 (warm)" . ,(- 90 1))
	  ("pad 3 (polysynth)" . ,(- 91 1))
	  ("pad 4 (choir)" . ,(- 92 1))
	  ("pad 5 (bowed)" . ,(- 93 1))
	  ("pad 6 (metallic)" . ,(- 94 1))
	  ("pad 7 (halo)" . ,(- 95 1))
	  ("pad 8 (sweep)" . ,(- 96 1))

	  ; (97-104 synth effects)
	  ("fx 1 (rain)" . ,(- 97 1))
	  ("fx 2 (soundtrack)" . ,(- 98 1))
	  ("fx 3 (crystal)" . ,(- 99 1))
	  ("fx 4 (atmosphere)" . ,(- 100 1))
	  ("fx 5 (brightness)" . ,(- 101 1))
	  ("fx 6 (goblins)" . ,(- 102 1))
	  ("fx 7 (echoes)" . ,(- 103 1))
	  ("fx 8 (sci-fi)" . ,(- 104 1))

	  ; (105-112 ethnic)
	  ("sitar" . ,(- 105 1))
	  ("banjo" . ,(- 106 1))
	  ("shamisen" . ,(- 107 1))
	  ("koto" . ,(- 108 1))
	  ("kalimba" . ,(- 109 1))
	  ("bagpipe" . ,(- 110 1))
	  ("fiddle" . ,(- 111 1))
	  ("shanai" . ,(- 112 1))

	  ; (113-120 percussive)
	  ("tinkle bell" . ,(- 113 1))
	  ("agogo" . ,(- 114 1))
	  ("steel drums" . ,(- 115 1))
	  ("woodblock" . ,(- 116 1))
	  ("taiko drum" . ,(- 117 1))
	  ("melodic tom" . ,(- 118 1))
	  ("synth drum" . ,(- 119 1))
	  ("reverse cymbal" . ,(- 120 1))

	  ; (121-128 sound effects)
	  ("guitar fret noise" . ,(- 121 1))
	  ("breath noise" . ,(- 122 1))
	  ("seashore" . ,(- 123 1))
	  ("bird tweet" . ,(- 124 1))
	  ("telephone ring" . ,(- 125 1))
	  ("helicopter" . ,(- 126 1))
	  ("applause" . ,(- 127 1))
	  ("gunshot" . ,(- 128 1))

	  ; (channel 10 drum-kits - subtract 32768 to get program no.)
	  ("standard kit" .     ,(+ 32768 0))
	  ("standard drums" .   ,(+ 32768 0))
	  ("drums" .            ,(+ 32768 0))
	  ("room kit" .         ,(+ 32768 8))
	  ("room drums" .       ,(+ 32768 8))
	  ("power kit" .        ,(+ 32768 16))
	  ("power drums" .      ,(+ 32768 16))
	  ("rock drums" .       ,(+ 32768 16))
	  ("electronic kit" .   ,(+ 32768 24))
	  ("electronic drums" . ,(+ 32768 24))
	  ("tr-808 kit" .       ,(+ 32768 25))
	  ("tr-808 drums" .     ,(+ 32768 25))
	  ("jazz kit" .         ,(+ 32768 32))
	  ("jazz drums" .       ,(+ 32768 32))
	  ("brush kit" .        ,(+ 32768 40))
	  ("brush drums" .      ,(+ 32768 40))
	  ("orchestra kit" .    ,(+ 32768 48))
	  ("orchestra drums" .  ,(+ 32768 48))
	  ("classical drums" .  ,(+ 32768 48))
	  ("sfx kit" .          ,(+ 32768 56))
	  ("sfx drums" .        ,(+ 32768 56))
	  ("mt-32 kit" .        ,(+ 32768 127))
	  ("mt-32 drums" .      ,(+ 32768 127))
	  ("cm-64 kit" .        ,(+ 32768 127))
	  ("cm-64 drums" .      ,(+ 32768 127))
	)
        instrument-names-alist
      )
)


(define-public (default-instrument-equalizer s)
  (let ((entry (assoc s instrument-equalizer-alist)))
    (if entry
	(cdr entry))))


(define-public (percussion? instrument)
  "
returns whether the instrument should use midi channel 9
"
  (let* ((inst  (symbol->string instrument))
         (entry (assoc inst instrument-names-alist))
	)
     (and entry (>= (cdr entry) 32768))
  ))

(define-public (midi-program instrument)
"
returns the program of the instrument
"
  (let* ((inst  (symbol->string instrument))
         (entry (assoc inst instrument-names-alist))
	)
    (if entry (modulo (cdr entry) 32768) #f )
  )
)

;; 90 == 90/127 == 0.71 is supposed to be the default value
;; urg: we should set this at start of track
(define-public dynamic-default-volume 0.71)

(define-public (accidentals-in-key pitch-list)
  "Count number of sharps minus number of flats"
  (apply + (map cdr pitch-list)))
