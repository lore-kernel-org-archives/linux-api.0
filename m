From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
Date: Mon, 1 Apr 2019 10:50:03 -0400
Message-ID: <CAHC9VhQpk6cFZckQH+LQmQmirVzLm_GH57ZD3-76y-59G=DocQ@mail.gmail.com>
References: <cover.1552665316.git.rgb@redhat.com> <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
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

...

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

We should move the contid_list assignment below this check, or decide
that aunet is always going to valid (?) and get rid of this check
completely.

> +       spin_lock(&aunet->contid_list_lock);
> +       if (!list_empty(contid_list))

We don't need the list_empty() check here do we?  I think we can just
call list_for_each_entry_rcu(), yes?

> +               list_for_each_entry_rcu(cont, contid_list, list)
> +                       if (cont->id == contid) {
> +                               refcount_inc(&cont->refcount);
> +                               goto out;
> +                       }
> +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);

If you had to guess, what do you think is going to be more common:
bumping the refcount of an existing entry in the list, or adding a new
entry?  I'm asking because I always get a little nervous when doing
allocations while holding a spinlock.  Yes, you are doing it with
GFP_ATOMIC, but it still seems like something to try and avoid if this
is going to approach 50%.  However, if the new entry is rare then the
extra work of always doing the allocation before taking the lock and
then freeing it afterwards might be a bad tradeoff.

My gut feeling says we might do about as many allocations as refcount
bumps, but I could be thinking about this wrong.

Moving the allocation outside the spinlock might also open the door to
doing this as GFP_KERNEL, which is a good thing, but I haven't looked
at the callers to see if that is possible (it may not be).  That's an
exercise left to the patch author (if he hasn't done that already).

> +       if (cont) {
> +               INIT_LIST_HEAD(&cont->list);

Unless there is some guidance that INIT_LIST_HEAD() should be used
regardless, you shouldn't need to call this here since list_add_rcu()
will take care of any list.h related initialization.

> +               cont->id = contid;
> +               refcount_set(&cont->refcount, 1);
> +               list_add_rcu(&cont->list, contid_list);
> +       }
> +out:
> +       spin_unlock(&aunet->contid_list_lock);
> +}

-- 
paul moore
www.paul-moore.com
