From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests/mount: Make git ignore all binaries in mount
 test suite
Date: Tue, 31 Mar 2015 15:36:56 -0600
Message-ID: <551B1378.5050205@osg.samsung.com>
References: <1427507045-68758-1-git-send-email-zhenzhang.zhang@huawei.com> <55160911.8080302@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55160911.8080302-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/27/2015 07:51 PM, Zhang Zhen wrote:
> This patch includes the mount test binaries into the .gitignore
> file listing in their respective directories. This will make sure
> that git ignores all of these test binaries when displaying status.
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/mount/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
>  create mode 100644 tools/testing/selftests/mount/.gitignore
> 
> diff --git a/tools/testing/selftests/mount/.gitignore b/tools/testing/selftests/mount/.gitignore
> new file mode 100644
> index 0000000..856ad41
> --- /dev/null
> +++ b/tools/testing/selftests/mount/.gitignore
> @@ -0,0 +1 @@
> +unprivileged-remount-test
> 


Thanks for fixing this. Applied to linux-kselftest next for 4.1

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
