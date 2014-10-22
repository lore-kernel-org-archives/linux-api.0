From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC v2 01/16] virtio: memory access APIs
Date: Wed, 22 Oct 2014 21:40:14 +0300
Message-ID: <20141022184014.GA10919@redhat.com>
References: <1413992894-22976-1-git-send-email-mst@redhat.com>
	<1413992894-22976-2-git-send-email-mst@redhat.com>
	<5447ED53.2030502@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <5447ED53.2030502@codeaurora.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Christopher Covington <cov@codeaurora.org>
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>, Anup Patel <anup.patel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, David Drysdale <drysdale@google.com>, "Lad,
	Prabhakar" <prabhakar.csengg@gmail.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-api@vger.kernel.org, Alexei Starovoitov <ast@plumgrid.com>, virtualization@lists.linux-foundation.org, "David S. Miller" <davem@davemloft.net>, Piotr =?iso-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 22, 2014 at 01:45:55PM -0400, Christopher Covington wrote:
> Hi Michael,
> 
> On 10/22/2014 11:50 AM, Michael S. Tsirkin wrote:
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
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio_config.h    | 16 +++++++++++++
> >  include/uapi/linux/virtio_ring.h | 49 ++++++++++++++++++++--------------------
> >  include/uapi/linux/Kbuild        |  1 +
> >  3 files changed, 42 insertions(+), 24 deletions(-)
> > 
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> > index 7f4ef66..d38d3c2 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -4,6 +4,7 @@
> >  #include <linux/err.h>
> >  #include <linux/bug.h>
> >  #include <linux/virtio.h>
> > +#include <linux/virtio_byteorder.h>
> 
> What patch creates this file?

Oops I forgot to git add it.
Will resend.

> >  #include <uapi/linux/virtio_config.h>
> >  
> >  /**
> > @@ -152,6 +153,21 @@ int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
> >  	return 0;
> >  }
> >  
> > +/* Memory accessors */
> > +#define DEFINE_VIRTIO_XX_TO_CPU(bits) \
> > +static inline u##bits virtio##bits##_to_cpu(struct virtio_device *vdev, __virtio##bits val) \
> > +{ \
> > +	return __virtio##bits##_to_cpu(false, val); \
> > +} \
> > +static inline __virtio##bits cpu_to_virtio##bits(struct virtio_device *vdev, u##bits val) \
> > +{ \
> > +	return __cpu_to_virtio##bits(false, val); \
> > +}
> > +
> > +DEFINE_VIRTIO_XX_TO_CPU(16)
> > +DEFINE_VIRTIO_XX_TO_CPU(32)
> > +DEFINE_VIRTIO_XX_TO_CPU(64)
> > +
> >  /* Config space accessors. */
> >  #define virtio_cread(vdev, structname, member, ptr)			\
> >  	do {								\
> > diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
> > index a99f9b7..6c00632 100644
> > --- a/include/uapi/linux/virtio_ring.h
> > +++ b/include/uapi/linux/virtio_ring.h
> > @@ -32,6 +32,7 @@
> >   *
> >   * Copyright Rusty Russell IBM Corporation 2007. */
> >  #include <linux/types.h>
> > +#include <linux/virtio_types.h>
> >  
> >  /* This marks a buffer as continuing via the next field. */
> >  #define VRING_DESC_F_NEXT	1
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
> How does __virtio64 differ from __le64?
> 
> Thanks,
> Chris

__le64 would require cpu_to_le, I wanted to force the use
of our byte swapping macros.

> -- 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
