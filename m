From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Thu, 26 Mar 2015 09:18:01 +0100
Message-ID: <20150326091545-mutt-send-email-mst@redhat.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
 <20150324171255-mutt-send-email-mst@redhat.com>
 <1427295121.23304.5.camel@nilsson.home.kraxel.org>
 <20150325162246-mutt-send-email-mst@redhat.com>
 <1427297836.23304.29.camel@nilsson.home.kraxel.org>
 <20150325180721-mutt-send-email-mst@redhat.com>
 <1427353959.9779.2.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427353959.9779.2.camel-3OfP5uLMi4C46o+2HkPkLj4oCIwMql/M@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:VIRTIO CORE, NET..." <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 26, 2015 at 08:12:39AM +0100, Gerd Hoffmann wrote:
> On Mi, 2015-03-25 at 18:09 +0100, Michael S. Tsirkin wrote:
> > On Wed, Mar 25, 2015 at 04:37:16PM +0100, Gerd Hoffmann wrote:
> > >   Hi,
> > > 
> > > > BTW can we teach virtio-gpu to look for framebuffer using
> > > > virtio pci caps?
> > > 
> > > The virtio-gpu driver doesn't matter much here, it doesn't use it
> > > anyway.
> > > 
> > > >  Or are there limitations such as only
> > > > using IO port BARs, or compatibility with
> > > > BIOS code etc that limit us to specific BARs anyway?
> > > 
> > > Yes, vgabios code needs to know.  Currently it has bar #2 for the vga
> > > framebuffer bar hardcoded.  It's 16bit code.  I don't feel like making
> > > the probing more complicated ...
> > > 
> > > cheers,
> > >   Gerd
> > 
> > OK - you are saying all VGA cards use bar #2 for this
> > functionality, so we are just following
> > established practice here?
> 
> vgabios checks pci ids to figure.  qxl+stdvga use bar #0, vmware-vga bar
> #1, virtio-vga bar #2.
> 
> cheers,
>   Gerd
> 

And is it possible to use offset within BAR and/or memory BARs?
If yes I'd strongly prefer this.
As for writing 16 bit code, I need to do this for virtio scsi/blk
anyway, so we'll be able to share code.

-- 
MST
