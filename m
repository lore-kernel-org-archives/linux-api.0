From: Andres Freund <andres@anarazel.de>
Subject: Re: [PATCH v3 0/3] vfs: have syncfs() return error when there are
 writeback errors
Date: Fri, 7 Feb 2020 14:21:30 -0800
Message-ID: <20200207222130.urcfi3i3dlfscimy@alap3.anarazel.de>
References: <20200207170423.377931-1-jlayton@kernel.org>
 <20200207205243.GP20628@dread.disaster.area>
 <20200207212012.7jrivg2bvuvvful5@alap3.anarazel.de>
 <220e015c525650588f24d17f549cd0a87ec518fd.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <220e015c525650588f24d17f549cd0a87ec518fd.camel@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, willy@infradead.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Hi,

On 2020-02-07 17:05:28 -0500, Jeff Layton wrote:
> On Fri, 2020-02-07 at 13:20 -0800, Andres Freund wrote:
> > On 2020-02-08 07:52:43 +1100, Dave Chinner wrote:
> > > On Fri, Feb 07, 2020 at 12:04:20PM -0500, Jeff Layton wrote:
> > > > You're probably wondering -- Where are v1 and v2 sets?
> > > > The basic idea is to track writeback errors at the superblock level,
> > > > so that we can quickly and easily check whether something bad happened
> > > > without having to fsync each file individually. syncfs is then changed
> > > > to reliably report writeback errors, and a new ioctl is added to allow
> > > > userland to get at the current errseq_t value w/o having to sync out
> > > > anything.
> > > 
> > > So what, exactly, can userspace do with this error? It has no idea
> > > at all what file the writeback failure occurred on or even
> > > what files syncfs() even acted on so there's no obvious error
> > > recovery that it could perform on reception of such an error.
> > 
> > Depends on the application.  For e.g. postgres it'd to be to reset
> > in-memory contents and perform WAL replay from the last checkpoint. Due
> > to various reasons* it's very hard for us (without major performance
> > and/or reliability impact) to fully guarantee that by the time we fsync
> > specific files we do so on an old enough fd to guarantee that we'd see
> > the an error triggered by background writeback.  But keeping track of
> > all potential filesystems data resides on (with one fd open permanently
> > for each) and then syncfs()ing them at checkpoint time is quite doable.
> > 
> > *I can go into details, but it's probably not interesting enough
> > 
> 
> Do applications (specifically postgresql) need the ability to check
> whether there have been writeback errors on a filesystem w/o blocking on
> a syncfs() call?  I thought that you had mentioned a specific usecase
> for that, but if you're actually ok with syncfs() then we can drop that
> part altogether.

It'd be considerably better if we could check for errors without a
blocking syncfs(). A syncfs will trigger much more dirty pages to be
written back than what we need for durability. Our checkpoint writes are
throttled to reduce the impact on current IO, we try to ensure there's
not much outstanding IO before calling fsync() on FDs, etc - all to
avoid stalls. Especially as on plenty installations there's also
temporary files, e.g. for bigger-than-memory sorts, on the same FS.  So
if we had to syncfs() to reliability detect errros it'd cause some pain
- but would still be an improvement.

But with a nonblocking check we could compare the error count from the
last checkpoint with the current count before finalizing the checkpoint
- without causing unnecessary writeback.

Currently, if we crash (any unclean shutdown, be it a PG bug, OS dying,
kill -9), we'll iterate over all files afterwards to make sure they're
fsynced, before starting to perform WAL replay. That can take quite a
while on some systems - it'd be much nicer if we could just syncfs() the
involved filesystems (which we can detect more quickly than iterating
over the whole directory tree, there's only a few places where we
support separate mounts), and still get errors.


> Yeah, if we do end up keeping it, I'm leaning toward making this
> fetchable via fsinfo() (once that's merged). If we do that, then we'll
> split this into a struct with two fields -- the most recent errno and an
> opaque token that you can keep to tell whether new errors have been
> recorded since.
> 
> I think that should be a little cleaner from an API standpoint. Probably
> we can just drop the ioctl, under the assumption that fsinfo() will be
> available in 5.7.

Sounds like a plan.

I guess an alternative could be to expose the error count in /sys, but
that looks like it'd be a bigger project, as there doesn't seem to be a
good pre-existing hierarchy to hook into.

Greetings,

Andres Freund
