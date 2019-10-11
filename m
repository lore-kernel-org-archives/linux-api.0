From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V7 12/21] audit: add support for containerid to
 network namespaces
Date: Thu, 10 Oct 2019 20:39:35 -0400
Message-ID: <CAHC9VhRgOTfZzzv+NxxH3D3FN-2A=cd2h1+oDc2cabLhzi4gfQ@mail.gmail.com>
References: <cover.1568834524.git.rgb@redhat.com> <91315ac64b44bcad9dfc623fa7fefe67d7d2561b.1568834524.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <91315ac64b44bcad9dfc623fa7fefe67d7d2561b.1568834524.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Wed, Sep 18, 2019 at 9:26 PM Richard Guy Briggs <rgb@redhat.com> wrote:
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
> Please see the github audit kernel issue for contid net support:
>   https://github.com/linux-audit/audit-kernel/issues/92
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h | 19 +++++++++++
>  kernel/audit.c        | 87 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/nsproxy.c      |  4 +++
>  3 files changed, 108 insertions(+), 2 deletions(-)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7cdb76b38966..e0c27bc39925 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -373,6 +381,75 @@ static struct sock *audit_get_sk(const struct net *net)
>         return aunet->sk;
>  }
>
> +void audit_netns_contid_add(struct net *net, u64 contid)
> +{
> +       struct audit_net *aunet;
> +       struct list_head *contid_list;
> +       struct audit_contid *cont;
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
> +       list_for_each_entry_rcu(cont, contid_list, list)
> +               if (cont->id == contid) {
> +                       refcount_inc(&cont->refcount);
> +                       goto out;
> +               }
> +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);

 kmalloc(sizeof(*cont), GFP_ATOMIC)


> +       if (cont) {
> +               INIT_LIST_HEAD(&cont->list);
> +               cont->id = contid;
> +               refcount_set(&cont->refcount, 1);
> +               list_add_rcu(&cont->list, contid_list);
> +       }
> +out:
> +       spin_unlock(&aunet->contid_list_lock);
> +}
