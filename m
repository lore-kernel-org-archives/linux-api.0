From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: Re: [RFCv2 4/6] mm: factor out madvise's core functionality
Date: Wed, 5 Jun 2019 15:27:28 +0200
Message-ID: <20190605132728.mihzzw7galqjf5uz@butterfly.localdomain>
References: <20190531064313.193437-1-minchan@kernel.org>
 <20190531064313.193437-5-minchan@kernel.org>
 <20190531070420.m7sxybbzzayig44o@butterfly.localdomain>
 <20190531131226.GA195463@google.com>
 <20190531143545.jwmgzaigd4rbw2wy@butterfly.localdomain>
 <20190531232959.GC248371@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190531232959.GC248371@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

Hi.

On Sat, Jun 01, 2019 at 08:29:59AM +0900, Minchan Kim wrote:
> > > > > /* snip a lot */
> > > > >
> > > > >  #ifdef CONFIG_MEMORY_FAILURE
> > > > >  	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
> > > > > -		return madvise_inject_error(behavior, start, start + len_in);
> > > > > +		return madvise_inject_error(behavior,
> > > > > +					start, start + len_in);
> > > > 
> > > > Not sure what this change is about except changing the line length.
> > > > Note, madvise_inject_error() still operates on "current" through
> > > > get_user_pages_fast() and gup_pgd_range(), but that was not changed
> > > > here. I Know you've filtered out this hint later, so technically this
> > > > is not an issue, but, maybe, this needs some attention too since we've
> > > > already spotted it?
> > > 
> > > It is leftover I had done. I actually modified it to handle remote
> > > task but changed my mind not to fix it because process_madvise
> > > will not support it at this moment. I'm not sure it's a good idea
> > > to change it for *might-be-done-in-future* at this moment even though
> > > we have spotted.
> > 
> > I'd expect to have at least some comments in code on why other hints
> > are disabled, so if we already know some shortcomings, this information
> > would not be lost.
> 
> Okay, I will add some comment but do not want to fix code piece until
> someone want to expose the poisoning to external process.

Fair enough.

> > > > >  	write = madvise_need_mmap_write(behavior);
> > > > >  	if (write) {
> > > > > -		if (down_write_killable(&current->mm->mmap_sem))
> > > > > +		if (down_write_killable(&mm->mmap_sem))
> > > > >  			return -EINTR;
> > > > 
> > > > Do you still need that trick with mmget_still_valid() here?
> > > > Something like:
> > > 
> > > Since MADV_COLD|PAGEOUT doesn't change address space layout or
> > > vma->vm_flags, technically, we don't need it if I understand
> > > correctly. Right?
> > 
> > I'd expect so, yes. But.
> > 
> > Since we want this interface to be universal and to be able to cover
> > various needs, and since my initial intention with working in this
> > direction involved KSM, I'd ask you to enable KSM hints too, and once
> > (and if) that happens, the work there is done under write lock, and
> > you'll need this trick to be applied.
> > 
> > Of course, I can do that myself later in a subsequent patch series once
> > (and, again, if) your series is merged, but, maybe, we can cover this
> > already especially given the fact that KSM hinting is a relatively easy
> > task in this pile. I did some preliminary tests with it, and so far no
> > dragons have started to roar.
> 
> Then, do you mind sending a patch based upon this series to expose
> MADV_MERGEABLE to process_madvise? It will have the right description
> why you want to have such feature which I couldn't provide since I don't
> have enough material to write the motivation. And the patch also could
> include the logic to prevent coredump race, which is more proper since
> finally we need to hold mmap_sem write-side lock, finally.
> I will pick it up and will rebase since then.

Sure, I can. Would you really like to have it being based on this exact
revision, or I should wait till you deal with MADV_COLD & Co and re-iterate
this part again?

Thanks.

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
