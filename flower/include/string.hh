/*

  FILE   : string.hh -- declare String
 
  Rehacked by HWN 3/nov/95
  removed String & 's
  introduced Class String_handle
 */

#ifndef STRING_HH
#define STRING_HH


#include <string.h>
#include <iostream.h>
#include <Rational.h>

#include "string-handle.hh"

/** 
 
  Intuitive string class. provides 
\begin{itemize}
\item
  ref counting through #String_handle#
\item
  conversion from bool, int, double, char* , char.  
\item
  to be moved to String_convert:
  conversion to int, upcase, downcase 

\item
  printable. 

\item
  indexing (index_i, index_any_i, last_index_i)

\item
  cutting (left_str, right_str, mid_str)

\item
  concat (+=, +)

\item
  signed comparison (<, >, ==, etc)

\item
  No operator[] is provided, since this would be enormously  slow. If needed,
  convert to char const* .
\end{itemize}

*/
class String
{
protected:
    String_handle strh_; 

    bool null_terminated();
    
public:

    /** init to empty string. This is needed because other
      constructors are provided.*/
    String() {  }                  
    String(Rational);

    /// String s = "abc";
    String( char const* source ); 
    String( Byte const* byte_C, int length_i ); 
    
    /// "ccccc"
    String( char c, int n = 1 );

    String( int i , char const *fmt=0);
    String ( double f , char const* fmt =0);
    /// 'true' or 'false'
    String(bool );

    ///  return a "new"-ed copy of contents
    Byte* copy_byte_p() const; //  return a "new"-ed copy of contents

    char const* ch_C() const;
    Byte const* byte_C() const;
    char* ch_l();
    Byte* byte_l();

    /// deprecated; use ch_C()
    operator char const* () const { return ch_C(); }
    
    String &operator =( String const & source );

    /// concatenate s
    void operator += (char const* s) { strh_ += s; }
    void operator += (String s);

    void append(String);
    void prepend(String);

    char operator []( int n ) const { return strh_[n]; }

    /// return n leftmost chars
    String left_str( int n ) const;

    /// return n rightmost chars
    String right_str( int n ) const;

    /// return uppercase of *this
    String upper_str() const;

    /// return lowercase of *this
    String lower_str() const;

    /// return the "esrever" of *this
    String reversed_str() const;


    /// return a piece starting at index_i (first char = index_i 0), length n
    String mid_str(int index_i, int n ) const;

    /// cut out a middle piece, return remainder
    String nomid_str(int index_i, int n ) const;

    /// signed comparison,  analogous to memcmp;
    static int compare_i(String const & s1,const  String& s2);
	
    /// index of rightmost c 
    int index_last_i( char c) const;

    /// index of rightmost element of string 
    int index_last_i( char const* string ) const;

    int index_i(char c ) const;
    int index_i(String ) const;
    int index_any_i(String ) const;

    void to_upper();
    void to_lower();
    /// provide Stream output
    void print_on(ostream& os) const;

    /// the length of the string
    int length_i() const;

    // ***** depreciated
    int len() const {
    	return length_i();
    }

    /// convert to an integer
    int value_i() const;

    /// convert to a double
    double value_f() const;
};

#include "compare.hh"

instantiate_compare(String const &, String::compare_i);

// because char const* also has an operator ==, this is for safety:
inline bool operator==(String s1, char const* s2){
    return s1 == String(s2);
}
inline bool operator==(char const* s1, String s2)
{
    return String(s1)==s2;
}
inline bool operator!=(String s1, char const* s2  ) {
    return s1!=String(s2);
}
inline bool operator!=(char const* s1,String s2) {
    return String(s2) !=s1;
}


inline String
operator  + (String s1, String  s2)
{
    s1 += s2;
    return s1;
}

inline ostream &
operator << ( ostream& os, String d )
{
    d.print_on(os);
    return os;
}


// String quoteString(String message, String quote);

#endif
