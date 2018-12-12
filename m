From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 12 Dec 2018 18:14:00 +0000
Message-ID: <alpine.DEB.2.21.1812121811080.21643@digraph.polyomino.org.uk>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com> <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com> <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org> <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org> <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com> <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org> <CAK8P3a3yurujkdic98H02j0YfctSBf9NeXQreLZVhTzsttoc9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3yurujkdic98H02j0YfctSBf9NeXQreLZVhTzsttoc9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: tg@mirbsd.de, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, vapier@gentoo.org, "H.J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Wed, 12 Dec 2018, Arnd Bergmann wrote:

> > MIPS had o32, n32, n64 since like forever.
> 
> o32 and n32 are practically the same, the only difference on the
> syscall ABI that I can see are the actual syscall numbers, and
> the 'struct sigcontext' definition.

And for syscalls that have 64-bit arguments, n32 generally passes those in 
a single register (like n64), not pairs of registers (like o32).  But, 
yes, userspace structure layout for n32 is generally much closer to o32 
than to n64.

-- 
Joseph S. Myers
joseph@codesourcery.com
