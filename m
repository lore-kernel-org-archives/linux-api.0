From: Christoph Hellwig <hch@infradead.org>
Subject: O_DIRECT as a hint, was: Re: [PATCH] ext4: refuse O_DIRECT opens for
 mode where DIO doesn't work
Date: Tue, 26 Apr 2016 01:14:51 -0700
Message-ID: <20160426081451.GA25616@infradead.org>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
 <877ffmhvzt.fsf@openvz.org>
 <20160425234946.GB26977@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160425234946.GB26977@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, torvalds@linux-foundation.org
Cc: Dmitry Monakhov <dmonlist@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 26, 2016 at 09:49:46AM +1000, Dave Chinner wrote:
> Why not just transparently fall back to buffered IO if direct IO
> cannot be done? Saves people from wondering why applications fail
> on one ext4 filesystem and not another....

I've been doing an audit of our direct I/O implementations, and most
of them does some form of transparent fallback, including some that
only pretend to support O_DIRECT, but do anything special for it at all,
while at the same time we go through greast efforts to check a file
system actualy supports direct I/O, leading to nasty no-op ->direct_IO
implementations as we even got that abstraction wrong.

At this point I wonder if we should simply treat O_DIRECT as a hint
and always allow it, and just let the file system optimize for it
(skip buffering, require alignment, relaxed Posix atomicy requirements)
if it is set.
