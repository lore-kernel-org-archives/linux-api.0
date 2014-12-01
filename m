From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Date: Mon, 1 Dec 2014 11:26:58 +0200
Message-ID: <20141201092658.GC15607@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20141201091641.3085e682@thinkpad-w530>
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
Cc: thuth@linux.vnet.ibm.com, rusty@au1.ibm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 01, 2014 at 09:16:41AM +0100, David Hildenbrand wrote:
> > Based on patch by Cornelia Huck.
> > 
> > Note: for consistency, and to avoid sparse errors,
> >       convert all fields, even those no longer in use
> >       for virtio v1.0.
> > 
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ...
> > 
> > -static unsigned int features[] = {
> > +static unsigned int features_legacy[] = {
> >  	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> >  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
> >  	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
> >  	VIRTIO_BLK_F_MQ,
> > +}
> > +;
> > +static unsigned int features[] = {
> > +	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> > +	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
> > +	VIRTIO_BLK_F_TOPOLOGY,
> > +	VIRTIO_BLK_F_MQ,
> > +	VIRTIO_F_VERSION_1,
> 
> We can fit this into less lines, like done for features_legacy.
> 
> I was asking myself if we could do the conversion of the statical values
> somehow upfront, to reduce the patch size and avoid cpu_to_virtio.* at those
> places.
> 
> Otherwise looks good to me.
> 

I don't see how we can reduce the patch size.
For BE architectures it's dynamic, so at best the values
will become macros/incline functions taking a flag.

For some places on data path, it might be worth it
to cache the correct value e.g. as part of device
structure. This replaces a branch with a memory load,
so the gain would have to be measured, best done
separately?

-- 
MST
