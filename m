From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 86/86] usb/dwc3: move ids to pci_ids.h
Date: Mon, 30 Mar 2015 08:58:10 +0200
Message-ID: <20150330065810.GA10508@kroah.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
 <1427635734-24786-87-git-send-email-mst@redhat.com>
 <20150329204200.GB5902@kroah.com>
 <20150330085001-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150330085001-mutt-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Peter Neubauer <pneubauer@bluerwhite.org>, Huang Rui <ray.huang@amd.com>, Jean Delvare <jdelvare@suse.de>, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 08:50:34AM +0200, Michael S. Tsirkin wrote:
> On Sun, Mar 29, 2015 at 10:42:00PM +0200, Greg Kroah-Hartman wrote:
> > On Sun, Mar 29, 2015 at 03:43:40PM +0200, Michael S. Tsirkin wrote:
> > > Comment says IDs should move to pci_ids.h, let's do it.
> > 
> > No, please remove the comment, it's not needed in pci_ids.h at all.
> 
> vendor ID does belong in pci_ids.h though, so says
> Documentation/PCI/pci.txt

Read the top of pci_ids.h please.
