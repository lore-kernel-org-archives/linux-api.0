From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v2] selftests: kcmp build fails when invoked from
 kselftest target
Date: Wed, 11 Mar 2015 13:19:37 +1100
Message-ID: <1426040377.20917.8.camel@ellerman.id.au>
References: <1426032512-10353-1-git-send-email-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426032512-10353-1-git-send-email-shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-03-10 at 18:08 -0600, Shuah Khan wrote:
> kcmp Makefile doesn't have an explicit build rule. As a result,
> kcmp build fails, when it is run from top level Makefile target
> kselftest. Without the explicit rule, make works only when it is
> run in the current directory or from selftests directory. Add an
> explicit build rule to fix the problem. 

This should be fixed properly using my patch to filter -rR or similar.

> In addition, build fails
> as it can't find kcmp.h. Fix it by passing CFLAGS.

That is also wrong. It should *not* be looking in include/uapi.

If it needs headers then it should be using the *exported* headers, which are
in ../../../../usr/include as the existing CFLAGS specifiy.

Those headers are installed as part of 'make headers_install'.

cheers
