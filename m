From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] virtio_balloon: convert to virtio 1.0
 endian-ness
Date: Tue, 2 Dec 2014 19:39:30 +0100
Message-ID: <20141202193930.2b8750f7.cornelia.huck@de.ibm.com>
References: <1417520617-2135-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417520617-2135-1-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2 Dec 2014 13:44:06 +0200
"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> balloon device is not part of virtio 1.0 spec.  Still, it's easy enough
> to make it handle endian-ness exactly as other virtio 1.0 devices: what
> we gain from this, is that there's no need to special-case it in virtio
> core.

Well, the balloon is weird in a number of ways, including its always
little-endian config space.

But I'm not quite sure the spec covers this?

> 
> Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/linux/virtio_balloon.h | 5 +++--
>  drivers/virtio/virtio_balloon.c     | 4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 

>  struct virtio_balloon_stat {
> -	__u16 tag;
> -	__u64 val;
> +	__virtio16 tag;
> +	__virtio64 val;
>  } __attribute__((packed));

Would the respective fields in the spec need updating? While it is
actually talking about legacy requirements, the fields are not
specified as __virtio{16,64}.

Also, is changing the stat fields enough? I've not looked into balloon
operation, but does the payload need some endianess conversion as well?
