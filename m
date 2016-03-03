From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 3 Mar 2016 17:39:52 -0500
Message-ID: <20160303223952.GE24012@thunk.org>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
 <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
 <20160302225601.GB21890@birch.djwong.org>
 <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
 <yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
 <20160303180924.GA4116@infradead.org>
 <yq1vb5375oh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <yq1vb5375oh.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2016 at 01:54:54PM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:
> 
> Christoph>  - FALLOC_FL_PUNCH_HOLE assures zeroes are returned, but
> Christoph> space is deallocated as much as possible -
> Christoph> FALLOC_FL_ZERO_RANGE assures zeroes are returned, AND blocks
> Christoph> are actually allocated
> 
> That works for me. I think it would be great if we could have consistent
> interfaces for fs and block. The more commonality the merrier.

So a question I have is do we want to add a "discard-as-a-hint" analog
for fallocate?  In the past we've said no because we don't trust
userspace.  (We seem to have as a core held belief that application
programmers are idiots and are not to be trusted with anything
dangerous, even if it would be highly useful in certain use cases.)

As a result I'm carrying an out-of-tree patch in our Google kernels so
that ext4 will honor BLKDISCARD on files.  I can't remember if I
floated it on linux-fsdevel, or I didn't bother because I knew it
would instantly shot down.  I believe it was the former, but I can't
be 100% sure.

It would be kind of nice, though, if we had some kind of agreement on
a consistent, unified interface for all three kinds of
"discard-as-a-hint", "zeroout", and "zeroout with deallocation" that
worked on block devices and files.  Whether it's via fallocate(2) or
BLK* ioctls, I'm agnostic.

							- Ted

P.S.  Speaking of things that are powerful and too dangerous for
application programmers, after the Linux FAST workshop, I was having
dinner with the Ceph developers and Ric Wheeler, and we were talking
about things they really needed.  Turns out they also could use an
FALLOC_FL_NO_HIDE_STALE functionality.  I told them I had an
out-of-tree patch that had that functionality, and even Ric Wheeler
started getting tempted....  :-)
