From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH v4 5/5] PCI: Handle Enhanced Allocation (EA) capability
 for bridges
Date: Mon, 5 Oct 2015 16:01:45 -0700
Message-ID: <56130159.6000909@caviumnetworks.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
 <1443825476-26880-6-git-send-email-ddaney.cavm@gmail.com>
 <20151005225405.GC4821@sean.stalley.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151005225405.GC4821@sean.stalley.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Sean O. Stalley" <sean.stalley@intel.com>, David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On 10/05/2015 03:54 PM, Sean O. Stalley wrote:
> On Fri, Oct 02, 2015 at 03:37:56PM -0700, David Daney wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> PCI bridges may have their properties be specified via EA entries.
>>
>> Extend the EA parser to extract the bridge resources, and modify
>> pci_read_bridge_{io,mmio,mmio_pref}() to use resources previously
>> obtained via EA.
>>
>> Save the offset to the EA capability in struct pci_dev, and use it to
>> easily find the EA bridge subordinate and secondary bus numbers.
>>
>> When assigning the bridge resources a couple of changes are required
>> so that the EA obtained IORESOURCE_PCI_FIXED are not resized, and
>> correctly linked into the resource tree.
>>
>> 1) In pbus_size_mem() do not attempt to resize the bridge resources if
>>     they are marked as IORESOURCE_PCI_FIXED.
>>
>> 2) In pci_bus_alloc_from_region()for IORESOURCE_PCI_FIXED resources, just
>>     try to request the resource as is, without attempting to resize it.
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> ---
>>   drivers/pci/bus.c       |  7 +++++++
>>   drivers/pci/pci.c       | 13 +++++++++++++
>>   drivers/pci/probe.c     | 31 +++++++++++++++++++++++++++++--
>>   drivers/pci/setup-bus.c |  3 +++
>>   include/linux/pci.h     |  1 +
>>   5 files changed, 53 insertions(+), 2 deletions(-)
>> @@ -801,8 +813,23 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
>>
>>   	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
>>   	primary = buses & 0xFF;
>> -	secondary = (buses >> 8) & 0xFF;
>> -	subordinate = (buses >> 16) & 0xFF;
>> +	if (dev->ea_cap) {
>> +		u32 dw1;
>> +
>> +		pci_read_config_dword(dev, dev->ea_cap + 4, &dw1);
>> +		if (dw1 & 0xFF)
>> +			secondary = dw1 & 0xFF;
>> +		else
>> +			secondary = (buses >> 8) & 0xFF;
>> +
>> +		if ((dw1 >> 8) & 0xFF)
>> +			subordinate = (dw1 >> 8) & 0xFF;
>> +		else
>> +			subordinate = (buses >> 16) & 0xFF;
>> +	} else {
>> +		secondary = (buses >> 8) & 0xFF;
>> +		subordinate = (buses >> 16) & 0xFF;
>> +	}
>
> We can refactor this to make it cleaner/more compact. from V3 review:
>
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

Yes, that is cleaner.  I think I didn't read the comments on v3 closely 
enough.  I will switch to doing it this way.

Thanks,
David Daney


>
> -Sean
>
