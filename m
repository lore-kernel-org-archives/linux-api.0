From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] uapi: use __u8 from linux/types.h
Date: Wed, 13 Jan 2016 18:25:53 +0200
Message-ID: <20160113182546-mutt-send-email-mst@redhat.com>
References: <20160113160958.GA29108@glebfm.cloud.tilaa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160113160958.GA29108-N9aU+Tdk7XkoO014n+3aBsY9il7ykmry@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gleb Fotengauer-Malinovskiy <glebfm-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 13, 2016 at 07:10:15PM +0300, Gleb Fotengauer-Malinovskiy wrote:
> Kernel headers should use linux/types.h based definitions.
> 
> Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>

Acked-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>  include/uapi/linux/virtio_gpu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/virtio_gpu.h b/include/uapi/linux/virtio_gpu.h
> index 7a63faa..4b04ead 100644
> --- a/include/uapi/linux/virtio_gpu.h
> +++ b/include/uapi/linux/virtio_gpu.h
> @@ -287,7 +287,7 @@ struct virtio_gpu_get_capset {
>  /* VIRTIO_GPU_RESP_OK_CAPSET */
>  struct virtio_gpu_resp_capset {
>  	struct virtio_gpu_ctrl_hdr hdr;
> -	uint8_t capset_data[];
> +	__u8 capset_data[];
>  };
>  
>  #define VIRTIO_GPU_EVENT_DISPLAY (1 << 0)
> -- 
> glebfm
