From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Fix selftests build to just build, not run tests
Date: Tue, 14 Feb 2017 13:09:14 +1100
Message-ID: <87shnhmsl1.fsf@concordia.ellerman.id.au>
References: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486630590-9410-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> writes:

> In commit 88baa78d1f31 ("selftests: remove duplicated all and clean
> target"), the "all" target was removed from individual Makefiles and
> added to lib.mk.
>
> However the "all" target was added to lib.mk *after* the existing
> "runtests" target. This means "runtests" becomes the first (default)
> target for most of our Makefiles.
...
>
> Fix it by moving the "all" target to the start of lib.mk, making it the
> default target.
>
> Fixes: 88baa78d1f31 ("selftests: remove duplicated all and clean target")
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

Hi Shuah,

Can you please merge this series into linux-next?

The selftests are badly broken otherwise.

cheers
