From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v6 4/6] task_isolation: provide strict mode configurable signal
Date: Fri, 28 Aug 2015 12:22:39 -0700
Message-ID: <CALCETrXQY3PvLaZXQgN1bw5s7JP6LZSZzChRziFenAiQWA3XpQ@mail.gmail.com>
References: <1440532555-15492-1-git-send-email-cmetcalf@ezchip.com> <1440532555-15492-5-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1440532555-15492-5-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 25, 2015 at 12:55 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> Allow userspace to override the default SIGKILL delivered
> when a task_isolation process in STRICT mode does a syscall
> or otherwise synchronously enters the kernel.
>
> In addition to being able to set the signal, we now also
> pass whether or not the interruption was from a syscall in
> the si_code field of the siginfo.
>
> Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
> ---
>  include/uapi/linux/prctl.h |  2 ++
>  kernel/isolation.c         | 17 +++++++++++++----
>  2 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index e16e13911e8a..2a4ddc890e22 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -195,5 +195,7 @@ struct prctl_mm_map {
>  #define PR_GET_TASK_ISOLATION          48
>  # define PR_TASK_ISOLATION_ENABLE      (1 << 0)
>  # define PR_TASK_ISOLATION_STRICT      (1 << 1)
> +# define PR_TASK_ISOLATION_SET_SIG(sig)        (((sig) & 0x7f) << 8)
> +# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
>
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/isolation.c b/kernel/isolation.c
> index a89a6e9adfb4..b776aa632c8f 100644
> --- a/kernel/isolation.c
> +++ b/kernel/isolation.c
> @@ -75,11 +75,20 @@ void task_isolation_enter(void)
>         }
>  }
>
> -static void kill_task_isolation_strict_task(void)
> +static void kill_task_isolation_strict_task(int is_syscall)
>  {
> +       siginfo_t info = {};
> +       int sig;
> +
>         dump_stack();
>         current->task_isolation_flags &= ~PR_TASK_ISOLATION_ENABLE;
> -       send_sig(SIGKILL, current, 1);
> +
> +       sig = PR_TASK_ISOLATION_GET_SIG(current->task_isolation_flags);
> +       if (sig == 0)
> +               sig = SIGKILL;
> +       info.si_signo = sig;
> +       info.si_code = is_syscall;
> +       send_sig_info(sig, &info, current);

The stuff you're doing here is sufficiently nasty that I think you
should add something like:

rcu_lockdep_assert(rcu_is_watching(), "some message here");

Because as it stands this is just asking for trouble.

For the record, I am *extremely* unhappy with the state of the context
tracking hooks.

--Andy
