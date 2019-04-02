From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
Date: Tue, 2 Apr 2019 07:31:50 -0400
Message-ID: <20190402113150.GA17593@hmswarspite.think-freely.org>
References: <cover.1552665316.git.rgb@redhat.com>
 <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAHC9VhQpk6cFZckQH+LQmQmirVzLm_GH57ZD3-76y-59G=DocQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhQpk6cFZckQH+LQmQmirVzLm_GH57ZD3-76y-59G=DocQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Mon, Apr 01, 2019 at 10:50:03AM -0400, Paul Moore wrote:
> On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Audit events could happen in a network namespace outside of a task
> > context due to packets received from the net that trigger an auditing
> > rule prior to being associated with a running task.  The network
> > namespace could be in use by multiple containers by association to the
> > tasks in that network namespace.  We still want a way to attribute
> > these events to any potential containers.  Keep a list per network
> > namespace to track these audit container identifiiers.
> >
> > Add/increment the audit container identifier on:
> > - initial setting of the audit container identifier via /proc
> > - clone/fork call that inherits an audit container identifier
> > - unshare call that inherits an audit container identifier
> > - setns call that inherits an audit container identifier
> > Delete/decrement the audit container identifier on:
> > - an inherited audit container identifier dropped when child set
> > - process exit
> > - unshare call that drops a net namespace
> > - setns call that drops a net namespace
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/92
> > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h | 19 ++++++++++++
> >  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  kernel/nsproxy.c      |  4 +++
> >  3 files changed, 106 insertions(+), 3 deletions(-)
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index cf448599ef34..7fa3194f5342 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -72,6 +72,7 @@
> >  #include <linux/freezer.h>
> >  #include <linux/pid_namespace.h>
> >  #include <net/netns/generic.h>
> > +#include <net/net_namespace.h>
> >
> >  #include "audit.h"
> >
> > @@ -99,9 +100,13 @@
> >  /**
> >   * struct audit_net - audit private network namespace data
> >   * @sk: communication socket
> > + * @contid_list: audit container identifier list
> > + * @contid_list_lock audit container identifier list lock
> >   */
> >  struct audit_net {
> >         struct sock *sk;
> > +       struct list_head contid_list;
> > +       spinlock_t contid_list_lock;
> >  };
> >
> >  /**
> > @@ -275,8 +280,11 @@ struct audit_task_info init_struct_audit = {
> >  void audit_free(struct task_struct *tsk)
> >  {
> >         struct audit_task_info *info = tsk->audit;
> > +       struct nsproxy *ns = tsk->nsproxy;
> >
> >         audit_free_syscall(tsk);
> > +       if (ns)
> > +               audit_netns_contid_del(ns->net_ns, audit_get_contid(tsk));
> >         /* Freeing the audit_task_info struct must be performed after
> >          * audit_log_exit() due to need for loginuid and sessionid.
> >          */
> > @@ -376,6 +384,73 @@ static struct sock *audit_get_sk(const struct net *net)
> >         return aunet->sk;
> >  }
> >
> > +void audit_netns_contid_add(struct net *net, u64 contid)
> > +{
> > +       struct audit_net *aunet = net_generic(net, audit_net_id);
> > +       struct list_head *contid_list = &aunet->contid_list;
> > +       struct audit_contid *cont;
> > +
> > +       if (!audit_contid_valid(contid))
> > +               return;
> > +       if (!aunet)
> > +               return;
> 
> We should move the contid_list assignment below this check, or decide
> that aunet is always going to valid (?) and get rid of this check
> completely.
> 
I'm not sure why that would be needed.  Finding the net_id list is an operation
of a map relating net namespaces to lists, not contids to lists.  We could do
it, sure, but since they're unrelated operations, I don't think we experience
any slowdowns from doing it this way.

> > +       spin_lock(&aunet->contid_list_lock);
> > +       if (!list_empty(contid_list))
> 
> We don't need the list_empty() check here do we?  I think we can just
> call list_for_each_entry_rcu(), yes?
> 
This is true, the list_empty check is redundant, and the for loop will fall
through if the list is empty.

> > +               list_for_each_entry_rcu(cont, contid_list, list)
> > +                       if (cont->id == contid) {
> > +                               refcount_inc(&cont->refcount);
> > +                               goto out;
> > +                       }
> > +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> 
> If you had to guess, what do you think is going to be more common:
> bumping the refcount of an existing entry in the list, or adding a new
> entry?  I'm asking because I always get a little nervous when doing
> allocations while holding a spinlock.  Yes, you are doing it with
> GFP_ATOMIC, but it still seems like something to try and avoid if this
> is going to approach 50%.  However, if the new entry is rare then the
> extra work of always doing the allocation before taking the lock and
> then freeing it afterwards might be a bad tradeoff.
> 
I think this is another way of asking, will multiple processes exist in the same
network namespace?  That is to say, will we expect a process to create a net
namespace, and then have other processes enter that namespace (thereby
triggering multiple calls to audit_netns_contid_add with the same net pointer
and cont id).  Given that the kubernetes notion of a pod is almost by definition
multiple containers sharing a network namespace, I think the answer is that we
will be strongly biased towards the refcount_inc case, rather than the kmalloc
case.  I could be wrong, but I think this is likely already in the optimized
order.

> My gut feeling says we might do about as many allocations as refcount
> bumps, but I could be thinking about this wrong.
> 
> Moving the allocation outside the spinlock might also open the door to
> doing this as GFP_KERNEL, which is a good thing, but I haven't looked
> at the callers to see if that is possible (it may not be).  That's an
> exercise left to the patch author (if he hasn't done that already).
> 
> > +       if (cont) {
> > +               INIT_LIST_HEAD(&cont->list);
> 
> Unless there is some guidance that INIT_LIST_HEAD() should be used
> regardless, you shouldn't need to call this here since list_add_rcu()
> will take care of any list.h related initialization.
> 
There is a corner case that needs it.  list_add_rcu has a check that gets
called, __list_add_valid.  Its a noop in the regular case, but if
CONFIG_DEBUG_LIST is defined, its a check to ensure that the next and prev
pointers getting passed in aren't set to detectable corrupt values.  If we pass
in garbage, we can get transient false positives on that check, so we need to
set the list pointers to known good values before hand, either by using kzalloc,
or INIT_LIST_HEAD, as has been done here.  Given that we expressly set every
field of this structure, I think this is the right approach, as it uses the list
macro to expressly set the list values to their proper state.

> > +               cont->id = contid;
> > +               refcount_set(&cont->refcount, 1);
> > +               list_add_rcu(&cont->list, contid_list);
> > +       }
> > +out:
> > +       spin_unlock(&aunet->contid_list_lock);
> > +}
> 
> -- 
> paul moore
> www.paul-moore.com
> 
