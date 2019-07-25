From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Thu, 25 Jul 2019 12:11:24 +0200
Message-ID: <20190725101123.zp7y2weotyqkfsv3@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-5-christian@brauner.io>
 <CAG48ez3nuY__qvctoOnX7mQbjjP4chEs4K-OPxSQficiPLS18w@mail.gmail.com>
 <CFB4D39F-24B9-4AD9-B19C-E2D14D38A808@brauner.io>
 <CAG48ez1vd4Yhd3DqHVjTWM-N0MaNnX9n8MNV7MEyU5m3XDu+kQ@mail.gmail.com>
 <DB572B9F-4D21-402F-A68B-CD193BBB166C@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DB572B9F-4D21-402F-A68B-CD193BBB166C@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, "Joel Fernandes (Google)" <joel@joelfernandes.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, kernel-team <kernel-team@android.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 24, 2019 at 09:10:20PM +0200, Christian Brauner wrote:
> On July 24, 2019 9:07:54 PM GMT+02:00, Jann Horn <jannh@google.com> wrote:
> >On Wed, Jul 24, 2019 at 8:27 PM Christian Brauner
> ><christian@brauner.io> wrote:
> >> On July 24, 2019 8:14:26 PM GMT+02:00, Jann Horn <jannh@google.com>
> >wrote:
> >> >On Wed, Jul 24, 2019 at 4:48 PM Christian Brauner
> >> ><christian@brauner.io> wrote:
> >> >> If CLONE_WAIT_PID is set the newly created process will not be
> >> >> considered by process wait requests that wait generically on
> >children
> >> >> such as:
> >> >>
> >> >>         syscall(__NR_wait4, -1, wstatus, options, rusage)
> >> >>         syscall(__NR_waitpid, -1, wstatus, options)
> >> >>         syscall(__NR_waitid, P_ALL, -1, siginfo, options, rusage)
> >> >>         syscall(__NR_waitid, P_PGID, -1, siginfo, options, rusage)
> >> >>         syscall(__NR_waitpid, -pid, wstatus, options)
> >> >>         syscall(__NR_wait4, -pid, wstatus, options, rusage)
> >> >>
> >> >> A process created with CLONE_WAIT_PID can only be waited upon with
> >a
> >> >> focussed wait call. This ensures that processes can be reaped even
> >if
> >> >> all file descriptors referring to it are closed.
> >> >[...]
> >> >> diff --git a/kernel/fork.c b/kernel/fork.c
> >> >> index baaff6570517..a067f3876e2e 100644
> >> >> --- a/kernel/fork.c
> >> >> +++ b/kernel/fork.c
> >> >> @@ -1910,6 +1910,8 @@ static __latent_entropy struct task_struct
> >> >*copy_process(
> >> >>         delayacct_tsk_init(p);  /* Must remain after
> >> >dup_task_struct() */
> >> >>         p->flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER | PF_IDLE);
> >> >>         p->flags |= PF_FORKNOEXEC;
> >> >> +       if (clone_flags & CLONE_WAIT_PID)
> >> >> +               p->flags |= PF_WAIT_PID;
> >> >>         INIT_LIST_HEAD(&p->children);
> >> >>         INIT_LIST_HEAD(&p->sibling);
> >> >>         rcu_copy_process(p);
> >> >
> >> >This means that if a process with PF_WAIT_PID forks, the child
> >> >inherits the flag, right? That seems unintended? You might have to
> >add
> >> >something like "if (clone_flags & CLONE_THREAD == 0) p->flags &=
> >> >~PF_WAIT_PID;" before this. (I think threads do have to inherit the
> >> >flag so that the case where a non-leader thread of the child goes
> >> >through execve and steals the leader's identity is handled
> >properly.)
> >> >Or you could cram it somewhere into signal_struct instead of on the
> >> >task - that might be a more logical place for it?
> >>
> >> Hm, CLONE_WAIT_PID is only useable with CLONE_PIDFD which in turn is
> >> not useable with CLONE_THREAD.
> >> But we should probably make that explicit for CLONE_WAIT_PID too.
> >
> >To clarify:
> >
> >This code looks buggy to me because p->flags is inherited from the
> >parent, with the exception of flags that are explicitly stripped out.
> >Since PF_WAIT_PID is not stripped out, this means that if task A
> >creates a child B with clone(CLONE_WAIT_PID), and then task B uses
> >fork() to create a child C, then B will not be able to use
> >wait(&status) to wait for C since C inherited PF_WAIT_PID from B.
> >
> >The obvious way to fix that would be to always strip out PF_WAIT_PID;
> >but that would also be wrong, because if task B creates a thread C,
> >and then C calls execve(), the task_struct of B goes away and B's TGID
> >is taken over by C. When C eventually exits, it should still obey the
> >CLONE_WAIT_PID (since to A, it's all the same process). Therefore, if
> >p->flags is used to track whether the task was created with
> >CLONE_WAIT_PID, PF_WAIT_PID must be inherited if CLONE_THREAD is set.
> >So:
> >
> >diff --git a/kernel/fork.c b/kernel/fork.c
> >index d8ae0f1b4148..b32e1e9a6c9c 100644
> >--- a/kernel/fork.c
> >+++ b/kernel/fork.c
> >@@ -1902,6 +1902,10 @@ static __latent_entropy struct task_struct
> >*copy_process(
> >      delayacct_tsk_init(p);  /* Must remain after dup_task_struct() */
> >        p->flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER | PF_IDLE);
> >        p->flags |= PF_FORKNOEXEC;
> >+       if (!(clone_flags & CLONE_THREAD))
> >+               p->flags &= ~PF_PF_WAIT_PID;
> >+       if (clone_flags & CLONE_WAIT_PID)
> >+               p->flags |= PF_PF_WAIT_PID;
> >        INIT_LIST_HEAD(&p->children);
> >        INIT_LIST_HEAD(&p->sibling);
> >        rcu_copy_process(p);
> >
> >An alternative would be to not use p->flags at all, but instead make
> >this a property of the signal_struct - since the property is shared by
> >all threads, that might make more sense?
> 
> Yeah, thanks for clarifying.
> Now it's more obvious.
> I need to take a look at the signal struct before I can say anything about this.

I've been looking at this a bit late last night.
Putting this in the flags argument of signal_struct would indeed be
possible. But it feels misplaced to me there. I think the implied
semantics by having this part of task_struct are nicer, i.e. the intent
is clearer especially when the task is filtered later on in exit.c.
So unless anyone sees a clear problem or otherwise objects I would keep
it as a property of task_struct for now and fix it up.

Christian
