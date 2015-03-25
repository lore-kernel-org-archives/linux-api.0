From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Wed, 25 Mar 2015 16:24:53 +0100
Message-ID: <20150325162246-mutt-send-email-mst@redhat.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
 <20150324171255-mutt-send-email-mst@redhat.com>
 <1427295121.23304.5.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427295121.23304.5.camel-3OfP5uLMi4C46o+2HkPkLj4oCIwMql/M@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:VIRTIO CORE, NET..." <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 25, 2015 at 03:52:01PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> > > index e894eb2..a3167fa 100644
> > > --- a/drivers/virtio/virtio_pci_common.c
> > > +++ b/drivers/virtio/virtio_pci_common.c
> > > @@ -510,7 +510,7 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
> > >  		goto err_enable_device;
> > >  
> > >  	rc = pci_request_regions(pci_dev, "virtio-pci");
> > > -	if (rc)
> > > +	if (rc && ((pci_dev->class >> 8) != PCI_CLASS_DISPLAY_VGA))
> > >  		goto err_request_regions;
> > >  
> > >  	if (force_legacy) {
> > 
> > This is probably what you described as "the only concern?
> 
> Ahem, no, forgot that one,

What does the concern refer to then?

> but it is related.  With vesafb using and
> registering the vga compat framebuffer bar pci_request_regions will not
> succeed.
> 
> vesafb will be unregistered later on (this is what I was refering to) by
> the virtio-gpu driver.
> 
> > If we only need to request specific
> > regions, I think we should do exactly that, requesting only parts of
> > regions that are covered by the virtio capabilities.
> 
> That should work too.
> 
> cheers,
>   Gerd

BTW can we teach virtio-gpu to look for framebuffer using
virtio pci caps? Or are there limitations such as only
using IO port BARs, or compatibility with
BIOS code etc that limit us to specific BARs anyway?

-- 
MST
