From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 08/10] audit: NETFILTER_PKT:
 record each container ID associated with a netNS
Date: Fri, 20 Jul 2018 18:15:00 -0400
Message-ID: <CAHC9VhQCxdOzcYHFtJ8eTLkNQxwvdAnuLOEguqHT_zU4V9d0OA@mail.gmail.com>
References: <cover.1528304203.git.rgb@redhat.com> <c6b64f6540e2e531636142ced36d51f0744d0e1f.1528304204.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c6b64f6540e2e531636142ced36d51f0744d0e1f.1528304204.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: rgb@redhat.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Wed, Jun 6, 2018 at 1:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> event standalone records.  Iterate through all potential audit container
> identifiers associated with a network namespace.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h    |  5 +++++
>  kernel/audit.c           | 20 +++++++++++++++++++-
>  kernel/auditsc.c         |  2 ++
>  net/netfilter/xt_AUDIT.c | 12 ++++++++++--
>  4 files changed, 36 insertions(+), 3 deletions(-)

...

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 7e2e51c..4560a4e 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -167,6 +167,8 @@ extern int audit_log_contid(struct audit_context *context,
>  extern void audit_contid_add(struct net *net, u64 contid);
>  extern void audit_contid_del(struct net *net, u64 contid);
>  extern void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p);
> +extern void audit_log_contid_list(struct net *net,
> +                                struct audit_context *context);

See my comment in previous patches about changing the function name to
better indicate it's dedicate use for network namespaces.

>  extern int                 audit_update_lsm_rules(void);
>
> @@ -231,6 +233,9 @@ static inline void audit_contid_del(struct net *net, u64 contid)
>  { }
>  static inline void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
>  { }
> +static inline void audit_log_contid_list(struct net *net,
> +                                       struct audit_context *context)
> +{ }
>
>  #define audit_enabled 0
>  #endif /* CONFIG_AUDIT */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index ecd2de4..8cca41a 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -382,6 +382,20 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
>                 audit_contid_add(new->net_ns, contid);
>  }
>
> +void audit_log_contid_list(struct net *net, struct audit_context *context)
> +{
> +       struct audit_contid *cont;
> +       int i = 0;
> +
> +       list_for_each_entry(cont, audit_get_contid_list(net), list) {
> +               char buf[14];
> +
> +               sprintf(buf, "net%u", i++);
> +               audit_log_contid(context, buf, cont->id);

Hmm.  It looks like this will generate multiple audit container ID
records with "op=netX contid=Y" (X=netns number, Y=audit container
ID), is that what we want?  I've mentioned my concern around the "op"
values in these records earlier in the patchset, that still applies
here, but now I'm also concerned about the multiple records.  I'm
thinking we might be better served with a single record with either
multiple "contid" fields, or a single "contid" field with a set of
comma separated values (or some other delimiter that Steve's tools
will tolerate).

Steve, thoughts?

> +       }
> +}
> +EXPORT_SYMBOL(audit_log_contid_list);
> +
>  void audit_panic(const char *message)
>  {
>         switch (audit_failure) {
> @@ -2132,17 +2146,21 @@ int audit_log_contid(struct audit_context *context,
>                               char *op, u64 contid)
>  {
>         struct audit_buffer *ab;
> +       gfp_t gfpflags;
>
>         if (!cid_valid(contid))
>                 return 0;
> +       /* We can be called in atomic context via audit_tg() */
> +       gfpflags = (in_atomic() || irqs_disabled()) ? GFP_ATOMIC : GFP_KERNEL;

See my previous comments in the earlier patches about guessing at
gfpflags; let's just add a gfpflags parameter to audit_log_contid().

>         /* Generate AUDIT_CONTAINER record with container ID */
> -       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER);
> +       ab = audit_log_start(context, gfpflags, AUDIT_CONTAINER);
>         if (!ab)
>                 return -ENOMEM;
>         audit_log_format(ab, "op=%s contid=%llu", op, contid);
>         audit_log_end(ab);
>         return 0;
>  }
> +EXPORT_SYMBOL(audit_log_contid);

Move the EXPORT_SYMBOL() to earlier in the patchset when you first
define audit_log_contid().

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 6ab5e5e..e2a16d2 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1015,6 +1015,7 @@ struct audit_context *audit_alloc_local(void)
>         context->in_syscall = 1;
>         return context;
>  }
> +EXPORT_SYMBOL(audit_alloc_local);

Same as above.

>  void audit_free_context(struct audit_context *context)
>  {
> @@ -1029,6 +1030,7 @@ void audit_free_context(struct audit_context *context)
>         audit_proctitle_free(context);
>         kfree(context);
>  }
> +EXPORT_SYMBOL(audit_free_context);

Same.

>  static int audit_log_pid_context(struct audit_context *context, pid_t pid,
>                                  kuid_t auid, kuid_t uid, unsigned int sessionid,
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index f368ee6..10d2707 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -71,10 +71,13 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>  {
>         struct audit_buffer *ab;
>         int fam = -1;
> +       struct audit_context *context;
> +       struct net *net;
>
>         if (audit_enabled == 0)
> -               goto errout;
> -       ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> +               goto out;
> +       context = audit_alloc_local();
> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>         if (ab == NULL)
>                 goto errout;
>
> @@ -104,7 +107,12 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>
>         audit_log_end(ab);
>
> +       net = xt_net(par);
> +       audit_log_contid_list(net, context);
> +
>  errout:
> +       audit_free_context(context);
> +out:
>         return XT_CONTINUE;
>  }
>
> --
> 1.8.3.1
>
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit
