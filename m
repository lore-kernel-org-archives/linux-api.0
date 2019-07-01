From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 2/6] Adjust watch_queue documentation to mention mount and
 superblock watches. [ver #5]
Date: Sun, 30 Jun 2019 19:59:33 -0700
Message-ID: <7a288c2c-11a1-87df-9550-b247d6ce3010@infradead.org>
References: <156173701358.15650.8735203424342507015.stgit@warthog.procyon.org.uk>
 <156173703546.15650.14319137940607993268.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156173703546.15650.14319137940607993268.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi David,

On 6/28/19 8:50 AM, David Howells wrote:
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  Documentation/watch_queue.rst |   20 +++++++++++++++++++-
>  drivers/misc/Kconfig          |    5 +++--
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/watch_queue.rst b/Documentation/watch_queue.rst
> index 4087a8e670a8..1bec2018d549 100644
> --- a/Documentation/watch_queue.rst
> +++ b/Documentation/watch_queue.rst
> @@ -13,6 +13,10 @@ receive notifications from the kernel.  This can be used in conjunction with::
>  
>      * USB subsystem event notifications
>  
> +  * Mount topology change notifications
> +
> +  * Superblock event notifications
> +
>  
>  The notifications buffers can be enabled by:
>  
> @@ -324,6 +328,19 @@ Any particular buffer can be fed from multiple sources.  Sources include:
>      for buses and devices.  Watchpoints of this type are set on the global
>      device watch list.
>  
> +  * WATCH_TYPE_MOUNT_NOTIFY
> +
> +    Notifications of this type indicate mount tree topology changes and mount
> +    attribute changes.  A watch can be set on a particular file or directory
> +    and notifications from the path subtree rooted at that point will be
> +    intercepted.
> +
> +  * WATCH_TYPE_SB_NOTIFY
> +
> +    Notifications of this type indicate superblock events, such as quota limits
> +    being hit, I/O errors being produced or network server loss/reconnection.
> +    Watches of this type are set directly on superblocks.
> +
>  
>  Event Filtering
>  ===============
> @@ -365,7 +382,8 @@ Where:
>  	(watch.info & info_mask) == info_filter
>  
>      This could be used, for example, to ignore events that are not exactly on
> -    the watched point in a mount tree.
> +    the watched point in a mount tree by specifying NOTIFY_MOUNT_IN_SUBTREE
> +    must be 0.

I'm having a little trouble parsing that sentence.
Could you clarify it or maybe rewrite/modify it?
Thanks.

>  
>    * ``subtype_filter`` is a bitmask indicating the subtypes that are of
>      interest.  Bit 0 of subtype_filter[0] corresponds to subtype 0, bit 1 to



-- 
~Randy
