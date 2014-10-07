From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Tue, 7 Oct 2014 14:30:40 +0100
Message-ID: <20141007133039.GG7996@ZenIV.linux.org.uk>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1412683977-29543-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrey Vagin <avagin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>, Rob Landley <rob@landley.net>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 07, 2014 at 04:12:57PM +0400, Andrey Vagin wrote:
> Another problem is that rootfs can't be hidden from a container, because
> rootfs can't be moved or umounted.

... which is a bug in mntns_install(), AFAICS.

> Here is an example how to get access to rootfs:
> fd = open("/proc/self/ns/mnt", O_RDONLY)
> umount2("/", MNT_DETACH);
> setns(fd, CLONE_NEWNS)
> 
> rootfs may contain data, which should not be avaliable in CT-s.

Indeed.

> I suggest to add ability to create a mount namespace with specified
> mount points. A current task root can be used as a root for the new
> mount namespace.

Yecchh...  Frankly, you are opening a big can of worms - having rootfs
as absolute root of all namespaces simplifies a lot of things in there.
