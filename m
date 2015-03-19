From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v2] selftests: Fix build failures when invoked from
 kselftest target
Date: Thu, 19 Mar 2015 11:05:15 +1100
Message-ID: <1426723515.14101.2.camel@ellerman.id.au>
References: <1426701942-25217-1-git-send-email-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426701942-25217-1-git-send-email-shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-03-18 at 12:05 -0600, Shuah Khan wrote:
> Several tests that rely on implicit build rules fail to build,
> when invoked from the main Makefile kselftest target. These
> failures are due to --no-builtin-rules and --no-builtin-variables
> options set in the inherited MAKEFLAGS.
> 
> --no-builtin-rules eliminates the use of built-in implicit rules
> and --no-builtin-variables is for not defining built-in variables.
> These two options override the use of implicit rules resulting in
> build failures. In addition, inherited LDFLAGS result in build
> failures and there is no need to define LDFLAGS.  Clear LDFLAGS
> and MAKEFLAG when make is invoked from the main Makefile kselftest
> target. Fixing this at selftests Makefile avoids changing the main
> Makefile and keeps this change self contained at selftests level.

Yep this looks good.

Acked-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

cheers
