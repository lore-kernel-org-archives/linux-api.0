From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Mon, 16 Jan 2017 18:15:01 +0100
Message-ID: <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com> <1484572984-13388-3-git-send-email-djalal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484572984-13388-3-git-send-email-djalal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Cc linux-api

On Mon, Jan 16, 2017 at 2:23 PM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> This adds a new per-task hidepid=3D flag that is honored by procfs when
> presenting /proc to the user, in addition to the existing hidepid=3D moun=
t
> option. So far, hidepid=3D was exclusively a per-pidns setting. Locking
> down a set of processes so that they cannot see other user's processes
> without affecting the rest of the system thus currently requires
> creation of a private PID namespace, with all the complexity it brings,
> including maintaining a stub init process as PID 1 and losing the
> ability to see processes of the same user on the rest of the system.
>
> With this patch all acesss and visibility checks in procfs now
> honour two fields:
>
>         a) the existing hide_pid field in the PID namespace
>         b) the new hide_pid in struct task_struct
>
> Access/visibility is only granted if both fields permit it; the more
> restrictive one wins. By default the new task_struct hide_pid value
> defaults to 0, which means behaviour is not changed from the status quo.
>
> Setting the per-process hide_pid value is done via a new PR_SET_HIDEPID
> prctl() option which takes the same three supported values as the
> hidepid=3D mount option. The per-process hide_pid may only be increased,
> never decreased, thus ensuring that once applied, processes can never
> escape such a hide_pid jail.  When a process forks it inherits its
> parent's hide_pid value.
>
> Suggested usecase: let's say nginx runs as user "www-data". After
> dropping privileges it may now call:
>
>         =E2=80=A6
>         prctl(PR_SET_HIDEPID, 2);
>         =E2=80=A6
>
> And from that point on neither nginx itself, nor any of its child
> processes may see processes in /proc anymore that belong to a different
> user than "www-data". Other services running on the same system remain
> unaffected.
>
> This should permit Linux distributions to more comprehensively lock down
> their services, as it allows an isolated opt-in for hidepid=3D for
> specific services. Previously hidepid=3D could only be set system-wide,
> and then specific services had to be excluded by group membership,
> essentially a more complex concept of opt-out.
>
> A tool to test this is available here:
> https://gist.github.com/tixxdz/4e6d21071463ad2c5a043984e3efb5a1
>
> Original-author: Lafcadio Wluiki <wluikil-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/filesystems/proc.txt |  2 ++
>  fs/proc/array.c                    |  3 +++
>  fs/proc/base.c                     |  8 ++++++--
>  include/linux/init_task.h          |  1 +
>  include/linux/sched.h              |  1 +
>  include/uapi/linux/prctl.h         |  4 ++++
>  kernel/fork.c                      |  1 +
>  kernel/sys.c                       | 13 +++++++++++++
>  8 files changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesyste=
ms/proc.txt
> index 72624a1..fc95261 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -164,6 +164,7 @@ read the file /proc/PID/status:
>    Uid:    501     501     501     501
>    Gid:    100     100     100     100
>    FDSize: 256
> +  HidePid:      0
>    Groups: 100 14 16
>    VmPeak:     5004 kB
>    VmSize:     5004 kB
> @@ -228,6 +229,7 @@ Table 1-2: Contents of the status files (as of 4.1)
>   Gid                         Real, effective, saved set, and  file syste=
m GIDs
>   Umask                       file mode creation mask
>   FDSize                      number of file descriptor slots currently a=
llocated
> + HidePid                     process access mode of /proc/<pid>/
>   Groups                      supplementary group list
>   NStgid                      descendant namespace thread group ID hierar=
chy
>   NSpid                       descendant namespace process ID hierarchy
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 51a4213..e6cd1a1 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -163,6 +163,7 @@ static inline void task_state(struct seq_file *m, str=
uct pid_namespace *ns,
>         const struct cred *cred;
>         pid_t ppid, tpid =3D 0, tgid, ngid;
>         unsigned int max_fds =3D 0;
> +       int hide_pid;
>
>         rcu_read_lock();
>         ppid =3D pid_alive(p) ?
> @@ -183,6 +184,7 @@ static inline void task_state(struct seq_file *m, str=
uct pid_namespace *ns,
>         task_lock(p);
>         if (p->files)
>                 max_fds =3D files_fdtable(p->files)->max_fds;
> +       hide_pid =3D p->hide_pid;
>         task_unlock(p);
>         rcu_read_unlock();
>
> @@ -201,6 +203,7 @@ static inline void task_state(struct seq_file *m, str=
uct pid_namespace *ns,
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->egid=
));
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->sgid=
));
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->fsgi=
d));
> +       seq_put_decimal_ull(m, "\nHidePid:\t", hide_pid);
>         seq_put_decimal_ull(m, "\nFDSize:\t", max_fds);
>
>         seq_puts(m, "\nGroups:\t");
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index cd8dd15..596b17f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -712,7 +712,9 @@ static bool has_pid_permissions(struct pid_namespace =
*pid,
>                                  struct task_struct *task,
>                                  int hide_pid_min)
>  {
> -       if (pid->hide_pid < hide_pid_min)
> +       int hide_pid =3D max(pid->hide_pid, (int) current->hide_pid);
> +
> +       if (hide_pid < hide_pid_min)
>                 return true;
>         if (in_group_p(pid->pid_gid))
>                 return true;
> @@ -733,7 +735,9 @@ static int proc_pid_permission(struct inode *inode, i=
nt mask)
>         put_task_struct(task);
>
>         if (!has_perms) {
> -               if (pid->hide_pid =3D=3D HIDEPID_INVISIBLE) {
> +               int hide_pid =3D max(pid->hide_pid, (int) current->hide_p=
id);
> +
> +               if (hide_pid =3D=3D HIDEPID_INVISIBLE) {
>                         /*
>                          * Let's make getdents(), stat(), and open()
>                          * consistent with each other.  If a process
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 325f649..c87de0e 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -250,6 +250,7 @@ extern struct task_group root_task_group;
>         .cpu_timers     =3D INIT_CPU_TIMERS(tsk.cpu_timers),             =
 \
>         .pi_lock        =3D __RAW_SPIN_LOCK_UNLOCKED(tsk.pi_lock),       =
 \
>         .timer_slack_ns =3D 50000, /* 50 usec default slack */           =
 \
> +       .hide_pid       =3D 0,                                           =
 \
>         .pids =3D {                                                      =
 \
>                 [PIDTYPE_PID]  =3D INIT_PID_LINK(PIDTYPE_PID),           =
 \
>                 [PIDTYPE_PGID] =3D INIT_PID_LINK(PIDTYPE_PGID),          =
 \
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ad3ec9e..ba9f1d5 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1608,6 +1608,7 @@ struct task_struct {
>         /* unserialized, strictly 'current' */
>         unsigned in_execve:1; /* bit to tell LSMs we're in execve */
>         unsigned in_iowait:1;
> +       unsigned hide_pid:2; /* per-process procfs hidepid=3D */
>  #if !defined(TIF_RESTORE_SIGMASK)
>         unsigned restore_sigmask:1;
>  #endif
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index a8d0759..ada62b6 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -197,4 +197,8 @@ struct prctl_mm_map {
>  # define PR_CAP_AMBIENT_LOWER          3
>  # define PR_CAP_AMBIENT_CLEAR_ALL      4
>
> +/* Per process, non-revokable procfs hidepid=3D option */
> +#define PR_SET_HIDEPID 48
> +#define PR_GET_HIDEPID 49
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 11c5c8a..a701a77 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1574,6 +1574,7 @@ static __latent_entropy struct task_struct *copy_pr=
ocess(
>  #endif
>
>         p->default_timer_slack_ns =3D current->timer_slack_ns;
> +       p->hide_pid =3D current->hide_pid;
>
>         task_io_accounting_init(&p->ioac);
>         acct_clear_integrals(p);
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 842914e..4041ff4 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2261,6 +2261,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long,=
 arg2, unsigned long, arg3,
>         case PR_GET_FP_MODE:
>                 error =3D GET_FP_MODE(me);
>                 break;
> +       case PR_SET_HIDEPID:
> +               if (arg2 < HIDEPID_OFF || arg2 > HIDEPID_INVISIBLE ||
> +                   arg3 || arg4 || arg5)
> +                       return -EINVAL;
> +               if (arg2 < me->hide_pid)
> +                       return -EPERM;
> +               me->hide_pid =3D arg2;
> +               break;
> +       case PR_GET_HIDEPID:
> +               if (arg2 || arg3 || arg4 || arg5)
> +                       return -EINVAL;
> +               error =3D me->hide_pid;
> +               break;
>         default:
>                 error =3D -EINVAL;
>                 break;
> --
> 2.5.5
>



--=20
tixxdz
http://opendz.org
