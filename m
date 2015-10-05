From: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 5/5] PCI: Handle Enhanced Allocation (EA) capability
 for bridges
Date: Mon, 5 Oct 2015 15:54:05 -0700
Message-ID: <20151005225405.GC4821@sean.stalley.intel.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
 <1443825476-26880-6-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443825476-26880-6-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 02, 2015 at 03:37:56PM -0700, David Daney wrote:
> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> 
> PCI bridges may have their properties be specified via EA entries.
> 
> Extend the EA parser to extract the bridge resources, and modify
> pci_read_bridge_{io,mmio,mmio_pref}() to use resources previously
> obtained via EA.
> 
> Save the offset to the EA capability in struct pci_dev, and use it to
> easily find the EA bridge subordinate and secondary bus numbers.
> 
> When assigning the bridge resources a couple of changes are required
> so that the EA obtained IORESOURCE_PCI_FIXED are not resized, and
> correctly linked into the resource tree.
> 
> 1) In pbus_size_mem() do not attempt to resize the bridge resources if
>    they are marked as IORESOURCE_PCI_FIXED.
> 
> 2) In pci_bus_alloc_from_region()for IORESOURCE_PCI_FIXED resources, just
>    try to request the resource as is, without attempting to resize it.
> 
> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/pci/bus.c       |  7 +++++++
>  drivers/pci/pci.c       | 13 +++++++++++++
>  drivers/pci/probe.c     | 31 +++++++++++++++++++++++++++++--
>  drivers/pci/setup-bus.c |  3 +++
>  include/linux/pci.h     |  1 +
>  5 files changed, 53 insertions(+), 2 deletions(-)
> @@ -801,8 +813,23 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
>  
>  	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
>  	primary = buses & 0xFF;
> -	secondary = (buses >> 8) & 0xFF;
> -	subordinate = (buses >> 16) & 0xFF;
> +	if (dev->ea_cap) {
> +		u32 dw1;
> +
> +		pci_read_config_dword(dev, dev->ea_cap + 4, &dw1);
> +		if (dw1 & 0xFF)
> +			secondary = dw1 & 0xFF;
> +		else
> +			secondary = (buses >> 8) & 0xFF;
> +
> +		if ((dw1 >> 8) & 0xFF)
> +			subordinate = (dw1 >> 8) & 0xFF;
> +		else
> +			subordinate = (buses >> 16) & 0xFF;
> +	} else {
> +		secondary = (buses >> 8) & 0xFF;
> +		subordinate = (buses >> 16) & 0xFF;
> +	}

We can refactor this to make it cleaner/more compact. from V3 review:


	secondary = (buses >> 8) & 0xFF;
	subordinate = (buses >> 16) & 0xFF;
	if (dev->ea_cap) {
		u32 sdw;
		
		pci_read_config_dword(dev, dev->ea_cap + 4, &sdw);
		
		if (sdw & 0xFF)
			secondary = sdw & 0xFF;
		
		sdw >>= 8;
		if (sdw & 0xFF)
			subordinate = sdw & 0xFF;
	}


-Sean
