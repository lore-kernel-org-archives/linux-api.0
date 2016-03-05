From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block
 devices
Date: Sat, 5 Mar 2016 12:57:28 -0800
Message-ID: <20160305205728.GA4834@infradead.org>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
 <20160305005617.29738.85316.stgit@birch.djwong.org>
 <CA+55aFyY+oDoK8C6C++PG=N+vtY-r1Y6fYO_3skDTzkP_SXC-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyY+oDoK8C6C++PG=N+vtY-r1Y6fYO_3skDTzkP_SXC-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 04, 2016 at 07:06:38PM -0800, Linus Torvalds wrote:
> > +       if ((mode & FALLOC_FL_PUNCH_HOLE) &&
> > +           (!blk_queue_discard(q) || !q->limits.discard_zeroes_data))
> > +               return -EOPNOTSUPP;
> 
> I'm ok with this, but suspect that some users would prefer to just
> turn this into ZERO_RANGE silently.
> 
> Comments from people who would be expected to use this?

A hole punch should be a hole punch, and not silently allocate blocks
isntead of deallocating them.  It's not even a fallback, it's pretty
much the opposite for some workloads.
