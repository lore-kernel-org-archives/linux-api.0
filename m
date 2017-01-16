From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Mon, 16 Jan 2017 18:12:42 +0100
Message-ID: <CAEiveUf9=qLH6XJnosGKBpvFQOKP32idJGy_0bsy92SWL+FXEg@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com> <1484572984-13388-3-git-send-email-djalal@gmail.com>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a11490174a0c5c80546394a9b
Return-path: <kernel-hardening-return-5988-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1484572984-13388-3-git-send-email-djalal@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--001a11490174a0c5c80546394a9b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Cc linux-api

On Mon, Jan 16, 2017 at 2:23 PM, Djalal Harouni <tixxdz@gmail.com> wrote:

> From: Djalal Harouni <tixxdz@gmail.com>
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
> Original-author: Lafcadio Wluiki <wluikil@gmail.com>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
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
> diff --git a/Documentation/filesystems/proc.txt
> b/Documentation/filesystems/proc.txt
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
m
> GIDs
>   Umask                       file mode creation mask
>   FDSize                      number of file descriptor slots currently
> allocated
> + HidePid                     process access mode of /proc/<pid>/
>   Groups                      supplementary group list
>   NStgid                      descendant namespace thread group ID
> hierarchy
>   NSpid                       descendant namespace process ID hierarchy
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 51a4213..e6cd1a1 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -163,6 +163,7 @@ static inline void task_state(struct seq_file *m,
> struct pid_namespace *ns,
>         const struct cred *cred;
>         pid_t ppid, tpid =3D 0, tgid, ngid;
>         unsigned int max_fds =3D 0;
> +       int hide_pid;
>
>         rcu_read_lock();
>         ppid =3D pid_alive(p) ?
> @@ -183,6 +184,7 @@ static inline void task_state(struct seq_file *m,
> struct pid_namespace *ns,
>         task_lock(p);
>         if (p->files)
>                 max_fds =3D files_fdtable(p->files)->max_fds;
> +       hide_pid =3D p->hide_pid;
>         task_unlock(p);
>         rcu_read_unlock();
>
> @@ -201,6 +203,7 @@ static inline void task_state(struct seq_file *m,
> struct pid_namespace *ns,
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns,
> cred->egid));
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns,
> cred->sgid));
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns,
> cred->fsgid));
> +       seq_put_decimal_ull(m, "\nHidePid:\t", hide_pid);
>         seq_put_decimal_ull(m, "\nFDSize:\t", max_fds);
>
>         seq_puts(m, "\nGroups:\t");
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index cd8dd15..596b17f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -712,7 +712,9 @@ static bool has_pid_permissions(struct pid_namespace
> *pid,
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
> @@ -733,7 +735,9 @@ static int proc_pid_permission(struct inode *inode,
> int mask)
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
> @@ -1574,6 +1574,7 @@ static __latent_entropy struct task_struct
> *copy_process(
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
> @@ -2261,6 +2261,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long,
> arg2, unsigned long, arg3,
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
>


--=20
tixxdz
http://opendz.org

--001a11490174a0c5c80546394a9b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Cc=C2=A0<span style=3D"color:rgb(0,0,0);font-size:12px">li=
nux-api</span><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On =
Mon, Jan 16, 2017 at 2:23 PM, Djalal Harouni <span dir=3D"ltr">&lt;<a href=
=3D"mailto:tixxdz@gmail.com" target=3D"_blank">tixxdz@gmail.com</a>&gt;</sp=
an> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex">From: Djalal Harouni &lt;<a hr=
ef=3D"mailto:tixxdz@gmail.com">tixxdz@gmail.com</a>&gt;<br>
<br>
This adds a new per-task hidepid=3D flag that is honored by procfs when<br>
presenting /proc to the user, in addition to the existing hidepid=3D mount<=
br>
option. So far, hidepid=3D was exclusively a per-pidns setting. Locking<br>
down a set of processes so that they cannot see other user&#39;s processes<=
br>
without affecting the rest of the system thus currently requires<br>
creation of a private PID namespace, with all the complexity it brings,<br>
including maintaining a stub init process as PID 1 and losing the<br>
ability to see processes of the same user on the rest of the system.<br>
<br>
With this patch all acesss and visibility checks in procfs now<br>
honour two fields:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 a) the existing hide_pid field in the PID names=
pace<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 b) the new hide_pid in struct task_struct<br>
<br>
Access/visibility is only granted if both fields permit it; the more<br>
restrictive one wins. By default the new task_struct hide_pid value<br>
defaults to 0, which means behaviour is not changed from the status quo.<br=
>
<br>
Setting the per-process hide_pid value is done via a new PR_SET_HIDEPID<br>
prctl() option which takes the same three supported values as the<br>
hidepid=3D mount option. The per-process hide_pid may only be increased,<br=
>
never decreased, thus ensuring that once applied, processes can never<br>
escape such a hide_pid jail.=C2=A0 When a process forks it inherits its<br>
parent&#39;s hide_pid value.<br>
<br>
Suggested usecase: let&#39;s say nginx runs as user &quot;www-data&quot;. A=
fter<br>
dropping privileges it may now call:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =E2=80=A6<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 prctl(PR_SET_HIDEPID, 2);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =E2=80=A6<br>
<br>
And from that point on neither nginx itself, nor any of its child<br>
processes may see processes in /proc anymore that belong to a different<br>
user than &quot;www-data&quot;. Other services running on the same system r=
emain<br>
unaffected.<br>
<br>
This should permit Linux distributions to more comprehensively lock down<br=
>
their services, as it allows an isolated opt-in for hidepid=3D for<br>
specific services. Previously hidepid=3D could only be set system-wide,<br>
and then specific services had to be excluded by group membership,<br>
essentially a more complex concept of opt-out.<br>
<br>
A tool to test this is available here:<br>
<a href=3D"https://gist.github.com/tixxdz/4e6d21071463ad2c5a043984e3efb5a1"=
 rel=3D"noreferrer" target=3D"_blank">https://gist.github.com/<wbr>tixxdz/<=
