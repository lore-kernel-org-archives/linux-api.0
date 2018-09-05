From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 03/11] UAPI: virtio_net: Fix use of C++ keywords as
 structural members
Date: Wed, 5 Sep 2018 18:54:36 +0200
Message-ID: <20180905165436.GA25206@kroah.com>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <153616289529.23468.7498785670556620808.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153616289529.23468.7498785670556620808.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 05, 2018 at 04:54:55PM +0100, David Howells wrote:
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

Ugh, ick, no!

Come on now, either put the whole C namespace stuff around the file, or
don't care about this at all.  Doing this whack-a-mole style is a mess.

"class" is a fine variable name for C code, there's no reason this has
to change here at all.

greg k-h
