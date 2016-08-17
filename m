From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 17 Aug 2016 11:33:23 +0200
Message-ID: <1471426403.4110.188.camel@gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org>
	 <1470474291.4117.243.camel@gmail.com> <20160810220944.GB3085@cmpxchg.org>
	 <20160816140738.GW6879@twins.programming.kicks-ass.net>
	 <20160816163045.GA16427@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160816163045.GA16427@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Tue, 2016-08-16 at 12:30 -0400, Johannes Weiner wrote:
> On Tue, Aug 16, 2016 at 04:07:38PM +0200, Peter Zijlstra wrote:

> > Also, the argument there seems unfair at best, you don't need cpu-v2 for
> > buffered write control, you only need memcg and block co-mounted.
> 
> Yes, memcg and block agreeing is enough for that case. But I mentioned
> a whole bunch of these examples, to make the broader case for a common
> controller model.

The core issue I have with that model is that it defines context=mm,
and declares context=task to be invalid, while in reality, both views
are perfectly valid, useful, and in use.  That redefinition of context
is demonstrably harmful when applied to scheduler related controllers,
rendering a substantial portion of to be managed objects completely
unmanageable.  You (collectively) know that full well.

AFAIKT, there is only one viable option, and that is to continue to
allow both.  Whether you like the duality or not (who would), it's
deeply embedded in what's under the controllers, and won't go away.

I'll now go try a little harder while you ponder (or pop) this thought
bubble, see if I can set a new personal best at the art of ignoring. 

(CC did not help btw, your bad if you don't like bubble content)

	-Mike
