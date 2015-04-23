From: Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v5 1/8] virtio: introduce virtio_is_little_endian()
 helper
Date: Thu, 23 Apr 2015 19:22:15 +0200
Message-ID: <20150423192215.12182311@thh440s>
References: <20150423152608.11795.4373.stgit@bahia.local>
	<20150423152617.11795.13272.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150423152617.11795.13272.stgit@bahia.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Am Thu, 23 Apr 2015 17:26:20 +0200
schrieb Greg Kurz <gkurz@linux.vnet.ibm.com>:

> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> ---
>  include/linux/virtio_config.h |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index ca3ed78..bd1a582 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -205,35 +205,40 @@ int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
>  	return 0;
>  }
>  
> +static inline bool virtio_is_little_endian(struct virtio_device *vdev)
> +{
> +	return virtio_has_feature(vdev, VIRTIO_F_VERSION_1);
> +}

So this function returns false when _not_ using version 1, but running
on a little endian host + guest? Sounds confusing. Maybe you could name
it "virtio_is_v1()" or so instead?

 Thomas
