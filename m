From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 20:30:19 +0100
Message-ID: <20181206193017.wpxls5p3zgjd6rv2@brauner.io>
References: <20181206121858.12215-1-christian@brauner.io>
 <87sgzahf7k.fsf@xmission.com>
 <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io>
 <875zw6bh2z.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <875zw6bh2z.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 06, 2018 at 01:17:24PM -0600, Eric W. Biederman wrote:
> Christian Brauner <christian@brauner.io> writes:
> 
> > On December 7, 2018 4:01:19 AM GMT+13:00, ebiederm@xmission.com wrote:
> >>Christian Brauner <christian@brauner.io> writes:
> >>
> >>> The kill() syscall operates on process identifiers (pid). After a
> >>process
> >>> has exited its pid can be reused by another process. If a caller
> >>sends a
> >>> signal to a reused pid it will end up signaling the wrong process.
> >>This
> >>> issue has often surfaced and there has been a push [1] to address
> >>this
> >>> problem.
> >>>
> >>> This patch uses file descriptors (fd) from proc/<pid> as stable
> >>handles on
> >>> struct pid. Even if a pid is recycled the handle will not change. The
> >>fd
> >>> can be used to send signals to the process it refers to.
> >>> Thus, the new syscall taskfd_send_signal() is introduced to solve
> >>this
> >>> problem. Instead of pids it operates on process fds (taskfd).
> >>
> >>I am not yet thrilled with the taskfd naming.
> >
> > Userspace cares about what does this thing operate on?
> > It operates on processes and threads.
> > The most common term people use is "task".
> > I literally "polled" ten non-kernel people for that purpose and asked:
> > "What term would you use to refer to a process and a thread?"
> > Turns out it is task. So if find this pretty apt.
> > Additionally, the proc manpage uses task in the exact same way (also see the commit message).
> > If you can get behind that name even if feeling it's not optimal it would be great.
> 
> Once I understand why threads and not process groups.  I don't see that
> logic yet.

The point is: userspace takes "task" to be a generic term for processes
and tasks. Which is what is important. The term also covers process
groups for all that its worth. Most of userspace isn't even aware of
that distinction necessarily.

fd_send_signal() makes the syscall name meaningless: what is userspace
signaling too? The point being that there's a lot more that you require
userspace to infer from fd_send_signal() than from task_send_signal()
where most people get the right idea right away: "signals to a process
or thread".

> 
> >>Is there any plan to support sesssions and process groups?
> >
> > I don't see the necessity.
> > As I said in previous mails:
> > we can emulate all interesting signal syscalls with this one.
> 
> I don't know what you mean by all of the interesting signal system
> calls.  I do know you can not replicate kill(2).

[1]: You cannot replicate certain aspects of kill *yet*. We have
established this before. If we want process group support later we do
have the flags argument to extend the sycall.

> 
> Sending signals to a process group the "kill(-pgrp)" case with kill
> sends the signals to an atomic snapshot of processes.  If the signal
> is SIGKILL then it is guaranteed that then entire process group is
> killed with no survivors.

See [1].

> 
> > We succeeded in doing that.
> 
> I am not certain you have.

See [1].

> 
> > No need to get more fancy.
> > There's currently no obvious need for more features.
> > Features should be implemented when someone actually needs them.
> 
> That is fair.  I don't understand what you are doing with sending
> signals to a thread.  That seems like one of the least useful
> corner cases of sending signals.

It's what glibc and Florian care about for pthreads and their our
biggest user atm so they get some I'd argue they get some say in this. :)

> 
> Eric
