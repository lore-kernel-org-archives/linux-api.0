From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 03/27] timens: Introduce CLOCK_MONOTONIC offsets
Date: Thu, 25 Apr 2019 21:52:41 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904252118280.1768@nanos.tec.linutronix.de>
References: <20190425161416.26600-1-dima@arista.com> <20190425161416.26600-4-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425161416.26600-4-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 25 Apr 2019, Dmitry Safonov wrote:
> From: Andrei Vagin <avagin@openvz.org>
> 
> Add monotonic time virtualisation for time namespace.
> Introduce timespec for monotionic clock into timens offsets and wire
> clock_gettime() syscall.

That's a bit meager. It should at least explain the concept how this is
supposed to work.
 
>  #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
>  #define CLOCKS_MONO			CLOCK_MONOTONIC

Unrelated to this, but those two defines can go away.
  
> +#define CLOCK_TIMENS			1024

Random number pulled out of thin air without any explanation. Aside of that
why is this exposed to user space?

> @@ -77,6 +78,7 @@ int do_clock_gettime(clockid_t which_clock, struct timespec64 *tp)
>  		break;
>  	case CLOCK_MONOTONIC:
>  		ktime_get_ts64(tp);
> +		timens_add_monotonic(tp);
>  		break;
>  	case CLOCK_BOOTTIME:
>  		ktime_get_boottime_ts64(tp);
> diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
> index 29176635991f..a047d6b7c768 100644
> --- a/kernel/time/posix-timers.c
> +++ b/kernel/time/posix-timers.c
> @@ -30,6 +30,7 @@
>  #include <linux/hashtable.h>
>  #include <linux/compat.h>
>  #include <linux/nospec.h>
> +#include <linux/time_namespace.h>
>  
>  #include "timekeeping.h"
>  #include "posix-timers.h"
> @@ -190,6 +191,8 @@ static int posix_clock_realtime_adj(const clockid_t which_clock,
>  static int posix_ktime_get_ts(clockid_t which_clock, struct timespec64 *tp)
>  {
>  	ktime_get_ts64(tp);
> +	if (which_clock & CLOCK_TIMENS)
> +		timens_add_monotonic(tp);

> @@ -1039,7 +1046,7 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
>  	if (!kc)
>  		return -EINVAL;
>  
> -	error = kc->clock_get(which_clock, &kernel_tp);
> +	error = kc->clock_get(which_clock | CLOCK_TIMENS, &kernel_tp);

Bah. After some banging the head against the wall I figured out what you
are doing here. It's because kc->clock_get() is used in common_timer_get()
as well and there you don't want the adjustment there. Sorry, but this is
uncomprehensible and unmaintainable and adds yet another conditional into
the code flow.

The callsite in common_timer_get() has already a comment:
        /*
         * The timespec64 based conversion is suboptimal, but it's not
         * worth to implement yet another callback.
         */
        kc->clock_get(timr->it_clock, &ts64);
        now = timespec64_to_ktime(ts64);

So now we have a proper justification to add that extra callback:
separation of functionality. It's trivial and not a massive code size
overhead.

Thanks,

	tglx
