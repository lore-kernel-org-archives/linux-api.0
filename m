From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
Date: Fri, 5 Apr 2019 07:32:03 -0400
Message-ID: <20190405113203.GC18498@hmswarspite.think-freely.org>
References: <cover.1552665316.git.rgb@redhat.com>
 <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAHC9VhQpk6cFZckQH+LQmQmirVzLm_GH57ZD3-76y-59G=DocQ@mail.gmail.com>
 <20190402113150.GA17593@hmswarspite.think-freely.org>
 <20190404214006.jcgmjb4u6iobu42s@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190404214006.jcgmjb4u6iobu42s@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 04, 2019 at 05:40:06PM -0400, Richard Guy Briggs wrote:
> On 2019-04-02 07:31, Neil Horman wrote:
> > On Mon, Apr 01, 2019 at 10:50:03AM -0400, Paul Moore wrote:
> > > On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Audit events could happen in a network namespace outside of a task
> > > > context due to packets received from the net that trigger an auditing
> > > > rule prior to being associated with a running task.  The network
> > > > namespace could be in use by multiple containers by association to the
> > > > tasks in that network namespace.  We still want a way to attribute
> > > > these events to any potential containers.  Keep a list per network
> > > > namespace to track these audit container identifiiers.
> > > >
> > > > Add/increment the audit container identifier on:
> > > > - initial setting of the audit container identifier via /proc
> > > > - clone/fork call that inherits an audit container identifier
> > > > - unshare call that inherits an audit container identifier
> > > > - setns call that inherits an audit container identifier
> > > > Delete/decrement the audit container identifier on:
> > > > - an inherited audit container identifier dropped when child set
> > > > - process exit
> > > > - unshare call that drops a net namespace
> > > > - setns call that drops a net namespace
> > > >
> > > > See: https://github.com/linux-audit/audit-kernel/issues/92
> > > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  include/linux/audit.h | 19 ++++++++++++
> > > >  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > > >  kernel/nsproxy.c      |  4 +++
> > > >  3 files changed, 106 insertions(+), 3 deletions(-)
> > > 
> > > ...
> > > 
> > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > index cf448599ef34..7fa3194f5342 100644
> > > > --- a/kernel/audit.c
> > > > +++ b/kernel/audit.c
> > > > @@ -72,6 +72,7 @@
> > > >  #include <linux/freezer.h>
> > > >  #include <linux/pid_namespace.h>
> > > >  #include <net/netns/generic.h>
> > > > +#include <net/net_namespace.h>
> > > >
> > > >  #include "audit.h"
> > > >
> > > > @@ -99,9 +100,13 @@
> > > >  /**
> > > >   * struct audit_net - audit private network namespace data
> > > >   * @sk: communication socket
> > > > + * @contid_list: audit container identifier list
> > > > + * @contid_list_lock audit container identifier list lock
> > > >   */
> > > >  struct audit_net {
> > > >         struct sock *sk;
> > > > +       struct list_head contid_list;
> > > > +       spinlock_t contid_list_lock;
> > > >  };
> > > >
> > > >  /**
> > > > @@ -275,8 +280,11 @@ struct audit_task_info init_struct_audit = {
> > > >  void audit_free(struct task_struct *tsk)
> > > >  {
> > > >         struct audit_task_info *info = tsk->audit;
> > > > +       struct nsproxy *ns = tsk->nsproxy;
> > > >
> > > >         audit_free_syscall(tsk);
> > > > +       if (ns)
> > > > +               audit_netns_contid_del(ns->net_ns, audit_get_contid(tsk));
> > > >         /* Freeing the audit_task_info struct must be performed after
> > > >          * audit_log_exit() due to need for loginuid and sessionid.
> > > >          */
> > > > @@ -376,6 +384,73 @@ static struct sock *audit_get_sk(const struct net *net)
> > > >         return aunet->sk;
> > > >  }
> > > >
> > > > +void audit_netns_contid_add(struct net *net, u64 contid)
> > > > +{
> > > > +       struct audit_net *aunet = net_generic(net, audit_net_id);
> > > > +       struct list_head *contid_list = &aunet->contid_list;
> > > > +       struct audit_contid *cont;
> > > > +
> > > > +       if (!audit_contid_valid(contid))
> > > > +               return;
> > > > +       if (!aunet)
> > > > +               return;
> > > 
> > > We should move the contid_list assignment below this check, or decide
> > > that aunet is always going to valid (?) and get rid of this check
> > > completely.
> > > 
> > I'm not sure why that would be needed.  Finding the net_id list is an operation
> > of a map relating net namespaces to lists, not contids to lists.  We could do
> > it, sure, but since they're unrelated operations, I don't think we experience
> > any slowdowns from doing it this way.
> > 
> > > > +       spin_lock(&aunet->contid_list_lock);
> > > > +       if (!list_empty(contid_list))
> > > 
> > > We don't need the list_empty() check here do we?  I think we can just
> > > call list_for_each_entry_rcu(), yes?
> > > 
> > This is true, the list_empty check is redundant, and the for loop will fall
> > through if the list is empty.
> > 
> > > > +               list_for_each_entry_rcu(cont, contid_list, list)
> > > > +                       if (cont->id == contid) {
> > > > +                               refcount_inc(&cont->refcount);
> > > > +                               goto out;
> > > > +                       }
> > > > +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> > > 
> > > If you had to guess, what do you think is going to be more common:
> > > bumping the refcount of an existing entry in the list, or adding a new
> > > entry?  I'm asking because I always get a little nervous when doing
> > > allocations while holding a spinlock.  Yes, you are doing it with
> > > GFP_ATOMIC, but it still seems like something to try and avoid if this
> > > is going to approach 50%.  However, if the new entry is rare then the
> > > extra work of always doing the allocation before taking the lock and
> > > then freeing it afterwards might be a bad tradeoff.
> > > 
> > I think this is another way of asking, will multiple processes exist in the same
> > network namespace?  That is to say, will we expect a process to create a net
> > namespace, and then have other processes enter that namespace (thereby
> > triggering multiple calls to audit_netns_contid_add with the same net pointer
> > and cont id).  Given that the kubernetes notion of a pod is almost by definition
> > multiple containers sharing a network namespace, I think the answer is that we
> > will be strongly biased towards the refcount_inc case, rather than the kmalloc
> > case.  I could be wrong, but I think this is likely already in the optimized
> > order.
> 
> I had a stab at doing a GFP_KERNEL alloc before the spinlock and releasing it
> after if it wasn't needed (in Patch#1 below).  I also went one step further and
> converted it to kmem_cache (in Patch#2 below).
> 
> > > My gut feeling says we might do about as many allocations as refcount
> > > bumps, but I could be thinking about this wrong.
> > > 
> > > Moving the allocation outside the spinlock might also open the door to
> > > doing this as GFP_KERNEL, which is a good thing, but I haven't looked
> > > at the callers to see if that is possible (it may not be).  That's an
> > > exercise left to the patch author (if he hasn't done that already).
> 
> Both appear to work, but after successfully running both the contid test and
> audit_testsuite, once I start to push that test system a bit harder I end up
> with a deadlock warning.
> 
> I am having trouble understanding why since it happens both without and with
> the kmem_cache options, so it must be another part of the code that is
> triggering it.  The task_lock is being held at this point in
> audit_set_contid().  I haven't tried changing this alloc over to a GFP_ATOMIC
> to see if that prevents it, just as a debugging check...
> At this point, I'm inclined to leave it as it was without these two patches
> since it works and there doesn't seem to be an obvious best way given the
> uncertainty of the potential workloads.
> 
I would agree.  The trace below says that, when you use GFP_KERNEL, you are
allowing the memory subsystem to block the memory allocating task on memory
reclaim operations (effectively to sleep until kswapd reclaims sufficient memory
to grant the allocation), but kswapd wants to lock the task that is doing the
allocation with task_lock, which the task calling kmalloc(...,GFP_KEREL) already
holds, ergo, deadlock.

In short, you can't hold a tasks lock while preforming a sleeping operation
involving memory allocation. You either need to use GFP_ATOMIC, or release the
tasks lock before allocating memory with GFP_KERNEL.  Given the possible race
conditions surrounding releasing and re-aquiring the lock, I'm inclined to say
just use GFP_ATOMIC

Neil

> ======================================================
> WARNING: possible circular locking dependency detected
> 5.1.0-rc1-ghak90-audit-containerID.v6.3+ #80 Not tainted
> ------------------------------------------------------
> kswapd0/41 is trying to acquire lock:
> 0000000006a8c88b (&(&p->alloc_lock)->rlock){+.+.}, at: create_task_io_context+0xe9/0x150
> 
> but task is already holding lock:
> 0000000010aadb74 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x40
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (fs_reclaim){+.+.}:
>        __fs_reclaim_acquire+0x2c/0x40
>        kmem_cache_alloc_trace+0x30/0x230
>        audit_netns_contid_add.part.12+0xcf/0x210
>        audit_set_contid+0x18f/0x480
>        proc_contid_write+0x74/0x110
>        vfs_write+0xad/0x1b0
>        ksys_write+0x55/0xc0
>        do_syscall_64+0x60/0x210
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> -> #0 (&(&p->alloc_lock)->rlock){+.+.}:
>        lock_acquire+0xd4/0x1c0
>        _raw_spin_lock+0x2e/0x40
>        create_task_io_context+0xe9/0x150
>        generic_make_request_checks+0x8b4/0x970
>        generic_make_request+0xbb/0x570
>        submit_bio+0x6e/0x130
>        __swap_writepage+0x281/0x420
>        shmem_writepage+0x1d3/0x350
>        pageout.isra.54+0x1e9/0x3f0
>        shrink_page_list+0xa9f/0xe60
>        shrink_inactive_list+0x263/0x6e0
>        shrink_node_memcg+0x376/0x7c0
>        shrink_node+0xdd/0x470
>        balance_pgdat+0x26c/0x570
>        kswapd+0x191/0x4f0
>        kthread+0xf8/0x130
>        ret_from_fork+0x3a/0x50
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(fs_reclaim);
>                                lock(&(&p->alloc_lock)->rlock);
>                                lock(fs_reclaim);
>   lock(&(&p->alloc_lock)->rlock);
> 
>  *** DEADLOCK ***
> 
> 1 lock held by kswapd0/41:
>  #0: 0000000010aadb74 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x40
> 
> > > paul moore
> 
> Patch#1:
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -388,7 +388,7 @@ void audit_netns_contid_add(struct net *net, u64 contid)
>  {
>         struct audit_net *aunet;
>         struct list_head *contid_list;
> -       struct audit_contid *cont;
> +       struct audit_contid *cont, *newcont;
>  
>         if (!net)
>                 return;
> @@ -398,18 +398,19 @@ void audit_netns_contid_add(struct net *net, u64 contid)
>         if (!aunet)
>                 return;
>         contid_list = &aunet->contid_list;
> +       newcont = kmalloc(sizeof(struct audit_contid), GFP_KERNEL);
>         spin_lock(&aunet->contid_list_lock);
>         list_for_each_entry_rcu(cont, contid_list, list)
>                 if (cont->id == contid) {
>                         refcount_inc(&cont->refcount);
> +                       kfree(newcont);
>                         goto out;
>                 }
> -       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> -       if (cont) {
> -               INIT_LIST_HEAD(&cont->list);
> -               cont->id = contid;
> -               refcount_set(&cont->refcount, 1);
> -               list_add_rcu(&cont->list, contid_list);
> +       if (newcont) {
> +               INIT_LIST_HEAD(&newcont->list);
> +               newcont->id = contid;
> +               refcount_set(&newcont->refcount, 1);
> +               list_add_rcu(&newcont->list, contid_list);
>         }
>  out:
>         spin_unlock(&aunet->contid_list_lock);
> 
> 
> Patch#2:
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -222,12 +222,16 @@ struct audit_reply {
>  };
>  
>  static struct kmem_cache *audit_task_cache;
> +static struct kmem_cache *audit_contid_cache;
>  
>  void __init audit_task_init(void)
>  {
>         audit_task_cache = kmem_cache_create("audit_task",
>                                              sizeof(struct audit_task_info),
>                                              0, SLAB_PANIC, NULL);
> +       audit_contid_cache = kmem_cache_create("audit_contid",
> +                                            sizeof(struct audit_contid),
> +                                            0, SLAB_PANIC, NULL);
>  }
>  
>  /**
> @@ -388,7 +392,7 @@ void audit_netns_contid_add(struct net *net, u64 contid)
>  {
>         struct audit_net *aunet;
>         struct list_head *contid_list;
> -       struct audit_contid *cont;
> +       struct audit_contid *cont, *newcont;
>  
>         if (!net)
>                 return;
> @@ -398,23 +402,32 @@ void audit_netns_contid_add(struct net *net, u64 contid)
>         if (!aunet)
>                 return;
>         contid_list = &aunet->contid_list;
> +       newcont = kmem_cache_alloc(audit_contid_cache, GFP_KERNEL);
>         spin_lock(&aunet->contid_list_lock);
>         list_for_each_entry_rcu(cont, contid_list, list)
>                 if (cont->id == contid) {
>                         refcount_inc(&cont->refcount);
> +                       kmem_cache_free(audit_contid_cache, newcont);
>                         goto out;
>                 }
> -       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> -       if (cont) {
> -               INIT_LIST_HEAD(&cont->list);
> -               cont->id = contid;
> -               refcount_set(&cont->refcount, 1);
> -               list_add_rcu(&cont->list, contid_list);
> +       if (newcont) {
> +               INIT_LIST_HEAD(&newcont->list);
> +               newcont->id = contid;
> +               refcount_set(&newcont->refcount, 1);
> +               list_add_rcu(&newcont->list, contid_list);
>         }
>  out:
>         spin_unlock(&aunet->contid_list_lock);
>  }
>  
> +static void audit_contid_free(struct rcu_head *rcu)
> +{
> +       struct audit_contid *cont;
> +
> +       cont = container_of(rcu, struct audit_contid, rcu);
> +       kmem_cache_free(audit_contid_cache, cont);
> +}
> +
>  void audit_netns_contid_del(struct net *net, u64 contid)
>  {
>         struct audit_net *aunet;
> @@ -434,7 +447,7 @@ void audit_netns_contid_del(struct net *net, u64 contid)
>                 if (cont->id == contid) {
>                         if (refcount_dec_and_test(&cont->refcount)) {
>                                 list_del_rcu(&cont->list);
> -                               kfree_rcu(cont, rcu);
> +                               call_rcu(&cont->rcu, audit_contid_free);
>                         }
>                         break;
>                 }
> 
> - RGB
> 
> --
> Richard Guy Briggs <rgb@redhat.com>
> Sr. S/W Engineer, Kernel Security, Base Operating Systems
> Remote, Ottawa, Red Hat Canada
> IRC: rgb, SunRaycer
> Voice: +1.647.777.2635, Internal: (81) 32635
> 
