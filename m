From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Fri, 28 Sep 2018 01:37:40 +0200
Message-ID: <CAG48ez0Zs1FCjyQsXp5aDGVxBsF=EuaQc9xrq_OiRT6ScXb3WQ@mail.gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws> <20180927151119.9989-2-tycho@tycho.ws>
 <CAG48ez05LyQOb4pw5H74VhHdQFDEOPLoLuhDPMEqFG7W1hwA_Q@mail.gmail.com> <20180927230408.GH15491@cisco.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927230408.GH15491@cisco.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: hch@lst.de, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp
List-Id: linux-api@vger.kernel.org

On Fri, Sep 28, 2018 at 1:04 AM Tycho Andersen <tycho@tycho.ws> wrote:
> On Thu, Sep 27, 2018 at 11:51:40PM +0200, Jann Horn wrote:
> > > +It is worth noting that ``struct seccomp_data`` contains the values of register
> > > +arguments to the syscall, but does not contain pointers to memory. The task's
> > > +memory is accessible to suitably privileged traces via ``ptrace()`` or
> > > +``/proc/pid/map_files/``.
> >
> > You probably don't actually want to use /proc/pid/map_files here; you
> > can't use that to access anonymous memory, and it needs CAP_SYS_ADMIN.
> > And while reading memory via ptrace() is possible, the interface is
> > really ugly (e.g. you can only read data in 4-byte chunks), and your
> > caveat about locking out other ptracers (or getting locked out by
> > them) applies. I'm not even sure if you could read memory via ptrace
> > while a process is stopped in the seccomp logic? PTRACE_PEEKDATA
> > requires the target to be in a __TASK_TRACED state.
> > The two interfaces you might want to use instead are /proc/$pid/mem
> > and process_vm_{readv,writev}, which allow you to do nice,
> > arbitrarily-sized, vectored IO on the memory of another process.
>
> Yes, in fact the sample code does use /proc/$pid/mem, but the docs
> should be correct :)

Please also mention the process_vm_readv/writev syscalls though, given
that fast access to remote processes is what they were made for.

> > > +#ifdef CONFIG_SECCOMP_FILTER
> > > +static int seccomp_notify_release(struct inode *inode, struct file *file)
[...]
> > > +       wake_up_all(&filter->notif->wqh);
> >
> > If select() is polling us, a reference to the open file is being held,
> > and this can't be reached; and I think if epoll is polling us,
> > eventpoll_release() will remove itself from the wait queue, right? So
> > can this wake_up_all() actually ever notify anyone?
>
> I don't know actually, I just thought better safe than sorry. I can
> drop it, though.

Let's see if any fs people have some insight...

> > > +               ret = -ENOENT;
> > > +               goto out;
> > > +       }
> > > +
> > > +       /* Allow exactly one reply. */
> > > +       if (knotif->state != SECCOMP_NOTIFY_SENT) {
> > > +               ret = -EINPROGRESS;
> > > +               goto out;
> > > +       }
> >
> > This means that if seccomp_do_user_notification() has in the meantime
> > received a signal and transitioned from SENT back to INIT, this will
> > fail, right? So we fail here, then we read the new notification, and
> > then we can retry SECCOMP_NOTIF_SEND? Is that intended?
>
> I think so, the idea being that you might want to do something
> different if a signal was sent. But Andy seemed to think that we might
> not actually do anything different.

If you already have the proper response ready, you'd probably want to
just go through with it, no? Otherwise you'll just end up re-emulating
the syscall afterwards for no good reason. If you noticed the
interruption in the middle of the emulated syscall, that'd be
different, but since this is the case where we're already done with
the emulation and getting ready to continue...
