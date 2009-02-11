From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Date: Wed, 11 Feb 2009 14:14:34 -0800
Message-ID: <20090211141434.dfa1d079.akpm@linux-foundation.org>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	<1234285547.30155.6.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1234285547.30155.6.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 10 Feb 2009 09:05:47 -0800
Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> On Tue, 2009-01-27 at 12:07 -0500, Oren Laadan wrote:
> > Checkpoint-restart (c/r): a couple of fixes in preparation for 64bit
> > architectures, and a couple of fixes for bugss (comments from Serge
> > Hallyn, Sudakvev Bhattiprolu and Nathan Lynch). Updated and tested
> > against v2.6.28.
> > 
> > Aiming for -mm.
> 
> Is there anything that we're waiting on before these can go into -mm?  I
> think the discussion on the first few patches has died down to almost
> nothing.  They're pretty reviewed-out.  Do they need a run in -mm?  I
> don't think linux-next is quite appropriate since they're not _quite_
> aimed at mainline yet.
> 

I raised an issue a few months ago and got inconclusively waffled at. 
Let us revisit.

I am concerned that this implementation is a bit of a toy, and that we
don't know what a sufficiently complete implementation will look like. 
There is a risk that if we merge the toy we either:

a) end up having to merge unacceptably-expensive-to-maintain code to
   make it a non-toy or

b) decide not to merge the unacceptably-expensive-to-maintain code,
   leaving us with a toy or

c) simply cannot work out how to implement the missing functionality.


So perhaps we can proceed by getting you guys to fill out the following
paperwork:

- In bullet-point form, what features are present?

- In bullet-point form, what features are missing, and should be added?

- Is it possible to briefly sketch out the design of the to-be-added
  features?

For extra marks:

- Will any of this involve non-trivial serialisation of kernel
  objects?  If so, that's getting into the
  unacceptably-expensive-to-maintain space, I suspect.

- Does (or will) this feature also support process migration?  If
  not, I'd have thought this to be a showstopper.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
