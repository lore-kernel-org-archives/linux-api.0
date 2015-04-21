From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 8/8] macvtap/tun: add VNET_BE flag
Date: Tue, 21 Apr 2015 20:30:23 +0200
Message-ID: <20150421202542-mutt-send-email-mst@redhat.com>
References: <20150410101500.31843.61248.stgit@bahia.local>
 <20150410101923.31843.66853.stgit@bahia.local>
 <20150421160538-mutt-send-email-mst@redhat.com>
 <20150421182220.33257bd6@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150421182220.33257bd6-GiB8zCg7hOfDOqzlkpFKJg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 21, 2015 at 06:22:20PM +0200, Greg Kurz wrote:
> On Tue, 21 Apr 2015 16:06:33 +0200
> "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Fri, Apr 10, 2015 at 12:20:21PM +0200, Greg Kurz wrote:
> > > The VNET_LE flag was introduced to fix accesses to virtio 1.0 headers
> > > that are always little-endian. It can also be used to handle the special
> > > case of a legacy little-endian device implemented by a big-endian host.
> > > 
> > > Let's add a flag and ioctls for big-endian devices as well. If both flags
> > > are set, little-endian wins.
> > > 
> > > Since this is isn't a common usecase, the feature is controlled by a kernel
> > > config option (not set by default).
> > > 
> > > Both macvtap and tun are covered by this patch since they share the same
> > > API with userland.
> > > 
> > > Signed-off-by: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > > ---
> > >  drivers/net/Kconfig         |   12 ++++++++
> > >  drivers/net/macvtap.c       |   60 +++++++++++++++++++++++++++++++++++++++++-
> > >  drivers/net/tun.c           |   62 ++++++++++++++++++++++++++++++++++++++++++-
> > >  include/uapi/linux/if_tun.h |    2 +
> > >  4 files changed, 134 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > > index df51d60..f0e23a0 100644
> > > --- a/drivers/net/Kconfig
> > > +++ b/drivers/net/Kconfig
> > > @@ -244,6 +244,18 @@ config TUN
> > >  
> > >  	  If you don't know what to use this for, you don't need it.
> > >  
> > > +config TUN_VNET_BE
> > > +	bool "Support for big-endian vnet headers"
> > > +	default n
> > > +	---help---
> > > +	  This option allows TUN/TAP and MACVTAP device drivers to parse
> > > +	  vnet headers that are in big-endian byte order. It is useful
> > > +	  when the headers come from a big-endian legacy virtio driver and
> > > +	  the host is little-endian.
> > > +
> > > +	  Unless you have a little-endian system hosting a big-endian virtual
> > > +	  machine with a virtio NIC, you should say N.
> > > +
> > 
> > should mention cross-endian, not big-endian, right?
> > 
> 
> The current TUN_VNET_LE related code is already doing cross-endian: without
> this patch, one can already run a LE guest on a BE host... wouldn't it be
> confusing to mention cross-endian only when the guest is BE ?

Hmm I think no - LE is also useful for virtio 1 - this is what it was
intended for after all.

> What about having a completely distinct implementation for cross-endian that
> don't reuse the existing code and defines then ?

I think implementation and interface are fine, just the documentation
can be improved a bit.

How about:
	"Support for cross-endian vnet headers on little-endian kernels".

Accordingly CONFIG_TUN_VNET_CROSS_LE

?

-- 
MST
