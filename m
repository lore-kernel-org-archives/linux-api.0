From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCHv3 05/27] timerfd/timens: Take into account ns clock
 offsets
Date: Fri, 3 May 2019 00:00:29 -0700
Message-ID: <20190503070028.GA7984@gmail.com>
References: <20190425161416.26600-1-dima@arista.com>
 <20190425161416.26600-6-dima@arista.com>
 <alpine.DEB.2.21.1904252207170.1768@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904252207170.1768@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Thomas,

Thank you for the review.  I read your comments. All of them look
reasonable. I'm sorry that you had to comment a lot. Will fix in the
next version.

Thanks,
Andrei

On Thu, Apr 25, 2019 at 11:28:24PM +0200, Thomas Gleixner wrote:
> On Thu, 25 Apr 2019, Dmitry Safonov wrote:
> > From: Andrei Vagin <avagin@gmail.com>
> > 
> > Make timerfd respect timens offsets.
> > Provide a helper timens_ktime_to_host() that is useful to wire up
> > timens to different kernel subsystems.
> 
> Yet another changelog which lacks meat.
> 
> > @@ -179,6 +180,8 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
> >  	htmode = (flags & TFD_TIMER_ABSTIME) ?
> >  		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
> >  
> > +	htmode |= HRTIMER_MODE_NS;
> 
> Without looking further this time. My gut reaction is that this is
> wrong. Name space adjustment is only valid for absolute timers not for
> relative timers.
> 
> Aside of that the name sucks. MODE_NS is really not intuitive. It could be
> NanoSeconds or whatever and quite some time(r) functions have a _ns element
> already. Please look for something more inuitive and clearly related to
> namespaces. We are not short of letters.
> 
> >  	texp = timespec64_to_ktime(ktmr->it_value);
> >  	ctx->expired = 0;
> >  	ctx->ticks = 0;
> > @@ -197,9 +200,10 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
> >  
> >  	if (texp != 0) {
> >  		if (isalarm(ctx)) {
> > -			if (flags & TFD_TIMER_ABSTIME)
> > +			if (flags & TFD_TIMER_ABSTIME) {
> > +				texp = timens_ktime_to_host(clockid, texp);
> 
> You are not serious about that inline function here? It's huge and
> pointless bloat because the only time affected here is boot time, but the
> compiler does not know that.
> 
> >  				alarm_start(&ctx->t.alarm, texp);
> 
> Make that:
> 
>    alarm_start_namespace(.....)
> 
> and that does:
> 
> void alarm_start_namespace(struct alarm *alarm, ktime_t expires)
> {
> 	if (alarm->type == ALARM_BOOTTIME)
> 		expires = timens_sub_boottime(expires);
> 	alarm_start(alarm, expires);
> }
> 
> Hmm?
> 
> > -			else
> > +			} else
> >  				alarm_start_relative(&ctx->t.alarm, texp);
> >  		} else {
> >  			hrtimer_start(&ctx->t.tmr, texp, htmode);
> > diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> > index 2e8957eac4d4..4b9c89c797ee 100644
> > --- a/include/linux/hrtimer.h
> > +++ b/include/linux/hrtimer.h
> > @@ -38,6 +38,7 @@ enum hrtimer_mode {
> >  	HRTIMER_MODE_REL	= 0x01,
> >  	HRTIMER_MODE_PINNED	= 0x02,
> >  	HRTIMER_MODE_SOFT	= 0x04,
> > +	HRTIMER_MODE_NS		= 0x08,
> >  
> >  	HRTIMER_MODE_ABS_PINNED = HRTIMER_MODE_ABS | HRTIMER_MODE_PINNED,
> >  	HRTIMER_MODE_REL_PINNED = HRTIMER_MODE_REL | HRTIMER_MODE_PINNED,
> > diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
> > index 5f0da6858b10..988414f7f791 100644
> > --- a/include/linux/time_namespace.h
> > +++ b/include/linux/time_namespace.h
> > @@ -56,6 +56,41 @@ static inline void timens_add_boottime(struct timespec64 *ts)
> >                  *ts = timespec64_add(*ts, ns_offsets->monotonic_boottime_offset);
> >  }
> >  
> > +static inline ktime_t timens_ktime_to_host(clockid_t clockid, ktime_t tim)
> > +{
> > +	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
> > +	struct timespec64 *offset;
> > +	ktime_t koff;
> > +
> > +	if (!ns_offsets)
> > +		return tim;
> > +
> > +	switch (clockid) {
> > +		case CLOCK_MONOTONIC:
> > +		case CLOCK_MONOTONIC_RAW:
> > +		case CLOCK_MONOTONIC_COARSE:
> 
> What's the point of COARSE and RAW? Neither of them can be used to arm
> timers.
> 
> > +			offset = &ns_offsets->monotonic_time_offset;
> > +			break;
> > +		case CLOCK_BOOTTIME:
> > +		case CLOCK_BOOTTIME_ALARM:
> > +			offset = &ns_offsets->monotonic_boottime_offset;
> > +			break;
> > +		default:
> > +			return tim;
> > +	}
> > +
> > +	koff = timespec64_to_ktime(*offset);
> 
> What about storing both the timespec and the ktime_t representation?
> 
> > +	if (tim < koff)
> > +		tim = 0;
> > +	else if (KTIME_MAX - tim < -koff)
> > +		tim = KTIME_MAX;
> 
> Blink!?! This is completely nonobvious and you're going to stare at it in
> disbelief half a year from now. Comments exist for a reason.
> 
> > +	else
> > +		tim = ktime_sub(tim, koff);
> > +
> > +	return tim;
> 
> This whole thing is way too large for inlining.
> 
> Please create a function which does the magic substraction, something like
> ktime_sub_namespace_offset() and invoke it from the proper places, i.e. the
> alarmtimer one.
> 
> > @@ -1069,6 +1070,8 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
> >  
> >  	if (mode & HRTIMER_MODE_REL)
> >  		tim = ktime_add_safe(tim, base->get_time());
> > +	else if (mode & HRTIMER_MODE_NS)
> > +		tim = timens_ktime_to_host(base->clockid, tim);
> 
> You can do the same as for alarmtime above:
> 
> hrtimer_start_namespace(struct hrtimer *timer, ktime_t tim,
> 			const enum hrtimer_mode mode)
> {
> 	if (mode & HRTIMER_MODE_ABS) {
> 		switch(timer->base->clockid) {
> 		case CLOCK_MONOTONIC:
> 			tim = timens_sub_monotonic(tim);
> 			break;
> 		case CLOCK_BOOTTIME:
> 			tim = timens_sub_boottime(tim);
> 			break;
> 		}
> 	}
> 	hrtimer_start(timer, tim, mode);
> }
> 
> Thanks,
> 
> 	tglx
