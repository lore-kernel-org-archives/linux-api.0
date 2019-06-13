From: Christian Brauner <christian@brauner.io>
Subject: Re: Regression for MS_MOVE on kernel v5.1
Date: Thu, 13 Jun 2019 15:22:51 +0200
Message-ID: <20190613132250.u65yawzvf4voifea@brauner.io>
References: <20190612225431.p753mzqynxpsazb7@brauner.io>
 <CAHk-=wh2Khe1Lj-Pdu3o2cXxumL1hegg_1JZGJXki6cchg_Q2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wh2Khe1Lj-Pdu3o2cXxumL1hegg_1JZGJXki6cchg_Q2Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 12, 2019 at 06:00:39PM -1000, Linus Torvalds wrote:
> On Wed, Jun 12, 2019 at 12:54 PM Christian Brauner <christian@brauner.io> wrote:
> >
> > The commit changes the internal logic to lock mounts when propagating
> > mounts (user+)mount namespaces and - I believe - causes do_mount_move()
> > to fail at:
> 
> You mean 'do_move_mount()'.
> 
> > if (old->mnt.mnt_flags & MNT_LOCKED)
> >         goto out;
> >
> > If that's indeed the case we should either revert this commit (reverts
> > cleanly, just tested it) or find a fix.
> 
> Hmm.. I'm not entirely sure of the logic here, and just looking at
> that commit 3bd045cc9c4b ("separate copying and locking mount tree on
> cross-userns copies") doesn't make me go "Ahh" either.
> 
> Al? My gut feel is that we need to just revert, since this was in 5.1
> and it's getting reasonably late in 5.2 too. But maybe you go "guys,
> don't be silly, this is easily fixed with this one-liner".

David and I have been staring at that code today for a while together.
I think I made some sense of it.
One thing we weren't absolutely sure is if the old MS_MOVE behavior was
intentional or a bug. If it is a bug we have a problem since we quite
heavily rely on this...

So this whole cross-user+mnt namespace propagation mechanism comes with
a big hammer that Eric indeed did introduce a while back which is
MNT_LOCKED (cf. [1] for the relevant commit).

Afaict, MNT_LOCKED is (among other cases) supposed to prevent a user+mnt
namespace pair to get access to a mount that is hidden underneath an
additional mount. Consider the following scenario:

sudo mount -t tmpfs tmpfs /mnt
sudo mount --make-rshared /mnt
sudo mount -t tmpfs tmpfs /mnt
sudo mount --make-rshared /mnt
unshare -U -m --map-root --propagation=unchanged

umount /mnt
# or
mount --move -mnt /opt

The last umount/MS_MOVE is supposed to fail since the mount is locked
with MNT_LOCKED since umounting or MS_MOVing the mount would reveal the
underlying mount which I didn't have access to prior to the creation of
my user+mnt namespace pair.
(Whether or not this is a reasonable security mechanism is a separate
discussion.)

But now consider the case where from the ancestor user+mnt namespace
pair I do:

# propagate the mount to the user+mount namespace pair                 
sudo mount -t tmpfs tmpfs /mnt
# switch to the child user+mnt namespace pair
umount /mnt
# or
mount --move /mnt /opt

That umount/MS_MOVE should work since that mount was propagated to the
unprivileged task after the user+mnt namespace pair was created.
Also, because I already had access to the underlying mount in the first
place and second because this is literally the only way - we know of -
to inject a mount cross mount namespaces and this is a must have feature
that quite a lot of users rely on.

Christian

[1]: git show 5ff9d8a65ce80efb509ce4e8051394e9ed2cd942
