From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression for MS_MOVE on kernel v5.1
Date: Wed, 12 Jun 2019 18:00:39 -1000
Message-ID: <CAHk-=wh2Khe1Lj-Pdu3o2cXxumL1hegg_1JZGJXki6cchg_Q2Q@mail.gmail.com>
References: <20190612225431.p753mzqynxpsazb7@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612225431.p753mzqynxpsazb7@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 12, 2019 at 12:54 PM Christian Brauner <christian@brauner.io> wrote:
>
> The commit changes the internal logic to lock mounts when propagating
> mounts (user+)mount namespaces and - I believe - causes do_mount_move()
> to fail at:

You mean 'do_move_mount()'.

> if (old->mnt.mnt_flags & MNT_LOCKED)
>         goto out;
>
> If that's indeed the case we should either revert this commit (reverts
> cleanly, just tested it) or find a fix.

Hmm.. I'm not entirely sure of the logic here, and just looking at
that commit 3bd045cc9c4b ("separate copying and locking mount tree on
cross-userns copies") doesn't make me go "Ahh" either.

Al? My gut feel is that we need to just revert, since this was in 5.1
and it's getting reasonably late in 5.2 too. But maybe you go "guys,
don't be silly, this is easily fixed with this one-liner".

                      Linus
