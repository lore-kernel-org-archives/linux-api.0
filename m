From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 01/17] mm: support madvise(MADV_FREE)
Date: Fri, 13 Nov 2015 15:38:02 +0900
Message-ID: <20151113063802.GF5235@bbox>
References: <1447302793-5376-1-git-send-email-minchan@kernel.org>
 <1447302793-5376-2-git-send-email-minchan@kernel.org>
 <CALCETrWA6aZC_3LPM3niN+2HFjGEm_65m9hiEdpBtEZMn0JhwQ@mail.gmail.com>
 <564421DA.9060809@gmail.com>
 <20151113061511.GB5235@bbox>
 <56458056.8020105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56458056.8020105-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin wang <yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 13, 2015 at 01:16:54AM -0500, Daniel Micay wrote:
> On 13/11/15 01:15 AM, Minchan Kim wrote:
> > On Thu, Nov 12, 2015 at 12:21:30AM -0500, Daniel Micay wrote:
> >>> I also think that the kernel should commit to either zeroing the page
> >>> or leaving it unchanged in response to MADV_FREE (even if the decision
> >>> of which to do is made later on).  I think that your patch series does
> >>> this, but only after a few of the patches are applied (the swap entry
> >>> freeing), and I think that it should be a real guaranteed part of the
> >>> semantics and maybe have a test case.
> >>
> >> This would be a good thing to test because it would be required to add
> >> MADV_FREE_UNDO down the road. It would mean the same semantics as the
> >> MEM_RESET and MEM_RESET_UNDO features on Windows, and there's probably
> >> value in that for the sake of migrating existing software too.
> > 
> > So, do you mean that we could implement MADV_FREE_UNDO with "read"
> > opearation("just access bit marking) easily in future?
> > 
> > If so, it would be good reason to change MADV_FREE from dirty bit to
> > access bit. Okay, I will look at that.
> 
> I just meant testing that the data is either zero or the old data if
> it's read before it's written to. Not having it stay around once there
> is a read. Not sure if that's what Andy meant.

Either zero of old data is gauranteed.
Now:

        MADV_FREE(range)
        A = read from the range
        ...
        ...
        B = read from the range


        A and B could have different value. But value should be old or zero.

But Andy want more strict ABI so he suggested access bit instead of dirty bit.

        MADV_FREE(range)
        A = read from the range
        ...
        ...
        B = read from the range

        A and B cannot have different value.

And now I am thinking if we use access bit, we could implment MADV_FREE_UNDO
easily when we need it. Maybe, that's what you want. Right?
