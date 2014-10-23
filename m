From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v3 01/16] virtio: memory access APIs
Date: Thu, 23 Oct 2014 12:15:02 +0300
Message-ID: <20141023091502.GA7028@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
 <1414003404-505-2-git-send-email-mst@redhat.com>
 <20141023095405.6bdd5a1a.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141023095405.6bdd5a1a.cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjarke Istrup Pedersen <gurligebis-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Anup Patel <anup.patel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Piotr =?iso-8859-1?Q?Kr=F3l?= <piotr.krol-zILERgsGILsAvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 23, 2014 at 09:54:05AM +0200, Cornelia Huck wrote:
> On Wed, 22 Oct 2014 21:44:08 +0300
> "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > virtio 1.0 makes all memory structures LE, so
> > we need APIs to conditionally do a byteswap on BE
> > architectures.
> > 
> > To make it easier to check code statically,
> > add virtio specific types for multi-byte integers
> > in memory.
> > 
> > Add low level wrappers that do a byteswap conditionally, these will be
> > useful e.g. for vhost.  Add high level wrappers that will (in the
> > future) query device endian-ness and act accordingly.
> > 
> > At the moment, stub them out and assume native endian-ness everywhere.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/linux/virtio_byteorder.h | 29 ++++++++++++++++++++++++
> >  include/linux/virtio_config.h    | 16 +++++++++++++
> >  include/uapi/linux/virtio_ring.h | 49 ++++++++++++++++++++--------------------
> >  include/uapi/linux/Kbuild        |  1 +
> >  4 files changed, 71 insertions(+), 24 deletions(-)
> >  create mode 100644 include/linux/virtio_byteorder.h
> > 
> > diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
> > new file mode 100644
> > index 0000000..7afdd8a
> > --- /dev/null
> > +++ b/include/linux/virtio_byteorder.h
> > @@ -0,0 +1,29 @@
> > +#ifndef _LINUX_VIRTIO_BYTEORDER_H
> > +#define _LINUX_VIRTIO_BYTEORDER_H
> > +#include <linux/types.h>
> > +#include <uapi/linux/virtio_types.h>
> > +
> > +/* Memory accessors for handling virtio in modern little endian and in
> > + * compatibility big endian format. */
> 
> s/big/native/

Thanks.

> > +
> > +#define __DEFINE_VIRTIO_XX_TO_CPU(bits) \
> > +static inline u##bits __virtio##bits##_to_cpu(bool little_endian, __virtio##bits val) \
> > +{ \
> > +	if (little_endian) \
> > +		return le##bits##_to_cpu((__force __le##bits)val); \
> > +	else \
> > +		return (__force u##bits)val; \
> > +} \
> > +static inline __virtio##bits __cpu_to_virtio##bits(bool little_endian, u##bits val) \
> > +{ \
> > +	if (little_endian) \
> > +		return (__force __virtio##bits)cpu_to_le##bits(val); \
> > +	else \
> > +		return val; \
> > +}
> > +
> > +__DEFINE_VIRTIO_XX_TO_CPU(16)
> > +__DEFINE_VIRTIO_XX_TO_CPU(32)
> > +__DEFINE_VIRTIO_XX_TO_CPU(64)
> 
> ...although I'm still not too happy with macro-generated helpers.

I'm fine with open-coding them.

> > +
> > +#endif /* _LINUX_VIRTIO_BYTEORDER */
> 
> > diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
> > index a99f9b7..6c00632 100644
> > --- a/include/uapi/linux/virtio_ring.h
> > +++ b/include/uapi/linux/virtio_ring.h
> 
> > @@ -61,32 +62,32 @@
> >  /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
> >  struct vring_desc {
> >  	/* Address (guest-physical). */
> > -	__u64 addr;
> > +	__virtio64 addr;
> >  	/* Length. */
> > -	__u32 len;
> > +	__virtio32 len;
> >  	/* The flags as indicated above. */
> > -	__u16 flags;
> > +	__virtio16 flags;
> >  	/* We chain unused descriptors via this, too */
> > -	__u16 next;
> > +	__virtio16 next;
> >  };
> 
> I think all of these __virtio types need an explanation somewhere as to
> what they mean, e.g.:
> 
> /*
>  * __virtio{16,32,64} have the following meaning:
>  * - __u{16,32,64} for virtio devices in legacy mode,
>  *   accessed in native endian
>  * - __le{16,32,64} for standard-compliant virtio devices
>  */

Will do.

-- 
MST
