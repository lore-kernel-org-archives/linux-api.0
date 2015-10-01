From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v7 02/11] task_isolation: add initial support
Date: Thu, 1 Oct 2015 23:20:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1510012224190.4500@nanos>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com> <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com> <20151001121414.GB3432@lerouge> <alpine.DEB.2.11.1510011416160.4500@nanos> <560D6725.9000609@ezchip.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560D6725.9000609-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 1 Oct 2015, Chris Metcalf wrote:
> But first I want to address the question of the basic semantics
> of the patch series.  I wrote up a description of why it's useful
> in my email yesterday:
> 
> https://lkml.kernel.org/r/560C4CF4.9090601-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org
> 
> I haven't directly heard from you as to whether you buy the
> basic premise of "hard isolation" in terms of protecting tasks
> from all kernel interrupts while they execute in userspace.

Just for the record. The first serious initiative to solve that
problem started here in my own company when I guided Frederic through
the endavour of figuring out what needs to be done to achieve
that. That was the assignement of his master thesis, which I gave him.

So I'm very well aware why this is needed and what needs to be done.

I started this, because I got tired of half baken attempts to solve
the problem, which were even worse than what you are trying to do now.

> So I first want to address what is effectively the API concern that
> you raised, namely that you're concerned that there is a wait
> loop in the implementation.

That wait loop is just a place holder for the underlying more serious
concern I have with this whole approach. And I raised that concern
several times in the past and I'm happy to do so again.

The people working on this, especially you, are just dead set to
achieve a certain functionality by jamming half baken mechanisms into
the kernel and especially into the low level entry/exit code. And
that's something which really annoys me, simply because you refuse to
tackle the problems which have been identified as need to be solved 5+
years ago when Frederic did his thesis.

Remote accounting:
==================

It's not an easy problem, but it's not rocket science either. It's
just quite some work.

I know that you just give a shit about it because your use case
does not care. But it's an essential part of the problem space. You
just work around it, by shutting down the tick completely and rely
on the fact that it does not explode in your face today.

If we accept your hackery, then who is going to fix it, when it
explodes in half a year from now?

Tick shut down:
===============

I still have to understand why the tick is needed at all.

There is exactly one reason why the tick must run if a cpu is in
full isolation mode:

  More than one SCHED_OTHER task is runnable on that cpu.

There is no other reason, period.

If there are requirements today to switch on the tick when a task
running in full isolation mode enters the kernel, then they need to be
fixed first.

And again you don't care, because for your particular use case it's
good enough to slap a busy wait loop into every archs low level exit
code and be done with it.

>From your mail excusing that approach:

> The nice thing here is that there is in fact no requirement in
> the API/ABI that we have a wait loop in the kernel at all.  Let's
> say hypothetically that in the future we come up with a way to
> guarantee, perhaps in some constrained kind of way, that you
> can enter and exit the kernel and are guaranteed no further
> timer interrupts, ....

"Let's say hypothetically" tells it all. You are not even trying to
find a proper solution. You just try to get your particular interest
solved.

That's exactly the attitude which drives me nuts and that's the point
where I say no.

You can do all of that in an out of tree patch set as many other hard
to solve features have done for years. Yes, it's an annoying catchup
game, but it forces you to think harder, refactor code and do a lot of
extra work to finally get it merged.

Thanks,

	tglx
