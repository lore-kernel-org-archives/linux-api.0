From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Mon, 11 May 2015 21:19:34 +0200
Message-ID: <1431371974.3195.126.camel@gmail.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
	 <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
	 <20150508172210.559830a9@gandalf.local.home> <554D428E.6020702@ezchip.com>
	 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
	 <20150509070538.GA9413@gmail.com>
	 <20150511085759.71deeb64@gandalf.local.home>
	 <20150511153602.GA32512@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150511153602.GA32512@lerouge>
Sender: linux-doc-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-05-11 at 17:36 +0200, Frederic Weisbecker wrote:

> I expect some Real Time users may want this kind of dataplane mode where a syscall
> or whatever sleeps until the system is ready to provide the guarantee that no
> disturbance is going to happen for a given time. I'm not sure HPC users are interested
> in that.

I bet they are.  RT is just a different way to spell HPC, and reverse.

> In fact it goes along the fact that NO_HZ_FULL was really only supposed to be about
> the tick and now people are introducing more and more kernel default presetting that
> assume NO_HZ_FULL implies ISOLATION which is about all kind of noise (tick, tasks, irqs,
> ...). Which is true but what kind of ISOLATION?

True, nohz mode and various isolation measures are distinct properties.
NO_HZ_FULL is kinda pointless without isolation measures to go with it,
but you're right.

I really shouldn't have acked nohz_full -> isolcpus.  Beside the fact
that old static isolcpus was _supposed_ to crawl off and die, I know
beyond doubt that having isolated a cpu as well as you can definitely
does NOT imply that said cpu should become tickless.  I routinely run a
load model that wants all the isolation it can get.  It's not single
task compute though, rt executive coordinating rt workers, and of course
wants every cycle it can get, so nohz_full is less than helpful.

	-Mike

