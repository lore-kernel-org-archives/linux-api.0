From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH v2 0/2] PCI: Add support for PCI Enhanced Allocation
 "BARs"
Date: Wed, 23 Sep 2015 16:51:09 -0700
Message-ID: <20150923235109.GA4384@sean.stalley.intel.com>
References: <1443047264-4003-1-git-send-email-sean.stalley@intel.com>
 <CAE9FiQXYzcEnagnAZ_agXXSVssAfVD8tBjKh9ox_ajqKG0v27g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQXYzcEnagnAZ_agXXSVssAfVD8tBjKh9ox_ajqKG0v27g@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rajat Jain <rajatxjain@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 23, 2015 at 04:26:56PM -0700, Yinghai Lu wrote:
> On Wed, Sep 23, 2015 at 3:27 PM, Sean O. Stalley <sean.stalley@intel.com> wrote:
> > PCI Enhanced Allocation is a new method of allocating MMIO & IO
> > resources for PCI devices & bridges. It can be used instead
> > of the traditional PCI method of using BARs.
> >
> > EA entries are hardware-initialized to a fixed address.
> > Unlike BARs, regions described by EA are cannot be moved.
> > Because of this, only devices which are permanently connected to
> > the PCI bus can use EA. A removable PCI card must not use EA.
> 
> As it is fixed, can you put IORESOURCE_PCI_FIXED in the res->flags?
> 
> Thanks
> 
> Yinghai

IORESOURCE_PCI_FIXED is set in pci_ea_set_flags():
 
	+static unsigned long pci_ea_set_flags(struct pci_dev *dev, u8 prop)
	+{
	+	unsigned long flags = IORESOURCE_PCI_FIXED;
	+
	+

Which is called in pci_ea_read(), and passed to res->flags (if there aren't any errors):

	+
	+	/* Try to use primary properties, otherwise fall back to secondary */
	+	flags = pci_ea_set_flags(dev, PCI_EA_PP(dw0));
	+	if (!flags)
	+		flags = pci_ea_set_flags(dev, PCI_EA_SP(dw0));
	+

	...

	+	res->flags = flags;


-Sean
