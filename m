From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH RFC 5/6] selftests: add EXTRA_CLEAN for clean target
Date: Fri, 18 Nov 2016 22:01:04 +1100
Message-ID: <87bmxdgihb.fsf@concordia.ellerman.id.au>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com> <1477047694-24122-6-git-send-email-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477047694-24122-6-git-send-email-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org writes:

> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Some testcases need the clean extra data after running. This patch
> introduce the "EXTRA_CLEAN" variable to address this requirement.

The idea here is fine I think. But this will need reworking if you
follow my suggestions for patch 1.

> After KOUTPUT_BUILD is enabled in later patch, it will be easy to
> decide to if we need do the cleanup in the KOUTPUT_BUILD path, if the
> testcase ran immediately after compiled.
>
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

All of these:

>  tools/testing/selftests/powerpc/benchmarks/Makefile   |  5 ++---
>  tools/testing/selftests/powerpc/copyloops/Makefile    |  3 +--
>  tools/testing/selftests/powerpc/dscr/Makefile         |  4 ++--
>  tools/testing/selftests/powerpc/math/Makefile         |  5 ++---
>  tools/testing/selftests/powerpc/primitives/Makefile   |  5 ++---
>  tools/testing/selftests/powerpc/stringloops/Makefile  |  5 ++---
>  tools/testing/selftests/powerpc/syscalls/Makefile     |  5 ++---
>  tools/testing/selftests/powerpc/tm/Makefile           |  5 ++---

are just cleaning *.o, and I'm pretty sure none of them need to. So for
those you can just drop the custom clean rule.

This one does need a custom rule:

>  .../testing/selftests/powerpc/switch_endian/Makefile  |  5 ++---


cheers
