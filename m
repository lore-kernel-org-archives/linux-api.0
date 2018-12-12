From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 12 Dec 2018 11:12:31 -0800
Message-ID: <CALCETrUzyEENFc8rgDnbx9U-tALR4sjKsORjAwTY5ko1zzAVsQ@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
 <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org> <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org> <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
 <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org> <CAK8P3a3yurujkdic98H02j0YfctSBf9NeXQreLZVhTzsttoc9g@mail.gmail.com>
 <alpine.DEB.2.21.1812121811080.21643@digraph.polyomino.org.uk> <CAAaskFA5cssU+fGAOUJO4u5XYBP6XYtSeWRhaSAr3BqOBTYjmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAaskFA5cssU+fGAOUJO4u5XYBP6XYtSeWRhaSAr3BqOBTYjmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: qmastery16@gmail.com
Cc: "Joseph S. Myers" <joseph@codesourcery.com>, Arnd Bergmann <arnd@arndb.de>, tg@mirbsd.de, Andrew Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 12, 2018 at 10:50 AM Ivan Ivanov <qmastery16@gmail.com> wrote:
>
> Please don't drop x86 support from the Linux kernel ! You may not
> realize it, but there are plenty of people who care about x86 systems.
> I have a good old Pentium 4 based computer which is 32-bit, using it
> for some weird Linux experiments + retro gaming, and if I can't run
> new Linux kernels there - it would be SAD

Just to clarify: no one is proposing to drop 32-bit hardware support
or normal x86 compatibility support from new kernels.

That being said, you should seriously consider replacing that P4.
Unless you live somewhere with *very* cheap power or you barely use
it, replacing it will pay for itself quite quickly.
