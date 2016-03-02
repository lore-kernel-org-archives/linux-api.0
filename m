From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Wed, 2 Mar 2016 10:52:01 -0800
Message-ID: <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
	<20160302040947.16685.42926.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160302040947.16685.42926.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 1, 2016 at 8:09 PM, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Create a new ioctl to expose the block layer's newfound ability to
> issue either a zeroing discard, a WRITE SAME with a zero page, or a
> regular write with the zero page.  This BLKZEROOUT2 ioctl takes
> {start, length, flags} as parameters.  So far, the only flag available
> is to enable the zeroing discard part -- without it, the call invokes
> the old BLKZEROOUT behavior.  start and length have the same meaning
> as in BLKZEROOUT.

NAK, just based on annoyance with the randomness of this interface:

 - without describing what the point of the new flag and lots of extra
expansion room is, this should never be merged. We don't add padding
just randomly.

 - Somewhat related to that: the flags are checked for zero, but the
random expansion room isn't. So not only are the random expansion
fields not explained, they will contain random garbage in the future.

 - why is that "FMODE_WRITE" check not in the common code, but duplicated?

it all seems very ad-hoc. It makes a big deal about that idiotic
"discard" behavior, which is entirely pointless.

Who cares about that discard behavior anyway? Why is it set to "false"
in the current version of BLKZEROOUT in the first place? Why do we do
that WRITE_SAME without questioning it, but "discard" is somehow so
special that it has a flag, and it's turned off by default?

If this is some "security issue" where somebody believes that discard
is not secure, then those people are full of shit. Discard and
write-same have exactly the same semantics - they may just unmap the
target range with the guarantee that you'll get zeroes on read.

So quite frankly, right now it seems that

 (a) the *only* excuse for this patch is that people want to use "discard"

 (b) the reason we already don't use "discard" for the old BLKZEROOUT
is very questionable

 (c) any future possible use of flags is not described and is questionable

You'll find people who think that "write-same with some non-zero
pattern" would be a real over-write and good for security. Those
people will then argue that a sane extension would be to make that
pattern part of the future expansion of BLKZEROOUT2. And those people
are full of shit. Write-same with a non-zero pattern may well be just
a discard with the pattern set in another table.

So the whole patch looks pointless.

Why isn't the patch just "change false to true in blk_ioctl_zeroout()
when it calls blkdev_issue_zeroout()".

No new interface, no new random padding, just a simple "it makes
absolutely no sense to not allow discard".

                    Linus
