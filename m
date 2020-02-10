From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 5/5] mm: support both pid and pidfd for process_madvise
Date: Mon, 10 Feb 2020 15:12:52 -0800
Message-ID: <CAKgT0Ue9y=CL-f8xNXLo70nSk1wR_tG6TYXQUYpfk42PkHWeug@mail.gmail.com>
References: <20200128001641.5086-1-minchan@kernel.org> <20200128001641.5086-6-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200128001641.5086-6-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 27, 2020 at 4:17 PM Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> There is a demand[1] to support pid as well pidfd for process_madvise
> to reduce unncessary syscall to get pidfd if the user has control of
> the targer process(ie, they could gaurantee the process is not gone
> or pid is not reused. Or, it might be okay to give a hint to wrong
> process).

It looks like you misspelled several items in here including
"unnecessary", "target", and "guarantee".

> This patch aims for supporting both options like waitid(2). So, the
> syscall is currently,
>
>         int process_madvise(int which, pid_t pid, void *addr,
>                 size_t length, int advise, unsigned long flag);
>
> @which is actually idtype_t for userspace libray and currently,
> it supports P_PID and P_PIDFD.
>
> [1]  https://lore.kernel.org/linux-mm/9d849087-3359-c4ab-fbec-859e8186c509-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org/
> Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  include/linux/pid.h      |  1 +
>  include/linux/syscalls.h |  3 ++-
>  kernel/exit.c            | 17 -----------------
>  kernel/pid.c             | 17 +++++++++++++++++
>  mm/madvise.c             | 34 ++++++++++++++++++++++------------
>  5 files changed, 42 insertions(+), 30 deletions(-)
>
> diff --git a/include/linux/pid.h b/include/linux/pid.h
> index 998ae7d24450..023d9c3a8edc 100644
> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -75,6 +75,7 @@ extern const struct file_operations pidfd_fops;
>  struct file;
>
>  extern struct pid *pidfd_pid(const struct file *file);
> +extern struct pid *pidfd_get_pid(unsigned int fd);
>
>  static inline struct pid *get_pid(struct pid *pid)
>  {

So really this is two patches interleaved. You have the moving of the
pidfd_get_pid function and the update of the syscall. Personally I
would make the function move a separate patch and place it before you
define the syscall and fold the syscall changes into your original
patch.

Doing that you wouldn't have to worry about the syscall changing in
behavior midway through a bisect. It would either be there or it
wouldn't.

> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 1b58a11ff49f..27060e59db37 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -877,7 +877,8 @@ asmlinkage long sys_munlockall(void);
>  asmlinkage long sys_mincore(unsigned long start, size_t len,
>                                 unsigned char __user * vec);
>  asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
> -asmlinkage long sys_process_madvise(int pidfd, unsigned long start,
> +
> +asmlinkage long sys_process_madvise(int which, pid_t pid, unsigned long start,
>                         size_t len, int behavior, unsigned long flags);
>  asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
>                         unsigned long prot, unsigned long pgoff,
> diff --git a/kernel/exit.c b/kernel/exit.c
> index bcbd59888e67..7698843b1411 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1466,23 +1466,6 @@ static long do_wait(struct wait_opts *wo)
>         return retval;
>  }
>
> -static struct pid *pidfd_get_pid(unsigned int fd)
> -{
> -       struct fd f;
> -       struct pid *pid;
> -
> -       f = fdget(fd);
> -       if (!f.file)
> -               return ERR_PTR(-EBADF);
> -
> -       pid = pidfd_pid(f.file);
> -       if (!IS_ERR(pid))
> -               get_pid(pid);
> -
> -       fdput(f);
> -       return pid;
> -}
> -
>  static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
>                           int options, struct rusage *ru)
>  {
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 2278e249141d..a41a89d5dad2 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -496,6 +496,23 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
>         return idr_get_next(&ns->idr, &nr);
>  }
>
> +struct pid *pidfd_get_pid(unsigned int fd)
> +{
> +       struct fd f;
> +       struct pid *pid;
> +
> +       f = fdget(fd);
> +       if (!f.file)
> +               return ERR_PTR(-EBADF);
> +
> +       pid = pidfd_pid(f.file);
> +       if (!IS_ERR(pid))
> +               get_pid(pid);
> +
> +       fdput(f);
> +       return pid;
> +}
> +
>  /**
>   * pidfd_create() - Create a new pid file descriptor.
>   *
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 39c40cbb389e..ba3a9bd8ea27 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1197,11 +1197,10 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
>         return madvise_common(current, current->mm, start, len_in, behavior);
>  }
>
> -SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
> +SYSCALL_DEFINE6(process_madvise, int, which, pid_t, upid, unsigned long, start,
>                 size_t, len_in, int, behavior, unsigned long, flags)
>  {
>         int ret;
> -       struct fd f;
>         struct pid *pid;
>         struct task_struct *task;
>         struct mm_struct *mm;
> @@ -1212,20 +1211,31 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
>         if (!process_madvise_behavior_valid(behavior))
>                 return -EINVAL;
>
> -       f = fdget(pidfd);
> -       if (!f.file)
> -               return -EBADF;
> +       switch (which) {
> +       case P_PID:
> +               if (upid <= 0)
> +                       return -EINVAL;
> +
> +               pid = find_get_pid(upid);
> +               if (!pid)
> +                       return -ESRCH;
> +               break;
> +       case P_PIDFD:
> +               if (upid < 0)
> +                       return -EINVAL;
>
> -       pid = pidfd_pid(f.file);
> -       if (IS_ERR(pid)) {
> -               ret = PTR_ERR(pid);
> -               goto fdput;
> +               pid = pidfd_get_pid(upid);
> +               if (IS_ERR(pid))
> +                       return PTR_ERR(pid);
> +               break;
> +       default:
> +               return -EINVAL;
>         }
>
>         task = get_pid_task(pid, PIDTYPE_PID);
>         if (!task) {
>                 ret = -ESRCH;
> -               goto fdput;
> +               goto put_pid;
>         }
>
>         mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
> @@ -1238,7 +1248,7 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
>         mmput(mm);
>  release_task:
>         put_task_struct(task);
> -fdput:
> -       fdput(f);
> +put_pid:
> +       put_pid(pid);
>         return ret;
>  }
> --
> 2.25.0.341.g760bfbb309-goog
>
>
