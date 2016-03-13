From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Mon, 14 Mar 2016 10:30:49 +1100
Message-ID: <20160313233049.GA30721@dastard>
References: <56E18B9B.5070503@gmail.com>
 <CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
 <56E24CA5.3030702@redhat.com>
 <20160311135952.57a44931@lxorguk.ukuu.org.uk>
 <CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
 <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
 <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
 <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 04:44:16PM -0800, Linus Torvalds wrote:
> On Fri, Mar 11, 2016 at 4:35 PM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> >
> > At the end of the day it's about whether you trust the userspace
> > program or not.
> 
> There's a big difference between "give the user rope", and "tie the
> rope in a noose and put a banana peel so that the user might stumble
> into the rope and hang himself", though.
> 
> So I do think that Dave is right that we should also strive to make
> sure that our interfaces are not just secure in theory, but that they
> are also good interfaces to make mistakes less likely.

At which point I have to ask: how do we safely allow filesystems to
expose stale data in files? There's a big "we need to trust
userspace" component in ever proposal that has been made so far -
that's the part I have extreme trouble with.

For example, what happens when a backup process running as root a
file that has exposed stale data? Yes, we could set the "NODUMP"
flag on the inode to tell backup programs to skip backing up such
files, but we're now trusting some random userspace application
(e.g. tar, rsync, etc) not to do something we don't want it to do
with the data in that file.

AFAICT, we can't stop root from copying files that have exposed
stale data or changing their ownership without some kind of special
handling of "contains stale data" files within the kernel. At this
point we are back to needing persistent tracking of the "exposed
stale data" state in the inode as the only safe way to allow us to
expose stale data.  That's fairly ironic given that the stated
purpose of exposing stale data through fallocate is to avoid the
overhead of the existing mechanisms we use to track extents
containing stale data....

> I think we _should_ give users rope, but maybe we should also make
> sure that there isn't some hidden rapidly spinning saw-blade right
> next to the rope that the user doesn't even think about.

IMO we already have a good, safe interface that provides the rope
without the saw blades. I'm happy to be proven wrong, but IMO I
don't see that we can provide stale data exposure in a safe,
non-saw-bladey way without any kernel/filesystem side overhead.....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
