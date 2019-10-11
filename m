From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V7 15/21] sched: pull task_is_descendant into kernel/sched/core.c
Date: Thu, 10 Oct 2019 20:40:17 -0400
Message-ID: <CAHC9VhRSpuNZTFvFmZ50M4bQS8raAJb_mX5qvnPWdPM71YqUwg@mail.gmail.com>
References: <cover.1568834524.git.rgb@redhat.com> <ff8a73c7841ef788c60f13f90d036b321af0e431.1568834524.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ff8a73c7841ef788c60f13f90d036b321af0e431.1568834524.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Wed, Sep 18, 2019 at 9:26 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Since the task_is_descendant() function is used in YAMA and in audit,
> pull the function into kernel/core/sched.c
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/sched.h    |  3 +++
>  kernel/audit.c           | 33 ---------------------------------
>  kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
>  security/yama/yama_lsm.c | 33 ---------------------------------
>  4 files changed, 36 insertions(+), 66 deletions(-)

I'm not really reviewing this as I'm still a little confused from
patch 14/21, but if 14/21 works out as correct this patch should be
squashed into that one.

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a936d162513a..b251f018f4db 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1988,4 +1988,7 @@ static inline void rseq_syscall(struct pt_regs *regs)
>
>  const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
>
> +extern int task_is_descendant(struct task_struct *parent,
> +                             struct task_struct *child);
> +
>  #endif
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 69fe1e9af7cb..4fe7678304dd 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2560,39 +2560,6 @@ static struct task_struct *audit_cont_owner(struct task_struct *tsk)
>  }
>
>  /*
> - * task_is_descendant - walk up a process family tree looking for a match
> - * @parent: the process to compare against while walking up from child
> - * @child: the process to start from while looking upwards for parent
> - *
> - * Returns 1 if child is a descendant of parent, 0 if not.
> - */
> -static int task_is_descendant(struct task_struct *parent,
> -                             struct task_struct *child)
> -{
> -       int rc = 0;
> -       struct task_struct *walker = child;
> -
> -       if (!parent || !child)
> -               return 0;
> -
> -       rcu_read_lock();
> -       if (!thread_group_leader(parent))
> -               parent = rcu_dereference(parent->group_leader);
> -       while (walker->pid > 0) {
> -               if (!thread_group_leader(walker))
> -                       walker = rcu_dereference(walker->group_leader);
> -               if (walker == parent) {
> -                       rc = 1;
> -                       break;
> -               }
> -               walker = rcu_dereference(walker->real_parent);
> -       }
> -       rcu_read_unlock();
> -
> -       return rc;
> -}
> -
> -/*
>   * audit_set_contid - set current task's audit contid
>   * @task: target task
>   * @contid: contid value
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2b037f195473..7ba9e07381fa 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7509,6 +7509,39 @@ void dump_cpu_task(int cpu)
>  }
>
>  /*
> + * task_is_descendant - walk up a process family tree looking for a match
> + * @parent: the process to compare against while walking up from child
> + * @child: the process to start from while looking upwards for parent
> + *
> + * Returns 1 if child is a descendant of parent, 0 if not.
> + */
> +int task_is_descendant(struct task_struct *parent,
> +                             struct task_struct *child)
> +{
> +       int rc = 0;
> +       struct task_struct *walker = child;
> +
> +       if (!parent || !child)
> +               return 0;
> +
> +       rcu_read_lock();
> +       if (!thread_group_leader(parent))
> +               parent = rcu_dereference(parent->group_leader);
> +       while (walker->pid > 0) {
> +               if (!thread_group_leader(walker))
> +                       walker = rcu_dereference(walker->group_leader);
> +               if (walker == parent) {
> +                       rc = 1;
> +                       break;
> +               }
> +               walker = rcu_dereference(walker->real_parent);
> +       }
> +       rcu_read_unlock();
> +
> +       return rc;
> +}
> +
> +/*
>   * Nice levels are multiplicative, with a gentle 10% change for every
>   * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
>   * nice 1, it will get ~10% less CPU time than another CPU-bound task
> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index 94dc346370b1..25eae205eae8 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -263,39 +263,6 @@ static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  }
>
>  /**
> - * task_is_descendant - walk up a process family tree looking for a match
> - * @parent: the process to compare against while walking up from child
> - * @child: the process to start from while looking upwards for parent
> - *
> - * Returns 1 if child is a descendant of parent, 0 if not.
> - */
> -static int task_is_descendant(struct task_struct *parent,
> -                             struct task_struct *child)
> -{
> -       int rc = 0;
> -       struct task_struct *walker = child;
> -
> -       if (!parent || !child)
> -               return 0;
> -
> -       rcu_read_lock();
> -       if (!thread_group_leader(parent))
> -               parent = rcu_dereference(parent->group_leader);
> -       while (walker->pid > 0) {
> -               if (!thread_group_leader(walker))
> -                       walker = rcu_dereference(walker->group_leader);
> -               if (walker == parent) {
> -                       rc = 1;
> -                       break;
> -               }
> -               walker = rcu_dereference(walker->real_parent);
> -       }
> -       rcu_read_unlock();
> -
> -       return rc;
> -}
> -
> -/**
>   * ptracer_exception_found - tracer registered as exception for this tracee
>   * @tracer: the task_struct of the process attempting ptrace
>   * @tracee: the task_struct of the process to be ptraced

--
paul moore
www.paul-moore.com
