From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 2/2] PCI: Add support for Enhanced Allocation devices
Date: Wed, 2 Sep 2015 13:01:27 -0700
Message-ID: <20150902200127.GA3347@sean.stalley.intel.com>
References: <1440089947-2839-1-git-send-email-sean.stalley@intel.com>
 <1440089947-2839-3-git-send-email-sean.stalley@intel.com>
 <CAE9FiQUQacSJXPqv9GQJ4AF0TN7uxcBiAYHVbHwvFhEfWgWKHg@mail.gmail.com>
 <20150902174612.GA2700@sean.stalley.intel.com>
 <CAErSpo4qZ9AXskyo86gXG1cb3AqCn-HB05nj7qT9wovZdLt2Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAErSpo4qZ9AXskyo86gXG1cb3AqCn-HB05nj7qT9wovZdLt2Tg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Rajat Jain <rajatxjain@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 02, 2015 at 02:25:50PM -0500, Bjorn Helgaas wrote:
> On Wed, Sep 2, 2015 at 12:46 PM, Sean O. Stalley <sean.stalley@intel.com> wrote:
> 
> > Would it be better to modify pci_claim_resource() to support EA instead of adding pci_ea_claim_resource()?
> > That way, EA entries would be claimed at the same time as traditional BARs.
> 
> Yes, I think so.

Ok, I'll make it work this way in the next patchset.

> Why wouldn't pci_claim_resource() work as-is for EA?  I see that
> pci_ea_get_parent_resource() defaults to iomem_resource or
> ioport_resource if we don't find a parent, but I don't understand why
> that's necessary.

EA resources may (or may not) be in the parent's range[1].
If the parent doesn't describe this range, we want to default to the top-level resource.
Other than that case, I think pci_claim_resource would work as-is.

-Sean

[1] From the EA ECN:
For a bridge function that is permitted to implement EA based on the rules above, it is
permitted, but not required, for the bridge function to use EA mechanisms to indicate
resource ranges that are located behind the bridge Function (see Section 6.9.1.2).
