From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH v4 3/5] PCI: Handle IORESOURCE_PCI_FIXED when sizing and
 assigning resources.
Date: Mon, 5 Oct 2015 15:44:12 -0700
Message-ID: <20151005224412.GB4821@sean.stalley.intel.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
 <1443825476-26880-4-git-send-email-ddaney.cavm@gmail.com>
 <CAE9FiQWnE3ucbjPKuXm5qhTGx7bYOBqnNoSNOMaJa_tEf3Z4=Q@mail.gmail.com>
 <560F158C.4040303@caviumnetworks.com>
 <CAE9FiQVr9E4w80ZSeTgKKwbGQ=NQiReSRnfoGF3D3+3NXj-G3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQVr9E4w80ZSeTgKKwbGQ=NQiReSRnfoGF3D3+3NXj-G3Q@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Daney <ddaney@caviumnetworks.com>, David Daney <ddaney.cavm@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, Rajat Jain <rajatxjain@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 02, 2015 at 08:00:20PM -0700, Yinghai Lu wrote:
> On Fri, Oct 2, 2015 at 4:38 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> > On 10/02/2015 04:14 PM, Yinghai Lu wrote:
> >>
> >> https://patchwork.kernel.org/patch/7304371/
> >> [v6,06/53] PCI: Claim fixed resource during remove/rescan path
> >
> >
> > This one is interesting, but I don't think it will work.
> >
> > pci_claim_resource() calls pci_find_parent_resource(), which will fail in
> > important use cases.
> >
> > It is perfectly legal for a bridge provisioned by EA to not specify any
> > resources.  In this case we must walk up the bus tree until we find
> > something that contains the device resource, and can thus be a parent.
> >
> > That is a big part of what my patch is doing.
> 
> looks we need another resource flags for EA in addition to
> FIXED as it could out side of bridge MMIO range.

I think I get what you are saying, but let me check.

If a bridge gets reconfigured, it needs to be able to tell if this resource is EA or not.
If it is a fixed EA resource, it doesn't need to include it in its MMIO range.
If it is fixed for some other reason,
	we should make sure the bridges MMIO range includes the fixed region.

You are suggesting that we should add a flag for EA, so if a bridge tries to move,
the bridge knows weather or not the resource is EA,
and therefore if it needs to worry about the resource when setting it's range?

Is that what you are trying to say?

-Sean
