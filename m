From: Jann Horn <jannh@google.com>
Subject: Re: [PATCHv3 01/27] ns: Introduce Time Namespace
Date: Thu, 25 Apr 2019 21:10:28 +0200
Message-ID: <CAG48ez2h5Khw1tcizUKywtqEuUWpHsrGcWF+KN+X119B4MvmoA@mail.gmail.com>
References: <20190425161416.26600-1-dima@arista.com> <20190425161416.26600-2-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425161416.26600-2-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 25, 2019 at 6:14 PM Dmitry Safonov <dima@arista.com> wrote:
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

Is there a check anywhere to make sure that you can't use
clone(CLONE_VM) after calling unshare(CLONE_NEWTIME), and that you
can't use clone(CLONE_VM|CLONE_NEWTIME)? Those things probably
shouldn't be allowed, right?

CLONE_NEWPID has similar rules; from the clone.2 manpage:

       EINVAL CLONE_THREAD was specified, but the current process previously
              called unshare(2) with the CLONE_NEWPID flag or used setns(2)
              to reassociate itself with a PID namespace.
[...]
       EINVAL One (or both) of CLONE_NEWPID or CLONE_NEWUSER and one (or
              both) of CLONE_THREAD or CLONE_PARENT were specified in flags.
