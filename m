From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH v3 2/4] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Mon, 16 Dec 2019 18:49:37 -0800
Message-ID: <CAMp4zn8fzeiJVSn6EtRi6UAGh6AL3QWu=PZxw+=TAYJORjn_Sw@mail.gmail.com>
References: <20191217010001.GA14461@ircssh-2.c.rugged-nimbus-611.internal> <20191217015001.sp6mrhuiqrivkq3u@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191217015001.sp6mrhuiqrivkq3u@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, cyphar@cyphar.com, oleg@redhat.com, Andy Lutomirski <luto@amacapital.net>, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 16, 2019 at 5:50 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> [Cc Arnd since he fiddled with ioctl()s quite a bit recently.]
>
>
> That should be pidfd.h and the resulting new file be placed under the
> pidfd entry in maintainers:
> +F:     include/uapi/linux/pidfd.h
>
> >
> >  enum pid_type
> >  {
> > diff --git a/include/uapi/linux/pid.h b/include/uapi/linux/pid.h
> > new file mode 100644
> > index 000000000000..4ec02ed8b39a
> > --- /dev/null
> > +++ b/include/uapi/linux/pid.h
> > @@ -0,0 +1,26 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_LINUX_PID_H
> > +#define _UAPI_LINUX_PID_H
> > +
> > +#include <linux/types.h>
> > +#include <linux/ioctl.h>
> > +
> > +/* options to pass in to pidfd_getfd_args flags */
> > +#define PIDFD_GETFD_CLOEXEC (1 << 0) /* open the fd with cloexec */
>
> Please, make them cloexec by default unless there's a very good reason
> not to.
>
For now then, should I have flags, and just say "reserved for future usage",
or would you prefer that I drop flags entirely?

> > +
> > +struct pidfd_getfd_args {
> > +     __u32 size;             /* sizeof(pidfd_getfd_args) */
> > +     __u32 fd;       /* the tracee's file descriptor to get */
> > +     __u32 flags;
> > +};
>
> I think you want to either want to pad this
>
> +struct pidfd_getfd_args {
> +       __u32 size;             /* sizeof(pidfd_getfd_args) */
> +       __u32 fd;       /* the tracee's file descriptor to get */
> +       __u32 flags;
>         __u32 reserved;
> +};
>
> or use __aligned_u64 everywhere which I'd personally prefer instead of
> this manual padding everywhere.
>
Wouldn't __attribute__((packed)) achieve a similar thing of making sure
the struct is a constant size across all compilers?

I'll go with __aligned_u64 instead of packed, if you don't want to use packed.

> > +
> > +#define PIDFD_IOC_MAGIC                      'p'
> > +#define PIDFD_IO(nr)                 _IO(PIDFD_IOC_MAGIC, nr)
> > +#define PIDFD_IOR(nr, type)          _IOR(PIDFD_IOC_MAGIC, nr, type)
> > +#define PIDFD_IOW(nr, type)          _IOW(PIDFD_IOC_MAGIC, nr, type)
> > +#define PIDFD_IOWR(nr, type)         _IOWR(PIDFD_IOC_MAGIC, nr, type)
> > +
> > +#define PIDFD_IOCTL_GETFD            PIDFD_IOWR(0xb0, \
> > +                                             struct pidfd_getfd_args)
> > +
> > +#endif /* _UAPI_LINUX_PID_H */
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 6cabc124378c..d9971e664e82 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1726,9 +1726,81 @@ static __poll_t pidfd_poll(struct file *file, struct poll_table_struct *pts)
> >       return poll_flags;
> >  }
> >
> > +static long pidfd_getfd(struct pid *pid, struct pidfd_getfd_args __user *buf)
> > +{
> > +     struct pidfd_getfd_args args;
> > +     unsigned int fd_flags = 0;
> > +     struct task_struct *task;
> > +     struct file *file;
> > +     u32 user_size;
> > +     int ret, fd;
> > +
> > +     ret = get_user(user_size, &buf->size);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = copy_struct_from_user(&args, sizeof(args), buf, user_size);
> > +     if (ret)
> > +             return ret;
> > +     if ((args.flags & ~(PIDFD_GETFD_CLOEXEC)) != 0)
> > +             return -EINVAL;
>
> Nit: It's more common - especially in this file - to do
>
> if (args.flags & ~PIDFD_GETFD_CLOEXEC)
>         return -EINVAL;
>
> > +     if (args.flags & PIDFD_GETFD_CLOEXEC)
> > +             fd_flags |= O_CLOEXEC;
> > +
I'll drop this bit, and just make it CLOEXEC by default.

> > +     task = get_pid_task(pid, PIDTYPE_PID);
> > +     if (!task)
> > +             return -ESRCH;
>
> \n
>
> > +     ret = -EPERM;
> > +     if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
> > +             goto out;
>
> \n
>
> Please don't pre-set errors unless they are used by multiple exit paths.
> if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
>         ret = -EPERM;
>         goto out;
> }
>
> > +     ret = -EBADF;
> > +     file = fget_task(task, args.fd);
> > +     if (!file)
> > +             goto out;
>
> Same.
>
> > +
> > +     fd = get_unused_fd_flags(fd_flags);
> > +     if (fd < 0) {
> > +             ret = fd;
> > +             goto out_put_file;
> > +     }
>
> \n
>
> > +     /*
> > +      * security_file_receive must come last since it may have side effects
> > +      * and cannot be reversed.
> > +      */
> > +     ret = security_file_receive(file);
> > +     if (ret)
> > +             goto out_put_fd;
> > +
> > +     fd_install(fd, file);
> > +     put_task_struct(task);
> > +     return fd;
> > +
> > +out_put_fd:
> > +     put_unused_fd(fd);
> > +out_put_file:
> > +     fput(file);
> > +out:
> > +     put_task_struct(task);
> > +     return ret;
> > +}
> > +
> > +static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > +{
> > +     struct pid *pid = file->private_data;
> > +     void __user *buf = (void __user *)arg;
> > +
> > +     switch (cmd) {
> > +     case PIDFD_IOCTL_GETFD:
> > +             return pidfd_getfd(pid, buf);
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +}
> > +
> >  const struct file_operations pidfd_fops = {
> >       .release = pidfd_release,
> >       .poll = pidfd_poll,
> > +     .unlocked_ioctl = pidfd_ioctl,
> >  #ifdef CONFIG_PROC_FS
> >       .show_fdinfo = pidfd_show_fdinfo,
> >  #endif
> > --
> > 2.20.1
> >
