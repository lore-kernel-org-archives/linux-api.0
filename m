From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 12:37:20 -0800
Message-ID: <CAKOZuevgPv1CbAZF-ha0njdq6rd6QkU7T8qmmERJLsL45CeVzg@mail.gmail.com>
References: <20181206121858.12215-1-christian@brauner.io> <87sgzahf7k.fsf@xmission.com>
 <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io> <875zw6bh2z.fsf@xmission.com>
 <20181206193017.wpxls5p3zgjd6rv2@brauner.io> <871s6u9z6u.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <871s6u9z6u.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 6, 2018 at 12:29 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Christian Brauner <christian@brauner.io> writes:
>
> > On Thu, Dec 06, 2018 at 01:17:24PM -0600, Eric W. Biederman wrote:
> >> Christian Brauner <christian@brauner.io> writes:
> >>
> >> > On December 7, 2018 4:01:19 AM GMT+13:00, ebiederm@xmission.com wrote:
> >> >>Christian Brauner <christian@brauner.io> writes:
> >> >>
> >> >>> The kill() syscall operates on process identifiers (pid). After a
> >> >>process
> >> >>> has exited its pid can be reused by another process. If a caller
> >> >>sends a
> >> >>> signal to a reused pid it will end up signaling the wrong process.
> >> >>This
> >> >>> issue has often surfaced and there has been a push [1] to address
> >> >>this
> >> >>> problem.
> >> >>>
> >> >>> This patch uses file descriptors (fd) from proc/<pid> as stable
> >> >>handles on
> >> >>> struct pid. Even if a pid is recycled the handle will not change. The
> >> >>fd
> >> >>> can be used to send signals to the process it refers to.
> >> >>> Thus, the new syscall taskfd_send_signal() is introduced to solve
> >> >>this
> >> >>> problem. Instead of pids it operates on process fds (taskfd).
> >> >>
> >> >>I am not yet thrilled with the taskfd naming.
> >> >
> >> > Userspace cares about what does this thing operate on?
> >> > It operates on processes and threads.
> >> > The most common term people use is "task".
> >> > I literally "polled" ten non-kernel people for that purpose and asked:
> >> > "What term would you use to refer to a process and a thread?"
> >> > Turns out it is task. So if find this pretty apt.
> >> > Additionally, the proc manpage uses task in the exact same way (also see the commit message).
> >> > If you can get behind that name even if feeling it's not optimal it would be great.
> >>
> >> Once I understand why threads and not process groups.  I don't see that
> >> logic yet.
> >
> > The point is: userspace takes "task" to be a generic term for processes
> > and tasks. Which is what is important. The term also covers process
> > groups for all that its worth. Most of userspace isn't even aware of
> > that distinction necessarily.
> >
> > fd_send_signal() makes the syscall name meaningless: what is userspace
> > signaling too? The point being that there's a lot more that you require
> > userspace to infer from fd_send_signal() than from task_send_signal()
> > where most people get the right idea right away: "signals to a process
> > or thread".
> >
> >>
> >> >>Is there any plan to support sesssions and process groups?
> >> >
> >> > I don't see the necessity.
> >> > As I said in previous mails:
> >> > we can emulate all interesting signal syscalls with this one.
> >>
> >> I don't know what you mean by all of the interesting signal system
> >> calls.  I do know you can not replicate kill(2).
> >
> > [1]: You cannot replicate certain aspects of kill *yet*. We have
> > established this before. If we want process group support later we do
> > have the flags argument to extend the sycall.
>
> Then you have horrible contradiction in the API.
>
> Either the grouping is a property of your file descriptor or the
> grouping comes from the flags argument.
>
> If the grouping is specified in the flags argument then pidfd is the
> proper name for your file descriptors, and the appropriate prefix
> for your system call.

Yes and no. "taskfd" is fine, since even if we do add a
kill-process-group capability, the general facility under discussion
is still *about* tasks in general, so "taskfd" still tells you in a
general sense what the thing does. "pidfd" would be wrong, and for the
same reason that the kernel's "struct pid" is badly-named: the object
being named is a *task*, and signaling a particular task instead of
whatever task happens to be labeled with a particular numeric PID at
the time of all is the whole point of this change.

> If the grouping is a property of your file descriptor it does not make
> sense to talk about using the flags argument later.
>
> Your intention is to add the thread case to support pthreads once the
> process case is sorted out.  So this is something that needs to be made
> clear.  Did I miss how you plan to handle threads?
>
> And this fundamentally and definitely gets into all of my concerns about
> proper handling of pid_task and PIDTYPE_TGID etc.

To the extent that it's possible, this system call should mimic the
behavior of a signal-send to a positive numeric PID (i.e., a specific
task), so if we change one, we should change both.
