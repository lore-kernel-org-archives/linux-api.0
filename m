From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock
 for reconfiguration [ver #12]
Date: Fri, 12 Oct 2018 15:49:50 +0100
Message-ID: <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com>
References: <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
 <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On 21/09/2018 17:34, David Howells wrote:
> Provide an fspick() system call that can be used to pick an existing
> mountpoint into an fs_context which can thereafter be used to reconfigure a
> superblock (equivalent of the superblock side of -o remount).
>
> This looks like:
>
> 	int fd = fspick(AT_FDCWD, "/mnt",
> 			FSPICK_CLOEXEC | FSPICK_NO_AUTOMOUNT);
> 	fsconfig(fd, FSCONFIG_SET_FLAG, "intr", NULL, 0);
> 	fsconfig(fd, FSCONFIG_SET_FLAG, "noac", NULL, 0);
> 	fsconfig(fd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);
>
> At the point of fspick being called, the file descriptor referring to the
> filesystem context is in exactly the same state as the one that was created
> by fsopen() after fsmount() has been successfully called.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-api@vger.kernel.org
> ---
>
>   arch/x86/entry/syscalls/syscall_32.tbl |    1 +
>   arch/x86/entry/syscalls/syscall_64.tbl |    1 +
>   fs/fsopen.c                            |   54 ++++++++++++++++++++++++++++++++
>   include/linux/syscalls.h               |    1 +
>   include/uapi/linux/fs.h                |    5 +++
>   5 files changed, 62 insertions(+)
>
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index c78b68256f8a..d1eb6c815790 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -403,3 +403,4 @@
>   389	i386	fsopen			sys_fsopen			__ia32_sys_fsopen
>   390	i386	fsconfig		sys_fsconfig			__ia32_sys_fsconfig
>   391	i386	fsmount			sys_fsmount			__ia32_sys_fsmount
> +392	i386	fspick			sys_fspick			__ia32_sys_fspick
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index d44ead5d4368..d3ab703c02bb 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -348,6 +348,7 @@
>   337	common	fsopen			__x64_sys_fsopen
>   338	common	fsconfig		__x64_sys_fsconfig
>   339	common	fsmount			__x64_sys_fsmount
> +340	common	fspick			__x64_sys_fspick
>   
>   #
>   # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/fsopen.c b/fs/fsopen.c
> index 5955a6b65596..9ead9220e2cb 100644
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c
> @@ -155,6 +155,60 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
>   	return ret;
>   }
>   
> +/*
> + * Pick a superblock into a context for reconfiguration.
> + */
> +SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags)
> +{
> +	struct fs_context *fc;
> +	struct path target;
> +	unsigned int lookup_flags;
> +	int ret;
> +
> +	if (!ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN))
> +		return -EPERM;


This seems to accept basically any mount.  Specifically: are you sure 
it's OK to return a handle to a SB_NO_USER superblock?

# strace -f -v -e trace=154 \
     ./fspick 3</proc/self/ns/mnt 3 \
     stat -f /dev/fd/3

syscall_0x154(0x3, 0x4009a1, 0x8, ...) = 0x4
   File: "/dev/fd/3"
     ID: 0        Namelen: 255     Type: anon-inode FS
Block size: 4096       Fundamental block size: 4096
Blocks: Total: 0          Free: 0          Available: 0
Inodes: Total: 0          Free: 0
+++ exited with 0 +++
