From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Fri, 20 Mar 2015 10:55:07 +0100
Message-ID: <CANq1E4QLPSK6NVeEx6yihYPdF-XPpXx4rKv0deHwX+s2RzFHCg@mail.gmail.com>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	<1426756391-26585-2-git-send-email-kraxel@redhat.com>
	<CANq1E4TDj4pq3J_BVc=Yuzo5dVR=QcNexVUqaqwjg7Qi5_xX4Q@mail.gmail.com>
	<1426844885.32097.36.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426844885.32097.36.camel-3OfP5uLMi4C46o+2HkPkLj4oCIwMql/M@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Fri, Mar 20, 2015 at 10:48 AM, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>   Hi,
>
>> > +static int virtinput_send_status(struct virtio_input *vi,
>> > +                                u16 type, u16 code, s32 value)
>> > +{
>> > +       struct virtio_input_event *stsbuf;
>> > +       struct scatterlist sg[1];
>> > +
>> > +       stsbuf = kzalloc(sizeof(*stsbuf), GFP_ATOMIC);
>> > +       if (!stsbuf)
>> > +               return -ENOMEM;
>> > +
>> > +       stsbuf->type  = cpu_to_le16(type);
>> > +       stsbuf->code  = cpu_to_le16(code);
>> > +       stsbuf->value = cpu_to_le32(value);
>> > +       sg_init_one(sg, stsbuf, sizeof(*stsbuf));
>> > +       virtqueue_add_outbuf(vi->sts, sg, 1, stsbuf, GFP_ATOMIC);
>> > +       virtqueue_kick(vi->sts);
>>
>> GFP_ATOMIC, eww. But everyone does that for input_event() callbacks..
>
> Yea, did it this way because I saw it elsewhere.
>
>> we should fix that for user-space input one day.
>
> Sounds like I have to use GFP_ATOMIC and can't switch to GFP_KERNEL,
> correct?

You cannot use GFP_KERNEL in this context, correct. GFP_ATOMIC is also
what all HID backends do, so it's fine here.

>> > +       size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ABS_INFO, abs);
>> > +       virtio_cread(vi->vdev, struct virtio_input_config, u.abs.min, &mi);
>> > +       virtio_cread(vi->vdev, struct virtio_input_config, u.abs.max, &ma);
>> > +       virtio_cread(vi->vdev, struct virtio_input_config, u.abs.fuzz, &fu);
>> > +       virtio_cread(vi->vdev, struct virtio_input_config, u.abs.flat, &fl);
>>
>> abs.resolution is missing. Please add it, we really also need to add
>> it to uinput one day.
>
> Ok.  How should I handle cases where the resolution is either not known
> or not fixed?  Just leave it zero?

Leave it 0, which is what you already do by not assigning it.

>> > +       vi->idev->name = vi->name;
>> > +       vi->idev->phys = vi->phys;
>>
>> Can you set vi->idev->uniq to the virtio-bus path?
>>
>> > +       vi->idev->id.bustype = BUS_VIRTUAL;
>> > +       vi->idev->id.vendor  = 0x0001;
>> > +       vi->idev->id.product = 0x0001;
>> > +       vi->idev->id.version = 0x0100;
>>
>> Please don't hardcode those. All user-space based interaction with
>> input-devices relies on those IDs. Can we retrieve it from the host
>> just like the name?
>
> Yes, we can.
>
> There will be emulated devices, i.e. the input coming from
> vnc/gtk/whatever will be sent to the virtio devices (instead of ps/2 or
> usb).  For these we should probably have fixed IDs per device.  There
> are keyboard/mouse/tablet at the moment.  Suggestions how to pick IDs?
>
> There will also be pass-through support, i.e. qemu
> opening /dev/input/event<nr> and forwarding everything to the guest.
> How should that be handled best?  Copy all four from the host?  Even
> though the bustype is BUS_USB?  Not sure this actually improves things
> because the guest can match the device, or whenever this confuses apps
> due to BUS_USB being applied to virtio devices ...

Lemme give an example: We have databases in user-space, that allow
applications to figure out the mouse DPI values of a device. Those
databases match on all four, bus+vid+pid+ver (sometimes even more,
like name and dmi). If one of those is not forwarded, it will not be
detected.

I'd like to see all four forwarded from the host. I'd be fine with
"bus" being set to VIRTUAL, but I'm not sure why that would be a good
thing to do?

Thanks
David
