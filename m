From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 3 Mar 2016 13:21:46 -0500
Message-ID: <20160303182146.GG9772@thunk.org>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
 <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
 <20160302225601.GB21890@birch.djwong.org>
 <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
 <20160303170205.GD24012@thunk.org>
 <CA+55aFwPA1X8XGTdVZmP5uzkWMwj+X=bjkGVcEkZDme+qskrzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwPA1X8XGTdVZmP5uzkWMwj+X=bjkGVcEkZDme+qskrzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2016 at 09:55:38AM -0800, Linus Torvalds wrote:
> But that essentially says that we shouldn't expose this interface at
> all (unless we trust our white-lists - I'm sure they are getting
> better, but if nobody has ever really _relied_ on the zeroing behavior
> of trim, then I guess there could be tons of bugs lurking).

We don't, so this interface won't be useful for SATA disks, where
we'll need to write zeros until the SATA folks get off their duffs and
fix it with a new, reliable trim command.

But it will be useful for other storage systems, such as eMMC devices,
which *do* have a reliable trim command.  So it may be that the first
place we'll see widepspread usage of this will be in the low-end and
high-end systems (where we can rely on eMMC's reliable trim and SCSI's
WRITE SAME command).

But that's why we want to have a new interface which is distinct from
BLKDISCARD.  We want one interface for an advisory hint (we don't care
about the contents, so if it's convenient, feel free to forget about
the contents and replace it by zeros), and something where it truly is
a zeroout command.  The intention is that BLKZEROOUT will be the
reliable zeroout command, while BLKDISCARD will be the unreliable
advisory hint.

						- Ted
