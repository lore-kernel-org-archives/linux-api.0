From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Sat, 4 Apr 2009 10:51:37 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904041045030.3915@localhost.localdomain>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org> <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain> <49D5CA58.20908@redhat.com> <alpine.LFD.2.00.0904030739540.4130@localhost.localdomain>
 <20090404103830.56f66e13.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20090404103830.56f66e13.akpm@linux-foundation.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, arnd@arndb.de, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, ralf@linux-mips.org, tglx@linutronix.de, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org



On Sat, 4 Apr 2009, Andrew Morton wrote:
> 
> Does C promote the `unsigned long high' beforehand, or will the
> intermediate expression overflow?

Thanks, good catch. Will fix. Needs the cast - I'm sure I had it at one 
point, but it got lost..

[ looks around ]

Heh. I had the cast in my original email that wasn't a patch:

        #define HALF_LONG (BITS_IN_LONG / 2)

	offset = (((loff_t)high << HALF_LONG) << HALF_LONG) | low;

but then when I actually turned it into a patch, I had lost it:

	+#define HALF_LONG_BITS (BITS_PER_LONG / 2)
	+       return ((high << HALF_LONG_BITS) << HALF_LONG_BITS) | low;

(but at least I had fixed the "BITS_IN_LONG" to "BITS_PER_LONG").

> I think it's wrong on 32-bit?
> 
> Also, HALF_LONG_BITS is 32 on 64-bit, so "high" gets shifted to zero. 
> It's unclear whether this was deliberate, but either way, it's a sneaky
> trick and deserves a code comment!

It was very much deliberate - the high bits disappear, since we don't have 
128-bit loff_t.

And it's not a sneaky trick, it's totally standard programming. We have 
the same thing in a few other places:

	drivers/net/starfire.c: writel( (np->queue_mem_dma >> 16) >> 16, ioaddr + RxDescQHiAddr);

Notice the ">> 16) >> 16" thing? That's a way to write ">> 32" without 
having the undefined overflow in 32 bits - if we have just a 32-bit dma 
address type, it just turns into "high bits are 0".

		Linus
