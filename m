From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Mon, 19 Nov 2018 01:40:39 +0100
Message-ID: <20181119004037.d4avmjyiooa7ujyf@brauner.io>
References: <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
 <20181118190504.ixglsqbn6mxkcdzu@yavin>
 <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
 <608F2959-800D-46EE-A7CD-8C972ACD2F02@amacapital.net>
 <20181118204317.seaztq7fqmysucns@brauner.io>
 <CAKOZueuWzu2GuJ-w3yb01P9uyO1WniKG+i=BUsweVdA-KgEjhw@mail.gmail.com>
 <20181118212336.53hh3qbjughrtc2l@brauner.io>
 <20181118213021.24asgwkci3do6oby@brauner.io>
 <CAKOZuetT8mzZJR-K_W0VM7Dg1c1SnH8tW-HXxMT77yS0DE453w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuetT8mzZJR-K_W0VM7Dg1c1SnH8tW-HXxMT77yS0DE453w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 04:31:22PM -0800, Daniel Colascione wrote:
> On Sun, Nov 18, 2018 at 1:30 PM, Christian Brauner <christian@brauner.io> wrote:
> > On Sun, Nov 18, 2018 at 10:23:36PM +0100, Christian Brauner wrote:
> >> On Sun, Nov 18, 2018 at 12:54:10PM -0800, Daniel Colascione wrote:
> >> > On Sun, Nov 18, 2018 at 12:43 PM, Christian Brauner
> >> > <christian@brauner.io> wrote:
> >> > > On Sun, Nov 18, 2018 at 01:28:41PM -0700, Andy Lutomirski wrote:
> >> > >>
> >> > >>
> >> > >> > On Nov 18, 2018, at 12:44 PM, Daniel Colascione <dancol@google.com> wrote:
> >> > >> >
> >> > >>
> >> > >> >
> >> > >> > That is, I'm proposing an API that looks like this:
> >> > >> >
> >> > >> > int process_kill(int procfs_dfd, int signo, const union sigval value)
> >> > >> >
> >> > >> > If, later, process_kill were to *also* accept process-capability FDs,
> >> > >> > nothing would break.
> >> > >>
> >> > >> Except that this makes it ambiguous to the caller as to whether their current creds are considered.  So it would need to be a different syscall or at least a flag.  Otherwise a lot of those nice theoretical properties go away.
> >> > >
> >> > > I can add a flag argument
> >> > > int process_signal(int procfs_dfd, int signo, siginfo_t *info, int flags)
> >> > > The way I see it process_signal() should be equivalent to kill(pid, signal) for now.
> >> > > That is siginfo_t is cleared and set to:
> >> > >
> >> > > info.si_signo = sig;
> >> > > info.si_errno = 0;
> >> > > info.si_code = SI_USER;
> >> > > info.si_pid = task_tgid_vnr(current);
> >> > > info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> >> >
> >> > That makes sense. I just don't want to get into a situation where
> >> > callers feel that they *have* to use the PID-based APIs to send a
> >> > signal because process_kill doesn't offer some bit of functionality.
> >>
> >> Yeah.
> >>
> >> >
> >> > Are you imagining something like requiring info t be NULL unless flags
> >> > contains some "I have a siginfo_t" value?
> >>
> >> Well, I was actually thinking about something like:
> >>
> >> /**
> >>  *  sys_process_signal - send a signal to a process trough a process file descriptor
> >>  *  @fd: the file descriptor of the process
> >>  *  @sig: signal to be sent
> >>  *  @info: the signal info
> >>  *  @flags: future flags to be passed
> >>  */
> >> SYSCALL_DEFINE4(process_signal, int, fd, int, sig, siginfo_t __user *, info,
> >>               int, flags)
> >> {
> >>       struct pid *pid;
> >>       struct fd *f;
> >>       kernel_siginfo_t kinfo;
> >>
> >>       /* Do not allow users to pass garbage. */
> >>       if (flags)
> >>               return -EINVAL;
> >>
> >>       int ret = __copy_siginfo_from_user(sig, &kinfo, info);
> >>       if (unlikely(ret))
> >>               return ret;
> >>
> >>       /* For now, enforce that caller's creds are used. */
> >>       kinfo.si_pid = task_tgid_vnr(current);
> >>       kinfo.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> 
> How about doing it this way? If info is NULL, act like kill(2);
> otherwise, act like rt_sigqueueinfo(2).
> 
> (Not actual working or compiled code.)
> 
> SYSCALL_DEFINE4(process_signal, int, fd, int, sig, siginfo_t __user *, info,
>               int, flags)
> {
>         struct fd f = { 0 };
>         kernel_siginfo_t kinfo;
>         int ret;
> 
>         /* Make API extension possible.  */
>         ret = -EINVAL;
>         if (flags)
>                 goto out;
> 
>         ret = -EBADF;
>         f = fdget(fd);
>         if (!f.file)
>                 goto out;
> 
>         ret = mumble_mumble_check_real_proc_file(f.file);
>         if (ret)
>                 goto out;
> 
>         /* Act like kill(2) or rt_sigqueueinfo(2) depending on whether
>          * the user gave us a siginfo structure.
>          */
>         if (info) {
>                 ret = __copy_siginfo_from_user(sig, &kinfo, info);
>                 if (ret)
>                         goto out;
>                 /* Combine this logic with rt_sigqueueinfo(2) */
>                 ret = -EPERM;
>                 if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
>                     (task_pid_vnr(current) != pid))
>                         goto out;
> 
>         } else {
>                 /* Combine this logic with kill(2) */
>                 clear_siginfo(&kinfo);
>                 kinfo.si_signo = sig;
>                 kinfo.si_errno = 0;
>                 kinfo.si_code = SI_USER;
>                 kinfo.si_pid = task_tgid_vnr(current);
>                 kinfo.si_uid = from_kuid_munged(current_user_ns(),
> current_uid());
>         }
> 
>         ret = kill_pid_info(sig, &kinfo, proc_pid(file_inode(f.file)));
> 
> out:
>         if (f.file)
>                 fput(f);
>         return ret;
> }

Right, allowing to ass NULL might make sense. I had:

/**
 *  sys_process_signal - send a signal to a process trough a process file descriptor
 *  @fd: the file descriptor of the process
 *  @sig: signal to be sent
 *  @info: the signal info
 *  @flags: future flags to be passed
 */
SYSCALL_DEFINE4(procfd_kill, int, fd, int, sig, siginfo_t __user *, info, int, flags)
{
       int ret;
       struct pid *pid;
       kernel_siginfo_t kinfo;
       struct fd f;

       /* Do not allow users to pass garbage. */
       if (flags)
               return -EINVAL;

       ret = __copy_siginfo_from_user(sig, &kinfo, info);
       if (unlikely(ret))
               return ret;

       /* For now, enforce that caller's creds are used. */
       kinfo.si_pid = task_tgid_vnr(current);
       kinfo.si_uid = from_kuid_munged(current_user_ns(), current_uid());

       f = fdget_raw(fd);
       if (!f.file)
               return -EBADF;

       ret = -EINVAL;
       /* Is this a process file descriptor? */
       if (!proc_is_procfd(f.file) || !d_is_dir(f.file->f_path.dentry))
               goto err;

       pid = f.file->private_data;
       if (!pid)
               goto err;

       ret = -EPERM;
       /*
        * Not even root can pretend to send signals from the kernel.
        * Nor can they impersonate a kill()/tgkill(), which adds source info.
        */
       if ((kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL) &&
           (task_pid(current) != pid))
               goto err;

       ret = kill_pid_info(sig, &kinfo, pid);

err:
       fdput(f);
       return ret;
}
