From: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 3/5] PCI: Handle IORESOURCE_PCI_FIXED when sizing and
 assigning resources.
Date: Tue, 06 Oct 2015 13:58:43 -0700
Message-ID: <56143603.9090708@gmail.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com> <1443825476-26880-4-git-send-email-ddaney.cavm@gmail.com> <20151005222351.GA4821@sean.stalley.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151005222351.GA4821-KQ5zpJUXklQTH34CoL1+91DQ4js95KgL@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/05/2015 03:23 PM, Sean O. Stalley wrote:
> On Fri, Oct 02, 2015 at 03:37:54PM -0700, David Daney wrote:
>
> ...
>
>> +/*
>> + * Try to assign any resources marked as IORESOURCE_PCI_FIXED, as they
>> + * are skipped by pbus_assign_resources_sorted().
>> + */
>> +static void pdev_assign_fixed_resources(struct pci_dev *dev)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i <  PCI_NUM_RESOURCES; i++) {
>> +		struct pci_bus *b;
>> +		struct resource *r = &dev->resource[i];
>> +
>> +		if (r->parent || !(r->flags & IORESOURCE_PCI_FIXED) ||
>> +		    !(r->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
>> +			continue;
>> +
>> +		b = dev->bus;
>> +		while (b && !r->parent) {
>> +			assign_fixed_resource_on_bus(b, r);
>> +			b = b->parent;
>> +		}
>> +		if (!r->parent) {
>> +			/*
>> +			 * If that didn't work, try to fallback to the
>> +			 * ultimate parent.
>> +			 */
>> +			if (r->flags &  IORESOURCE_IO)
>> +				request_resource(&ioport_resource, r);
>> +			else
>> +				request_resource(&iomem_resource, r);
>> +		}
>
> I don't think this check is necessary.
> assign_fixed_resource_on_bus() should find these resources when it reaches the top bus.
> (since since the root bus contains these resources).

You are correct.  It does work fine without that last fallback bit.  I 
will remove that, and re-send the patches.

Thanks,
David Daney



>
>> +	}
>> +}
>
> -Sean
>
