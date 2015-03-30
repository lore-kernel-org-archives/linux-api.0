From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Mon, 30 Mar 2015 16:49:27 +0200
Message-ID: <20150330144927.GN23521@phenom.ffwll.local>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
 <20150324165057.GN1349@phenom.ffwll.local>
 <1427718227.3372.33.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427718227.3372.33.camel@nilsson.home.kraxel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, virtio-dev@lists.oasis-open.org, "Michael S. Tsirkin" <mst@redhat.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, Dave Airlie <airlied@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 02:23:47PM +0200, Gerd Hoffmann wrote:
>   Hi,
> 
> > > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > 
> > Standard request from my side for new drm drivers (especially if they're
> > this simple): Can you please update the drivers to latest drm internal
> > interfaces, i.e. using universal planes and atomic?
> 
> Up'n'running.  Incremental patch:
> 
> https://www.kraxel.org/cgit/linux/commit/?h=virtio-gpu-2d&id=b8edf4f38a1ec5a50f6ac8948521a12f862d3d5a
> 
> v2 coming, but I'll go over the other reviews first.

Looking good. Wrt pageflip the current MO is to handroll it in your
driver, common approach is to use the msm async commit implementation
msm_atomic_commit. The issue is simply that right now there's still no
useable generic vblank callback support (drm_irq.c is a mess) hence why
the core helpers don't support async flips yet.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
