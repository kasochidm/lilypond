/*
  key-reg.hh -- declare Key_register

  source file of the GNU LilyPond music typesetter

  (c) 1997 Han-Wen Nienhuys <hanwen@stack.nl>
*/


#ifndef KEYREG_HH
#define KEYREG_HH

#include "register.hh"
#include "key.hh"

struct Key_register : Request_register {
    Key key_;
    Key_change_req * keyreq_l_;
    Key_item * kit_p_;
    Array<int> accidental_idx_arr_;
    bool default_key_b_;
    bool change_key_b_;
    
    virtual bool do_try_request(Request *req_l);
    virtual void do_process_requests();
    virtual void do_pre_move_processing();
    virtual void do_post_move_processing();
    virtual void acknowledge_element(Score_elem_info);
    Key_register();
    NAME_MEMBERS();
private:
    void create_key();
    
    void read_req(Key_change_req * r);
};

#endif // KEYREG_HH
