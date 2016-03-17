From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 17 Mar 2016 11:35:12 -0700
Message-ID: <20160317183512.GA76233@clm-mbp.thefacebook.com>
References: <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <20160315225224.GD23848@thunk.org>
 <20160316015139.GC5826@birch.djwong.org>
 <7674C689-C07E-4D38-85EB-4FD9B55CBB35@dilger.ca>
 <20160317001502.GF23593@thunk.org>
 <56E9FB73.6040803@redhat.com>
 <CAC6JEv-CGaphHj6hVXUhFS+Dc4jS46nO1yOfKF5yA8AnDwqgOw@mail.gmail.com>
 <CA+55aFzbzXb9ApP5FnVZihWRpWGO1-YnJj_Giip5LfD6=uvf0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzbzXb9ApP5FnVZihWRpWGO1-YnJj_Giip5LfD6=uvf0w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gregory Farnum <greg@gregs42.com>, Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Ric Wheeler <rwheeler@redhat.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Martin Petersen <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 17, 2016 at 10:47:29AM -0700, Linus Torvalds wrote:
> On Wed, Mar 16, 2016 at 10:18 PM, Gregory Farnum <greg@gregs42.com> wrote:
> >
> > So we've not asked for NO_HIDE_STALE on the mailing lists, but I think
> > it was one of the problems Sage had using xfs in his BlueStore
> > implementation and was a big part of why it moved to pure userspace.
> > FileStore might use NO_HIDE_STALE in some places but it would be
> > pretty limited. When it came up at Linux FAST we were discussing how
> > it and similar things had been problems for us in the past and it
> > would've been nice if they were upstream.
> 
> Hmm.
> 
> So to me it really sounds like somebody should cook up a patch, but we
> shouldn't put it in the upstream kernel until we get numbers and
> actual "yes, we'd use this" from outside of google.

We haven't had internal tiers yelling at us for fallocate performance,
so I'm unlikely to suggest it, just because its a potential
privacy leak we'd have to educate people about.  What I'd be more likely
to use is code inside the filesystem like this:

somefs_fallocate() {
	if (trim_can_really_zero(my_device)) {
		trim
		allocate a regular extent
		return
	} else {
		do normal fallocate
	}
}

Then the out of tree patch (for google or whoever) becomes a hack to
flip trim_can_really_zero on a given block device.  The rest of us can
use explicit interfaces from the hardware when deciding what we want
preallocation to mean.

It gets messy for crcs in btrfs, so we'd need the old fashioned
preallocation anyway.  But the database workloads where this matters
aren't our target right now, so its more an ext4/xfs thing anyway.

-chris

