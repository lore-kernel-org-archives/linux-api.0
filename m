From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/5] mm: factor out madvise's core functionality
Date: Fri, 17 Jan 2020 10:14:13 -0800
Message-ID: <20200117181413.GC140922@google.com>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-2-minchan@kernel.org>
 <d3b8431d-fa3d-6a16-8af1-a68b3ac8ca58@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d3b8431d-fa3d-6a16-8af1-a68b3ac8ca58-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, sjpark-ebkRAfMGSJGzQB+pC5nmwQ@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 17, 2020 at 01:02:34PM +0300, Kirill Tkhai wrote:
> On 17.01.2020 02:59, Minchan Kim wrote:
> > This patch factor out madvise's core functionality so that upcoming
> > patch can reuse it without duplication. It shouldn't change any behavior.
> > 
> > Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  mm/madvise.c | 194 +++++++++++++++++++++++++++++----------------------
> >  1 file changed, 111 insertions(+), 83 deletions(-)
> > 
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index bcdb6a042787..0c901de531e4 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -35,6 +35,7 @@
> >  struct madvise_walk_private {
> >  	struct mmu_gather *tlb;
> >  	bool pageout;
> > +	struct task_struct *task;
> >  };
> >  
> >  /*
> > @@ -306,12 +307,13 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  	bool pageout = private->pageout;
> >  	struct mm_struct *mm = tlb->mm;
> >  	struct vm_area_struct *vma = walk->vma;
> > +	struct task_struct *task = private->task;
> >  	pte_t *orig_pte, *pte, ptent;
> >  	spinlock_t *ptl;
> >  	struct page *page = NULL;
> >  	LIST_HEAD(page_list);
> >  
> > -	if (fatal_signal_pending(current))
> > +	if (fatal_signal_pending(task))
> >  		return -EINTR;
> 
> This EINTR may confuse userspace. Users will think the syscall was interrupted,
> and it may be restarted, but this is not true.

madvise_[pageout|cold] doesn't propagate the error to userspace.

> 
> What we care here? Current task received fatal signal, while walk_page_range(..&cold_walk_ops..)
> is a long cycle. So, this check allows to break the cycle faster.
> 
> Iteration over remote task's mm may also be long, and we still may need to break
> it if current received a signal.
> 
> So, we'd better left fatal_signal_pending(current) here.
> 
> Maybe we need both tasks fatal_signal_pending() checks and different retvals here,
> but it's up to you.

Yub, let's check both processes here to bail out.

Thanks for the review!
