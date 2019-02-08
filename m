From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/32] timens: Introduce CLOCK_MONOTONIC offsets
Date: Fri, 8 Feb 2019 10:46:35 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1902080859460.1645@nanos.tec.linutronix.de>
References: <20190206001107.16488-1-dima@arista.com> <20190206001107.16488-4-dima@arista.com> <alpine.DEB.2.21.1902072225420.1645@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1902072225420.1645@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 7 Feb 2019, Thomas Gleixner wrote:
> Does this really need to be an out of line call? If you stick this into the
> clock_get() implementations then it boils down to:
> 
> static inline void timens_add_monotonic(struct timespec64 *ts)
> {
> 	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
> 
> 	if (ns_offsets)
> 		*ts = timespec64_add(*ts, ns_offsets->monotonic_time_offset);

And this needs to be a special variant of
timespec64-add_safe(). timespec64_add_safe() is not sufficient, because it
assumes that both values are positive, which is not the case here..

In timer_set() implementations you move the timespec_valid() check after
the add. That's wrong because you really want to check the input value from
user space.

Assume that the caller supplied value is valid and the adjustment brings it
out of range then how should the caller understand why it it rejected?

So timespec64_add_namespace() must check for under and overflow. But doing
this with timespecs is a pain. I rather suggest to rework the whole thing
so hrtimer_nanosleep() takes a ktime_t expiry value and move the conversion
to the call sites. Then the whole offset magic becomes:

   expires = timespec64_to_ktime(rqtp);

   if (abstime)
   	expires = timens_to_host_mono(expires);

and that function can nicely do the underflow and overflow detection and
cap the values to 0 on underflow and KTIME_MAX on overflow.

Hmm?

Thanks,

	tglx
