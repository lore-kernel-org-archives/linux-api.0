From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 13:27:40 -0800
Message-ID: <CALCETrV2kV5cm7xJfKJ4J4VjhhypnMhfOYkOcU5w2Ps1BiMxMw@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
 <20181213160242.GV23599@brightrain.aerifal.cx> <c8987b31-ed79-acef-a300-31ebf2c29d2e@petrovitsch.priv.at>
 <20181214161732.GY23599@brightrain.aerifal.cx> <87mup8gj1y.fsf@oldenburg2.str.redhat.com>
 <20181214165535.GZ23599@brightrain.aerifal.cx> <EC1F028D-4382-41D6-B539-A9662FD53820@amacapital.net>
 <CAHk-=wj0ejxYVV1xPfNX5YD6ZakRoSx+wQR==rFoj4J4SzLWhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wj0ejxYVV1xPfNX5YD6ZakRoSx+wQR==rFoj4J4SzLWhg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rich Felker <dalias@libc.org>, Florian Weimer <fweimer@redhat.com>, Bernd Petrovitsch <bernd@petrovitsch.priv.at>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 14, 2018 at 12:13 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Dec 14, 2018 at 10:58 AM Andy Lutomirski <luto@amacapital.net> wr=
ote:
> >
> > Does anyone know *why* Linux=E2=80=99s x32 has __kernel_long_t defined =
as long long?
>
> It *needs* to be long long, since the headers are used for builds in
> user mode using ILP32.
>
> Since __kernel_long_t is a 64-bit (the _kernel_ is not ILP32), you
> need to use "long long" when building in ILP32.
>
> Obviously, it could be something like
>
>    #ifdef __KERNEL__
>     typedef long __kernel_long_t;
>    #else
>     typedef long long __kernel_long_t;
>    #endif
>
> or similar to make it more obvious what's going on.
>
> Or we could encourage all the uapi header files to always just use
> explicit sizing like __u64, but some of the structures really end up
> being "kernel long size" for sad historical reasons. Not lovely, but
> there we are..
>

This is probably water under the bridge, but I disagree with you here.
Or rather, I agree with you in principle but I really don't like the
way it turned out.

For legacy uapi structs (and probably some new ones too, sigh), as a
practical matter, user code is going to shove them at the C compiler,
and the C compiler is going to interpret them in the usual way, and
either we need a usermode translation layer or the kernel needs to
deal with the result.

It's a nice thought that, by convincing an x32 compiler that
__kernel_long_t is 64 bits, we end up with the x32 struct being
compatible with the native Linux struct, but it only works for structs
where the only ABI-dependent type is long.  But the real structs in
uapi aren't all like this.  We have struct iovec:

struct iovec
{
        void __user *iov_base;  /* BSD uses caddr_t (1003.1g requires void =
*) */
        __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
};

Whoops, this one looks the same on x32 and i386, but neither one of
them match x86_64, and, just randomly grepping around a bit, I see:

struct snd_hwdep_dsp_image {
        unsigned int index;             /* W: DSP index */
        unsigned char name[64];         /* W: ID (e.g. file name) */
        unsigned char __user *image;    /* W: binary image */
        size_t length;                  /* W: size of image in bytes */
        unsigned long driver_data;      /* W: driver-specific data */
};

struct __sysctl_args {
        int __user *name;
        int nlen;
        void __user *oldval;
        size_t __user *oldlenp;
        void __user *newval;
        size_t newlen;
        unsigned long __unused[4];
};

If these had been switched from "unsigned long" to __kernel_ulong_t,
they would have had three different layouts on i386, x32, and x86_64.

So now we have a situation where, if we were to make x32 work 100%,
the whole kernel would need to recognize that there are three possible
ABIs, not two.  And this sucks.

So I think it would have been a better choice to let long be 32-bit on
x32 and to therefore make x32 match the x86_32 "compat" layout as much
as possible.  Sure, this would make x32 be more of a second-class
citizen, but I think it would have worked better, had fewer bugs, and
been more maintainable.

--Andy
