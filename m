From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] ARM64:Fix MINSIGSTKSZ and SIGSTKSZ
Date: Mon, 05 Oct 2015 12:58:04 +0200
Message-ID: <5166889.dum1bb5mjD@wuerfel>
References: <1444038969-14112-1-git-send-email-manjeet.p@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444038969-14112-1-git-send-email-manjeet.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Manjeet Pawar <manjeet.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pankaj.m-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Akhilesh Kumar <akhilesh.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Rohit Thapliyal <r.thapliyal-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday 05 October 2015 15:26:09 Manjeet Pawar wrote:
> -#define MINSIGSTKSZ    2048
> -#define SIGSTKSZ       8192
> +#ifdef CONFIG_ARM64
> +#define MINSIGSTKSZ 5120
> +#define SIGSTKSZ    16384
> +#else
> +#define MINSIGSTKSZ 2048
> +#define SIGSTKSZ    8192
> +#endif

uapi header files cannot use CONFIG_* symbols, as they are not visible
in user space.

If these have to be architecture-specific, override them in
arch/arm64/include/uapi/asm/signal.h

	Arnd
