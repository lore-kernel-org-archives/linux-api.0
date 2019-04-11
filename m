From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] io_uring: add support for barrier fsync
Date: Thu, 11 Apr 2019 21:05:24 +1000
Message-ID: <20190411110524.GC1695@dread.disaster.area>
References: <7c7276e4-8ffa-495a-6abf-926a58ee899e@kernel.dk>
 <20190409181742.GA24925@infradead.org>
 <5f8d9644-9e8f-c9d2-611e-4b144c62539c@kernel.dk>
 <5BF7FDDE-212E-4F9A-9B50-26BDA99E952A@fb.com>
 <a7f00629-f822-7271-7a4e-ad3b802752e4@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a7f00629-f822-7271-7a4e-ad3b802752e4@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 09, 2019 at 12:46:15PM -0600, Jens Axboe wrote:
> On 4/9/19 12:42 PM, Chris Mason wrote:
> > On 9 Apr 2019, at 14:23, Jens Axboe wrote:
> > 
> >> On 4/9/19 12:17 PM, Christoph Hellwig wrote:
> >>> On Tue, Apr 09, 2019 at 10:27:43AM -0600, Jens Axboe wrote:
> >>>> It's a quite common use case to issue a bunch of writes, then an 
> >>>> fsync
> >>>> or fdatasync when they complete. Since io_uring doesn't guarantee 
> >>>> any
> >>>> type of ordering, the application must track issued writes and wait
> >>>> with the fsync issue until they have completed.
> >>>>
> >>>> Add an IORING_FSYNC_BARRIER flag that helps with this so the 
> >>>> application
> >>>> doesn't have to do this manually. If this flag is set for the fsync
> >>>> request, we won't issue it until pending IO has already completed.
> >>>
> >>> I think we need a much more detailed explanation of the semantics,
> >>> preferably in man page format.
> >>>
> >>> Barrier at least in Linux traditionally means all previously 
> >>> submitted
> >>> requests have finished and no new ones are started until the
> >>> barrier request finishes, which is very heavy handed.  Is that what
> >>> this is supposed to do?  If not what are the exact guarantees vs
> >>> ordering and or barrier semantics?
> >>
> >> The patch description isn't that great, and maybe the naming isn't 
> >> that
> >> intuitive either. The way it's implemented, the fsync will NOT be 
> >> issued
> >> until previously issued IOs have completed. That means both reads and
> >> writes, since there's no way to wait for just one.  In terms of
> >> semantics, any previously submitted writes will have completed before
> >> this fsync is issued. The barrier fsync has no ordering wrt future
> >> writes, no ordering is implied there. Hence:
> >>
> >> W1, W2, W3, FSYNC_W_BARRIER, W4, W5
> >>
> >> W1..3 will have been completed by the hardware side before we start
> >> FSYNC_W_BARRIER. We don't wait with issuing W4..5 until after the 
> >> fsync
> >> completes, no ordering is provided there.
> > 
> > Looking at the patch, why is fsync special?  Seems like you could add 
> > this ordering bit to any write?
> 
> It's really not, the exact same technique could be used on any type of
> command to imply ordering. My initial idea was to have an explicit
> barrier/ordering command, but I didn't think that separating it from an
> actual command would be needed/useful.
> 
> > While you're here, do you want to add a way to FUA/cache flush?  
> > Basically the rest of what user land would need to make their own 
> > write-back-cache-safe implementation.
> 
> FUA would be a WRITEV/WRITE_FIXED flag, that should be trivially doable.

We already have plumbing to make pwritev2 and AIO issue FUA writes
via the RWF_DSYNC flag through the fs/iomap.c direct IO path. FUA is
only valid if the file does not have dirty metadata (e.g. because of
block allocation) and that requires the filesystem block mapping to
tell the IO path if FUA can be used. Otherwise a journal flush is
also required to make the data stable and there's no point in doing
a FUA write for the data in that case...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
