From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Tue, 29 Dec 2015 10:31:09 -0700
Message-ID: <1451410269.18084.15.camel@redhat.com>
References: <20140509191914.GA7286@jtriplet-mobl1>
	 <CA+iXiiNKiMz=9BJgu3g=LggXjTv61Uwu+ibNfKeih3rK328LSQ@mail.gmail.com>
	 <CA+iXiiM+TrciHROfgTcN01mfGEYuUCvpNRU0Qqgrt56VdCcR8Q@mail.gmail.com>
	 <1961979.Xhiud0jvNd@wuerfel>
	 <CAAyOgsYuMWudLgbSNM+QAkSXpU_fp6Ue01r=Ufmf5MXUHMs4UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAyOgsYuMWudLgbSNM+QAkSXpU_fp6Ue01r=Ufmf5MXUHMs4UQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Santosh Shukla <sshukla-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Santosh Shukla <santosh.shukla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuanhan Liu <yuanhan.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2015-12-29 at 22:00 +0530, Santosh Shukla wrote:
> On Tue, Dec 29, 2015 at 9:50 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> > On Tuesday 29 December 2015 21:25:15 Santosh Shukla wrote:
> > > mistakenly added wrong email-id of alex, looping his correct one.
> > >=20
> > > On 29 December 2015 at 21:23, Santosh Shukla <santosh.shukla@lina
> > > ro.org> wrote:
> > > > On 29 December 2015 at 18:58, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> > > > wrote:
> > > > > On Wednesday 23 December 2015 17:04:40 Santosh Shukla wrote:
> > > > > > On 23 December 2015 at 03:26, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> > > > > > wrote:
> > > > > > > On Tuesday 22 December 2015, Santosh Shukla wrote:
> > > > > > > > }
> > > > > > > >=20
> > > > > > > > So I care for /dev/ioport types interface who could do
> > > > > > > > more than byte
> > > > > > > > data copy to/from user-space. I tested this patch with
> > > > > > > > little
> > > > > > > > modification and could able to run pmd driver for
> > > > > > > > arm/arm64 case.
> > > > > > > >=20
> > > > > > > > Like to know how to address pci_io region mapping
> > > > > > > > problem for
> > > > > > > > arm/arm64, in-case /dev/ioports approach is not
> > > > > > > > acceptable or else I
> > > > > > > > can spent time on restructuring the patch?
> > > > > > > >=20
> > > > > > >=20
> > > > > > > For the use case you describe, can't you use the vfio
> > > > > > > framework to
> > > > > > > access the PCI BARs?
> > > > > > >=20
> > > > > >=20
> > > > > > I looked at file: drivers/vfio/pci/vfio_pci.c, func
> > > > > > vfio_pci_map() and
> > > > > > it look to me that it only maps ioresource_mem pci region,
> > > > > > pasting
> > > > > > code snap:
> > > > > >=20
> > > > > > if (!(pci_resource_flags(pdev, index) & IORESOURCE_MEM))
> > > > > > return -EINVAL;
> > > > > > ....
> > > > > >=20
> > > > > > and I want to map ioresource_io pci region for arm platform
> > > > > > in my
> > > > > > use-case. Not sure vfio maps pci_iobar region?
> > > > >=20
> > > > > Mapping I/O BARs is not portable, notably it doesn't work on
> > > > > x86.
> > > > >=20
> > > > > You should be able access them using the read/write interface
> > > > > on
> > > > > the vfio device.
> > > > >=20
> > > > Right, x86 doesn't care as iopl() could give userspace
> > > > application
> > > > direct access to ioports.
> > > >=20
> > > > Also, Alex in other dpdk thread [1] suggested someone to
> > > > propose io
> > > > bar mapping in vfio-pci, I guess in particular to non-x86 arch
> > > > so I
> > > > started working on it.
> > > >=20
> > >=20
> >=20
> > So what's wrong with just using the existing read/write API on all
> > architectures?
> >=20
>=20
> nothing wrong, infact read/write api will still be used so to access
> mmaped io pci bar at userspace. But right now vfio_pci_map() doesn't

vfio_pci_mmap(), the read/write accessors fully support i/o port.

> map io pci bar in particular (i.e.. ioresource_io) so I guess need to
> add that bar mapping in vfio. pl. correct me if i misunderstood
> anything.

Maybe I misunderstood what you were asking for, it seemed like you
specifically wanted to be able to mmap i/o port space, which is
possible, just not something we can do on x86. =C2=A0Maybe I should hav=
e
asked why. =C2=A0The vfio API already supports read/write access to i/o=
 port
space, so if you intend to mmap it only to use read/write on top of the
mmap, I suppose you might see some performance improvement, but not
really any new functionality. =C2=A0You'd also need to deal with page s=
ize
issues since i/o port ranges are generally quite a bit smaller than the
host page size and they'd need to be mapped such that each devices does
not share a host page of i/o port space with other devices. =C2=A0On x8=
6 i/o
port space is mostly considered legacy and not a performance critical
path for most modern devices; PCI SR-IOV specifically excludes i/o port
space. =C2=A0So what performance gains do you expect to see in being ab=
le to
mmap i/o port space and what hardware are you dealing with that relies
on i/o port space rather than mmio for performance? =C2=A0Thanks,

Alex
