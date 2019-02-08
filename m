From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/32] timens/kernel: Take into account timens clock
 offsets in clock_nanosleep
Date: Fri, 8 Feb 2019 08:56:25 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1902072242220.1645@nanos.tec.linutronix.de>
References: <20190206001107.16488-1-dima@arista.com> <20190206001107.16488-8-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-8-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 6 Feb 2019, Dmitry Safonov wrote:
>  
> @@ -1721,9 +1722,16 @@ long hrtimer_nanosleep(const struct timespec64 *rqtp,
>  {
>  	struct restart_block *restart;
>  	struct hrtimer_sleeper t;
> +	struct timespec64 tp;
>  	int ret = 0;
>  	u64 slack;
>  
> +	if (!(mode & HRTIMER_MODE_REL)) {
> +		tp = *rqtp;
> +		rqtp = &tp;

So every invocation of hrtimer_nanosleep() gains a copy of the timespec64
even if the namespace muck is disabled.

The only relevant caller of this is common_nsleep(). So it might make sense
to have common_nsleep() separated for CLOCK_MONOTONIC/BOOTTIME and handle
the thing there. That again avoids the switch() to and out of line calls.

Thanks,

	tglx
