From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] pci: export class IDs from pci_ids.h
Date: Sun, 5 Apr 2015 14:05:07 +0200
Message-ID: <20150405132041-mutt-send-email-mst@redhat.com>
References: <1427714755-16873-1-git-send-email-mst@redhat.com>
 <20150402205347.GA10892@google.com>
 <20150402232804-mutt-send-email-mst@redhat.com>
 <CAErSpo7Wtg2QTznd7RpqXrGO7BL7OekE89iH6CvuXsC6gyVXWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAErSpo7Wtg2QTznd7RpqXrGO7BL7OekE89iH6CvuXsC6gyVXWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Masahiro Yamada <yamada.m-NAum8xwdG0+S7A1Ibl2khg@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Martin =?utf-8?B?TWFyZcWh?= <mj-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 02, 2015 at 05:32:14PM -0500, Bjorn Helgaas wrote:
> [+cc Martin]

That's a good idea. Martin, could you please answer the following:
assuming that linux exported linux/pci_ids.h providing class
IDs that are currently in /usr/include/pci/header.h
in a header /usr/include/linux/pci_ids.h,
would libpci be open to replacing part of
/usr/include/pci/header.h with #include <linux/pci_ids.h>,
assuming that a solution for old systems that lack this
header is also provided?

> On Thu, Apr 2, 2015 at 4:28 PM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu, Apr 02, 2015 at 03:53:47PM -0500, Bjorn Helgaas wrote:
> >> On Mon, Mar 30, 2015 at 01:33:28PM +0200, Michael S. Tsirkin wrote:
> >> > The basic class ID macros in pci_ids.h are pretty useful for userspace
> >> > using the pci sysfs interface, and they aren't fundamentally different
> >> > from the constants in pci_regs.h - both are defined in the
> >> > pci spec.
> >> >
> >> > At the moment userspace is forced to duplicate these macros
> >> > (e.g. QEMU does this, so do seabios, gpxe, and others), it is better to
> >> > expose them in /usr/include/linux/pci_ids.h so everyone can just include
> >> > this header.
> >>
> >> I agree that it would be nice for applications to get these definitions
> >> from a single place, but I'm not sure that include/uapi/linux/pci_ids.h
> >> needs to be that place.
> >>
> >> These constants are just copies of what's in the spec, and I don't think
> >> you're suggesting that the constants are necessary to use a kernel API.
> >>
> >> I know the kernel does provide access to values via sysfs "class" files,
> >> but the kernel is just passing the values through from the hardware.
> >> That's analogous to reading the class with setpci, and I don't think it
> >> leads to a requirement that the kernel export all the information about how
> >> to interpret the class values.
> >>
> >> I haven't looked at libpci or libudev, but it sounds like you think those
> >> are not good solutions.  Is that because they don't currently have this
> >> information?  People don't want to add dependencies on them?
> >
> > People don't want to add dependencies on them.
> 
> Why not?  I'm not a user-space programmer, so it's not obvious to me
> what the problems with adding a dependency are.  If a package provides
> functionality you want, it seems like a *good* thing to use it and
> depend on it rather than reimplementing the functionality yourself.
> The /usr/include/pci/header.h supplied by libpci-dev (on Ubuntu) looks
> like it has most or all of the constants you want.
> 
> Bjorn

Well, so does libudev-devel according to Greg.  Do you know why doesn't
libudev-devel include /usr/include/pci/header.h?
xorg has a copy too: /usr/include/xorg/xf86Pci.h
Why does not xorg include /usr/include/pci/header.h?

I think I know - I think that's because each extra dependency does
introduce overhead: it's another community to interact with to fix bugs
and add features, it's more portability and version skew headaches.

Besides, I'm guessing that the linux header is less likely to have bugs.
Consider PCI_CLASS_STORAGE_IDE:

pciutils]$ git grep PCI_CLASS_STORAGE_IDE
lib/header.h:#define PCI_CLASS_STORAGE_IDE              0x0101
$ git grep PCI_CLASS_STORAGE_IDE                                
arch/alpha/kernel/pci.c:        if (dev->class >> 8 == PCI_CLASS_STORAGE_IDE) {
....
many more hits.

pciutils does nothing with this value itself, it's possible for a distro
to ship a wrong header, and no one will notice. OTOH Linux will break if
it's wrong.  In fact there are 3 values libpci does appear to use
internally:
PCI_CLASS_BRIDGE_HOST
PCI_CLASS_DISPLAY_VGA
PCI_CLASS_BRIDGE_PCI

I'm guessing others are re-exported for the benefit of
applications using libpci.


-- 
MST
