From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [patch 3/4] timerfd: Implement timerfd_ioctl method to restore
 timerfd_ctx::ticks
Date: Wed, 02 Jul 2014 12:49:51 -0400
Message-ID: <53B4382F.9030908@codeaurora.org>
References: <20140623185431.396309193@openvz.org> <20140623190345.499956567@openvz.org> <20140624220351.GZ2095@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140624220351.GZ2095@moon>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Andrey Vagin <avagin@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Vladimir Davydov <vdavydov@parallels.com>, Linux ARM kernel mailing list <linux-arm-kernel@lists.infradead.org>
List-Id: linux-api@vger.kernel.org

Hi Cyrill,

On 06/24/2014 06:03 PM, Cyrill Gorcunov wrote:
> The read() of timerfd files allows to fetch the number of timer ticks
> while there is no way to set it back from userspace.
> 
> To restore the timer's state as it was at checkpoint moment we need
> a path to bring @ticks back. Initially I thought about writing ticks
> back via write() interface but it seems such API is somehow obscure.
> 
> Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
> command which allows to adjust @ticks into non-zero value waking
> up the waiters.
> 
> I wrapped code with CONFIG_CHECKPOINT_RESTORE which can be
> dropped off if there users except c/r camp appear.
> 
> v2 (by akpm@):
>  -Use define timerfd_ioctl NULL for non c/r config
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Vladimir Davydov <vdavydov@parallels.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> A nit fixed for for non c/r config in timerfd_ioctl declaration
> 
>  fs/timerfd.c            |   37 +++++++++++++++++++++++++++++++++++++
>  include/linux/timerfd.h |    5 +++++
>  2 files changed, 42 insertions(+)
> 
> Index: linux-2.6.git/fs/timerfd.c
> ===================================================================
> --- linux-2.6.git.orig/fs/timerfd.c
> +++ linux-2.6.git/fs/timerfd.c
> @@ -315,12 +315,49 @@ static int timerfd_show(struct seq_file
>  #define timerfd_show NULL
>  #endif
>  
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
> +	int ret = 0;
> +
> +	switch (cmd) {
> +	case TFD_IOC_SET_TICKS: {
> +		u64 ticks;
> +
> +		if (get_user(ticks, (u64 __user *)arg))

64-bit get_user is currently unsupported on ARM, although it appears work is
ongoing [1].

1. https://lkml.org/lkml/2014/6/17/260

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
