From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block
 devices
Date: Sat, 5 Mar 2016 12:58:34 -0800
Message-ID: <20160305205833.GB4834@infradead.org>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
 <20160305005617.29738.85316.stgit@birch.djwong.org>
 <CA+55aFzJW70YApg8ra-c79E-j1ujOXbh=26k2dvyYX+qZuu_8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzJW70YApg8ra-c79E-j1ujOXbh=26k2dvyYX+qZuu_8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 04, 2016 at 07:13:25PM -0800, Linus Torvalds wrote:
> > +       /* We can't change the bdev size from here */
> > +       if (!(mode & FALLOC_FL_KEEP_SIZE))
> > +               return -EOPNOTSUPP;
> 
> Oh, and this I think is wrong.
> 
> The thing is, FALLOC_FL_KEEP_SIZE is only supposed to matter if the
> region is outside the existing length.

For allocations...

> So if y ou punch a hole in the middle of a file, you don't need
> FALLOC_FL_KEEP_SIZE.

For FALLOC_FL_PUNCH_HOLE we always require FALLOC_FL_KEEP_SIZE so far,
and I'd rather not change things for block devices just because we can.
