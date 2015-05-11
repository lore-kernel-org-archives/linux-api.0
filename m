From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Mon, 11 May 2015 14:00:09 -0400
Message-ID: <20150511140009.1f7bcf07@gandalf.local.home>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
	<20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
	<20150508172210.559830a9@gandalf.local.home>
	<554D428E.6020702@ezchip.com>
	<20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
	<20150509070538.GA9413@gmail.com>
	<20150511085759.71deeb64@gandalf.local.home>
	<20150511171916.GN6776@linux.vnet.ibm.com>
	<20150511102744.9ebb2d05a7e8b457d03430bf@linux-foundation.org>
	<20150511173305.GC32512@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150511173305.GC32512@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>, Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 11 May 2015 19:33:06 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, May 11, 2015 at 10:27:44AM -0700, Andrew Morton wrote:
> > On Mon, 11 May 2015 10:19:16 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Mon, May 11, 2015 at 08:57:59AM -0400, Steven Rostedt wrote:
> > > > 
> > > > NO_HZ_LEAVE_ME_THE_FSCK_ALONE!
> > > 
> > > NO_HZ_OVERFLOWING?
> > 
> > Actually, "NO_HZ" shouldn't appear in the name at all.  The objective
> > is to permit userspace to execute without interruption.  NO_HZ is a
> > part of that, as is NO_INTERRUPTS.  The "NO_HZ" thing is a historical
> > artifact from an early partial implementation.
> 
> Agreed! Which is why I'd rather advocate in favour of CONFIG_ISOLATION.

Then we should have CONFIG_LEAVE_ME_THE_FSCK_ALONE. Hmm, I guess that's
just an synonym for CONFIG_ISOLATION.

-- Steve
