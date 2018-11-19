From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 19:39:36 +0100
Message-ID: <20181119183931.tkz7hfruw2ekqh62@brauner.io>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <CALCETrUY=Hk6=BjgPuDBgj5J1T_b5Q5u1uVOWHjGWXwmHoZBEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUY=Hk6=BjgPuDBgj5J1T_b5Q5u1uVOWHjGWXwmHoZBEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 07:45:04AM -0800, Andy Lutomirski wrote:
> On Mon, Nov 19, 2018 at 2:33 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > The kill() syscall operates on process identifiers. After a process has
> > exited its pid can be reused by another process. If a caller sends a signal
> > to a reused pid it will end up signaling the wrong process. This issue has
> > often surfaced and there has been a push [1] to address this problem.
> >
> > A prior patch has introduced the ability to get a file descriptor
> > referencing struct pid by opening /proc/<pid>. This guarantees a stable
> > handle on a process which can be used to send signals to the referenced
> > process. Discussion has shown that a dedicated syscall is preferable over
> > ioctl()s. Thus, the  new syscall procfd_signal() is introduced to solve
> > this problem. It operates on a process file descriptor.
> > The syscall takes an additional siginfo_t and flags argument. If siginfo_t
> > is NULL then procfd_signal() behaves like kill() if it is not NULL it
> > behaves like rt_sigqueueinfo.
> > The flags argument is added to allow for future extensions of this syscall.
> > It currently needs to be passed as 0.
> 
> A few questions.  First: you've made this work on /proc/PID, but
> should it also work on /proc/PID/task/TID to send signals to a
> specific thread?

Yeah, so I thought about that. Your point being to combine: kill(),
tgkill() aka rt_sigqueueinfo() and rt_tg_sigqueueinfo(). If I understand
this correctly the implication is to also get file descriptors to
/proc/PID/task/TID and pass them to procfd_signal()? Can we hold of on
that one? Adding this in the future should be easily doable by simply
getting /proc/PID/task/TID file descriptors but I would like this
patchset to be as small as possible.

> 
> > +bool proc_is_procfd(const struct file *file)
> > +{
> > +       return d_is_dir(file->f_path.dentry) &&
> > +              (file->f_op == &proc_tgid_base_operations);
> > +}
> 
> Maybe rename to proc_is_tgid_procfd() to leave room for proc_is_tid_procfd()?

Yes, good idea!

> 
> > +       if (info) {
> > +               ret = __copy_siginfo_from_user(sig, &kinfo, info);
> > +               if (unlikely(ret))
> > +                       goto err;
> > +               /*
> > +                * Not even root can pretend to send signals from the kernel.
> > +                * Nor can they impersonate a kill()/tgkill(), which adds
> > +                * source info.
> > +                */
> > +               ret = -EPERM;
> > +               if ((kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL) &&
> > +                   (task_pid(current) != pid))
> > +                       goto err;
> 
> Is the exception for signaling yourself actually useful here?

I tried to strictly follow the sigqueue-based permission checks. I'm not
comfortable removing this check without signal-experts telling me that
it is safe to do.
