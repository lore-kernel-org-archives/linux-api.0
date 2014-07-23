From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Wed, 23 Jul 2014 09:52:19 +0200
Message-ID: <20140723075219.GQ3935@laptop>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <1406091303.5076.33.camel@marge.simpson.net>
 <20140723065736.GM3935@laptop>
 <1406100346.5076.98.camel@marge.simpson.net>
 <20140723073518.GP3935@laptop>
 <1406101143.5076.100.camel@marge.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406101143.5076.100.camel@marge.simpson.net>
Sender: linux-doc-owner@vger.kernel.org
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 23, 2014 at 09:39:03AM +0200, Mike Galbraith wrote:
> On Wed, 2014-07-23 at 09:35 +0200, Peter Zijlstra wrote: 
> > On Wed, Jul 23, 2014 at 09:25:46AM +0200, Mike Galbraith wrote:
> > > I also resurrect mwait_idle(), as while you may consider it obsolete, I
> > > still love my lovely little Q6600 box (power sucking pig) dearly :)
> > 
> > Yeah, I keep forgetting about that one.. we should get that fixed.
> 
> (it is an obsolete pig, and nobody else seems to mind, so I don't mind)

Hey, I fixed early P4 topology setup yesterday, core2 is like brand
spanking new compared :-)
