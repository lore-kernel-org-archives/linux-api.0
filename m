From: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] PCI: Add support for Enhanced Allocation devices
Date: Tue, 29 Sep 2015 13:25:59 -0700
Message-ID: <560AF3D7.80908@gmail.com>
References: <1443485439-12081-1-git-send-email-ddaney.cavm@gmail.com> <1443485439-12081-3-git-send-email-ddaney.cavm@gmail.com> <20150929192737.GA2517@sean.stalley.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150929192737.GA2517-KQ5zpJUXklQTH34CoL1+91DQ4js95KgL@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks for reviewing the new code.  Expect a revised patch soon.

Other responses below...


On 09/29/2015 12:27 PM, Sean O. Stalley wrote:
> Hi David,
>
> Thanks for working on this. I gave it a look and added my comments inline below.
> I have a few concerns, but overall I like it :)
>
> To clarify, you are only trying to add support for Bridges that have
> EA entries to describe the resource range of downstream devices?

Yes.  If a bridge doesn't have an EA capability, it will be treated as a 
normal bridge.

> I ask because the spec allows for bridges that don't include an EA entry for this.

Correct.  I think that should still work, but I will test it to make sure.

>
> I think we will need to add more code to make sure we don't break hot-plugging for non-EA devices.

I cannot envision how it would go wrong, but if someone can describe a 
valid failure mode, I agree it should be handled.


> What if something happens on a non-EA bus that causes the PCI core to reassign bus numbers?
> I don't think the current code can make sure the bus numbers stay the same.

I don't know if it makes sense to design hardware containing fixed BARS 
described by EA capabilities, but where the bus topology would change 
with respect to those devices.  So perhaps that doesn't have to be handled.

>
> Also, I think we should split up the patch set to make it easier to review.
> Maybe something like:
> 	1 - Register/Constant definitions
> 	2 - EA entry parser/RCiEP support
> 	3 - Bridge support
> 	4 - SR-IOV support

Yes, that would make it easier to understand what each part is doing.

