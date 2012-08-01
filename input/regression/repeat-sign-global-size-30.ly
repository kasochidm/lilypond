\version "2.17.5"
\header {
  texidoc = "The two dots of a repeat sign should be symmetric
to the staff centre and avoid staff lines even for exotic staves.
Test set-global-staff size 30 (with layout-set-staff-size)."
}

#(set-global-staff-size 30)

\score {
  <<
    \context Staff = "s1" \with {
      \override StaffSymbol #'staff-space = #0.5
    } {
      s1 \bar ":|."
    }

    \context Staff = "s2" \with {
      \override StaffSymbol #'staff-space = #0.6
      \override StaffSymbol #'line-positions = #'(-4 -2 0 2)
    } {
      s1 \bar ":|."
    }

    \context Staff = "s3" {
      s1 \bar ":|."
    }
  >>
}

\score {
  <<
    \context Staff = "s1" {
      s1 \bar ":|."
    }

    \context Staff = "s2" \with {
      \override StaffSymbol #'staff-space = #0.33
    } {
      s1 \bar ":|."
    }

    \context Staff = "s3" \with {
      \override StaffSymbol #'staff-space = #0.33
      \override StaffSymbol #'line-positions = #'(-4 -2 0 2)
    } {
      s1 \bar ":|."
    }
  >>

  \layout {
    #(layout-set-staff-size 10)
  }
}
