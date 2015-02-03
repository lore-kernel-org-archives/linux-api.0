From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Tue, 3 Feb 2015 16:21:21 +0100
Message-ID: <20150203152121.GC8914@dhcp22.suse.cz>
References: <20150202165525.GM2395@suse.de>
 <54CFF8AC.6010102@intel.com>
 <54D08483.40209@suse.cz>
 <20150203111600.GR2395@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150203111600.GR2395-l3A5Bk7waGM@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 03-02-15 11:16:00, Mel Gorman wrote:
> On Tue, Feb 03, 2015 at 09:19:15AM +0100, Vlastimil Babka wrote:
[...]
> > And if we agree that there is indeed no guarantee, what's the actual semantic
> > difference from MADV_FREE? I guess none? So there's only a possible perfomance
> > difference?
> > 
> 
> Timing. MADV_DONTNEED if it has an effect is immediate, is a heavier
> operations and RSS is reduced. MADV_FREE only has an impact in the future
> if there is memory pressure.

JFTR. the man page for MADV_FREE has been proposed already
(https://lkml.org/lkml/2014/12/5/63 should be the last version AFAIR). I
do not see it in the man-pages git tree but the patch was not in time
for 3.19 so I guess it will only appear in 3.20.
-- 
Michal Hocko
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
