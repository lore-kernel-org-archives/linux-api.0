From: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2] [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY
Date: Wed, 27 Jan 2016 13:44:44 +0200
Message-ID: <20160127114443.GF14876@valkosipuli.retiisi.org.uk>
References: <be0270ec89e6b9b49de7e533dd1f3a89ad34d205.1452523228.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <be0270ec89e6b9b49de7e533dd1f3a89ad34d205.1452523228.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hverkuil@xs4all.nl>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Mauro,

I see that this patch got applied to the media_tree master, but then
reverted a few days ago. Do you think the G_TOPOLOGY IOCTL and the
associated user space structs are ready for being included in a release?

I have a few concerns over the current interface, in decreasing order of
importance:

- G_TOPOLOGY IOCTL is intended to enable dynamic updates, but do we have a
  driver actually supporting this? For instance, supposing that the users's
  knowledge of the graph state isn't what the user expected it to be
  (assuming the graph state changed between G_TOPOLOGY and SETUP_LINK), does
  the user still want to perform the SETUP_LINK IOCTL or would the user
  prefer that the kernel returned an error instead to tell the user has no
  knowledge of the current graph state? I'd like to see how that works in
  practice. For instance, a virtual driver such as vivi, but with MC, V4L2
  sub-device and V4L2 support which adds and removes a random entity every,
  say, five minutes, would be wonderful. If this has not been tried out in a
  real use case, the chances of getting it right may remain rather slim.

- struct media_v2_pad contains fields called "id" and "entity_id". The "id"
  field, as far as I understand, is the graph object id, not the pad index.
  In order to configure a link using MEDIA_IOC_SETUP_LINK, one does need to
  know the entity id and the pad index. This information you'll only get
  using MEDIA_IOC_ENUM_LINKS, which right now refutes the very purpose of
  the G_TOPOLOGY IOCTL. Knowing the pad indices is also essential for the
  V4L2 sub-device user space API. (I remember whether or not the pad index
  should be there but I don't remember the details, except that it was
  intentionally left out. Considering this again, I think adding it is
  unavoidable.) This together with the above point suggest there are no
  real applications using G_TOPOLOGY yet.

- Some more thought should be given to the state of the reserved fields, in
  e.g. struct media_v2_pad there are __u32 fields only, except a reserved
  field which is a __u16 array of 9. While this isn't exactly wrong it makes
  no sense either.

- KernelDoc documentation would be nice for the G_TOPOLOGY argument structs.
  DocBook documentation for G_TOPOLOGY as itself is fine, but I think it
  reflects an older version of the structs than what's now defined in
  include/uapi/linux/media.h.

Please give some thought on this. There are some obvious gaps that need to
be filled, and when doing so, I don't think we want to start guessing
whether there might be an application that depends on the current API/ABI.

If you'd like the G_TOPOLOGY IOCTL and its argument structs to be available
for developers without kernel changes, I propose to add a new Kconfig option
for G_TOPOLOGY and make it depend on BROKEN.

What do you think?

On Mon, Jan 11, 2016 at 12:41:02PM -0200, Mauro Carvalho Chehab wrote:
> There are a few discussions left with regards to this ioctl:
> 
> 1) the name of the new structs will contain _v2_ on it?
> 2) what's the best alternative to avoid compat32 issues?
> 
> Due to that, let's postpone the addition of this new ioctl to
> the next Kernel version, to give people more time to discuss it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> 
> v2: Fix a compilation breakage
> 
>  Documentation/DocBook/media/v4l/media-ioc-g-topology.xml | 3 +++
>  drivers/media/media-device.c                             | 7 ++++++-
>  include/uapi/linux/media.h                               | 6 +++++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml b/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
> index e0d49fa329f0..63152ab9efba 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
> @@ -48,6 +48,9 @@
>  
>    <refsect1>
>      <title>Description</title>
> +
> +    <para><emphasis role="bold">NOTE:</emphasis> This new ioctl is programmed to be added on Kernel 4.6. Its definition/arguments may change until its final version.</para>
> +
>      <para>The typical usage of this ioctl is to call it twice.
>      On the first call, the structure defined at &media-v2-topology; should
>      be zeroed. At return, if no errors happen, this ioctl will return the
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 4d1c13de494b..7dae0ac0f3ae 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -234,6 +234,7 @@ static long media_device_setup_link(struct media_device *mdev,
>  	return ret;
>  }
>  
> +#if 0 /* Let's postpone it to Kernel 4.6 */
>  static long __media_device_get_topology(struct media_device *mdev,
>  				      struct media_v2_topology *topo)
>  {
> @@ -389,6 +390,7 @@ static long media_device_get_topology(struct media_device *mdev,
>  
>  	return 0;
>  }
> +#endif
>  
>  static long media_device_ioctl(struct file *filp, unsigned int cmd,
>  			       unsigned long arg)
> @@ -422,13 +424,14 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
>  		mutex_unlock(&dev->graph_mutex);
>  		break;
>  
> +#if 0 /* Let's postpone it to Kernel 4.6 */
>  	case MEDIA_IOC_G_TOPOLOGY:
>  		mutex_lock(&dev->graph_mutex);
>  		ret = media_device_get_topology(dev,
>  				(struct media_v2_topology __user *)arg);
>  		mutex_unlock(&dev->graph_mutex);
>  		break;
> -
> +#endif
>  	default:
>  		ret = -ENOIOCTLCMD;
>  	}
> @@ -477,7 +480,9 @@ static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
>  	case MEDIA_IOC_DEVICE_INFO:
>  	case MEDIA_IOC_ENUM_ENTITIES:
>  	case MEDIA_IOC_SETUP_LINK:
> +#if 0 /* Let's postpone it to Kernel 4.6 */
>  	case MEDIA_IOC_G_TOPOLOGY:
> +#endif
>  		return media_device_ioctl(filp, cmd, arg);
>  
>  	case MEDIA_IOC_ENUM_LINKS32:
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 5dbb208e5451..1e3c8cb43bd7 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -286,7 +286,7 @@ struct media_links_enum {
>   *	  later, before the adding this API upstream.
>   */
>  
> -
> +#if 0 /* Let's postpone it to Kernel 4.6 */
>  struct media_v2_entity {
>  	__u32 id;
>  	char name[64];		/* FIXME: move to a property? (RFC says so) */
> @@ -351,6 +351,7 @@ static inline void __user *media_get_uptr(__u64 arg)
>  {
>  	return (void __user *)(uintptr_t)arg;
>  }
> +#endif
>  
>  /* ioctls */
>  
> @@ -358,6 +359,9 @@ static inline void __user *media_get_uptr(__u64 arg)
>  #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
>  #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
>  #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
> +
> +#if 0 /* Let's postpone it to Kernel 4.6 */
>  #define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
> +#endif
>  
>  #endif /* __LINUX_MEDIA_H */

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
