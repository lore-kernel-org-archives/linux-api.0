From: David Howells <dhowells@redhat.com>
Subject: Re: Regression for MS_MOVE on kernel v5.1
Date: Thu, 13 Jun 2019 10:27:30 +0100
Message-ID: <9383.1560418050@warthog.procyon.org.uk>
References: <CAHk-=wh2Khe1Lj-Pdu3o2cXxumL1hegg_1JZGJXki6cchg_Q2Q@mail.gmail.com> <20190612225431.p753mzqynxpsazb7@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wh2Khe1Lj-Pdu3o2cXxumL1hegg_1JZGJXki6cchg_Q2Q@mail.gmail.com>
Content-ID: <9382.1560418050.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[Adding Eric to the cc list since he implemented MNT_LOCKED]

Linus Torvalds <torvalds@linux-foundation.org> wrote:

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
