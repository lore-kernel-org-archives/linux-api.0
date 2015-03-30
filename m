From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 01/86] pci: export pci_ids.h
Date: Mon, 30 Mar 2015 08:48:44 +0200
Message-ID: <20150330083707-mutt-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
 <1427635734-24786-2-git-send-email-mst@redhat.com>
 <20150329204047.GA5902@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150329204047.GA5902@kroah.com>
Sender: linux-doc-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Alexei Starovoitov <ast@plumgrid.com>, stephen hemminger <stephen@networkplumber.org>, Masahiro Yamada <yamada.m@jp.panasonic.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephane Eranian <eranian@google.com>, Huang Rui <ray.huang@amd.com>, Peter Neubauer <pneubauer@bluerwhite.org>, linux-pci@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Mar 29, 2015 at 10:40:47PM +0200, Greg KH wrote:
> On Sun, Mar 29, 2015 at 03:37:01PM +0200, Michael S. Tsirkin wrote:
> > The macros in pci_ids.h are pretty useful for userspace
> > using the pci sysfs interface.
> > At the moment userspace is forced to duplicate these macros
> > (e.g. QEMU does this), it is better to expose them in
> > /usr/include/linux/pci_ids.h so everyone can just include
> > this header.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/pci_ids.h      | 2998 +-----------------------------------------
> >  include/uapi/linux/pci_ids.h | 2997 +++++++++++++++++++++++++++++++++++++++++
> 
> No, please use the pci ids file from the upstream pci id database
> instead.


>  We shouldn't be putting these all in one file,

pci.txt says:
	Please add PCI_VENDOR_ID_xxx for vendors
You want to change this policy, and get rid of
vendor ids in pci_ids.h completely?
Bjorn, what do you think of this?

>  and pulling
> them out of drivers isn't ok.

This patchset is not pulling any files out of drivers fwiw.

> Userspace shouldn't need to know any of these, use libpci.

Unless I'm mistaken, libpci does not export a header with defines. It
has a text file pci.ids, but parsing that when all I want is e.g. locate
all intel devices is just too much overhead. No one wants that, so
people just duplicate headers.

Standard class IDs are even sillier to duplicate.


> thanks,
> 
> greg k-h
