From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v6 0/3] fallocate for block devices to provide zero-out
Date: Fri, 4 Mar 2016 19:17:24 -0800
Message-ID: <CA+55aFxcXOL+sqWN1yze7d5fQZmTa_6Tg6D6hJ+ReYyKMFxzSg@mail.gmail.com>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305005556.29738.66782.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 4, 2016 at 4:55 PM, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> This is a redesign of the patch series that fixes various interface
> problems with the existing "zero out this part of a block device"
> code.  BLKZEROOUT2 is gone.

I replied to two of the patches with small nits, but on the whole I
like it. The only nit that I think is serious is that you shouldn't be
requiring people to have to use FALLOC_FL_KEEP_SIZE.

If anything, you might just change that logic to say: If
FALLOC_FL_KEEP_SIZE is set, then we truncate the hole punching/zeroing
to the size of the device. So people could do something like

  fallocate(fd,
        FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
        0, ~0);

to trim the whole device (and if FALLOC_FL_KEEP_SIZE isn't set, then
the above would be an error simply because the requested hole was
bigger than the device)

            Linus
