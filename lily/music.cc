/*
  music.cc -- implement Music

  source file of the GNU LilyPond music typesetter

  (c) 1997--2004 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "music.hh"

#include "duration.hh"
#include "input-smob.hh"
#include "ly-smobs.icc"
#include "main.hh"
#include "music-list.hh"
#include "pitch.hh"
#include "score.hh"
#include "warn.hh"

bool
Music::internal_is_music_type (SCM k) const
{
  SCM ifs = get_property ("types");

  return scm_c_memq (k, ifs) != SCM_BOOL_F;
}

String
Music::name () const
{
  SCM nm = get_property ("name");
  if (scm_is_symbol (nm))
    {
      return ly_symbol2string (nm);
    }
  else
    {
      return classname (this);
    }
}

Music::Music (SCM init)
{
  self_scm_ = SCM_EOL;
  immutable_property_alist_ = init;
  mutable_property_alist_ = SCM_EOL;
  smobify_self ();

  length_callback_ = get_property ("length-callback");
  start_callback_ = get_property ("start-callback");
}

Music::Music (Music const &m)
{
  immutable_property_alist_ = m.immutable_property_alist_;
  mutable_property_alist_ = SCM_EOL;
  self_scm_ = SCM_EOL;

  /* First we smobify_self, then we copy over the stuff.  If we don't,
     stack vars that hold the copy might be optimized away, meaning
     that they won't be protected from GC. */
  smobify_self ();
  mutable_property_alist_ = ly_music_deep_copy (m.mutable_property_alist_);
  length_callback_ = m.length_callback_;
  start_callback_ = m.start_callback_;
  set_spot (*m.origin ());
}

Music::~Music ()
{
}

ADD_MUSIC (Music);

SCM
Music::get_property_alist (bool m) const
{
  return (m) ? mutable_property_alist_ : immutable_property_alist_;
}

SCM
Music::mark_smob (SCM m)
{
  Music *mus = (Music*) SCM_CELL_WORD_1 (m);
  scm_gc_mark (mus->immutable_property_alist_);
  scm_gc_mark (mus->mutable_property_alist_);
  return SCM_EOL;
}

Moment
Music::get_length () const
{
  SCM lst = get_property ("length");
  if (unsmob_moment (lst))
    return *unsmob_moment (lst);

  if (ly_c_procedure_p (length_callback_))
    {
      SCM res = scm_call_1 (length_callback_, self_scm ());
      return *unsmob_moment (res);
    }

  return Moment(0);
}

Moment
Music::start_mom () const
{
  SCM lst = get_property ("start-callback");
  if (ly_c_procedure_p (lst))
    {
      SCM res = scm_call_1 (lst, self_scm ());
      return *unsmob_moment (res);
    }

  Moment m;
  return m;
}

void
print_alist (SCM a, SCM port)
{
  /* SCM_EOL  -> catch malformed lists.  */
  for (SCM s = a; scm_is_pair (s); s = scm_cdr (s))
    {
      scm_display (scm_caar (s), port);
      scm_puts (" = ", port);
      scm_write (scm_cdar (s), port);
      scm_puts ("\n", port);
    }
}

int
Music::print_smob (SCM s, SCM p, scm_print_state*)
{
  scm_puts ("#<Music ", p);
  Music* m = unsmob_music (s);

  SCM nm = m->get_property ("name");
  if (scm_is_symbol (nm) || scm_is_string (nm))
    scm_display (nm, p);
  else
    scm_puts (classname (m),p);

  /* Printing properties takes a lot of time, especially during backtraces.
     For inspecting, it is better to explicitly use an inspection
     function.  */

  scm_puts (">",p);
  return 1;
}

Pitch
Music::to_relative_octave (Pitch p)
{
  SCM elt = get_property ("element");

  if (Music *m = unsmob_music (elt))
    p = m->to_relative_octave (p);

  p = music_list_to_relative (get_property ("elements"), p, false);
  return p;
}

void
Music::compress (Moment factor)
{
  SCM elt = get_property ("element");

  if (Music *m = unsmob_music (elt))
    m->compress (factor);

  compress_music_list (get_property ("elements"), factor);
  Duration *d =  unsmob_duration (get_property ("duration"));
  if (d)
    set_property ("duration", d ->compressed (factor.main_part_).smobbed_copy ());
}

void
Music::transpose (Pitch delta)
{
  if (to_boolean (get_property ("untransposable")))
    return ;
  
  for (SCM s = this->get_property_alist (true); scm_is_pair (s); s = scm_cdr (s))
    {
      SCM entry = scm_car (s);
      SCM val = scm_cdr (entry);

      if (Pitch * p = unsmob_pitch (val))
	{
	  Pitch transposed =  p->transposed (delta);
	  scm_set_cdr_x (entry, transposed.smobbed_copy ());

	  if (abs (transposed.get_alteration ()) > DOUBLE_SHARP)
	    {
	      warning (_f ("Transposition by %s makes alteration larger than double",
			   delta.to_string ()));
	    }
	}
    }
 
  SCM elt = get_property ("element");

  if (Music* m = unsmob_music (elt))
    m->transpose (delta);

  transpose_music_list (get_property ("elements"), delta);
}

IMPLEMENT_TYPE_P (Music, "ly:music?");
IMPLEMENT_SMOBS (Music);
IMPLEMENT_DEFAULT_EQUAL_P (Music);

SCM
Music::internal_get_property (SCM sym) const
{
  SCM s = scm_sloppy_assq (sym, mutable_property_alist_);
  if (s != SCM_BOOL_F)
    return scm_cdr (s);

  s = scm_sloppy_assq (sym, immutable_property_alist_);
  return (s == SCM_BOOL_F) ? SCM_EOL : scm_cdr (s);
}

void
Music::internal_set_property (SCM s, SCM v)
{
  if (do_internal_type_checking_global)
    if (!type_check_assignment (s, v, ly_symbol2scm ("music-type?")))
      abort ();

  mutable_property_alist_ = scm_assq_set_x (mutable_property_alist_, s, v);
}

void
Music::set_spot (Input ip)
{
  set_property ("origin", make_input (ip));
}

Input*
Music::origin () const
{
  Input *ip = unsmob_input (get_property ("origin"));
  return ip ? ip : & dummy_input_global;
}

int
Music::duration_log () const
{
  if (is_mus_type ("rhythmic-event"))
    return unsmob_duration (get_property ("duration"))->duration_log ();
  return 0;
}

Music*
make_music_by_name (SCM sym)
{
  SCM make_music_proc = ly_lily_module_constant ("make-music");
  SCM rv = scm_call_1 (make_music_proc, sym);

  /* UGH. */
  scm_gc_protect_object (rv);
  return unsmob_music (rv);
}
