From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Tue, 12 May 2015 06:35:31 +0200
Message-ID: <1431405331.3591.24.camel@gmail.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
	 <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
	 <20150508172210.559830a9@gandalf.local.home> <554D428E.6020702@ezchip.com>
	 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
	 <20150509070538.GA9413@gmail.com>
	 <20150511085759.71deeb64@gandalf.local.home>
	 <20150511153602.GA32512@lerouge> <1431371974.3195.126.camel@gmail.com>
	 <55510218.9090104@ezchip.com> <1431395275.3195.19.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431395275.3195.19.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-05-12 at 03:47 +0200, Mike Galbraith wrote:
> On Mon, 2015-05-11 at 15:25 -0400, Chris Metcalf wrote:
> > On 05/11/2015 03:19 PM, Mike Galbraith wrote:
> > > I really shouldn't have acked nohz_full -> isolcpus.  Beside the fact
> > > that old static isolcpus was_supposed_  to crawl off and die, I know
> > > beyond doubt that having isolated a cpu as well as you can definitely
> > > does NOT imply that said cpu should become tickless.
> > 
> > True, at a high level, I agree that it would be better to have a
> > top-level concept like Frederic's proposed ISOLATION that includes
> > isolcpus and nohz_cpu (and other stuff as needed).
> > 
> > That said, what you wrote above is wrong; even with the patch you
> > acked, setting isolcpus does not automatically turn on nohz_full for
> > a given cpu.  The patch made it true the other way around: when
> > you say nohz_full, you automatically get isolcpus on that cpu too.
> > That does, at least, make sense for the semantics of nohz_full.
> 
> I didn't write that, I wrote nohz_full implies (spelled '->') isolcpus.
> Yes, with nohz_full currently being static, the old allegedly dying but
> also static isolcpus scheduler off switch is a convenient thing to wire
> the nohz_full CPU SET (<- hint;) property to.

BTW, another facet of this: Rik wants to make isolcpus immune to
cpusets, which makes some sense, user did say isolcpus=, but that also
makes isolcpus truly static.  If the user now says nohz_full=, they lose
the ability to deactivate CPU isolation, making the set fairly useless
for anything other than HPC.  Currently, the user can flip the isolation
switch as he sees fit.  He takes a size extra large performance hit for
having said nohz_full=, but he doesn't lose generic utility.

	-Mike
