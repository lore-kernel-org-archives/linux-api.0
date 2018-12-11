From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 23:40:35 +0000 (GMT)
Message-ID: <alpine.LFD.2.21.1812112337270.11202@eddie.linux-mips.org>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com> <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com> <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Received: (from localhost user: 'macro', uid#1010) by eddie.linux-mips.org
        with ESMTP id S23992828AbeLKXkfQ0bYt (ORCPT
        <rfc822;linux-api@vger.kernel.org> + 1 other);
        Wed, 12 Dec 2018 00:40:35 +0100
In-Reply-To: <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thorsten Glaser <tg@mirbsd.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, bp@alien8.de, fweimer@redhat.com, vapier@gentoo.org, hjl.tools@gmail.com, dalias@libc.org, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, 11 Dec 2018, Thorsten Glaser wrote:

> Furthermore, x32 was the first of the many *64ilp32
> architectures; I know I’ve seen amd64ilp32 and at least
> one other I don’t recall.

 Maybe you mean n32 MIPS, complete kernel+userland support for which has 
been available in Linux from 2001?

  Maciej
