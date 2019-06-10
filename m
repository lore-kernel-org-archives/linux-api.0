From: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFCv2 4/6] mm: factor out madvise's core functionality
Date: Mon, 10 Jun 2019 19:12:48 +0900
Message-ID: <20190610101248.GD55602@google.com>
References: <20190531064313.193437-1-minchan@kernel.org>
 <20190531064313.193437-5-minchan@kernel.org>
 <20190531070420.m7sxybbzzayig44o@butterfly.localdomain>
 <20190531131226.GA195463@google.com>
 <20190531143545.jwmgzaigd4rbw2wy@butterfly.localdomain>
 <20190531232959.GC248371@google.com>
 <20190605132728.mihzzw7galqjf5uz@butterfly.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190605132728.mihzzw7galqjf5uz@butterfly.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

Hi Oleksandr,

On Wed, Jun 05, 2019 at 03:27:28PM +0200, Oleksandr Natalenko wrote:
< snip >
> > > > > >  	write = madvise_need_mmap_write(behavior);
> > > > > >  	if (write) {
> > > > > > -		if (down_write_killable(&current->mm->mmap_sem))
> > > > > > +		if (down_write_killable(&mm->mmap_sem))
> > > > > >  			return -EINTR;
> > > > > 
> > > > > Do you still need that trick with mmget_still_valid() here?
> > > > > Something like:
> > > > 
> > > > Since MADV_COLD|PAGEOUT doesn't change address space layout or
> > > > vma->vm_flags, technically, we don't need it if I understand
> > > > correctly. Right?
> > > 
> > > I'd expect so, yes. But.
> > > 
> > > Since we want this interface to be universal and to be able to cover
> > > various needs, and since my initial intention with working in this
> > > direction involved KSM, I'd ask you to enable KSM hints too, and once
> > > (and if) that happens, the work there is done under write lock, and
> > > you'll need this trick to be applied.
> > > 
> > > Of course, I can do that myself later in a subsequent patch series once
> > > (and, again, if) your series is merged, but, maybe, we can cover this
> > > already especially given the fact that KSM hinting is a relatively easy
> > > task in this pile. I did some preliminary tests with it, and so far no
> > > dragons have started to roar.
> > 
> > Then, do you mind sending a patch based upon this series to expose
> > MADV_MERGEABLE to process_madvise? It will have the right description
> > why you want to have such feature which I couldn't provide since I don't
> > have enough material to write the motivation. And the patch also could
> > include the logic to prevent coredump race, which is more proper since
> > finally we need to hold mmap_sem write-side lock, finally.
> > I will pick it up and will rebase since then.
> 
> Sure, I can. Would you really like to have it being based on this exact
> revision, or I should wait till you deal with MADV_COLD & Co and re-iterate
> this part again?

I'm okay you to send your patch against this revision. I'm happy to
include it when I start a new thread for process_madvise discussion
after resolving MADV_COLD|PAGEOUT.

Thanks.
