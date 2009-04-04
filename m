From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Sat, 4 Apr 2009 10:38:30 -0700
Message-ID: <20090404103830.56f66e13.akpm@linux-foundation.org>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org>
	<alpine.LFD.2.00.0904021839390.15441@localhost.localdomain>
	<49D5CA58.20908@redhat.com>
	<alpine.LFD.2.00.0904030739540.4130@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904030739540.4130@localhost.localdomain>
Sender: linux-arch-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, arnd@arndb.de, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, ralf@linux-mips.org, tglx@linutronix.de, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, 3 Apr 2009 08:03:22 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> +static inline loff_t pos_from_hilo(unsigned long high, unsigned long low)
> +{
> +#define HALF_LONG_BITS (BITS_PER_LONG / 2)
> +	return ((high << HALF_LONG_BITS) << HALF_LONG_BITS) | low;
> +}

Does C promote the `unsigned long high' beforehand, or will the
intermediate expression overflow?

<does it the old-fashioned way>

y:/home/akpm> cat t.c

#define HALF_LONG_BITS 16

main()
{
        unsigned hi = 0x43;
        unsigned lo = 0x42;
        unsigned long long res;
	
        res = ((hi << 16) << 16) | lo;
        printf("%llx\n", res);
}
y:/home/akpm> gcc -O t.c
y:/home/akpm> ./a.out
42

I think it's wrong on 32-bit?

Also, HALF_LONG_BITS is 32 on 64-bit, so "high" gets shifted to zero. 
It's unclear whether this was deliberate, but either way, it's a sneaky
trick and deserves a code comment!
