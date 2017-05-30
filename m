From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Tue, 30 May 2017 16:56:33 +0200
Message-ID: <20170530145632.GL7969@dhcp22.suse.cz>
References: <20170524075043.GB3063@rapoport-lnx>
 <c59a0893-d370-130b-5c33-d567a4621903@suse.cz>
 <20170524103947.GC3063@rapoport-lnx>
 <20170524111800.GD14733@dhcp22.suse.cz>
 <20170524142735.GF3063@rapoport-lnx>
 <20170530074408.GA7969@dhcp22.suse.cz>
 <20170530101921.GA25738@rapoport-lnx>
 <20170530103930.GB7969@dhcp22.suse.cz>
 <20170530140456.GA8412@redhat.com>
 <20170530143941.GK7969@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530143941.GK7969-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 30-05-17 16:39:41, Michal Hocko wrote:
> On Tue 30-05-17 16:04:56, Andrea Arcangeli wrote:
[...]
> > About the proposed madvise, it just clear bits, but it doesn't change
> > at all how those bits are computed in THP code. So I don't see it as
> > convoluted.
> 
> But we already have MADV_HUGEPAGE, MADV_NOHUGEPAGE and prctl to
> enable/disable thp. Doesn't that sound little bit too much for a single
> feature to you?

And also I would argue that the prctl should be usable for this specific
usecase. The man page says
"
Setting this flag provides a method for disabling transparent huge pages
for jobs where the code cannot be modified
"

and that fits into the described case AFAIU. The thing that the current
implementation doesn't work is a mere detail. I would even argue that
it is non-intuitive if not buggy right away. Whoever calls this prctl
later in the process life time will simply not stop THP from creating.

So again, why cannot we fix that? There was some handwaving about
potential overhead but has anybody actually measured that?
-- 
Michal Hocko
SUSE Labs
