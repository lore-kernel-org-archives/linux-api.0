From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT
 is set for the I/O
Date: Fri, 1 Feb 2019 16:13:55 +1100
Message-ID: <20190201051355.GV6173@dastard>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz>
 <20190130124420.1834-3-vbabka@suse.cz>
 <20190131095644.GR18811@dhcp22.suse.cz>
 <nycvar.YFH.7.76.1901311114260.6626@cbobk.fhfr.pm>
 <20190131102348.GT18811@dhcp22.suse.cz>
 <CAHk-=wjkiNPWb97JXV6=J6DzscB1g7moGJ6G_nSe=AEbMugTNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wjkiNPWb97JXV6=J6DzscB1g7moGJ6G_nSe=AEbMugTNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Jiri Kosina <jikos@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 31, 2019 at 09:54:16AM -0800, Linus Torvalds wrote:
> On Thu, Jan 31, 2019 at 2:23 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > OK, I guess my question was not precise. What does prevent taking fs
> > locks down the path?
> 
> IOCB_NOWAIT has never meant that, and will never mean it.

I think you're wrong, Linus. IOCB_NOWAIT was specifically designed
to prevent blocking on filesystem locks during AIO submission. The
initial commits spell that out pretty clearly:

commit b745fafaf70c0a98a2e1e7ac8cb14542889ceb0e
Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date:   Tue Jun 20 07:05:43 2017 -0500

    fs: Introduce RWF_NOWAIT and FMODE_AIO_NOWAIT
    
    RWF_NOWAIT informs kernel to bail out if an AIO request will block
    for reasons such as file allocations, or a writeback triggered,
    or would block while allocating requests while performing
    direct I/O.
    
    RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.
    
    FMODE_AIO_NOWAIT is a flag which identifies the file opened is capable
    of returning -EAGAIN if the AIO call will block. This must be set by
    supporting filesystems in the ->open() call.
    
    Filesystems xfs, btrfs and ext4 would be supported in the following patches.
    
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

commit 29a5d29ec181ebdc98a26cedbd76ce9870248892
Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date:   Tue Jun 20 07:05:48 2017 -0500

    xfs: nowait aio support
    
    If IOCB_NOWAIT is set, bail if the i_rwsem is not lockable
    immediately.
    
    IF IOMAP_NOWAIT is set, return EAGAIN in xfs_file_iomap_begin
    if it needs allocation either due to file extension, writing to a hole,
    or COW or waiting for other DIOs to finish.
    
    Return -EAGAIN if we don't have extent list in memory.
    
    Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

commit 728fbc0e10b7f3ce2ee043b32e3453fd5201c055
Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date:   Tue Jun 20 07:05:47 2017 -0500

    ext4: nowait aio support
    
    Return EAGAIN if any of the following checks fail for direct I/O:
      + i_rwsem is lockable
      + Writing beyond end of file (will trigger allocation)
      + Blocks are not allocated at the write location
    
    Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
    Reviewed-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

> We will never give user space those kinds of guarantees. We do locking
> for various reasons.  For example, we'll do the mm lock just when
> fetching/storing data from/to user space if there's a page fault.

You are conflating "best effort non-blocking operation" with
"atomic guarantee".  RWF_NOWAIT/IOCB_NOWAIT is the
former, not the latter.

i.e. RWF_NOWAIT addresses the "every second IO submission blocks"
problems that AIO submission suffered from due to filesystem lock
contention, not the rare and unusual things like  "page fault during
get_user_pages in direct IO submission".  Maybe one day, but right
now those rare cases are not pain points for applications that
require nonblock AIO submission via RWF_NOWAIT.

> Or -
> more obviously - we'll also check for - and sleep on - mandatory locks
> in rw_verify_area().

Well, only if you don't use fcntl(O_NONBLOCK) on the file to tell
mandatory locking to fail with -EAGAIN instead of sleeping.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
