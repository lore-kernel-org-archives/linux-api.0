From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Thu, 26 Mar 2015 09:53:49 +0100
Message-ID: <20150326085349.GP1349@phenom.ffwll.local>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
 <20150324165057.GN1349@phenom.ffwll.local>
 <1427295189.23304.6.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427295189.23304.6.camel-3OfP5uLMi4C46o+2HkPkLj4oCIwMql/M@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:VIRTIO CORE, NET..." <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 25, 2015 at 03:53:09PM +0100, Gerd Hoffmann wrote:
> > > Signed-off-by: Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Standard request from my side for new drm drivers (especially if they're
> > this simple): Can you please update the drivers to latest drm internal
> > interfaces, i.e. using universal planes and atomic?
> 
> Have a docs / sample code pointer for me?

Picking any of the recently converted drivers or recently merged atomic
drivers should be fairly informative. Overall conversion procedure is
detailed in

http://blog.ffwll.ch/2014/11/atomic-modeset-support-for-kms-drivers.html
http://blog.ffwll.ch/2015/01/update-for-atomic-display-updates.html

And ofc there's the kerneldoc stuff in the drm docbook. If you have
questions probably best to ask them in #dri-devel irc, most of the people
who've done atomic conversions hang out there and can help out.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
