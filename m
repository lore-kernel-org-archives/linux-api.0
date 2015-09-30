From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests: add .gitignore for efivarfs
Date: Wed, 30 Sep 2015 07:34:45 -0600
Message-ID: <560BE4F5.60000@osg.samsung.com>
References: <1443492239-5231-1-git-send-email-sunyuan3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443492239-5231-1-git-send-email-sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/28/2015 08:03 PM, Yuan Sun wrote:
> Signed-off-by: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/efivarfs/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
>  create mode 100644 tools/testing/selftests/efivarfs/.gitignore
> 
> diff --git a/tools/testing/selftests/efivarfs/.gitignore b/tools/testing/selftests/efivarfs/.gitignore
> new file mode 100644
> index 0000000..3361849
> --- /dev/null
> +++ b/tools/testing/selftests/efivarfs/.gitignore
> @@ -0,0 +1,2 @@
> +create-read
> +open-unlink
> 

Thanks for fixing this. Patch applied to linux-kselftest next for 4.4

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
