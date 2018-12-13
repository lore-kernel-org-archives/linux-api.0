From: Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Thu, 13 Dec 2018 16:11:39 +0000
Message-ID: <1bcacee85afc8e4864be6c9a4a7fcc52511b41bd.camel@linuxfoundation.org>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
         <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, bp@alien8.de, fweimer@redhat.com, vapier@gentoo.org, hjl.tools@gmail.com, dalias@libc.org, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2018-12-10 at 17:40 -0800, Linus Torvalds wrote:
> On Mon, Dec 10, 2018 at 5:23 PM Andy Lutomirski <luto@kernel.org>
> wrote:
> > I'm seriously considering sending a patch to remove x32 support
> > from
> > upstream Linux.  Here are some problems with it:
> 
> I talked to Arnd (I think - we were talking about all the crazy
> ABI's,
> but maybe it was with somebody else) about exactly this in Edinburgh.
> 
> Apparently the main real use case is for extreme benchmarking. It's
> the only use-case where the complexity of maintaining a whole
> development environment and distro is worth it, it seems. Apparently
> a
> number of Spec submissions have been done with the x32 model.
> 
> I'm not opposed to trying to sunset the support, but let's see who
> complains..

FWIW, the Yocto Project has working x32 support which it regularly
builds, tests and has as a supported configuration. We did help
identify and fix many of the places userspace didn't support it.

As with open source in general, its hard to know how many people are
actually using it. I don't think there are huge numbers but we do
occasionally get bug reports.

Cheers,

Richard
