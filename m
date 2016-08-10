From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 10:43:20 +0200
Message-ID: <20160810084320.GM6879@twins.programming.kicks-ass.net>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160803131940.GM6862@twins.programming.kicks-ass.net>
 <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <656745027.6624.1470773200334.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 09, 2016 at 08:06:40PM +0000, Mathieu Desnoyers wrote:
> > Also, do we want a comment somewhere that explains why overflow isn't a
> > problem?
> 
> I can add a comment about rseq_increment_event_counter stating:
> 
>  * Overflow of the event counter is not a problem in practice. It
>  * increments at most once between each user-space thread instruction
>  * executed, so we would need a thread to execute 2^32 instructions or
>  * more between rseq_start() and rseq_finish(), while single-stepping,
>  * for this to be an issue.
> 
> Is it fine, or should we be more conservative and care about the overflow,
> extending the counter to a 64-bit value in the process ?

I think its good enough; and using u64 has the unfortunate side effect
of not being able to share the word with the cpu number.

My point was more to have this stuff clearly documented.

> > Maybe I missed it, but why do we want to hook into NOTIFY_RESUME and not
> > have our own TIF flag?
> 
> The short answer is that used the same approach as Paul Turner's patchset. ;)
> 
> Through a deeper look into this, the only times we set the flag is when
> preempting and delivering a signal to a thread that has registered to
> rseq.

 <snip>

> So initial results seems to indicate that adding the notify_resume
> handling upon preemption does not have noticeable effects on
> performance, so I don't consider it worthwhile to try optimizing
> it by reserving its own thread flag. Or perhaps am I missing something
> important here ?

Not sure; seems like we can leave it as is for the moment. Again my
point was to make sure we've thought about the decision, and per the
above you clearly have now ;-)

> > Also, I think it would be good to have a comment explaining why this is
> > split in two structures? Don't you rely on the address dependency?
> 
> The comment above the rseq_cs fields needs clarification, how about:
> 
>         /*
>          * Restartable sequences rseq_cs field.
>          * Contains NULL when no critical section is active for the
>          * current thread, or holds a pointer to the currently active
>          * struct rseq_cs.
>          * Updated by user-space at the beginning and end of assembly
>          * instruction sequence block, and by the kernel when it
>          * restarts an assembly instruction sequence block. Read by the
>          * kernel with single-copy atomicity semantics. Aligned on
>          * 64-bit.
>          */
> 
> This really explains that rseq_cs field of struct rseq holds a pointer
> to the current struct rseq_cs (or NULL), which makes it obvious why this
> needs to be two different structures.

I think I'm still missing things as its not obvious to me at all :/

We could equally well have chosen a single structure and picked the
post_commit_ip field to trigger things from, no?

The only down side seems to be that we must then impose ordering (but UP
ordering, so that's cheap) between writing the abort_ip and
post_commit_ip.

That is; something like so:

struct rseq {
	union rseq_event_cpu u;

	u64 abort_ip;
	u64 post_commit_ip;
};

Where userspace must do:

	r->abort_ip = $abort_ip;
	barrier();
	WRITE_ONCE(r->post_commit_ip, $post_commit_ip);
	barrier();

Which is not much different from what Paul did, except he kept the
abort_ip in a register (which must be loaded before setting the
commit_ip).

And the kernel checks post_commit_ip, if 0, nothing happens, otherwise
we check instruction_pointer and do magic.

Then after the commit, we clear post_commit_ip again; just like we now
clear the rseq_cs pointer.

AFAICT this is an equally valid approach. So why split and put that
indirection in?

> Combined with other recent feedback, this becomes:
> 
>  *   The abort_ip address needs to be lesser than start_ip, or

Isn't it "less than" ?

>  *   greater-or-equal the post_commit_ip. Step [4] and the failure
>  *   code step [F1] need to be at addresses lesser than start_ip, or
>  *   greater-or-equal the post_commit_ip.
> 


> >> +	if (current->rseq) {
> >> +		/*
> >> +		 * If rseq is already registered, check whether
> >> +		 * the provided address differs from the prior
> >> +		 * one.
> >> +		 */
> >> +		if (current->rseq != rseq)
> >> +			return -EBUSY;
> > 
> > Why explicitly allow resetting the same value?
> 
> The foreseen use is as follows: let's assume we have one or more
> user-space libraries, and possibly the application, each using rseq.
> They would each define a struct rseq TLS. They are expected to all
> give it the same name (e.g. __rseq_thread_state), and mark it as a
> weak symbol, so all uses of that symbol within the process address
> space will refer to the same address for a given thread.

Cute!
