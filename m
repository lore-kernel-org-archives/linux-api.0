From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 30/33] vfs: syscall: Add fspick() to select a superblock
 for reconfiguration [ver #11]
Date: Fri, 24 Aug 2018 16:51:22 +0200
Message-ID: <CAELBmZCv3uAmXiSEk3vdYEy8wn_mP8Rs6qzMqSa56_kPsb_=aA@mail.gmail.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <153313724861.13253.3837522702693613670.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153313724861.13253.3837522702693613670.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 1, 2018 at 5:29 PM David Howells <dhowells@redhat.com> wrote:

> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -351,6 +351,11 @@ typedef int __bitwise __kernel_rwf_t;
>
>  #define FSMOUNT_CLOEXEC                0x00000001
>
> +#define FSPICK_CLOEXEC         0x00000001
> +#define FSPICK_SYMLINK_NOFOLLOW        0x00000002
> +#define FSPICK_NO_AUTOMOUNT    0x00000004
> +#define FSPICK_EMPTY_PATH      0x00000008

This caught my eye:  why aren't we using the AT_ constants?  Adding an
AT_CLOEXEC sounds less horrible than duplicating all the lookup
related flags for FSPICK...

Thanks,
Miklos




> +
>  /*
>   * The type of fsconfig() call made.
>   */
>
