From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 1/5] PCI: Handle IORESOURCE_PCI_FIXED when sizing
 resources.
Date: Thu, 29 Oct 2015 16:13:25 -0500
Message-ID: <20151029211325.GB921@localhost>
References: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com>
 <1445382282-2396-2-git-send-email-ddaney.cavm@gmail.com>
 <56328826.2020406@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56328826.2020406@caviumnetworks.com>
Sender: linux-pci-owner@vger.kernel.org
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 29, 2015 at 01:57:10PM -0700, David Daney wrote:
> Bjorn,
> 
> A small snafu...
> 
> On 10/20/2015 04:04 PM, David Daney wrote:
> >From: David Daney <david.daney@cavium.com>
> >
> >The new Enhanced Allocation (EA) capability support (patches to
> >follow) creates resources with the IORESOURCE_PCI_FIXED set. Since
> >these resources cannot be relocated or resized, their alignment is not
> >really defined, and it is therefore not specified.  This causes a
> >problem in pbus_size_mem() where resources with unspecified alignment
> >are disabled.
> >
> >So, in pbus_size_mem() skip IORESOURCE_PCI_FIXED resources, instead of
> >disabling them.
> >
> >Acked-by: Sean O. Stalley <sean.stalley@intel.com>
> >Signed-off-by: David Daney <david.daney@cavium.com>
> >---
> >  drivers/pci/setup-bus.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> >index 508cc56..4dfef10 100644
> >--- a/drivers/pci/setup-bus.c
> >+++ b/drivers/pci/setup-bus.c
> >@@ -1037,9 +1037,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
> >  			struct resource *r = &dev->resource[i];
> >  			resource_size_t r_size;
> >
> >-			if (r->parent || ((r->flags & mask) != type &&
> >-					  (r->flags & mask) != type2 &&
> >-					  (r->flags & mask) != type3))
> >+			if (r->parent || (r->flags | IORESOURCE_PCI_FIXED) ||
> 
> Should be:
> 
>   r->flags & IORESOURCE_PCI_FIXED
> 
> With the erroneous '|', sizing of bridge resources can break.
> 
> Q:  How to fix this.
> 
>   A) Replace this patch entirely?
> 
>   B) A patch on top of this one?

No problem, I fixed it and repushed the pci/enhanced-allocation branch:

https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/enhanced-allocation
