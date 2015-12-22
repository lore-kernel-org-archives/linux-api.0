From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Tue, 22 Dec 2015 22:56:20 +0100
Message-ID: <201512222256.20580.arnd@arndb.de>
References: <20140509191914.GA7286@jtriplet-mobl1> <4845518.edhUzAktsU@wuerfel> <CA+iXiiN8xFaiz6DwyLfWRFZ81pJZf=Fv1E60VZC-iSNPswaGEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+iXiiN8xFaiz6DwyLfWRFZ81pJZf=Fv1E60VZC-iSNPswaGEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Santosh Shukla <santosh.shukla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 22 December 2015, Santosh Shukla wrote:
> }
> 
> So I care for /dev/ioport types interface who could do more than byte
> data copy to/from user-space. I tested this patch with little
> modification and could able to run pmd driver for arm/arm64 case.
> 
> Like to know how to address pci_io region mapping problem for
> arm/arm64, in-case /dev/ioports approach is not acceptable or else I
> can spent time on restructuring the patch?
> 

For the use case you describe, can't you use the vfio framework to
access the PCI BARs?

After all, you are talking about regular PCI devices, not access to
random unknown I/O port numbers.

	Arnd
