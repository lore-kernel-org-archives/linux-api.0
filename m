From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Thu, 29 May 2014 06:38:35 -0700
Message-ID: <5387385B.1030203@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <63645237.lSKEVJUKkQ@wuerfel> <53865820.7010309@zytor.com> <16228376.RHijyT1ZPk@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <16228376.RHijyT1ZPk@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/29/2014 02:26 AM, Arnd Bergmann wrote:
> On Wednesday 28 May 2014 14:41:52 H. Peter Anvin wrote:
>> On 05/19/2014 05:36 AM, Arnd Bergmann wrote:
>>>
>>> My feeling is that all devices we can think of fall into at least one
>>> of these categories:
>>>
>>> * legacy PC stuff that needs only byte access
>>> * PCI devices that can be accessed through sysfs
>>> * devices on x86 that can be accessed using iopl
>>>
>>
>> I don't believe PCI I/O space devices can be accessed through sysfs, but
>> perhaps I'm wrong?  (mmapping I/O space is not portable.)
> 
> The interface is there, both a read/write and mmap on the resource
> bin_attribute. But it seems you're right, neither of them is implemented
> on all architectures.
> 
> Only powerpc, microblaze, alpha, sparc and xtensa allow users to mmap
> I/O space, even though a lot of others could. The read-write interface
> is only defined for alpha, ia64, microblaze and powerpc.
> 

And how is that read/write interface defined?  Does it have the same
silly handling of data sizes?

	-hpa
