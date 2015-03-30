From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 86/86] usb/dwc3: move ids to pci_ids.h
Date: Mon, 30 Mar 2015 09:16:19 +0200
Message-ID: <20150330091542-mutt-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
 <1427635734-24786-87-git-send-email-mst@redhat.com>
 <20150329204200.GB5902@kroah.com>
 <20150330085001-mutt-send-email-mst@redhat.com>
 <20150330065810.GA10508@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150330065810.GA10508-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Neubauer <pneubauer-OUHTSVaU61M6GL+IUqp+Xg@public.gmane.org>, Huang Rui <ray.huang-5C7GfCeVMHo@public.gmane.org>, Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 08:58:10AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Mar 30, 2015 at 08:50:34AM +0200, Michael S. Tsirkin wrote:
> > On Sun, Mar 29, 2015 at 10:42:00PM +0200, Greg Kroah-Hartman wrote:
> > > On Sun, Mar 29, 2015 at 03:43:40PM +0200, Michael S. Tsirkin wrote:
> > > > Comment says IDs should move to pci_ids.h, let's do it.
> > > 
> > > No, please remove the comment, it's not needed in pci_ids.h at all.
> > 
> > vendor ID does belong in pci_ids.h though, so says
> > Documentation/PCI/pci.txt
> 
> Read the top of pci_ids.h please.

Thanks for pointing this out, looks like Documentation/PCI/pci.txt
should be improved.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
