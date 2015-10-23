From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v8 00/14] support "task_isolation" mode for nohz_full
Date: Fri, 23 Oct 2015 15:29:08 +0200
Message-ID: <20151023132905.GA32453@lerouge>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <20151021123900.GD3604@twins.programming.kicks-ass.net>
 <562947B0.7050103@ezchip.com>
 <20151023023300.GC28099@lerouge>
 <20151023084951.GV17308@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151023084951.GV17308@twins.programming.kicks-ass.net>
Sender: linux-doc-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 23, 2015 at 10:49:51AM +0200, Peter Zijlstra wrote:
> On Fri, Oct 23, 2015 at 04:33:02AM +0200, Frederic Weisbecker wrote:
> > I personally (and I think this is the general LKML behaviour) use in-reply-to
> > when I post a single patch that is a fix for a bug, or a small enhancement,
> > discussed on some thread. It works well as it fits the conversation inline.
> > 
> > But for anything that requires significant changes, namely a patchset,
> > and that includes a new version of such patchset, it's usually better
> > to create a new thread. Otherwise the thread becomes an infinite mess and it
> > eventually expands further the mail client columns.
> 
> Agreed, although for single patches I use my regular mailer (mutt) and
> can't be arsed with tools.

Yeah me too, otherwise I can't write a text before the patch changelog.

> Also I don't actually use git-send-email ever, so I might be biased.

Ah it's just too convenient so I wrote my scripts on top of it :-)
But surely many mail sender libraries can post patches just fine as well.
