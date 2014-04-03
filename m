From: Richard Hansen <rhansen@bbn.com>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Date: Thu, 03 Apr 2014 16:23:51 -0400
Message-ID: <533DC357.1080203@bbn.com>
References: <533B04A9.6090405@bbn.com> <20140402111032.GA27551@infradead.org> <1396439119.2726.29.camel@menhir> <533CA0F6.2070100@bbn.com> <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: mtk.manpages@gmail.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Troxel <gdt@ir.bbn.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On 2014-04-03 04:25, Michael Kerrisk (man-pages) wrote:
> [CC +=3D Peter Zijlstra]
> [CC +=3D bug-readline@gnu.org -- maintainers, it _may_ be desirable to
> fix your msync() call]

I didn't see bug-readline@gnu.org in the CC list -- did you forget to
add them, or were they BCC'd?

>>   * Clearer intentions.  Looking at the existing code and the code
>>     history, the fact that flags=3D0 behaves like flags=3DMS_ASYNC app=
ears
>>     to be a coincidence, not the result of an intentional choice.
>=20
> Maybe. You earlier asserted that the semantics when flags=3D=3D0 may ha=
ve
> been different, prior to Peter Zijstra's patch,
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D204ec841fbea3e5138168edbc3a76d46747cc987
> .
> It's not clear to me that that is the case. But, it would be wise to
> CC the developer, in case he has an insight.

Good idea, thanks.

> But, even if you could find and fix every application that misuses
> msync(), new kernels with your proposed changes would still break old
> binaries. Linus has made it clear on numerous occasions that kernel
> changes must not break user space. So, the change you suggest is never
> going to fly (and Christoph's NAK at least saves Linus yelling at you
> ;-).)

OK -- that's a good enough reason for me.

> I think the only reasonable solution is to better document existing
> behavior and what the programmer should do.

Greg mentioned the possibility of syslogging a warning the first time a
process uses msync() with neither flag set.  Another alternative would
be to do this in userspace: modify the {g,u}libc shims to log a warning
to stderr.

And there's yet another alternative that's probably a bad idea but I'll
toss it out anyway:  I'm not very familiar with the Linux kernel, but
the NetBSD kernel defines multiple versions of some syscalls for
backward-compatibility reasons.  A new non-backward-compatible version
of an existing syscall gets a new syscall number.  Programs compiled
against the latest headers use the new version of the syscall but old
binaries still get the old behavior.  I imagine folks would frown upon
doing something like this in Linux for msync() (create a new version
that EINVALs if neither flag is specified), but it would be a way to
migrate toward a portability-friendly behavior while maintaining
compatibility with existing binaries.  (Sloppy userspace programs would
still need to be fixed, so this would still "break userspace".)

> With that in mind, I've
> drafted the following text for the msync(2) man page:
>=20
>     NOTES
>        According to POSIX, exactly one of MS_SYNC and MS_ASYNC  must  b=
e
>        specified  in  flags.   However,  Linux permits a call to msync(=
)
>        that specifies neither of these flags, with  semantics  that  ar=
e
>        (currently)  equivalent  to  specifying  MS_ASYNC.   (Since Linu=
x
>        2.6.19, MS_ASYNC is in fact a no-op, since  the  kernel  properl=
y
>        tracks  dirty  pages  and  flushes them to storage as necessary.=
)
>        Notwithstanding the Linux behavior, portable, future-proof appli=
=E2=80=90
>        cations  should  ensure  that they specify exactly one of MS_SYN=
C
>        and MS_ASYNC in flags.
>=20
> Comments on this draft welcome.

I agree with Greg's reply to this note.  How about this text instead:

    Exactly one of MS_SYNC and MS_ASYNC must be specified in flags.
    If neither flag is set, the behavior is unspecified.

I'll follow up with a new patch that explicitly defaults to MS_ASYNC (to
document the desire to maintain compaitibility and to prevent unexpected
problems if msync() is ever overhauled again).

Thanks,
Richard

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
