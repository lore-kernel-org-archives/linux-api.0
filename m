From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Fri, 09 May 2014 13:54:05 -0700
Message-ID: <536D406D.2080508@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <9233735.5FfZoZovqP@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9233735.5FfZoZovqP@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/09/2014 12:58 PM, Arnd Bergmann wrote:
> On Friday 09 May 2014 12:19:16 Josh Triplett wrote:
> 
>> +	if (!access_ok(VERIFY_WRITE, buf, count))
>> +		return -EFAULT;
>> +	if (port > 65535)
>> +		return 0;
> 
> This should probably test against IO_SPACE_LIMIT, which may be zero,
> something larger than 65536 or even ULONG_MAX, depending on the
> architecture.
> 
> In cases where this IO_SPACE_LIMIT is zero or ULONG_MAX, we should
> probably disallow access completely. The former case is for architectures
> that don't have any I/O ports, the other is either a mistake, or is
> used when inb is defined as readb, and the port numbers are just virtual
> addresses.
> 

PCI supports a 32-bit I/O address space, so if the architecture permits
it, having a 32-bit I/O space is perfectly legitimate.

It is worth noting that /dev/port has the same problem.

However, if we're going to have these devices I'm wondering if having
/dev/portw and /dev/portl (or something like that) might not make sense,
rather than requiring a system call per transaction.

Also, x86 supports unaligned I/O port references, but not all
architectures do.  On the other hand, x86 also supports ioperm().

	-hpa
