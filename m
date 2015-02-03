From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Tue, 3 Feb 2015 12:53:01 +0200
Message-ID: <20150203105301.GC14259@node.dhcp.inet.fi>
References: <20150202165525.GM2395@suse.de>
 <54CFF8AC.6010102@intel.com>
 <54D08483.40209@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54D08483.40209-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 03, 2015 at 09:19:15AM +0100, Vlastimil Babka wrote:
> [CC linux-api, man pages]
> 
> On 02/02/2015 11:22 PM, Dave Hansen wrote:
> > On 02/02/2015 08:55 AM, Mel Gorman wrote:
> >> This patch identifies when a thread is frequently calling MADV_DONTNEED
> >> on the same region of memory and starts ignoring the hint. On an 8-core
> >> single-socket machine this was the impact on ebizzy using glibc 2.19.
> > 
> > The manpage, at least, claims that we zero-fill after MADV_DONTNEED is
> > called:
> > 
> >>      MADV_DONTNEED
> >>               Do  not  expect  access in the near future.  (For the time being, the application is finished with the given range, so the kernel can free resources
> >>               associated with it.)  Subsequent accesses of pages in this range will succeed, but will result either in reloading of the memory contents  from  the
> >>               underlying mapped file (see mmap(2)) or zero-fill-on-demand pages for mappings without an underlying file.
> > 
> > So if we have anything depending on the behavior that it's _always_
> > zero-filled after an MADV_DONTNEED, this will break it.
> 
> OK, so that's a third person (including me) who understood it as a zero-fill
> guarantee. I think the man page should be clarified (if it's indeed not
> guaranteed), or we have a bug.
> 
> The implementation actually skips MADV_DONTNEED for
> VM_LOCKED|VM_HUGETLB|VM_PFNMAP vma's.

It doesn't skip. It fails with -EINVAL. Or I miss something.

> - The word "will result" did sound as a guarantee at least to me. So here it
> could be changed to "may result (unless the advice is ignored)"?

It's too late to fix documentation. Applications already depends on the
beheviour.

-- 
 Kirill A. Shutemov
