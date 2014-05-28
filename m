From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Wed, 28 May 2014 14:41:52 -0700
Message-ID: <53865820.7010309@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <53729873.2030805@zytor.com> <20140515215646.GA16326@cloud> <63645237.lSKEVJUKkQ@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <63645237.lSKEVJUKkQ@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/19/2014 05:36 AM, Arnd Bergmann wrote:
> 
> My feeling is that all devices we can think of fall into at least one
> of these categories:
> 
> * legacy PC stuff that needs only byte access
> * PCI devices that can be accessed through sysfs
> * devices on x86 that can be accessed using iopl
> 

I don't believe PCI I/O space devices can be accessed through sysfs, but
perhaps I'm wrong?  (mmapping I/O space is not portable.)


	-hpa
