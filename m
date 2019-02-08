From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH 03/32] timens: Introduce CLOCK_MONOTONIC offsets
Date: Fri, 8 Feb 2019 01:02:59 -0800
Message-ID: <20190208090258.GA31765@gmail.com>
References: <20190206001107.16488-1-dima@arista.com>
 <20190206001107.16488-4-dima@arista.com>
 <alpine.DEB.2.21.1902072225420.1645@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1902072225420.1645@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 07, 2019 at 10:40:55PM +0100, Thomas Gleixner wrote:
> On Wed, 6 Feb 2019, Dmitry Safonov wrote:
> >  #include "timekeeping.h"
> >  #include "posix-timers.h"
> > @@ -1041,6 +1042,9 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
> >  
> >  	error = kc->clock_get(which_clock, &kernel_tp);
> >  
> > +	if (!error && kc->clock_timens_adjust)
> > +		timens_clock_from_host(which_clock, &kernel_tp);
> 
> Why are you adding this conditional instead of sticking the offset
> magic into the affected ->clock_get() implementations?
> 
> That spares you the switch() and the !offsets conditional.
> 
> > +static void clock_timens_fixup(int clockid, struct timespec64 *val, bool to_ns)
> > +{
> > +	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
> > +	struct timespec64 *offsets = NULL;
> > +
> > +	if (!ns_offsets)
> > +		return;
> > +
> > +	if (val->tv_sec == 0 && val->tv_nsec == 0)
> > +		return;
> 
> I have no idea why 0/0 is special.

Initially this function was introduced to apply timens offsets in
do_timer_settime and there it is special and means that the timer should
be disarmed.

Now this functions is used in many other places and this check defenetly
sould not be here.


> 
> > +
> > +	switch (clockid) {
> > +	case CLOCK_MONOTONIC:
> > +	case CLOCK_MONOTONIC_RAW:
> > +	case CLOCK_MONOTONIC_COARSE:
> > +		offsets = &ns_offsets->monotonic_time_offset;
> > +		break;
> > +	}
> > +
> > +	if (!offsets)
> > +		return;
> > +
> > +	if (to_ns)
> > +		*val = timespec64_add(*val, *offsets);
> > +	else
> > +		*val = timespec64_sub(*val, *offsets);
> > +}
> > +
> > +void timens_clock_to_host(int clockid, struct timespec64 *val)
> 
> Does this really need to be an out of line call?

The idea was to collect all the logic about timens offsets in one place.

clock_timens_fixup() is used in all places where we need apply timens
offsets (clock_gettim, posix timers, clock_nanosleep, timerfd, uptime_proc_show).


> If you stick this into the
> clock_get() implementations then it boils down to:

clock_get() is called from clock_gettime and from common_timer_get(). In
common_timer_get(), we expect to get time in the root time namespace.

but I think we can handle this. For example, we can introduce a new flag
CLOCL_TIMENS and

kc->clock_get(which_clock | CLOCK_TIMENS, &tp) will return time in a
current time namespace.

kc->clock_get(which_clock, &tp) will return time in the root time
namespace.

> 
> static inline void timens_add_monotonic(struct timespec64 *ts)
> {
> 	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
> 
> 	if (ns_offsets)
> 		*ts = timespec64_add(*ts, ns_offsets->monotonic_time_offset);
> }
> 
> and
> 
> static int posix_ktime_get_ts(clockid_t which_clock, struct timespec64 *tp)
> {
>         ktime_get_ts64(tp);
> 	timens_add_monotonic(tp);
>         return 0;
> }
> 
> Hmm?

Yes, we can do this. I like this idea. This will allow us to remove
timens_clock_to_host(), but I am not sure that we will be able to do
something similar with timens_clock_from_host, which is used to apply
offsets for timers. I need to look at the timer code again.


Thanks,
Andrei

> 
> Thanks,
> 
> 	tglx
> 
