From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 16 Mar 2016 09:33:13 +1100
Message-ID: <20160315223313.GH30721@dastard>
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
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 01:43:01PM -0700, Linus Torvalds wrote:
> On Tue, Mar 15, 2016 at 1:14 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> >
> > Root can still change the group id of a file that has exposed stale
> > data and hence make it visible outside of the group based
> > containment wall.
> 
> Ok, Dave, now you're just being ridiculous.
> 
> The issue has never been - and *should* never be - that stale data
> cannot get out.

Stale data escaping containment is a security issue. Enabling
generic kernel mechanisms to *enable containment escape* is
fundamentally wrong, and relying on userspace to Do The Right Thing
is even more of a gamble, IMO.

> The only issue is that we shouldn't make it ridiculously easy to make
> silly mistakes.

# sudo rsync -a ....

And now the stale data is on another machine without group-based
access containment.

> There's no "group based containment wall" that is some kind of
> absolute protection border.

Precisely my point - it's being pitched as a generic containment
mechanism, but it really isn't.

> Put another way: this is not about theoretical leaks - because those
> are totally irrelevant (in theory, the original discard writer had
> access to all that stale data anyway). This is about making it a
> practical interface that doesn't have serious hidden gotchas.
> 
> So stop making silly theoretical arguments that make no sense.

It's a practical concern because if we enable this functionality in
fallocate because it will get used by more than just special storage
apps. i.e. this can't be waved away with "only properly managed
applications will use it" arguments.

> We should make sure that we have _practical_ rules that are sensible,
> but also not painful enough for the people who want to use this in
> _practice_.

Of course. The fact is that most of the people discussing this issue
have very little domain specific expertise.

In _practice_, XFS has *always* been able to turn off unwritten
extents and expose stale data.  e.g. see this speed-racer blog from
2003 (first google hit on "xfs bonnie++ optimisation"):

http://everything2.com/title/Filesystem+performance+tweaking+with+XFS+on+Linux

	" The first XFS tweak I'll try relates to XFS' practice of
	adding a flag to all unwritten extents. This is a safety
	feature, and it can be disabled with an option during
	filesystem creation time (mkfs.xfs -d unwritten=0). [....]

	A few improvements, a few setbacks, they're all at the level
	of statistical noise. Disabling unwritten extent flagging
	doesn't seem to be terribly useful here."

I also don't make a habit of publicising the fact that since we
disabled the "-d unwritten=X" mkfs parameter (because of speed racer
blogs such as the above and configuration cargo-culting resulting in
unsuspecting users exposing stale data unintentionally) that the
functionality still exists in the kernel code and that it only takes
a single xfs_db command to turn off unwritten extents in XFS. i.e.
we can easily make fallocate on XFS expose stale data, filesystem
wide, without requiring mount options, kernel or application
modifications.

And, yes, I do know of proprietary and non-public storage
applications that have used this capability for years, even though
it is unsupported and performance benefits have only ever been
marginal.

> Reality trumps everything else.

Yes, it does. The reality is we've enabled people who know what they
are doing to expose stale data through preallocation interfaces on
XFS since 1998 and we haven't required kernel API hacks to do this.

> If google is already using this kind of interface, then that is
> _reality_. Take that into account.

Making Google's hack more widely available through the fallocate
API is entirely dependent on proving that:

	a) the performance problem still exists;
	b) the performance problem exists across multiple
	   filesytsems and is not isolated to just ext4 or one specific
	   set of workloads;
	c) the performance problem cannot be fixed;
	d) ext4 can't implement a simple feature check to turn off
	   unwritten extents similar to XFS; and
	e) if all else fails, that the API hack does not compromise the
	   security of general users unaware that applications might
	   be using this functionality.

a), b), c) and d) have not been demonstrated, discussed or iterated -
we've jumped straight to arguing about e). Before anything else,
we need to work through a)-d) because exposing stale data through a
general purpose API is a *last resort*.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
