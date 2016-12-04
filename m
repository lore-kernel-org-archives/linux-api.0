From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available [ver #3]
Date: Sun, 4 Dec 2016 04:00:33 +0000
Message-ID: <20161204040026.GA32055@ZenIV.linux.org.uk>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
 <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 23, 2016 at 12:55:51AM +0000, David Howells wrote:

> -int vfs_getattr_nosec(struct path *path, struct kstat *stat)
> +int vfs_xgetattr_nosec(struct path *path, struct kstat *stat)

const struct path *, please.  Especially since we feed &file->f_path to
it.  And yes, I realize that the same applies to vfs_getattr() in the
current tree.

> +int vfs_xgetattr(struct path *path, struct kstat *stat)

Ditto.

> +int vfs_getattr(struct path *path, struct kstat *stat)

Again.

> +#define __put_timestamp(kts, uts) (				\
> +		__put_user(kts.tv_sec,	uts.tv_sec	) ||	\
> +		__put_user(kts.tv_nsec,	uts.tv_nsec	) ||		\
> +		__put_user(0,		uts.__reserved	))

static inline.

> +#define KSTAT_ATTR_FS_IOC_FLAGS		0x00000874 /* Attrs corresponding to FS_*_FL flags */

Err...  An explicit hex constant?
