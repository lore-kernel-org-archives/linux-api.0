From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v4 3/5] PCI: Handle IORESOURCE_PCI_FIXED when sizing and
 assigning resources.
Date: Fri, 2 Oct 2015 16:14:08 -0700
Message-ID: <CAE9FiQWnE3ucbjPKuXm5qhTGx7bYOBqnNoSNOMaJa_tEf3Z4=Q@mail.gmail.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
	<1443825476-26880-4-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443825476-26880-4-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, Rajat Jain <rajatxjain@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 2, 2015 at 3:37 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
>
> The new Enhanced Allocation (EA) capability support creates resources
> with the IORESOURCE_PCI_FIXED set.  This creates a couple of problems:
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

Can you check if

https://patchwork.kernel.org/patch/7304971/
[v6,05/53] PCI: Don't release fixed resource for realloc

https://patchwork.kernel.org/patch/7304371/
[v6,06/53] PCI: Claim fixed resource during remove/rescan path

address the the problem that you met?

        Yinghai
