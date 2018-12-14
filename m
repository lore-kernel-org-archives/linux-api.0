From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 15:13:10 +0100
Message-ID: <c8987b31-ed79-acef-a300-31ebf2c29d2e@petrovitsch.priv.at>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
 <20181213160242.GV23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------544822C287D28255C7136853"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213160242.GV23599@brightrain.aerifal.cx>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------544822C287D28255C7136853
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 13/12/2018 17:02, Rich Felker wrote:
> On Tue, Dec 11, 2018 at 11:29:14AM +0100, John Paul Adrian Glaubitz wro=
te:
>> I can't say anything about the syscall interface. However, what I do k=
now
>> is that the weird combination of a 32-bit userland with a 64-bit kerne=
l
>> interface is sometimes causing issues. For example, application code u=
sually
>> expects things like time_t to be 32-bit on a 32-bit system. However, t=
his

IMHO this just historically grown (as in "it has been forever that way"
- it sounds way better in Viennese dialect though;-).

>> isn't the case for x32 which is why code fails to build.
>=20
> I don't see any basis for this claim about expecting time_t to be
> 32-bit. I've encountered some programs that "implicitly assume" this
> by virtue of assuming they can cast time_t to long to print it, or
> similar. IIRC this was an issue in busybox at one point; I'm not sure
> if it's been fixed. But any software that runs on non-Linux unices has
> long been corrected. If not, 2038 is sufficiently close that catching
> and correcting any such remaining bugs is more useful than covering
> them up and making the broken code work as expected.

Yup, unconditionally providing 64bit
time_t/timespec/timeval/...-equivalents with libc and syscall support
also for 32bit architectures (and deprecating all 32bit versions) should
be the way to go.

FWIW I have
----  snip  ----
#if defined __x86_64__
# if defined __ILP32__		// x32
#  define PRI_time_t	"lld"	// for time_t
#  define PRI_nsec_t	"lld"	// for tv_nsec in struct timespec
# else				// x86_64
#  define PRI_time_t	"ld"	// for time_t
#  define PRI_nsec_t	"ld"	// for tv_nsec in struct timespec
# endif
#else				// i[3-6]68
# define PRI_time_t	"ld"	// for time_t
# define PRI_nsec_t	"ld"	// for tv_nsec in struct timespec
#endif
----  snip  ----
in my userspace code for printf() and friends - I don't know how libc's
react to such a patch (and I don't care for the name of the macros as
long it's obviously clear for which type they are).
I assume/fear we won't get additional modifiers into the relevant
standards for libc types (as they are far more like pid_t, uid_t etc.).
And casting to u/intmaxptr_t to get a defined printf()-modifier doesn't
look appealing to me to "solve" such issues.

MfG,
	Bernd
--=20
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds

--------------544822C287D28255C7136853
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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3D=3D
=3Dv2Yn
-----END PGP PUBLIC KEY BLOCK-----

--------------544822C287D28255C7136853--
