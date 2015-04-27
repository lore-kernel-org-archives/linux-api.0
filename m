From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v6 1/8] virtio: introduce virtio_is_little_endian() helper
Date: Mon, 27 Apr 2015 11:07:30 +0200
Message-ID: <20150427110730.212a1594.cornelia.huck@de.ibm.com>
References: <20150424122211.19156.97626.stgit@bahia.local>
	<20150424122423.19156.34555.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150424122423.19156.34555.stgit@bahia.local>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Fri, 24 Apr 2015 14:24:27 +0200
Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:

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
> +

While this reads a bit funny in this patch, it will end up correctly at
the end of the series, so

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
