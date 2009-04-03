From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Thu, 2 Apr 2009 18:43:08 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200904022359.n32NxNYu022834-AB4EexQrvXRQetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On Thu, 2 Apr 2009, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
>
> glibc entriely and use a syscall prototype which works without
> arch-specific wrappers inside the kernel: The offset argument is
> explicitly split into two 32bit values.

Grr. That may make sense on 32-bit architectures, but makes no sense 
what-so-ever on 64-bit ones.

Why not just say that it's two "unsigned long" arguments, and split it by 
"sizeof unsigned long". And then, on 64-bit architectures, the high bits 
can be ignored. You can even get gcc to optimize it all away by doing 
something like

	#define HALF_LONG (BITS_IN_LONG / 2)

	offset = (((loff_t)high << HALF_LONG) << HALF_LONG) | low;

and then gcc should automaticaly notice that shifting up that way is just 
a fancy way of saying "0", and ignore the high bits.

How married are people to this crazy 2x "32 bits" model?

			Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
