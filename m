From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Fri, 8 May 2015 17:22:10 -0400
Message-ID: <20150508172210.559830a9@gandalf.local.home>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
	<20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
Sender: linux-doc-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 8 May 2015 14:18:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 8 May 2015 13:58:41 -0400 Chris Metcalf <cmetcalf@ezchip.com> wrote:
> 
> > A prctl() option (PR_SET_DATAPLANE) is added
> 
> Dumb question: what does the term "dataplane" mean in this context?  I
> can't see the relationship between those words and what this patch
> does.

I was thinking the same thing. I haven't gotten around to searching
DATAPLANE yet.

I would assume we want a name that is more meaningful for what is
happening.

-- Steve
