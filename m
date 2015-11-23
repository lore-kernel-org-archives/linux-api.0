From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH V2 0/2] Create specific kconfig for kselftest
Date: Mon, 23 Nov 2015 13:35:49 -0700
Message-ID: <565378A5.6010507@osg.samsung.com>
References: <1447770857-9883-1-git-send-email-bamvor.zhangjian@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447770857-9883-1-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/17/2015 07:34 AM, Bamvor Jian Zhang wrote:
> There is a discussion about improving the usability of kselftest by
> creating test-specific kconfig in recent kernel Summit. Furthormore,
> there are different approaches to do it:
> 
> 1) keep test-specific kconfig fragments inside each selftest so that
> merge_configs.sh could build up a kernel that can test the specific
> or all feature(s).
> 
> 2) In the main menu, have an additional option/flag for each feature
> that should be enabled when ksefltests are wanted.  Similar to the
> CONFIG_COMPILE_TEST flag.
> 
> Patch 1/2: do option 1. Hope it is a good start for discussion.
> 
> Patch 2/2: add config option(kselftest-mergeconfig) in make file as a
> helper to merge all the test config dependecies to .config.
> 
> Changes since v1[1]:
> 1.  Add kselftest-mergeconfig in scripts/kconfig/Makefile according
>     to the suggestion from Michael.
> 
> [1] http://www.spinics.net/lists/linux-api/msg15533.html
> 
> Bamvor Jian Zhang (2):
>   selftests: create test-specific kconfig fragments
>   scripts/kconfig/Makefile: add kselftest-mergeconfig
> 

Both patches applied to linux-kseltftest next for 4.5-rc1

thanks,
-- Shuah

Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
