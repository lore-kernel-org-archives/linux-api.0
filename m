From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 1/2] include/uapi/linux/virtio_blk.h: introduce
	feature of VIRTIO_BLK_F_MQ
Date: Sun, 29 Jun 2014 19:32:16 +0300
Message-ID: <20140629163216.GA25431@redhat.com>
References: <1403775708-22244-1-git-send-email-ming.lei@canonical.com>
	<1403775708-22244-2-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1403775708-22244-2-git-send-email-ming.lei@canonical.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 26, 2014 at 05:41:47PM +0800, Ming Lei wrote:
> Current virtio-blk spec only supports one virtual queue for transfering
> data between VM and host, and inside VM all kinds of operations on
> the virtual queue needs to hold one lock, so cause below problems:
> 
> 	- bad scalability
> 	- bad throughput
> 
> This patch requests to introduce feature of VIRTIO_BLK_F_MQ
> so that more than one virtual queues can be used to virtio-blk
> device, then above problems can be solved or eased.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  include/uapi/linux/virtio_blk.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
> index 6d8e61c..9ad67b2 100644
> --- a/include/uapi/linux/virtio_blk.h
> +++ b/include/uapi/linux/virtio_blk.h
> @@ -40,6 +40,7 @@
>  #define VIRTIO_BLK_F_WCE	9	/* Writeback mode enabled after reset */
>  #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
>  #define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
> +#define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
>  
>  #ifndef __KERNEL__
>  /* Old (deprecated) name for VIRTIO_BLK_F_WCE. */
> @@ -77,6 +78,10 @@ struct virtio_blk_config {
>  
>  	/* writeback mode (if VIRTIO_BLK_F_CONFIG_WCE) */
>  	__u8 wce;
> +	__u8 unused;
> +
> +	/* number of vqs, only available when VIRTIO_BLK_F_MQ is set */
> +	__u16 num_queues;
>  } __attribute__((packed));
>  
>  /*
> -- 
> 1.7.9.5
