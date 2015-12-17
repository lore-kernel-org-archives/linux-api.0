From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v3 0/2] Create specific kconfig for kselftest
Date: Fri, 18 Dec 2015 10:44:57 +1100
Message-ID: <1450395897.19696.0.camel@ellerman.id.au>
References: <1450346273-31633-1-git-send-email-bamvor.zhangjian@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450346273-31633-1-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, yann.morin.1998-GANU6spQydw@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2015-12-17 at 17:57 +0800, Bamvor Jian Zhang wrote:

> There is a discussion about improving the usability of kselftest by
> creating test-specific kconfig in recent kernel Summit.
> 
> Patch 1 keep test-specific kconfig fragments inside each selftest so
> that merge_configs.sh could build up a kernel that can test the
> specific or all feature(s).
> 
> Patch 2 add config option(kselftest-mergeconfig) in make file as a
> helper to merge all the test config dependecies to .config.
> 
> Changes since v2:
> 1.  Fix the misuse of objtree and srctree in the
>     kselftest-mergeconfig target.
> 
> Changes since v1:
> 1.  Add kselftest-mergeconfig in scripts/kconfig/Makefile according
>     to the suggestion from Michael.

Sorry I only just noticed you put it in scripts/kconfig/Makefile. I meant for
it to go in Makefile, alongside the other kselftest targets.

cheers
