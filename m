From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 16 Mar 2016 11:08:23 +1100
Message-ID: <20160316000823.GJ30721@dastard>
References: <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <CA+55aFxCpza3_3J8kP9E0gLKHiSitZHjC4UMS_ZfZ_HBTC9=Bg@mail.gmail.com>
 <CA+55aFw80NXB9L7ooxV0zr3oaf4zWzZAJcb87ib58n=toiCn7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFw80NXB9L7ooxV0zr3oaf4zWzZAJcb87ib58n=toiCn7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 04:14:32PM -0700, Linus Torvalds wrote:
> On Tue, Mar 15, 2016 at 4:06 PM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >
> > And yes, "keep the patch entirely inside google" is obviously one good
> > way to limit the interface. But if there are really other groups that
> > want to explore this, then that sounds like a pretty horrible model
> > too.
> 
> Side note: I really don't see how your argument of "XFS has been able
> to do something like this for over a decade, using an even uglier
> trick that is hidden and not documented" is at all an argument for
> your position.
> 
> You're saying "nobody else should be doing what I've been doing for a
> long time", and backing that argument up with "but I don't document
> it, and it's completely different because it's done at mkfs/debugfs
> time rather than mount-time".

You can read it that way, but that is not the message I was trying
to get across.

The message I was trying to get across is that there are people out
there that have been using hacks like what google uses for as long
as there have been filesystems around that support unwritten
extents. And that they do this even though the benefits of such
hacks are marginal and frequently can't be backed up with numbers.

We don't support filesystems with unwritten extents disabled. I
don't like the fact that there are people who turn them off on XFS
filesystems, but we are stuck with it as it is part of the supported
on disk format that. The best we can do is to try to prevent
unsuspecting users from shooting themselves in the foot with such
features, which is what we did by removing the mkfs option back in
2007.

Like I said, most people don't know or understand the history....

> But now that people are talking about a filesystem-independent way of
> doing the same thing, now it's suddenly poisonous.

It's always been poisonous.

> Dave, I call BS on your arguments. Or maybe I misunderstood it. But it
> does smell very "do what I say, not what I do".

We're stuck with a lot of historical functionality in XFS that we
can't easily remove or disable. Learn from history, don't repeat it.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
