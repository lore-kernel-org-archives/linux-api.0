From: Andres Freund <andres@anarazel.de>
Subject: Re: [PATCH v3 0/3] vfs: have syncfs() return error when there are
 writeback errors
Date: Fri, 7 Feb 2020 13:20:12 -0800
Message-ID: <20200207212012.7jrivg2bvuvvful5@alap3.anarazel.de>
References: <20200207170423.377931-1-jlayton@kernel.org>
 <20200207205243.GP20628@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200207205243.GP20628@dread.disaster.area>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jeff Layton <jlayton@kernel.org>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, willy@infradead.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Hi,

On 2020-02-08 07:52:43 +1100, Dave Chinner wrote:
> On Fri, Feb 07, 2020 at 12:04:20PM -0500, Jeff Layton wrote:
> > You're probably wondering -- Where are v1 and v2 sets?

> > The basic idea is to track writeback errors at the superblock level,
> > so that we can quickly and easily check whether something bad happened
> > without having to fsync each file individually. syncfs is then changed
> > to reliably report writeback errors, and a new ioctl is added to allow
> > userland to get at the current errseq_t value w/o having to sync out
> > anything.
> 
> So what, exactly, can userspace do with this error? It has no idea
> at all what file the writeback failure occurred on or even
> what files syncfs() even acted on so there's no obvious error
> recovery that it could perform on reception of such an error.

Depends on the application.  For e.g. postgres it'd to be to reset
in-memory contents and perform WAL replay from the last checkpoint. Due
to various reasons* it's very hard for us (without major performance
and/or reliability impact) to fully guarantee that by the time we fsync
specific files we do so on an old enough fd to guarantee that we'd see
the an error triggered by background writeback.  But keeping track of
all potential filesystems data resides on (with one fd open permanently
for each) and then syncfs()ing them at checkpoint time is quite doable.

*I can go into details, but it's probably not interesting enough


> > - This adds a new generic fs ioctl to allow userland to scrape the
> >   current superblock's errseq_t value. It may be best to present this
> >   to userland via fsinfo() instead (once that's merged). I'm fine with
> >   dropping the last patch for now and reworking it for fsinfo if so.
> 
> What, exactly, is this useful for? Why would we consider exposing
> an internal implementation detail to userspace like this?

There is, as far as I can tell, so far no way but scraping the kernel
log to figure out if there have been data loss errors on a
machine/fs. Even besides app specific reactions like outlined above,
just generally being able to alert whenever there error count increases
seems extremely useful.  I'm not sure it makes sense to expose the
errseq_t bits straight though - seems like it'd enshrine them in
userspace ABI too much?

Greetings,

Andres Freund
