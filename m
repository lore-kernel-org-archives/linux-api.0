From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 03/11] UAPI: virtio_net: Fix use of C++ keywords as
 structural members [ver #2]
Date: Thu, 6 Sep 2018 11:02:04 -0400
Message-ID: <20180906104208-mutt-send-email-mst@kernel.org>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
 <153622552270.14298.14568295161017777604.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153622552270.14298.14568295161017777604.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, Jason Wang <jasowang@redhat.com>, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 06, 2018 at 10:18:42AM +0100, David Howells wrote:
> The virtio_net_ctrl_hdr struct uses a C++ keyword as structural members.  Fix
> this by inserting an anonymous union that provides an alternative name and
> then hide the reserved name in C++.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: "Michael S. Tsirkin" <mst@redhat.com>
> cc: Jason Wang <jasowang@redhat.com>
> cc: virtualization@lists.linux-foundation.org
> ---
> 
>  include/uapi/linux/virtio_net.h |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index a3715a3224c1..967142bc0e05 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -150,7 +150,12 @@ struct virtio_net_hdr_mrg_rxbuf {
>   * command goes in between.
>   */
>  struct virtio_net_ctrl_hdr {
> -	__u8 class;
> +	union {
> +#ifndef __cplusplus
> +		__u8 class;
> +#endif
> +		__u8 _class;
> +	};
>  	__u8 cmd;
>  } __attribute__((packed));
>  

So if we are going to do this, I think I'd prefer something like:

struct virtio_net_ctrl_hdr_v2 {
	__u8 cmd_class;
  	__u8 cmd;
};

And then hide the whole old structure. This also gets rid of the packed
keyword which we don't really need here.

Only issue is virtio_net_ctrl_hdr_v2 is ugly. But oh well.

And then rework at least QEMU to use the v2 of the header.

Quite a bit of churn, so I don't think it makes sense to apply just this
one in isolation - only if rest of the changes go in.


-- 
MST
