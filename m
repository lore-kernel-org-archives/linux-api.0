From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Wed, 24 Jul 2019 20:14:26 +0200
Message-ID: <CAG48ez3nuY__qvctoOnX7mQbjjP4chEs4K-OPxSQficiPLS18w@mail.gmail.com>
References: <20190724144651.28272-1-christian@brauner.io> <20190724144651.28272-5-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190724144651.28272-5-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: kernel list <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, "Joel Fernandes (Google)" <joel@joelfernandes.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, kernel-team <kernel-team@android.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 24, 2019 at 4:48 PM Christian Brauner <christian@brauner.io> wrote:
> If CLONE_WAIT_PID is set the newly created process will not be
> considered by process wait requests that wait generically on children
> such as:
>
>         syscall(__NR_wait4, -1, wstatus, options, rusage)
>         syscall(__NR_waitpid, -1, wstatus, options)
>         syscall(__NR_waitid, P_ALL, -1, siginfo, options, rusage)
>         syscall(__NR_waitid, P_PGID, -1, siginfo, options, rusage)
>         syscall(__NR_waitpid, -pid, wstatus, options)
>         syscall(__NR_wait4, -pid, wstatus, options, rusage)
>
> A process created with CLONE_WAIT_PID can only be waited upon with a
> focussed wait call. This ensures that processes can be reaped even if
> all file descriptors referring to it are closed.
[...]
> diff --git a/kernel/fork.c b/kernel/fork.c
> index baaff6570517..a067f3876e2e 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1910,6 +1910,8 @@ static __latent_entropy struct task_struct *copy_process(
>         delayacct_tsk_init(p);  /* Must remain after dup_task_struct() */
>         p->flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER | PF_IDLE);
>         p->flags |= PF_FORKNOEXEC;
> +       if (clone_flags & CLONE_WAIT_PID)
> +               p->flags |= PF_WAIT_PID;
>         INIT_LIST_HEAD(&p->children);
>         INIT_LIST_HEAD(&p->sibling);
>         rcu_copy_process(p);

This means that if a process with PF_WAIT_PID forks, the child
inherits the flag, right? That seems unintended? You might have to add
something like "if (clone_flags & CLONE_THREAD == 0) p->flags &=
~PF_WAIT_PID;" before this. (I think threads do have to inherit the
flag so that the case where a non-leader thread of the child goes
through execve and steals the leader's identity is handled properly.)
Or you could cram it somewhere into signal_struct instead of on the
task - that might be a more logical place for it?
