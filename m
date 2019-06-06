From: Christian Brauner <christian@brauner.io>
Subject: Re: [RFC][PATCH 00/10] Mount, FS, Block and Keyrings notifications
 [ver #3]
Date: Thu, 6 Jun 2019 16:34:21 +0200
Message-ID: <20190606143420.hxjximmhigpa2nti@brauner.io>
References: <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, linux-usb@vger.kernel.org, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 06, 2019 at 10:41:59AM +0100, David Howells wrote:
> 
> Hi Al,
> 
> Here's a set of patches to add a general variable-length notification queue
> concept and to add sources of events for:
> 
>  (1) Mount topology events, such as mounting, unmounting, mount expiry,
>      mount reconfiguration.
> 
>  (2) Superblock events, such as R/W<->R/O changes, quota overrun and I/O
>      errors (not complete yet).
> 
>  (3) Key/keyring events, such as creating, linking and removal of keys.
> 
>  (4) General device events (single common queue) including:
> 
>      - Block layer events, such as device errors
> 
>      - USB subsystem events, such as device/bus attach/remove, device
>        reset, device errors.
> 
> One of the reasons for this is so that we can remove the issue of processes
> having to repeatedly and regularly scan /proc/mounts, which has proven to
> be a system performance problem.  To further aid this, the fsinfo() syscall
> on which this patch series depends, provides a way to access superblock and
> mount information in binary form without the need to parse /proc/mounts.
> 
> 
> LSM support is included, but controversial:

Apart from the LSM/security controversy here the general direction of
this patchset is pretty well received it seems.
Imho, having a notification mechanism like this is a very good thing for
userspace. So would be great if there'd be a consensus on the LSM bits.

Christian
