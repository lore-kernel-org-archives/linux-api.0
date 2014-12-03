From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v17 1/7] mm: support madvise(MADV_FREE)
Date: Wed, 3 Dec 2014 09:00:26 +0900
Message-ID: <20141203000026.GA30217@bbox>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
 <1413799924-17946-2-git-send-email-minchan@kernel.org>
 <20141127144725.GB19157@dhcp22.suse.cz>
 <20141130235652.GA10333@bbox>
 <20141202100125.GD27014@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141202100125.GD27014-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 02, 2014 at 11:01:25AM +0100, Michal Hocko wrote:
> On Mon 01-12-14 08:56:52, Minchan Kim wrote:
> [...]
> > From 2edd6890f92fa4943ce3c452194479458582d88c Mon Sep 17 00:00:00 2001
> > From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Date: Mon, 1 Dec 2014 08:53:55 +0900
> > Subject: [PATCH] madvise.2: Document MADV_FREE
> > 
> > Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  man2/madvise.2 | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/man2/madvise.2 b/man2/madvise.2
> > index 032ead7..33aa936 100644
> > --- a/man2/madvise.2
> > +++ b/man2/madvise.2
> > @@ -265,6 +265,19 @@ file (see
> >  .BR MADV_DODUMP " (since Linux 3.4)"
> >  Undo the effect of an earlier
> >  .BR MADV_DONTDUMP .
> > +.TP
> > +.BR MADV_FREE " (since Linux 3.19)"
> > +Gives the VM system the freedom to free pages, and tells the system that
> > +information in the specified page range is no longer important.
> > +This is an efficient way of allowing
> > +.BR malloc (3)
> 
> This might be rather misleading. Only some malloc implementations are
> using this feature (jemalloc, right?). So either be specific about which
> implementation or do not add it at all.

Make sense. I don't think it's a good idea to say specific example
in man page, which is rather arguable and limit the idea.

> 
> > +to free pages anywhere in the address space, while keeping the address space
> > +valid. The next time that the page is referenced, the page might be demand
> > +zeroed, or might contain the data that was there before the MADV_FREE call.
> > +References made to that address space range will not make the VM system page the
> > +information back in from backing store until the page is modified again.
> 
> I am not sure I understand the last sentence. So say I did MADV_FREE and
> the reclaim has dropped that page. I know that the file backed mappings
> are not supported yet but assume they were for a second... Now, I do
> read from that location again what is the result?

Zero page.

> If we consider anon mappings then the backing store is misleading as
> well because memory was dropped and so always newly allocated.

When I read the sentence at first, I thought backing store means swap
so I don't have any trouble to understand it. But I agree your opinion.
Target for man page is not a kernel developer but application developer.

> I would rather drop the whole sentence and rather see an explanation
> what is the difference between to MADV_DONT_NEED.
> "
> Unlike MADV_DONT_NEED the memory is freed lazily e.g. when the VM system
> is under memory pressure.
> "

It's a good idea but I don't think it's enough. At least we should explan
cancel of delay free logic(ie, write). So, How about this?

MADV_FREE " (since Linux 3.19)"

Gives the VM system the freedom to free pages, and tells the system that
it's okay to free pages if the VM system has reasons(e.g., memory pressure).
So, it looks like delayed MADV_DONTNEED.
The next time that the page is referenced, the page might be demand
zeroed if the VM system freed the page. Otherwise, it might contain the data
that was there before the MADV_FREE call if the VM system didn't free the page.
New write in the page after the MADV_FREE call makes the VM system not free
the page any more.
It works only with private anonymous pages (see mmap(2)).

> 
> > +It works only with private anonymous pages (see
> > +.BR mmap (2)).
> >  .SH RETURN VALUE
> >  On success
> >  .BR madvise ()
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Kind regards,
Minchan Kim
