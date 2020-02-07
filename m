From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/3] vfs: have syncfs() return error when there are
 writeback errors
Date: Fri, 07 Feb 2020 17:05:28 -0500
Message-ID: <220e015c525650588f24d17f549cd0a87ec518fd.camel@kernel.org>
References: <20200207170423.377931-1-jlayton@kernel.org>
         <20200207205243.GP20628@dread.disaster.area>
         <20200207212012.7jrivg2bvuvvful5@alap3.anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200207212012.7jrivg2bvuvvful5-npzPixP2Kky4qIFNZ/xzbbNAH6kLmebB@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andres Freund <andres-XfW7kCwqgJAb1SvskN2V4Q@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2020-02-07 at 13:20 -0800, Andres Freund wrote:
> Hi,
> 
> On 2020-02-08 07:52:43 +1100, Dave Chinner wrote:
> > On Fri, Feb 07, 2020 at 12:04:20PM -0500, Jeff Layton wrote:
> > > You're probably wondering -- Where are v1 and v2 sets?
> > > The basic idea is to track writeback errors at the superblock level,
> > > so that we can quickly and easily check whether something bad happened
> > > without having to fsync each file individually. syncfs is then changed
> > > to reliably report writeback errors, and a new ioctl is added to allow
> > > userland to get at the current errseq_t value w/o having to sync out
> > > anything.
> > 
> > So what, exactly, can userspace do with this error? It has no idea
> > at all what file the writeback failure occurred on or even
> > what files syncfs() even acted on so there's no obvious error
> > recovery that it could perform on reception of such an error.
> 
> Depends on the application.  For e.g. postgres it'd to be to reset
> in-memory contents and perform WAL replay from the last checkpoint. Due
> to various reasons* it's very hard for us (without major performance
> and/or reliability impact) to fully guarantee that by the time we fsync
> specific files we do so on an old enough fd to guarantee that we'd see
> the an error triggered by background writeback.  But keeping track of
> all potential filesystems data resides on (with one fd open permanently
> for each) and then syncfs()ing them at checkpoint time is quite doable.
> 
> *I can go into details, but it's probably not interesting enough
> 

Do applications (specifically postgresql) need the ability to check
whether there have been writeback errors on a filesystem w/o blocking on
a syncfs() call?  I thought that you had mentioned a specific usecase
for that, but if you're actually ok with syncfs() then we can drop that
part altogether.

> 
> > > - This adds a new generic fs ioctl to allow userland to scrape the
> > >   current superblock's errseq_t value. It may be best to present this
> > >   to userland via fsinfo() instead (once that's merged). I'm fine with
> > >   dropping the last patch for now and reworking it for fsinfo if so.
> > 
> > What, exactly, is this useful for? Why would we consider exposing
> > an internal implementation detail to userspace like this?
> 
> There is, as far as I can tell, so far no way but scraping the kernel
> log to figure out if there have been data loss errors on a
> machine/fs. Even besides app specific reactions like outlined above,
> just generally being able to alert whenever there error count increases
> seems extremely useful.  I'm not sure it makes sense to expose the
> errseq_t bits straight though - seems like it'd enshrine them in
> userspace ABI too much?
> 

Yeah, if we do end up keeping it, I'm leaning toward making this
fetchable via fsinfo() (once that's merged). If we do that, then we'll
split this into a struct with two fields -- the most recent errno and an
opaque token that you can keep to tell whether new errors have been
recorded since.

I think that should be a little cleaner from an API standpoint. Probably
we can just drop the ioctl, under the assumption that fsinfo() will be
available in 5.7.

Cheers,
-- 
Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
