/*
  main.cc -- implement main: entrypoints

  source file of the LilyPond music typesetter

  (c) 1997 Han-Wen Nienhuys <hanwen@stack.nl>
*/

#include <iostream.h>
#include <assert.h>
#include "proto.hh"
#include "plist.hh"
#include "lgetopt.hh"
#include "misc.hh"
#include "string.hh"
#include "main.hh"
#include "path.hh"
#include "config.hh"
#include "source.hh"
#include "my-lily-parser.hh"

Sources* source_l_g = 0;
bool only_midi = false;
extern void parse_file(String,String);


void
destill_inname( String &name_str_r);
Long_option_init theopts[] = {
    1, "output", 'o',
    0, "warranty", 'w',
    0, "help", 'h',
    0, "debug", 'd',
    1, "init", 'i',
    1, "include", 'I',
    0, "midi", 'M',
    0,0,0
};

void
help()
{
    cout <<
	"--help, -h		This help\n"
	"--warranty, -w		show warranty & copyright\n"
	"--output, -o		set default output\n"
	"--debug, -d		enable debug output\n"
	"--init, -i             set init file\n"
        "--include, -I		add to file search path.\n"
	"--midi, -M             midi output only\n"
	"\n"
	"LilyPond was compiled with the following settings:\n"
#ifdef NDEBUG
	"NDEBUG "	
#endif
#ifdef NPRINT
	"NPRINT "
#endif
#ifdef STRING_UTILS_INLINED
	"STRING_UTILS_INLINED "
#endif
	"datadir= " DIR_DATADIR "\n" 
	;
    
    
}

void 
notice()
{
    cout <<
	"\n"
	"LilyPond, a music typesetter.\n"
	"Copyright (C) 1996,97 by\n"
	"  Han-Wen Nienhuys <hanwen@stack.nl>\n"
	"  Jan Nieuwenhuizen <jan@digicash.com>\n"
	"Contributors\n"
	"  Mats Bengtsson <matsb@s3.kth.se>\n"
	"\n"
	"    This program is free software; you can redistribute it and/or\n"
	"modify it under the terms of the GNU General Public License version 2\n"
	"as published by the Free Software Foundation.\n"
	"\n"
	"    This program is distributed in the hope that it will be useful,\n"
	"but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
	"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU\n"
	"General Public License for more details.\n"
	"\n"
	"    You should have received a copy (refer to the file COPYING) of the\n"
	"GNU General Public License along with this program; if not, write to\n"
	"the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,\n"
	"USA.\n";
}

static File_path * path =0;
struct Main_init {
    Main_init() {
	path = new File_path(String(DIR_DATADIR)+"/init/");
	path->push(DIR_DATADIR );
	debug_init();
    }
    ~Main_init() {
	delete path;
    }
} main_init;

void
do_one_file(String init_str, String file_str)
{
    source_l_g = new Sources;
    source_l_g->set_path(path);
    My_lily_parser parser(source_l_g);
    parser.parse_file(init_str, file_str);
    do_scores();
    delete source_l_g;
    source_l_g = 0;
}

int
main (int argc, char **argv)
{    
    Getopt_long oparser(argc, argv,theopts);
    cout << get_version_str() << endl;
    String init_str("symbol.ini");
    
    while (Long_option_init * opt = oparser()) {
	switch ( opt->shortname){
	case 'o':
	    set_default_output(oparser.optarg);
	    break;
	case 'w':
	    notice();
	    exit(0);
	    break;
	case 'I':
	    path->push(oparser.optarg);
	    break;
	case 'i':
	    init_str = oparser.optarg;
	    break;
	case 'h':
	    help();
	    exit(0);
	    break;
	case 'd':
	    set_debug(true);
	    break;
	case 'M':
	    only_midi = true;
	    break;
	default:
	    assert(false);
	    break;
	}
    }

    int p=0;
    char *arg ;
    while ( (arg= oparser.get_next_arg()) ) {
	String f(arg);
	destill_inname(f);
	do_one_file(init_str,f);
	p++;
    }
    if (!p) {
	do_one_file(init_str, "");	
    }

    return 0;
}
String
find_file(String f)
{
    return path->find(f);
}

/// make input file name: add default extension. "" is stdin.
void
destill_inname( String &name_str_r)
{
    if ( name_str_r.length_i() )
        {
        if( name_str_r[ 0 ] != '-' ) 
	    {
	    String a,b,c,d;
	    split_path(name_str_r,a,b,c,d);

	    // add extension if not present.
	    if (d == "") 
		d = ".ly";
	    name_str_r = a+b+c+d;
	    }
	} else name_str_r = "";   
}

