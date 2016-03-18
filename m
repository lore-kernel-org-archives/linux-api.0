From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v20 00/23] Richacls (Core and Ext4)
Date: Fri, 18 Mar 2016 00:20:40 -0500
Message-ID: <CAH2r5mu66qi=G6sMNQzS_Ciu9ctyS4Q+bKskVqk1Hj5_x7FWng@mail.gmail.com>
References: <1458166743-18488-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458166743-18488-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Reviewing the current version of your patch series in your tree
 git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
        richacl-2016-03-16

you can add my reviewed by to the following patches so far:
0001-vfs-Add-IS_ACL-and-IS_RICHACL-tests.patch
0002-vfs-Add-MAY_CREATE_FILE-and-MAY_CREATE_DIR-permissio.patch
0003-vfs-Add-MAY_DELETE_SELF-and-MAY_DELETE_CHILD-permiss.patch
0004-vfs-Make-the-inode-passed-to-inode_change_ok-non-con.patch
0005-vfs-Add-permission-flags-for-setting-file-attributes.patch
0011-posix_acl-Improve-xattr-fixup-code.patch
0013-vfs-Add-get_richacl-and-set_richacl-inode-operations.patch
0024-xfs-Make-xfs_set_mode-non-static.patch
0042-ext4-Don-t-allow-unmapped-identifiers-in-richacls.patch
0043-xfs-Don-t-allow-unmapped-identifiers-in-richacls.patch

Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

On Wed, Mar 16, 2016 at 5:18 PM, Andreas Gruenbacher
<agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Al,
>
> here is a minor update to the richacl patches with some feedback from Christoph
> incorporated.
>
> Changes since the last posting (https://lkml.org/lkml/2016/3/14/503):
>
>  * Merge richacl_base.c and richacl_inode.c into richacl.c.
>
>  * Add linux/acl.h header including function acl_chmod.
>    Use it in richacl enabled filesystems.
>
>
> The complete patch queue is available here:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
>         richacl-2016-03-16
>
>
> The richacl user-space utilitites, man pages, and test suite are available
> here:
>
>   https://github.com/andreas-gruenbacher/richacl
>
>
> Changes to other user-space packages for richacl:
>
>   https://github.com/andreas-gruenbacher/coreutils
>   https://github.com/andreas-gruenbacher/e2fsprogs
>   https://github.com/andreas-gruenbacher/samba
>   https://github.com/andreas-gruenbacher/xfsprogs-dev
>   https://github.com/andreas-gruenbacher/nfs-utils
>
>
> Please see the richacl homepage for more information:
>
>   http://www.bestbits.at/richacl/
>
>
> Thanks,
> Andreas
>
> Andreas Gruenbacher (21):
>   vfs: Add IS_ACL() and IS_RICHACL() tests
>   vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR permission flags
>   vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD permission flags
>   vfs: Make the inode passed to inode_change_ok non-const
>   vfs: Add permission flags for setting file attributes
>   richacl: In-memory representation and helper functions
>   richacl: Permission mapping functions
>   richacl: Compute maximum file masks from an acl
>   richacl: Permission check algorithm
>   posix_acl: Unexport acl_by_type and make it static
>   posix_acl: Improve xattr fixup code
>   vfs: Cache base_acl objects in inodes
>   vfs: Add get_richacl and set_richacl inode operations
>   vfs: Cache richacl in struct inode
>   richacl: Update the file masks in chmod()
>   richacl: Check if an acl is equivalent to a file mode
>   richacl: Create-time inheritance
>   richacl: Automatic Inheritance
>   richacl: xattr mapping functions
>   richacl: Add richacl xattr handler
>   vfs: Add richacl permission checking
>
> Aneesh Kumar K.V (2):
>   ext4: Add richacl support
>   ext4: Add richacl feature flag
>
>  drivers/staging/lustre/lustre/llite/llite_lib.c |   2 +-
>  fs/Kconfig                                      |   3 +
>  fs/Makefile                                     |   1 +
>  fs/attr.c                                       |  81 ++-
>  fs/ext4/Kconfig                                 |  11 +
>  fs/ext4/Makefile                                |   1 +
>  fs/ext4/ext4.h                                  |   6 +-
>  fs/ext4/file.c                                  |   3 +
>  fs/ext4/ialloc.c                                |  11 +-
>  fs/ext4/inode.c                                 |   5 +-
>  fs/ext4/namei.c                                 |   5 +
>  fs/ext4/richacl.c                               | 137 ++++
>  fs/ext4/richacl.h                               |  40 ++
>  fs/ext4/super.c                                 |  49 +-
>  fs/ext4/xattr.c                                 |   7 +
>  fs/f2fs/acl.c                                   |   4 +-
>  fs/inode.c                                      |  15 +-
>  fs/jffs2/acl.c                                  |  10 +-
>  fs/namei.c                                      | 118 +++-
>  fs/posix_acl.c                                  |  50 +-
>  fs/richacl.c                                    | 889 ++++++++++++++++++++++++
>  fs/richacl_xattr.c                              | 235 +++++++
>  fs/xattr.c                                      |  29 +-
>  include/linux/acl.h                             |  15 +
>  include/linux/fs.h                              |  60 +-
>  include/linux/posix_acl.h                       |  13 +-
>  include/linux/richacl.h                         | 205 ++++++
>  include/linux/richacl_xattr.h                   |  31 +
>  include/uapi/linux/Kbuild                       |   2 +
>  include/uapi/linux/fs.h                         |   3 +-
>  include/uapi/linux/richacl.h                    | 152 ++++
>  include/uapi/linux/richacl_xattr.h              |  44 ++
>  include/uapi/linux/xattr.h                      |   2 +
>  33 files changed, 2131 insertions(+), 108 deletions(-)
>  create mode 100644 fs/ext4/richacl.c
>  create mode 100644 fs/ext4/richacl.h
>  create mode 100644 fs/richacl.c
>  create mode 100644 fs/richacl_xattr.c
>  create mode 100644 include/linux/acl.h
>  create mode 100644 include/linux/richacl.h
>  create mode 100644 include/linux/richacl_xattr.h
>  create mode 100644 include/uapi/linux/richacl.h
>  create mode 100644 include/uapi/linux/richacl_xattr.h
>
> --
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
