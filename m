From: Santosh Shukla <sshukla@mvista.com>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Thu, 7 Jan 2016 15:01:30 +0530
Message-ID: <CAAyOgsaYkEyCKoYREWNsCF34jSwvLuPBiutj=r0DEif0Avm3ng@mail.gmail.com>
References: <20140509191914.GA7286@jtriplet-mobl1>
	<CA+iXiiNKiMz=9BJgu3g=LggXjTv61Uwu+ibNfKeih3rK328LSQ@mail.gmail.com>
	<CA+iXiiM+TrciHROfgTcN01mfGEYuUCvpNRU0Qqgrt56VdCcR8Q@mail.gmail.com>
	<1961979.Xhiud0jvNd@wuerfel>
	<CAAyOgsYuMWudLgbSNM+QAkSXpU_fp6Ue01r=Ufmf5MXUHMs4UQ@mail.gmail.com>
	<1451410269.18084.15.camel@redhat.com>
	<CAAyOgsaxEaQ5+BW6Rwmz4cEuzVUdswZAWyF0OrbdPpXduwESYg@mail.gmail.com>
	<1451576518.3223.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451576518.3223.9.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Santosh Shukla <santosh.shukla@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, josh@joshtriplett.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 31, 2015 at 9:11 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Thu, 2015-12-31 at 15:03 +0530, Santosh Shukla wrote:
