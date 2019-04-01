From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V5 10/10] audit: NETFILTER_PKT: record each
 container ID associated with a netNS
Date: Mon, 1 Apr 2019 10:50:11 -0400
Message-ID: <CAHC9VhQpNGaWeb7dY4ooPKXRoGBd9Ri_Z_ZPpoKun4gUhXDOGA@mail.gmail.com>
References: <cover.1552665316.git.rgb@redhat.com> <56127b2a5b82f15cb0d0f040502c2e3bb6945f30.1552665316.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56127b2a5b82f15cb0d0f040502c2e3bb6945f30.1552665316.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> event standalone records.  Iterate through all potential audit container
> identifiers associated with a network namespace.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h    |  5 +++++
>  kernel/audit.c           | 41 +++++++++++++++++++++++++++++++++++++++++
>  net/netfilter/nft_log.c  | 11 +++++++++--
>  net/netfilter/xt_AUDIT.c | 11 +++++++++--
>  4 files changed, 64 insertions(+), 4 deletions(-)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7fa3194f5342..80ed323feeb5 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -451,6 +451,47 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
>                 audit_netns_contid_add(new->net_ns, contid);
>  }
>
> +/**
> + * audit_log_netns_contid_list - List contids for the given network namespace
> + * @net: the network namespace of interest
> + * @context: the audit context to use
> + *
> + * Description:
> + * Issues a CONTAINER_ID record with a CSV list of contids associated
> + * with a network namespace to accompany a NETFILTER_PKT record.
> + */
> +void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
> +{
> +       struct audit_buffer *ab = NULL;
> +       struct audit_contid *cont;
> +       bool first = true;
> +       struct audit_net *aunet;
> +
> +       /* Generate AUDIT_CONTAINER_ID record with container ID CSV list */
> +       rcu_read_lock();
> +       aunet = net_generic(net, audit_net_id);
> +       if (!aunet)
> +               goto out;
> +       list_for_each_entry_rcu(cont, &aunet->contid_list, list) {
> +               if (first) {

This is borderline nit-picky, but it seems like we could get rid of
"first" and just check to see if "ab" is still NULL.

> +                       ab = audit_log_start(context, GFP_ATOMIC,
> +                                            AUDIT_CONTAINER_ID);
> +                       if (!ab) {
> +                               audit_log_lost("out of memory in audit_log_netns_contid_list");
> +                               goto out;
> +                       }
> +                       audit_log_format(ab, "contid=");
> +               } else
> +                       audit_log_format(ab, ",");
> +               audit_log_format(ab, "%llu", cont->id);
> +               first = false;
> +       }
> +       audit_log_end(ab);
> +out:
> +       rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(audit_log_netns_contid_list);

-- 
paul moore
www.paul-moore.com
