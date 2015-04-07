From: Martin Mares <mj-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH v2] pci: export class IDs from pci_ids.h
Date: Tue, 7 Apr 2015 14:57:19 +0200
Message-ID: <mj+md-20150407.125023.43354.nikam@ucw.cz>
References: <1427714755-16873-1-git-send-email-mst@redhat.com>
 <20150402205347.GA10892@google.com>
 <20150402232804-mutt-send-email-mst@redhat.com>
 <CAErSpo7Wtg2QTznd7RpqXrGO7BL7OekE89iH6CvuXsC6gyVXWg@mail.gmail.com>
 <20150405132041-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150405132041-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Masahiro Yamada <yamada.m-NAum8xwdG0+S7A1Ibl2khg@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello!

> That's a good idea. Martin, could you please answer the following:
> assuming that linux exported linux/pci_ids.h providing class
> IDs that are currently in /usr/include/pci/header.h
> in a header /usr/include/linux/pci_ids.h,
> would libpci be open to replacing part of
> /usr/include/pci/header.h with #include <linux/pci_ids.h>,
> assuming that a solution for old systems that lack this
> header is also provided?

Please remember that libpci is cross-platform. Your proposal would make it
use <linux/pci_ids.h> on Linux and provide its own definitions on all other
systems, which is likely to bring less consistency, not more.

I do not see any point in using kernel headers for things, which are unrelated
to the kernel.

> pciutils does nothing with this value itself, it's possible for a distro
> to ship a wrong header, and no one will notice. OTOH Linux will break if
> it's wrong.  In fact there are 3 values libpci does appear to use
> internally:
> PCI_CLASS_BRIDGE_HOST
> PCI_CLASS_DISPLAY_VGA
> PCI_CLASS_BRIDGE_PCI
> 
> I'm guessing others are re-exported for the benefit of
> applications using libpci.

Exactly. And I expect that it will be quite similar with the kernel --
most classes defined in <linux/pci_ids.h> are not likely to be used anywhere
in the kernel.

				Martin
