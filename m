From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 09/10] audit: NETFILTER_PKT: record
 each container ID associated with a netNS
Date: Fri, 19 Oct 2018 19:18:54 -0400
Message-ID: <CAHC9VhT2GJH2cJsrCsxCZMLsdv67oXJhH9mHAgpfMRY4=y43WQ@mail.gmail.com>
References: <cover.1533065887.git.rgb@redhat.com> <3f5edfb0d530d7f0061fe11b817b315b350b9d86.1533065887.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3f5edfb0d530d7f0061fe11b817b315b350b9d86.1533065887.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rgb@redhat.com
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 5, 2018 at 4:33 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> event standalone records.  Iterate through all potential audit container
> identifiers associated with a network namespace.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h    |  5 +++++
>  kernel/audit.c           | 26 ++++++++++++++++++++++++++
>  net/netfilter/xt_AUDIT.c | 12 ++++++++++--
>  3 files changed, 41 insertions(+), 2 deletions(-)

...

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 9a02095..8755f4d 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -169,6 +169,8 @@ extern int audit_log_contid(struct audit_context *context,
>  extern void audit_netns_contid_add(struct net *net, u64 contid);
>  extern void audit_netns_contid_del(struct net *net, u64 contid);
>  extern void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p);
> +extern void audit_log_netns_contid_list(struct net *net,
> +                                struct audit_context *context);
>
>  extern int                 audit_update_lsm_rules(void);
>
> @@ -228,6 +230,9 @@ static inline void audit_netns_contid_del(struct net *net, u64 contid)
>  { }
>  static inline void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
>  { }
> +static inline void audit_log_netns_contid_list(struct net *net,
> +                                       struct audit_context *context)
> +{ }
>
>  #define audit_enabled AUDIT_OFF
>  #endif /* CONFIG_AUDIT */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index c5fed3b..b23711c 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -392,6 +392,32 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
>                 audit_netns_contid_add(new->net_ns, contid);
>  }
>
> +void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
> +{
> +       spinlock_t *lock = audit_get_netns_contid_list_lock(net);
> +       struct audit_buffer *ab;
> +       struct audit_contid *cont;
> +       bool first = true;
> +
> +       /* Generate AUDIT_CONTAINER record with container ID CSV list */
> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_CONTAINER);
> +       if (!ab) {
> +               audit_log_lost("out of memory in audit_log_netns_contid_list");
> +               return;
> +       }
> +       audit_log_format(ab, "contid=");
> +       spin_lock(lock);
> +       list_for_each_entry(cont, audit_get_netns_contid_list(net), list) {
> +               if (!first)
> +                       audit_log_format(ab, ",");
> +               audit_log_format(ab, "%llu", cont->id);
> +               first = false;
> +       }
> +       spin_unlock(lock);

This is looking like potentially a lot of work to be doing under a
spinlock, not to mention a single spinlock that is shared across CPUs.
Considering that I expect changes to the list to be somewhat
infrequent, this might be a good candidate for a RCU based locking
scheme.

> +       audit_log_end(ab);
> +}
> +EXPORT_SYMBOL(audit_log_netns_contid_list);
>
>  void audit_panic(const char *message)
>  {
>         switch (audit_failure) {
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index af883f1..44fac3f 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -71,10 +71,13 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>  {
>         struct audit_buffer *ab;
>         int fam = -1;
> +       struct audit_context *context;
> +       struct net *net;
>
>         if (audit_enabled == AUDIT_OFF)
> -               goto errout;
> -       ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> +               goto out;
> +       context = audit_alloc_local(GFP_ATOMIC);
> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>         if (ab == NULL)
>                 goto errout;
>
> @@ -104,7 +107,12 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>
>         audit_log_end(ab);
>
> +       net = xt_net(par);
> +       audit_log_netns_contid_list(net, context);
> +
>  errout:
> +       audit_free_context(context);
> +out:
>         return XT_CONTINUE;
>  }
>

--
paul moore
www.paul-moore.com
