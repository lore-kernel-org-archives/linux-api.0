From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 2/4] pid: add pidfd_open()
Date: Wed, 27 Mar 2019 18:07:54 +0100
Message-ID: <CAG48ez2QgRQKYeNDpacLGCOuNKVM1g=1PK3KzzO2Uoyn2cKXaQ@mail.gmail.com>
References: <20190327162147.23198-1-christian@brauner.io> <20190327162147.23198-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327162147.23198-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.li>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 5:22 PM Christian Brauner <christian@brauner.io> wrote:
> pidfd_open() allows to retrieve pidfds for processes and removes the
> dependency of pidfd on procfs. Multiple people have expressed a desire to
> do this even when pidfd_send_signal() was merged. It is even recorded in
[...]
> IF PROCFD_TO_PIDFD is passed as a flag together with a file descriptor to a
> /proc mount in a given pid namespace and a pidfd pidfd_open() will return a
> file descriptor to the corresponding /proc/<pid> directory in procfs
> mounts' pid namespace. pidfd_open() is very careful to verify that the pid

nit: s/mounts'/mount's/

> hasn't been recycled in between.
> IF PIDFD_TO_PROCFD is passed as a flag together with a file descriptor
> referencing a /proc/<pid> directory a pidfd referencing the struct pid
> stashed in /proc/<pid> of the process will be returned.

nit: s/of the process //?

> The pidfd_open() syscalls in that manner resembles openat() as it uses a

nit: s/syscalls/syscall/

[...]
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 20881598bdfa..c9e24e726aba 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
[...]
> +static struct file *pidfd_open_proc_pid(const struct file *procf, pid_t pid,
> +                                       const struct pid *pidfd_pid)
> +{
> +       char name[11]; /* int to strlen + \0 */

nit: The comment is a bit off; an unconstrained int needs 1+10+1
bytes, I think? minus sign, 10 digits, nullbyte? But of course that
can't actually happen here.

> +       struct file *file;
> +       struct pid *proc_pid;
> +
> +       snprintf(name, sizeof(name), "%d", pid);
> +       file = file_open_root(procf->f_path.dentry, procf->f_path.mnt, name,
> +                             O_DIRECTORY | O_NOFOLLOW, 0);

Maybe explicitly write the implied O_RDONLY (which is 0) here for clarity?

[...]
> +static int pidfd_to_procfd(pid_t pid, int procfd, int pidfd)
> +{
> +       long fd;
> +       pid_t ns_pid;
> +       struct fd fdproc, fdpid;
> +       struct file *file = NULL;
> +       struct pid *pidfd_pid = NULL;
> +       struct pid_namespace *proc_pid_ns = NULL;
> +
> +       fdproc = fdget(procfd);
> +       if (!fdproc.file)
> +               return -EBADF;
> +
> +       fdpid = fdget(pidfd);
> +       if (!fdpid.file) {
> +               fdput(fdpid);

Typo: s/fdput(fdpid)/fdput(fdproc)/

[...]
> +SYSCALL_DEFINE4(pidfd_open, pid_t, pid, int, procfd, int, pidfd, unsigned int,
> +               flags)
[...]
> +       if (!flags) {
[...]
> +               rcu_read_lock();
> +               pidfd_pid = get_pid(find_pid_ns(pid, task_active_pid_ns(current)));
> +               rcu_read_unlock();

The previous three lines are equivalent to `pidfd_pid = find_get_pid(pid)`.

> +               fd = pidfd_create_fd(pidfd_pid, O_CLOEXEC);

Nit: You could hardcode O_CLOEXEC in pidfd_create_fd() and get rid of
the second function argument if you want to.

> +               put_pid(pidfd_pid);
> +       } else if (flags & PIDFD_TO_PROCFD) {
[...]
> +               fd = pidfd_to_procfd(pid, procfd, pidfd);

The `pid` argument of pidfd_to_procfd() looks unused, maybe it makes
sense to get rid of that?
