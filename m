From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 0/2] PCI: Add support for PCI Enhanced Allocation "BARs"
Date: Wed, 23 Sep 2015 17:25:45 -0700
Message-ID: <CAE9FiQVnppKTcmbxRoTTniYst8CWQ8_XV8fsU1wa34nGjmcxJA@mail.gmail.com>
References: <1443047264-4003-1-git-send-email-sean.stalley@intel.com>
	<CAE9FiQXYzcEnagnAZ_agXXSVssAfVD8tBjKh9ox_ajqKG0v27g@mail.gmail.com>
	<20150923235109.GA4384@sean.stalley.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150923235109.GA4384@sean.stalley.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Sean O. Stalley" <sean.stalley@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rajat Jain <rajatxjain@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 23, 2015 at 4:51 PM, Sean O. Stalley <sean.stalley@intel.com> wrote:
> IORESOURCE_PCI_FIXED is set in pci_ea_set_flags():
>
>         +static unsigned long pci_ea_set_flags(struct pci_dev *dev, u8 prop)
>         +{
>         +       unsigned long flags = IORESOURCE_PCI_FIXED;
>         +
>         +
>
> Which is called in pci_ea_read(), and passed to res->flags (if there aren't any errors):

ok.
