From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH] ptrace: add PTRACE_GETFD request
Date: Fri, 6 Dec 2019 03:38:29 +0100
Message-ID: <CAG48ez0_CCxO=stFvK=4G4Og=xe9Rtws8PEVy-cSmLqcxfE2Zw@mail.gmail.com>
References: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 6, 2019 at 12:44 AM Sargun Dhillon <sargun@sargun.me> wrote:
> PTRACE_GETFD is a generic ptrace API that allows the tracer to
> get file descriptors from the traceee.

typo: tracee

> The primary reason to use this syscall is to allow sandboxers to
> take action on an FD on behalf of the tracee. For example, this
> can be combined with seccomp's user notification feature to extract
> a file descriptor and call privileged syscalls, like binding
> a socket to a privileged port.
[...]
> +/* This gets a file descriptor from a running process. It doesn't require the
> + * process to be stopped.
> + */
> +#define PTRACE_GETFD   0x420f
[...]
> +static int ptrace_getfd(struct task_struct *child, unsigned long fd)

I'd make the "fd" parameter of this function an "unsigned int", given
that that's also the argument type of fcheck_files().

> +{
> +       struct files_struct *files;
> +       struct file *file;
> +       int ret = 0;
> +
> +       files = get_files_struct(child);
> +       if (!files)
> +               return -ENOENT;
> +
> +       spin_lock(&files->file_lock);
> +       file = fcheck_files(files, fd);
> +       if (!file)
> +               ret = -EBADF;
> +       else
> +               get_file(file);
> +       spin_unlock(&files->file_lock);
> +       put_files_struct(files);
> +
> +       if (ret)
> +               goto out;
> +
> +       ret = get_unused_fd_flags(0);

You're hardcoding the flags for the fd as 0, which means that there is
no way for the caller to enable O_CLOEXEC on the fd in a way that is
race-free against a concurrent execve(). If you can't easily plumb
through an O_CLOEXEC flag from userspace to here, you should probably
hardcode O_CLOEXEC here.

> +       if (ret >= 0)
> +               fd_install(ret, file);
> +
> +       fput(file);

Annoyingly, this isn't how fd_install() works. fd_install() has
slightly weird semantics and consumes the reference passed to it, so
this should be:

  if (ret >= 0)
    fd_install(ret, file);
  else
    fput(file);

> +out:
> +       return ret;
> +}
