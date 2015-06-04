From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] tools, add tools/testing/selftests/timers/.gitignore
Date: Thu, 04 Jun 2015 13:28:28 -0600
Message-ID: <5570A6DC.6090907@osg.samsung.com>
References: <1433440392-31274-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433440392-31274-1-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/04/2015 11:53 AM, Prarit Bhargava wrote:
> After building the tests in the timers directory each executable shows up
> in 'git-status' as a new file.  This patch adds a .gitignore file to the
> directory.
> 
> Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/timers/.gitignore |    3 +++
>  1 file changed, 3 insertions(+)
>  create mode 100644 tools/testing/selftests/timers/.gitignore
> 
> diff --git a/tools/testing/selftests/timers/.gitignore b/tools/testing/selftests/timers/.gitignore
> new file mode 100644
> index 0000000..afe9743
> --- /dev/null
> +++ b/tools/testing/selftests/timers/.gitignore
> @@ -0,0 +1,3 @@
> +*
> +!*.c
> +!.gitignore
> 

Zhang Zhen sent in a patch to fix this and it is queued for 4.2
in linux-kselftest next.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
