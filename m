From: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] PCI: Add support for Enhanced Allocation devices
Date: Wed, 30 Sep 2015 15:50:11 -0700
Message-ID: <20150930225011.GA4244@sean.stalley.intel.com>
References: <1443485439-12081-1-git-send-email-ddaney.cavm@gmail.com>
 <1443485439-12081-3-git-send-email-ddaney.cavm@gmail.com>
 <20150929192737.GA2517@sean.stalley.intel.com>
 <560AF3D7.80908@gmail.com>
 <20150929224727.GB2517@sean.stalley.intel.com>
 <560B2470.9080100@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <560B2470.9080100-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 29, 2015 at 04:53:20PM -0700, David Daney wrote:
> On 09/29/2015 03:47 PM, Sean O. Stalley wrote:
> [...]
> >>>>diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> >>>>index 6a9a111..7c60b16 100644
> >>>>--- a/drivers/pci/pci.c
> >>>>+++ b/drivers/pci/pci.c
> >>>>@@ -2148,6 +2148,284 @@ void pci_pm_init(struct pci_dev *dev)
> >>>>  	}
> >>>>  }
> >>>>
> >>>>+static unsigned long pci_ea_set_flags(struct pci_dev *dev, u8 prop)
> >>>>+{
> >>>>+	unsigned long flags = IORESOURCE_PCI_FIXED | IORESOURCE_SIZEALIGN;
> >>>
> >>>Why did you add the IORESOURCE_SIZEALIGN flag? EA allows for unaligned resources.
> >>
> >>pci_bus_assign_resources() fails causing the devices to be unusable
> >>if resource_alignment() returns zero.  The easiest fix for this was
> >>to specify IORESOURCE_SIZEALIGN.
> >>
> >>An alternative would be to change the code in setup-bus.c so that
> >>for IORESOURCE_PCI_FIXED resources, it didn't barf.
> >
> >I would do this alternative, but with a IORESOURCE_PCI_EA flag.
> >
> 
> I don't think we need IORESOURCE_PCI_EA.  If a resource is tagged as
> IORESOURCE_PCI_FIXED that means that it cannot be changed, we
> shouldn't care why it is fixed (due to an EA capability for
> example).  We just need to gracefully handle IORESOURCE_PCI_FIXED in
> the places where things currently go wrong.
> 
> David Daney
> 

I agree that we need to make sure fixed things stay fixed,
regardless of if they are fixed by EA or something else.

The question is: do we want to allow all fixed resources to be non-aligned, or just EA?

-Sean
