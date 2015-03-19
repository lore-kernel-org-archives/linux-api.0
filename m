From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2] selftests/timers: Use shared logic to run and install
 tests
Date: Thu, 19 Mar 2015 15:52:38 -0600
Message-ID: <550B4526.8060301@osg.samsung.com>
References: <1426724440-12439-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426724440-12439-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/18/2015 06:20 PM, Michael Ellerman wrote:
> Change the timers Makefile to make use of shared run and install logic
> in lib.mk. Destructive tests are installed but not run by default.
> 
> Add a new variable, TEST_PROGS_EXTENDED, which is a list of extra
> programs to install, but which are not run by the default run_tests
> logic.
> 
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> ---
> 
> v2: Add and use TEST_PROGS_EXTENDED.
>     Just use the standard run_tests/install/emit_tests, this relies on the
>     patch from John to change the defaults for threadtest.

Applied to next for 4.1

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
