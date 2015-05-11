From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Mon, 11 May 2015 10:19:16 -0700
Message-ID: <20150511171916.GN6776@linux.vnet.ibm.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
 <20150508172210.559830a9@gandalf.local.home>
 <554D428E.6020702@ezchip.com>
 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
 <20150509070538.GA9413@gmail.com>
 <20150511085759.71deeb64@gandalf.local.home>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150511085759.71deeb64@gandalf.local.home>
Sender: linux-doc-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, May 11, 2015 at 08:57:59AM -0400, Steven Rostedt wrote:
> 
> NO_HZ_LEAVE_ME_THE_FSCK_ALONE!

NO_HZ_OVERFLOWING?

Kconfig naming controversy aside, I believe this patchset is addressing
a real need.  Might need additional adjustment, but something useful.

							Thanx, Paul

> On Sat, 9 May 2015 09:05:38 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > So I think we should either rename NO_HZ_FULL to NO_HZ_PURE, or keep 
> > it at NO_HZ_FULL: because the intention of NO_HZ_FULL was always to be 
> > such a 'zero overhead' mode of operation, where if user-space runs, it 
> > won't get interrupted in any way.
> 
> 
> All kidding aside, I think this is the real answer. We don't need a new
> NO_HZ, we need to make NO_HZ_FULL work. Right now it doesn't do exactly
> what it was created to do. That should be fixed.
> 
> Please lets get NO_HZ_FULL up to par. That should be the main focus.
> 
> -- Steve
> 

