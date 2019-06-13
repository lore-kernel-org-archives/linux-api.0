From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Regression for MS_MOVE on kernel v5.1
Date: Thu, 13 Jun 2019 22:25:44 +0200
Message-ID: <CAJfpegvZwDY+zoWjDTrPpMCS01rzQgeE-_z-QtGfvcRnoamzgg@mail.gmail.com>
References: <20190612225431.p753mzqynxpsazb7@brauner.io> <CAHk-=wh2Khe1Lj-Pdu3o2cXxumL1hegg_1JZGJXki6cchg_Q2Q@mail.gmail.com>
 <20190613132250.u65yawzvf4voifea@brauner.io> <871rzxwcz7.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <871rzxwcz7.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 13, 2019 at 8:35 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Christian Brauner <christian@brauner.io> writes:
>
> > On Wed, Jun 12, 2019 at 06:00:39PM -1000, Linus Torvalds wrote:
> >> On Wed, Jun 12, 2019 at 12:54 PM Christian Brauner <christian@brauner.io> wrote:
> >> >
> >> > The commit changes the internal logic to lock mounts when propagating
> >> > mounts (user+)mount namespaces and - I believe - causes do_mount_move()
> >> > to fail at:
> >>
> >> You mean 'do_move_mount()'.
> >>
> >> > if (old->mnt.mnt_flags & MNT_LOCKED)
> >> >         goto out;
> >> >
> >> > If that's indeed the case we should either revert this commit (reverts
> >> > cleanly, just tested it) or find a fix.
> >>
> >> Hmm.. I'm not entirely sure of the logic here, and just looking at
> >> that commit 3bd045cc9c4b ("separate copying and locking mount tree on
> >> cross-userns copies") doesn't make me go "Ahh" either.
> >>
> >> Al? My gut feel is that we need to just revert, since this was in 5.1
> >> and it's getting reasonably late in 5.2 too. But maybe you go "guys,
> >> don't be silly, this is easily fixed with this one-liner".
> >
> > David and I have been staring at that code today for a while together.
> > I think I made some sense of it.
> > One thing we weren't absolutely sure is if the old MS_MOVE behavior was
> > intentional or a bug. If it is a bug we have a problem since we quite
> > heavily rely on this...
>
> It was intentional.
>
> The only mounts that are locked in propagation are the mounts that
> propagate together.  If you see the mounts come in as individuals you
> can always see/manipulate/work with the underlying mount.
>
> I can think of only a few ways for MNT_LOCKED to become set:
> a) unshare(CLONE_NEWNS)
> b) mount --rclone /path/to/mnt/tree /path/to/propagation/point
> c) mount --move /path/to/mnt/tree /path/to/propgation/point
>
> Nothing in the target namespace should be locked on the propgation point
> but all of the new mounts that came across as a unit should be locked
> together.

Locked together means the root of the new mount tree doesn't have
MNT_LOCKED set, but all mounts below do have MNT_LOCKED, right?

Isn't the bug here that the root mount gets MNT_LOCKED as well?

>
> Then it breaking is definitely a regression that needs to be fixed.
>
> I believe the problematic change as made because the new mount
> api allows attaching floating mounts.  Or that was the plan last I
> looked.   Those floating mounts don't have a mnt_ns so will result
> in a NULL pointer dereference when they are attached.

Well, it's called anonymous namespace.  So there *is* an mnt_ns, and
its lifetime is bound to the file returned by fsmount().

Thanks,
Miklos
