From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 2/4] update .gitignore in selftests/timers
Date: Thu, 7 Jan 2016 13:52:22 -0700
Message-ID: <568ED006.9010003@osg.samsung.com>
References: <1452149642-7597-1-git-send-email-sunyuan3@huawei.com>
 <1452149642-7597-2-git-send-email-sunyuan3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452149642-7597-2-git-send-email-sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/06/2016 11:54 PM, Yuan Sun wrote:
> Signed-off-by: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/timers/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/timers/.gitignore b/tools/testing/selftests/timers/.gitignore
> index ced9981..68f3fc7 100644
> --- a/tools/testing/selftests/timers/.gitignore
> +++ b/tools/testing/selftests/timers/.gitignore
> @@ -16,3 +16,4 @@ set-timer-lat
>  skew_consistency
>  threadtest
>  valid-adjtimex
> +adjtick
> 

Thanks for doing this. Applied to linux-kselftest next
for 4.5-rc1

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