>
>
> Thanks,
> Sean
>
> On Mon, Sep 28, 2015 at 05:10:39PM -0700, David Daney wrote:
>> From: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Add support for devices using Enhanced Allocation entries instead of BARs.
>> This patch allows the kernel to parse the EA Extended Capability structure
>> in PCI configspace and claim the BAR-equivalent resources.
>>
>> Signed-off-by: Sean O. Stalley <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> [david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org: Added support for bridges and SRIOV]
>> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>> ---
>>   drivers/pci/iov.c       |  15 ++-
>>   drivers/pci/pci.c       | 278 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/pci/pci.h       |   4 +
>>   drivers/pci/probe.c     |  42 +++++++-
>>   drivers/pci/setup-bus.c |   3 +
>>   include/linux/pci.h     |   1 +
>>   6 files changed, 339 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index ee0ebff..c034575 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -435,9 +435,20 @@ found:
>>
>>   	nres = 0;
>>   	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
>> +		int ea_bar = pci_ea_find_ent_with_bei(dev,
>> +						      i + PCI_EA_BEI_VF_BAR0);
>> +
>>   		res = &dev->resource[i + PCI_IOV_RESOURCES];
>> -		bar64 = __pci_read_base(dev, pci_bar_unknown, res,
>> -					pos + PCI_SRIOV_BAR + i * 4);
>> +
>> +		if (ea_bar > 0) {
>> +			if (pci_ea_decode_ent(dev, ea_bar, res))
>> +				continue;
>
> Do we want to decode here?
>
> This patch calls pci_ea_decode_ent() a lot more than I think it should...
> I think we only want to call the decode function once per entry,
> since it requests resources & reads configspace.
>
> Do you think we could find a way to only call decode() once during initialization,
> then use info in the resource struct after that?
>

The other option is to decode the bars when the EA capability is probed 
(as we do for the normal device BARs), and then skip calling 
__pci_read_base() if the BAR resource is already IORESOURCE_PCI_FIXED, 
indicating that it was populated by EA.

It does end up doing more config space reads than it otherwise would, 
but we only do this at device discovery, so it doesn't effect anything 
except at boot time.

The resource is only requested if the requested EA entry is found, so it 
is done exactly once.

The reason I like doing it here is that it keeps all the SRIOV related 
code in one place.

>
>> +			bar64 = (res->flags & IORESOURCE_MEM_64) ? 1 : 0;
>> +		} else {
>> +			bar64 = __pci_read_base(dev, pci_bar_unknown, res,
>> +						pos + PCI_SRIOV_BAR + i * 4);
>> +		}
>> +
>>   		if (!res->flags)
>>   			continue;
>>   		if (resource_size(res) & (PAGE_SIZE - 1)) {
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 6a9a111..7c60b16 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -2148,6 +2148,284 @@ void pci_pm_init(struct pci_dev *dev)
>>   	}
>>   }
>>
>> +static unsigned long pci_ea_set_flags(struct pci_dev *dev, u8 prop)
>> +{
>> +	unsigned long flags = IORESOURCE_PCI_FIXED | IORESOURCE_SIZEALIGN;
>
> Why did you add the IORESOURCE_SIZEALIGN flag? EA allows for unaligned resources.

pci_bus_assign_resources() fails causing the devices to be unusable if 
resource_alignment() returns zero.  The easiest fix for this was to 
specify IORESOURCE_SIZEALIGN.

An alternative would be to change the code in setup-bus.c so that for 
IORESOURCE_PCI_FIXED resources, it didn't barf.

>
>> +
>> +	switch (prop) {
>> +	case PCI_EA_P_MEM:
>> +	case PCI_EA_P_VIRT_MEM:
>> +	case PCI_EA_P_BRIDGE_MEM:
>> +		flags |= IORESOURCE_MEM;
>> +		break;
>> +	case PCI_EA_P_MEM_PREFETCH:
>> +	case PCI_EA_P_VIRT_MEM_PREFETCH:
>> +	case PCI_EA_P_BRIDGE_MEM_PREFETCH:
>> +		flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
>> +		break;
>> +	case PCI_EA_P_IO:
>> +	case PCI_EA_P_BRIDGE_IO:
>> +		flags |= IORESOURCE_IO;
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +
>> +	return flags;
>> +}
>> +
>> +static struct resource *pci_ea_get_resource(struct pci_dev *dev, u8 bei)
>> +{
>> +	if (bei <= PCI_STD_RESOURCE_END)
>> +		return &dev->resource[bei];
>> +	else if (bei == PCI_EA_BEI_ROM)
>> +		return &dev->resource[PCI_ROM_RESOURCE];
>
> For SR-IOV, you would need to handle the case where the bei is between
> PCI_EA_BEI_IOV and PCI_EA_BEI_IOV_END  (9-14)
>
> For Bridges, we need to handle the PCI_EA_BEI_BRIDGE (6) case.
>

My strategy was to decode the entries for SRIOV and bridges in their own 
initialization code, instead of here.

We could change it so that all the EA entries are decoded in one go, and 
then the resources are not touched in the SRIOV and bridge initialization.


>> +	else
>> +		return NULL;
>> +}
>> +
>> +int pci_ea_decode_ent(struct pci_dev *dev, int offset, struct resource *res)
>> +{
>> +	struct resource *r;
>> +	int i;
>> +	unsigned long mask;
>> +	int ent_offset = offset;
>> +	int ent_size;
>> +	resource_size_t start;
>> +	resource_size_t end;
>> +	unsigned long flags;
>> +	u32 dw0;
>> +	u32 base;
>> +	u32 max_offset;
>> +	bool support_64 = (sizeof(resource_size_t) >= 8);
>> +
>> +	pci_read_config_dword(dev, ent_offset, &dw0);
>> +	ent_offset += 4;
>> +
>> +	/* Entry size field indicates DWORDs after 1st */
>> +	ent_size = ((dw0 & PCI_EA_ES) + 1) << 2;
>> +
>> +	/* Try to use primary properties, otherwise fall back to secondary */
>> +	flags = pci_ea_set_flags(dev, PCI_EA_PP(dw0));
>> +	if (!flags)
>> +		flags = pci_ea_set_flags(dev, PCI_EA_SP(dw0));
>> +
>> +	if (!flags) {
>> +		dev_err(&dev->dev, "%s: Entry EA properties not supported\n",
>> +			__func__);
>> +		goto out;
>> +	}
>> +
>> +	/* Read Base */
>> +	pci_read_config_dword(dev, ent_offset, &base);
>> +	start = (base & PCI_EA_FIELD_MASK);
>> +	ent_offset += 4;
>> +
>> +	/* Read MaxOffset */
>> +	pci_read_config_dword(dev, ent_offset, &max_offset);
>> +	ent_offset += 4;
>> +
>> +	/* Read Base MSBs (if 64-bit entry) */
>> +	if (base & PCI_EA_IS_64) {
>> +		u32 base_upper;
>> +
>> +		pci_read_config_dword(dev, ent_offset, &base_upper);
>> +		ent_offset += 4;
>> +
>> +		flags |= IORESOURCE_MEM_64;
>> +
>> +		/* entry starts above 32-bit boundary, can't use */
>> +		if (!support_64 && base_upper)
>> +			goto out;
>> +
>> +		if (support_64)
>> +			start |= ((u64)base_upper << 32);
>> +	}
>> +
>> +	dev_dbg(&dev->dev, "%s: start = %pa\n", __func__, &start);
>> +
>> +	end = start + (max_offset | 0x03);
>> +
>> +	/* Read MaxOffset MSBs (if 64-bit entry) */
>> +	if (max_offset & PCI_EA_IS_64) {
>> +		u32 max_offset_upper;
>> +
>> +		pci_read_config_dword(dev, ent_offset, &max_offset_upper);
>> +		ent_offset += 4;
>> +
>> +		flags |= IORESOURCE_MEM_64;
>> +
>> +		/* entry too big, can't use */
>> +		if (!support_64 && max_offset_upper)
>> +			goto out;
>> +
>> +		if (support_64)
>> +			end += ((u64)max_offset_upper << 32);
>> +	}
>> +
>> +	dev_dbg(&dev->dev, "%s: end = %pa\n", __func__, &end);
>> +
>> +	if (end < start) {
>> +		dev_err(&dev->dev, "EA Entry crosses address boundary\n");
>> +		goto out;
>> +	}
>> +
>> +	if (ent_size != ent_offset - offset) {
>> +		dev_err(&dev->dev, "EA entry size does not match length read\n"
>> +			"(Entry Size:%u Length Read:%u)\n",
>> +			ent_size, ent_offset - offset);
>> +		goto out;
>> +	}
>> +
>> +	res->name = pci_name(dev);
>> +	res->start = start;
>> +	res->end = end;
>> +	res->flags = flags;
>> +	mask = IORESOURCE_IO | IORESOURCE_MEM | IORESOURCE_PREFETCH;
>> +	pci_bus_for_each_resource(dev->bus, r, i) {
>> +		if (!r)
>> +			continue;
>> +		if ((r->flags & mask) == (flags & mask) &&
>> +		    resource_contains(r, res)) {
>> +			request_resource(r, res);
>> +			break;
>> +		}
>> +	}
>
> Yinghai had some objections to claiming/requesting resources this early
> in initialization. Bjorn thought it would be better to modify the existing
> pci_claim_resource() function then try to do it ourselves here.
> (V1 did something similar, but I pulled it out in V2)

For fixed resources, it works to do the claiming here.  Everything is 
set in stone, it is never going to change.


>
>> +	if (!res->parent) {
>> +		if (flags & IORESOURCE_IO)
>> +			res->parent = &ioport_resource;
>> +		else
>> +			res->parent =  &iomem_resource;
>> +	}
>
> I had this code in V1. Bjorn didn't like defaulting to these resources.
> Also, is there a reason you call request_resource() for resources above, but not here?
>

request_resource() was failing in some cases (I think due to overlapping 
resources), so this seemed like a reasonable fallback.


>> +	return 0;
>> +out:
>> +	return -EINVAL;
>> +}
>> +
>
> I'm not sure if this finder code is necessary.
>
> You could avoid having to call pci_ea_find_ent_with_prop()
> by making the decoder set the right resource struct for the bridge.
>
> You could avoid having to call pci_ea_find_ent_with_bei() by adding an EA flag to the resources.
> When the SR-IOV code usually reads the BAR, just check if the EA flag is set,
> and skip the read (since the resource has already been set).
>

You are correct.  It depends on where we think the best place to 
initialize the resources is.

>> +static int pci_ea_find_ent_with_x(struct pci_dev *dev,
>> +				  bool (*matcher)(u32, int), int m)
>> +{
>> +	int ent_offset;
>> +	u8 num_ent;
>> +	u32 dw0;
>> +
>> +	if (!dev->ea_cap)
>> +		return -ENOENT;
>> +
>> +	/* determine the number of entries */
>> +	pci_read_config_byte(dev, dev->ea_cap + PCI_EA_NUM_ENT, &num_ent);
>> +	num_ent &= PCI_EA_NUM_ENT_MASK;
>> +
>> +	ent_offset = dev->ea_cap + PCI_EA_FIRST_ENT;
>> +	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE)
>> +		ent_offset += 4;
>> +
>> +	while (num_ent) {
>> +		pci_read_config_dword(dev, ent_offset, &dw0);
>> +
>> +		if (matcher(dw0, m))
>> +			return ent_offset;
>> +
>> +		/* Entry size field indicates DWORDs after 1st */
>> +		ent_offset += ((dw0 & PCI_EA_ES) + 1) << 2;
>> +		num_ent--;
>> +	}
>> +	return -ENOENT;
>> +}
>> +
>> +static bool pci_ea_match_prop(u32 dw0, int prop)
>> +{
>> +	return PCI_EA_PP(dw0) == prop || PCI_EA_SP(dw0) == prop;
>> +}
>> +
>> +int pci_ea_find_ent_with_prop(struct pci_dev *dev, int prop)
>> +{
>> +	return pci_ea_find_ent_with_x(dev, pci_ea_match_prop, prop);
>> +}
>> +
>> +static bool pci_ea_match_bei(u32 dw0, int bei)
>> +{
>> +	return PCI_EA_BEI(dw0) == bei;
>> +}
>> +
>> +int pci_ea_find_ent_with_bei(struct pci_dev *dev, int bei)
>> +{
>> +	return pci_ea_find_ent_with_x(dev, pci_ea_match_bei, bei);
>> +}
>> +
>> +/* Read an Enhanced Allocation (EA) entry */
>> +static int pci_ea_read(struct pci_dev *dev, int offset)
>> +{
>> +	struct resource *res;
>> +	int ent_offset = offset;
>> +	int ent_size;
>> +	u32 dw0;
>> +
>> +	pci_read_config_dword(dev, ent_offset, &dw0);
>> +	ent_offset += 4;
>> +
>> +	/* Entry size field indicates DWORDs after 1st */
>> +	ent_size = ((dw0 & PCI_EA_ES) + 1) << 2;
>> +
>> +	switch (PCI_EA_PP(dw0)) {
>> +	case PCI_EA_P_MEM:
>> +	case PCI_EA_P_MEM_PREFETCH:
>> +	case PCI_EA_P_IO:
>> +		break;
>> +	default:
>> +		switch (PCI_EA_SP(dw0)) {
>> +		case PCI_EA_P_MEM:
>> +		case PCI_EA_P_MEM_PREFETCH:
>> +		case PCI_EA_P_IO:
>> +			break;
>> +		default:
>> +			goto out;
>> +		}
>> +	}
>> +	if (!(dw0 & PCI_EA_ENABLE)) /* Entry not enabled */
>> +		goto out;
>> +
>> +	res = pci_ea_get_resource(dev, PCI_EA_BEI(dw0));
>> +	if (!res) {
>> +		dev_err(&dev->dev, "%s: Unsupported EA entry BEI\n", __func__);
>> +		goto out;
>> +	}
>> +
>> +	pci_ea_decode_ent(dev, offset, res);
>> +out:
>> +	return offset + ent_size;
>> +}
>> +
>> +/* Enhanced Allocation Initalization */
>> +void pci_ea_init(struct pci_dev *dev)
>> +{
>> +	int ea;
>> +	u8 num_ent;
>> +	int offset;
>> +	int i;
>> +
>> +	/* find PCI EA capability in list */
>> +	ea = pci_find_capability(dev, PCI_CAP_ID_EA);
>> +	if (!ea)
>> +		return;
>> +
>> +	dev->ea_cap = ea;
>> +
>> +	/* determine the number of entries */
>> +	pci_read_config_byte(dev, ea + PCI_EA_NUM_ENT, &num_ent);
>> +	num_ent &= PCI_EA_NUM_ENT_MASK;
>> +
>> +	offset = ea + PCI_EA_FIRST_ENT;
>> +
>> +	/* Skip DWORD 2 for type 1 functions */
>> +	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE)
>> +		offset += 4;
>> +
>> +	/* parse each EA entry */
>> +	for (i = 0; i < num_ent; ++i)
>> +		offset = pci_ea_read(dev, offset);
>> +}
>> +
>>   static void pci_add_saved_cap(struct pci_dev *pci_dev,
>>   	struct pci_cap_saved_state *new_cap)
>>   {
>> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
>> index 24ba9dc..80542ac 100644
>> --- a/drivers/pci/pci.h
>> +++ b/drivers/pci/pci.h
>> @@ -78,6 +78,10 @@ bool pci_dev_keep_suspended(struct pci_dev *dev);
>>   void pci_config_pm_runtime_get(struct pci_dev *dev);
>>   void pci_config_pm_runtime_put(struct pci_dev *dev);
>>   void pci_pm_init(struct pci_dev *dev);
>> +void pci_ea_init(struct pci_dev *dev);
>> +int pci_ea_decode_ent(struct pci_dev *dev, int offset, struct resource *res);
>> +int pci_ea_find_ent_with_prop(struct pci_dev *dev, int prop);
>> +int pci_ea_find_ent_with_bei(struct pci_dev *dev, int prop);
>>   void pci_allocate_cap_save_buffers(struct pci_dev *dev);
>>   void pci_free_cap_save_buffers(struct pci_dev *dev);
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 0b2be17..52ae57d 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -338,6 +338,7 @@ static void pci_read_bridge_io(struct pci_bus *child)
>>   	unsigned long io_mask, io_granularity, base, limit;
>>   	struct pci_bus_region region;
>>   	struct resource *res;
>> +	int ea_ent;
>>
>>   	io_mask = PCI_IO_RANGE_MASK;
>>   	io_granularity = 0x1000;
>> @@ -348,6 +349,12 @@ static void pci_read_bridge_io(struct pci_bus *child)
>>   	}
>>
>>   	res = child->resource[0];
>> +	ea_ent = pci_ea_find_ent_with_prop(dev, PCI_EA_P_BRIDGE_IO);
>> +	if (ea_ent > 0 && !pci_ea_decode_ent(dev, ea_ent, res)) {
>
> Wouldn't this make EA entries for bridges get decoded (& requested) twice
> (Here & when the EA entry is initially parsed)?
>

See my comments on the SRIOV BARs.  Same reasoning applies here.


> Happens below too for memory entries...
>
>> +		dev_dbg(&dev->dev, "  bridge window %pR via EA\n", res);
>> +		return;
>> +	}
>> +
>>   	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
>>   	pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
>
> Don't we want to use the EA window (instead of whatever is written in base limit)?

