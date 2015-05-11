From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Mon, 11 May 2015 14:36:40 -0400
Message-ID: <20150511143640.63f6b1fc@gandalf.local.home>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
	<20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
	<20150508172210.559830a9@gandalf.local.home>
	<554D428E.6020702@ezchip.com>
	<20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
	<20150509070538.GA9413@gmail.com>
	<20150511085759.71deeb64@gandalf.local.home>
	<20150511171916.GN6776@linux.vnet.ibm.com>
	<20150511102744.9ebb2d05a7e8b457d03430bf@linux-foundation.org>
	<20150511173305.GC32512@lerouge>
	<20150511140009.1f7bcf07@gandalf.local.home>
	<5550F077.6030906@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5550F077.6030906-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 11 May 2015 14:09:59 -0400
Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:

> Steven writes:
> > All kidding aside, I think this is the real answer. We don't need a new
> > NO_HZ, we need to make NO_HZ_FULL work. Right now it doesn't do exactly
> > what it was created to do. That should be fixed.
> 
> The claim I'm making is that it's worthwhile to differentiate the two
> semantics.  Plain NO_HZ_FULL just says "kernel makes a best effort to
> avoid periodic interrupts without incurring any serious overhead".  My
> patch series allows an app to request "kernel makes an absolute
> commitment to avoid all interrupts regardless of cost when leaving
> kernel space".  These are different enough ideas, and serve different
> enough application needs, that I think they should be kept distinct.
> 
> Frederic actually summed this up very nicely in his recent email when
> he wrote "some people may expect hard isolation requirement (Real
> Time, deterministic latency) and others softer isolation (HPC, only
> interested in performance, can live with one rare random tick, so no
> need to loop before returning to userspace until we have the no-noise
> guarantee)."
> 
> So we need a way for apps to ask for the "harder" mode and let
> the softer mode be the default.

Fair enough. But I would hope that this would improve on NO_HZ_FULL as
well.

> 
> What about naming?  We may or may not want to have a Kconfig flag
> for this, and we may or may not have a separate mode for it, but
> we still will need some kind of name to talk about it with.  (In
> particular there's the prctl name, if we take that approach, and
> potential boot command-line flags to consider naming for.)
> 
> I'll quickly cover the suggestions that have been raised:
> 
> - DATAPLANE.  My suggestion, seemingly broadly disliked by folks
>    who felt it wasn't apparent what it meant.  Probably a fair point.
> 
> - NO_INTERRUPTS (Andrew).  Captures some of the sense, but was
>    criticized pretty fairly by Ingo as being too negative, confusing
>    with perf nomenclature, and too long :-)

What about NO_INTERRUPTIONS

> 
> - PURE (Ingo).  Proposed as an alternative to NO_HZ_FULL, but we could
>    use it as a name for this new mode.  However, I think it's not clear
>    enough how FULL and PURE can/should relate to each other from the
>    names alone.

I would find the two confusing as well.

> 
> - BARE_METAL (me).  Ingo observes it's confusing with respect to
>    virtualization.

This is also confusing.

> 
> - TASK_SOLO (Gilad).  Not sure this conveys enough of the semantics.

Agreed.

> 
> - OS_LIGHT/OS_ZERO and NO_HZ_LEAVE_ME_THE_FSCK_ALONE.  Excellent
>    ideas :-)

At least the LEAVE_ME_ALONE conveys the semantics ;-)

> 
> - ISOLATION (Frederic).  I like this but it conflicts with other uses
>    of "isolation" in the kernel: cgroup isolation, lru page isolation,
>    iommu isolation, scheduler isolation (at least it's a superset of
>    that one), etc.  Also, we're not exactly isolating a task - often
>    a "dataplane" app consists of a bunch of interacting threads in
>    userspace, so not exactly isolated.  So perhaps it's too confusing.
> 
> - OVERFLOWING (Steven) - not sure I understood this one, honestly.

Actually, that was suggested by Paul McKenney.

> 
> I suggested earlier a few other candidates that I don't love, but no
> one commented on: NO_HZ_STRICT, USERSPACE_ONLY, and ZERO_OVERHEAD.
> 
> One thing I'm leaning towards is to remove the intermediate state of
> DATAPLANE_ENABLE and say that there is really only one primary state,
> DATAPLANE_QUIESCE (or whatever we call it).  The "dataplane but no
> quiesce" state probably isn't that useful, since it doesn't offer the
> hard guarantee that is the entire point of this patch series.  So that
> opens the idea of using the name NO_HZ_QUIESCE or just QUIESCE as the
> word that describes the mode; of course this sort of conflicts with
> RCU quiesce (though it is a superset of that so maybe that's OK).
> 
> One new idea I had is to use NO_HZ_HARD to reflect what Frederic was
> suggesting about "soft" and "hard" requirements for NO_HZ.  So
> enabling NO_HZ_HARD would enable my suggested QUIESCE mode.
> 
> One way to focus this discussion is on the user API naming.  I had
> prctl(PR_SET_DATAPLANE), which was attractive in being a "positive"
> noun.  A lot of the other suggestions fail this test in various way.
> Reasonable candidates seem to be:
> 
>    PR_SET_OS_ZERO
>    PR_SET_TASK_SOLO
>    PR_SET_ISOLATION
> 
> Another possibility:
> 
>    PR_SET_NONSTOP
> 
> Or take Andrew's NO_INTERRUPTS and have:
> 
>    PR_SET_UNINTERRUPTED

For another possible answer, what about 

	SET_TRANQUILITY

A state with no disturbances. 

-- Steve

> 
> I slightly favor ISOLATION at this point despite the overlap with
> other kernel concepts.
> 
> Let the bike-shedding continue! :-)
> 
