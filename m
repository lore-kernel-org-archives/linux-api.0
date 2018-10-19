From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 08/10] audit: add support for
 containerid to network namespaces
Date: Fri, 19 Oct 2018 19:18:23 -0400
Message-ID: <CAHC9VhTCi3+XRTMtDmM_7QS+HK7cygC4Qs71PFpWXH58ECb_8Q@mail.gmail.com>
References: <cover.1533065887.git.rgb@redhat.com> <5a2b4aadf6994f622bc1ad27a8a6889c7e61edff.1533065887.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <5a2b4aadf6994f622bc1ad27a8a6889c7e61edff.1533065887.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: rgb@redhat.com
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 31, 2018 at 4:12 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Audit events could happen in a network namespace outside of a task
> context due to packets received from the net that trigger an auditing
> rule prior to being associated with a running task.  The network
> namespace could in use by multiple containers by association to the
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
>  include/linux/audit.h | 17 ++++++++++
>  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/auditsc.c      |  8 ++++-
>  kernel/nsproxy.c      |  4 +++
>  4 files changed, 114 insertions(+), 1 deletion(-)

...

> @@ -308,6 +312,86 @@ static struct sock *audit_get_sk(const struct net *net)
>         return aunet->sk;
>  }
>
> +/**
> + * audit_get_netns_contid_list - Return the audit container ID list for the given network namespace
> + * @net: the destination network namespace
> + *
> + * Description:
> + * Returns the list pointer if valid, NULL otherwise.  The caller must ensure
> + * that a reference is held for the network namespace while the sock is in use.
> + */
> +struct list_head *audit_get_netns_contid_list(const struct net *net)
> +{
> +       struct audit_net *aunet = net_generic(net, audit_net_id);
> +
> +       return &aunet->contid_list;
> +}
> +
> +spinlock_t *audit_get_netns_contid_list_lock(const struct net *net)
> +{
> +       struct audit_net *aunet = net_generic(net, audit_net_id);
> +
> +       return &aunet->contid_list_lock;
> +}

Instead of returning the spinlock, just do away with the
audit_get_ns_contid_list_lock() function and create two separate lock
and unlock functions that basically do the net_generic() and spinlock
operations together, for example:

static int audit_netns_contid_lock(const struct net *net)
{
  aunet = net_generic(net, audit_net_id);

  if (!aunet)
    return -whatever;

  spin_lock(aunet->lock);
  return 0;
}

> +void audit_netns_contid_add(struct net *net, u64 contid)
> +{
> +       spinlock_t *lock = audit_get_netns_contid_list_lock(net);
> +       struct list_head *contid_list = audit_get_netns_contid_list(net);
> +       struct audit_contid *cont;
> +
> +       if (!audit_contid_valid(contid))
> +               return;
> +       spin_lock(lock);
> +       if (!list_empty(contid_list))
> +               list_for_each_entry(cont, contid_list, list)
> +                       if (cont->id == contid) {
> +                               refcount_inc(&cont->refcount);
> +                               goto out;
> +                       }
> +       cont = kmalloc(sizeof(struct audit_contid), GFP_KERNEL);
> +       if (cont) {
> +               INIT_LIST_HEAD(&cont->list);
> +               cont->id = contid;
> +               refcount_set(&cont->refcount, 1);
> +               list_add(&cont->list, contid_list);
> +       }
> +out:
> +       spin_unlock(lock);
> +}
> +
> +void audit_netns_contid_del(struct net *net, u64 contid)
> +{
> +       spinlock_t *lock = audit_get_netns_contid_list_lock(net);
> +       struct list_head *contid_list = audit_get_netns_contid_list(net);
> +       struct audit_contid *cont = NULL;
> +
> +       if (!audit_contid_valid(contid))
> +               return;
> +       spin_lock(lock);
> +       if (!list_empty(contid_list))
> +               list_for_each_entry(cont, contid_list, list)
> +                       if (cont->id == contid) {
> +                               list_del(&cont->list);
> +                               if (refcount_dec_and_test(&cont->refcount))
> +                                       kfree(cont);
> +                               break;
> +                       }
> +       spin_unlock(lock);
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
> @@ -1547,6 +1631,8 @@ static int __net_init audit_net_init(struct net *net)
>                 return -ENOMEM;
>         }
>         aunet->sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
> +       INIT_LIST_HEAD(&aunet->contid_list);
> +       spin_lock_init(&aunet->contid_list_lock);
>
>         return 0;
>  }
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 610c6869..fdf3f68 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -75,6 +75,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/fsnotify_backend.h>
>  #include <uapi/linux/limits.h>
> +#include <net/net_namespace.h>
>
>  #include "audit.h"
>
> @@ -2165,6 +2166,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>         uid_t uid;
>         struct tty_struct *tty;
>         char comm[sizeof(current->comm)];
> +       struct net *net = task->nsproxy->net_ns;
>
>         task_lock(task);
>         /* Can't set if audit disabled */
> @@ -2186,8 +2188,12 @@ int audit_set_contid(struct task_struct *task, u64 contid)
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
> index f6c5d33..718b120 100644
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
>
>         if (ns && atomic_dec_and_test(&ns->count))
>                 free_nsproxy(ns);
