From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 25/25] fsinfo: Add API documentation [ver #13]
Date: Wed, 5 Jun 2019 13:21:48 +0100
Message-ID: <d88b3276-a81a-d5a6-76d6-1a01376aa31c@gmail.com>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905647369.1662.10806818386998503329.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905647369.1662.10806818386998503329.stgit@warthog.procyon.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On 28/05/2019 16:14, David Howells wrote:
> +Then there are attributes that convey information about the mount topology:
> +
> + *  ``FSINFO_ATTR_MOUNT_INFO``
> +
> +    This struct-type attribute conveys information about a mount topology node
> +    rather than a superblock.  This includes the ID of the superblock mounted
> +    there and the ID of the mount node, its parent, group, master and
> +    propagation source.  It also contains the attribute flags for the mount and
> +    a change notification counter so that it can be quickly determined if that
> +    node changed.
> +
> + *  ``FSINFO_ATTR_MOUNT_DEVNAME``
> +
> +    This string-type attribute returns the "device name" that was supplied when
> +    the mount object was created.
> +
> + *  ``FSINFO_ATTR_MOUNT_CHILDREN``
> +
> +    This is an array-type attribute that conveys a set of structs, each of
> +    which indicates the mount ID of a child and the change counter for that
> +    child.  The kernel also tags an extra element on the end that indicates the
> +    ID and change counter of the queried object.  This allows a conflicting
> +    change to be quickly detected by comparing the before and after counters.
> +
> + *  ``FSINFO_ATTR_MOUNT_SUBMOUNT``
> +
> +    This is a string-type attribute that conveys the pathname of the Nth
> +    mountpoint under the target mount, relative to the mount root or the
> +    chroot, whichever is closer.  These correspond on a 1:1 basis with the
> +    eleemnts in the FSINFO_ATTR_MOUNT_CHROOT list.

FSINFO_ATTR_MOUNT_CHROOT -> FSINFO_ATTR_MOUNT_CHILDREN
