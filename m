From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH man-pages] Document encoded I/O
Date: Wed, 23 Oct 2019 09:06:24 +0300
Message-ID: <CAOQ4uxjyNZhyU9yEYkuMnD0o=sU1vJMOYJAzjV7FDjG45gaevg@mail.gmail.com>
References: <cover.1571164762.git.osandov@fb.com> <c7e8f93596fee7bb818dc0edf29f484036be1abb.1571164851.git.osandov@fb.com>
 <CAOQ4uxh_pZSiMmD=46Mc3o0GE+svXuoC155P_9FGJXdsE4cweg@mail.gmail.com>
 <20191021185356.GB81648@vader> <CAOQ4uxgm6MWwCDO5stUwOKKSq7Ot4-Sc96F1Evc6ra5qBE+-wA@mail.gmail.com>
 <20191023044430.alow65tnodgnu5um@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20191023044430.alow65tnodgnu5um@yavin.dot.cyphar.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, kernel-team@fb.com, Theodore Tso <tytso@mit.edu>
List-Id: linux-api@vger.kernel.org

> >
> > No, I see why you choose to add the flag to open(2).
> > I have no objection.
> >
> > I once had a crazy thought how to add new open flags
> > in a non racy manner without adding a new syscall,
> > but as you wrote, this is not relevant for O_ALLOW_ENCODED.
> >
> > Something like:
> >
> > /*
> >  * Old kernels silently ignore unsupported open flags.
> >  * New kernels that gets __O_CHECK_NEWFLAGS do
> >  * the proper checking for unsupported flags AND set the
> >  * flag __O_HAVE_NEWFLAGS.
> >  */
> > #define O_FLAG1 __O_CHECK_NEWFLAGS|__O_FLAG1
> > #define O_HAVE_FLAG1 __O_HAVE_NEWFLAGS|__O_FLAG1
> >
> > fd = open(path, O_FLAG1);
> > if (fd < 0)
> >     return -errno;
> > flags = fcntl(fd, F_GETFL, 0);
> > if (flags < 0)
> >     return flags;
> > if ((flags & O_HAVE_FLAG1) != O_HAVE_FLAG1) {
> >     close(fd);
> >     return -EINVAL;
> > }
>
> You don't need to add __O_HAVE_NEWFLAGS to do this -- this already works
> today for userspace to check whether a flag works properly
> (specifically, __O_FLAG1 will only be set if __O_FLAG1 is supported --
> otherwise it gets cleared during build_open_flags).

That's a behavior of quite recent kernels since
629e014bb834 fs: completely ignore unknown open flags
and maybe some stable kernels. Real old kernels don't have that luxury.

>
> The problem with adding new flags is that an *old* program running on a
> *new* kernel could pass a garbage flag (__O_CHECK_NEWFLAGS for instance)
> that causes an error only on the new kernel.
>

That's a theoretic problem. Same as O_PATH|O_TMPFILE.
Show me a real life program that passes garbage files to open.

> The only real solution to this (and several other problems) is
> openat2().

No argue about that. Come on, let's get it merged ;-)

> As for O_ALLOW_ENCODED -- the current semantics (-EPERM if it
> is set without CAP_SYS_ADMIN) *will* cause backwards compatibility
> issues for programs that have garbage flags set...
>

Again, that's theoretical.
In practice, O_ALLOW_ENCODED can work with open()/openat().
In fact, even if O_ALLOW_ENCODED gets merged after openat2(),
I don't think it should be forbidden by open()/openat(), right?
Do in that sense, O_ALLOW_ENCODED does not depend on openat2().

Thanks,
Amir.
