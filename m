From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Tue, 29 Dec 2015 17:20:08 +0100
Message-ID: <1961979.Xhiud0jvNd@wuerfel>
References: <20140509191914.GA7286@jtriplet-mobl1> <CA+iXiiNKiMz=9BJgu3g=LggXjTv61Uwu+ibNfKeih3rK328LSQ@mail.gmail.com> <CA+iXiiM+TrciHROfgTcN01mfGEYuUCvpNRU0Qqgrt56VdCcR8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+iXiiM+TrciHROfgTcN01mfGEYuUCvpNRU0Qqgrt56VdCcR8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Santosh Shukla <santosh.shukla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuanhan.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Santosh Shukla <sshukla-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tuesday 29 December 2015 21:25:15 Santosh Shukla wrote:
> mistakenly added wrong email-id of alex, looping his correct one.
> 
> On 29 December 2015 at 21:23, Santosh Shukla <santosh.shukla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > On 29 December 2015 at 18:58, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> >> On Wednesday 23 December 2015 17:04:40 Santosh Shukla wrote:
> >>> On 23 December 2015 at 03:26, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> >>> > On Tuesday 22 December 2015, Santosh Shukla wrote:
> >>> >> }
> >>> >>
> >>> >> So I care for /dev/ioport types interface who could do more than byte
> >>> >> data copy to/from user-space. I tested this patch with little
> >>> >> modification and could able to run pmd driver for arm/arm64 case.
> >>> >>
> >>> >> Like to know how to address pci_io region mapping problem for
> >>> >> arm/arm64, in-case /dev/ioports approach is not acceptable or else I
> >>> >> can spent time on restructuring the patch?
> >>> >>
> >>> >
> >>> > For the use case you describe, can't you use the vfio framework to
> >>> > access the PCI BARs?
> >>> >
> >>>
> >>> I looked at file: drivers/vfio/pci/vfio_pci.c, func vfio_pci_map() and
> >>> it look to me that it only maps ioresource_mem pci region, pasting
> >>> code snap:
> >>>
> >>> if (!(pci_resource_flags(pdev, index) & IORESOURCE_MEM))
> >>> return -EINVAL;
> >>> ....
> >>>
> >>> and I want to map ioresource_io pci region for arm platform in my
> >>> use-case. Not sure vfio maps pci_iobar region?
> >>
> >> Mapping I/O BARs is not portable, notably it doesn't work on x86.
> >>
> >> You should be able access them using the read/write interface on
> >> the vfio device.
> >>
> > Right, x86 doesn't care as iopl() could give userspace application
> > direct access to ioports.
> >
> > Also, Alex in other dpdk thread [1] suggested someone to propose io
> > bar mapping in vfio-pci, I guess in particular to non-x86 arch so I
> > started working on it.
> >
> 

So what's wrong with just using the existing read/write API on all
architectures?

	Arnd