Yes.  Good catch.  I will change it.


>
>>   	base = (io_base_lo & io_mask) << 8;
>> @@ -378,8 +385,14 @@ static void pci_read_bridge_mmio(struct pci_bus *child)
>>   	unsigned long base, limit;
>>   	struct pci_bus_region region;
>>   	struct resource *res;
>> +	int ea_ent;
>>
>>   	res = child->resource[1];
>> +	ea_ent = pci_ea_find_ent_with_prop(dev, PCI_EA_P_BRIDGE_MEM);
>> +	if (ea_ent > 0 && !pci_ea_decode_ent(dev, ea_ent, res)) {
>> +		dev_dbg(&dev->dev, "  bridge window %pR via EA\n", res);
>> +		return;
>> +	}
>>   	pci_read_config_word(dev, PCI_MEMORY_BASE, &mem_base_lo);
>>   	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
>
> Don't we want to use the EA window (instead of whatever is written in base limit)?

See above.

>
>>   	base = ((unsigned long) mem_base_lo & PCI_MEMORY_RANGE_MASK) << 16;
>> @@ -401,8 +414,14 @@ static void pci_read_bridge_mmio_pref(struct pci_bus *child)
>>   	pci_bus_addr_t base, limit;
>>   	struct pci_bus_region region;
>>   	struct resource *res;
>> +	int ea_ent;
>>
>>   	res = child->resource[2];
>> +	ea_ent = pci_ea_find_ent_with_prop(dev, PCI_EA_P_BRIDGE_MEM_PREFETCH);
>> +	if (ea_ent > 0 && !pci_ea_decode_ent(dev, ea_ent, res)) {
>> +		dev_dbg(&dev->dev, "  bridge window %pR via EA\n", res);
>> +		return;
>> +	}
>>   	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
>>   	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
>
> Don't we want to use the EA window (instead of whatever is written in base limit)?

