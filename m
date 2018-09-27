From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 4/6] files: add a replace_fd_files() function
Date: Thu, 27 Sep 2018 12:04:15 -0600
Message-ID: <20180927180415.GA15491@cisco.cisco.com>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-5-tycho@tycho.ws>
 <CAG48ez1eU_j_Ti0nRh05Qv6hv7-7hv5i+8gnJS5e30mTti2Jhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez1eU_j_Ti0nRh05Qv6hv7-7hv5i+8gnJS5e30mTti2Jhg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 06:49:02PM +0200, Jann Horn wrote:
> On Thu, Sep 27, 2018 at 5:11 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > Similar to fd_install/__fd_install, we want to be able to replace an fd of
> > an arbitrary struct files_struct, not just current's. We'll use this in the
> > next patch to implement the seccomp ioctl that allows inserting fds into a
> > stopped process' context.
> [...]
> > diff --git a/fs/file.c b/fs/file.c
> > index 7ffd6e9d103d..3b3c5aadaadb 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -850,24 +850,32 @@ __releases(&files->file_lock)
> >  }
> >
> >  int replace_fd(unsigned fd, struct file *file, unsigned flags)
> > +{
> > +       return replace_fd_task(current, fd, file, flags);
> > +}
> > +
> > +/*
> > + * Same warning as __alloc_fd()/__fd_install() here.
> > + */
> > +int replace_fd_task(struct task_struct *task, unsigned fd,
> > +                   struct file *file, unsigned flags)
> >  {
> >         int err;
> > -       struct files_struct *files = current->files;
> 
> Why did you remove this? You could just do s/current/task/ instead, right?

No reason, probably just flailing around trying to figure out what
exactly I wanted. I'll make the change, thanks.

> >         if (!file)
> > -               return __close_fd(files, fd);
> > +               return __close_fd(task->files, fd);
> >
> > -       if (fd >= rlimit(RLIMIT_NOFILE))
> > +       if (fd >= task_rlimit(task, RLIMIT_NOFILE))
> >                 return -EBADF;
> >
> > -       spin_lock(&files->file_lock);
> > -       err = expand_files(files, fd);
> > +       spin_lock(&task->files->file_lock);
> > +       err = expand_files(task->files, fd);
> >         if (unlikely(err < 0))
> >                 goto out_unlock;
> > -       return do_dup2(files, file, fd, flags);
> > +       return do_dup2(task->files, file, fd, flags);
> >
> >  out_unlock:
> > -       spin_unlock(&files->file_lock);
> > +       spin_unlock(&task->files->file_lock);
> >         return err;
> >  }
> >
> > diff --git a/include/linux/file.h b/include/linux/file.h
> > index 6b2fb032416c..f94277fee038 100644
> > --- a/include/linux/file.h
> > +++ b/include/linux/file.h
> > @@ -11,6 +11,7 @@
> >  #include <linux/posix_types.h>
> >
> >  struct file;
> > +struct task_struct;
> >
> >  extern void fput(struct file *);
> >
> > @@ -79,6 +80,13 @@ static inline void fdput_pos(struct fd f)
> >
> >  extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
> >  extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
> > +/*
> > + * Warning! This is only safe if you know the owner of the files_struct is
> > + * stopped outside syscall context. It's a very bad idea to use this unless you
> > + * have similar guarantees in your code.
> > + */
> > +extern int replace_fd_task(struct task_struct *task, unsigned fd,
> > +                          struct file *file, unsigned flags);
> 
> I think Linux kernel coding style is normally to have comments on the
> implementations of functions, not in the headers? Maybe replace the
> warning above the implemenation of replace_fd_task() with this
> comment.

Will do.

Cheers,

Tycho
