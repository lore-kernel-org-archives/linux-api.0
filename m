From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: lazytime implementation questions
Date: Wed, 6 Jan 2016 20:05:06 -0500
Message-ID: <20160107010506.GB2866@thunk.org>
References: <20160104062219.GB19802@dastard>
 <20160105173604.GE18604@quack.suse.cz>
 <20160105225907.GE21461@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160105225907.GE21461@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 06, 2016 at 09:59:07AM +1100, Dave Chinner wrote:
> > So the intended semantics is:
> > 1) fsync / sync / freeze / unmount will write the timestamp updates even
> >    with lazytime. So unless crash happens, timestamps are guaranteed to be
> >    consistent. Also sync / fsync guarantees all changes to get to disk.
> > 2) We periodically write back timestamps (once per 24 hours) to avoid too
> >    big timestamp inconsistencies in case of crash.
> 
> Ok, so it's supposed to be a delayed timestamp update mechanism
> without any specific ordering guarantees, not an opportunistic
> timestamp update mechanism.

There is an optimization which ext4 has which will update related
timestamps when we write an inode table block, which is
"opportunistic", but there is no guarantee that this will happen.

This is purely optional; other file systems don't have to do this, but
it can be a win in that if related inodes are in the same 4k block,
and we need to update, say, the index file one because we are changing
i_size, but we were also doing non-allocating writes to the data file,
then we might as well write out the timestamps for the data file at
the same time, since this is "free".

						- Ted
