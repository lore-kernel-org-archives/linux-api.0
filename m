From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 0/5] VFS: Introduce filesystem information query syscall
 [ver #12]
Date: Fri, 21 Sep 2018 21:50:32 +0200
Message-ID: <f3646774-ee9e-d5b7-8a11-670012034d59@rasmusvillemoes.dk>
References: <153754786825.19213.16907802981157370740.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153754786825.19213.16907802981157370740.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On 2018-09-21 18:37, David Howells wrote:

> 
>  arch/x86/entry/syscalls/syscall_32.tbl |    1 
>  arch/x86/entry/syscalls/syscall_64.tbl |    1 
>  fs/afs/internal.h                      |    1 
>  fs/afs/super.c                         |  168 +++++++++
>  fs/hugetlbfs/inode.c                   |   66 ++++
>  fs/kernfs/mount.c                      |   16 +
>  fs/statfs.c                            |  587 ++++++++++++++++++++++++++++++++
>  include/linux/fs.h                     |    4 
>  include/linux/fsinfo.h                 |   41 ++
>  include/linux/kernfs.h                 |    2 
>  include/linux/syscalls.h               |    4 
>  include/uapi/linux/fsinfo.h            |  303 ++++++++++++++++
>  kernel/cgroup/cgroup-v1.c              |   72 ++++
>  kernel/cgroup/cgroup.c                 |   31 ++
>  samples/vfs/Makefile                   |    6 
>  samples/vfs/test-fs-query.c            |  138 +++++++
>  samples/vfs/test-fsinfo.c              |  589 ++++++++++++++++++++++++++++++++
>  17 files changed, 2028 insertions(+), 2 deletions(-)

Would you consider adding a Kconfig knob to not include all this (and
all the extra tricks that syscall might learn down the road)?

Rasmus
