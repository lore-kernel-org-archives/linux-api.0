From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH RFC 2/6] selftests: remove useless TEST_DIRS
Date: Fri, 18 Nov 2016 21:31:56 +1100
Message-ID: <87k2c1gjtv.fsf@concordia.ellerman.id.au>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com> <1477047694-24122-3-git-send-email-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477047694-24122-3-git-send-email-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org writes:

> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> The TEST_DIRS was introduced in Commit e8c1d7cdf137 ("selftests: copy
> TEST_DIRS to INSTALL_PATH") for coping a whole directory in ftrace.
>
> After rsync(with -a) is introduced by Commit 900d65ee11aa ("selftests:
> change install command to rsync"). Rsync could handle the directory
> without the definition of TEST_DIRS.
>
> This patch simply replace TEST_DIRS with TEST_FILES in ftrace and remove
> the TEST_DIRS in tools/testing/selftest/lib.mk

Thanks for cleaning it up.

Acked-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

cheers
