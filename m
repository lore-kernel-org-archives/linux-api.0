From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Sat, 12 Mar 2016 09:30:47 +1100
Message-ID: <20160311223047.GZ30721@dastard>
References: <20160303231050.GU29057@dastard>
 <CAC6JEv-HeAoRxSmVghGvbX7G92yH00k-5F-48qEW13vAB1Q99g@mail.gmail.com>
 <20160309230819.GB3949@thunk.org>
 <56E18B9B.5070503@gmail.com>
 <CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
 <56E24CA5.3030702@redhat.com>
 <20160311135952.57a44931@lxorguk.ukuu.org.uk>
 <CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
 <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
 <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 10:25:30AM -0800, Linus Torvalds wrote:
> On Fri, Mar 11, 2016 at 9:30 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> >
> > What if we had an ioctl to do these data-leaking operations that took,
> > as an extra parameter, an fd to the block device node.  They allow
> > access if the fd points to the right inode and has FMODE_READ (and LSM
> > checks say it's okay).  Sure, it's awkward, but it's much safer.
> 
> That sounds absolutely horrible.
> 
> I'd *much* prefer the suggestion from Alan to simply have a mount-time
> option to enable it. That way, you will never get any surprises, and
> no "subtle new behavior for somebody who set their system up in a way
> that doesn't allow for this".
> 
> So you'd have to explicitly say "my setup is ok with hole punching".

Except it's not hole punching that is the problem. Hoel punching
makes sure that the underlying blocksare removed and so whatever
data is in them cannot be accessed any more. The problem here is
preallocation of unwritten blocks that expose the stale data if the
filesystem skips marking those blocks as unwritten.

And, so, what happens when a file that is preallocated with the
unwritten bit so it exposes stale data then has it's owner/group
changed? Or copied by root/user in privileged group to a different
location that other users can access? Or any of the other vectors
that can result in the stale data being copied/made available to
unprivileged users?

It's all well and good to restrict access to the fallocate() call to
limit who can expose stale data, but it doesn't remove the fact it
is easy for stale data to unintentionally escape the privileged
group once it has been exposed because there is no record of the
fact the file contains uninitialised blocks....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
