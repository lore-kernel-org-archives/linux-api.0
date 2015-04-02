From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 7/7] vhost: feature to set the vring endianness
Date: Thu, 2 Apr 2015 20:53:24 +0200
Message-ID: <20150402204636-mutt-send-email-mst@redhat.com>
References: <20150402131637.24676.60700.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
 <20150402131713.24676.9924.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
 <20150402142046.GA23121@redhat.com>
 <20150402184527.0bc68efe@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150402184527.0bc68efe@bahia.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 02, 2015 at 06:45:27PM +0200, Greg Kurz wrote:
> On Thu, 2 Apr 2015 16:20:46 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Thu, Apr 02, 2015 at 03:17:13PM +0200, Greg Kurz wrote:
> > > This patch brings cross-endian support to vhost when used to implement
> > > legacy virtio devices. Since it is a relatively rare situation, the feature
> > > availability is controlled by a kernel config option (not set by default).
> > > 
> > > If cross-endian support is compiled in, vhost abvertises a new feature
> > > to be negotiated with userspace. If userspace acknowledges the feature,
> > > it can inform vhost about the endianness to use with a new ioctl.
> > > 
> > > This feature is mutually exclusive with virtio 1.0. Even if the vhost device
> > > advertises virtio 1.0 and legacy cross-endian features, it cannot receive
> > > aknowledgement for both at the same time.
> > > 
> > > Hot paths are being preserved from any penalty when the config option is
> > > disabled or when virtio 1.0 is being used.
> > > 
> > > Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> > > ---
> > >  drivers/vhost/Kconfig      |   10 ++++++++++
> > >  drivers/vhost/net.c        |    5 +++++
> > >  drivers/vhost/scsi.c       |    4 ++++
> > >  drivers/vhost/test.c       |    4 ++++
> > >  drivers/vhost/vhost.c      |   19 +++++++++++++++++++
> > >  drivers/vhost/vhost.h      |   13 ++++++++++++-
> > >  include/uapi/linux/vhost.h |   10 ++++++++++
> > >  7 files changed, 64 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > > index 017a1e8..5bb8da9 100644
> > > --- a/drivers/vhost/Kconfig
> > > +++ b/drivers/vhost/Kconfig
> > > @@ -32,3 +32,13 @@ config VHOST
> > >  	---help---
> > >  	  This option is selected by any driver which needs to access
> > >  	  the core of vhost.
> > > +
> > > +config VHOST_SET_ENDIAN_LEGACY
> > > +	bool "Cross-endian support for host kernel accelerator"
> > > +	default n
> > > +	---help---
> > > +	  This option allows vhost to support guests with a different byte
> > > +	  ordering
> > 
> > from host
> > 
> > >. It is disabled by default since it adds overhead and it
> > > +	  is only needed by a few platforms (powerpc and arm).
> > > +
> > > +	  If unsure, say "n".
> > 
> > "N"
> > 
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > index 2bbfc25..5274a44 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -1011,6 +1011,11 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
> > >  		vhost_hlen = 0;
> > >  		sock_hlen = hdr_len;
> > >  	}
> > > +
> > > +	if (features & ((1ULL << VHOST_F_SET_ENDIAN_LEGACY) |
> > > +			(1ULL << VIRTIO_F_VERSION_1)))
> > > +		return -EINVAL;
> > > +
> > >  	mutex_lock(&n->dev.mutex);
> > >  	if ((features & (1 << VHOST_F_LOG_ALL)) &&
> > >  	    !vhost_log_access_ok(&n->dev)) {
> > > diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> > > index 71df240..b53e9c2 100644
> > > --- a/drivers/vhost/scsi.c
> > > +++ b/drivers/vhost/scsi.c
> > > @@ -1544,6 +1544,10 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
> > >  	if (features & ~VHOST_SCSI_FEATURES)
> > >  		return -EOPNOTSUPP;
> > >  
> > > +	if (features & ((1ULL << VHOST_F_SET_ENDIAN_LEGACY) |
> > > +			(1ULL << VIRTIO_F_VERSION_1)))
> > > +		return -EINVAL;
> > > +
> > >  	mutex_lock(&vs->dev.mutex);
> > >  	if ((features & (1 << VHOST_F_LOG_ALL)) &&
> > >  	    !vhost_log_access_ok(&vs->dev)) {
> > > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > > index d9c501e..cfefdad 100644
> > > --- a/drivers/vhost/test.c
> > > +++ b/drivers/vhost/test.c
> > > @@ -243,6 +243,10 @@ static int vhost_test_set_features(struct vhost_test *n, u64 features)
> > >  {
> > >  	struct vhost_virtqueue *vq;
> > >  
> > > +	if (features & ((1ULL << VHOST_F_SET_ENDIAN_LEGACY) |
> > > +			(1ULL << VIRTIO_F_VERSION_1)))
> > > +		return -EINVAL;
> > > +
> > >  	mutex_lock(&n->dev.mutex);
> > >  	if ((features & (1 << VHOST_F_LOG_ALL)) &&
> > >  	    !vhost_log_access_ok(&n->dev)) {
> > 
> > Above seems to prevent users from specifying either
> > VIRTIO_F_VERSION_1 or VHOST_F_SET_ENDIAN_LEGACY.
> > Does it actually work?
> > 
> 
> Arggg no it doesn't *of course*... I've added these bogus checks lately
> and didn't re-test :(

BTW I would be happier with less ifdefs all over the code,
using some inline wrappers defined differently depending on ifdef.
For example:

#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
bool vhost_vq_legacy_is_little_endian(vq)
{
	return !vq->legacy_big_endian;
}
#else
bool vhost_vq_legacy_is_little_endian(vq)
{
 	return virtio_legacy_is_little_endian();
}
#endif

similarly put VHOST_SET_VRING_ENDIAN_LEGACY handling
in a separate function, with a stub definition
when functionality is configured out.

> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 2ee2826..60a0f32 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -199,6 +199,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> > >  	vq->call = NULL;
> > >  	vq->log_ctx = NULL;
> > >  	vq->memory = NULL;
> > > +	vq->legacy_big_endian = false;
> > >  }
> > >  
> > >  static int vhost_worker(void *data)
> > > @@ -806,6 +807,24 @@ long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp)
> > >  		} else
> > >  			filep = eventfp;
> > >  		break;
> > > +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> > > +	case VHOST_SET_VRING_ENDIAN_LEGACY:
> > > +	{
> > > +		struct vhost_vring_endian e;
> > > +
> > > +		if (!vhost_has_feature(vq, VHOST_F_SET_ENDIAN_LEGACY)) {
> > > +			r = -EINVAL;
> > > +			break;
> > > +		}
> > > +
> > > +		if (copy_from_user(&e, argp, sizeof(e))) {
> > > +			r = -EFAULT;
> > > +			break;
> > > +		}
> > > +		vq->legacy_big_endian = e.is_big_endian;
> > > +		break;
> > > +	}
> > > +#endif
> > >  	default:
> > >  		r = -ENOIOCTLCMD;
> > >  	}
> > > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > > index 4e9a186..d50881d 100644
> > > --- a/drivers/vhost/vhost.h
> > > +++ b/drivers/vhost/vhost.h
> > > @@ -106,6 +106,9 @@ struct vhost_virtqueue {
> > >  	/* Log write descriptors */
> > >  	void __user *log_base;
> > >  	struct vhost_log *log;
> > > +
> > > +	/* We need to know the device endianness with legacy virtio. */
> > > +	bool legacy_big_endian;
> > >  };
> > >  
> > >  struct vhost_dev {
> > > @@ -165,7 +168,11 @@ enum {
> > >  	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> > >  			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> > >  			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> > > -			 (1ULL << VHOST_F_LOG_ALL),
> > > +			 (1ULL << VHOST_F_LOG_ALL) |
> > > +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> > > +			 (1ULL << VHOST_F_SET_ENDIAN_LEGACY) |
> > > +#endif
> > > +			 0ULL,
> > >  };
> > >  
> > >  static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
> > > @@ -177,6 +184,10 @@ static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
> > >  {
> > >  	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
> > >  		return true;
> > > +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> > > +	if (vhost_has_feature(vq, VHOST_F_SET_ENDIAN_LEGACY))
> > > +		return !vq->legacy_big_endian;
> > 
> > why do we need to check the feature bit?
> > How about simple
> > 	return !vq->legacy_big_endian;
> > here?
> 
> This is a runtime feature. Even for powerpc, cross-endian won't be the
> most common scenario. Userspace may have cleared the bit if it doesn't
> need/want it.

Right but if we drop VHOST_F_SET_ENDIAN_LEGACY then
it's simply
#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
	return !vq->legacy_big_endian;
#else
 	return virtio_legacy_is_little_endian();
#endif

> > All you need to do is set legacy_big_endian to
> > !virtio_legacy_is_little_endian() on reset.
> > Maybe rename to legacy_is_little_endian so you don't
> > need to reverse the logic.
> > 
> 
> Do you mean vhost doesn't need userspace to provide the endianness
> to be used ? Please elaborate on the meaning of "reset" here... I
> am confused.

I refer to vhost_vq_reset here.

> > > +#endif
> > >  	return virtio_legacy_is_little_endian();
> > >  }
> > >  
> > > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > > index bb6a5b4..09d2a48 100644
> > > --- a/include/uapi/linux/vhost.h
> > > +++ b/include/uapi/linux/vhost.h
> > > @@ -47,6 +47,11 @@ struct vhost_vring_addr {
> > >  	__u64 log_guest_addr;
> > >  };
> > >  
> > > +struct vhost_vring_endian {
> > > +	unsigned int index;
> > > +	bool is_big_endian;
> > 
> > bool in uapi is a bad idea.
> > Generally, I think you can use vhost_vring_state here.
> > 
> 
> Ok to turn is_big_endian into an int but why hijacking vhost_vring_state ?

Yes.

> 
> > > +};
> > > +
> > >  struct vhost_memory_region {
> > >  	__u64 guest_phys_addr;
> > >  	__u64 memory_size; /* bytes */
> > > @@ -103,6 +108,9 @@ struct vhost_memory {
> > >  /* Get accessor: reads index, writes value in num */
> > >  #define VHOST_GET_VRING_BASE _IOWR(VHOST_VIRTIO, 0x12, struct vhost_vring_state)
> > >  
> > > +/* Set endianness for the ring (legacy virtio only) */
> > > +#define VHOST_SET_VRING_ENDIAN_LEGACY _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_endian)
> > > +
> > >  /* The following ioctls use eventfd file descriptors to signal and poll
> > >   * for events. */
> > >  
> > 
> > You also need a GET ioctl, as a matter of policy.
> > 
> 
> Ok. Will add.
> 
> > > @@ -126,6 +134,8 @@ struct vhost_memory {
> > >  #define VHOST_F_LOG_ALL 26
> > >  /* vhost-net should add virtio_net_hdr for RX, and strip for TX packets. */
> > >  #define VHOST_NET_F_VIRTIO_NET_HDR 27
> > > +/* the vring endianness can be explicitly set (legacy virtio only). */
> > > +#define VHOST_F_SET_ENDIAN_LEGACY 28
> > >  
> > >  /* VHOST_SCSI specific definitions */
> > 
> > 
> > VHOST_F_SET_ENDIAN_LEGACY doesn't seem too useful.
> > Is this so userspace can detect kernel configuration?
> 
> Yes. Also, it is quite easy to "un-ack" the feature when
> it is not wanted.
> 
> > I think probing VHOST_SET_VRING_ENDIAN_LEGACY should
> > be sufficient for this.
> > 
> 
> I'll get rid of the feature.
> 
> Thanks for your time Michael.
> 
> --
> Greg
