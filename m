From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] xgetdents system call
Date: Tue, 29 Jul 2014 10:18:37 +0200
Message-ID: <CAHO5Pa2Fg986M+AZmj87pzywTsXSL+z8gmbrh1yTLHGEDieOxA@mail.gmail.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406309888-10749-1-git-send-email-adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 7:38 PM, Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This system call takes 5 arguments:
> fd    - file descriptor of the directory
> flags - flags used by xstat
> mask  - field mask used to request stat/xattr info
> buf   - user buf to return collected info
> count - size of user buffer in bytes
>
> xgetdents() should read the directory entries, collect stat
> and xattr information for each entry as requested and return
> all the data back to the user in a container structure
> (linux_xdirent) as part of the supplied user buffer.

Hello Abhi,

As per Documentation/SubmitChecklist, please CC linux-api on patches
that change the kerne-user-space API/ABI. (See
https://www.kernel.org/doc/man-pages/linux-api-ml.html for more
details.)

Cheers,

Michael



> Abhi Das (5):
>   fs: xstat system call VFS bits
>   fs: Add xgetdents system call and xreaddir file operation
>   gfs2: Add a dynamic buffer backed by a vector of pages
>   gfs2: Add sort functionality with extra parameter
>   gfs2: Add xreaddir file operation and supporting functions
>
>  arch/x86/syscalls/syscall_32.tbl |    3 +
>  arch/x86/syscalls/syscall_64.tbl |    3 +
>  fs/gfs2/Makefile                 |    3 +-
>  fs/gfs2/dir.c                    |   80 +--
>  fs/gfs2/dir.h                    |   13 +-
>  fs/gfs2/export.c                 |    2 +-
>  fs/gfs2/file.c                   |   17 +-
>  fs/gfs2/incore.h                 |    6 +
>  fs/gfs2/inode.c                  |    3 +-
>  fs/gfs2/inode.h                  |    5 +
>  fs/gfs2/ops_fstype.c             |    4 +
>  fs/gfs2/sys.c                    |   26 +-
>  fs/gfs2/util.c                   |  363 ++++++++++++++
>  fs/gfs2/util.h                   |   47 ++
>  fs/gfs2/xattr.c                  |   27 +-
>  fs/gfs2/xattr.h                  |   23 +
>  fs/gfs2/xreaddir.c               | 1024 ++++++++++++++++++++++++++++++++++++++
>  fs/gfs2/xreaddir.h               |   84 ++++
>  fs/readdir.c                     |   42 ++
>  fs/stat.c                        |  340 ++++++++++++-
>  include/linux/fs.h               |    5 +
>  include/linux/stat.h             |   16 +-
>  include/linux/syscalls.h         |    5 +
>  include/uapi/linux/fcntl.h       |    1 +
>  include/uapi/linux/stat.h        |  143 ++++++
>  25 files changed, 2196 insertions(+), 89 deletions(-)
>  create mode 100644 fs/gfs2/xreaddir.c
>  create mode 100644 fs/gfs2/xreaddir.h
>
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
