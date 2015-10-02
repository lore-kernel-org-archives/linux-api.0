From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH v4 3/5] PCI: Handle IORESOURCE_PCI_FIXED when sizing and
 assigning resources.
Date: Fri, 2 Oct 2015 16:38:52 -0700
Message-ID: <560F158C.4040303@caviumnetworks.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com> <1443825476-26880-4-git-send-email-ddaney.cavm@gmail.com> <CAE9FiQWnE3ucbjPKuXm5qhTGx7bYOBqnNoSNOMaJa_tEf3Z4=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE9FiQWnE3ucbjPKuXm5qhTGx7bYOBqnNoSNOMaJa_tEf3Z4=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Daney <ddaney.cavm@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, Rajat Jain <rajatxjain@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On 10/02/2015 04:14 PM, Yinghai Lu wrote:
> On Fri, Oct 2, 2015 at 3:37 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> The new Enhanced Allocation (EA) capability support creates resources
>> with the IORESOURCE_PCI_FIXED set.  This creates a couple of problems:
>>
>> 1) Since these resources cannot be relocated or resized, their
>>     alignment is not really defined, and it is therefore not specified.
>>     This causes a problem in pbus_size_mem() where resources with
>>     unspecified alignment are disabled.
>>
>> 2) During resource assignment in pci_bus_assign_resources(),
>>     IORESOURCE_PCI_FIXED resources are not given a parent.  This, in
>>     turn, causes pci_enable_resources() to fail with a "not claimed"
>>     error.
>>
>> So, in pbus_size_mem() skip IORESOURCE_PCI_FIXED resources, instead of
>> disabling them.
>>
>> In __pci_bus_assign_resources(), for IORESOURCE_PCI_FIXED resources,
>> try to request the resource from a parent bus.
>
> Can you check if
>
> https://patchwork.kernel.org/patch/7304971/
> [v6,05/53] PCI: Don't release fixed resource for realloc


This one isn't relevant as the problem is seen when we are acquiring 
resources, not releasing them.

>
> https://patchwork.kernel.org/patch/7304371/
> [v6,06/53] PCI: Claim fixed resource during remove/rescan path

This one is interesting, but I don't think it will work.

pci_claim_resource() calls pci_find_parent_resource(), which will fail 
in important use cases.

It is perfectly legal for a bridge provisioned by EA to not specify any 
resources.  In this case we must walk up the bus tree until we find 
something that contains the device resource, and can thus be a parent.

That is a big part of what my patch is doing.

As for the merits of assigning fixed resources from the FINAL fixup, 
rather than in __pci_bus_assign_resources(), I am unsure.

Thanks,
David Daney


>
> address the the problem that you met?
>
>          Yinghai
>
