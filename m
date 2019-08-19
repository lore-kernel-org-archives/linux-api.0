From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v5 1/6] mm/page_idle: Add per-pid idle page tracking
 using virtual index
Date: Mon, 19 Aug 2019 17:52:01 -0400
Message-ID: <20190819215201.GG117548@google.com>
References: <20190807171559.182301-1-joel@joelfernandes.org>
 <CAG48ez0ysprvRiENhBkLeV9YPTN_MB18rbu2HDa2jsWo5FYR8g@mail.gmail.com>
 <20190813100856.GF17933@dhcp22.suse.cz>
 <CAG48ez2cuqe_VYhhaqw8Hcyswv47cmz2XmkqNdvkXEhokMVaXg@mail.gmail.com>
 <20190814075601.GO17933@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190814075601.GO17933@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Jann Horn <jannh@google.com>, Daniel Gruss <daniel.gruss@iaik.tugraz.at>, kernel list <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, Daniel Colascione <dancol@google.com>, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team <kernel-team@android.com>, Linux API <linux-api@vger.kernel.org>, linux-doc@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Mike Rapoport <rppt@linux.>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 14, 2019 at 09:56:01AM +0200, Michal Hocko wrote:
[snip]
> > > > Can this be used to observe which library pages other processes are
> > > > accessing, even if you don't have access to those processes, as long
> > > > as you can map the same libraries? I realize that there are already a
> > > > bunch of ways to do that with side channels and such; but if you're
> > > > adding an interface that allows this by design, it seems to me like
> > > > something that should be gated behind some sort of privilege check.
> > >
> > > Hmm, you need to be priviledged to get the pfn now and without that you
> > > cannot get to any page so the new interface is weakening the rules.
> > > Maybe we should limit setting the idle state to processes with the write
> > > status. Or do you think that even observing idle status is useful for
> > > practical side channel attacks? If yes, is that a problem of the
> > > profiler which does potentially dangerous things?
> > 
> > I suppose read-only access isn't a real problem as long as the
> > profiler isn't writing the idle state in a very tight loop... but I
> > don't see a usecase where you'd actually want that? As far as I can
> > tell, if you can't write the idle state, being able to read it is
> > pretty much useless.
> > 
> > If the profiler only wants to profile process-private memory, then
> > that should be implementable in a safe way in principle, I think, but
> > since Joel said that they want to profile CoW memory as well, I think
> > that's inherently somewhat dangerous.
> 
> I cannot really say how useful that would be but I can see that
> implementing ownership checks would be really non-trivial for
> shared pages. Reducing the interface to exclusive pages would make it
> easier as you noted but less helpful.
> 
> Besides that the attack vector shouldn't be really much different from
> the page cache access, right? So essentially can_do_mincore model.
> 
> I guess we want to document that page idle tracking should be used with
> care because it potentially opens a side channel opportunity if used
> on sensitive data.

I have been thinking of this, and discussing with our heap profiler folks.
Not being able to track shared pages would be a limitation, but I don't see
any way forward considering this security concern so maybe we have to
limit what we can do.

I will look into implementing this without doing the rmap but still make it
work on shared pages from the point of view of the process being tracked. It
just would no longer through the PTEs of *other* processes sharing the page.

My current thought is to just rely on the PTE accessed bit, and not use the
PageIdle flag at all. But we'd still set the PageYoung flag so that the
reclaim code still sees the page as accessed. The reason I feel like avoiding
the PageIdle flag is:

1. It looks like mark_page_accessed() can be called from other paths which
can also result in some kind of side-channel issue if a page was shared.

2. I don't think I need the PageIdle flag since the access bit alone should
let me know, although it could be a bit slower. Since previously, I did not
need to check every PTE and if the PageIdle flag was already cleared, then
the page was declared as idle.

At least this series resulted in a bug fix and a tonne of learning, so thank
you everyone!

Any other thoughts?

thanks,

 - Joel
