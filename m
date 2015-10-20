From: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 3/4] PCI: Handle IORESOURCE_PCI_FIXED when sizing and
 assigning resources.
Date: Tue, 20 Oct 2015 09:04:16 -0500
Message-ID: <20151020140416.GD8224@localhost>
References: <1444175438-7443-1-git-send-email-ddaney.cavm@gmail.com>
 <1444175438-7443-4-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444175438-7443-4-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 06, 2015 at 04:50:37PM -0700, David Daney wrote:
> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> 
> The new Enhanced Allocation (EA) capability support creates resources
> with the IORESOURCE_PCI_FIXED set.  This causes a couple of problems:
> 
> 1) Since these resources cannot be relocated or resized, their
>    alignment is not really defined, and it is therefore not specified.
>    This causes a problem in pbus_size_mem() where resources with
>    unspecified alignment are disabled.
> 
> 2) During resource assignment in pci_bus_assign_resources(),
>    IORESOURCE_PCI_FIXED resources are not given a parent.  This, in
>    turn, causes pci_enable_resources() to fail with a "not claimed"
>    error.
> 
> So, in pbus_size_mem() skip IORESOURCE_PCI_FIXED resources, instead of
> disabling them.
> 
> In __pci_bus_assign_resources(), for IORESOURCE_PCI_FIXED resources,
> try to request the resource from a parent bus.

This is fixing two problems; can you just split this into two patches?
I think the changelogs will read more easily then.

It seems like maybe these fixes should also precede the "add support
for EA devices" patch.  We already use IORESOURCE_PCI_FIXED in a few
cases, and these are probably applicable to them, and if you have the
fixes in first, we'll have less of a bisection hole when we add EA
support.

> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/pci/setup-bus.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 508cc56..7239a2c 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -1037,9 +1037,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  			struct resource *r = &dev->resource[i];
>  			resource_size_t r_size;
>  
> -			if (r->parent || ((r->flags & mask) != type &&
> -					  (r->flags & mask) != type2 &&
> -					  (r->flags & mask) != type3))
> +			if (r->parent || (r->flags | IORESOURCE_PCI_FIXED) ||
> +			    ((r->flags & mask) != type &&
> +			     (r->flags & mask) != type2 &&
> +			     (r->flags & mask) != type3))
>  				continue;
>  			r_size = resource_size(r);
>  #ifdef CONFIG_PCI_IOV
> @@ -1340,6 +1341,47 @@ void pci_bus_size_bridges(struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL(pci_bus_size_bridges);
>  
> +static void assign_fixed_resource_on_bus(struct pci_bus *b, struct resource *r)
> +{
> +	int i;
> +	struct resource *parent_r;
> +	unsigned long mask = IORESOURCE_IO | IORESOURCE_MEM |
> +			     IORESOURCE_PREFETCH;
> +
> +	pci_bus_for_each_resource(b, parent_r, i) {
> +		if (!parent_r)
> +			continue;
> +
> +		if ((r->flags & mask) == (parent_r->flags & mask) &&
> +		    resource_contains(parent_r, r))
> +			request_resource(parent_r, r);

If request_resource() fails, it seems like it'd useful to know about
it.  Can you use request_resource_conflict() and add a diagnostic
similar to what's in pci_claim_resource()?

> +	}
> +}
> +
> +/*
> + * Try to assign any resources marked as IORESOURCE_PCI_FIXED, as they
> + * are skipped by pbus_assign_resources_sorted().
> + */
> +static void pdev_assign_fixed_resources(struct pci_dev *dev)

"assign" seems like the wrong verb here (and above).  I think of
"assign" as the process where we might change the addresses to which
the device responds, seting res->start accordingly.  But here, we
already know those addresses, and we're merely telling the resource
manager what we're using.

> +{
> +	int i;
> +
> +	for (i = 0; i <  PCI_NUM_RESOURCES; i++) {
> +		struct pci_bus *b;
> +		struct resource *r = &dev->resource[i];
> +
> +		if (r->parent || !(r->flags & IORESOURCE_PCI_FIXED) ||
> +		    !(r->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
> +			continue;
> +
> +		b = dev->bus;
> +		while (b && !r->parent) {
> +			assign_fixed_resource_on_bus(b, r);
> +			b = b->parent;
> +		}
> +	}
> +}
> +
>  void __pci_bus_assign_resources(const struct pci_bus *bus,
>  				struct list_head *realloc_head,
>  				struct list_head *fail_head)
> @@ -1350,6 +1392,8 @@ void __pci_bus_assign_resources(const struct pci_bus *bus,
>  	pbus_assign_resources_sorted(bus, realloc_head, fail_head);
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		pdev_assign_fixed_resources(dev);
> +
>  		b = dev->subordinate;
>  		if (!b)
>  			continue;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
