From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 2/4] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Tue, 17 Dec 2019 02:13:16 +0100
Message-ID: <CAG48ez0ooeZfdBf+u9uE3mzo2yc7f1D5EHZ09Jz5T8VVh6AWYw@mail.gmail.com>
References: <20191217010001.GA14461@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191217010001.GA14461@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, gpascutto@mozilla.com, ealvarez@mozilla.com, Florian Weimer <fweimer@redhat.com>, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

On Tue, Dec 17, 2019 at 2:00 AM Sargun Dhillon <sargun@sargun.me> wrote:
> This adds an ioctl which allows file descriptors to be extracted
> from processes based on their pidfd.
[...]
> You must have the ability to ptrace the process in order to extract any
> file descriptors from it. ptrace can already be used to extract file
> descriptors based on parasitic code injections, so the permissions
> model is aligned.
[...]
> +       task = get_pid_task(pid, PIDTYPE_PID);
> +       if (!task)
> +               return -ESRCH;
> +       ret = -EPERM;

Please add something like

if (mutex_lock_killable(&task->signal->cred_guard_mutex))
  goto out;

here, and drop the mutex after fget_task().

> +       if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
> +               goto out;
> +       ret = -EBADF;
> +       file = fget_task(task, args.fd);
> +       if (!file)
> +               goto out;
> +
> +       fd = get_unused_fd_flags(fd_flags);
> +       if (fd < 0) {
> +               ret = fd;
> +               goto out_put_file;
> +       }
> +       /*
> +        * security_file_receive must come last since it may have side effects
> +        * and cannot be reversed.
> +        */
> +       ret = security_file_receive(file);
> +       if (ret)
> +               goto out_put_fd;
> +
> +       fd_install(fd, file);
> +       put_task_struct(task);
> +       return fd;
> +
> +out_put_fd:
> +       put_unused_fd(fd);
> +out_put_file:
> +       fput(file);
> +out:
> +       put_task_struct(task);
> +       return ret;
> +}
