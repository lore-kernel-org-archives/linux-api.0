From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [virtio-dev] Re: [PATCH] Add virtio gpu driver.
Date: Thu, 26 Mar 2015 12:53:56 +0100
Message-ID: <20150326124751-mutt-send-email-mst@redhat.com>
References: <20150324171255-mutt-send-email-mst@redhat.com>
 <1427295121.23304.5.camel@nilsson.home.kraxel.org>
 <20150325162246-mutt-send-email-mst@redhat.com>
 <1427297836.23304.29.camel@nilsson.home.kraxel.org>
 <20150325180721-mutt-send-email-mst@redhat.com>
 <1427353959.9779.2.camel@nilsson.home.kraxel.org>
 <20150326091545-mutt-send-email-mst@redhat.com>
 <1427359367.9779.9.camel@nilsson.home.kraxel.org>
 <20150326095736-mutt-send-email-mst@redhat.com>
 <1427369923.9779.18.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427369923.9779.18.camel-3OfP5uLMi4C46o+2HkPkLj4oCIwMql/M@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:VIRTIO CORE, NET..." <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 26, 2015 at 12:38:43PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > Absolutely, it's pretty common to mix regions in a BAR.
> > For example, we have virtio kick (ioeventfd backed,
> > handled in kernel) in same BAR as common and device
> > specific configuration.
> 
> > We did the same thing you are now doing with the
> > virtio BAR, and now we have to maintain two code
> > bases, virtio pci config was designed to be future proof
> > so why not use it?
> 
> It's not about virtio at all.  It's about vga compatibility, so we have
> a simple framebuffer as boot display.  Only used when virtio is *not*
> enabled.
> 

I don't know. This seems exactly like the kind of thing
we had in mind when we added the virtio pci capability.
For example, we have text in spec that requires drivers
to skip unknown capabilities.

And yes, if bios pokes at a specific bar then we do
need to list this info in the virtio spec so this makes
it an issue that is virtio related.


> > This is mostly just making sure we don't paint ourselves into a corner.
> 
> It's a simple memory bar.  vga cards have that since pci was invented
> (standalone ones, chipset graphics aside), and there havn't been
> fundamental changes ...
> 
> cheers,
>   Gerd
> 

Yes, it's not about what we put there now. It's about being able
to move things about in the future without breaking guests.

-- 
MST
