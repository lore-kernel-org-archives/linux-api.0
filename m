From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: THP-enabled filesystem vs. FALLOC_FL_PUNCH_HOLE
Date: Fri, 4 Mar 2016 11:38:47 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1603041100320.6011@eggly.anvils>
References: <1457023939-98083-1-git-send-email-kirill.shutemov@linux.intel.com> <20160304112603.GA9790@node.shutemov.name> <56D9C882.3040808@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D9C882.3040808-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 4 Mar 2016, Dave Hansen wrote:
> On 03/04/2016 03:26 AM, Kirill A. Shutemov wrote:
> > On Thu, Mar 03, 2016 at 07:51:50PM +0300, Kirill A. Shutemov wrote:
> >> Truncate and punch hole that only cover part of THP range is implemented
> >> by zero out this part of THP.
> >>
> >> This have visible effect on fallocate(FALLOC_FL_PUNCH_HOLE) behaviour.
> >> As we don't really create hole in this case, lseek(SEEK_HOLE) may have
> >> inconsistent results depending what pages happened to be allocated.
> >> Not sure if it should be considered ABI break or not.
> > 
> > Looks like this shouldn't be a problem. man 2 fallocate:
> > 
> > 	Within the specified range, partial filesystem blocks are zeroed,
> > 	and whole filesystem blocks are removed from the file.  After a
> > 	successful call, subsequent reads from this range will return
> > 	zeroes.
> > 
> > It means we effectively have 2M filesystem block size.
> 
> The question is still whether this will case problems for apps.
> 
> Isn't 2MB a quote unusual block size?  Wouldn't some files on a tmpfs
> filesystem act like they have a 2M blocksize and others like they have
> 4k?  Would that confuse apps?

At risk of addressing the tip of an iceberg, before diving down to
scope out the rest of the iceberg...

So far as the behaviour of lseek(,,SEEK_HOLE) goes, I agree with Kirill:
I don't think it matters to anyone if it skips some zeroed small pages
within a hugepage.  It may cause some artificial tests of holepunch and
SEEK_HOLE to fail, and it ought to be documented as a limitation from
choosing to enable THP (Kirill's way) on a filesystem, but I don't think
it's an ABI break to worry about: anyone who cares just shouldn't enable.

(Though in the case of my huge tmpfs, it's the reverse: the small hole
punch splits the hugepage; but it's natural that Kirill's way would try
to hold on to its compound pages for longer than I do, and that's fine
so long as it's all consistent.)

But I may disagree with "we effectively have 2M filesystem block size",
beyond the SEEK_HOLE case.  If we're emulating hugetlbfs in tmpfs, sure,
we would have 2M filesystem block size.  But if we're enabling THP
(emphasis on T for Transparent) in tmpfs (or another filesystem), then
when it matters it must act as if the block size is the 4k (or whatever)
it usually is.  When it matters?  Approaching memcg limit or ENOSPC
spring to mind.

Ah, but suppose someone holepunches out most of each 2M page: they would
expect the memcg not to be charged for those holes (just as when they
munmap most of an anonymous THP) - that does suggest splitting is needed.

Hugh
