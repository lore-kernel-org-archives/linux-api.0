From: David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Thu, 19 Mar 2015 18:16:37 +0100
Message-ID: <CANq1E4Sh74p0+U36FUWNctr=jiKkuSgK6w-9FiSsOZ7PbtJG5g@mail.gmail.com>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	<1426756391-26585-2-git-send-email-kraxel@redhat.com>
	<CANq1E4TDj4pq3J_BVc=Yuzo5dVR=QcNexVUqaqwjg7Qi5_xX4Q@mail.gmail.com>
	<20150319162704.GE30732@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150319162704.GE30732@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, mst@redhat.com, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hey

On Thu, Mar 19, 2015 at 5:27 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Mar 19, 2015 at 01:29:49PM +0100, David Herrmann wrote:
[...]
>> > +static int virtinput_probe(struct virtio_device *vdev)
>> > +{
>> > +       struct virtio_input *vi;
>> > +       size_t size;
>> > +       int abs, err;
>> > +
>> > +       vi = kzalloc(sizeof(*vi), GFP_KERNEL);
>> > +       if (!vi) {
>> > +               err = -ENOMEM;
>> > +               goto out1;
>> > +       }
>> > +       vdev->priv = vi;
>> > +       vi->vdev = vdev;
>> > +
>> > +       err = virtinput_init_vqs(vi);
>> > +       if (err)
>> > +               goto out2;
>> > +
>> > +       vi->idev = input_allocate_device();
>> > +       if (!vi->idev) {
>> > +               err = -ENOMEM;
>> > +               goto out3;
>> > +       }
>> > +       input_set_drvdata(vi->idev, vi);
>> > +
>> > +       size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_NAME, 0);
>> > +       virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config, u),
>> > +                          vi->name, min(size, sizeof(vi->name)));
>> > +       size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_SERIAL, 0);
>> > +       virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config, u),
>> > +                          vi->serial, min(size, sizeof(vi->serial)));
>> > +       snprintf(vi->phys, sizeof(vi->phys),
>> > +                "virtio%d/input0", vdev->index);
>> > +
>> > +       virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_PROP_BITS, 0,
>> > +                          vi->idev->propbit, INPUT_PROP_CNT);
>> > +       size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_REP);
>> > +       if (size)
>> > +               set_bit(EV_REP, vi->idev->evbit);
>> > +
>> > +       vi->idev->name = vi->name;
>> > +       vi->idev->phys = vi->phys;
>>
>> Can you set vi->idev->uniq to the virtio-bus path?
>
> No, uniq can't be phys as phys is unique within the system while uniq is
> like serial number or UUID and should never repeat.

...sorry, my bad! We should still forward it from the host, imo. It's
really handy for applications to re-detect devices.

Thanks
David
