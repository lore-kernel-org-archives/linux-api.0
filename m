From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 11:30:29 -0700
Message-ID: <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
 <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480-kTBAvIqET4EjX1lkf7hTyId3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, David Goldblatt <davidgoldblatt-b10kYP2dOMg@public.gmane.org>, Qi Wang <qiwang-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 13, 2017 at 2:35 AM, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org> wrote:
>
> I'm really excited to hear that you're open to this patch set and totally understand the desire for some more numbers.

So the patch-set actually looks very reasonable today. I looked
through it (ok, I wasn't cc'd on the ppc-only patches so I didn't look
at those, but I don't think they are likely objectionable either), and
everything looked fine from a patch standpoint.

But it's not _just_ numbers for real loads I'm looking for, it's
actually an _existence proof_ for a real load too. I'd like to know
that the suggested interface _really_ works in practice too for all
the expected users.

In particular, it's easy to make test-cases to show basic
functionality, but that does not necessarily show that the interface
then works in "real life".

For example, if this is supposed to work for a malloc library, it's
important that people show that yes, this can really work in a
*LIBRARY*.

That sounds so obvious and stupid that you might go "What do you
mean?", but for things to work for libraries, they have to work
together with *other* users, and with *independent* users.

For example, say that you're some runtime that wants to use the percpu
thing for percpu counters - because you want to avoid cache ping-pong,
and you want to avoid per-thread allocation overhead (or per-thread
scaling for just summing up the counters) when you have potentially
tens of thousands of threads.

Now, how does this runtime work *together* with

 - CPU hotplug adding new cpu's while you are running (and after you
allocated your percpu areas)

 - libraries and system admins that limit - or extend - you to a
certain set of CPUs

 - another library (like the malloc library) that wants to use the
same interface for its percpu allocation queues.

maybe all of this "just works", but I really want to see an existence
proof.  Not just a "dedicated use of the interface for one benchmark".

So yes, I want to see numbers, but I really want to see something much
more fundamental. I want to feel like there is a good reason to
believe that the interface really is sufficient and that it really
does work, even when a single thread may have multiple *different*
uses for this. Statistics, memory allocation queues, RCU, per-cpu
locking, yadda yadda. All these things may want to use this, but they
want to use it *together*, and without you having to write special
code where every user needs to know about every other user statically.

Can you load two different *dynamic* libraries that each independently
uses this thing for their own use, without having to be built together
for each other?

>> A "increment percpu value" simply isn't relevant.
>
> While I understand it seems trivial, my experience has been that this type of operation can actually be important in many server workloads.

Oh, I'm not saying that it's not relevant to have high-performance
statistics gathering using percpu data structures. Of _course_ that is
important, we do that very much in the kernel itself.

But a benchmark that does nothing else really isn't relevant.  If the
*only* thing somebody uses this for is statistics, it's simply not
good enough.


>> Because without real-world uses, it's not obvious that there won't be
>> somebody who goes "oh, this isn't quite enough for us, the semantics
>> are subtly incompatible with our real-world use case".
>
> Is your concern mainly this question (is this patchset a good way to
> bring per-cpu algorithms to userspace)? I'm hoping that given the
> variety of ways that per-cpu data structures are used in the kernel
> the concerns around this patch set are mainly around what approach we
> should take rather than if per-cpu algorithms are a good idea at all.
> If this is your main concern perhaps our focus should be around
> demonstrating that a number of useful per-cpu algorithms can be
> implemented using restartable sequences.

The important thing for me is that it should demonstrate that you can
have users co-exists, and that the interface is sufficient for that.

So I do want to see "just numbers" in the sense that I would want to
see that people have actually written code that takes advantage of the
percpu nature to do real things (like an allocator). But more than
that, I want to see *use*.

> Ultimately I'm worried there's a chicken and egg problem here.

This patch-set has been around for *years* in some form. It's improved
over the years, but the basic approaches are not new.

Honestly, if people still don't have any actual user-level code that
really _uses_ this, I'm not interested in merging it.

There's no chicken-and-egg here. Anybody who wants to push this
patch-set needs to write the user level code to validate that the
patch-set makes sense. That's not chicken-and-egg, that's just
"without the user-space code, the kernel code has never been tested,
validated or used".

And if nobody can be bothered to write the user-level code and test
this patch-series, then obviously it's not important enough for the
kernel to merge it.

                      Linus
