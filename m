From: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mtd: Expand the ecc placement locations to 1216
Date: Fri, 20 Nov 2015 11:33:42 -0800
Message-ID: <20151120193342.GX64635@google.com>
References: <1446742735-20824-1-git-send-email-punnaia@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446742735-20824-1-git-send-email-punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
Cc: dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, michals-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kpc528-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kalluripunnaiahchoudary-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Punnaiah Choudary Kalluri <punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 05, 2015 at 10:28:55PM +0530, Punnaiah Choudary Kalluri wrote:
> Device like MT29F32G08ABCDBJ4 have a writesize/oobsize of 16K/1216 Bytes.
> So, increasing the maximum ecc placement locations to 1216

I'd really prefer not increasing the size of the internal arrays any
more. The structures should be rewritten to be dynamic.

> Signed-off-by: Punnaiah Choudary Kalluri <punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/mtd/mtd.h    | 2 +-
>  include/uapi/mtd/mtd-abi.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> index f17fa75..1fd3cc6 100644
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -95,7 +95,7 @@ struct mtd_oob_ops {
>  };
>  
>  #define MTD_MAX_OOBFREE_ENTRIES_LARGE	32
> -#define MTD_MAX_ECCPOS_ENTRIES_LARGE	640
> +#define MTD_MAX_ECCPOS_ENTRIES_LARGE	1216
>  /*
>   * Internal ECC layout control structure. For historical reasons, there is a
>   * similar, smaller struct nand_ecclayout_user (in mtd-abi.h) that is retained
> diff --git a/include/uapi/mtd/mtd-abi.h b/include/uapi/mtd/mtd-abi.h
> index 763bb69..c4d592c 100644
> --- a/include/uapi/mtd/mtd-abi.h
> +++ b/include/uapi/mtd/mtd-abi.h
> @@ -220,8 +220,8 @@ struct nand_oobfree {
>  	__u32 length;
>  };
>  
> -#define MTD_MAX_OOBFREE_ENTRIES	8
> -#define MTD_MAX_ECCPOS_ENTRIES	64
> +#define MTD_MAX_OOBFREE_ENTRIES	32
> +#define MTD_MAX_ECCPOS_ENTRIES	1216

NAK. This is part of the ABI, and changing this will break user space.
If you actually bothered to read code, you might understand why there
are now internal and external versions of this struct. The external
(user space) version cannot be changed. The internal version can be
refactored, as long as the external version still maintains some sanity,
at least for old/small devices.

>  /*
>   * OBSOLETE: ECC layout control structure. Exported to user-space via ioctl
>   * ECCGETLAYOUT for backwards compatbility and should not be mistaken as a

Brian
