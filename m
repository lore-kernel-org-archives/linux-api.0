From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCHv3 04/27] timens: Introduce CLOCK_BOOTTIME offset
Date: Thu, 25 Apr 2019 23:08:06 +0300
Message-ID: <20190425200806.GQ6662@uranus.lan>
References: <20190425161416.26600-1-dima@arista.com>
 <20190425161416.26600-5-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190425161416.26600-5-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 25, 2019 at 05:13:53PM +0100, Dmitry Safonov wrote:
> 
> diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
> index 8f75d34cf34a..5f0da6858b10 100644
> --- a/include/linux/time_namespace.h
> +++ b/include/linux/time_namespace.h
> @@ -48,6 +48,14 @@ static inline void timens_add_monotonic(struct timespec64 *ts)
>                  *ts = timespec64_add(*ts, ns_offsets->monotonic_time_offset);
>  }
>  
> +static inline void timens_add_boottime(struct timespec64 *ts)
> +{
> +        struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
> +
> +        if (ns_offsets)
> +                *ts = timespec64_add(*ts, ns_offsets->monotonic_boottime_offset);
> +}
>
...

>  struct timens_offsets {
>  	struct timespec64  monotonic_time_offset;
> +	struct timespec64  monotonic_boottime_offset;
>  };

Guys, is not the _offset postfix here redundant? timens_offsets
already has it and ns_offsets->monotonic_boottime_offset looks
too much.

static always_inline current_time_ns_offsets(void)
{
	return current->nsproxy->time_ns->offsets;
}

static inline void timens_add_boottime(struct timespec64 *ts)
{
	struct timens_offsets *tns_off = current_time_ns_offsets();

	if (tns_off)
		*ts = timespec64_add(*ts, tns_off->monotonic_boottime);
}

Hmm? Up to you though.
