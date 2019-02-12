From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT
 is set for the I/O
Date: Tue, 12 Feb 2019 16:48:56 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1902121645470.11598@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-3-vbabka@suse.cz> <20190131095644.GR18811@dhcp22.suse.cz> <20190201014446.GU6173@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201014446.GU6173@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 1 Feb 2019, Dave Chinner wrote:

> So, I'll invite the incoherent, incandescent O_DIRECT rage flames of
> Linus to be unleashed again and point out the /other reference/ to
> IOCB_NOWAIT in mm/filemap.c. That is, in generic_file_read_iter(),
> in the *generic O_DIRECT read path*:
> 
> 	if (iocb->ki_flags & IOCB_DIRECT) {
> .....
> 		if (iocb->ki_flags & IOCB_NOWAIT) {
> 			if (filemap_range_has_page(mapping, iocb->ki_pos,
> 						   iocb->ki_pos + count - 1))
> 				return -EAGAIN;
> 		} else {
> .....

OK, thanks Dave, this is a good point I've missed in this mail before 
(probabably as I focused only on the aspect of disagreement what NONBLOCK 
actually means :) ). I will look into fixing it for next iteration.

> It's effectively useless as a workaround because you can avoid the
> readahead IO being issued relatively easily:
> 
> void page_cache_sync_readahead(struct address_space *mapping,
>                                struct file_ra_state *ra, struct file *filp,
>                                pgoff_t offset, unsigned long req_size)
> {
>         /* no read-ahead */
>         if (!ra->ra_pages)
>                 return;
> 
>         if (blk_cgroup_congested())
>                 return;
> ....
> 
> IOWs, we just have to issue enough IO to congest the block device (or,
> even easier, a rate-limited cgroup), and we can still use RWF_NOWAIT
> to probe the page cache. Or if we can convince ra->ra_pages to be
> zero (e.g. it's on bdi device with no readahead configured because
> it's real fast) then it doesn't work there, either.

It's though questionable whether the noise level here wouldn't be too high 
already for any sidechannel to work reliably. So I'd suggest to operate 
under the assumption that it would be too noisy, unless anyone is able to 
prove otherwise.

Thanks,

-- 
Jiri Kosina
SUSE Labs
