From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [virtio-dev] Re: [PATCH v3] Add virtio-input driver.
Date: Tue, 24 Mar 2015 14:02:16 +0100
Message-ID: <20150324135908-mutt-send-email-mst@redhat.com>
References: <1427182321-19451-1-git-send-email-kraxel@redhat.com>
	<20150324105829-mutt-send-email-mst@redhat.com>
	<1427197581.18768.16.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1427197581.18768.16.camel@nilsson.home.kraxel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, David Herrmann <dh.herrmann@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 12:46:21PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > > +	spin_lock_irqsave(&vi->lock, flags);
> > > +	while ((event = virtqueue_get_buf(vi->evt, &len)) != NULL) {
> > > +		input_event(vi->idev,
> > > +			    le16_to_cpu(event->type),
> > > +			    le16_to_cpu(event->code),
> > > +			    le32_to_cpu(event->value));
> > 
> > What happens if input layer gets an
> > unexpected event code or value?
> 
> input layer checks it and ignores events not supported (according to the
> support bitmaps).

Right but support bitmaps come from host too, no?


> > > +static int virtinput_send_status(struct virtio_input *vi,
> > > +				 u16 type, u16 code, s32 value)
> > > +{
> 
> > This means that caller will get errors if it happens to call
> > send_status at a rate that's faster than host's consumption of them.
> > To me this looks wrong.
> > Poking at input layer, it seems to simply discard errors.
> > Is it always safe to discard status updates?
> 
> Typical use case is updating the leds of your keyboard.  Loosing one
> update isn't the end of the world.  Also that are _very_ low rate
> events, and in case that really actually happens you likely have bigger
> problems anyway ;)

Until QE opens a bug report I guess :)
OK but pls add a comment.

> > > +static void virtinput_cfg_bits(struct virtio_input *vi, int select, int subsel,
> > > +			       unsigned long *bits, unsigned int bitcount)
> > > +{
> > > +	unsigned int bit;
> > > +	size_t bytes;
> > > +	u8 *virtio_bits;
> > > +
> > > +	bytes = virtinput_cfg_select(vi, select, subsel);
> > > +	if (!bytes)
> > > +		return;
> > 
> > How about limiting bytes to sizeof struct virtio_input_config->u?
> 
> It's limited to 256 anyway because size is u8 in config space.

That struct is 128 bytes though.
Also, change bytes and virtinput_cfg_select to be u8 to make this
clearer?

> > > +	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_DEVIDS, 0);
> > > +	if (size >= 8) {
> > 
> > What does 8 mean here? Should be sizeof virtio_input_devids?
> 
> Yes, fixed.
> 
> > > +struct virtio_input_config {
> > > +	__u8    select;
> > > +	__u8    subsel;
> > > +	__u8    size;
> > > +	__u8    reserved;
> > > +	union {
> > > +		char string[128];
> > > +		__u8 bitmap[128];
> > 
> > I note that neither string nor bitmap are used by
> > driver. What are they in aid of?
> 
> Fixed.  Just sloppy coding, the name should use u.string, the bitmap
> u.bitmap, instead of just "u" (although for offsetof it doesn't make a
> difference).
> 
> cheers,
>   Gerd
> 
