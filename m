From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v5 0/4] PCI: Add support for PCI Enhanced Allocation
 "BARs"
Date: Thu, 15 Oct 2015 09:06:57 -0500
Message-ID: <20151015140657.GB12958@localhost>
References: <1444175438-7443-1-git-send-email-ddaney.cavm@gmail.com>
 <5FE5E296BC647B42A2509AB982F88C1321D86B95@ORSMSX108.amr.corp.intel.com>
 <20151014161731.GA3029@sean.stalley.intel.com>
 <561E8221.7070701@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <561E8221.7070701@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Daney <ddaney@caviumnetworks.com>
Cc: "Sean O. Stalley" <sean.stalley@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, David Daney <ddaney.cavm@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Rafal Milecki <zajec5@gmail.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "yinghai@kernel.org" <yinghai@kernel.org>, "rajatxjain@gmail.com" <rajatxjain@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 14, 2015 at 09:26:09AM -0700, David Daney wrote:
> On 10/14/2015 09:17 AM, Sean O. Stalley wrote:
> >Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
> >
> 
> Thanks a lot Sean.
> 
> I think you cannot SOB if the patches are not flowing through you
> (as may be the case for my two additions).  Perhaps a Tested-by: or
> Acked-by: would be more appropriate.
> 
> >I tested it out with the QEMU EA Patches here:
> >	[https://lists.nongnu.org/archive/html/qemu-devel/2015-07/msg00348.html]
> >
> >Also, I found 1 trivial typo in the commit message of PATCH 1/4:
> >	"Signed-off-by: Signed-off-by: David Daney <david.daney@cavium.com>"
> 
> Aargh!  I need to be more careful.
> 
> In any case, what should be the next course of action?
> 
>   A) I receive Tested-by/Acked-by from Sean, and resend the four patches?
> 
>   B) Bjorn takes these as is, but fixes the headers as needed.
> 
> Bjorn, what do you think?

You do not need to repost patches just to add Tested-by/Acked-by/etc.

I can also fix trivial things like your Signed-off-by typo.

Bjorn
