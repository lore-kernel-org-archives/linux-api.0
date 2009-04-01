From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Wed, 1 Apr 2009 17:04:12 +0200
Message-ID: <200904011704.13581.arnd@arndb.de>
References: <49D071A8.4010703@petalogix.com> <200904011611.53355.arnd@arndb.de> <87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932496AbZDAPEx@vger.kernel.org>
In-Reply-To: <87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Will Newton <will.newton@gmail.com>
Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>, michal.simek@petalogix.com, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
List-Id: linux-api@vger.kernel.org

On Wednesday 01 April 2009, Will Newton wrote:
> > + * There seems to be no way of detecting this automatically from user
> > + * space, so 64 bit architectures should override this in their types.h.
> > + */
> > +#ifndef __BITS_PER_LONG
> > +#define __BITS_PER_LONG 32
> > +#endif
> 
> Why is this define required? It doesn't seem to be in any existing headers.

Unfortunately, there is no generic way to detect the word size yet,
but every architecture uses its own preprocessor macro (__x86_64__,
__s390x__, __ppc64__). We also can't use CONFIG_64BIT in an user-exported
interface header file, because the use space can also be compiled for
32 bits when the kernel uses 64 bits.

__BITS_PER_LONG is actually defined in parisc now, and was the result
of the last time we had this discussion. I'm still thinking about
making a separate <asm/bitsperlong.h> header, or a <asm/bits.h> that
also contains the respective __BIG_ENDIAN/__LITTLE_ENDIAN macros
which have the same problem. The advantage would be that other header
files (e.g. unistd.h) can known the word size without getting the
whole types.h name space.

	Arnd <><
