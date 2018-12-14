From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 12:13:01 -0800
Message-ID: <CAHk-=wj0ejxYVV1xPfNX5YD6ZakRoSx+wQR==rFoj4J4SzLWhg@mail.gmail.com>
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
Cc: dalias@libc.org, fweimer@redhat.com, bernd@petrovitsch.priv.at, glaubitz@physik.fu-berlin.de, Andrew Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, bp@alien8.de, vapier@gentoo.org, hjl.tools@gmail.com, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 14, 2018 at 10:58 AM Andy Lutomirski <luto@amacapital.net> wrot=
e:
>
> Does anyone know *why* Linux=E2=80=99s x32 has __kernel_long_t defined as=
 long long?

It *needs* to be long long, since the headers are used for builds in
user mode using ILP32.

Since __kernel_long_t is a 64-bit (the _kernel_ is not ILP32), you
need to use "long long" when building in ILP32.

Obviously, it could be something like

   #ifdef __KERNEL__
    typedef long __kernel_long_t;
   #else
    typedef long long __kernel_long_t;
   #endif

or similar to make it more obvious what's going on.

Or we could encourage all the uapi header files to always just use
explicit sizing like __u64, but some of the structures really end up
being "kernel long size" for sad historical reasons. Not lovely, but
there we are..

              Linus
