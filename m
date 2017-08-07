From: Olga Kornievskaia <kolga-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 0/3] VFS/NFS support to destroy FS credentials
Date: Mon, 7 Aug 2017 17:23:51 -0400
Message-ID: <20170807212355.29127-1-kolga@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Allow a user to call into the file system and ask to destroy FS
credentials. For instance, when the user logs out after using
a kerberized NFS share, he destroys Kerberos credentials but NFS
credentials remain valid until the gss context expires. Allow
the user (or things like pam) to trigger destruction of such
credentials.

A userland application would do:

fd = open("/mnt", O_DIRECTORY|O_RDONLY);
syscall(_NR_destroy_creds, fd);

v2: fixing a hasty IS_DIR check, definition of __NR_destroy_creds
and order of the patches
 
v3: 
* changing error codes
  in VFS return ENOSYS for when destroy_creds is not defined
  in VFS return EBADF if file descriptor is wrong
  return 0 is success (before I had 1 as success and 0 as failure)
  in SUNRPC patch, when credentials are not found return ENOENT not
    EACCES
* including man page

Olga Kornievskaia (3):
  VFS adding destroy_creds call
  SUNRPC mark user credentials destroyed
  NFS define vfs destroy_creds functions

 arch/x86/entry/syscalls/syscall_32.tbl |  1 +
 arch/x86/entry/syscalls/syscall_64.tbl |  1 +
 fs/nfs/dir.c                           |  8 ++++++++
 fs/read_write.c                        | 22 ++++++++++++++++++++++
 include/linux/fs.h                     |  2 ++
 include/linux/sunrpc/auth.h            |  5 +++++
 include/linux/syscalls.h               |  2 +-
 include/uapi/asm-generic/unistd.h      |  4 +++-
 kernel/sys_ni.c                        |  1 +
 net/sunrpc/auth.c                      |  9 +++++++++
 net/sunrpc/auth_generic.c              | 15 +++++++++++++++
 net/sunrpc/auth_gss/auth_gss.c         |  3 +++
 12 files changed, 71 insertions(+), 2 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
