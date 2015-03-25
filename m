From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 7/7] clone4: Add a CLONE_FD flag to get task exit
 notification via fd
Date: Wed, 25 Mar 2015 07:53:48 -0700
Message-ID: <20150325145347.GA30137@thin>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <fdec4b70c7cd34e2eacf6a0e41d36f606a696da1.1426376419.git.josh@joshtriplett.org>
 <CAHse=S9F=F8yOcac4ywwQbahZkZjbTGFUfTjy=4Guo_UoMaJkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHse=S9F=F8yOcac4ywwQbahZkZjbTGFUfTjy=4Guo_UoMaJkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 23, 2015 at 05:38:45PM +0000, David Drysdale wrote:
> On Sun, Mar 15, 2015 at 8:00 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 9daa017..1dc680b 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1374,6 +1374,11 @@ struct task_struct {
> >
> >         unsigned autoreap:1; /* Do not become a zombie on exit */
> >
> > +#ifdef CONFIG_CLONEFD
> > +       unsigned clonefd:1; /* Notify clonefd_wqh on exit */
> > +       wait_queue_head_t clonefd_wqh;
> > +#endif
> > +
> >         unsigned long atomic_flags; /* Flags needing atomic access. */
> >
> >         struct restart_block restart_block;
> 
> Idle thought: are there any concerns about the occupancy
> impact of adding a wait_queue_head to every task_struct,
> whether it has a clonefd or not?
> 
> I guess we could reduce the size somewhat by just
> storing a struct file *clonefd_file in the task, and then have
> a separate structure (with the wqh and a task_struct*) referenced
> by file->private_data.  Not sure whether the added complication
> would be worthwhile, though.

My original patches did exactly that (minus the reference back to the
task_struct).  However, there are a couple of problems with that
approach.  First, it assumes that a task_struct has only a single file
referencing it, but in the future I'd like to support obtaining a
clonefd for an existing task.  Second, the task_struct really shouldn't
have a reference to the actual struct file, when it only needs the
wait_queue_head_t.

Also, AFAICT a wait_queue_head_t is normally (in the absence of kernel
lock debugging options) the size of two pointers.  Adding an indirection
and an extra allocation to change that to the size of one pointer seems
iffy, especially when looking at the rest of what's directly in
task_struct that's far larger.

> > --- /dev/null
> > +++ b/kernel/clonefd.c
> > @@ -0,0 +1,121 @@
> > +/*
> > + * Support functions for CLONE_FD
> > + *
> > + * Copyright (c) 2015 Intel Corporation
> > + * Original authors: Josh Triplett <josh@joshtriplett.org>
> > + *                   Thiago Macieira <thiago@macieira.org>
> > + */
> > +#include <linux/anon_inodes.h>
> > +#include <linux/file.h>
> > +#include <linux/fs.h>
> > +#include <linux/poll.h>
> > +#include <linux/slab.h>
> > +#include "clonefd.h"
> > +
> > +static int clonefd_release(struct inode *inode, struct file *file)
> > +{
> > +       put_task_struct(file->private_data);
> > +       return 0;
> > +}
> > +
> > +static unsigned int clonefd_poll(struct file *file, poll_table *wait)
> > +{
> > +       struct task_struct *p = file->private_data;
> > +       poll_wait(file, &p->clonefd_wqh, wait);
> > +       return p->exit_state ? (POLLIN | POLLRDNORM | POLLHUP) : 0;
> > +}
> > +
> > +static ssize_t clonefd_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> > +{
> > +       struct task_struct *p = file->private_data;
> > +       int ret = 0;
> > +
> > +       /* EOF after first read */
> > +       if (*ppos)
> > +               return 0;
> > +
> > +       if (file->f_flags & O_NONBLOCK)
> > +               ret = -EAGAIN;
> > +       else
> > +               ret = wait_event_interruptible(p->clonefd_wqh, p->exit_state);
> > +
> > +       if (p->exit_state) {
> > +               struct clonefd_info info = {};
> > +               cputime_t utime, stime;
> > +               task_exit_code_status(p->exit_code, &info.code, &info.status);
> > +               info.code &= ~__SI_MASK;
> > +               task_cputime(p, &utime, &stime);
> > +               info.utime = cputime_to_clock_t(utime + p->signal->utime);
> > +               info.stime = cputime_to_clock_t(stime + p->signal->stime);
> > +               ret = simple_read_from_buffer(buf, count, ppos, &info, sizeof(info));
> > +       }
> > +       return ret;
> > +}
> > +
> > +static struct file_operations clonefd_fops = {
> > +       .release = clonefd_release,
> > +       .poll = clonefd_poll,
> > +       .read = clonefd_read,
> > +       .llseek = no_llseek,
> > +};
> 
> It might be nice to include a show_fdinfo() implementation that shows
> (say) the pid that the clonefd refers to.  E.g. something like:
> 
> static void clonefd_show_fdinfo(struct seq_file *m, struct file *file)
> {
>     struct task_struct *p = file->private_data;
> 
>     seq_printf(m, "tid:\t%d\n", task_tgid_vnr(p));
> }

I thought about that, but that would add a couple of additional ifdefs
(CONFIG_PROC_FS), for an informational file of minimal value.  More
importantly, I don't want to add that until after adding an ioctl or
similar to programmatically obtain the pid from a clonefd; otherwise,
someone might try to use fdinfo as the "API" to do so, which would be
all kinds of awful.

So I'd prefer to add fdinfo in a future extension of clonefd, rather
than in the initial patch series.

> > +
> > +/* Do process exit notification for clonefd. */
> > +void clonefd_do_notify(struct task_struct *p)
> > +{
> > +       if (p->clonefd)
> > +               wake_up_all(&p->clonefd_wqh);
> > +}
> > +
> > +/* Handle the CLONE_FD case for copy_process. */
> > +int clonefd_do_clone(u64 clone_flags, struct task_struct *p,
> > +                    struct clone4_args *args, struct clonefd_setup *setup)
> > +{
> > +       int flags;
> > +       struct file *file;
> > +       int fd;
> > +
> > +       p->clonefd = !!(clone_flags & CLONE_FD);
> > +       if (!p->clonefd)
> > +               return 0;
> > +
> > +       if (args->clonefd_flags & ~(O_CLOEXEC | O_NONBLOCK))
> > +               return -EINVAL;
> > +
> 
> Maybe also check for (args->clonefd == NULL) in advance, and
> return -EINVAL or -EFAULT?

That wouldn't be consistent with how clone treats its various other
out argument pointers.

- Josh Triplett
