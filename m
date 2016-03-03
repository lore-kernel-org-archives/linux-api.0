From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 3 Mar 2016 10:14:17 -0800
Message-ID: <CA+55aFyf6QkH1Q-9S2FZpdzRyyJAHfxo81kO5wxp5q09Bu3vcw@mail.gmail.com>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
	<20160302040947.16685.42926.stgit@birch.djwong.org>
	<CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
	<20160302225601.GB21890@birch.djwong.org>
	<CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
	<yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1bn6v8mqg.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 3, 2016 at 10:01 AM, Martin K. Petersen
<martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> "Linus" == Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:
>
> Linus> .. but the flag doesn't even set that. Even if you avoid TRIM,
> Linus> there is absolutely zero guarantees that WRITE_SAME would do
> Linus> "real storage blocks full of zeroes backing the LBAs they just
> Linus> wrote out".
>
> That's not entirely true. Writing the blocks may cause them to be
> allocated on the storage device (depending on which flags we feed it in
> WRITE SAME).

Ok, so now we're getting somewhere, with actual _reasons_ why somebody
would want to use one interface over another.

> The filesystems people were wanted the following semantics:
>
>  - deallocate, don't care about contents for future reads (discard)
>  - deallocate, guarantee zeroes on future reads (zeroout)
>  - (re)allocate, guarantee zeroes on future reads (zeroout)
>
> Maybe we just need a better naming scheme...

Yes.

And this does make me think that Christoph is right: this would be so
much better if the block layer just supported fallocate() instead,
which already has those operations.

Right now we have

        if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
                return -ENODEV;

so right now the vfs_fallocate() code expliitly disallows block
devices, but that would be easy to expand.

Would people be happy with that kind of patch instead? It would
certainly make all my objections go away..

             Linus
