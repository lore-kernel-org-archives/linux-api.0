From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Wed, 25 Mar 2015 18:09:06 +0100
Message-ID: <20150325180721-mutt-send-email-mst@redhat.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
 <20150324171255-mutt-send-email-mst@redhat.com>
 <1427295121.23304.5.camel@nilsson.home.kraxel.org>
 <20150325162246-mutt-send-email-mst@redhat.com>
 <1427297836.23304.29.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <virtio-dev-return-682-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <1427297836.23304.29.camel@nilsson.home.kraxel.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 25, 2015 at 04:37:16PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > BTW can we teach virtio-gpu to look for framebuffer using
> > virtio pci caps?
> 
> The virtio-gpu driver doesn't matter much here, it doesn't use it
> anyway.
> 
> >  Or are there limitations such as only
> > using IO port BARs, or compatibility with
> > BIOS code etc that limit us to specific BARs anyway?
> 
> Yes, vgabios code needs to know.  Currently it has bar #2 for the vga
> framebuffer bar hardcoded.  It's 16bit code.  I don't feel like making
> the probing more complicated ...
> 
> cheers,
>   Gerd

OK - you are saying all VGA cards use bar #2 for this
functionality, so we are just following
established practice here?

-- 
MST
