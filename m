From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak32 V2 11/13] audit: add support for containerid
 to network namespaces
Date: Fri, 20 Apr 2018 16:02:26 -0400
Message-ID: <20180420200226.7tyxzuovdbgclw3m@madcap2.tricolour.ca>
References: <cover.1521179281.git.rgb@redhat.com>
 <11b43a498e768a14764594c808a96b34d52be0af.1521179281.git.rgb@redhat.com>
 <CAHC9VhRkstDMjd5T3w+iOUDjzDAs1AOm0xd3p6v_xn6fNGYQhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRkstDMjd5T3w+iOUDjzDAs1AOm0xd3p6v_xn6fNGYQhA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On 2018-04-18 21:46, Paul Moore wrote:
> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > Audit events could happen in a network namespace outside of a task
> > context due to packets received from the net that trigger an auditing
> > rule prior to being associated with a running task.  The network
> > namespace could in use by multiple containers by association to the
> > tasks in that network namespace.  We still want a way to attribute
> > these events to any potential containers.  Keep a list per network
> > namespace to track these container identifiiers.
> >
> > Add/increment the container identifier on:
> > - initial setting of the container id via /proc
> > - clone/fork call that inherits a container identifier
> > - unshare call that inherits a container identifier
> > - setns call that inherits a container identifier
> > Delete/decrement the container identifier on:
> > - an inherited container id dropped when child set
> > - process exit
> > - unshare call that drops a net namespace
> > - setns call that drops a net namespace
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/32
> > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h       |  7 +++++++
> >  include/net/net_namespace.h | 12 ++++++++++++
> >  kernel/auditsc.c            |  9 ++++++---
> >  kernel/nsproxy.c            |  6 ++++++
> >  net/core/net_namespace.c    | 45 +++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 76 insertions(+), 3 deletions(-)
> 
> ...
> 
> > diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> > index 0490084..343a428 100644
> > --- a/include/net/net_namespace.h
> > +++ b/include/net/net_namespace.h
> > @@ -33,6 +33,7 @@
> >  #include <linux/ns_common.h>
> >  #include <linux/idr.h>
> >  #include <linux/skbuff.h>
> > +#include <linux/audit.h>
> >
> >  struct user_namespace;
> >  struct proc_dir_entry;
> > @@ -150,6 +151,7 @@ struct net {
> >  #endif
> >         struct sock             *diag_nlsk;
> >         atomic_t                fnhe_genid;
> > +       struct list_head        audit_containerid;
> >  } __randomize_layout;
> 
> We talked about this briefly off-list, you should be using audit_net
> and the net_generic mechanism instead of this.
> 
> >  #include <linux/seq_file_net.h>
> > @@ -301,6 +303,16 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
> >  #define __net_initconst        __initconst
> >  #endif
> >
> > +#ifdef CONFIG_NET_NS
> > +void net_add_audit_containerid(struct net *net, u64 containerid);
> > +void net_del_audit_containerid(struct net *net, u64 containerid);
> > +#else
> > +static inline void net_add_audit_containerid(struct net *, u64)
> > +{ }
> > +static inline void net_del_audit_containerid(struct net *, u64)
> > +{ }
> > +#endif
> > +
> >  int peernet2id_alloc(struct net *net, struct net *peer);
> >  int peernet2id(struct net *net, struct net *peer);
> >  bool peernet_has_id(struct net *net, struct net *peer);
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 2f02ed9..208da962 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -75,6 +75,7 @@
> >  #include <linux/uaccess.h>
> >  #include <linux/fsnotify_backend.h>
> >  #include <uapi/linux/limits.h>
> > +#include <net/net_namespace.h>
> >
> >  #include "audit.h"
> >
> > @@ -2175,16 +2176,18 @@ static void audit_log_set_containerid(struct task_struct *task, u64 oldcontainer
> >   */
> >  int audit_set_containerid(struct task_struct *task, u64 containerid)
> >  {
> > -       u64 oldcontainerid;
> > +       u64 oldcontainerid = audit_get_containerid(task);
> >         int rc;
> > -
> > -       oldcontainerid = audit_get_containerid(task);
> > +       struct net *net = task->nsproxy->net_ns;
> >
> >         rc = audit_set_containerid_perm(task, containerid);
> >         if (!rc) {
> > +               if (cid_valid(oldcontainerid))
> > +                       net_del_audit_containerid(net, oldcontainerid);
> 
> Using audit_net we can handle this internal to audit, which is a Good Thing.

No problem, done.

> >                 task_lock(task);
> >                 task->containerid = containerid;
> >                 task_unlock(task);
> > +               net_add_audit_containerid(net, containerid);
> 
> Same.
> 
> >         }
> >
> >         audit_log_set_containerid(task, oldcontainerid, containerid, rc);
> > diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> > index f6c5d33..d9f1090 100644
> > --- a/kernel/nsproxy.c
> > +++ b/kernel/nsproxy.c
> > @@ -140,6 +140,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
> >         struct nsproxy *old_ns = tsk->nsproxy;
> >         struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
> >         struct nsproxy *new_ns;
> > +       u64 containerid = audit_get_containerid(tsk);
> >
> >         if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
> >                               CLONE_NEWPID | CLONE_NEWNET |
> > @@ -167,6 +168,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
> >                 return  PTR_ERR(new_ns);
> >
> >         tsk->nsproxy = new_ns;
> > +       net_add_audit_containerid(new_ns->net_ns, containerid);
> >         return 0;
> >  }
> 
> Hopefully we can handle this in audit_net_init(), we just need to
> figure out where we can get the correct task_struct for the audit
> container ID (some backpointer in the net struct?).

I don't follow.  This needs to happen on every task startup.
audit_net_init() is only called when a new network namespace starts up.

> > @@ -217,6 +219,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
> >  void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
> >  {
> >         struct nsproxy *ns;
> > +       u64 containerid = audit_get_containerid(p);
> >
> >         might_sleep();
> >
> > @@ -224,6 +227,9 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
> >         ns = p->nsproxy;
> >         p->nsproxy = new;
> >         task_unlock(p);
> > +       net_del_audit_containerid(ns->net_ns, containerid);
> > +       if (new)
> > +               net_add_audit_containerid(new->net_ns, containerid);
> 
> Okay, we might need a hook here for switching namespaces, but I would
> much rather it be a generic audit hook that calls directly into audit.

Trivial, done.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
