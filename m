From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: lazytime implementation questions
Date: Thu, 7 Jan 2016 13:21:40 +1100
Message-ID: <20160107022140.GM21461@dastard>
References: <20160104062219.GB19802@dastard>
 <20160105173604.GE18604@quack.suse.cz>
 <20160105225907.GE21461@dastard>
 <20160107010506.GB2866@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160107010506.GB2866-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 06, 2016 at 08:05:06PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 06, 2016 at 09:59:07AM +1100, Dave Chinner wrote:
> > > So the intended semantics is:
> > > 1) fsync / sync / freeze / unmount will write the timestamp updates even
> > >    with lazytime. So unless crash happens, timestamps are guaranteed to be
> > >    consistent. Also sync / fsync guarantees all changes to get to disk.
> > > 2) We periodically write back timestamps (once per 24 hours) to avoid too
> > >    big timestamp inconsistencies in case of crash.
> > 
> > Ok, so it's supposed to be a delayed timestamp update mechanism
> > without any specific ordering guarantees, not an opportunistic
> > timestamp update mechanism.
> 
> There is an optimization which ext4 has which will update related
> timestamps when we write an inode table block, which is
> "opportunistic", but there is no guarantee that this will happen.

XFS used to do that, too, before we removed all that hackery when we
moved to logging timestamp updates unconditionally a few years ago.
I'm going to have to re-instate some of that code for lazytime, I
think.

> This is purely optional; other file systems don't have to do this, but
> it can be a win in that if related inodes are in the same 4k block,
> and we need to update, say, the index file one because we are changing
> i_size, but we were also doing non-allocating writes to the data file,
> then we might as well write out the timestamps for the data file at
> the same time, since this is "free".

*nod*. Explicit, optimised clustered inode writeback (rather than
purely opportunistic clustering via delayed buffer writeback) was
added to XFS way back in early 1999. :)

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