wbr>4e6d21071463ad2c5a043984e3efb5<wbr>a1</a><br>
<br>
Original-author: Lafcadio Wluiki &lt;<a href=3D"mailto:wluikil@gmail.com">w=
luikil@gmail.com</a>&gt;<br>
Signed-off-by: Djalal Harouni &lt;<a href=3D"mailto:tixxdz@gmail.com">tixxd=
z@gmail.com</a>&gt;<br>
---<br>
=C2=A0Documentation/filesystems/<wbr>proc.txt |=C2=A0 2 ++<br>
=C2=A0fs/proc/array.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 3 +++<br>
=C2=A0fs/proc/base.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0|=C2=A0 8 ++++++--<br>
=C2=A0include/linux/init_task.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 1=
 +<br>
=C2=A0include/linux/sched.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 |=C2=A0 1 +<br>
=C2=A0include/uapi/linux/prctl.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 4=
 ++++<br>
=C2=A0kernel/fork.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0kernel/sys.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0| 13 +++++++++++++<br>
=C2=A08 files changed, 31 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/Documentation/filesystems/<wbr>proc.txt b/Documentation/filesy=
stems/<wbr>proc.txt<br>
index 72624a1..fc95261 100644<br>
--- a/Documentation/filesystems/<wbr>proc.txt<br>
+++ b/Documentation/filesystems/<wbr>proc.txt<br>
@@ -164,6 +164,7 @@ read the file /proc/PID/status:<br>
=C2=A0 =C2=A0Uid:=C2=A0 =C2=A0 501=C2=A0 =C2=A0 =C2=A0501=C2=A0 =C2=A0 =C2=
=A0501=C2=A0 =C2=A0 =C2=A0501<br>
=C2=A0 =C2=A0Gid:=C2=A0 =C2=A0 100=C2=A0 =C2=A0 =C2=A0100=C2=A0 =C2=A0 =C2=
=A0100=C2=A0 =C2=A0 =C2=A0100<br>
=C2=A0 =C2=A0FDSize: 256<br>
+=C2=A0 HidePid:=C2=A0 =C2=A0 =C2=A0 0<br>
=C2=A0 =C2=A0Groups: 100 14 16<br>
=C2=A0 =C2=A0VmPeak:=C2=A0 =C2=A0 =C2=A05004 kB<br>
=C2=A0 =C2=A0VmSize:=C2=A0 =C2=A0 =C2=A05004 kB<br>
@@ -228,6 +229,7 @@ Table 1-2: Contents of the status files (as of 4.1)<br>
=C2=A0 Gid=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0Real, effective, saved set, and=C2=A0 file syste=
m GIDs<br>
=C2=A0 Umask=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0file mode creation mask<br>
=C2=A0 FDSize=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 number of file descriptor slots currently allocated<br>
+ HidePid=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0process access mode of /proc/&lt;pid&gt;/<br>
=C2=A0 Groups=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 supplementary group list<br>
=C2=A0 NStgid=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 descendant namespace thread group ID hierarchy<br>
=C2=A0 NSpid=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0descendant namespace process ID hierarchy<br>
diff --git a/fs/proc/array.c b/fs/proc/array.c<br>
index 51a4213..e6cd1a1 100644<br>
--- a/fs/proc/array.c<br>
+++ b/fs/proc/array.c<br>
@@ -163,6 +163,7 @@ static inline void task_state(struct seq_file *m, struc=
t pid_namespace *ns,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct cred *cred;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pid_t ppid, tpid =3D 0, tgid, ngid;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int max_fds =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int hide_pid;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rcu_read_lock();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ppid =3D pid_alive(p) ?<br>
@@ -183,6 +184,7 @@ static inline void task_state(struct seq_file *m, struc=
t pid_namespace *ns,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 task_lock(p);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p-&gt;files)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_fds =3D files_f=
dtable(p-&gt;files)-&gt;max_<wbr>fds;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0hide_pid =3D p-&gt;hide_pid;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 task_unlock(p);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rcu_read_unlock();<br>
<br>
@@ -201,6 +203,7 @@ static inline void task_state(struct seq_file *m, struc=
t pid_namespace *ns,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_put_decimal_ull(m, &quot;\t&quot;, from_kgi=
d_munged(user_ns, cred-&gt;egid));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_put_decimal_ull(m, &quot;\t&quot;, from_kgi=
d_munged(user_ns, cred-&gt;sgid));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_put_decimal_ull(m, &quot;\t&quot;, from_kgi=
d_munged(user_ns, cred-&gt;fsgid));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0seq_put_decimal_ull(m, &quot;\nHidePid:\t&quot;=
, hide_pid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_put_decimal_ull(m, &quot;\nFDSize:\t&quot;,=
 max_fds);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_puts(m, &quot;\nGroups:\t&quot;);<br>
diff --git a/fs/proc/base.c b/fs/proc/base.c<br>
index cd8dd15..596b17f 100644<br>
--- a/fs/proc/base.c<br>
+++ b/fs/proc/base.c<br>
@@ -712,7 +712,9 @@ static bool has_pid_permissions(struct pid_namespace *p=
id,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct task_struct *task,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int hide_pid_min)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pid-&gt;hide_pid &lt; hide_pid_min)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int hide_pid =3D max(pid-&gt;hide_pid, (int) cu=
rrent-&gt;hide_pid);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (hide_pid &lt; hide_pid_min)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return true;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (in_group_p(pid-&gt;pid_gid))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return true;<br>
@@ -733,7 +735,9 @@ static int proc_pid_permission(struct inode *inode, int=
 mask)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 put_task_struct(task);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!has_perms) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pid-&gt;hide_pi=
d =3D=3D HIDEPID_INVISIBLE) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int hide_pid =3D ma=
x(pid-&gt;hide_pid, (int) current-&gt;hide_pid);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (hide_pid =3D=3D=
 HIDEPID_INVISIBLE) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* Let&#39;s make getdents(), stat(), and open()<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* consistent with each other.=C2=A0 If a process<br>
