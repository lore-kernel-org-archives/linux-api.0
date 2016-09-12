From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: Build failures in -next: sys_pkey_mprotect etc. undefined
Date: Mon, 12 Sep 2016 16:59:30 +0200
Message-ID: <9369809.1DWhqOZ7mo@wuerfel>
References: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9d74497b-1522-b350-42fa-49df2df48c4a-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Monday, September 12, 2016 7:55:33 AM CEST Guenter Roeck wrote:
> Building h8300:allnoconfig ... failed
> Building h8300:h8300h-sim_defconfig ... failed
> Building c6x:dsk6455_defconfig ... failed
> 
> [ and more builds for the same architectures ]
> 
> --------------
> Error log:
> arch/h8300/kernel/built-in.o:(.data+0x480): undefined reference to `sys_pkey_mprotect'
> arch/h8300/kernel/built-in.o:(.data+0x484): undefined reference to `sys_pkey_alloc'
> arch/h8300/kernel/built-in.o:(.data+0x488): undefined reference to `sys_pkey_free'
> 
> Other architectures (frv, xtensa, score) currently fail to build for other reasons,
> so I don't really know if the above are the only ones affected.
> 
> 

I think the best solution would be to add them to kernel/sys_ni.c so we can
assign syscall numbers for all architectures regardless of whether they use it
or not (most of them will never use these AFAICT).

	Arnd
