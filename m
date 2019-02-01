From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT
 is set for the I/O
Date: Fri, 1 Feb 2019 12:44:46 +1100
Message-ID: <20190201014446.GU6173@dastard>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz>
 <20190130124420.1834-3-vbabka@suse.cz>
 <20190131095644.GR18811@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190131095644.GR18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jkosina@suse.cz>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Jiri Kosina <jikos@kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 31, 2019 at 10:56:44AM +0100, Michal Hocko wrote:
> [Cc fs-devel]
> 
> On Wed 30-01-19 13:44:19, Vlastimil Babka wrote:
> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > preadv2(RWF_NOWAIT) can be used to open a side-channel to pagecache contents, as
> > it reveals metadata about residency of pages in pagecache.
> > 
> > If preadv2(RWF_NOWAIT) returns immediately, it provides a clear "page not
> > resident" information, and vice versa.
> > 
> > Close that sidechannel by always initiating readahead on the cache if we
> > encounter a cache miss for preadv2(RWF_NOWAIT); with that in place, probing
> > the pagecache residency itself will actually populate the cache, making the
> > sidechannel useless.
> 
> I guess the current wording doesn't disallow background IO to be
> triggered for EAGAIN case. I am not sure whether that breaks clever
> applications which try to perform larger IO for those cases though.

Actually, it does:

RWF_NOWAIT (since Linux 4.14)

    Do  not  wait for data which is not immediately available.  If
    this flag is specified, the preadv2() system call will return
    instantly if it would have to read data from the backing storage
    or wait for a lock.

page_cache_sync_readahead() can block on page allocation, it calls
->readpages() which means there are page locks and filesystem locks
in play (e.g.  for block mapping), there's potential for blocking on
metadata IO (both submission and completion) to read block maps, the
data readahead can be submitted for IO so it can get stuck anywhere
in the IO path, etc...

Basically, it completely subverts the documented behaviour of
RWF_NOWAIT.

There are applications (like Samba (*)) that are planning to use
this to avoid blocking their main processing threads on buffered
IO. This change makes RWF_NOWAIT pretty much useless to them - it
/was/ the only solution we had for reliably issuing non-blocking IO,
with this patch it isn't a viable solution at all.

(*) https://github.com/samba-team/samba/commit/6381044c0270a647c20935d22fd23f235d19b328

IOWs, if this change goes through, it needs to be documented as an
intentional behavioural bug in the preadv2 manpage so that userspace
developers are aware of the new limitations of RWF_NOWAIT and should
avoid it like the plague.

But worse than that is nobody has bothered to (or ask someone
familiar with the code to) do an audit of RWF_NOWAIT usage after I
pointed out the behavioural issues. The one person who was engaged
and /had done an audit/ got shouted down with so much bullshit they
just walked away....

So, I'll invite the incoherent, incandescent O_DIRECT rage flames of
Linus to be unleashed again and point out the /other reference/ to
IOCB_NOWAIT in mm/filemap.c. That is, in generic_file_read_iter(),
in the *generic O_DIRECT read path*:

	if (iocb->ki_flags & IOCB_DIRECT) {
.....
		if (iocb->ki_flags & IOCB_NOWAIT) {
			if (filemap_range_has_page(mapping, iocb->ki_pos,
						   iocb->ki_pos + count - 1))
				return -EAGAIN;
		} else {
.....

This page cache probe is about 100 lines of code down from the code
that this patch modifies, in it's direct caller. It's not hard to
find, I shouldn't have to point it out, nor have to explain how it
makes this patch completely irrelevant.

> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 9f5e323e883e..7bcdd36e629d 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -2075,8 +2075,6 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
> >  
> >  		page = find_get_page(mapping, index);
> >  		if (!page) {
> > -			if (iocb->ki_flags & IOCB_NOWAIT)
> > -				goto would_block;
> >  			page_cache_sync_readahead(mapping,
> >  					ra, filp,
> >  					index, last_index - index);
> 
> Maybe a stupid question but I am not really familiar with this path but
> what exactly does prevent a sync read down page_cache_sync_readahead
> path?

It's effectively useless as a workaround because you can avoid the
readahead IO being issued relatively easily:

void page_cache_sync_readahead(struct address_space *mapping,
                               struct file_ra_state *ra, struct file *filp,
                               pgoff_t offset, unsigned long req_size)
{
        /* no read-ahead */
        if (!ra->ra_pages)
                return;

        if (blk_cgroup_congested())
                return;
....

IOWs, we just have to issue enough IO to congest the block device (or,
even easier, a rate-limited cgroup), and we can still use RWF_NOWAIT
to probe the page cache. Or if we can convince ra->ra_pages to be
zero (e.g. it's on bdi device with no readahead configured because
it's real fast) then it doesn't work there, either.

So this a) isn't a robust workaround, b) it breaks documented API
semantics and c) isn't the only path to page cache probing via
RWF_NOWAIT. It's just a new game of whack-a-mole.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
