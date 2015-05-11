From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Mon, 11 May 2015 15:25:12 -0400
Message-ID: <55510218.9090104@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>	 <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>	 <20150508172210.559830a9@gandalf.local.home> <554D428E.6020702@ezchip.com>	 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>	 <20150509070538.GA9413@gmail.com>	 <20150511085759.71deeb64@gandalf.local.home>	 <20150511153602.GA32512@lerouge> <1431371974.3195.126.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1431371974.3195.126.camel@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mike Galbraith <umgwanakikbuti@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/11/2015 03:19 PM, Mike Galbraith wrote:
> I really shouldn't have acked nohz_full -> isolcpus.  Beside the fact
> that old static isolcpus was_supposed_  to crawl off and die, I know
> beyond doubt that having isolated a cpu as well as you can definitely
> does NOT imply that said cpu should become tickless.

True, at a high level, I agree that it would be better to have a
top-level concept like Frederic's proposed ISOLATION that includes
isolcpus and nohz_cpu (and other stuff as needed).

That said, what you wrote above is wrong; even with the patch you
acked, setting isolcpus does not automatically turn on nohz_full for
a given cpu.  The patch made it true the other way around: when
you say nohz_full, you automatically get isolcpus on that cpu too.
That does, at least, make sense for the semantics of nohz_full.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

