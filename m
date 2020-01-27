From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv8 03/34] ns: Introduce Time Namespace
Date: Mon, 27 Jan 2020 15:12:07 +0100
Message-ID: <CACT4Y+b70bRRS2XD3yxhBoy4E-LFy_K3wMrjeuPmiEvaPe_c2Q@mail.gmail.com>
References: <20191112012724.250792-1-dima@arista.com> <20191112012724.250792-4-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20191112012724.250792-4-dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Adrian Reber <adrian-5+Cda9B46AM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 12, 2019 at 2:30 AM Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
>
> From: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>
> Time Namespace isolates clock values.
>
> The kernel provides access to several clocks CLOCK_REALTIME,
> CLOCK_MONOTONIC, CLOCK_BOOTTIME, etc.
>
> CLOCK_REALTIME
>       System-wide clock that measures real (i.e., wall-clock) time.
>
> CLOCK_MONOTONIC
>       Clock that cannot be set and represents monotonic time since
>       some unspecified starting point.
>
> CLOCK_BOOTTIME
>       Identical to CLOCK_MONOTONIC, except it also includes any time
>       that the system is suspended.
>
> For many users, the time namespace means the ability to changes date and
> time in a container (CLOCK_REALTIME).
>
> But in a context of the checkpoint/restore functionality, monotonic and
> bootime clocks become interesting. Both clocks are monotonic with
> unspecified staring points. These clocks are widely used to measure time
> slices and set timers. After restoring or migrating processes, we have to
> guarantee that they never go backward. In an ideal case, the behavior of
> these clocks should be the same as for a case when a whole system is
> suspended. All this means that we need to be able to set CLOCK_MONOTONIC
> and CLOCK_BOOTTIME clocks, what can be done by adding per-namespace
> offsets for clocks.
>
> A time namespace is similar to a pid namespace in a way how it is
> created: unshare(CLONE_NEWTIME) system call creates a new time namespace,
> but doesn't set it to the current process. Then all children of
> the process will be born in the new time namespace, or a process can
> use the setns() system call to join a namespace.
>
> This scheme allows setting clock offsets for a namespace, before any
> processes appear in it.
>
> All available clone flags have been used, so CLONE_NEWTIME uses the
> highest bit of CSIGNAL. It means that we can use it with the unshare()
> system call only. Rith now, this works for us, because time namespace
> offsets can be set only when a new time namespace is not populated. In a
> future, we will have the clone3() system call [1] which will allow to use
> the CSIGNAL mask for clone flags.
>
> [1]: httmps://lkml.kernel.org/r/20190604160944.4058-1-christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
>
> Link: https://criu.org/Time_namespace
> Link: https://lists.openvz.org/pipermail/criu/2018-June/041504.html
> Signed-off-by: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Co-developed-by: Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
> ---
>  MAINTAINERS                    |   2 +
>  fs/proc/namespaces.c           |   4 +
>  include/linux/nsproxy.h        |   2 +
>  include/linux/proc_ns.h        |   3 +
>  include/linux/time_namespace.h |  66 ++++++++++
>  include/linux/user_namespace.h |   1 +
>  include/uapi/linux/sched.h     |   6 +
>  init/Kconfig                   |   7 ++
>  kernel/fork.c                  |  16 ++-
>  kernel/nsproxy.c               |  41 +++++--
>  kernel/time/Makefile           |   1 +
>  kernel/time/namespace.c        | 217 +++++++++++++++++++++++++++++++++
>  12 files changed, 356 insertions(+), 10 deletions(-)
>  create mode 100644 include/linux/time_namespace.h
>  create mode 100644 kernel/time/namespace.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3f7f8cdbc471..037abc28c414 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13172,6 +13172,8 @@ T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
>  S:     Maintained
>  F:     fs/timerfd.c
>  F:     include/linux/timer*
> +F:     include/linux/time_namespace.h
> +F:     kernel/time_namespace.c

Is it supposed to be kernel/time/namespace.c?
