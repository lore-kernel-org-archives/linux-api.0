From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH v3 2/2] PCI: Add support for Enhanced Allocation devices
Date: Tue, 29 Sep 2015 16:53:20 -0700
Message-ID: <560B2470.9080100@caviumnetworks.com>
References: <1443485439-12081-1-git-send-email-ddaney.cavm@gmail.com> <1443485439-12081-3-git-send-email-ddaney.cavm@gmail.com> <20150929192737.GA2517@sean.stalley.intel.com> <560AF3D7.80908@gmail.com> <20150929224727.GB2517@sean.stalley.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150929224727.GB2517@sean.stalley.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Sean O. Stalley" <sean.stalley@intel.com>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On 09/29/2015 03:47 PM, Sean O. Stalley wrote:
[...]
>>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>>> index 6a9a111..7c60b16 100644
>>>> --- a/drivers/pci/pci.c
>>>> +++ b/drivers/pci/pci.c
>>>> @@ -2148,6 +2148,284 @@ void pci_pm_init(struct pci_dev *dev)
>>>>   	}
>>>>   }
>>>>
>>>> +static unsigned long pci_ea_set_flags(struct pci_dev *dev, u8 prop)
>>>> +{
>>>> +	unsigned long flags = IORESOURCE_PCI_FIXED | IORESOURCE_SIZEALIGN;
>>>
>>> Why did you add the IORESOURCE_SIZEALIGN flag? EA allows for unaligned resources.
>>
>> pci_bus_assign_resources() fails causing the devices to be unusable
>> if resource_alignment() returns zero.  The easiest fix for this was
>> to specify IORESOURCE_SIZEALIGN.
>>
>> An alternative would be to change the code in setup-bus.c so that
>> for IORESOURCE_PCI_FIXED resources, it didn't barf.
>
> I would do this alternative, but with a IORESOURCE_PCI_EA flag.
>

I don't think we need IORESOURCE_PCI_EA.  If a resource is tagged as 
IORESOURCE_PCI_FIXED that means that it cannot be changed, we shouldn't 
care why it is fixed (due to an EA capability for example).  We just 
need to gracefully handle IORESOURCE_PCI_FIXED in the places where 
things currently go wrong.

David Daney
