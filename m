From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 3 Mar 2016 10:09:24 -0800
Message-ID: <20160303180924.GA4116@infradead.org>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
 <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
 <20160302225601.GB21890@birch.djwong.org>
 <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
 <yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <yq1bn6v8mqg.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2016 at 01:01:11PM -0500, Martin K. Petersen wrote:
> That's not entirely true. Writing the blocks may cause them to be
> allocated on the storage device (depending on which flags we feed it in
> WRITE SAME).
> 
> The filesystems people were wanted the following semantics:
> 
>  - deallocate, don't care about contents for future reads (discard)
>  - deallocate, guarantee zeroes on future reads (zeroout)
>  - (re)allocate, guarantee zeroes on future reads (zeroout)
> 
> Maybe we just need a better naming scheme...

In filesystem terms we have two and three:

 - FALLOC_FL_PUNCH_HOLE assures zeroes are returned, but space is
   deallocated as much as possible
 - FALLOC_FL_ZERO_RANGE assures zeroes are returned, AND blocks are
   actually allocated

Returning stale blocks in a file system is a nasty security risk, so
we don't do that, and so shouldn't storage that offers any kind
of multi tenancy, and if it's just VMs using multiple partitions on it.
