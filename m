From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 03 Mar 2016 13:01:11 -0500
Message-ID: <yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
	<20160302040947.16685.42926.stgit@birch.djwong.org>
	<CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
	<20160302225601.GB21890@birch.djwong.org>
	<CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Linus Torvalds's message of "Wed, 2 Mar 2016 15:49:53 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:

Linus> .. but the flag doesn't even set that. Even if you avoid TRIM,
Linus> there is absolutely zero guarantees that WRITE_SAME would do
Linus> "real storage blocks full of zeroes backing the LBAs they just
Linus> wrote out".

That's not entirely true. Writing the blocks may cause them to be
allocated on the storage device (depending on which flags we feed it in
WRITE SAME).

The filesystems people were wanted the following semantics:

 - deallocate, don't care about contents for future reads (discard)
 - deallocate, guarantee zeroes on future reads (zeroout)
 - (re)allocate, guarantee zeroes on future reads (zeroout)

Maybe we just need a better naming scheme...

-- 
Martin K. Petersen	Oracle Linux Engineering
