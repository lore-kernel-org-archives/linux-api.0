From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v2 3/3] restartable sequences: basic self-tests
Date: Wed, 6 Apr 2016 21:25:34 +0200
Message-ID: <20160406192534.GX3448@twins.programming.kicks-ass.net>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <20151027235716.16059.47610.stgit@pjt-glaptop.roam.corp.google.com>
 <1276514010.46061.1459888406999.JavaMail.zimbra@efficios.com>
 <20160406074309.GE3430@twins.programming.kicks-ass.net>
 <528054829.46502.1459949962537.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <528054829.46502.1459949962537.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 06, 2016 at 01:39:22PM +0000, Mathieu Desnoyers wrote:
> There is still the question of use-after-free however that
> remains open. My understanding is that this lock-free list
> should be paired with either a type-safe memory allocator,
> using RCU, or a garbage collector.

Yeah, it looks that way indeed, there no sane way to fix that either,
even if you stick all this inside the rseq_start/finish thing you'll get
use-after-free, because we'll not restart until rseq_finish fails.
