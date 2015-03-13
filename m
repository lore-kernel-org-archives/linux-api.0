From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Fri, 13 Mar 2015 15:32:44 -0600
Message-ID: <5503577C.9050002@osg.samsung.com>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au> <1426046765-19289-4-git-send-email-mpe@ellerman.id.au> <55031C78.4040609@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55031C78.4040609-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/13/2015 11:20 AM, Shuah Khan wrote:
> On 03/10/2015 10:06 PM, Michael Ellerman wrote:
>> This adds make install support to selftests. The basic usage is:
>>
>> $ cd tools/testing/selftests
>> $ make install
>>
>> That installs into tools/testing/selftests/install, which can then be
>> copied where ever necessary.
>>
>> The install destination is also configurable using eg:
>>
>> $ INSTALL_PATH=/mnt/selftests make install
>>
>> The implementation uses two targets in the child makefiles. The first
>> "install" is expected to install all files into $(INSTALL_PATH).
>>
>> The second, "emit_tests", is expected to emit the test instructions (ie.
>> bash script) on stdout. Separating this from install means the child
>> makefiles need no knowledge of the location of the test script.
>>
>> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> 
> Thanks for doing the work. This patch will be applied to next and will
> be queued for 4.1
> 

ok. linux-kselftest next has both shared logic and install patches
now. As I mentioned in my reply to shared logic patch, I had to drop
the changes to timers Makefile to add shared logic, hence timers progs
don't get installed at the moment.

Could you please review to make sure, it looks right.

As I said in the other email, if lib.mk could provide a way to run
additional programs that require arguments in addition to RUN_TESTS.
In the case of timers, there is one test that requires arguments. In
some cases, e.g: memory hotplug, override works well since it is just
one executable. In this case, there is a mix of executables that don't
need any special handling and some that need it.

You are welcome to add shared logic and install to timers if you would
like.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
