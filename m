From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Tue, 31 May 2016 08:55:17 +0200
Message-ID: <CAKMK7uEK867bF+cdvoA=FyFo-zw7UwK9Bzi2boVFLQ0R4wSh3w@mail.gmail.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
	<20150324165057.GN1349@phenom.ffwll.local>
	<1427718227.3372.33.camel@nilsson.home.kraxel.org>
	<20150330144927.GN23521@phenom.ffwll.local>
	<CAKMK7uFUNT193f5djZD6T8cgRxxnZL73yrqbupPHOd2P-+Y=pQ@mail.gmail.com>
	<1464335302.10663.10.camel@redhat.com>
	<20160527090313.GX27098@phenom.ffwll.local>
	<1464616236.5179.41.camel@redhat.com>
	<20160530144755.GK27098@phenom.ffwll.local>
	<1464676160.5978.24.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464676160.5978.24.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:VIRTIO CORE, NET..." <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 31, 2016 at 8:29 AM, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>  but it also means that
>> atomic userspace can't use hotspots before we add properties to fbs. And
>> doing that is a bit tricky since drm_framebuffer objects are meant to be
>> invariant - this assumption is deeply in-grained into the code all over
>> the place, everything just compares pointers when semantically it means to
>> compare the entire fb (including backing storage pointer/offsets and
>> everything).
>
> Hmm, the hotspot location for a given cursor image is invariant too, so
> I don't think that would be a big issue.
>
> I'd expect userspace define a bunch of cursors, then switch between them
> (instead of defining a single cursor, then constantly updating it).

Agreed, conceptually it would be a really nice fit to put the hotspot
into the invariant drm_framebuffer. I just meant to say that you need
to add a bit of new uapi to make it happen, since we can't reuse our
existing get/set_prop functions (since those only change props after
the object is created). And we also can't use our existing ioctls to
enumerate properties of an object (since chicken-egg: you want the
list of properties before creating a new framebuffer, so can't use
that framebuffer to enumerate them).

But really not a big concern.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
