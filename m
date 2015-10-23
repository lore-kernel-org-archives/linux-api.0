From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v8 00/14] support "task_isolation" mode for nohz_full
Date: Fri, 23 Oct 2015 07:52:08 -0400
Message-ID: <20151023115208.GC7917@thunk.org>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <20151021123900.GD3604@twins.programming.kicks-ass.net>
 <562947B0.7050103@ezchip.com>
 <20151023090459.GW17308@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151023090459.GW17308@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 23, 2015 at 11:04:59AM +0200, Peter Zijlstra wrote:
> > If you think this is actually the wrong thing, is it worth trying
> > to fix the git docs to deprecate this option?
> 
> As said in the other email; git has different standards than lkml. By
> now we're just one of many many users of git.

Even git developers will create a new thread for a large (more than
2-3 patches) patch set.  However, for a single patch, people have
chained the -v3 version of the draft --- not to the v2 version,
though, but to the review of the patch.  And I've seen that behavior
on some LKML lists, and I'm certainly fine with it on linux-ext4.

But if you have a huge patch series, and you keep chaining it unto the
8th, 10th, 22nd version, it certainly will get **very** annoying for
some MUA's.

The bottom line is that you should use common sense, and it can be
hard to document every last bit of what should be "common sense" into
a rule that is followed by robots or a perl script.  (Which is one of
the reasons why I'm not fond of the philosophy that every single last
checkpatch warning or error should result in a "cleanup" patch, but
that's another issue.)

Cheers,

						- Ted
