From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: Re: [RFC v4 9/9] kmsg: selftests
Date: Tue, 20 Oct 2015 13:10:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1510201305130.13138@AMDC1262.digital.local>
References: <1445273404-24562-1-git-send-email-p.osmialowsk@samsung.com>
 <1445273404-24562-10-git-send-email-p.osmialowsk@samsung.com>
 <56254470.4070102@osg.samsung.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <56254470.4070102@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Richard Weinberger <richard.weinberger@gmail.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Shuah,

Thanks for your comments,

On Mon, 19 Oct 2015, Shuah Khan wrote:

>> --- a/tools/testing/selftests/Makefile
>> +++ b/tools/testing/selftests/Makefile
>> @@ -7,6 +7,7 @@ TARGETS += ftrace
>>  TARGETS += futex
>>  TARGETS += kcmp
>>  TARGETS += kdbus
>
> Doesn't look like this patch is based on linux-kselftest next
> or Linus's latest. Please base your work on either one of the
> above. Please make sure "make kselftest" from top level Makefile
> doesn't break.
>
>> +TARGETS += kmsg

Any guidelines what such test should be implemented (apart from use of 
kselftest.h API)?

>> +kmsg-test: $(OBJS)
>> +	$(CC) $(CFLAGS) $^ $(LDLIBS) -o $@
>> +
>> +run_tests:
>> +	./kmsg-test --tap
>
> What does --tap do? Is this a longform option?
> I don't see it in usage()
>

Should be removed - I copy-pasted parts of kdbus selftests Makefile not 
noticing that.

Best regards,
Paul

