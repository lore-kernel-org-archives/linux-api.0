From: David Hildenbrand <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Date: Mon, 1 Dec 2014 11:01:36 +0100
Message-ID: <20141201110136.1ff29a67@thinkpad-w530>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092850.GD15607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141201092850.GD15607-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, rusty-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, thuth-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On Mon, Dec 01, 2014 at 09:16:41AM +0100, David Hildenbrand wrote:
> > > Based on patch by Cornelia Huck.
> > > 
> > > Note: for consistency, and to avoid sparse errors,
> > >       convert all fields, even those no longer in use
> > >       for virtio v1.0.
> > > 
> > > Signed-off-by: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ...
> > > 
> > > -static unsigned int features[] = {
> > > +static unsigned int features_legacy[] = {
> > >  	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> > >  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
> > >  	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
> > >  	VIRTIO_BLK_F_MQ,
> > > +}
> > > +;
> > > +static unsigned int features[] = {
> > > +	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> > > +	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
> > > +	VIRTIO_BLK_F_TOPOLOGY,
> > > +	VIRTIO_BLK_F_MQ,
> > > +	VIRTIO_F_VERSION_1,
> > 
> > We can fit this into less lines, like done for features_legacy.
> 
> Wrt packing code more tightly, I did it like this to
> make it easier to compare the arrays.
> Each flag is on the same line in original and new array.

This just looks inconsistent to me.

1. features_legacy is tightly packed
2. half of features is tightly packed

So either all tightly packed or put every item on a single line. At least
that's what I would do :)

> 
> > I was asking myself if we could do the conversion of the statical values
> > somehow upfront, to reduce the patch size and avoid cpu_to_virtio.* at those
> > places.
> > 
> > Otherwise looks good to me.
> > 
> 
