#ifndef PSTAFF_HH
#define PSTAFF_HH

#include "proto.hh"
#include "plist.hh"
#include "item.hh"
#include "symbol.hh"

/// items grouped horizontally
struct PStaff {
    PScore * pscore_l_;
    
    
    Link_list<Spanner const *> spans;
    Link_list<Item*> its;

    /* *************** */
    void add(Item*i);
    PStaff(PScore*);

private:
    PStaff(PStaff const&);
};

#endif
