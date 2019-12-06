From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [RFC PATCH] ptrace: add PTRACE_GETFD request
Date: Thu, 5 Dec 2019 22:16:03 -0800
Message-ID: <CAMp4zn85sz_y8EvXUULVY0a0fAmg91pFkYX5zZSXDz6Q-EiUoA@mail.gmail.com>
References: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal> <CAG48ez0_CCxO=stFvK=4G4Og=xe9Rtws8PEVy-cSmLqcxfE2Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0_CCxO=stFvK=4G4Og=xe9Rtws8PEVy-cSmLqcxfE2Zw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 5, 2019 at 6:38 PM Jann Horn <jannh@google.com> wrote:
>
> On Fri, Dec 6, 2019 at 12:44 AM Sargun Dhillon <sargun@sargun.me> wrote:
> > PTRACE_GETFD is a generic ptrace API that allows the tracer to
> > get file descriptors from the traceee.
>
> typo: tracee
>
> > The primary reason to use this syscall is to allow sandboxers to
> > take action on an FD on behalf of the tracee. For example, this
> > can be combined with seccomp's user notification feature to extract
> > a file descriptor and call privileged syscalls, like binding
> > a socket to a privileged port.
> [...]
> > +/* This gets a file descriptor from a running process. It doesn't require the
> > + * process to be stopped.
> > + */
> > +#define PTRACE_GETFD   0x420f
> [...]
> > +static int ptrace_getfd(struct task_struct *child, unsigned long fd)
>
> I'd make the "fd" parameter of this function an "unsigned int", given
> that that's also the argument type of fcheck_files().
>
> > +{
> > +       struct files_struct *files;
> > +       struct file *file;
> > +       int ret = 0;
> > +
> > +       files = get_files_struct(child);
> > +       if (!files)
> > +               return -ENOENT;
> > +
> > +       spin_lock(&files->file_lock);
> > +       file = fcheck_files(files, fd);
> > +       if (!file)
> > +               ret = -EBADF;
> > +       else
> > +               get_file(file);
> > +       spin_unlock(&files->file_lock);
> > +       put_files_struct(files);
> > +
> > +       if (ret)
> > +               goto out;
> > +
> > +       ret = get_unused_fd_flags(0);
>
> You're hardcoding the flags for the fd as 0, which means that there is
> no way for the caller to enable O_CLOEXEC on the fd in a way that is
> race-free against a concurrent execve(). If you can't easily plumb
> through an O_CLOEXEC flag from userspace to here, you should probably
> hardcode O_CLOEXEC here.
>
I thought about making addr used for flags. It seems a little weird, given the
name, but it'll do the job. Alternatively, it could be a point to an
options struct.
If we introduce options, one of the nice things we could add is add the ability
to cleanse the FD of certain information, like cgroups.

> > +       if (ret >= 0)
> > +               fd_install(ret, file);
> > +
> > +       fput(file);
>
> Annoyingly, this isn't how fd_install() works. fd_install() has
> slightly weird semantics and consumes the reference passed to it, so
> this should be:
>
>   if (ret >= 0)
>     fd_install(ret, file);
>   else
>     fput(file);
>
> > +out:
> > +       return ret;
> > +}
