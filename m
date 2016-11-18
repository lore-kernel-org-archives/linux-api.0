From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH RFC 3/6] selftests: add default rules for c source file
Date: Fri, 18 Nov 2016 21:57:37 +1100
Message-ID: <87h975gin2.fsf@concordia.ellerman.id.au>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com> <1477047694-24122-4-git-send-email-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477047694-24122-4-git-send-email-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org writes:

> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> There are difference rules for compiling c source file in different
> testcases. In order to enable KBUILD_OUTPUT support in later patch,
> this patch introduce the default rules in
> "tools/testing/selftest/lib.mk" and remove the existing rules in each
> testcase.

Looks good.

Acked-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

cheers