diff --git a/include/linux/init_task.h b/include/linux/init_task.h<br>
index 325f649..c87de0e 100644<br>
--- a/include/linux/init_task.h<br>
+++ b/include/linux/init_task.h<br>
@@ -250,6 +250,7 @@ extern struct task_group root_task_group;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .cpu_timers=C2=A0 =C2=A0 =C2=A0=3D INIT_CPU_TIM=
ERS(tsk.cpu_<wbr>timers),=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .pi_lock=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D __RAW_S=
PIN_LOCK_UNLOCKED(tsk.<wbr>pi_lock),=C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .timer_slack_ns =3D 50000, /* 50 usec default s=
lack */=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0.hide_pid=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 0,=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .pids =3D {=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0\<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [PIDTYPE_PID]=C2=A0=
 =3D INIT_PID_LINK(PIDTYPE_PID),=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [PIDTYPE_PGID] =3D =
INIT_PID_LINK(PIDTYPE_PGID),=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
diff --git a/include/linux/sched.h b/include/linux/sched.h<br>
index ad3ec9e..ba9f1d5 100644<br>
--- a/include/linux/sched.h<br>
+++ b/include/linux/sched.h<br>
@@ -1608,6 +1608,7 @@ struct task_struct {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* unserialized, strictly &#39;current&#39; */<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned in_execve:1; /* bit to tell LSMs we&#3=
9;re in execve */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned in_iowait:1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned hide_pid:2; /* per-process procfs hide=
pid=3D */<br>
=C2=A0#if !defined(TIF_RESTORE_SIGMASK)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned restore_sigmask:1;<br>
=C2=A0#endif<br>
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h<br>
index a8d0759..ada62b6 100644<br>
--- a/include/uapi/linux/prctl.h<br>
+++ b/include/uapi/linux/prctl.h<br>
@@ -197,4 +197,8 @@ struct prctl_mm_map {<br>
=C2=A0# define PR_CAP_AMBIENT_LOWER=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3<br>
=C2=A0# define PR_CAP_AMBIENT_CLEAR_ALL=C2=A0 =C2=A0 =C2=A0 4<br>
<br>
+/* Per process, non-revokable procfs hidepid=3D option */<br>
+#define PR_SET_HIDEPID 48<br>
+#define PR_GET_HIDEPID 49<br>
+<br>
=C2=A0#endif /* _LINUX_PRCTL_H */<br>
diff --git a/kernel/fork.c b/kernel/fork.c<br>
index 11c5c8a..a701a77 100644<br>
--- a/kernel/fork.c<br>
+++ b/kernel/fork.c<br>
@@ -1574,6 +1574,7 @@ static __latent_entropy struct task_struct *copy_proc=
ess(<br>
=C2=A0#endif<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 p-&gt;default_timer_slack_ns =3D current-&gt;ti=
mer_slack_ns;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;hide_pid =3D current-&gt;hide_pid;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 task_io_accounting_init(&amp;p-&gt;<wbr>ioac);<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 acct_clear_integrals(p);<br>
diff --git a/kernel/sys.c b/kernel/sys.c<br>
index 842914e..4041ff4 100644<br>
--- a/kernel/sys.c<br>
+++ b/kernel/sys.c<br>
@@ -2261,6 +2261,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, a=
rg2, unsigned long, arg3,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case PR_GET_FP_MODE:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 error =3D GET_FP_MO=
DE(me);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0case PR_SET_HIDEPID:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (arg2 &lt; HIDEP=
ID_OFF || arg2 &gt; HIDEPID_INVISIBLE ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0arg3 =
|| arg4 || arg5)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -EINVAL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (arg2 &lt; me-&g=
t;hide_pid)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -EPERM;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0me-&gt;hide_pid =3D=
 arg2;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0case PR_GET_HIDEPID:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (arg2 || arg3 ||=
 arg4 || arg5)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -EINVAL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error =3D me-&gt;hi=
de_pid;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 default:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 error =3D -EINVAL;<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.5.5<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature" data-smartmail=3D"gmail_signature">tixxdz<=
br><a href=3D"http://opendz.org" target=3D"_blank">http://opendz.org</a></d=
iv>
</div></div>

--001a11490174a0c5c80546394a9b--
