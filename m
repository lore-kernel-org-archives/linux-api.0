From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Tue, 15 Mar 2016 17:29:08 -0400
Message-ID: <20160315212908.GB23848@thunk.org>
References: <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
 <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
 <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 01:43:01PM -0700, Linus Torvalds wrote:
> Put another way: this is not about theoretical leaks - because those
> are totally irrelevant (in theory, the original discard writer had
> access to all that stale data anyway). This is about making it a
> practical interface that doesn't have serious hidden gotchas.

So there have been two interfaces proposed so far:

1) A mount option which specifies the group id under which a program
must be running in order to have the permission to use
FALLOC_FL_NO_HIDE_STALE flag in the fallocate system call.

2) The program must have read access to the underlying block device
inode under which the file system is mounted in order to have the
permission to use the FALLOC_FL_NO_HIDE_STALE flag in the fallocate
system call.

In both cases, the application has to be make C source code changes to
use this feature, and the system administrator has to set up the
application so it has the privileges to use it.  In the case of #1,
the sysadmin has to specify a mount option as well.

We're doing #1 in production in a very large number of mounted disks
today.  Linus has suggested #2, although there was some concern that
screw-up in the user namespaces configuration could result in
accidentally in a security exposure.  (To which my response is, as
opposed to the gazillions of other security nightmares which the user
namespace makes us vulnerable to?)

Still, my preference is for #1, since the mount option acts as an
additional control for those really paranoid types that seem convinced
that it can't be used safely, and it's what we're doing in production
already.   I'm open to #2 if other people are OK with it, though.

Cheers,

						- Ted
