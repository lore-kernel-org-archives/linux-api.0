From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv4 15/28] x86/vdso: Add offsets page in vvar
Date: Fri, 14 Jun 2019 15:58:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1906141553070.1722@nanos.tec.linutronix.de>
References: <20190612192628.23797-1-dima@arista.com> <20190612192628.23797-16-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612192628.23797-16-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 12 Jun 2019, Dmitry Safonov wrote:
>  
> +#ifdef CONFIG_TIME_NS
> +notrace static __always_inline void clk_to_ns(clockid_t clk, struct timespec *ts)
> +{
> +	struct timens_offsets *timens = (struct timens_offsets *) &timens_page;
> +	struct timespec64 *offset64;
> +
> +	switch (clk) {
> +	case CLOCK_MONOTONIC:
> +	case CLOCK_MONOTONIC_COARSE:
> +	case CLOCK_MONOTONIC_RAW:
> +		offset64 = &timens->monotonic;
> +		break;
> +	case CLOCK_BOOTTIME:
> +		offset64 = &timens->boottime;
> +	default:
> +		return;
> +	}
> +
> +	ts->tv_nsec += offset64->tv_nsec;
> +	ts->tv_sec += offset64->tv_sec;
> +	if (ts->tv_nsec >= NSEC_PER_SEC) {
> +		ts->tv_nsec -= NSEC_PER_SEC;
> +		ts->tv_sec++;
> +	}
> +	if (ts->tv_nsec < 0) {
> +		ts->tv_nsec += NSEC_PER_SEC;
> +		ts->tv_sec--;
> +	}

I had to think twice why adding the offset (which can be negative) can
never result in negative time being returned. A comment explaining this
would be appreciated.

As I'm planning to merge Vincezos VDSO consolidation into 5.3, can you
please start to work on top of his series, which should be available as
final v7 next week hopefully.

Thanks,

	tglx
