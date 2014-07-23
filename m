From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Wed, 23 Jul 2014 08:57:36 +0200
Message-ID: <20140723065736.GM3935@laptop>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <1406091303.5076.33.camel@marge.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406091303.5076.33.camel@marge.simpson.net>
Sender: linux-doc-owner@vger.kernel.org
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 23, 2014 at 06:55:03AM +0200, Mike Galbraith wrote:
> On Mon, 2014-07-21 at 09:42 -0700, Andi Kleen wrote:
> 
> > FWIW the main problem is currently that switch-through-idle is so 
> > slow. I think improving that would give a boost to far more
> > situations.
> 
> Two high frequency idle enter/exit suckage spots:
> 
> 1) nohz (tick) - it's expensive to start/stop tick on every micro-idle,
> throttle it or something.

Yeah, so the idea was to use the cpuidle idle guestimator to control
this, and now that we've moved it somewhat closer to the scheduler that
might become possible.

> 2) ondemand governor - tweak silly default settings to reflect the
> reality that we routinely schedule communicating threads cross core.

Yeah, so the plan is to shoot cpufreq in the head and base the
replacement on smp aware metrics ;-) Its on a todo list somewhere..
