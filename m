From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kernel/sys_ni: sort cond_syscall() entries
Date: Wed, 7 Mar 2018 09:26:12 +0100
Message-ID: <20180307082612.tveaovxhhtvyu5dj@gmail.com>
References: <20180306185301.GA31061@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180306185301.GA31061@light.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, luto@amacapital.net, tglx@linutronix.de, viro@zeniv.linux.org.uk, ak@linux.intel.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org


* Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> Shuffle the cond_syscall() entries in kernel/sys_ni.c around so that they
> are kept in the same order as in include/uapi/asm-generic/unistd.h. For
> better structuring, add the same comments as in that file, but keep a few
> additional comments and extend the commentary where it seems useful.
> 
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> 
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
> + * system calls.

That's both a typo and wrong: 'follow' in this context means the exact opposite 
ordering.

I think this is more accurate:

    * Architecture specific entries go below, followed by deprecated or obsolete
    * system calls.

Thanks,

	Ingo
