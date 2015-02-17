From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 34/45] include/uapi/asm-generic/signal.h: hide sigset_t definition in userspace
Date: Tue, 17 Feb 2015 10:16:09 +0100
Message-ID: <2741317.tcRFXAy9C6@wuerfel>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-35-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-35-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 17 February 2015 00:05:37 Mikko Rapeli wrote:
> +#ifdef __KERNEL__
> +/* already defined in userspace via stdlib.h */
>  typedef struct {
>         unsigned long sig[_NSIG_WORDS];
>  } sigset_t;
> +#endif /* __KERNEL__ */

I'm not sure here: Is this structure always identical to the one
we see in user space?

If not, we might want to rename the typedef to __kernel_sigset_t
instead and use that inside of the uapi headers.

	Arnd
