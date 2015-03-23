From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Mon, 23 Mar 2015 08:53:58 +0100
Message-ID: <1427097238.6365.27.camel@nilsson.home.kraxel.org>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	<1426756391-26585-2-git-send-email-kraxel@redhat.com>
	<20150319123940-mutt-send-email-mst@redhat.com>
	<1426847327.32097.60.camel@nilsson.home.kraxel.org>
	<20150321225356-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150321225356-mutt-send-email-mst@redhat.com>
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

> > > > +		if (cfg & (1 << (bit % 8)))
> > > > +			set_bit(bit, bits);
> > > 
> > > what if not set? does something clear the mask?
> > 
> > kzalloc?
> 
> So you are really just reading in array of bytes?
> All this set bit trickery is just to convert things from LE?

Trickery?  Just checking each bit from virtio config space, then set it
in the input layer bitmap.  It's a simple stupid loop.

Surely not the most efficient way, but hey, it's not in the hot path and
I'm sure I'm setting the bits correctly because this uses the standard
linux kernel bitops.

> At least, this needs a comment explaining what the function does,
> and maybe wrap it in a helper like virtio_input_bitmap_copy or
> virtio_bitmap_or.

Can do that, sure.

> > > > +	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ABS_INFO, abs);
> > > > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.min, &mi);
> > > > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.max, &ma);
> > > > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.fuzz, &fu);
> > > > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.flat, &fl);
> > > 
> > > you read le field into u32 value.
> > > Please run sparse on this code. you will get a ton
> > > of warnings. Same error appears elsewhere.
> > 
> > Indeed.  IIRC that wasn't the case a while back.  Guess those bitwise
> > annotations have been added with the virtio 1.0 patches?
> > 
> > In any case I'll fix it up.
> 
> I see you still didn't in v2?

v2 builds fine without sparse warnings.  virtio_cread handles swapping
if needed and returns native endian, so I have to store this in normal
u32 variables and pass it on to the input layer as-is.

> You are doing leXXX everywhere, that's VERSION_1 dependency.
> virtio_cread will do byteswaps differently without VERSION_1.
> Just don't go there.

Changed that for v2, for the config space structs.  They have normal u32
in there now.  virtio_cread() wants it this way.

cheers,
  Gerd
