From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 2/4] clone: add CLONE_PIDFD
Date: Mon, 15 Apr 2019 18:15:28 +0100
Message-ID: <CAGLj2rHpZ92txk2=yf7dtHFcic2H0bGB0=FzEo7w2rNpC2zxDA@mail.gmail.com>
References: <20190414201436.19502-1-christian@brauner.io> <20190414201436.19502-3-christian@brauner.io>
 <20190415105209.GA22204@redhat.com> <20190415114204.ydczeuwmi74wfsuv@brauner.io>
 <20190415132416.GB22204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190415132416.GB22204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 15, 2019 at 2:25 PM Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 04/15, Christian Brauner wrote:
> >
> > > CLONE_PARENT_SETTID doesn't look very usefule, so what if we add
> > >
> > >     if ((clone_flags & (CLONE_PIDFD|CLONE_PARENT_SETTID)) ==
> > >                        (CLONE_PIDFD|CLONE_PARENT_SETTID))
> > >             return ERR_PTR(-EINVAL);
> > >
> > > at the start of copy_process() ?
> > >
> > > Then it can do
> > >
> > >     if (clone_flags & CLONE_PIDFD) {
> > >             retval = pidfd_create(pid, &pidfdf);
> > >             if (retval < 0)
> > >                     goto bad_fork_free_pid;
> > >             retval = put_user(retval, parent_tidptr)
> > >             if (retval < 0)
> > >                     goto bad_fork_free_pid;
> > >     }
> >
> > Uhhh Oleg, that is nifty. I have to say I like that a lot. This would
> > let us return the pid and the pidfd in one go and we can also start
> > pidfd numbering at 0.
>
> Christian, sorry if it was already discussed, but I can't force myself to
> read all the previous discussions ;)
>
> If we forget about CONFIG_PROC_FS, why do we really want to create a file?
>
>
> Suppose we add a global u64 counter incremented by copy_process and reported
> in /proc/$pid/status. Suppose that clone(CLONE_PIDFD) writes this counter to
> *parent_tidptr. Let's denote this counter as UNIQ_PID.
>
> Now, if you want to (say) safely kill a task and you have its UNIQ_PID, you
> can do
>
>         kill_by_pid_uniq(int pid, u64 uniq_pid)
>         {
>                 pidfd = open("/proc/$pid", O_DIRECTORY);
>
>                 status = openat(pidfd, "status");
>                 u64 this_uniq_pid = ... read UNIQ_PID from status ...;
>
>                 if (uniq_pid != this_uniq_pid)
>                         return;
>
>                 pidfd_send_signal(pidfd);
>         }
>
> Why else do we want pidfd?

Apart from what others have already pointed out, there are two other
things I am looking forward to:

* Currently, when ptracing from a thread, waitpid means that I need to
block or constantly loop over with pauses to receive the ptrace
related results, since ptrace is thread directed (and to be able to
poll other event sources as well, eg. to receive further commands over
a pipe/message passing fd), and related waitpid responses only arrive
to the attached thread. The waitfd patchset was rejected on the
grounds that one could use a separate thread to do the waitpid while
polling from the attached thread or a new thread, but due to ptrace
this is false. pidfds would allow for this to work (this does mean
we'd also need to be able to return one at ATTACH/SEIZE time, though).
Note that waitid and other variants throw away a lot of needed
information.

* Descriptors mean you can optionally choose to bind your privileges
to the file descriptor and then pass it around to others. They do not
work this way now but the choice of such an extension has been kept
open. One of the examples is binding one's CAP_KILL capability and
then pass it to another process, so that it can freely signal the said
process (and only that), or be able to optionally poke holes in the
restrictions imposed by PID namespaces (possibly in the future), etc.

>
> Oleg.
>
