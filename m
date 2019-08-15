From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 10/36] kernel: Add do_timens_ktime_to_host() helper
Date: Thu, 15 Aug 2019 19:38:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908151935320.1908@nanos.tec.linutronix.de>
References: <20190815163836.2927-1-dima@arista.com> <20190815163836.2927-11-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190815163836.2927-11-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 15 Aug 2019, Dmitry Safonov wrote:
> +ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim,
> +				struct timens_offsets *ns_offsets)
> +{
> +	ktime_t offset;
> +
> +	switch (clockid) {
> +	case CLOCK_MONOTONIC:
> +		offset = timespec64_to_ktime(ns_offsets->monotonic);
> +		break;
> +	case CLOCK_BOOTTIME:
> +	case CLOCK_BOOTTIME_ALARM:
> +		offset = timespec64_to_ktime(ns_offsets->boottime);
> +		break;
> +	default:
> +		return tim;
> +	}
> +
> +	/*
> +	 * Check that @tim value is in [offset, KTIME_MAX + offset]
> +	 * and subtract offset.
> +	 */
> +	if (tim < offset) {
> +		/*
> +		 * User can specify @tim *absolute* value - if it's lesser than
> +		 * the time namespace's offset - it's already expired.
> +		 */
> +		tim = 0;
> +	} else if (KTIME_MAX - tim < -offset) {
> +		/*
> +		 * User-supplied @tim may be close or even equal KTIME_MAX
> +		 * and time namespace offset can be negative.
> +		 * Let's check (tim - offset) for an overflow.
> +		 * Return KTIME_MAX in such case, as the time value is
> +		 * thousands *years* in future anyway.
> +		 */
> +		tim = KTIME_MAX;
> +	} else {
> +		tim = ktime_sub(tim, offset);
> +	}

While the overflow check is correct, wouldn't it be more intuitive to do:

      	  	tim = ktime_sub(tim, offset);
		if (unlikely(tim > KTIME_MAX))
			tim = KTIME_MAX;

Thanks,

	tglx
