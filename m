From: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Fri, 19 Aug 2016 15:59:38 -0700
Message-ID: <20160819225938.GC1228@davejwatson-mba.local>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1471637274-13583-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g@mail.gmail.com>
 <20160819205611.GF5871@two.firstfloor.org>
 <20160819212423.623v5leqknfrxhpd@x>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160819212423.623v5leqknfrxhpd@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>Catalin Marinas <c>
List-Id: linux-api@vger.kernel.org

On 08/19/16 02:24 PM, Josh Triplett wrote:
> On Fri, Aug 19, 2016 at 01:56:11PM -0700, Andi Kleen wrote:
> > > Nobody gets a cpu number just to get a cpu number - it's not a useful
> > > thing to benchmark. What does getcpu() so much that we care?
> > 
> > malloc is the primary target I believe. Saves lots of memory to keep
> > caches per CPU rather than per thread.
> 
> Also improves locality; that does seem like a good idea.  Has anyone
> written and tested the corresponding changes to a malloc implementation?
> 

I had modified jemalloc to use rseq instead of per-thread caches, and
did some testing on one of our services.

Memory usage decreased by ~20% due to fewer caches.  Our services
generally have lots and lots of idle threads (~400), and we already go
through a few hoops to try and flush idle thread caches.  Threads are
often coming from dependent libraries written by disparate teams,
making them harder to reduce to a smaller number.

We also have quite a few data structures that are sharded
thread-locally only to avoid contention, for example we have extensive
statistics code that would also be a prime candidate for rseq .  We
often have to prune some stats because they're taking up too much
memory, rseq would let us fit a bit more in.

jemalloc diff here (pretty stale now):

https://github.com/djwatson/jemalloc/commit/51f6e6f61b88eee8de981f0f2d52bc48f85e0d01

Original numbers posted here:

https://lkml.org/lkml/2015/10/22/588
