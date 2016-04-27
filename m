From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: O_DIRECT as a hint, was: Re: [PATCH] ext4: refuse O_DIRECT opens
 for mode where DIO doesn't work
Date: Tue, 26 Apr 2016 23:25:26 -0400
Message-ID: <20160427032526.GC30021@thunk.org>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
 <877ffmhvzt.fsf@openvz.org>
 <20160425234946.GB26977@dastard>
 <20160426081451.GA25616@infradead.org>
 <20160427022746.GJ18496@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160427022746.GJ18496@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org, Dmitry Monakhov <dmonlist@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2016 at 12:27:46PM +1000, Dave Chinner wrote:
> > At this point I wonder if we should simply treat O_DIRECT as a hint
> > and always allow it, and just let the file system optimize for it
> > (skip buffering, require alignment, relaxed Posix atomicy requirements)
> > if it is set.
> 
> I thought that's how most filesystems treated it, anyway. i.e.
> anything they can't do via direct IO, they fell back to buffered IO
> to complete (e.g. for allocation or append writes, etc). Hence why I
> suggested the fallback rather than erroring out....

No, some file systems return EINVAL on the open.  In fact that's what
the _require_odirect test in xfstests relies upon....

    		     	     	      	     - Ted
