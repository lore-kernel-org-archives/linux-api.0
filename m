From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 10 Mar 2016 16:47:04 -0500
Message-ID: <20160310214704.GA8890@thunk.org>
References: <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
 <yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
 <20160303180924.GA4116@infradead.org>
 <yq1vb5375oh.fsf@sermon.lab.mkp.net>
 <20160303223952.GE24012@thunk.org>
 <20160303231050.GU29057@dastard>
 <CAC6JEv-HeAoRxSmVghGvbX7G92yH00k-5F-48qEW13vAB1Q99g@mail.gmail.com>
 <20160309230819.GB3949@thunk.org>
 <56E18B9B.5070503@gmail.com>
 <CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 10, 2016 at 10:33:49AM -0800, Linus Torvalds wrote:
> On Thu, Mar 10, 2016 at 6:58 AM, Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > What was objectionable at the time this patch was raised years back (not
> > just to me, but to pretty much every fs developer at LSF/MM that year)
> > centered on the concern that this would be viewed as a "performance" mode
> > and we get pressure to support this for non-priveleged users. It gives any
> > user effectively the ability to read the block device content for previously
> > allocated data without restriction.

Sure, but it was never "any user".  We always had group-based
permissions from the beginning.  Sure, we passed it in via a mount
option which was a bit hacky, but we never got to the point of
discussing the way that we would modulate the access --- the complaint
seemed to be that if it was a non-root user, it was an unacceptable
security hole.  And the pushback I got was more in the way of a
religious objection more than anything else.  Heck, even reserving a
code point for the out-of-tree patch received a huge amount of
pushback.

> The sane way to do it would be to just check permissions of the
> underlying block device.
> 
> That way, people can just set the permissions for that to whatever
> they want. If google right now uses some magical group for this, they
> could make the underlying block device be writable for that group.

I'd suggest making it be if you had *read* access to the block device.
After all, the risk that everyone was all excited about was the risk
of being able to read stale (deleted) data from old files.  And
there's no point giving the userspace cluster file system daemon the
ability to corrupt the file system or set the setuid bit on some
arbitrary executable.

And if we are going to go this far, then I'd also suggest using this
permission check to the user the ability to issue BLKDISCARD on a
file.  Allowing BLKDISCARD on files is one that should have been even
more of a no-brainer, since it could never reveal stale data, but
simply wasn't guaranteed to have reliable results because it was a
hint to the underlying storage device.  But this has also received a
huge amount of religious pushback, which is why this is also an
out-of-tree patch in the Google kernel.  (If that means that our
competitors have a higher flash TCO than us, again, no skin off my
nose.  I tried to get it upstream, and cost of forward porting the
patch each time we rebase the kernel isn't _that_ annoying.)

						- Ted


> We can do the security check at the filesystem level, because we have
> sb->s_bdev->bd_inode, and if you have read and write permissions to
> that inode, you might as well have permission to create a unsafe hole.
> 
> That doesn't sound very hacky to me.
> 
>                Linus
