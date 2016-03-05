From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block devices
Date: Fri, 4 Mar 2016 19:13:25 -0800
Message-ID: <CA+55aFzJW70YApg8ra-c79E-j1ujOXbh=26k2dvyYX+qZuu_8A@mail.gmail.com>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
	<20160305005617.29738.85316.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305005617.29738.85316.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 4, 2016 at 4:56 PM, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> +
> +       /* We can't change the bdev size from here */
> +       if (!(mode & FALLOC_FL_KEEP_SIZE))
> +               return -EOPNOTSUPP;

Oh, and this I think is wrong.

The thing is, FALLOC_FL_KEEP_SIZE is only supposed to matter if the
region is outside the existing length.

So if y ou punch a hole in the middle of a file, you don't need
FALLOC_FL_KEEP_SIZE.

I would suggest removing this check entirely, since you already check
that people don't try to punch holes past the end of the device. So
FALLOC_FL_KEEP_SIZE is simply a non-issue, and shouldn't even be
checked.

              Linus
