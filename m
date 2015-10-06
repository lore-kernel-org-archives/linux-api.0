From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/3] mce: change asm/ioctls.h for linux/ioctl.h
Date: Tue, 06 Oct 2015 14:41:09 +0200
Message-ID: <6517027.uJ4tlVnjPB@wuerfel>
References: <1444056611-7513-1-git-send-email-gabriel@lse.epita.fr> <1444056611-7513-2-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444056611-7513-2-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday 05 October 2015 16:50:09 Gabriel Laskar wrote:
> Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
> ---
> 
> asm/ioctls.h contains definition for termios, not just the _IO* macros
> 
> 

The patch looks reasonable, but the description you have below the ---
should be the actual changelog that is missing.

Also, please show how you found this, did it trigger some checking tool,
or did you find it through manual inspection?

With that fixed,

Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
