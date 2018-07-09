From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 7/7] aio: implement io_pgetevents
Date: Mon, 09 Jul 2018 21:21:53 +0200
Message-ID: <1632268.WSg4zQ7CbY@positron.chronox.de>
References: <20180502211448.18276-1-hch@lst.de> <20180704142116.GM17048@lisas.de> <20180708204359.GA19198@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180708204359.GA19198@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Adrian Reber <adrian@lisas.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
List-Id: linux-api@vger.kernel.org

Am Sonntag, 8. Juli 2018, 22:44:00 CEST schrieb Christoph Hellwig:

Hi Christoph,
> 
> diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
> index 75846164290e..b7705ad66d78 100644
> --- a/include/uapi/linux/aio_abi.h
> +++ b/include/uapi/linux/aio_abi.h
> @@ -29,7 +29,11 @@
> 
>  #include <linux/types.h>
>  #include <linux/fs.h>
> +#ifdef __KERNEL__
>  #include <linux/signal.h>
> +#else
> +#include <signal.h>
> +#endif
>  #include <asm/byteorder.h>

Without such a patch, libkcapi fails to compile as well. See [1].

Apart from your suggested patch above, do you have another suggestion how make 
the user space code compile?

[1] https://github.com/smuellerDD/libkcapi/issues/59


Thanks
Stephan
