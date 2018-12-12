From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 12 Dec 2018 10:04:53 +0100
Message-ID: <CAK8P3a3yurujkdic98H02j0YfctSBf9NeXQreLZVhTzsttoc9g@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
 <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org> <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org> <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
 <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tg@mirbsd.de
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, vapier@gentoo.org, "H.J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 12, 2018 at 3:38 AM Thorsten Glaser <tg@mirbsd.de> wrote:
>
> Andy Lutomirski dixit:
>
> >That’s the thing, though: the whole generic kernel compat
> >infrastructure assumes there are at most two ABIs: native and, if
> >enabled and relevant, compat. x32 breaks this entirely.
>
> MIPS had o32, n32, n64 since like forever.

o32 and n32 are practically the same, the only difference on the
syscall ABI that I can see are the actual syscall numbers, and
the 'struct sigcontext' definition.

> ARM has old ABI, EABI and now 64-bit.

arm64 intentionally did not attempt to support OABI user space
because of this, and as I said the ilp32 ABI follows what MIPS
n32 does using the same data structures as aarch32 (corresponding
to mips o32).

> >How hard would it be to have __attribute__((ilp64)), with an optional
> >warning if any embedded structs are not ilp64?  This plus a wrapper to
>
> You mean LP64. Impossible, because LP64 vs. ILP32 is not the only
> difference between amd64 and x32.

I think the above is what Intel's compiler does, and similar to what they
do for mixing big-endian and little-endian code (!). Generally possible yes,
but a lot of work, as well as error-prone and not particular appealing for
the GNU toolchain IMHO.

        Arnd
