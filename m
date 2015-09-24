From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH v2 0/2] PCI: Add support for PCI Enhanced Allocation
 "BARs"
Date: Thu, 24 Sep 2015 09:39:46 -0700
Message-ID: <20150924163945.GA7240@sean.stalley.intel.com>
References: <1443047264-4003-1-git-send-email-sean.stalley@intel.com>
 <56034505.1080301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56034505.1080301@gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: bhelgaas@google.com, yinghai@kernel.org, rajatxjain@gmail.com, mst@redhat.com, zajec5@gmail.com, gong.chen@linux.intel.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi David,

My response is inline. Let me know if you have any questions.

Thanks for taking a look,
Sean

On Wed, Sep 23, 2015 at 05:34:13PM -0700, David Daney wrote:
> Hi Sean,
> 
> Thanks for doing this, I think we will use it for Cavium ThunderX.
> A couple of questions...
> 
> 
> On 09/23/2015 03:27 PM, Sean O. Stalley wrote:
> >PCI Enhanced Allocation is a new method of allocating MMIO & IO
> >resources for PCI devices & bridges. It can be used instead
> >of the traditional PCI method of using BARs.
> >
> >EA entries are hardware-initialized to a fixed address.
> >Unlike BARs, regions described by EA are cannot be moved.
> >Because of this, only devices which are permanently connected to
> >the PCI bus can use EA. A removable PCI card must not use EA.
> >
> >This patchset adds support for using EA entries instead of BARs
> >on Root Complex Integrated Endpoints.
> >
> >The Enhanced Allocation ECN is publicly available here:
> >https://www.pcisig.com/specifications/conventional/ECN_Enhanced_Allocation_23_Oct_2014_Final.pdf
> >
> >
> >Changes from V1:
> >	- Use generic PCI resource claim functions (instead of EA-specific functions)
> >	- Only add support for RCiEPs (instead of all devices).
> 
> Why not all devices?  The spec. allows for EA on devices behind bridges.

The short answer is that adding support for EA bridges would be a much larger change.
EA bridges can do some weird stuff, like fixing bus numbers & using resources not in the base+limit window.

See the conversation I had with Bjorn on the original patchset for the details.
[ https://lkml.org/lkml/2015/9/3/497 ]

> >	- Removed some debugging messages leftover from early testing.
> >
> >
> >Sean O. Stalley (2):
> >   PCI: Add Enhanced Allocation register entries
> >   PCI: Add support for Enhanced Allocation devices
> >
> >  drivers/pci/pci.c             | 174 ++++++++++++++++++++++++++++++++++++++++++
> >  drivers/pci/pci.h             |   1 +
> >  drivers/pci/probe.c           |   3 +
> >  include/uapi/linux/pci_regs.h |  40 +++++++++-
> >  4 files changed, 217 insertions(+), 1 deletion(-)
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
