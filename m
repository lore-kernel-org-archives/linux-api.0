From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 05/10] audit: add support for
 non-syscall auxiliary records
Date: Fri, 19 Oct 2018 19:17:18 -0400
Message-ID: <CAHC9VhSG3Hk2zrNP3w=CfEBXN7_LcywiTpvhGp48661xYhRq2A@mail.gmail.com>
References: <cover.1533065887.git.rgb@redhat.com> <2827530000d6b4972d446b0226adab153ff3b5c5.1533065887.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2827530000d6b4972d446b0226adab153ff3b5c5.1533065887.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rgb@redhat.com
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 5, 2018 at 4:33 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> Standalone audit records have the timestamp and serial number generated
> on the fly and as such are unique, making them standalone.  This new
> function audit_alloc_local() generates a local audit context that will
> be used only for a standalone record and its auxiliary record(s).  The
> context is discarded immediately after the local associated records are
> produced.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> ---
>  include/linux/audit.h |  8 ++++++++
>  kernel/audit.h        |  1 +
>  kernel/auditsc.c      | 33 ++++++++++++++++++++++++++++-----
>  3 files changed, 37 insertions(+), 5 deletions(-)

I'm not in love with the local flag, and the whole local context in
general, but that's a larger discussion and not something I want to
force on this patchset; we can fix it later.

I think this patch looks fine, but it seems a bit odd standalone; it's
almost always better to include new capabilities/functions in the same
patch as the user.  Since the only user is the networking bits, it
might make more sense to fold this patch into that one.

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 4f514ed..1f340ad 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -234,7 +234,9 @@ struct audit_task_info {
>  extern struct audit_task_info init_struct_audit;
>  extern void __init audit_task_init(void);
>  extern int  audit_alloc(struct task_struct *task);
> +extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
>  extern void audit_free(struct task_struct *task);
> +extern void audit_free_context(struct audit_context *context);
>  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
>                                   unsigned long a2, unsigned long a3);
>  extern void __audit_syscall_exit(int ret_success, long ret_value);
> @@ -495,6 +497,12 @@ static inline int audit_alloc(struct task_struct *task)
>  {
>         return 0;
>  }
> +static inline struct audit_context *audit_alloc_local(gfp_t gfpflags)
> +{
> +       return NULL;
> +}
> +static inline void audit_free_context(struct audit_context *context)
> +{ }
>  static inline void audit_free(struct task_struct *task)
>  { }
>  static inline void audit_syscall_entry(int major, unsigned long a0,
> diff --git a/kernel/audit.h b/kernel/audit.h
> index 1cf1c35..a6d00a5 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -110,6 +110,7 @@ struct audit_proctitle {
>  struct audit_context {
>         int                 dummy;      /* must be the first element */
>         int                 in_syscall; /* 1 if task is in a syscall */
> +       bool                local;      /* local context needed */
>         enum audit_state    state, current_state;
>         unsigned int        serial;     /* serial number for record */
>         int                 major;      /* syscall number */
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index cdb24cf..7627f21 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -913,11 +913,13 @@ static inline void audit_free_aux(struct audit_context *context)
>         }
>  }
>
> -static inline struct audit_context *audit_alloc_context(enum audit_state state)
> +static inline struct audit_context *audit_alloc_context(enum audit_state state,
> +                                                       gfp_t gfpflags)
>  {
>         struct audit_context *context;
>
> -       context = kzalloc(sizeof(*context), GFP_KERNEL);
> +       /* We can be called in atomic context via audit_tg() */
> +       context = kzalloc(sizeof(*context), gfpflags);
>         if (!context)
>                 return NULL;
>         context->state = state;
> @@ -970,7 +972,8 @@ int audit_alloc(struct task_struct *tsk)
>                 return 0;
>         }
>
> -       if (!(context = audit_alloc_context(state))) {
> +       context = audit_alloc_context(state, GFP_KERNEL);
> +       if (!(context)) {
>                 tsk->audit = NULL;
>                 kmem_cache_free(audit_task_cache, info);
>                 kfree(key);
> @@ -991,8 +994,27 @@ struct audit_task_info init_struct_audit = {
>         .ctx = NULL,
>  };
>
> -static inline void audit_free_context(struct audit_context *context)
> +struct audit_context *audit_alloc_local(gfp_t gfpflags)
>  {
> +       struct audit_context *context;
> +
> +       if (!audit_ever_enabled)
> +               return NULL; /* Return if not auditing. */
> +
> +       context = audit_alloc_context(AUDIT_RECORD_CONTEXT, gfpflags);
> +       if (!context)
> +               return NULL;
> +       context->serial = audit_serial();
> +       context->ctime = current_kernel_time64();
> +       context->local = true;
> +       return context;
> +}
> +EXPORT_SYMBOL(audit_alloc_local);
> +
> +void audit_free_context(struct audit_context *context)
> +{
> +       if (!context)
> +               return;
>         audit_free_names(context);
>         unroll_tree_refs(context, NULL, 0);
>         free_tree_refs(context);
> @@ -1002,6 +1024,7 @@ static inline void audit_free_context(struct audit_context *context)
>         audit_proctitle_free(context);
>         kfree(context);
>  }
> +EXPORT_SYMBOL(audit_free_context);
>
>  static int audit_log_pid_context(struct audit_context *context, pid_t pid,
>                                  kuid_t auid, kuid_t uid, unsigned int sessionid,
> @@ -2024,7 +2047,7 @@ void __audit_inode_child(struct inode *parent,
>  int auditsc_get_stamp(struct audit_context *ctx,
>                        struct timespec64 *t, unsigned int *serial)
>  {
> -       if (!ctx->in_syscall)
> +       if (!ctx->in_syscall && !ctx->local)
>                 return 0;
>         if (!ctx->serial)
>                 ctx->serial = audit_serial();

--
paul moore
www.paul-moore.com
