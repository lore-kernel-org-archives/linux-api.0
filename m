From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/3] vfs: have syncfs() return error when there are
 writeback errors
Date: Tue, 11 Feb 2020 07:57:00 -0500
Message-ID: <538b41c956c3b69900c9166464d9621b2537d877.camel@kernel.org>
References: <20200207170423.377931-1-jlayton@kernel.org>
         <20200207205243.GP20628@dread.disaster.area>
         <20200207212012.7jrivg2bvuvvful5@alap3.anarazel.de>
         <20200210214657.GA10776@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200210214657.GA10776-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andres Freund <andres-XfW7kCwqgJAb1SvskN2V4Q@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2020-02-11 at 08:46 +1100, Dave Chinner wrote:
> On Fri, Feb 07, 2020 at 01:20:12PM -0800, Andres Freund wrote:
> > Hi,
> > 
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
> > in-memory contents and perform WAL replay from the last checkpoint.
> 
> What happens if a user runs 'sync -f /path/to/postgres/data' instead
> of postgres? All the writeback errors are consumed at that point by
> reporting them to the process that ran syncfs()...
> 

Well, no. If you keep a fd open, then you can be sure that you'll see
any errors that occurred since that open at syncfs time, regardless of
who else is issuing syncfs calls(). That's basically how errseq_t works.

I guess I figured that part was obvious and didn't point it out here --
mea culpa.

> > Due
> > to various reasons* it's very hard for us (without major performance
> > and/or reliability impact) to fully guarantee that by the time we fsync
> > specific files we do so on an old enough fd to guarantee that we'd see
> > the an error triggered by background writeback.  But keeping track of
> > all potential filesystems data resides on (with one fd open permanently
> > for each) and then syncfs()ing them at checkpoint time is quite doable.
> 
> Oh, you have to keep an fd permanently open to every superblock that
> application holds data on so that errors detected by other users of
> that filesystem are also reported to the application?
> 
> This seems like a fairly important requirement for applications to
> ensure this error reporting is "reliable" and that certainly wasn't
> apparent from the patches or their description.  i.e. the API has an
> explicit userspace application behaviour requirement for reliable
> functioning, and that was not documented.  "we suck at APIs" and all
> that..
> 
> It also seems to me as useful only to applications that have a
> "rollback and replay" error recovery mechanism. If the application
> doesn't have the ability to go back in time to before the
> "unfindable" writeback error occurred, then this error is largely
> useless to those applications because they can't do anything with
> it, and so....
> 

Just knowing that an error occurred is still a better situation than
letting the application obliviously chug along.

In a sense I see the above argument as circular. Our error reporting
mechanisms have historically sucked, and applications have been written
accordingly. Unless we improve how errors are reported then applications
will never improve.

It is true that we can't reasonably report which inodes failed writeback
with this interface, but syncfs only returns int. That's really the best
we can do with it.

> > > > - This adds a new generic fs ioctl to allow userland to scrape
> > > > the current superblock's errseq_t value. It may be best to
> > > > present this to userland via fsinfo() instead (once that's
> > > > merged). I'm fine with dropping the last patch for now and
> > > > reworking it for fsinfo if so.
> > > 
> > > What, exactly, is this useful for? Why would we consider
> > > exposing an internal implementation detail to userspace like
> > > this?
> > 
> > There is, as far as I can tell, so far no way but scraping the
> > kernel log to figure out if there have been data loss errors on a
> > machine/fs.
> 
> .... most applications will still require users to scrape their
> logs to find out what error actually occurred. IOWs, we haven't
> really changed the status quo with this new mechanism.
> 
> FWIW, explicit userspace error notifications for data loss events is
> one of the features that David Howell's generic filesystem
> notification mechanism is intended to provide.  Hence I'm not sure
> that there's a huge amount of value in providing a partial solution
> that only certain applications can use when there's a fully generic
> mechanism for error notification just around the corner.
> 

David's notification work is great, but it's quite a bit more
heavyweight than just allowing syncfs to return better errors. The
application would need to register to be notified and watch a pipe. Not
all application are going to want or need to do that.

> > Even besides app specific reactions like outlined above,
> > just generally being able to alert whenever there error count
> > increases seems extremely useful.
> 
> Yup, a generic filesystem notification mechanism is perfect for
> that, plus it can provide more explicit details of where the error
> actually occurred rather than jsut a handwavy "some error occurred
> some where" report....
> 
> > I'm not sure it makes sense to
> > expose the errseq_t bits straight though - seems like it'd
> > enshrine them in userspace ABI too much?
> 
> Even a little is way too much. Userspace ABI needs to be completely
> independent of the kernel internal structures and implementation.
> This is basic "we suck at APIs 101" stuff...
> 

Yeah, I've already self-NAK'ed that patch.

If we are going to expose that info, we'll probably do it via fsinfo(),
and put it in a struct with two fields: last reported error code, and an
opaque token that you can use to see whether new errors have been
recorded since you last checked. I think that should be enough to ensure
that we don't tie this too closely to the internal kernel mplementation.

-- 
Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
