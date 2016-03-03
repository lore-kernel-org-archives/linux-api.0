From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 3 Mar 2016 10:00:03 -0800
Message-ID: <20160303180003.GA6969@infradead.org>
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
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2016 at 09:55:38AM -0800, Linus Torvalds wrote:
> Ugh.
> 
> But that essentially says that we shouldn't expose this interface at
> all (unless we trust our white-lists - I'm sure they are getting
> better, but if nobody has ever really _relied_ on the zeroing behavior
> of trim, then I guess there could be tons of bugs lurking).

Fortunately what Ted said is close to the truth, but a little off.

The mess about ATA is all real, and we work around it by never claiming
discard zeroes data for any ATA device except those specificly
whitelisted because the vendors gave guarantees for it (see the
ATA_HORKAGE_ZERO_AFTER_TRIM flag and the commit introducing it).

The reason why we don't use it unconditionally is simply because
there are users that want blocks zeroed without deallocating the
physical blocks.  Now if you want to opt into the trim/unmap
behavior is one question, but we clearly need the split.
