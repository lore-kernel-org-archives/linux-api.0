From: Santosh Shukla <santosh.shukla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Tue, 22 Dec 2015 16:22:29 +0530
Message-ID: <CA+iXiiN8xFaiz6DwyLfWRFZ81pJZf=Fv1E60VZC-iSNPswaGEQ@mail.gmail.com>
References: <20140509191914.GA7286@jtriplet-mobl1>
	<16228376.RHijyT1ZPk@wuerfel>
	<5387385B.1030203@zytor.com>
	<4845518.edhUzAktsU@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4845518.edhUzAktsU@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 30 May 2014 at 17:02, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> On Thursday 29 May 2014 06:38:35 H. Peter Anvin wrote:
>> On 05/29/2014 02:26 AM, Arnd Bergmann wrote:
>> > On Wednesday 28 May 2014 14:41:52 H. Peter Anvin wrote:
>> >> On 05/19/2014 05:36 AM, Arnd Bergmann wrote:
>> >>>
>> >>> My feeling is that all devices we can think of fall into at least one
>> >>> of these categories:
>> >>>
>> >>> * legacy PC stuff that needs only byte access
>> >>> * PCI devices that can be accessed through sysfs
>> >>> * devices on x86 that can be accessed using iopl
>> >>>
>> >>
>> >> I don't believe PCI I/O space devices can be accessed through sysfs, but
>> >> perhaps I'm wrong?  (mmapping I/O space is not portable.)
>> >
>> > The interface is there, both a read/write and mmap on the resource
>> > bin_attribute. But it seems you're right, neither of them is implemented
>> > on all architectures.
>> >
>> > Only powerpc, microblaze, alpha, sparc and xtensa allow users to mmap
>> > I/O space, even though a lot of others could. The read-write interface
>> > is only defined for alpha, ia64, microblaze and powerpc.
>> >
>>
>> And how is that read/write interface defined?  Does it have the same
>> silly handling of data sizes?
>
> In architecture specific code, e.g. for powerpc:
>
> int pci_legacy_read(struct pci_bus *bus, loff_t port, u32 *val, size_t size)
> {
>         unsigned long offset;
>         struct pci_controller *hose = pci_bus_to_host(bus);
>         struct resource *rp = &hose->io_resource;
>         void __iomem *addr;
>
>         /* Check if port can be supported by that bus. We only check
>          * the ranges of the PHB though, not the bus itself as the rules
>          * for forwarding legacy cycles down bridges are not our problem
>          * here. So if the host bridge supports it, we do it.
>          */
>         offset = (unsigned long)hose->io_base_virt - _IO_BASE;
>         offset += port;
>
>         if (!(rp->flags & IORESOURCE_IO))
>                 return -ENXIO;
>         if (offset < rp->start || (offset + size) > rp->end)
>                 return -ENXIO;
>         addr = hose->io_base_virt + port;
>
>         switch(size) {
>         case 1:
>                 *((u8 *)val) = in_8(addr);
>                 return 1;
>         case 2:
>                 if (port & 1)
>                         return -EINVAL;
>                 *((u16 *)val) = in_le16(addr);
>                 return 2;
>         case 4:
>                 if (port & 3)
>                         return -EINVAL;
>                 *((u32 *)val) = in_le32(addr);
>                 return 4;
>         }
>         return -EINVAL;
> }
>
> The common code already enforces size to be 1, 2 or 4.
>

I have an use-case for arm/arm64 both where user-space application
access pci_io address in user-space. The use-case description: dpdk's
virtio-pmd user-space driver running inside the VM/Guest. That
virtio-pmd driver maps pci_io region to guest user-space and does pmd
driver initialization. In x86 case, pmd driver uses iopl() so to
access ioport via port api's {in, out},[b,w,l]. The problem is for
platform like arm, where kernel does not map pci_io space

file : arch/arm/kernel/bios32.c
int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
enum pci_mmap_state mmap_state, int write_combine)
{
if (mmap_state == pci_mmap_io)
return -EINVAL;
.....
}

So I care for /dev/ioport types interface who could do more than byte
data copy to/from user-space. I tested this patch with little
modification and could able to run pmd driver for arm/arm64 case.

Like to know how to address pci_io region mapping problem for
arm/arm64, in-case /dev/ioports approach is not acceptable or else I
can spent time on restructuring the patch?

Use-case details [1].

Thanks in advance.

[1] http://dpdk.org/ml/archives/dev/2015-December/030530.html
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
