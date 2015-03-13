From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v4 3/9] selftests: Introduce minimal shared logic for
 running tests
Date: Fri, 13 Mar 2015 11:19:16 -0600
Message-ID: <55031C14.1030203@osg.samsung.com>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au> <1426046765-19289-3-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426046765-19289-3-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/10/2015 10:05 PM, Michael Ellerman wrote:
> This adds a Make include file which most selftests can then include to
> get the run_tests logic.
> 
> On its own this has the advantage of some reduction in repetition, and
> also means the pass/fail message is defined in fewer places.
> 
> However the key advantage is it will allow us to implement install very
> simply in a subsequent patch.
> 
> The default implementation just executes each program in $(TEST_PROGS).
> 
> We use a variable to hold the default implementation of $(RUN_TESTS)
> because that gives us a clean way to override it if necessary, ie. using
> override. The mount, memory-hotplug and mqueue tests use that to provide
> a different implementation.
> 
> Tests are not run via /bin/bash, so if they are scripts they must be
> executable, we add a+x to several.
> 
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

This patch will be applied to next and queued for 4.1.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
