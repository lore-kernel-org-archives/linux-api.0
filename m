From: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Wed, 25 May 2016 17:44:55 +0100
Message-ID: <CACvgo53ADmgiSHaHiUdwtO50un0exKXiaqkjScmp0VhmCCXEbA@mail.gmail.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
	<20150324165057.GN1349@phenom.ffwll.local>
	<1427718227.3372.33.camel@nilsson.home.kraxel.org>
	<20150330144927.GN23521@phenom.ffwll.local>
	<CAKMK7uFUNT193f5djZD6T8cgRxxnZL73yrqbupPHOd2P-+Y=pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKMK7uFUNT193f5djZD6T8cgRxxnZL73yrqbupPHOd2P-+Y=pQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:VIRTIO CORE, NET..." <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 25 May 2016 at 17:40, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> On Mon, Mar 30, 2015 at 4:49 PM, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
>> On Mon, Mar 30, 2015 at 02:23:47PM +0200, Gerd Hoffmann wrote:
>>> > > Signed-off-by: Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> > > Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> >
>>> > Standard request from my side for new drm drivers (especially if they're
>>> > this simple): Can you please update the drivers to latest drm internal
>>> > interfaces, i.e. using universal planes and atomic?
>>>
>>> Up'n'running.  Incremental patch:
>>>
>>> https://www.kraxel.org/cgit/linux/commit/?h=virtio-gpu-2d&id=b8edf4f38a1ec5a50f6ac8948521a12f862d3d5a
>>>
>>> v2 coming, but I'll go over the other reviews first.
>>
>> Looking good. Wrt pageflip the current MO is to handroll it in your
>> driver, common approach is to use the msm async commit implementation
>> msm_atomic_commit. The issue is simply that right now there's still no
>> useable generic vblank callback support (drm_irq.c is a mess) hence why
>> the core helpers don't support async flips yet.
>
> I guess I didn't do a good job at looking at your v2: Cursor is still
> using legacy interfaces and not a proper plane. Would be awesome if
> you could fix that up. Atomic drivers really shouldn't use the legacy
> cursor interfaces any more at all.

Wild idea:
Worth adding if (drm_core_check_feature(dev, DRIVER_ATOMIC)  {
printf("abort abort"); return; }
style of checks for the legacy (preatomic) kms helpers ?

Or does it feel like an overkill ?

-Emil
