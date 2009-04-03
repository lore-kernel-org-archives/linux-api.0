From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Fri, 03 Apr 2009 09:57:49 -0700
Message-ID: <49D6400D.7040001@zytor.com>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org> <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0904021839390.15441-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds wrote:
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
> 

I certainly am *not* happy with it, and said so when it was first
posted.  My main complaint with it is that it introduces yet another
special case in the kernel<->userspace ABI, because although we've had
this problem before, it has been hacked around a different way every time.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
