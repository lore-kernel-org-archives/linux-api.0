From: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Wed, 28 Oct 2015 07:44:01 -0700
Message-ID: <20151028144401.GB2994761@devbig217.prn1.facebook.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151027235635.16059.11630.stgit-G8L5E6GV2z5XSTzz+wBt03oUN1GumTyQ7j82oEJ37pA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/27/15 04:56 PM, Paul Turner wrote:
> This series is a new approach which introduces an alternate ABI that does not
> depend on open-coded assembly nor a central 'repository' of rseq sequences.
> Sequences may now be inlined and the preparatory[*] work for the sequence can
> be written in a higher level language.

Very nice, it's definitely much easier to use.

> Exactly, for x86_64 this looks like:
>   movq <failed>, rcx [1]
>   movq $1f, <commit_instr> [2]
>   cmpq <start value>, <current value> [3] (start is in rcx)
>   jnz <failed> (4)
>   movq <to_write>, (<target>) (5)
>   1: movq $0, <commit_instr>
>
> There has been some related discussion, which I am supportive of, in which
> we use fs/gs instead of TLS.  This maps naturally to the above and removes
> the current requirement for per-thread initialization (this is a good thing!).
>
> On debugger interactions:
>
> There are some nice properties about this new style of API which allow it to
> actually support safe interactions with a debugger:
>  a) The event counter is a per-cpu value.  This means that we can not advance
>     it if no threads from the same process execute on that cpu.  This
>     naturally allows basic single step support with thread-isolation.

I think this means multiple processes would no longer be able to use
per-cpu variables in shared memory, since they would no longer restart
with respect to each other?

>  b) Single-step can be augmented to evalute the ABI without incrementing the
>     event count.
>  c) A debugger can also be augmented to evaluate this ABI and push restarts
>     on the kernel's behalf.
>
> This is also compatible with David's approach of not single stepping between
> 2-4 above.  However, I think these are ultimately a little stronger since true
> single-stepping and breakpoint support would be available.  Which would be
> nice to allow actual debugging of sequences.
