From: Santosh Shukla <santosh.shukla@linaro.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Wed, 23 Dec 2015 17:04:40 +0530
Message-ID: <CA+iXiiOsbC0MBaRwc5JgaTVRpdxHub5t2T=LrGaVN1AjKpiJgA@mail.gmail.com>
References: <20140509191914.GA7286@jtriplet-mobl1>
	<4845518.edhUzAktsU@wuerfel>
	<CA+iXiiN8xFaiz6DwyLfWRFZ81pJZf=Fv1E60VZC-iSNPswaGEQ@mail.gmail.com>
	<201512222256.20580.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201512222256.20580.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, josh@joshtriplett.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, yuanhan.liu@linux.intel.com
List-Id: linux-api@vger.kernel.org

On 23 December 2015 at 03:26, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 22 December 2015, Santosh Shukla wrote:
>> }
>>
>> So I care for /dev/ioport types interface who could do more than byte
>> data copy to/from user-space. I tested this patch with little
>> modification and could able to run pmd driver for arm/arm64 case.
>>
>> Like to know how to address pci_io region mapping problem for
>> arm/arm64, in-case /dev/ioports approach is not acceptable or else I
>> can spent time on restructuring the patch?
>>
>
> For the use case you describe, can't you use the vfio framework to
> access the PCI BARs?
>

I looked at file: drivers/vfio/pci/vfio_pci.c, func vfio_pci_map() and
it look to me that it only maps ioresource_mem pci region, pasting
code snap:

if (!(pci_resource_flags(pdev, index) & IORESOURCE_MEM))
return -EINVAL;
....

and I want to map ioresource_io pci region for arm platform in my
use-case. Not sure vfio maps pci_iobar region?

> After all, you are talking about regular PCI devices, not access to
> random unknown I/O port numbers.
>
Yes, pci_iobar region.

>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
