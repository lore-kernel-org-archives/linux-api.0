From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] kernel/sys_ni: sort cond_syscall() entries
Date: Tue, 6 Mar 2018 12:02:51 -0800
Message-ID: <3d7b7278-e849-2673-564e-10a65774ee58@infradead.org>
References: <20180306185301.GA31061@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306185301.GA31061@light.dominikbrodowski.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: torvalds@linux-foundation.org, luto@amacapital.net, mingo@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, ak@linux.intel.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 03/06/2018 10:53 AM, Dominik Brodowski wrote:

> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index b5189762d275..44c65e4d2528 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -17,245 +17,403 @@ asmlinkage long sys_ni_syscall(void)
>  	return -ENOSYS;
>  }
>  
> -cond_syscall(sys_quotactl);
> -cond_syscall(sys32_quotactl);
> -cond_syscall(sys_acct);
> +/*
> + * This list is kept in the same order as include/uapi/asm-generic/unistd.h.
> + * Architecture specific entries go below, then follow deprecated or obsolote

                                                                        obsolete

> + * system calls.
> + */

> 


-- 
~Randy
