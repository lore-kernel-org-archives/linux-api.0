From: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 17 Mar 2016 14:00:18 -0700
Message-ID: <20160317210018.GA78710@clm-mbp.thefacebook.com>
References: <20160315223313.GH30721@dastard>
 <20160315225224.GD23848@thunk.org>
 <20160316015139.GC5826@birch.djwong.org>
 <7674C689-C07E-4D38-85EB-4FD9B55CBB35@dilger.ca>
 <20160317001502.GF23593@thunk.org>
 <56E9FB73.6040803@redhat.com>
 <CAC6JEv-CGaphHj6hVXUhFS+Dc4jS46nO1yOfKF5yA8AnDwqgOw@mail.gmail.com>
 <CA+55aFzbzXb9ApP5FnVZihWRpWGO1-YnJj_Giip5LfD6=uvf0w@mail.gmail.com>
 <20160317183512.GA76233@clm-mbp.thefacebook.com>
 <819F38A3-51A7-4874-8314-8A6004495716@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <819F38A3-51A7-4874-8314-8A6004495716-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 17, 2016 at 02:49:06PM -0600, Andreas Dilger wrote:
> On Mar 17, 2016, at 12:35 PM, Chris Mason <clm-b10kYP2dOMg@public.gmane.org> wrote:
> > 
> > On Thu, Mar 17, 2016 at 10:47:29AM -0700, Linus Torvalds wrote:
> >> On Wed, Mar 16, 2016 at 10:18 PM, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org> wrote:
> >>> 
> >>> So we've not asked for NO_HIDE_STALE on the mailing lists, but I think
> >>> it was one of the problems Sage had using xfs in his BlueStore
> >>> implementation and was a big part of why it moved to pure userspace.
> >>> FileStore might use NO_HIDE_STALE in some places but it would be
> >>> pretty limited. When it came up at Linux FAST we were discussing how
> >>> it and similar things had been problems for us in the past and it
> >>> would've been nice if they were upstream.
> >> 
> >> Hmm.
> >> 
> >> So to me it really sounds like somebody should cook up a patch, but we
> >> shouldn't put it in the upstream kernel until we get numbers and
> >> actual "yes, we'd use this" from outside of google.
> > 
> > We haven't had internal tiers yelling at us for fallocate performance,
> > so I'm unlikely to suggest it, just because its a potential
> > privacy leak we'd have to educate people about.  What I'd be more likely
> > to use is code inside the filesystem like this:
> > 
> > somefs_fallocate() {
> > 	if (trim_can_really_zero(my_device)) {
> > 		trim
> > 		allocate a regular extent
> > 		return
> > 	} else {
> > 		do normal fallocate
> > 	}
> > }
> 
> We were discussing almost this very same thing in the ext4 concall today.
> 
> Ted initially didn't think it was worthwhile to implement, but after looking
> at the whitelist for SATA SSDs it seems that there are enough devices on the
> market that support the ATA_HORKAGE_ZERO_AFTER_TRIM to make this approach
> worthwhile to implement.

We'll end up with people complaining it makes fallocate slower because
of the trims, so it's not a perfect solution.  But I much prefer it to
fallocate-stale.

> 
> Also, if the ext4 extent size was limited it might even be possible to do
> this efficiently enough with write_same on HDD devices.
> 
> > Then the out of tree patch (for google or whoever) becomes a hack to
> > flip trim_can_really_zero on a given block device.  The rest of us can
> > use explicit interfaces from the hardware when deciding what we want
> > preallocation to mean.
> 
> This might be a bit trickier, since this would affect all zero/trim
> operations, not just ones for uninitialized data extents.

Thinking more, my guess is that google will just keep doing what they
are already doing ;)  But there could be a flag in sysfs dedicated to
trim-for-fallocate so admins can see what their devices are reporting.
readonly in mainline, if someone wants to patch it in their large data
center it wouldn't be hard.

-chris
