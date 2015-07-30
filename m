From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] kdbus/samples: skip on CROSS_COMPILE
Date: Thu, 30 Jul 2015 19:00:13 +0200
Message-ID: <CANq1E4SnQQq42m9YMCc_wKoZY=P19MsZTdxVnWUVwoCNvmHP7g@mail.gmail.com>
References: <1438272805-19029-1-git-send-email-dh.herrmann@gmail.com>
	<20150730163307.GA20048@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730163307.GA20048-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Thu, Jul 30, 2015 at 6:33 PM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Thu, Jul 30, 2015 at 06:13:25PM +0200, David Herrmann wrote:
>> Apparently we cannot rely on up-to-date kernel headers to be available
>> when cross-compiling, not even for HOSTCC. That's sad, but it's how it
>> is. Skip samples on cross-compiles as suggested by Paul, so allmodconfig
>> runs smoothly again.
>>
>> Tested-by: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
>> Signed-off-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  samples/kdbus/Makefile | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/samples/kdbus/Makefile b/samples/kdbus/Makefile
>> index 137f842..dbd9de8 100644
>> --- a/samples/kdbus/Makefile
>> +++ b/samples/kdbus/Makefile
>> @@ -1,9 +1,13 @@
>>  # kbuild trick to avoid linker error. Can be omitted if a module is built.
>>  obj- := dummy.o
>>
>> +ifndef CROSS_COMPILE
>
> This really feels like the wrong solution.
>
>> +
>>  hostprogs-$(CONFIG_SAMPLE_KDBUS) += kdbus-workers
>>
>>  always := $(hostprogs-y)
>>
>>  HOSTCFLAGS_kdbus-workers.o += -I$(objtree)/usr/include
>>  HOSTLOADLIBES_kdbus-workers := -lrt
>> +
>> +endif
>
> Shuah, how should we fix this "properly"?  How is this resolved for the
> kernel test scripts, it should have the same issue that the samples do.

./samples/ is built as part of "make vmlinux", tests are not.
Therefore, tests don't break allmodconfig and friends. The underlying
issue is, that ./samples/ provides both: examples for kernel modules
*and* examples for user-space code.

Maybe the real fix is to eventually split user-space examples from
kernel-module-examples (./samples/kernel/ and ./samples/user/). But I
don't want to include such split in the kdbus tree. Instead, I tried
to follow the recent fixes that are already upstream: 65f6f092a6987,
f59514b6a8c5ca6dd, and 6a407a81a9abcf.

Suggestions welcome!

Thanks
David
