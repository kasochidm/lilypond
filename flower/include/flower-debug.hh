/*
  flower-debug.hh -- declare 

  source file of the Flower Library

  (c) 1997 Han-Wen Nienhuys <hanwen@stack.nl>
*/


#ifndef FLOWER_DEBUG_HH
#define FLOWER_DEBUG_HH

#include "dstream.hh"

extern Dstream *flower_dstream;
extern bool flower_check_debug;
#ifdef NPRINT
#define	fdebug if ( 0 ) *flower_dstream
#else
#define fdebug if (flower_check_debug) \
	flower_dstream->identify_as(__PRETTY_FUNCTION__)
#endif
void set_flower_debug(Dstream&ds, bool);

#endif // FLOWER_DEBUG_HH
