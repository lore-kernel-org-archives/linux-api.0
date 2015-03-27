From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [virtio-dev] Re: [PATCH] Add virtio gpu driver.
Date: Fri, 27 Mar 2015 09:08:26 +0100
Message-ID: <1427443706.22166.10.camel@nilsson.home.kraxel.org>
References: <20150325162246-mutt-send-email-mst@redhat.com>
	 <1427297836.23304.29.camel@nilsson.home.kraxel.org>
	 <20150325180721-mutt-send-email-mst@redhat.com>
	 <1427353959.9779.2.camel@nilsson.home.kraxel.org>
	 <20150326091545-mutt-send-email-mst@redhat.com>
	 <1427359367.9779.9.camel@nilsson.home.kraxel.org>
	 <20150326095736-mutt-send-email-mst@redhat.com>
	 <1427369923.9779.18.camel@nilsson.home.kraxel.org>
	 <20150326124751-mutt-send-email-mst@redhat.com>
	 <1427382436.8786.15.camel@nilsson.home.kraxel.org>
	 <20150326174401-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150326174401-mutt-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

  Hi,

> > 
> > Completely different thing crossing my mind:  I think we can make
> > virtio-vga fully compatible with stdvga.  stdvga has two bars, memory
> > (#0) and mmio (#2).  We can make the mmio bar larger and place all the
> > virtio regions there.
> > 
> 
> Full compatibility with some standard sounds like a better motivation,
> yes.

Ok, I'll look into it.

> > I think in any case I'll go split off the vga compatibility bits to a
> > different patch (and possible a separate patch series).
> > 
> > cheers,
> >   Gerd
> 
> Will you still need me to change core to claim specific memory only?

That would be great, yes.  The resource conflict with vesafb/efifb will
stay no matter how we design the pci resource layout of virtio-vga.

cheers,
  Gerd
