From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH ghak90 V5 01/10] audit: collect audit task parameters
Date: Wed, 27 Mar 2019 21:33:44 +0100
Message-ID: <CAFqZXNsct8yLwHSyAK5rdaOPLLJJS=1R+WyNsWKj0DKiT9_wGQ@mail.gmail.com>
References: <cover.1552665316.git.rgb@redhat.com> <76b039ef21de18f8b36af9c15f9d3fb7fd94ab21.1552665316.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <76b039ef21de18f8b36af9c15f9d3fb7fd94ab21.1552665316.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, Steve Grubb <sgrubb@redhat.com>, David Howells <dhowells@redhat.com>, Simo Sorce <simo@redhat.com>, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 7:33 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> The audit-related parameters in struct task_struct should ideally be
> collected together and accessed through a standard audit API.
>
> Collect the existing loginuid, sessionid and audit_context together in a
> new struct audit_task_info called "audit" in struct task_struct.
>
> Use kmem_cache to manage this pool of memory.
> Un-inline audit_free() to be able to always recover that memory.
>
> Please see the upstream github issue
> https://github.com/linux-audit/audit-kernel/issues/81
> but that issue has been closed with this patch included with
> https://github.com/linux-audit/audit-kernel/issues/90
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>


> ---
>  include/linux/audit.h | 49 +++++++++++++++++++++++------------
>  include/linux/sched.h |  7 +----
>  init/init_task.c      |  3 +--
>  init/main.c           |  2 ++
>  kernel/audit.c        | 71 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/audit.h        |  5 ++++
>  kernel/auditsc.c      | 26 ++++++++++---------
>  kernel/fork.c         |  1 -
>  8 files changed, 124 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 1e69d9fe16da..bde346e73f0c 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -86,6 +86,16 @@ struct audit_field {
>         u32                             op;
>  };
>
> +struct audit_task_info {
> +       kuid_t                  loginuid;
> +       unsigned int            sessionid;
> +#ifdef CONFIG_AUDITSYSCALL
> +       struct audit_context    *ctx;
> +#endif
> +};
> +
> +extern struct audit_task_info init_struct_audit;
> +
>  extern int is_audit_feature_set(int which);
>
>  extern int __init audit_register_class(int class, unsigned *list);
> @@ -122,6 +132,9 @@ struct audit_field {
>  #ifdef CONFIG_AUDIT
>  /* These are defined in audit.c */
>                                 /* Public API */
> +extern int  audit_alloc(struct task_struct *task);
> +extern void audit_free(struct task_struct *task);
> +extern void __init audit_task_init(void);
>  extern __printf(4, 5)
>  void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
>                const char *fmt, ...);
> @@ -164,16 +177,28 @@ extern void                   audit_log_key(struct audit_buffer *ab,
>
>  static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
>  {
> -       return tsk->loginuid;
> +       if (!tsk->audit)
> +               return INVALID_UID;
> +       return tsk->audit->loginuid;
>  }
>
>  static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>  {
> -       return tsk->sessionid;
> +       if (!tsk->audit)
> +               return AUDIT_SID_UNSET;
> +       return tsk->audit->sessionid;
>  }
>
>  extern u32 audit_enabled;
>  #else /* CONFIG_AUDIT */
> +static inline int audit_alloc(struct task_struct *task)
> +{
> +       return 0;
> +}
> +static inline void audit_free(struct task_struct *task)
> +{ }
> +static inline void __init audit_task_init(void)
> +{ }
>  static inline __printf(4, 5)
>  void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
>                const char *fmt, ...)
> @@ -239,8 +264,6 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>
>  /* These are defined in auditsc.c */
>                                 /* Public API */
> -extern int  audit_alloc(struct task_struct *task);
> -extern void __audit_free(struct task_struct *task);
>  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
>                                   unsigned long a2, unsigned long a3);
>  extern void __audit_syscall_exit(int ret_success, long ret_value);
> @@ -263,12 +286,14 @@ extern void audit_seccomp_actions_logged(const char *names,
>
>  static inline void audit_set_context(struct task_struct *task, struct audit_context *ctx)
>  {
> -       task->audit_context = ctx;
> +       task->audit->ctx = ctx;
>  }
>
>  static inline struct audit_context *audit_context(void)
>  {
> -       return current->audit_context;
> +       if (!current->audit)
> +               return NULL;
> +       return current->audit->ctx;
>  }
>
>  static inline bool audit_dummy_context(void)
> @@ -276,11 +301,7 @@ static inline bool audit_dummy_context(void)
>         void *p = audit_context();
>         return !p || *(int *)p;
>  }
> -static inline void audit_free(struct task_struct *task)
> -{
> -       if (unlikely(task->audit_context))
> -               __audit_free(task);
> -}
> +
>  static inline void audit_syscall_entry(int major, unsigned long a0,
>                                        unsigned long a1, unsigned long a2,
>                                        unsigned long a3)
> @@ -470,12 +491,6 @@ static inline void audit_fanotify(unsigned int response)
>  extern int audit_n_rules;
>  extern int audit_signals;
>  #else /* CONFIG_AUDITSYSCALL */
> -static inline int audit_alloc(struct task_struct *task)
> -{
> -       return 0;
> -}
> -static inline void audit_free(struct task_struct *task)
> -{ }
>  static inline void audit_syscall_entry(int major, unsigned long a0,
>                                        unsigned long a1, unsigned long a2,
>                                        unsigned long a3)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 765119df759a..6850d1e48ace 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -31,7 +31,6 @@
>  #include <linux/rseq.h>
>
>  /* task_struct member predeclarations (sorted alphabetically): */
> -struct audit_context;
>  struct backing_dev_info;
>  struct bio_list;
>  struct blk_plug;
> @@ -886,11 +885,7 @@ struct task_struct {
>         struct callback_head            *task_works;
>
>  #ifdef CONFIG_AUDIT
> -#ifdef CONFIG_AUDITSYSCALL
> -       struct audit_context            *audit_context;
> -#endif
> -       kuid_t                          loginuid;
> -       unsigned int                    sessionid;
> +       struct audit_task_info          *audit;
>  #endif
>         struct seccomp                  seccomp;
>
> diff --git a/init/init_task.c b/init/init_task.c
> index 39c3109acc1a..f9685e1edda1 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -122,8 +122,7 @@ struct task_struct init_task
>         .thread_group   = LIST_HEAD_INIT(init_task.thread_group),
>         .thread_node    = LIST_HEAD_INIT(init_signals.thread_head),
>  #ifdef CONFIG_AUDIT
> -       .loginuid       = INVALID_UID,
> -       .sessionid      = AUDIT_SID_UNSET,
> +       .audit          = &init_struct_audit,
>  #endif
>  #ifdef CONFIG_PERF_EVENTS
>         .perf_event_mutex = __MUTEX_INITIALIZER(init_task.perf_event_mutex),
> diff --git a/init/main.c b/init/main.c
> index e2e80ca3165a..8a1c36625d12 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -92,6 +92,7 @@
>  #include <linux/rodata_test.h>
>  #include <linux/jump_label.h>
>  #include <linux/mem_encrypt.h>
> +#include <linux/audit.h>
>
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -727,6 +728,7 @@ asmlinkage __visible void __init start_kernel(void)
>         nsfs_init();
>         cpuset_init();
>         cgroup_init();
> +       audit_task_init();
>         taskstats_init_early();
>         delayacct_init();
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index c89ea48c70a6..67498c5690bb 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -215,6 +215,73 @@ struct audit_reply {
>         struct sk_buff *skb;
>  };
>
> +static struct kmem_cache *audit_task_cache;
> +
> +void __init audit_task_init(void)
> +{
> +       audit_task_cache = kmem_cache_create("audit_task",
> +                                            sizeof(struct audit_task_info),
> +                                            0, SLAB_PANIC, NULL);
> +}
> +
> +/**
> + * audit_alloc - allocate an audit info block for a task
> + * @tsk: task
> + *
> + * Call audit_alloc_syscall to filter on the task information and
> + * allocate a per-task audit context if necessary.  This is called from
> + * copy_process, so no lock is needed.
> + */
> +int audit_alloc(struct task_struct *tsk)
> +{
> +       int ret = 0;
> +       struct audit_task_info *info;
> +
> +       info = kmem_cache_alloc(audit_task_cache, GFP_KERNEL);
> +       if (!info) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +       info->loginuid = audit_get_loginuid(current);
> +       info->sessionid = audit_get_sessionid(current);
> +       tsk->audit = info;
> +
> +       ret = audit_alloc_syscall(tsk);
> +       if (ret) {
> +               tsk->audit = NULL;
> +               kmem_cache_free(audit_task_cache, info);
> +       }
> +out:
> +       return ret;
> +}
> +
> +struct audit_task_info init_struct_audit = {
> +       .loginuid = INVALID_UID,
> +       .sessionid = AUDIT_SID_UNSET,
> +#ifdef CONFIG_AUDITSYSCALL
> +       .ctx = NULL,
> +#endif
> +};
> +
> +/**
> + * audit_free - free per-task audit info
> + * @tsk: task whose audit info block to free
> + *
> + * Called from copy_process and do_exit
> + */
> +void audit_free(struct task_struct *tsk)
> +{
> +       struct audit_task_info *info = tsk->audit;
> +
> +       audit_free_syscall(tsk);
> +       /* Freeing the audit_task_info struct must be performed after
> +        * audit_log_exit() due to need for loginuid and sessionid.
> +        */
> +       info = tsk->audit;
> +       tsk->audit = NULL;
> +       kmem_cache_free(audit_task_cache, info);
> +}
> +
>  /**
>   * auditd_test_task - Check to see if a given task is an audit daemon
>   * @task: the task to check
> @@ -2266,8 +2333,8 @@ int audit_set_loginuid(kuid_t loginuid)
>                         sessionid = (unsigned int)atomic_inc_return(&session_id);
>         }
>
> -       current->sessionid = sessionid;
> -       current->loginuid = loginuid;
> +       current->audit->sessionid = sessionid;
> +       current->audit->loginuid = loginuid;
>  out:
>         audit_log_set_loginuid(oldloginuid, loginuid, oldsessionid, sessionid, rc);
>         return rc;
> diff --git a/kernel/audit.h b/kernel/audit.h
> index 958d5b8fc1b3..c00e2ee3c6b3 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -264,6 +264,8 @@ extern void audit_log_d_path_exe(struct audit_buffer *ab,
>  extern unsigned int audit_serial(void);
>  extern int auditsc_get_stamp(struct audit_context *ctx,
>                               struct timespec64 *t, unsigned int *serial);
> +extern int audit_alloc_syscall(struct task_struct *tsk);
> +extern void audit_free_syscall(struct task_struct *tsk);
>
>  extern void audit_put_watch(struct audit_watch *watch);
>  extern void audit_get_watch(struct audit_watch *watch);
> @@ -305,6 +307,9 @@ extern void audit_filter_inodes(struct task_struct *tsk,
>  extern struct list_head *audit_killed_trees(void);
>  #else /* CONFIG_AUDITSYSCALL */
>  #define auditsc_get_stamp(c, t, s) 0
> +#define audit_alloc_syscall(t) 0
> +#define audit_free_syscall(t) {}
> +
>  #define audit_put_watch(w) {}
>  #define audit_get_watch(w) {}
>  #define audit_to_watch(k, p, l, o) (-EINVAL)
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index d1eab1d4a930..8090eff7868d 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -885,23 +885,25 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
>         return context;
>  }
>
> -/**
> - * audit_alloc - allocate an audit context block for a task
> +/*
> + * audit_alloc_syscall - allocate an audit context block for a task
>   * @tsk: task
>   *
>   * Filter on the task information and allocate a per-task audit context
>   * if necessary.  Doing so turns on system call auditing for the
> - * specified task.  This is called from copy_process, so no lock is
> - * needed.
> + * specified task.  This is called from copy_process via audit_alloc, so
> + * no lock is needed.
>   */
> -int audit_alloc(struct task_struct *tsk)
> +int audit_alloc_syscall(struct task_struct *tsk)
>  {
>         struct audit_context *context;
>         enum audit_state     state;
>         char *key = NULL;
>
> -       if (likely(!audit_ever_enabled))
> +       if (likely(!audit_ever_enabled)) {
> +               audit_set_context(tsk, NULL);
>                 return 0; /* Return if not auditing. */
> +       }
>
>         state = audit_filter_task(tsk, &key);
>         if (state == AUDIT_DISABLED) {
> @@ -911,7 +913,7 @@ int audit_alloc(struct task_struct *tsk)
>
>         if (!(context = audit_alloc_context(state))) {
>                 kfree(key);
> -               audit_log_lost("out of memory in audit_alloc");
> +               audit_log_lost("out of memory in audit_alloc_syscall");
>                 return -ENOMEM;
>         }
>         context->filterkey = key;
> @@ -1555,14 +1557,15 @@ static void audit_log_exit(void)
>  }
>
>  /**
> - * __audit_free - free a per-task audit context
> + * audit_free_syscall - free per-task audit context info
>   * @tsk: task whose audit context block to free
>   *
> - * Called from copy_process and do_exit
> + * Called from audit_free
>   */
> -void __audit_free(struct task_struct *tsk)
> +void audit_free_syscall(struct task_struct *tsk)
>  {
> -       struct audit_context *context = tsk->audit_context;
> +       struct audit_task_info *info = tsk->audit;
> +       struct audit_context *context = info->ctx;
>
>         if (!context)
>                 return;
> @@ -1585,7 +1588,6 @@ void __audit_free(struct task_struct *tsk)
>                 if (context->current_state == AUDIT_RECORD_CONTEXT)
>                         audit_log_exit();
>         }
> -
>         audit_set_context(tsk, NULL);
>         audit_free_context(context);
>  }
> diff --git a/kernel/fork.c b/kernel/fork.c
> index a60459947f18..1107bd8b8ad8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1836,7 +1836,6 @@ static __latent_entropy struct task_struct *copy_process(
>         p->start_time = ktime_get_ns();
>         p->real_start_time = ktime_get_boot_ns();
>         p->io_context = NULL;
> -       audit_set_context(p, NULL);
>         cgroup_fork(p);
>  #ifdef CONFIG_NUMA
>         p->mempolicy = mpol_dup(p->mempolicy);
> --
> 1.8.3.1
>


--
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
