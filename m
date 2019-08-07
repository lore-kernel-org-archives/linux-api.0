From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 09/37] posix-clocks: Introduce CLOCK_MONOTONIC time
 namespace offsets
Date: Wed, 7 Aug 2019 08:07:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908070805460.24014@nanos.tec.linutronix.de>
References: <20190729215758.28405-1-dima@arista.com> <20190729215758.28405-10-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-10-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 29 Jul 2019, Dmitry Safonov wrote:
>  
> +static inline void timens_add_monotonic(struct timespec64 *ts)
> +{
> +	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
> +
> +	if (ns_offsets)
> +		*ts = timespec64_add(*ts, ns_offsets->monotonic);
> +}

This helper is not posix timer specific and should be introduced either in
the name space patches or in a separate patch,

Thanks

	tglx
