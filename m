From: Laurent Vivier <lvivier@redhat.com>
Subject: Re: [RFC 01/20] ns: Introduce Time Namespace
Date: Fri, 28 Sep 2018 20:20:10 +0200
Message-ID: <2087cf9b-89a1-e591-4dcd-4d98767a1be6@redhat.com>
References: <20180919205037.9574-1-dima@arista.com>
 <20180919205037.9574-2-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-2-dima@arista.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 19/09/2018 22:50, Dmitry Safonov wrote:
> From: Andrei Vagin <avagin@openvz.org>
> 
> Time Namespace isolates clock values.
> 
> The kernel provides access to several clocks CLOCK_REALTIME,
> CLOCK_MONOTONIC, CLOCK_BOOTTIME, etc.
> 
> CLOCK_REALTIME
>       System-wide  clock  that  measures real (i.e., wall-clock) time.
> 
> CLOCK_MONOTONIC
>       Clock that cannot be set and represents monotonic time since
>       some  unspecified starting point.
> 
> CLOCK_BOOTTIME
>       Identical  to  CLOCK_MONOTONIC, except it also includes any time
>       that the system is suspended.
> 
> For many users, the time namespace means the ability to changes time in
> a container (CLOCK_REALTIME).
> 
> But in a context of the checkpoint/restore functionality, monotonic and
> bootime clocks become interesting. Both clocks are monotonic with
> unspecified staring points. These clocks are widely used to measure time
> slices, set timers. After restoring or migrating processes, we have to
> guarantee that they never go backward. In an ideal case, the behavior of
> these clocks should be the same as for a case when a whole system is
> suspended. All this means that we need to be able to set CLOCK_MONOTONIC
> and CLOCK_BOOTTIME clocks, what can be done by adding per-namespace
> offsets for clocks.
> 
> Link: https://criu.org/Time_namespace
> Link: https://lists.openvz.org/pipermail/criu/2018-June/041504.html
> Signed-off-by: Andrei Vagin <avagin@openvz.org>
> Co-developed-by: Dmitry Safonov <dima@arista.com>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  fs/proc/namespaces.c           |   3 +
>  include/linux/nsproxy.h        |   1 +
>  include/linux/proc_ns.h        |   1 +
>  include/linux/time_namespace.h |  59 ++++++++++++++
>  include/linux/user_namespace.h |   1 +
>  include/uapi/linux/sched.h     |   1 +
>  init/Kconfig                   |   7 ++
>  kernel/Makefile                |   1 +
>  kernel/fork.c                  |   3 +-
>  kernel/nsproxy.c               |  19 ++++-
>  kernel/time_namespace.c        | 169 +++++++++++++++++++++++++++++++++++++++++
>  11 files changed, 262 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/time_namespace.h
>  create mode 100644 kernel/time_namespace.c
> 
...
> diff --git a/kernel/time_namespace.c b/kernel/time_namespace.c
> new file mode 100644
> index 000000000000..902cd9c22159
> --- /dev/null
> +++ b/kernel/time_namespace.c
...
> +
> +struct time_namespace init_time_ns = {
> +	.kref = KREF_INIT(2),
> +	.user_ns = &init_user_ns,
> +	.ns.inum = PROC_UTS_INIT_INO,

Do you mean PROC_TIME_INIT_INO?

> +#ifdef CONFIG_UTS_NS
> +	.ns.ops = &timens_operations,
> +#endif

Do you mean CONFIG_TIME_NS?

Thanks,
Laurent
