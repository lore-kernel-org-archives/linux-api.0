From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Thu, 19 Mar 2015 09:27:04 -0700
Message-ID: <20150319162704.GE30732@dtor-ws>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
 <1426756391-26585-2-git-send-email-kraxel@redhat.com>
 <CANq1E4TDj4pq3J_BVc=Yuzo5dVR=QcNexVUqaqwjg7Qi5_xX4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANq1E4TDj4pq3J_BVc=Yuzo5dVR=QcNexVUqaqwjg7Qi5_xX4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 19, 2015 at 01:29:49PM +0100, David Herrmann wrote:
> Hi
> 
> (CC: Dmitry)
> 
> On Thu, Mar 19, 2015 at 10:13 AM, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > virtio-input is basically evdev-events-over-virtio, so this driver isn't
> > much more than reading configuration from config space and forwarding
> > incoming events to the linux input layer.
> >
> > Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/virtio/Kconfig            |  10 ++
> >  drivers/virtio/Makefile           |   1 +
> >  drivers/virtio/virtio_input.c     | 313 ++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/virtio_ids.h   |   1 +
> >  include/uapi/linux/virtio_input.h |  65 ++++++++
> >  5 files changed, 390 insertions(+)
> >  create mode 100644 drivers/virtio/virtio_input.c
> >  create mode 100644 include/uapi/linux/virtio_input.h
> >
> > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > index b546da5..cab9f3f 100644
> > --- a/drivers/virtio/Kconfig
> > +++ b/drivers/virtio/Kconfig
> > @@ -48,6 +48,16 @@ config VIRTIO_BALLOON
> >
> >          If unsure, say M.
> >
> > +config VIRTIO_INPUT
> > +       tristate "Virtio input driver"
> > +       depends on VIRTIO
> > +       depends on INPUT
> > +       ---help---
> > +        This driver supports virtio input devices such as
> > +        keyboards, mice and tablets.
> > +
> > +        If unsure, say M.
> > +
> >   config VIRTIO_MMIO
> >         tristate "Platform bus driver for memory mapped virtio devices"
> >         depends on HAS_IOMEM
> > diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> > index d85565b..41e30e3 100644
> > --- a/drivers/virtio/Makefile
> > +++ b/drivers/virtio/Makefile
> > @@ -4,3 +4,4 @@ obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
> >  virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
> >  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
> >  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
> > +obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
> > diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
> > new file mode 100644
> > index 0000000..2d425cf
> > --- /dev/null
> > +++ b/drivers/virtio/virtio_input.c
> > @@ -0,0 +1,313 @@
> > +#include <linux/module.h>
> > +#include <linux/virtio.h>
> > +#include <linux/input.h>
> > +
> > +#include <uapi/linux/virtio_ids.h>
> > +#include <uapi/linux/virtio_input.h>
> > +
> > +struct virtio_input {
> > +       struct virtio_device       *vdev;
> > +       struct input_dev           *idev;
> > +       char                       name[64];
> > +       char                       serial[64];
> > +       char                       phys[64];
> > +       struct virtqueue           *evt, *sts;
> > +       struct virtio_input_event  evts[64];
> > +};
> > +
> > +static ssize_t serial_show(struct device *dev,
> > +                          struct device_attribute *attr, char *buf)
> > +{
> > +       struct input_dev *idev = to_input_dev(dev);
> > +       struct virtio_input *vi = input_get_drvdata(idev);
> > +       return sprintf(buf, "%s\n", vi->serial);
> > +}
> > +static DEVICE_ATTR_RO(serial);

What is serial? Serial number?

