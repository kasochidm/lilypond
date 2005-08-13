/*
  ttf.cc --  implement ttf -> pfa routine.

  source file of the GNU LilyPond music typesetter

  (c) 2005 Han-Wen Nienhuys <hanwen@xs4all.nl>
*/

#include "freetype.hh"

#include <freetype/tttables.h>

#include "lily-proto.hh"
#include "memory-stream.hh"
#include "warn.hh"
#include "lily-guile.hh"
#include "main.hh"

/*
  Based on ttfps by Juliusz Chroboczek
*/
static void
print_header (void *out, FT_Face face)
{
  lily_cookie_fprintf (out, "%%!PS-TrueTypeFont\n");

  TT_Postscript *pt
    = (TT_Postscript *) FT_Get_Sfnt_Table (face, ft_sfnt_post);

  if (pt->maxMemType42)
    lily_cookie_fprintf (out, "%%%%VMUsage: %ld %ld\n", 0, 0);

  lily_cookie_fprintf (out, "%d dict begin\n", 11);
  lily_cookie_fprintf (out, "/FontName /%s def\n",
		       FT_Get_Postscript_Name (face));

  lily_cookie_fprintf (out, "/Encoding StandardEncoding def\n");
  lily_cookie_fprintf (out, "/PaintType 0 def\n");
  lily_cookie_fprintf (out, "/FontMatrix [1 0 0 1 0 0] def\n");

  TT_Header *ht
    = (TT_Header *)FT_Get_Sfnt_Table (face, ft_sfnt_head);

  lily_cookie_fprintf (out, "/FontBBox [%ld %ld %ld %ld] def\n",
		       ht->xMin *1000L / ht->Units_Per_EM,
		       ht->yMin *1000L / ht->Units_Per_EM,
		       ht->xMax *1000L / ht->Units_Per_EM,
		       ht->yMax *1000L / ht->Units_Per_EM);

  lily_cookie_fprintf (out, "/FontType 42 def\n");
  lily_cookie_fprintf (out, "/FontInfo 8 dict dup begin\n");
  lily_cookie_fprintf (out, "/version (%d.%d) def\n",
		       (ht->Font_Revision >> 16),
		       (ht->Font_Revision &((1 << 16) -1)));

#if 0
  if (strings[0])
    {
      lily_cookie_fprintf (out, "/Notice (");
      fputpss (strings[0], out);
      lily_cookie_fprintf (out, ") def\n");
    }
  if (strings[4])
    {
      lily_cookie_fprintf (out, "/FullName (");
      fputpss (strings[4], out);
      lily_cookie_fprintf (out, ") def\n");
    }
  if (strings[1])
    {
      lily_cookie_fprintf (out, "/FamilyName (");
      fputpss (strings[1], out);
      lily_cookie_fprintf (out, ") def\n");
    }
#endif

  lily_cookie_fprintf (out, "/isFixedPitch %s def\n",
		       pt->isFixedPitch ? "true" : "false");
  lily_cookie_fprintf (out, "/UnderlinePosition %ld def\n",
		       pt->underlinePosition *1000L / ht->Units_Per_EM);
  lily_cookie_fprintf (out, "/UnderlineThickness %ld def\n",
		       pt->underlineThickness *1000L / ht->Units_Per_EM);
  lily_cookie_fprintf (out, "end readonly def\n");
}

#define CHUNKSIZE 65534

static void
print_body (void *out, String name)
{
  FILE *fd = fopen (name.to_str0 (), "rb");

  static char xdigits[] = "0123456789ABCDEF";

  unsigned char *buffer;
  int i, j;

  buffer = new unsigned char[CHUNKSIZE];
  lily_cookie_fprintf (out, "/sfnts [");
  for (;;)
    {
      i = fread (buffer, 1, CHUNKSIZE, fd);
      if (i == 0)
	break;
      lily_cookie_fprintf (out, "\n<");
      for (j = 0; j < i; j++)
	{
	  if (j != 0 && j % 36 == 0)
	    lily_cookie_putc ('\n', out);
	  /* lily_cookie_fprintf (out,"%02X",(int)buffer[j]) is too slow */
	  lily_cookie_putc (xdigits[ (buffer[j] & 0xF0) >> 4], out);
	  lily_cookie_putc (xdigits[buffer[j] & 0x0F], out);
	}
      lily_cookie_fprintf (out, "00>");	/* Adobe bug? */
      if (i < CHUNKSIZE)
	break;
    }
  lily_cookie_fprintf (out, "\n] def\n");
  delete[] buffer;
  fclose (fd);
}

static void
print_trailer (void *out,
	       FT_Face face)
{
  const int GLYPH_NAME_LEN = 256;
  char glyph_name[GLYPH_NAME_LEN];

  TT_MaxProfile *mp
    = (TT_MaxProfile *)FT_Get_Sfnt_Table (face, ft_sfnt_maxp);

  lily_cookie_fprintf (out, "/CharStrings %d dict dup begin\n", mp->numGlyphs);
  for (int i = 0; i < mp->numGlyphs; i++)
    {
      FT_Error error = FT_Get_Glyph_Name (face, i, glyph_name, GLYPH_NAME_LEN);

      if (error)
	programming_error ("FT_Get_Glyph_Name() returned error");
      else
	lily_cookie_fprintf (out, "/%s %d def ", glyph_name, i);

      if (! (i % 5))
	lily_cookie_fprintf (out, "\n");
    }
  lily_cookie_fprintf (out, "end readonly def\n");
  lily_cookie_fprintf (out, "FontName currentdict end definefont pop\n");
}

static void
create_type42_font (void *out, String name)
{
  FT_Face face = open_ft_face (name);

  print_header (out, face);
  print_body (out, name);
  print_trailer (out, face);
}

LY_DEFINE (ly_ttf_to_pfa, "ly:ttf->pfa",
	   1, 0, 0, (SCM ttf_file_name),
	   "Convert the contents of a TTF file to Type42 PFA, returning it as "
	   " a string.")
{
  SCM_ASSERT_TYPE (scm_is_string (ttf_file_name), ttf_file_name,
		   SCM_ARG1, __FUNCTION__, "string");

  String file_name = ly_scm2string (ttf_file_name);
  if (be_verbose_global)
    progress_indication ("[" + file_name);

  Memory_out_stream stream;

  create_type42_font (&stream, file_name);
  SCM asscm = scm_from_locale_stringn (stream.get_string (),
				       stream.get_length ());

  if (be_verbose_global)
    progress_indication ("]");

  return asscm;
}
