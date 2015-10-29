From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 1/5] PCI: Handle IORESOURCE_PCI_FIXED when sizing resources.
Date: Thu, 29 Oct 2015 13:57:10 -0700
Message-ID: <56328826.2020406@caviumnetworks.com>
References: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com> <1445382282-2396-2-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445382282-2396-2-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Bjorn,

A small snafu...

On 10/20/2015 04:04 PM, David Daney wrote:
> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>
> The new Enhanced Allocation (EA) capability support (patches to
> follow) creates resources with the IORESOURCE_PCI_FIXED set. Since
> these resources cannot be relocated or resized, their alignment is not
> really defined, and it is therefore not specified.  This causes a
> problem in pbus_size_mem() where resources with unspecified alignment
> are disabled.
>
> So, in pbus_size_mem() skip IORESOURCE_PCI_FIXED resources, instead of
> disabling them.
>
> Acked-by: Sean O. Stalley <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/pci/setup-bus.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 508cc56..4dfef10 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -1037,9 +1037,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>   			struct resource *r = &dev->resource[i];
>   			resource_size_t r_size;
>
> -			if (r->parent || ((r->flags & mask) != type &&
> -					  (r->flags & mask) != type2 &&
> -					  (r->flags & mask) != type3))
> +			if (r->parent || (r->flags | IORESOURCE_PCI_FIXED) ||

Should be:

   r->flags & IORESOURCE_PCI_FIXED

With the erroneous '|', sizing of bridge resources can break.

Q:  How to fix this.

   A) Replace this patch entirely?

   B) A patch on top of this one?


> +			    ((r->flags & mask) != type &&
> +			     (r->flags & mask) != type2 &&
> +			     (r->flags & mask) != type3))
>   				continue;
>   			r_size = resource_size(r);
>   #ifdef CONFIG_PCI_IOV
>
