From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Implement leftpad syscall
Date: Fri, 1 Apr 2016 11:46:29 +1300
Message-ID: <56FDA8C5.5030402@gmail.com>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
 <1459463613-32473-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459463613-32473-2-git-send-email-richard-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Gstir <david-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/01/2016 11:33 AM, Richard Weinberger wrote:
> From: David Gstir <david-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
> 
> Implement the leftpad() system call such that userspace,
> especially node.js applications, can in the near future directly
> use it and no longer depend on fragile npm packages.

Works can't express the importance of adding this system call!
Thanks so much for proposing and implementing it!

Acked-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Cheers,

Michael

> Signed-off-by: David Gstir <david-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
> Signed-off-by: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
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
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
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


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
