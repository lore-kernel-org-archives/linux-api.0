From: Lance Richardson <lance.richardson.net@gmail.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 14:59:32 -0500
Message-ID: <CAPmeqMoqNO2ps5tnGJX+Q7BgjdPKHt_vb3h+hDXC4=yth+r+dA@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
 <20181213160242.GV23599@brightrain.aerifal.cx> <c8987b31-ed79-acef-a300-31ebf2c29d2e@petrovitsch.priv.at>
 <20181214161732.GY23599@brightrain.aerifal.cx> <87mup8gj1y.fsf@oldenburg2.str.redhat.com>
 <20181214165535.GZ23599@brightrain.aerifal.cx> <EC1F028D-4382-41D6-B539-A9662FD53820@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EC1F028D-4382-41D6-B539-A9662FD53820@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Rich Felker <dalias@libc.org>, Florian Weimer <fweimer@redhat.com>, Bernd Petrovitsch <bernd@petrovitsch.priv.at>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

My impression is it was mostly a desire to reuse existing x86_64 system cal=
ls
as much as possible without modification or additional compat layer work.

The 64-bit time requirement seems to have come from an lkml discussion, whi=
ch
has quite a bit of interesting background about x32:
    https://lkml.org/lkml/2011/8/26/415
    https://lkml.org/lkml/2011/8/26/453


On Fri, Dec 14, 2018 at 2:05 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
>
>
> > On Dec 14, 2018, at 8:55 AM, Rich Felker <dalias@libc.org> wrote:
> >
> >> On Fri, Dec 14, 2018 at 05:38:33PM +0100, Florian Weimer wrote:
> >> * Rich Felker:
> >>
> >>> This is all useless (and wrong since tv_nsec is required to have type
> >>> long as part of C and POSIX, regardless of ILP32-vs-LP64; that's a bu=
g
> >>> in glibc's x32).
> >>
> >> We should be able to fix standards if they prove unworkable in practic=
e.
> >> In my opinion, if standards require complex solutions where an obvious
> >> and simple solution exists, then standards are wrong.
> >
> > The requirement doesn't mandate complex solutions. There's nothing
> > complex about tv_nsec being long. long is the smallest type that C
> > guarantees to be large enough to store the range of values, which is
> > forever fixed and can't grow (because the definition of "nano" prefix
> > is fixed :). The type has been long ever since the structure was
> > introduced, and its being long means that there's lots of (correct!)
> > code using %ld (e.g. ".%.9ld" to format results as a decimal without
> > using floating point approximations) to print it. There might also be
> > code taking pointers to it to pass to functions, etc.
> >
> > The only reason a "complex" need arises is that Linux did something
> > horribly wrong here, ignoring the specified type, when introducing an
> > obscure subarch that almost nobody uses. This kind of mistake is
> > becoming a theme in Linux (see also: msghdr). Application authors
> > should not have to pay the price for fixing this by retrofitting yet
> > another silly type like "snseconds_t" or something into programs to
> > accommodate the mistakes of x32.
> >
> >
>
> Does anyone know *why* Linux=E2=80=99s x32 has __kernel_long_t defined as=
 long long?  I assume that this is where this bug, and most of the other bu=
gs, came from.
>
> This may be silly, but the kernel could plausibly add a x32v2 where long =
is genuinely 32-bit, and then maybe we could drop the old x32 at some point=
.  From all the discussion so far, it seems like there really is some deman=
d for ILP32, but it=E2=80=99s still not really clear that preserving compat=
ibility with existing x32 binaries in the long run is critical.
