From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 17/23] kmsg_dumper: Introduce a new 'SOFT' dump reason
Date: Tue,  9 Nov 2010 14:49:13 +0900 (JST)
Message-ID: <20101109144749.BC6C.A69D9226@jp.fujitsu.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com> <20101108203316.22479.86025.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101108203316.22479.86025.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Americo Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi

> It is a useful to be able to exercise kmsg_dumper implementations without
> requiring a kernel oops or panic.  This commit adds a new reason called
> KMSG_DUMP_SOFT, which signifies that the system isn't really going down.
> 
> This logic is used in a later commit that introduces the netoops driver.
> 
> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> 
> It is also possible that we not introduce KMSG_DUMP_SOFT, and simply overload
> the existing KMSG_DUMP_OOPS reason, but I figured that this would be cleaner.
> 
> TODO: Make sure mtdoops and ramoops do something useful with this flag?

Yes. If userland explicitly want to log, we have no reason to refuse it. :)
But, I don't think KMSG_DUMP_SOFT is good name because _SOFT don't explain
anything.



> ---
>  include/linux/kmsg_dump.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
> index a229acc..0abc2d7 100644
> --- a/include/linux/kmsg_dump.h
> +++ b/include/linux/kmsg_dump.h
> @@ -20,6 +20,7 @@ enum kmsg_dump_reason {
>  	KMSG_DUMP_OOPS,
>  	KMSG_DUMP_PANIC,
>  	KMSG_DUMP_KEXEC,
> +	KMSG_DUMP_SOFT,
>  };
>  
>  /**
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
