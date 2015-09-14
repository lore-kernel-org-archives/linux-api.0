From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] seltests/zram: fix syntax error
Date: Mon, 14 Sep 2015 16:54:48 -0600
Message-ID: <55F75038.50809@osg.samsung.com>
References: <1442203768-35696-1-git-send-email-zhenzhang.zhang@huawei.com>
 <55F64967.3090508@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F64967.3090508-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/13/2015 10:13 PM, Zhang Zhen wrote:
> Not all shells define a variable UID. This is a bash and zsh feature only.
> In other shells, the UID variable is not defined, so here test command
> expands to [ != 0 ] which is a syntax error.
> 
> Without this patch:
> root@HGH1000007090:/opt/work/linux/tools/testing/selftests/zram# sh zram.sh
> zram.sh: 8: [: !=: unexpected operator
> zram.sh : No zram.ko module or /dev/zram0 device file not found
> zram.sh : CONFIG_ZRAM is not set
> 
> With this patch:
> root@HGH1000007090:/opt/work/linux/tools/testing/selftests/zram# sh ./zram.sh
> zram.sh : No zram.ko module or /dev/zram0 device file not found
> zram.sh : CONFIG_ZRAM is not set
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/zram/zram.sh     | 10 +---------
>  tools/testing/selftests/zram/zram_lib.sh |  3 ++-
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 

Thanks for fixing this. Applied to linux-kselftest fixes for 4.3-rc2

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