See above.

>
>>   	base64 = (mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
>> @@ -801,8 +820,24 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
>>
>>   	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
>>   	primary = buses & 0xFF;
>> -	secondary = (buses >> 8) & 0xFF;
>> -	subordinate = (buses >> 16) & 0xFF;
>> +	if (dev->ea_cap) {
>> +		u32 sdw;
>> +
>> +		pci_read_config_dword(dev, dev->ea_cap + 4, &sdw);
>> +		if (sdw & 0xFF)
>> +			secondary = sdw & 0xFF;
>> +		else
>> +			secondary = (buses >> 8) & 0xFF;
>> +
>> +		sdw >>= 8;
>> +		if (sdw & 0xFF)
>> +			subordinate = sdw & 0xFF;
>> +		else
>> +			subordinate = (buses >> 16) & 0xFF;
>> +	} else {
>> +		secondary = (buses >> 8) & 0xFF;
>> +		subordinate = (buses >> 16) & 0xFF;
>> +	}
>
> We could refactor this to avoid duplicate assignment lines.
> What if we did something like this:
>
> 	secondary = (buses >> 8) & 0xFF;
> 	subordinate = (buses >> 16) & 0xFF;
> 	if (dev->ea_cap) {
> 		u32 sdw;
>
> 		pci_read_config_dword(dev, dev->ea_cap + 4, &sdw);
>
> 		if (sdw & 0xFF)
> 			secondary = sdw & 0xFF;
>
> 		sdw >>= 8;
> 		if (sdw & 0xFF)
> 			subordinate = sdw & 0xFF;
> 	}
>

Yes.

>
>>
>>   	dev_dbg(&dev->dev, "scanning [bus %02x-%02x] behind bridge, pass %d\n",
>>   		secondary, subordinate, pass);
>> @@ -1598,6 +1633,9 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
>>
>>   static void pci_init_capabilities(struct pci_dev *dev)
>>   {
>> +	/* Enhanced Allocation */
>> +	pci_ea_init(dev);
>> +
>>   	/* MSI/MSI-X list */
>>   	pci_msi_init_pci_dev(dev);
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index 508cc56..1158c71 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -1026,6 +1026,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>>   	if (!b_res)
>>   		return -ENOSPC;
>>
>> +	if (b_res->flags & IORESOURCE_PCI_FIXED)
>> +		return 0; /* Fixed from EA, we cannot change it */
>> +
>
> Other things set the IORESOURCE_PCI_FIXED flag, we can't assume that it was because of EA.

I think that means a comment change only.  Doesn't it?


>
>>   	memset(aligns, 0, sizeof(aligns));
>>   	max_order = 0;
>>   	size = 0;
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index b505b50..41b85ed 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -384,6 +384,7 @@ struct pci_dev {
>>   	phys_addr_t rom; /* Physical address of ROM if it's not from the BAR */
>>   	size_t romlen; /* Length of ROM if it's not from the BAR */
>>   	char *driver_override; /* Driver name to force a match */
>> +	u8		ea_cap;		/* Enhanced Allocation capability offset */
>>   };
>>
>>   static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
>> --
>> 1.9.1
>>
