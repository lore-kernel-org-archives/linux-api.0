From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/13] mm: support madvise(MADV_FREE)
Date: Thu, 5 Nov 2015 10:17:26 -0800
Message-ID: <20151105181726.GA63566@kernel.org>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
 <1446600367-7976-2-git-send-email-minchan@kernel.org>
 <CALCETrUuNs=26UQtkU88cKPomx_Bik9mbgUUF9q7Nmh1pQJ4qg@mail.gmail.com>
 <56399CA5.8090101@gmail.com>
 <CALCETrU5P-mmjf+8QuS3-pm__R02j2nnRc5B1gQkeC013XWNvA@mail.gmail.com>
 <563A813B.9080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <563A813B.9080903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yalin wang <yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 04, 2015 at 05:05:47PM -0500, Daniel Micay wrote:
> > With enough pages at once, though, munmap would be fine, too.
> 
> That implies lots of page faults and zeroing though. The zeroing alone
> is a major performance issue.
> 
> There are separate issues with munmap since it ends up resulting in a
> lot more virtual memory fragmentation. It would help if the kernel used
> first-best-fit for mmap instead of the current naive algorithm (bonus:
> O(log n) worst-case, not O(n)). Since allocators like jemalloc and
> PartitionAlloc want 2M aligned spans, mixing them with other allocators
> can also accelerate the VM fragmentation caused by the dumb mmap
> algorithm (i.e. they make a 2M aligned mapping, some other mmap user
> does 4k, now there's a nearly 2M gap when the next 2M region is made and
> the kernel keeps going rather than reusing it). Anyway, that's a totally
> separate issue from this. Just felt like complaining :).
> 
> > Maybe what's really needed is a MADV_FREE variant that takes an iovec.
> > On an all-cores multithreaded mm, the TLB shootdown broadcast takes
> > thousands of cycles on each core more or less regardless of how much
> > of the TLB gets zapped.
> 
> That would work very well. The allocator ends up having a sequence of
> dirty spans that it needs to purge in one go. As long as purging is
> fairly spread out, the cost of a single TLB shootdown isn't that bad. It
> is extremely bad if it needs to do it over and over to purge a bunch of
> ranges, which can happen if the memory has ended up being very, very
> fragmentated despite the efforts to compact it (depends on what the
> application ends up doing).

I posted a patch doing exactly iovec madvise. Doesn't support MADV_FREE yet
though, but should be easy to do it.

http://marc.info/?l=linux-mm&m=144615663522661&w=2
