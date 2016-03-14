From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Mon, 14 Mar 2016 10:46:03 -0400
Message-ID: <20160314144603.GO29218@thunk.org>
References: <56E24CA5.3030702@redhat.com>
 <20160311135952.57a44931@lxorguk.ukuu.org.uk>
 <CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
 <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
 <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
 <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E69398.7030508-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 14, 2016 at 06:34:00AM -0400, Ric Wheeler wrote:
> I think that once we enter this mode, the local file system has effectively
> ceded its role to prevent stale data exposure to the upper layer. In effect,
> this ceases to become a normal file system for any enabled process if we
> control this through fallocate() or for all processes if we do the brute
> force mount option that would be file system wide.

Or we do this via group id, such that we are ceding responsibility for
proventing stale data exposure to the processes running under that
group id.  That process has the responsibility for making sure that it
doesn't return any data from that file unless it has been written, and
also to make sure the permissions of that file are not readable by
processes that aren't in that group.  (For example, owned by user
ceph, group ceph, with premissions 640).

> In the end, that is the actual goal - move this enforcement up a layer for
> overlay/user space file systems that are then responsible for policing this
> ind of thing.

Yes, exactly.

						- Ted
