From: Scotty Bauer <sbauer@eng.utah.edu>
Subject: Re: [PATCH] Implement leftpad syscall
Date: Fri, 1 Apr 2016 01:14:08 -0600
Message-ID: <56FE1FC0.4030909@eng.utah.edu>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
 <1459463613-32473-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459463613-32473-2-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, David Gstir <david@sigma-star.at>
List-Id: linux-api@vger.kernel.org



On 03/31/2016 04:33 PM, Richard Weinberger wrote:
> From: David Gstir <david@sigma-star.at>
> 
> Implement the leftpad() system call such that userspace,
> especially node.js applications, can in the near future directly
> use it and no longer depend on fragile npm packages.
> 
> Signed-off-by: David Gstir <david@sigma-star.at>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/x86/entry/syscalls/syscall_64.tbl |  1 +
>  include/linux/syscalls.h               |  1 +
>  kernel/sys.c                           | 35 ++++++++++++++++++++++++++++++++++
>  kernel/sys_ni.c                        |  1 +
>  4 files changed, 38 insertions(+)
> 
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index cac6d17..f287712 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -335,6 +335,7 @@
>  326	common	copy_file_range		sys_copy_file_range
>  327	64	preadv2			sys_preadv2
>  328	64	pwritev2		sys_pwritev2
> +329	common	leftpad			sys_leftpad
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index d795472..a0850bb 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -898,4 +898,5 @@ asmlinkage long sys_copy_file_range(int fd_in, loff_t __user *off_in,
>  
>  asmlinkage long sys_mlock2(unsigned long start, size_t len, int flags);
>  
> +asmlinkage long sys_leftpad(char *str, char pad, char *dst, size_t dst_len);
>  #endif
> diff --git a/kernel/sys.c b/kernel/sys.c
> index cf8ba54..e42d972 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2432,3 +2432,38 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
>  	return 0;
>  }
>  #endif /* CONFIG_COMPAT */
> +
> +
> +SYSCALL_DEFINE4(leftpad, char *, src, char, pad, char *, dst, size_t, dst_len)
> +{
> +	char *buf;
> +	long ret;
> +	size_t len = strlen_user(src);
> +	size_t pad_len = dst_len - len; 
> +
> +	if (dst_len <= len || dst_len > 4096) {
> +		return -EINVAL;
> +	}
> +
> +	buf = kmalloc(dst_len, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	memset(buf, pad, pad_len);
> +	ret = copy_from_user(buf + pad_len, src, len);
> +	if (ret) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = copy_to_user(dst, buf, dst_len);
> +	if (ret) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = pad_len;
> +out:
> +	kfree(buf);
> +	return ret;
> +}

This looks good, but since we want this to be as fast as possible we might just want to eliminate all
branches (Pesky bounds checks), and write directly into user memory to eliminate the pesky copy_from/copy_to. The second
idea would eliminate that slow kmalloc as well.

What do you think?

> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.
> index 2c5e3a8..262608d 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -175,6 +175,7 @@ cond_syscall(sys_setfsgid);
>  cond_syscall(sys_capget);
>  cond_syscall(sys_capset);
>  cond_syscall(sys_copy_file_range);
> +cond_syscall(sys_leftpad);
>  
>  /* arch-specific weak syscall entries */
>  cond_syscall(sys_pciconfig_read);
> 
