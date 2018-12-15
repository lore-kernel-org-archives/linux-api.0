From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Sat, 15 Dec 2018 08:41:30 +0100
Message-ID: <54449048-a057-5005-1b50-b884628643eb@schoebel-theuer.de>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
 <CALCETrV0fVLZKG6JrOvzvOzP06UxhZW=LbHpPXbonoeFdPJB1A@mail.gmail.com>
 <35905587-2d7b-c0ab-e081-2b938d60e881@schoebel-theuer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <35905587-2d7b-c0ab-e081-2b938d60e881@schoebel-theuer.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 12/14/18 22:41, Thomas Schöbel-Theuer wrote:
> On 12/14/18 22:24, Andy Lutomirski wrote:
>>
>> I'm talking about x32, which is a different beast.
>>
>
> So from my viewpoint the mentioned roadmap / timing requirements will 
> remain the same, whatever you are dropping.
>
> Enterprise-critical use cases will probably need to be migrated to 
> KVM/qemu together with their old kernel versions, anyway (because the 
> original hardware will be no longer available in a few decades).
>

Here is a systematic approach to the problem.


AFAICS legacy 32bit userspace code (which exists in some notable masses) 
can be executed at least in the following ways:


1) natively on 32bit-capable hardware, under 32bit kernels. Besides 
legacy hardware, this also encompasses most current Intel / AMD 64bit 
hardware in 32bit compatibility mode.

2) under 64bit kernels, using the 32bit compat layer from practically 
any kernel version.

3) under KVM/qemu.


When you just drop 1), users have a fair chance by migrating to any of 
the other two possibilities.

As explained, a time frame of ~5 years should work for the vast majority.

If you clearly explain the migration paths to your users (and to the 
press), I think it will be acceptable.


[side note: I know of a single legacy instance which is now ~20 years 
old, but makes a revenue of several millions per month. These guys have 
large quantities of legacy hardware in stock. And they have enough money 
to hire a downstream maintainer in case of emergency.]


Fatal problems would only arise if you would drop all three 
possibilities in the very long term.


In ~100 years, possibility 3) should be sufficient for handling use 
cases like preservation of historic documents. The latter is roughly 
equivalent to running binary-only MSDOS, Windows NT, and similar, even 
in 100 years, and even non-natively under future hardware architectures.
