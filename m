From: =?UTF-8?Q?Thomas_Sch=c3=b6bel-Theuer?= <thomas@schoebel-theuer.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 22:41:20 +0100
Message-ID: <35905587-2d7b-c0ab-e081-2b938d60e881@schoebel-theuer.de>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
 <CALCETrV0fVLZKG6JrOvzvOzP06UxhZW=LbHpPXbonoeFdPJB1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrV0fVLZKG6JrOvzvOzP06UxhZW=LbHpPXbonoeFdPJB1A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 12/14/18 22:24, Andy Lutomirski wrote:
> I should clarify again: I am not suggesting that we drop 32-bit
> support in the forseeable future.  (Well, I might eventually suggest
> that we drop support for 32-bit *hardware* at some point, but not for
> 32-bit compat software.)  Linux's compat code is quite robust and is
> even fairly maintainable.
>
> I'm talking about x32, which is a different beast.
>
OK, this does not really make a big difference for large-scale 
enterprise users. Some day in the very distant future any legacy system 
will disappear, eventually.

So from my viewpoint the mentioned roadmap / timing requirements will 
remain the same, whatever you are dropping.

Enterprise-critical use cases will probably need to be migrated to 
KVM/qemu together with their old kernel versions, anyway (because the 
original hardware will be no longer available in a few decades).
