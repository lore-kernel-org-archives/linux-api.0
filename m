From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Fri, 03 Apr 2009 10:35:36 +0200
Message-ID: <49D5CA58.20908@redhat.com>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org> <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain>
Sender: linux-arch-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, arnd@arndb.de, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, ralf@linux-mips.org, tglx@linutronix.de, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 2 Apr 2009, akpm@linux-foundation.org wrote:
>> glibc entriely and use a syscall prototype which works without
>> arch-specific wrappers inside the kernel: The offset argument is
>> explicitly split into two 32bit values.
> 
> Grr. That may make sense on 32-bit architectures, but makes no sense 
> what-so-ever on 64-bit ones.
> 
> Why not just say that it's two "unsigned long" arguments, and split it by 
> "sizeof unsigned long". And then, on 64-bit architectures, the high bits 
> can be ignored. You can even get gcc to optimize it all away by doing 
> something like
> 
> 	#define HALF_LONG (BITS_IN_LONG / 2)
> 
> 	offset = (((loff_t)high << HALF_LONG) << HALF_LONG) | low;
> 
> and then gcc should automaticaly notice that shifting up that way is just 
> a fancy way of saying "0", and ignore the high bits.
> 
> How married are people to this crazy 2x "32 bits" model?

The tricky corner case are 32bit compat syscalls on 64bit kernel, where
a noticable number of archs (IIRC at least ppc, mips and s390) can't
pass unaligned 64bit values through the syscall abi.  The 32/32 split
was done because of that.

I think using two unsigned longs instead of two u32 should work.  And
allows us to handle 128bit file offsets on 64bit.  That I'll call
future-proof interface!  Nevertheless I'd like to have comments from the
arch maintainers on the idea.

cheers,
  Gerd
