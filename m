From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Fri, 20 Mar 2015 11:28:47 +0100
Message-ID: <1426847327.32097.60.camel@nilsson.home.kraxel.org>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	<1426756391-26585-2-git-send-email-kraxel@redhat.com>
	<20150319123940-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150319123940-mutt-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

  Hi,

> > +static int virtinput_send_status(struct virtio_input *vi,
> > +				 u16 type, u16 code, s32 value)
> > +{
> > +	struct virtio_input_event *stsbuf;
> > +	struct scatterlist sg[1];
> > +
> > +	stsbuf = kzalloc(sizeof(*stsbuf), GFP_ATOMIC);
> > +	if (!stsbuf)
> > +		return -ENOMEM;
> 
> Does this return an error to userspace?
> If so it's not a good idea I think, GFP_ATOMIC failures are
> transient conditions and should not be reported
> to userspace.
> Can use GFP_KERNEL here?

Waiting for an answer from the ioput guys here.

> > +
> > +	stsbuf->type  = cpu_to_le16(type);
> > +	stsbuf->code  = cpu_to_le16(code);
> > +	stsbuf->value = cpu_to_le32(value);
> > +	sg_init_one(sg, stsbuf, sizeof(*stsbuf));
> > +	virtqueue_add_outbuf(vi->sts, sg, 1, stsbuf, GFP_ATOMIC);
> 
> This can fail if queue is full. What prevents this from happening?

Nothing.  It's highly unlikely though given the throughput we have for
input devices, not sure it is that useful to put too much effort into
this.  Except for freeing stsbuf in the error case.

> > +	virtqueue_kick(vi->sts);
> 
> Also what prevents multiple virtinput_send_status calls
> from racing with each other? Is there locking at a higher level?

I think input_dev->event_lock does this.

> > +static void virtinput_recv_status(struct virtqueue *vq)
> > +{
> > +	struct virtio_input *vi = vq->vdev->priv;
> > +	struct virtio_input_event *stsbuf;
> > +	unsigned int len;
> > +
> > +	while ((stsbuf = virtqueue_get_buf(vi->sts, &len)) != NULL)
> 
> looks like this get_buf can race with add above.

Yes, it can.

> Need some locking.

I'll add it.

> Also pls avoid != NULL, removing it makes code less verbose.
> 
> > +		kfree(stsbuf);
> > +	virtqueue_kick(vq);
> 
> Why are you kicking here?

Hmm, it is pointless indeed.

> > +	if (select == VIRTIO_INPUT_CFG_EV_BITS)
> > +		set_bit(subsel, vi->idev->evbit);
> > +	for (bit = 0; bit < bitcount; bit++) {
> > +		if ((bit % 8) == 0)
> > +			virtio_cread(vi->vdev, struct virtio_input_config,
> > +				     u.bitmap[bit/8], &cfg);
> 
> coding style violations above. you need spaces around ops like / and *.
> Please run checkpatch.pl
> 
> > +		if (cfg & (1 << (bit % 8)))
> > +			set_bit(bit, bits);
> 
> what if not set? does something clear the mask?

kzalloc?

> > +	}
> 
> doesn't above just implement bitmap_copy or bitmap_or?

Not fully sure how bitmaps are defined.  virtio has a stream of bytes,
first byte carries bits 0-7, second 8-15 etc.  linux kernel bitmaps ops
are operating on longs, and native byteorder longs would be something
else ...

> > +	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ABS_INFO, abs);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.min, &mi);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.max, &ma);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.fuzz, &fu);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.flat, &fl);
> 
> you read le field into u32 value.
> Please run sparse on this code. you will get a ton
> of warnings. Same error appears elsewhere.

Indeed.  IIRC that wasn't the case a while back.  Guess those bitwise
annotations have been added with the virtio 1.0 patches?

In any case I'll fix it up.

> > +static int virtinput_probe(struct virtio_device *vdev)
> > +{
> > +	struct virtio_input *vi;
> > +	size_t size;
> > +	int abs, err;
> 
> How about checking VERSION_1 and bailing out of not there?

I don't think this is needed.  There isn't a hard dependency on virtio
1.0.  It's just that config space is relatively large and because of
that I want it be 1.0 on the host (qemu) side to not allocate large
portions of I/O address space for the legacy virtio pci bar.

> > +	vi->idev->name = vi->name;
> > +	vi->idev->phys = vi->phys;
> > +	vi->idev->id.bustype = BUS_VIRTUAL;
> > +	vi->idev->id.vendor  = 0x0001;
> > +	vi->idev->id.product = 0x0001;
> > +	vi->idev->id.version = 0x0100;
> 
> Add comments explaining why these #s make sense?

See other subthread, will be changed to be host-provided (like name).

> > +	err = input_register_device(vi->idev);
> 
> Once you do this, virtinput_status can get called,
> and that will kick, correct?

Correct.

> If so, you must call device_ready before this.

Ok.

> > +	if (err)
> > +		goto out4;
> > +
> > +	return 0;
> > +
> > +out4:
> > +	input_free_device(vi->idev);
> > +out3:
> > +	vdev->config->del_vqs(vdev);
> > +out2:
> > +	kfree(vi);
> > +out1:
> > +	return err;
> 
> free on error is out of order with initialization.
> Might lead to leaks or other bugs.
> Also - can you name labels something sensible pls?
> out is usually for exiting on success too...
> E.g. out4 -> err_register etc.

Will fix.

> > +static void virtinput_remove(struct virtio_device *vdev)
> > +{
> > +	struct virtio_input *vi = vdev->priv;
> > +
> > +	input_unregister_device(vi->idev);
> > +	vdev->config->reset(vdev);
> 
> You don't really need a reset if you just to del_vqs.
> People do this if they want to prevent interrupts
> without deleting vqs.

Ok.

> > +	vdev->config->del_vqs(vdev);
> > +	kfree(vi);
> 
> free_device seems to be missing?

Indeed, good catch.

thanks,
  Gerd
