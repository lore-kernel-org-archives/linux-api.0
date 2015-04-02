From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] selftests/mount: output error messages when mount test
 fail
Date: Thu, 02 Apr 2015 08:21:59 -0600
Message-ID: <551D5087.3010900@osg.samsung.com>
References: <1427957214-40367-1-git-send-email-zhenzhang.zhang@huawei.com> <551CE72E.3050303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <551CE72E.3050303@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Zhen <zhenzhang.zhang@huawei.com>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mpe@ellerman.id.au, ebiederm@xmission.com, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 04/02/2015 12:52 AM, Zhang Zhen wrote:
> Without this patch, if /proc/self/uid_map is not exist,
> the mount test case will fail and no any prompting.
> 
> After applied this patch, the case will prompt why it fail.
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
> ERROR: No /proc/self/uid_map exist
> make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/mount'
> make: Leaving directory `/opt/kernel/tools/testing/selftests'
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>

Thanks for fixing this. It will get into 4.1-rc2.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
