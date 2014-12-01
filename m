From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Date: Mon, 1 Dec 2014 12:28:44 +0100
Message-ID: <20141201122844.1f0a0fa8.cornelia.huck@de.ibm.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092850.GD15607@redhat.com>
	<20141201110136.1ff29a67@thinkpad-w530>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20141201110136.1ff29a67@thinkpad-w530>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: thuth@linux.vnet.ibm.com, "Michael S. Tsirkin" <mst@redhat.com>, rusty@au1.ibm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Mon, 1 Dec 2014 11:01:36 +0100
David Hildenbrand <dahi@linux.vnet.ibm.com> wrote:

> > On Mon, Dec 01, 2014 at 09:16:41AM +0100, David Hildenbrand wrote:
> > > > Based on patch by Cornelia Huck.
> > > > 
> > > > Note: for consistency, and to avoid sparse errors,
> > > >       convert all fields, even those no longer in use
> > > >       for virtio v1.0.
> > > > 
> > > > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ...
> > > > 
> > > > -static unsigned int features[] = {
> > > > +static unsigned int features_legacy[] = {
> > > >  	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> > > >  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
> > > >  	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
> > > >  	VIRTIO_BLK_F_MQ,
> > > > +}
> > > > +;
> > > > +static unsigned int features[] = {
> > > > +	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> > > > +	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
> > > > +	VIRTIO_BLK_F_TOPOLOGY,
> > > > +	VIRTIO_BLK_F_MQ,
> > > > +	VIRTIO_F_VERSION_1,
> > > 
> > > We can fit this into less lines, like done for features_legacy.
> > 
> > Wrt packing code more tightly, I did it like this to
> > make it easier to compare the arrays.
> > Each flag is on the same line in original and new array.
> 
> This just looks inconsistent to me.
> 
> 1. features_legacy is tightly packed
> 2. half of features is tightly packed
> 
> So either all tightly packed or put every item on a single line. At least
> that's what I would do :)

I agree with the reasoning that this makes it easy to compare legacy
vs. standard at a glance, so I vote for keeping it this way.
