From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/8] signal/sparc: Document a conflict with SI_USER
 with SIGFPE
Date: Fri, 30 Jun 2017 12:45:05 -0400 (EDT)
Message-ID: <20170630.124505.736865959393416284.davem@davemloft.net>
References: <87efu22set.fsf@xmission.com>
        <20170630123906.8865-3-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170630123906.8865-3-ebiederm@xmission.com>
Sender: linux-arch-owner@vger.kernel.org
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, luto@kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, oleg@redhat.com, avagin@virtuozzo.com, tglx@linutronix.de, greg@kroah.com, avagin@openvz.org, serge@hallyn.com, xemul@virtuozzo.com, gorcunov@openvz.org, peterz@infradead.org, w@1wt.eu, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, mtk.manpages@gmail.com, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 30 Jun 2017 07:39:01 -0500

> diff --git a/arch/sparc/include/uapi/asm/siginfo.h b/arch/sparc/include/uapi/asm/siginfo.h
> index 2d9b79ccaa50..6bc5c677e92f 100644
> --- a/arch/sparc/include/uapi/asm/siginfo.h
> +++ b/arch/sparc/include/uapi/asm/siginfo.h
> @@ -17,6 +17,11 @@
>  #define SI_NOINFO	32767		/* no information in siginfo_t */
>  
>  /*
> + * SIGFPE si_codes
> + */
> +#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
> +
> +/*
>   * SIGEMT si_codes
>   */
>  #define EMT_TAGOVF	(__SI_FAULT|1)	/* tag overflow */

It's one thing to say FIXME in a comment in a kernel local header or
C file.

It's quite another to put this into the name of a macro which has
visibility in the global user compilation namespace.

I don't think you should really do that.
