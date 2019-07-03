From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/9] uapi: General notification ring definitions [ver #5]
Date: Wed, 3 Jul 2019 19:08:10 +0200
Message-ID: <20190703170810.GB24672@kroah.com>
References: <156173690158.15137.3985163001079120218.stgit@warthog.procyon.org.uk>
 <156173691411.15137.2073887155273175167.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156173691411.15137.2073887155273175167.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 28, 2019 at 04:48:34PM +0100, David Howells wrote:
> Add UAPI definitions for the general notification ring, including the
> following pieces:
> 
>  (1) struct watch_notification.
> 
>      This is the metadata header for each entry in the ring.  It includes a
>      type and subtype that indicate the source of the message
>      (eg. WATCH_TYPE_MOUNT_NOTIFY) and the kind of the message
>      (eg. NOTIFY_MOUNT_NEW_MOUNT).
> 
>      The header also contains an information field that conveys the
>      following information:
> 
> 	- WATCH_INFO_LENGTH.  The size of the entry (entries are variable
>           length).
> 
> 	- WATCH_INFO_ID.  The watch ID specified when the watchpoint was
>           set.
> 
> 	- WATCH_INFO_TYPE_INFO.  (Sub)type-specific information.
> 
> 	- WATCH_INFO_FLAG_*.  Flag bits overlain on the type-specific
>           information.  For use by the type.
> 
>      All the information in the header can be used in filtering messages at
>      the point of writing into the buffer.
> 
>  (2) struct watch_queue_buffer.
> 
>      This describes the layout of the ring.  Note that the first slots in
>      the ring contain a special metadata entry that contains the ring
>      pointers.  The producer in the kernel knows to skip this and it has a
>      proper header (WATCH_TYPE_META, WATCH_META_SKIP_NOTIFICATION) that
>      indicates the size so that the ring consumer can handle it the same as
>      any other record and just skip it.
> 
>      Note that this means that ring entries can never be split over the end
>      of the ring, so if an entry would need to be split, a skip record is
>      inserted to wrap the ring first; this is also WATCH_TYPE_META,
>      WATCH_META_SKIP_NOTIFICATION.
> 
>  (3) WATCH_INFO_NOTIFICATIONS_LOST.
> 
>      This is a flag that can be set in the metadata header by the kernel to
>      indicate that at least one message was lost since it was last cleared
>      by userspace.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
