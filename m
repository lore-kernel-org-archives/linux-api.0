From: Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Wed, 25 Mar 2015 10:00:25 +1000
Message-ID: <CAPM=9tyM9AxX-RHhbO-LK+LTyQC6YjwW67pZM1XjbL35+counA@mail.gmail.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
	<CAPj87rN4pXHukDRD-e=ZrO1hcts04cSz1Hr9TNAgicGVWE5_-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPj87rN4pXHukDRD-e=ZrO1hcts04cSz1Hr9TNAgicGVWE5_-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:VIRTIO CORE, NET..." <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 25 March 2015 at 08:50, Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org> wrote:
> Hi,
>
> On 24 March 2015 at 16:07, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> +static int virtio_gpu_crtc_page_flip(struct drm_crtc *crtc,
>> +                                    struct drm_framebuffer *fb,
>> +                                    struct drm_pending_vblank_event *event,
>> +                                    uint32_t flags)
>> +{
>> +       return -EINVAL;
>> +}
>
> I'm not going to lie, I was really hoping the 5th (?) GPU option for
> Qemu would support pageflipping. Daniel's comment about conversion to
> atomic is relevant, but: do you have a mechanism which allows you to
> post updates (e.g. 'start displaying this buffer now please') that
> allows you to get events back when they have actually been displayed?

Page flip is implemented in a later patch,

https://www.kraxel.org/cgit/linux/commit/?h=virtio-gpu&id=1e167e8e964f8e08100d315dd354cc0a4b090841

Since its a long way from an actual display, finding out when
something is actually displayed is hard,
but when we've posted it to the frontbuffer should be fine.

Dave.
