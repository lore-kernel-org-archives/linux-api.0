From: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH] selftests: use INSTALL_HDR_PATH instead of relative
 paths
Date: Thu, 14 Jan 2016 11:17:43 +0000
Message-ID: <569783D7.5000303@arm.com>
References: <1452522172-16650-1-git-send-email-sudeep.holla@arm.com>
 <1452742640.25808.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452742640.25808.1.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 14/01/16 03:37, Michael Ellerman wrote:
> On Mon, 2016-01-11 at 14:22 +0000, Sudeep Holla wrote:
>
>> The selftests build fails or picks up wrong headers when cross-compiling
>> and build directory is different from source as the headers are referred
>> using the relative paths.
>>
>> This patch use $INSTALL_HDR_PATH to fix the compilation. It also removes
>> installing the headers.
>>
>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> Signed-off-by: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
>> ---
>>   tools/testing/selftests/membarrier/Makefile | 2 +-
>>   tools/testing/selftests/memfd/Makefile      | 2 +-
>>   tools/testing/selftests/net/Makefile        | 2 +-
>>   tools/testing/selftests/vm/Makefile         | 7 ++-----
>>   4 files changed, 5 insertions(+), 8 deletions(-)
>>
>> Hi,
>>
>> When I was cross-compiling these tests for arm{32,64}, I faced issues.
>> With limited knowledge I have on this build system, I came up with this
>> patch. Please treat this as bug report if this approach makes no-sense
>> and suggest on how to fix it.
>
> Yeah sorry that doesn't work.
>
> If $(INSTALL_HDR_PATH) isn't defined you end up with:
>
>    gcc -Wall -I /include  -o compaction_test compaction_test.c -lrt
>                 ^
>

Ah OK, I got carried away by below in the main Makefile.

#Default location for installed headers
export INSTALL_HDR_PATH = $(objtree)/usr

> Which is wrong.
>
> INSTALL_HDR_PATH will not be defined when the tests are built standalone, ie.
> like:
>
>    $ make -C tools/testing/selftests
>

Thanks for pointing this out. I had totally forgotten about that.

>
> This has been on my todo list to fix, but it doesn't actually bother me so I
> haven't got around to it.
>
> Does the patch below work for you? It uses INSTALL_HDR_PATH if it is defined,
> or otherwise KERNEL_HEADERS if it is defined, or finally it guesses at
> ../../../usr/include (ie. the base of the source tree).
>

Yes it does work fine. So feel free to add my tested-by when you post
the patch. Thanks for the quick and clean fix.

-- 
Regards,
Sudeep
