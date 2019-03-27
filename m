From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
Date: Wed, 27 Mar 2019 23:42:11 +0100
Message-ID: <CAFqZXNskwTub5Bm_HZqr02VPB4s79CcgAVX8VE2vQYP07-qssg@mail.gmail.com>
References: <cover.1552665316.git.rgb@redhat.com> <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, Steve Grubb <sgrubb@redhat.com>, David Howells <dhowells@redhat.com>, Simo Sorce <simo@redhat.com>, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 7:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Audit events could happen in a network namespace outside of a task
> context due to packets received from the net that trigger an auditing
> rule prior to being associated with a running task.  The network
> namespace could be in use by multiple containers by association to the
> tasks in that network namespace.  We still want a way to attribute
> these events to any potential containers.  Keep a list per network
> namespace to track these audit container identifiiers.
>
> Add/increment the audit container identifier on:
> - initial setting of the audit container identifier via /proc
> - clone/fork call that inherits an audit container identifier
> - unshare call that inherits an audit container identifier
> - setns call that inherits an audit container identifier
> Delete/decrement the audit container identifier on:
> - an inherited audit container identifier dropped when child set
> - process exit
> - unshare call that drops a net namespace
> - setns call that drops a net namespace
>
> See: https://github.com/linux-audit/audit-kernel/issues/92
> See: https://github.com/linux-audit/audit-testsuite/issues/64
> See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h | 19 ++++++++++++
>  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/nsproxy.c      |  4 +++
>  3 files changed, 106 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index fa19fa408931..70255c2dfb9f 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -27,6 +27,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/namei.h>  /* LOOKUP_* */
>  #include <uapi/linux/audit.h>
> +#include <linux/refcount.h>
>
>  #define AUDIT_INO_UNSET ((unsigned long)-1)
>  #define AUDIT_DEV_UNSET ((dev_t)-1)
> @@ -99,6 +100,13 @@ struct audit_task_info {
>
>  extern struct audit_task_info init_struct_audit;
>
> +struct audit_contid {
> +       struct list_head        list;
> +       u64                     id;
> +       refcount_t              refcount;

Hm, since we only ever touch the refcount under a spinlock, I wonder
if we could just make it a regular unsigned int (we don't need the
atomicity guarantees). OTOH, refcount_t comes with some extra overflow
checking, so it's probably better to leave it as is...

> +       struct rcu_head         rcu;
> +};
> +
>  extern int is_audit_feature_set(int which);
>
>  extern int __init audit_register_class(int class, unsigned *list);
> @@ -202,6 +210,10 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
>  }
>
>  extern void audit_log_contid(struct audit_context *context, u64 contid);
> +extern void audit_netns_contid_add(struct net *net, u64 contid);
> +extern void audit_netns_contid_del(struct net *net, u64 contid);
> +extern void audit_switch_task_namespaces(struct nsproxy *ns,
> +                                        struct task_struct *p);
>
>  extern u32 audit_enabled;
>  #else /* CONFIG_AUDIT */
> @@ -271,6 +283,13 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
>
>  static inline void audit_log_contid(struct audit_context *context, u64 contid)
>  { }
> +static inline void audit_netns_contid_add(struct net *net, u64 contid)
> +{ }
> +static inline void audit_netns_contid_del(struct net *net, u64 contid)
> +{ }
> +static inline void audit_switch_task_namespaces(struct nsproxy *ns,
> +                                               struct task_struct *p)
> +{ }
>
>  #define audit_enabled AUDIT_OFF
>  #endif /* CONFIG_AUDIT */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index cf448599ef34..7fa3194f5342 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -72,6 +72,7 @@
>  #include <linux/freezer.h>
>  #include <linux/pid_namespace.h>
>  #include <net/netns/generic.h>
> +#include <net/net_namespace.h>
>
>  #include "audit.h"
>
> @@ -99,9 +100,13 @@
>  /**
>   * struct audit_net - audit private network namespace data
>   * @sk: communication socket
> + * @contid_list: audit container identifier list
> + * @contid_list_lock audit container identifier list lock
>   */
>  struct audit_net {
>         struct sock *sk;
> +       struct list_head contid_list;
> +       spinlock_t contid_list_lock;
>  };
>
>  /**
> @@ -275,8 +280,11 @@ struct audit_task_info init_struct_audit = {
>  void audit_free(struct task_struct *tsk)
>  {
>         struct audit_task_info *info = tsk->audit;
> +       struct nsproxy *ns = tsk->nsproxy;
>
>         audit_free_syscall(tsk);
> +       if (ns)
> +               audit_netns_contid_del(ns->net_ns, audit_get_contid(tsk));
>         /* Freeing the audit_task_info struct must be performed after
>          * audit_log_exit() due to need for loginuid and sessionid.
>          */
> @@ -376,6 +384,73 @@ static struct sock *audit_get_sk(const struct net *net)
>         return aunet->sk;
>  }
>
> +void audit_netns_contid_add(struct net *net, u64 contid)
> +{
> +       struct audit_net *aunet = net_generic(net, audit_net_id);
> +       struct list_head *contid_list = &aunet->contid_list;
> +       struct audit_contid *cont;
> +
> +       if (!audit_contid_valid(contid))
> +               return;
> +       if (!aunet)
> +               return;
> +       spin_lock(&aunet->contid_list_lock);
> +       if (!list_empty(contid_list))
> +               list_for_each_entry_rcu(cont, contid_list, list)
> +                       if (cont->id == contid) {
> +                               refcount_inc(&cont->refcount);
> +                               goto out;
> +                       }
> +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> +       if (cont) {
> +               INIT_LIST_HEAD(&cont->list);
> +               cont->id = contid;
> +               refcount_set(&cont->refcount, 1);
> +               list_add_rcu(&cont->list, contid_list);
> +       }
> +out:
> +       spin_unlock(&aunet->contid_list_lock);
> +}
> +
> +void audit_netns_contid_del(struct net *net, u64 contid)
> +{
> +       struct audit_net *aunet;
> +       struct list_head *contid_list;
> +       struct audit_contid *cont = NULL;
> +
> +       if (!net)
> +               return;
> +       if (!audit_contid_valid(contid))
> +               return;
> +       aunet = net_generic(net, audit_net_id);
> +       if (!aunet)
> +               return;
> +       contid_list = &aunet->contid_list;
> +       spin_lock(&aunet->contid_list_lock);
> +       if (!list_empty(contid_list))
> +               list_for_each_entry_rcu(cont, contid_list, list)
> +                       if (cont->id == contid) {
> +                               if (refcount_dec_and_test(&cont->refcount)) {
> +                                       list_del_rcu(&cont->list);
> +                                       kfree_rcu(cont, rcu);
> +                               }
> +                               break;
> +                       }
> +       spin_unlock(&aunet->contid_list_lock);
> +}
> +
> +void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
> +{
> +       u64 contid = audit_get_contid(p);
> +       struct nsproxy *new = p->nsproxy;
> +
> +       if (!audit_contid_valid(contid))
> +               return;
> +       audit_netns_contid_del(ns->net_ns, contid);
> +       if (new)
> +               audit_netns_contid_add(new->net_ns, contid);
> +}
> +
>  void audit_panic(const char *message)
>  {
>         switch (audit_failure) {
> @@ -1619,7 +1694,6 @@ static int __net_init audit_net_init(struct net *net)
>                 .flags  = NL_CFG_F_NONROOT_RECV,
>                 .groups = AUDIT_NLGRP_MAX,
>         };
> -
>         struct audit_net *aunet = net_generic(net, audit_net_id);
>
>         aunet->sk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
> @@ -1628,7 +1702,8 @@ static int __net_init audit_net_init(struct net *net)
>                 return -ENOMEM;
>         }
>         aunet->sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
> -
> +       INIT_LIST_HEAD(&aunet->contid_list);
> +       spin_lock_init(&aunet->contid_list_lock);
>         return 0;
>  }
>
> @@ -2380,6 +2455,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>         uid_t uid;
>         struct tty_struct *tty;
>         char comm[sizeof(current->comm)];
> +       struct net *net = task->nsproxy->net_ns;
>
>         task_lock(task);
>         /* Can't set if audit disabled */
> @@ -2401,8 +2477,12 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>         else if (!(thread_group_leader(task) && thread_group_empty(task)))
>                 rc = -EALREADY;
>         read_unlock(&tasklist_lock);
> -       if (!rc)
> +       if (!rc) {
> +               if (audit_contid_valid(oldcontid))
> +                       audit_netns_contid_del(net, oldcontid);
>                 task->audit->contid = contid;
> +               audit_netns_contid_add(net, contid);
> +       }
>         task_unlock(task);
>
>         if (!audit_enabled)
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index f6c5d330059a..718b1201ae70 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -27,6 +27,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/cgroup.h>
>  #include <linux/perf_event.h>
> +#include <linux/audit.h>
>
>  static struct kmem_cache *nsproxy_cachep;
>
> @@ -140,6 +141,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
>         struct nsproxy *old_ns = tsk->nsproxy;
>         struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
>         struct nsproxy *new_ns;
> +       u64 contid = audit_get_contid(tsk);
>
>         if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
>                               CLONE_NEWPID | CLONE_NEWNET |
> @@ -167,6 +169,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
>                 return  PTR_ERR(new_ns);
>
>         tsk->nsproxy = new_ns;
> +       audit_netns_contid_add(new_ns->net_ns, contid);
>         return 0;
>  }
>
> @@ -224,6 +227,7 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
>         ns = p->nsproxy;
>         p->nsproxy = new;
>         task_unlock(p);
> +       audit_switch_task_namespaces(ns, p);

Since we call audit_switch_task_namespaces() after task_unlock(),
could there be a potential race condition? I'm not going to dive too
much into this now, because it's getting late here, but on first look
it seems like p->nsproxy could change under our hands before we fetch
it in audit_switch_task_namespaces()...

>
>         if (ns && atomic_dec_and_test(&ns->count))
>                 free_nsproxy(ns);
> --
> 1.8.3.1
>

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
