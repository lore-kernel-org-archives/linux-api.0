From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/86] pci: export pci_ids.h
Date: Mon, 30 Mar 2015 10:31:54 +0200
Message-ID: <20150330101830-mutt-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
 <1427635734-24786-2-git-send-email-mst@redhat.com>
 <20150329204047.GA5902@kroah.com>
 <20150330083707-mutt-send-email-mst@redhat.com>
 <20150330065522.GA10105@kroah.com>
 <20150330085617-mutt-send-email-mst@redhat.com>
 <20150330075331.GA17823@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150330075331.GA17823-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Masahiro Yamada <yamada.m-NAum8xwdG0+S7A1Ibl2khg@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Stephane Eranian <eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang Rui <ray.huang-5C7GfCeVMHo@public.gmane.org>, Peter Neubauer <pneubauer-OUHTSVaU61M6GL+IUqp+Xg@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 09:53:31AM +0200, Greg KH wrote:
> On Mon, Mar 30, 2015 at 09:15:26AM +0200, Michael S. Tsirkin wrote:
> > On Mon, Mar 30, 2015 at 08:55:22AM +0200, Greg KH wrote:
> > > On Mon, Mar 30, 2015 at 08:48:44AM +0200, Michael S. Tsirkin wrote:
> > > > On Sun, Mar 29, 2015 at 10:40:47PM +0200, Greg KH wrote:
> > > > > On Sun, Mar 29, 2015 at 03:37:01PM +0200, Michael S. Tsirkin wrote:
> > > > > > The macros in pci_ids.h are pretty useful for userspace
> > > > > > using the pci sysfs interface.
> > > > > > At the moment userspace is forced to duplicate these macros
> > > > > > (e.g. QEMU does this), it is better to expose them in
> > > > > > /usr/include/linux/pci_ids.h so everyone can just include
> > > > > > this header.
> > > > > > 
> > > > > > Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > > ---
> > > > > >  include/linux/pci_ids.h      | 2998 +-----------------------------------------
> > > > > >  include/uapi/linux/pci_ids.h | 2997 +++++++++++++++++++++++++++++++++++++++++
> > > > > 
> > > > > No, please use the pci ids file from the upstream pci id database
> > > > > instead.
> > > > 
> > > > 
> > > > >  We shouldn't be putting these all in one file,
> > > > 
> > > > pci.txt says:
> > > > 	Please add PCI_VENDOR_ID_xxx for vendors
> > > > You want to change this policy, and get rid of
> > > > vendor ids in pci_ids.h completely?
> > > 
> > > Please read the top of pci_ids.h.  It hasn't had new ids added to it in
> > > a long time.
> > 
> > OK, looks like pci.txt should be fixed then.
> 
> Please send a patch.  As the original PCI kernel maintainer, I don't
> think I ever noticed pci.txt.  It was last "updated" in 2006...
> 
> > > Why would userspace need the pci id of anything?
> > 
> > Look at how they are used e.g. by QEMU, seabios, gpxe.
> > People want to say e.g. "find all network class devices".
> 
> Then use libpci.
> 
> > >  Again, just use
> > > libpci, isn't it fast enough?  Don't duplicate existing logic.
> > 
> > This really depends on whether you want something else that
> > libpci provides. But if I just want e.g. standard class IDs,
> > I don't want to depend on libpci.
> 
> Why not?  Don't duplicate things that already are there just for this
> very use.
> 
> Don't make us do kernel changes just because you don't want to depend on
> either of the two different userspace packages that provide this
> information in a standard way for userspace.  Your system will have one
> of those two packages in it, depending on it isn't a "burden" at all.
> 
> > > Or use the hw database that libudev exports, which is already on your
> > > machine and exports all of the pci ids from libpci directly.
> > 
> > Same argument really.
> 
> Because you don't want to depend on existing packages, doesn't mean we
> have to accept kernel changes and maintain them for forever, as you are
> now creating a new api that we will have to keep up to date and correct
> for all time.
> 
> Again, depend on the packages that are already doing this work please.
> 

Maintaining correct class IDs is more or less a requirement
for kernel to work properly, isn't it?

Wouldn't the same thing apply to pci_regs.h?
Why does it make sense to export PCI_CLASS_REVISION
so I know where to read the class value from
configuration, but not what the values are?

> > > > Standard class IDs are even sillier to duplicate.
> > > 
> > > Again, why does userspace need this?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Mostly because it has a userspace driver, or is emulating
> > a hardware device.
> > 
> > For example, the VFIO driver uses the PCI hardware formats
> > as it's userspace/kernel interface. This means I need
> > a ton of PCI constants in userspace. Most of them are
> > already in pci_regs.h, and so exported. No problem here.
> > 
> > However class and prog interface IDs are not, they
> > are in pci_ids.h
> > 
> > Would you support splitting pci_ids.h to
> > include/uapi/linux/pci_ids.h with standard headers
> > and include/linux/pci_ids.h with device/vendor
> > specific ones?
> 
> No, again, please use the "standard" Linux apis for these, don't
> duplicate work and make people do more work over the long-term than is
> needed.
> 
> thanks,
> 
> greg k-h

What's the work you refer to?  This is just hardware description it
can't change and doesn't need to be maintained.

-- 
MST
