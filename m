From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Date: Thu, 12 Feb 2009 10:11:23 -0800
Message-ID: <1234462283.30155.173.camel@nimitz>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1234285547.30155.6.camel@nimitz>
	 <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <20090212091721.GB1888@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090212091721.GB1888-X9Un+BFzKDI@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2009-02-12 at 10:17 +0100, Ingo Molnar wrote:
> * Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> 
> > On Tue, 10 Feb 2009 09:05:47 -0800
> > Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > 
> > > On Tue, 2009-01-27 at 12:07 -0500, Oren Laadan wrote:
> > > > Checkpoint-restart (c/r): a couple of fixes in preparation for 64bit
> > > > architectures, and a couple of fixes for bugss (comments from Serge
> > > > Hallyn, Sudakvev Bhattiprolu and Nathan Lynch). Updated and tested
> > > > against v2.6.28.
> > > > 
> > > > Aiming for -mm.
> > > 
> > > Is there anything that we're waiting on before these can go into -mm?  I
> > > think the discussion on the first few patches has died down to almost
> > > nothing.  They're pretty reviewed-out.  Do they need a run in -mm?  I
> > > don't think linux-next is quite appropriate since they're not _quite_
> > > aimed at mainline yet.
> > > 
> > 
> > I raised an issue a few months ago and got inconclusively waffled at. 
> > Let us revisit.
> > 
> > I am concerned that this implementation is a bit of a toy, and that we
> > don't know what a sufficiently complete implementation will look like. 
> > There is a risk that if we merge the toy we either:
> > 
> > a) end up having to merge unacceptably-expensive-to-maintain code to
> >    make it a non-toy or
> > 
> > b) decide not to merge the unacceptably-expensive-to-maintain code,
> >    leaving us with a toy or
> > 
> > c) simply cannot work out how to implement the missing functionality.
> > 
> > 
> > So perhaps we can proceed by getting you guys to fill out the following
> > paperwork:
> > 
> > - In bullet-point form, what features are present?
> 
> It would be nice to get an honest, critical-thinking answer on this.
> 
> What is it good for right now, and what are the known weaknesses and
> quirks you can think of. Declaring them upfront is a bonus - not talking
> about them and us discovering them later at the patch integration stage
> is a sure receipe for upstream grumpiness.

That's a fair enough point, and I do agree with you on it.

Right now, it is good for very little.  An app has to basically be
either specifically designed to work, or be pretty puny in its
capabilities.  Any fds that are open can only be restored if a simple
open();lseek(); would have been sufficient to get it back into a good
state.  The process must be single-threaded.  Shared memory, hugetlbfs,
VM_NONLINEAR are not supported.  

> For example, one of the critical corner points: can an app programmatically 
> determine whether it can support checkpoint/restart safely? Are there 
> warnings/signals/helpers in place that make it a well-defined space, and
> make the implementation of missing features directly actionable?
> 
> ( instead of: 'silent breakage' and a wishy-washy boundary between the
>   working and non-working space. Without clear boundaries there's no
>   clear dynamics that extends the 'working' space beyond the demo stage. )

Patch 12/14 is supposed to address this *concept*.  But, it hasn't been
carried through so that it currently works.  My expectation was that we
would go through and add things over time.  I'll go make sure I push it
to the point that it actually works for at least the simple test
programs that we have.

What I will probably do is something BKL-style.  Basically put a "this
can't be checkpointed" marker over most everything I can think of and
selectively remove it as we add features.  

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
