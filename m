From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able
 ring buffer
Date: Fri, 31 May 2019 15:26:20 +0200
Message-ID: <20190531132620.GC2606@hirez.programming.kicks-ass.net>
References: <20190531111445.GO2677@hirez.programming.kicks-ass.net>
 <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
 <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <20190528231218.GA28384@kroah.com>
 <31936.1559146000@warthog.procyon.org.uk>
 <16193.1559163763@warthog.procyon.org.uk>
 <21942.1559304135@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-16020-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <21942.1559304135@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Fri, May 31, 2019 at 01:02:15PM +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Can you re-iterate the exact problem? I konw we talked about this in the
> > past, but I seem to have misplaced those memories :/
> 
> Take this for example:
> 
> 	void afs_put_call(struct afs_call *call)
> 	{
> 		struct afs_net *net = call->net;
> 		int n = atomic_dec_return(&call->usage);
> 		int o = atomic_read(&net->nr_outstanding_calls);
> 
> 		trace_afs_call(call, afs_call_trace_put, n + 1, o,
> 			       __builtin_return_address(0));
> 
> 		ASSERTCMP(n, >=, 0);
> 		if (n == 0) {
> 			...
> 		}
> 	}
> 
> I am printing the usage count in the afs_call tracepoint so that I can use it
> to debug refcount bugs.  If I do it like this:
> 
> 	void afs_put_call(struct afs_call *call)
> 	{
> 		int n = refcount_read(&call->usage);
> 		int o = atomic_read(&net->nr_outstanding_calls);
> 
> 		trace_afs_call(call, afs_call_trace_put, n, o,
> 			       __builtin_return_address(0));
> 
> 		if (refcount_dec_and_test(&call->usage)) {
> 			...
> 		}
> 	}
> 
> then there's a temporal gap between the usage count being read and the actual
> atomic decrement in which another CPU can alter the count.  This can be
> exacerbated by an interrupt occurring, a softirq occurring or someone enabling
> the tracepoint.
> 
> I can't do the tracepoint after the decrement if refcount_dec_and_test()
> returns false unless I save all the values from the object that I might need
> as the object could be destroyed any time from that point on.

Is it not the responsibility of the task that affects the 1->0
transition to actually free the memory?

That is, I'm expecting the '...' in both cases above the include the
actual freeing of the object. If this is not the case, then @usage is
not a reference count.

(and it has already been established that refcount_t doesn't work for
usage count scenarios)

Aside from that, is the problem that refcount_dec_and_test() returns a
boolean (true - last put, false - not last) instead of the refcount
value? This does indeed make it hard to print the exact count value for
the event.