> > +
> > +static struct attribute *dev_attrs[] = {
> > +       &dev_attr_serial.attr,
> > +       NULL
> > +};
> > +
> > +static umode_t dev_attrs_are_visible(struct kobject *kobj,
> > +                                    struct attribute *a, int n)
> > +{
> > +       struct device *dev = container_of(kobj, struct device, kobj);
> > +       struct input_dev *idev = to_input_dev(dev);
> > +       struct virtio_input *vi = input_get_drvdata(idev);
> > +
> > +       if (a == &dev_attr_serial.attr && !strlen(vi->serial))
> > +               return 0;
> > +
> > +       return a->mode;
> > +}
> > +
> > +static struct attribute_group dev_attr_grp = {
> > +       .attrs =        dev_attrs,
> > +       .is_visible =   dev_attrs_are_visible,
> > +};
> > +
> > +static const struct attribute_group *dev_attr_groups[] = {
> > +       &dev_attr_grp,
> > +       NULL
> > +};
> > +
> > +static void virtinput_queue_evtbuf(struct virtio_input *vi,
> > +                                  struct virtio_input_event *evtbuf)
> > +{
> > +       struct scatterlist sg[1];
> > +
> > +       sg_init_one(sg, evtbuf, sizeof(*evtbuf));
> > +       virtqueue_add_inbuf(vi->evt, sg, 1, evtbuf, GFP_ATOMIC);
> > +}
> > +
> > +static void virtinput_recv_events(struct virtqueue *vq)
> > +{
> > +       struct virtio_input *vi = vq->vdev->priv;
> > +       struct virtio_input_event *event;
> > +       unsigned int len;
> > +
> > +       while ((event = virtqueue_get_buf(vi->evt, &len)) != NULL) {
> > +               input_event(vi->idev,
> > +                           le16_to_cpu(event->type),
> > +                           le16_to_cpu(event->code),
> > +                           le32_to_cpu(event->value));
> > +               virtinput_queue_evtbuf(vi, event);
> > +       }
> > +       virtqueue_kick(vq);
> > +}
> > +
> > +static int virtinput_send_status(struct virtio_input *vi,
> > +                                u16 type, u16 code, s32 value)
> > +{
> > +       struct virtio_input_event *stsbuf;
> > +       struct scatterlist sg[1];
> > +
> > +       stsbuf = kzalloc(sizeof(*stsbuf), GFP_ATOMIC);
> > +       if (!stsbuf)
> > +               return -ENOMEM;
> > +
> > +       stsbuf->type  = cpu_to_le16(type);
> > +       stsbuf->code  = cpu_to_le16(code);
> > +       stsbuf->value = cpu_to_le32(value);
> > +       sg_init_one(sg, stsbuf, sizeof(*stsbuf));
> > +       virtqueue_add_outbuf(vi->sts, sg, 1, stsbuf, GFP_ATOMIC);
> > +       virtqueue_kick(vi->sts);
> 
> GFP_ATOMIC, eww. But everyone does that for input_event() callbacks..
> we should fix that for user-space input one day.
> 
> > +       return 0;
> > +}
> > +
> > +static void virtinput_recv_status(struct virtqueue *vq)
> > +{
> > +       struct virtio_input *vi = vq->vdev->priv;
> > +       struct virtio_input_event *stsbuf;
> > +       unsigned int len;
> > +
> > +       while ((stsbuf = virtqueue_get_buf(vi->sts, &len)) != NULL)
> > +               kfree(stsbuf);
> > +       virtqueue_kick(vq);
> > +}
> > +
> > +static int virtinput_status(struct input_dev *idev, unsigned int type,
> > +                           unsigned int code, int value)
> > +{
> > +       struct virtio_input *vi = input_get_drvdata(idev);
> > +
> > +       return virtinput_send_status(vi, type, code, value);
> > +}
> > +
> > +static size_t virtinput_cfg_select(struct virtio_input *vi,
> > +                                  u8 select, u8 subsel)
> > +{
> > +       u8 size;
> > +
> > +       virtio_cwrite(vi->vdev, struct virtio_input_config, select, &select);
> > +       virtio_cwrite(vi->vdev, struct virtio_input_config, subsel, &subsel);
> > +       virtio_cread(vi->vdev, struct virtio_input_config, size, &size);
> > +       return size;
> > +}
> > +
> > +static void virtinput_cfg_bits(struct virtio_input *vi, int select, int subsel,
> > +                              unsigned long *bits, unsigned int bitcount)
> > +{
> > +       unsigned int bit;
> > +       size_t bytes;
> > +       u8 cfg = 0;
> > +
> > +       bytes = virtinput_cfg_select(vi, select, subsel);
> > +       if (!bytes)
> > +               return;
> > +       if (bitcount > bytes*8)
> > +               bitcount = bytes*8;
> > +       if (select == VIRTIO_INPUT_CFG_EV_BITS)
> > +               set_bit(subsel, vi->idev->evbit);
> > +       for (bit = 0; bit < bitcount; bit++) {
> > +               if ((bit % 8) == 0)
> > +                       virtio_cread(vi->vdev, struct virtio_input_config,
> > +                                    u.bitmap[bit/8], &cfg);
> > +               if (cfg & (1 << (bit % 8)))
> > +                       set_bit(bit, bits);
> > +       }
> > +}
> > +
> > +static void virtinput_cfg_abs(struct virtio_input *vi, int abs)
> > +{
> > +       u32 size, mi, ma, fu, fl;
> > +
> > +       size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ABS_INFO, abs);
> > +       virtio_cread(vi->vdev, struct virtio_input_config, u.abs.min, &mi);
> > +       virtio_cread(vi->vdev, struct virtio_input_config, u.abs.max, &ma);
> > +       virtio_cread(vi->vdev, struct virtio_input_config, u.abs.fuzz, &fu);
> > +       virtio_cread(vi->vdev, struct virtio_input_config, u.abs.flat, &fl);
> 
> abs.resolution is missing. Please add it, we really also need to add
> it to uinput one day.
> 
> > +       input_set_abs_params(vi->idev, abs,
> > +                            le32_to_cpu(mi), le32_to_cpu(ma),
> > +                            le32_to_cpu(fu), le32_to_cpu(fl));
> > +}
> > +
> > +static int virtinput_init_vqs(struct virtio_input *vi)
> > +{
> > +       struct virtqueue *vqs[2];
> > +       vq_callback_t *cbs[] = { virtinput_recv_events,
> > +                                virtinput_recv_status };
> > +       const char *names[] = { "events", "status" };
> > +       int i, err, size;
> > +
> > +       err = vi->vdev->config->find_vqs(vi->vdev, 2, vqs, cbs, names);
> > +       if (err)
> > +               return err;
> > +       vi->evt = vqs[0];
> > +       vi->sts = vqs[1];
> > +
> > +       size = virtqueue_get_vring_size(vi->evt);
> > +       if (size > ARRAY_SIZE(vi->evts))
> > +               size = ARRAY_SIZE(vi->evts);
> > +       for (i = 0; i < size; i++)
> > +               virtinput_queue_evtbuf(vi, &vi->evts[i]);
> > +
> > +       return 0;
> > +}
> > +
> > +static int virtinput_probe(struct virtio_device *vdev)
> > +{
> > +       struct virtio_input *vi;
> > +       size_t size;
> > +       int abs, err;
> > +
> > +       vi = kzalloc(sizeof(*vi), GFP_KERNEL);
> > +       if (!vi) {
> > +               err = -ENOMEM;
> > +               goto out1;
> > +       }
> > +       vdev->priv = vi;
> > +       vi->vdev = vdev;
> > +
> > +       err = virtinput_init_vqs(vi);
> > +       if (err)
> > +               goto out2;
> > +
> > +       vi->idev = input_allocate_device();
> > +       if (!vi->idev) {
> > +               err = -ENOMEM;
> > +               goto out3;
> > +       }
> > +       input_set_drvdata(vi->idev, vi);
> > +
> > +       size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_NAME, 0);
> > +       virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config, u),
> > +                          vi->name, min(size, sizeof(vi->name)));
> > +       size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_SERIAL, 0);
> > +       virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config, u),
> > +                          vi->serial, min(size, sizeof(vi->serial)));
> > +       snprintf(vi->phys, sizeof(vi->phys),
> > +                "virtio%d/input0", vdev->index);
> > +
> > +       virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_PROP_BITS, 0,
> > +                          vi->idev->propbit, INPUT_PROP_CNT);
> > +       size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_REP);
> > +       if (size)
> > +               set_bit(EV_REP, vi->idev->evbit);
> > +
> > +       vi->idev->name = vi->name;
> > +       vi->idev->phys = vi->phys;
> 
> Can you set vi->idev->uniq to the virtio-bus path?

No, uniq can't be phys as phys is unique within the system while uniq is
like serial number or UUID and should never repeat.

Thanks.

-- 
Dmitry