>> On Tue, Dec 29, 2015 at 11:01 PM, Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>> > On Tue, 2015-12-29 at 22:00 +0530, Santosh Shukla wrote:
>> > > On Tue, Dec 29, 2015 at 9:50 PM, Arnd Bergmann <arnd@arndb.de>
>> > > wrote:
>> > > > On Tuesday 29 December 2015 21:25:15 Santosh Shukla wrote:
>> > > > > mistakenly added wrong email-id of alex, looping his correct
>> > > > > one.
>> > > > >
>> > > > > On 29 December 2015 at 21:23, Santosh Shukla <santosh.shukla@
>> > > > > lina
>> > > > > ro.org> wrote:
>> > > > > > On 29 December 2015 at 18:58, Arnd Bergmann <arnd@arndb.de>
>> > > > > > wrote:
>> > > > > > > On Wednesday 23 December 2015 17:04:40 Santosh Shukla
>> > > > > > > wrote:
>> > > > > > > > On 23 December 2015 at 03:26, Arnd Bergmann <arnd@arndb
>> > > > > > > > .de>
>> > > > > > > > wrote:
>> > > > > > > > > On Tuesday 22 December 2015, Santosh Shukla wrote:
>> > > > > > > > > > }
>> > > > > > > > > >
>> > > > > > > > > > So I care for /dev/ioport types interface who could
>> > > > > > > > > > do
>> > > > > > > > > > more than byte
>> > > > > > > > > > data copy to/from user-space. I tested this patch
>> > > > > > > > > > with
>> > > > > > > > > > little
>> > > > > > > > > > modification and could able to run pmd driver for
>> > > > > > > > > > arm/arm64 case.
>> > > > > > > > > >
>> > > > > > > > > > Like to know how to address pci_io region mapping
>> > > > > > > > > > problem for
>> > > > > > > > > > arm/arm64, in-case /dev/ioports approach is not
>> > > > > > > > > > acceptable or else I
>> > > > > > > > > > can spent time on restructuring the patch?
>> > > > > > > > > >
>> > > > > > > > >
>> > > > > > > > > For the use case you describe, can't you use the vfio
>> > > > > > > > > framework to
>> > > > > > > > > access the PCI BARs?
>> > > > > > > > >
>> > > > > > > >
>> > > > > > > > I looked at file: drivers/vfio/pci/vfio_pci.c, func
>> > > > > > > > vfio_pci_map() and
>> > > > > > > > it look to me that it only maps ioresource_mem pci
>> > > > > > > > region,
>> > > > > > > > pasting
>> > > > > > > > code snap:
>> > > > > > > >
>> > > > > > > > if (!(pci_resource_flags(pdev, index) &
>> > > > > > > > IORESOURCE_MEM))
>> > > > > > > > return -EINVAL;
>> > > > > > > > ....
>> > > > > > > >
>> > > > > > > > and I want to map ioresource_io pci region for arm
>> > > > > > > > platform
>> > > > > > > > in my
>> > > > > > > > use-case. Not sure vfio maps pci_iobar region?
>> > > > > > >
>> > > > > > > Mapping I/O BARs is not portable, notably it doesn't work
>> > > > > > > on
>> > > > > > > x86.
>> > > > > > >
>> > > > > > > You should be able access them using the read/write
>> > > > > > > interface
>> > > > > > > on
>> > > > > > > the vfio device.
>> > > > > > >
>> > > > > > Right, x86 doesn't care as iopl() could give userspace
>> > > > > > application
>> > > > > > direct access to ioports.
>> > > > > >
>> > > > > > Also, Alex in other dpdk thread [1] suggested someone to
>> > > > > > propose io
>> > > > > > bar mapping in vfio-pci, I guess in particular to non-x86
>> > > > > > arch
>> > > > > > so I
>> > > > > > started working on it.
>> > > > > >
>> > > > >
>> > > >
>> > > > So what's wrong with just using the existing read/write API on
>> > > > all
>> > > > architectures?
>> > > >
>> > >
>> > > nothing wrong, infact read/write api will still be used so to
>> > > access
>> > > mmaped io pci bar at userspace. But right now vfio_pci_map()
>> > > doesn't
>> >
>> > vfio_pci_mmap(), the read/write accessors fully support i/o port.
>> >
>>
>> (Sorry for delayed response!)
>> Right.
>> > > map io pci bar in particular (i.e.. ioresource_io) so I guess
>> > > need to
>> > > add that bar mapping in vfio. pl. correct me if i misunderstood
>> > > anything.
>> >
>> > Maybe I misunderstood what you were asking for, it seemed like you
>> > specifically wanted to be able to mmap i/o port space, which is
>> > possible, just not something we can do on x86.  Maybe I should have
>> > asked why.  The vfio API already supports read/write access to i/o
>> > port
>>
>> Yes, I want to map io port pci space in vfio and reason for that is :
>> I want to access virto-net-pci device at userspace using vfio and for
>> that I am using vfio-noiommu latest linux-next patch. but I am not
>> able to mmap io port pci space in vfio because of below condition -
>>
>> 1)
>> --- user space code snippet ----
>> reg.index = i; // where i is {0..1} i.e.. {BAR0..BAR1} such that BAR0
>> = io port pci space and BAR1 = pci config space
>>
>> ret = ioctl(vfio_dev_fd, VFIO_DEVICE_GET_REGION_INFO, &reg);
>> if ((reg.flags & VFIO_REGION_INFO_FLAG_MMAP) == 0) {
>>        return err;
>> }
>> now consider i = 0 case where pci_rersource_flag set to IORESOURCE_IO
>>
>> --- kernel / vfip-pci.c -------------
>> so vfio_pci_ioctl() wont set info.flag to VFIO_REGION_INFO_FLAG_MMAP.
>> And it won't set for two
>> 1) pci_resource_flag & IORESOURCE_MEM
>> 2) ioport size < PAZE_SIZE
>>
>> The second one I addressed but first one is what I believe that need
>> to add support in vfio.
>> and Same applicable for vfio_pci_mmap() too..
>>
>> This is why I am thinking to add IORESOURCE_IO space mapping support
>> in vfio; in particular non-x86 archs.. pl. correct my understanding
>> in
>> case wrong.
>>
>> > space, so if you intend to mmap it only to use read/write on top of
>> > the
>> > mmap, I suppose you might see some performance improvement, but not
>> > really any new functionality.  You'd also need to deal with page
>> > size
>> > issues since i/o port ranges are generally quite a bit smaller than
>> > the
>> > host page size and they'd need to be mapped such that each devices
>> > does
>> > not share a host page of i/o port space with other devices.  On x86
>> > i/o
>>
>> Yes. I have taken care size < PAZE_SIZE condition.
>>
>> > port space is mostly considered legacy and not a performance
>> > critical
>> > path for most modern devices; PCI SR-IOV specifically excludes i/o
>> > port
>> > space.  So what performance gains do you expect to see in being
>> > able to
>> > mmap i/o port space and what hardware are you dealing with that
>> > relies
>> > on i/o port space rather than mmio for performance?  Thanks,
>> >
>> dpdk user space virtio-net pmd driver uses ioport space for driver
>> initialization, as because virtio-net header resides in ioport area
>> of
>> virtio-pxe.rom file, also it is inlined to virtio spec (<= 0.95).
>> Till
>> now virtio-net dpdk pmd driver for x86 using iopl() to access those
>> ioport for driver initialization but for non-x86 cases; we needed
>> alternative i.e.. kernel to someway map ioport pci region either by
>> architecture example powerpc does Or look in vfio for mapping. I hope
>> I made my use-case clear.
>
> Not really.  I still don't understand why you need to *mmap* ioport
> space rather than access it via read/write.  vfio already supports
> assignment of numerous physical devices that rely on ioport space for
> the device rom, device initialization, and even runtime operation in
> QEMU using the accesses currently supported.  Legacy x86 ioport space
> cannot be mmap'd on x86 hardware, it's only through sparse memory
> mapping and emulation of ioport space provided on some architectures
> that this is even possible, so you will not achieve
> platform/architecture neutral support for mmap'ing ioport space, which
> means that your userspace driver will not work universally if it
> depends on this support.
>
> If you were using iopl() and in*()/out*() before, simply drop the
> iopl() and use pread()/pwrite() instead.  Thanks,
>

Yes, It works, I got confused, Sorry for noise and thanks for helping on this!

> Alex
