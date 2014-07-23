From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Wed, 23 Jul 2014 09:25:46 +0200
Message-ID: <1406100346.5076.98.camel@marge.simpson.net>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <8761iq3bp3.fsf@tassilo.jf.intel.com>
	 <1406091303.5076.33.camel@marge.simpson.net> <20140723065736.GM3935@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140723065736.GM3935@laptop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2014-07-23 at 08:57 +0200, Peter Zijlstra wrote: 
> On Wed, Jul 23, 2014 at 06:55:03AM +0200, Mike Galbraith wrote:
> > On Mon, 2014-07-21 at 09:42 -0700, Andi Kleen wrote:
> > 
> > > FWIW the main problem is currently that switch-through-idle is so 
> > > slow. I think improving that would give a boost to far more
> > > situations.
> > 
> > Two high frequency idle enter/exit suckage spots:
> > 
> > 1) nohz (tick) - it's expensive to start/stop tick on every micro-idle,
> > throttle it or something.
> 
> Yeah, so the idea was to use the cpuidle idle guestimator to control
> this, and now that we've moved it somewhat closer to the scheduler that
> might become possible.
> 
> > 2) ondemand governor - tweak silly default settings to reflect the
> > reality that we routinely schedule communicating threads cross core.
> 
> Yeah, so the plan is to shoot cpufreq in the head and base the
> replacement on smp aware metrics ;-) Its on a todo list somewhere..

It never ceases to amaze me that people aren't screaming bloody murder
about those two spots.  Watching performance of lightly loaded boxen is
enough to make a grown man cry.

SUSE (and I in all of my many regression testing trees) puts tourniquets
on both of these blood spurting gashes, laptops be damned.

I also resurrect mwait_idle(), as while you may consider it obsolete, I
still love my lovely little Q6600 box (power sucking pig) dearly :)

-Mike
