From: Marian Marinov <mm@1h.com>
Subject: Re: Pondering per-process vsyscall disablement
Date: Fri, 23 May 2014 05:44:30 +0300
Message-ID: <537EB60E.40204@1h.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/23/2014 02:04 AM, Andy Lutomirski wrote:
> It would be nice to have a way for new programs to declare that they don't need vsyscalls.  What's the right way to
> do this?  An ELF header entry in the loader?  An ELF header entry in the program?  A new arch_prctl?
> 
> As background, there's an old part of the x86_64 ABI that allows programs to do gettimeofday, clock_gettime, and
> getcpu by calling to fixed addresses of the form 0xffffffffff600n00 where n indicates which of those three syscalls
> is being invoked.  This is a security issue.
> 
> Since Linux 3.1, vsyscalls are emulated using NX and page faults.  As a result, vsyscalls no longer offer any
> performance advantage over normal syscalls; in fact, they're much slower.  As far as I know, nothing newer than
> 2012 will attempt to use vsyscalls if a vdso is present.  (Sadly, a lot of things will still fall back to the
> vsyscall page if there is no vdso, but that shouldn't matter, since there is always a vdso.)
> 
> Despite the emulation, they could still be used as a weird form of ROP gadget that lives at a fixed address.  I'd
> like to offer a way for new runtimes to indicate that they don't use vsyscalls so that the kernel can selectively
> disable emulation and remove the fixed-address executable code issue.
> 
> 
Wouldn't it be more useful if the check is against a bitmask added as extended attribute for that executable?
This way the administrators and will have the flexibility to simply add the new attribute to the executable.

Marian

> --Andy -- To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html Please read the FAQ at
> http://www.tux.org/lkml/
> 


- -- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlN+tg4ACgkQ4mt9JeIbjJRGkgCgjnD2s+J9kIr5oEDeL3VKHNvX
X4cAn17zC0aPKyTCVekmqZRlVukqLWyC
=vrfk
-----END PGP SIGNATURE-----
