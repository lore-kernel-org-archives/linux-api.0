From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 4/7] vfs: Add superblock notifications
Date: Wed, 29 May 2019 16:16:10 +0200
Message-ID: <CAG48ez0Ugv=cfj-v6DaYma0HgyiBjpykSkCr7mCAcMx13LEncg@mail.gmail.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905934373.7587.10824503964531598726.stgit@warthog.procyon.org.uk>
 <CAG48ez2o1egR13FDd3=CgdXP_MbBsZM4SX=+aqvR6eheWddhFg@mail.gmail.com> <24577.1559134719@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <24577.1559134719@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 2:58 PM David Howells <dhowells@redhat.com> wrote:
> Jann Horn <jannh@google.com> wrote:
> > It might make sense to require that the path points to the root inode
> > of the superblock? That way you wouldn't be able to do this on a bind
> > mount that exposes part of a shared filesystem to a container.
>
> Why prevent that?  It doesn't prevent the container denizen from watching a
> bind mount that exposes the root of a shared filesystem into a container.

Well, yes, but if you expose the root of the shared filesystem to the
container, the container is probably meant to have a higher level of
access than if only a bind mount is exposed? But I don't know.

> It probably makes sense to permit the LSM to rule on whether a watch may be
> emplaced, however.

We should have some sort of reasonable policy outside of LSM code
though - the kernel should still be secure even if no LSMs are built
into it.

> > > +                       }
> > > +               }
> > > +               up_write(&s->s_umount);
> > > +               if (ret < 0)
> > > +                       kfree(watch);
> > > +       } else if (s->s_watchers) {
> >
> > This should probably have something like a READ_ONCE() for clarity?
>
> Note that I think I'll rearrange this to:
>
>         } else {
>                 ret = -EBADSLT;
>                 if (s->s_watchers) {
>                         down_write(&s->s_umount);
>                         ret = remove_watch_from_object(s->s_watchers, wqueue,
>                                                        s->s_unique_id, false);
>                         up_write(&s->s_umount);
>                 }
>         }
>
> I'm not sure READ_ONCE() is necessary, since s_watchers can only be
> instantiated once and the watch list then persists until the superblock is
> deactivated.  Furthermore, by the time deactivate_locked_super() is called, we
> can't be calling sb_notify() on it as it's become inaccessible.
>
> So if we see s->s_watchers as non-NULL, we should not see anything different
> inside the lock.  In fact, I should be able to rewrite the above to:
>
>         } else {
>                 ret = -EBADSLT;
>                 wlist = s->s_watchers;
>                 if (wlist) {
>                         down_write(&s->s_umount);
>                         ret = remove_watch_from_object(wlist, wqueue,
>                                                        s->s_unique_id, false);
>                         up_write(&s->s_umount);
>                 }
>         }

I'm extremely twitchy when it comes to code like this because AFAIK
gcc at least used to sometimes turn code that read a value from memory
and then used it multiple times into something with multiple memory
reads, leading to critical security vulnerabilities; see e.g. slide 36
of <https://www.blackhat.com/docs/us-16/materials/us-16-Wilhelm-Xenpwn-Breaking-Paravirtualized-Devices.pdf>.
I am not aware of any spec that requires the compiler to only perform
one read from the memory location in code like this.
