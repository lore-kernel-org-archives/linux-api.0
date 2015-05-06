From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2] selftests/mount: output WARN messages when mount test
 skipped
Date: Wed, 06 May 2015 14:15:08 -0600
Message-ID: <554A764C.7080908@osg.samsung.com>
References: <1428024818-28554-1-git-send-email-zhenzhang.zhang@huawei.com> <551DEF58.3090505@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551DEF58.3090505-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org >> Linux Kernel Mailing List" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/02/2015 07:39 PM, Zhang Zhen wrote:
> Without this patch, if /proc/self/uid_map is not exist,
> the mount test case will skipped and no any prompting.
> 
> After applied this patch, the case will prompt why it skipped.
> Just as follows:
> root@kernel-host:/opt/kernel> make -C tools/testing/selftests TARGETS=mount run_tests
> make: Entering directory `/opt/kernel/tools/testing/selftests'
> for TARGET in mount; do \
>                 make -C $TARGET; \
>         done;
> make[1]: Entering directory `/opt/kernel/tools/testing/selftests/mount'
> make[1]: Nothing to be done for `all'.
> make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/mount'
> for TARGET in mount; do \
>                 make -C $TARGET run_tests; \
>         done;
> make[1]: Entering directory `/opt/kernel/tools/testing/selftests/mount'
> if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; else echo "WARN: No /proc/self/uid_map exist, test skipped." ; fi
> WARN: No /proc/self/uid_map exist, test skipped.
> make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/mount'
> make: Leaving directory `/opt/kernel/tools/testing/selftests'
> 
> Change v1 -> v2:
> - fix syntax error when run kselftest_install.sh
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---

Thanks for fixing this. Applied it to linux-kselftest next
for 4.2 - I ended up making changes the commit log to fix
checkpatch warnings before applying the patch.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
