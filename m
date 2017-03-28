From: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] selftests: fix the broken individual test for x86
Date: Tue, 28 Mar 2017 19:33:40 +0800
Message-ID: <CAFy1USTnJcbsHs-9d9Bs+cLyNfg0WvDgq_xJiOvnpjpUbtob+w@mail.gmail.com>
References: <20170327054601.22415-1-bamvor.zhangjian@linaro.org>
 <20170327054601.22415-2-bamvor.zhangjian@linaro.org> <87bmsm8d2a.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87bmsm8d2a.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Zhang Jian(Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi, Michael

On 28 March 2017 at 08:22, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>
>> Andy Lutomirski report that build individual testcase in x86 is broken:
>>
>> $ make -C tools/testing/selftests/x86 ldt_gdt_32
>> make: Entering directory '/home/luto/apps/linux/tools/testing/selftests/x86'
>> Makefile:44: warning: overriding recipe for target 'clean'
>> ../lib.mk:55: warning: ignoring old recipe for target 'clean'
>> make: *** No rule to make target 'ldt_gdt_32'.  Stop.
>> make: Leaving directory '/home/luto/apps/linux/tools/testing/selftests/x86'
>>
>> This patch fix this issue by adding default OUTPUT and convert
>> target in Makefile of x86.
>>
>> And also mention this use case in Documentation/kselftests.txt
>>
>> Reported-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  Documentation/kselftest.txt          |  6 ++++++
>>  tools/testing/selftests/x86/Makefile | 23 ++++++++++++++---------
>>  2 files changed, 20 insertions(+), 9 deletions(-)
>
> I don't think this is a good fix, it only fixes this one Makefile, and
> it's quite verbose. But if it really bothers Andy then it would be OK as
> a stop-gap for 4.11.
Thanks for review.
Do you mean check this issue in other directory? I plan to do it.
Currently, the x86/Makefile do not use the TEST_GEN_XXX, so
if we found a better fix, we could convert x86/Makefile later.

Regards

Bamvor
>
> cheers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
