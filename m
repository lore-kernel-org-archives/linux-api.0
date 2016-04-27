From: Dave Chinner <david@fromorbit.com>
Subject: Re: O_DIRECT as a hint, was: Re: [PATCH] ext4: refuse O_DIRECT opens
 for mode where DIO doesn't work
Date: Wed, 27 Apr 2016 12:25:35 +1000
Message-ID: <20160427022535.GI18496@dastard>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
 <877ffmhvzt.fsf@openvz.org>
 <20160425234946.GB26977@dastard>
 <20160426081451.GA25616@infradead.org>
 <20160427021649.GA30021@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160427021649.GA30021@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org, Dmitry Monakhov <dmonlist@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 26, 2016 at 10:16:49PM -0400, Theodore Ts'o wrote:
> On Tue, Apr 26, 2016 at 01:14:51AM -0700, Christoph Hellwig wrote:
> > I've been doing an audit of our direct I/O implementations, and most
> > of them does some form of transparent fallback, including some that
> > only pretend to support O_DIRECT, but do anything special for it at all,
> > while at the same time we go through greast efforts to check a file
> > system actualy supports direct I/O, leading to nasty no-op ->direct_IO
> > implementations as we even got that abstraction wrong.
> > 
> > At this point I wonder if we should simply treat O_DIRECT as a hint
> > and always allow it, and just let the file system optimize for it
> > (skip buffering, require alignment, relaxed Posix atomicy requirements)
> > if it is set.
> 
> That's fine with me, but there ought to be some way for a program to
> query whether a particular file / file system is one where DIO is
> supported, and if so, what the alignment requirements would be.

Yes, that's called XFS_IOC_DIOINFO. We've been saying that this
should be promoted to the VFS for some time, though it might be
better to re-implement it with a different structure that includes
padding and a flags field....

> That
> way applications who care can get the information they need (and we
> can use it for xfstests's _require_odirect :-).

Just return EOPNOTSUPP to XFS_IOC_DIOINFO if direct io is not
supported?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
