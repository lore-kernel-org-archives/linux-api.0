From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 3/4] signal: support pidctl() with pidfd_send_signal()
Date: Mon, 25 Mar 2019 18:28:53 +0000
Message-ID: <CAGLj2rGTK2xLhDhBjh1wSpAiuxbLBt-AwREB5kA8LeW4JFzgsg@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <20190325162052.28987-4-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190325162052.28987-4-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 4:21 PM Christian Brauner <christian@brauner.io> wrote:
>
> Let pidfd_send_signal() use pidfds retrieved via pidctl(). With this patch
> pidfd_send_signal() becomes independent of procfs. This fullfils the
> request made when we merged the pidfd_send_signal() patchset. The
> pidfd_send_signal() syscall is now always available allowing for it to be
> used by users without procfs mounted or even users without procfs support
> compiled into the kernel.
>
> Signed-off-by: Christian Brauner <christian@brauner.io>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jann Horn <jannh@google.com
> Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>
> Cc: "Dmitry V. Levin" <ldv@altlinux.org>
> Cc: Andy Lutomirsky <luto@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  kernel/signal.c | 20 +++++++++-----------
>  kernel/sys_ni.c |  3 ---
>  2 files changed, 9 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index b7953934aa99..d77183be1677 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3513,7 +3513,6 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
>         return kill_something_info(sig, &info, pid);
>  }
>
> -#ifdef CONFIG_PROC_FS
>  /*
>   * Verify that the signaler and signalee either are in the same pid namespace
>   * or that the signaler's pid namespace is an ancestor of the signalee's pid
> @@ -3521,16 +3520,13 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
>   */
>  static bool access_pidfd_pidns(struct pid *pid)

If it is agreed upon to remove the ability of using /proc/<PID> as a
pidfd pidfd_send_signal accepts, is lifting this check acceptable?

The system call as is does not allow for a process to acquire a pidfd
without being in an ancestor namespace or the same namespace. Thus,
there are good reasons to allow for this to work and be able to work
around the limitations imposed by pid namespaces if userspace
explicitly decides to do so, by passing around the pidfd to some other
process.

Also, you would need to translate this only once, when filling in the
structure. The other process is bound to its pid ns as long as it is
alive, therefore it would be simple without having to do anything
fancy at read side (unlike unix sockets).

>  {
> +       int ret;
>         struct pid_namespace *active = task_active_pid_ns(current);
>         struct pid_namespace *p = ns_of_pid(pid);
>
> -       for (;;) {
> -               if (!p)
> -                       return false;
> -               if (p == active)
> -                       break;
> -               p = p->parent;
> -       }
> +       ret = pidnscmp(active, p);
> +       if (ret < 0)
> +               return false;
>
>         return true;
>  }
> @@ -3581,12 +3577,15 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
>         if (flags)
>                 return -EINVAL;
>
> -       f = fdget_raw(pidfd);
> +       f = fdget(pidfd);
>         if (!f.file)
>                 return -EBADF;
>
>         /* Is this a pidfd? */
> -       pid = tgid_pidfd_to_pid(f.file);
> +       if (f.file->f_op == &pidfd_fops)
> +               pid = f.file->private_data;
> +       else
> +               pid = tgid_pidfd_to_pid(f.file);
>         if (IS_ERR(pid)) {
>                 ret = PTR_ERR(pid);
>                 goto err;
> @@ -3625,7 +3624,6 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
>         fdput(f);
>         return ret;
>  }
> -#endif /* CONFIG_PROC_FS */
>
>  static int
>  do_send_specific(pid_t tgid, pid_t pid, int sig, struct kernel_siginfo *info)
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index d21f4befaea4..4d9ae5ea6caf 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -167,9 +167,6 @@ COND_SYSCALL(syslog);
>
>  /* kernel/sched/core.c */
>
> -/* kernel/signal.c */
> -COND_SYSCALL(pidfd_send_signal);
> -
>  /* kernel/sys.c */
>  COND_SYSCALL(setregid);
>  COND_SYSCALL(setgid);
> --
> 2.21.0
>
