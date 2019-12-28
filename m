From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH v7 2/3] pid: Introduce pidfd_getfd syscall
Date: Sat, 28 Dec 2019 08:03:23 -0500
Message-ID: <CAMp4zn9LyGw=BNiLNRgZXAbFdi87pSjy1YmDXvFvwmA=u3yDyw@mail.gmail.com>
References: <20191226180334.GA29409@ircssh-2.c.rugged-nimbus-611.internal> <20191228100944.kh22bofbr5oe2kvk@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191228100944.kh22bofbr5oe2kvk@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <ealvarez@mozilla.com>, Florian Weimer <fweimer@redhat.com>, Jed Davis <jld@mozilla.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 28, 2019 at 5:12 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Thu, Dec 26, 2019 at 06:03:36PM +0000, Sargun Dhillon wrote:
> > This syscall allows for the retrieval of file descriptors from other
> > processes, based on their pidfd. This is possible using ptrace, and
> > injection of parasitic code to inject code which leverages SCM_RIGHTS
> > to move file descriptors between a tracee and a tracer. Unfortunately,
> > ptrace comes with a high cost of requiring the process to be stopped,
> > and breaks debuggers. This does not require stopping the process under
> > manipulation.
> >
> > One reason to use this is to allow sandboxers to take actions on file
> > descriptors on the behalf of another process. For example, this can be
> > combined with seccomp-bpf's user notification to do on-demand fd
> > extraction and take privileged actions. One such privileged action
> > is binding a socket to a privileged port.
> >
> > This also adds the syscall to all architectures at the same time.
> >
> > /* prototype */
> >   /* flags is currently reserved and should be set to 0 */
> >   int sys_pidfd_getfd(int pidfd, int fd, unsigned int flags);
> >
> > /* testing */
> > Ran self-test suite on x86_64
>
> Fyi, I'm likely going to rewrite/add parts of/to this once I apply.
>
> A few comments below.
>
> > diff --git a/kernel/pid.c b/kernel/pid.c
> > index 2278e249141d..4a551f947869 100644
> > --- a/kernel/pid.c
> > +++ b/kernel/pid.c
> > @@ -578,3 +578,106 @@ void __init pid_idr_init(void)
> >       init_pid_ns.pid_cachep = KMEM_CACHE(pid,
> >                       SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
> >  }
> > +
> > +static struct file *__pidfd_fget(struct task_struct *task, int fd)
> > +{
> > +     struct file *file;
> > +     int ret;
> > +
> > +     ret = mutex_lock_killable(&task->signal->cred_guard_mutex);
> > +     if (ret)
> > +             return ERR_PTR(ret);
> > +
> > +     if (!ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS)) {
> > +             file = ERR_PTR(-EPERM);
> > +             goto out;
> > +     }
> > +
> > +     file = fget_task(task, fd);
> > +     if (!file)
> > +             file = ERR_PTR(-EBADF);
> > +
> > +out:
> > +     mutex_unlock(&task->signal->cred_guard_mutex);
> > +     return file;
> > +}
>
> Looking at this code now a bit closer, ptrace_may_access() and
> fget_task() both take task_lock(task) so this currently does:
>
> task_lock();
> /* check access */
> task_unlock();
>
> task_lock();
> /* get fd */
> task_unlock();
>
> which doesn't seem great.
>
> I would prefer if we could do:
> task_lock();
> /* check access */
> /* get fd */
> task_unlock();
>
> But ptrace_may_access() doesn't export an unlocked variant so _shrug_.
Right, it seems intentional that __ptrace_may_access isn't exported. We
can always change that later?

>
> But we can write this a little cleaner without the goto as:
>
> static struct file *__pidfd_fget(struct task_struct *task, int fd)
> {
>         struct file *file;
>         int ret;
>
>         ret = mutex_lock_killable(&task->signal->cred_guard_mutex);
>         if (ret)
>                 return ERR_PTR(ret);
>
>         if (ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
>                 file = fget_task(task, fd);
>         else
>                 file = ERR_PTR(-EPERM);
>         mutex_unlock(&task->signal->cred_guard_mutex);
>
>         return file ?: ERR_PTR(-EBADF);
> }
>
> If you don't like the ?: just do:
>
> if (!file)
>         return ERR_PTR(-EBADF);
>
> return file;
>
> though I prefer the shorter ?: syntax which is perfect for shortcutting
> returns.
>
> > +
> > +static int pidfd_getfd(struct pid *pid, int fd)
> > +{
> > +     struct task_struct *task;
> > +     struct file *file;
> > +     int ret, retfd;
> > +
> > +     task = get_pid_task(pid, PIDTYPE_PID);
> > +     if (!task)
> > +             return -ESRCH;
> > +
> > +     file = __pidfd_fget(task, fd);
> > +     put_task_struct(task);
> > +     if (IS_ERR(file))
> > +             return PTR_ERR(file);
> > +
> > +     retfd = get_unused_fd_flags(O_CLOEXEC);
> > +     if (retfd < 0) {
> > +             ret = retfd;
> > +             goto out;
> > +     }
> > +
> > +     /*
> > +      * security_file_receive must come last since it may have side effects
> > +      * and cannot be reversed.
> > +      */
> > +     ret = security_file_receive(file);
>
> So I don't understand the comment here. Can you explain what the side
> effects are?
The LSM can modify the LSM blob, or emit an (audit) event, even though
the operation as a whole failed. Smack will report that file_receive
successfully happened even though it could not have happened,
because we were unable to provision a file descriptor.

Apparmor does similar, and also manipulates the LSM blob,
although that is undone by closing the file.


> security_file_receive() is called in two places: net/core/scm.c and
> net/compat.c. In both places it is called _before_ get_unused_fd_flags()
> so I don't know what's special here that would prevent us from doing the
> same. If there's no actual reason, please rewrite this functions as:
>
> static int pidfd_getfd(struct pid *pid, int fd)
> {
>         int ret;
>         struct task_struct *task;
>         struct file *file;
>
>         task = get_pid_task(pid, PIDTYPE_PID);
>         if (!task)
>                 return -ESRCH;
>
>         file = __pidfd_fget(task, fd);
>         put_task_struct(task);
>         if (IS_ERR(file))
>                 return PTR_ERR(file);
>
>         ret = security_file_receive(file);
>         if (ret) {
>                 fput(file);
>                 return ret;
>         }
>
>         ret = get_unused_fd_flags(O_CLOEXEC);
>         if (ret < 0)
>                 fput(file);
>         else
>                 fd_install(ret, file);
>
>         return ret;
> }
