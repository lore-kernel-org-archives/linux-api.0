From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 0/3] selftests: ptrace, kcmp, efivars build failure fixes
Date: Tue, 10 Mar 2015 17:37:34 -0600
Message-ID: <54FF803E.9030407@osg.samsung.com>
References: <cover.1426022048.git.shuahkh@osg.samsung.com> <1426030513.20917.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426030513.20917.2.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/10/2015 05:35 PM, Michael Ellerman wrote:
> On Tue, 2015-03-10 at 16:00 -0600, Shuah Khan wrote:
>> ptrace, efivars, and kcmp Makefiles don't have explicit build rule.
>> As a result, build fails when make is run from top level Makefile
>> target kselftest. Without the explicit rule, make works only when
>> it is run in the current directory or from selftests directory.
>> Fxing the problems by adding an explicit build rule to fix the
>> problem.
>>
>> Shuah Khan (3):
>>   selftests: ptrace build fails when invoked from kselftest target
>>   selftests: efivars build fails when invoked from kselftest target
>>   selftests: kcmp build fails when invoked from kselftest target
>>
>>  tools/testing/selftests/efivarfs/Makefile | 2 ++
>>  tools/testing/selftests/kcmp/Makefile     | 5 +++--
>>  tools/testing/selftests/ptrace/Makefile   | 5 +++--
>>  3 files changed, 8 insertions(+), 4 deletions(-)
> 
> What? No. This is the bug my patch to filter the make flags fixes.
> 
> cheers
> 
> 

Michael,

Did you see my email from yesterday on how your patch introduced
more problems. Can you please make sure the patches you send work
and don't introduce problems. I am having this issue with a lot
of your patches.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
