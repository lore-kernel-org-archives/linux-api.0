From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] Add renameat2 function [BZ #17662]
Date: Mon, 2 Jul 2018 11:32:50 +0200
Message-ID: <83bc54c8-ea97-22f7-360f-523e5979864a@redhat.com>
References: <20180630121447.E4C8643994575@oldenburg.str.redhat.com>
 <20180701214901.GA32498@yury-thinkpad>
 <60505ccf-a399-6320-74f5-e2e17965d25c@redhat.com>
 <20180702084622.GA15274@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702084622.GA15274@yury-thinkpad>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: libc-alpha@sourceware.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/02/2018 10:46 AM, Yury Norov wrote:

> Is my understanding correct that glibc community finds <linux/fs.h>
> inappropriate for their use, and prefer to re-introduce (duplicate)
> its functionality locally? I think it's wrong. The right way to go
> is to make kernel headers comfortable for users instead of ignoring
> it.

In some cases, we already use UAPI headers (<linux/falloc.h> is an 
example), but it is not always possible.

> Are you OK to switch to kernel RENAME_* definitions if they will be
> located in separated small file? Like in the patch below.
> 
> Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
> ---
>   include/uapi/linux/fs.h     |  4 +---
>   include/uapi/linux/rename.h | 12 ++++++++++++
>   2 files changed, 13 insertions(+), 3 deletions(-)
>   create mode 100644 include/uapi/linux/rename.h
> 
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index c27576d471c2..46c03ea31a76 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -44,9 +44,7 @@
>   #define SEEK_HOLE	4	/* seek to the next hole */
>   #define SEEK_MAX	SEEK_HOLE
>   
> -#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
> -#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
> -#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
> +#include <linux/rename.h>
>   
>   struct file_clone_range {
>   	__s64 src_fd;
> diff --git a/include/uapi/linux/rename.h b/include/uapi/linux/rename.h
> new file mode 100644
> index 000000000000..7178f0565657
> --- /dev/null
> +++ b/include/uapi/linux/rename.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_RENAME_H
> +#define _UAPI_LINUX_RENAME_H
> +
> +/*
> + * Definitions for rename syscall family.
> + */
> +#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
> +#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
> +#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
> +
> +#endif /* _UAPI_LINUX_RENAME_H */

This would help.

We would need to provide definitions for compatibility with older kernel 
headers locally, but on newer kernels, we could use the UAPI header file.

Thanks,
Florian
