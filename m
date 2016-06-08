From: "Zhangjian (Bamvor)" <bamvor.zhangjian@huawei.com>
Subject: Re: [RFC PATCH] sys_read: add a compat_sys_read for 64bit system
Date: Wed, 8 Jun 2016 10:14:41 +0800
Message-ID: <57577F91.5080308@huawei.com>
References: <575775FA.1080009@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <575775FA.1080009@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Weidong Wang <wangweidong1@huawei.com>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Hanjun Guo <guohanjun@huawei.com>, "Zhangjian (Bamvor)" <bamvor.zhangjian@huawei.com>, Linux-Api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi,

On 2016/6/8 9:33, Weidong Wang wrote:
> Test 32 progress and 64 progress on the 64bit system with
> this progress:
>
> int main(int argc, char **argv)
> {
>          int fd = 0;
>          int i, ret = 0;
>          char buf[512];
>          unsigned long count = -1;
>
>          fd = open("/tmp", O_RDONLY);
>          if (fd < -1) {
>                  printf("Pls check the directory is exist?\n");
>                  return -1;
>          }
>          errno = 0;
>          ret = read(fd, NULL, count);
>          printf("Ret is %d errno %d\n", ret, errno);
>          close(fd);
>
>          return 0;
> }
>
> we get the different errno. The 64 progress we get errno is -14 while
> the 32 progress is -21.
>
> The reason is that, the user progress would use a 32bit count, while
> the sys_read size_t in kernel is 64bit.  When the uesrspace count is
> -1(0xffffffff), it goes to the sys_read, it would be change to a positive
> number.
>
> So I think we should add a compat_sys_read for the read syscall. I test it
> on x86 or arm64 platform. The patch works well.
As weidong said, we tested on x86, x86_64, aarch64 ilp32, aarch64 lp64.
We do not familiar with other architecture, cc linux-api, hope could get more
input.

Regards

Bamvor
>
> As well this patch may do work for the 'tile' 64 system.
> I think it may enter the same result on mips/parisc/powerpc/sparc.
> The s390 do the compat_sys_s390_read for the compat sys_read.
>
> Signed-off-by: Weidong Wang <wangweidong1@huawei.com>
> ---
>   arch/x86/entry/syscalls/syscall_32.tbl | 2 +-
>   fs/read_write.c                        | 8 ++++++++
>   include/linux/compat.h                 | 2 ++
>   include/uapi/asm-generic/unistd.h      | 2 +-
>   4 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index 4cddd17..ebc24e3 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -9,7 +9,7 @@
>   0	i386	restart_syscall		sys_restart_syscall
>   1	i386	exit			sys_exit
>   2	i386	fork			sys_fork			sys_fork
> -3	i386	read			sys_read
> +3	i386	read			sys_read			compat_sys_read
>   4	i386	write			sys_write
>   5	i386	open			sys_open			compat_sys_open
>   6	i386	close			sys_close
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 933b53a..d244848 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -613,6 +613,14 @@ SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
>   	return ret;
>   }
>
> +#ifdef CONFIG_COMPAT
> +COMPAT_SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf,
> +		compat_size_t, count)
> +{
> +        return sys_read(fd, buf, (compat_ssize_t)count);
> +}
> +#endif
> +
>   SYSCALL_DEFINE4(pread64, unsigned int, fd, char __user *, buf,
>   			size_t, count, loff_t, pos)
>   {
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index f964ef7..d88ccad 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -332,6 +332,8 @@ asmlinkage long compat_sys_keyctl(u32 option,
>   			      u32 arg2, u32 arg3, u32 arg4, u32 arg5);
>   asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32);
>
> +asmlinkage ssize_t compat_sys_read(unsigned int fd,
> +		char __user * buf, compat_size_t count);
>   asmlinkage ssize_t compat_sys_readv(compat_ulong_t fd,
>   		const struct compat_iovec __user *vec, compat_ulong_t vlen);
>   asmlinkage ssize_t compat_sys_writev(compat_ulong_t fd,
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index a26415b..745818a 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -201,7 +201,7 @@ __SC_COMP(__NR_getdents64, sys_getdents64, compat_sys_getdents64)
>   #define __NR3264_lseek 62
>   __SC_3264(__NR3264_lseek, sys_llseek, sys_lseek)
>   #define __NR_read 63
> -__SYSCALL(__NR_read, sys_read)
> +__SC_COMP(__NR_read, sys_read, compat_sys_read)
>   #define __NR_write 64
>   __SYSCALL(__NR_write, sys_write)
>   #define __NR_readv 65
>
