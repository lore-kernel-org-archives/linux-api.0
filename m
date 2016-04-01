From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Implement leftpad syscall
Date: Fri, 1 Apr 2016 03:33:34 +0200
Message-ID: <20160401013333.GA7875@lerouge>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
 <1459463613-32473-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459463613-32473-2-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Gstir <david@sigma-star.at>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 01, 2016 at 12:33:32AM +0200, Richard Weinberger wrote:
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

Have you considered /dev/leftpad instead?
