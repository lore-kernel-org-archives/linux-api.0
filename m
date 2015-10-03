From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v4 3/5] PCI: Handle IORESOURCE_PCI_FIXED when sizing and
 assigning resources.
Date: Fri, 2 Oct 2015 20:00:20 -0700
Message-ID: <CAE9FiQVr9E4w80ZSeTgKKwbGQ=NQiReSRnfoGF3D3+3NXj-G3Q@mail.gmail.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
	<1443825476-26880-4-git-send-email-ddaney.cavm@gmail.com>
	<CAE9FiQWnE3ucbjPKuXm5qhTGx7bYOBqnNoSNOMaJa_tEf3Z4=Q@mail.gmail.com>
	<560F158C.4040303@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <560F158C.4040303@caviumnetworks.com>
Sender: linux-pci-owner@vger.kernel.org
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, Rajat Jain <rajatxjain@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 2, 2015 at 4:38 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> On 10/02/2015 04:14 PM, Yinghai Lu wrote:
>>
>> https://patchwork.kernel.org/patch/7304371/
>> [v6,06/53] PCI: Claim fixed resource during remove/rescan path
>
>
> This one is interesting, but I don't think it will work.
>
> pci_claim_resource() calls pci_find_parent_resource(), which will fail in
> important use cases.
>
> It is perfectly legal for a bridge provisioned by EA to not specify any
> resources.  In this case we must walk up the bus tree until we find
> something that contains the device resource, and can thus be a parent.
>
> That is a big part of what my patch is doing.

looks we need another resource flags for EA in addition to
FIXED as it could out side of bridge MMIO range.

>
> As for the merits of assigning fixed resources from the FINAL fixup, rather
> than in __pci_bus_assign_resources(), I am unsure.

usually __pci_bus_assign_resources() is used for unassigned one. so
I don't want it mixed with request resource there.

Thanks

Yinghai
