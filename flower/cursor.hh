// cursor.hh

#ifndef __CURSOR_HH
#define __CURSOR_HH

#include "link.hh"
template<class T> class List;

/// iterator to List
/** 
  add and insert extend the list
  items are always stored as copies in List, but:
  List<String> :  copies of String stored 
  List<String*> : copies of String* stored!

    the operations add and insert actually delegate the work to List class.
 */
template<class T>
class Cursor 
{
 public:
    /** this isn't true, actually, #list# surely isn't const, but I get
      tired of the warning messages.  */
    Cursor( const List<T>& list, Link<T>* pointer = 0 );
    
    Cursor( const Cursor<T>& cursor );

    T& thing();

    /// return current T
    T& operator *() { return thing(); }
    operator T() { return thing(); }
    Cursor<T> operator =( const Cursor<T>& c );

    /// make cursor with #no# items back
    Cursor<T> operator -( int no) const;

    /// make cursor with #no# items further
    Cursor<T> operator +( int no) const;
    int operator -(Cursor<T> op) const;
    Cursor<T> operator -=(int);
    Cursor<T> operator +=(int);
    
    /// return current and move one down
    Cursor<T> operator ++( int );
    
    /// return current and move one up
    Cursor<T> operator --( int ); 

    /// point to link?
    bool ok();                  

    /// ++ items left?
    bool forward();		

    /// -- items left?
    bool backward();

    /// put (copy) after me in List
    /**
      analogously to editor. ok() interpreted as at end
      of line.

      PRE: !ok, POST: added to bottom()

      PRE: ok, POST: added after me

      cursor points to same object, cursor.next() is newly added
      object.
      */
    void add( const T& thing );

    /// put (copy) before me in List
    /**
      analogously to editor. ok() interpreted as at begin of
      line.
      
      PRE: !ok, POST: add to top()

      PRE: ok, POST: add before me

      cursor points to same object, cursor.previous()
      is newly inserted object.
      */
    
    void insert( const T& thing );
    ///
    void backspace();

    /// 
    void del();
    
    /// access the list this came from
    List<T>& list() const ;
    Link<T>* pointer();
    static   int compare(Cursor<T> a,Cursor<T>b) { return a-b; }
private:
    List<T>& list_;
    Link<T>* pointer_;
};


/*
  comparisons.
  */
#include "compare.hh"


template_instantiate_compare(Cursor<T>, Cursor<T>::compare, template<class T>);

#include "pcursor.hh"
#include "list.hh"
#include "cursor.inl"
#include "iterate.hh"

#endif // CURSOR_HH 
