From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/3] selftests/capabilities: actually test it
Date: Mon, 16 Nov 2015 10:49:30 -0800
Message-ID: <CALCETrWOP=4pJrnJsfW2zVWvGHNnZDC5HYy5tOop8W-X4U2H8A@mail.gmail.com>
References: <1447480914-14834-1-git-send-email-bamvor.zhangjian@linaro.org>
 <1447480914-14834-3-git-send-email-bamvor.zhangjian@linaro.org> <1447651093.959.7.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447651093.959.7.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 15, 2015 at 9:18 PM, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> On Sat, 2015-11-14 at 14:01 +0800, Bamvor Jian Zhang wrote:
>
>> The capatabilities exist in selftest but no in the TARGET list.
>> Add it to the TARGET.
>>
>> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  tools/testing/selftests/Makefile | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
>> index 2458288..71b147e 100644
>> --- a/tools/testing/selftests/Makefile
>> +++ b/tools/testing/selftests/Makefile
>> @@ -1,4 +1,5 @@
>>  TARGETS = breakpoints
>> +TARGETS += capabilities
>>  TARGETS += cpu-hotplug
>>  TARGETS += efivarfs
>>  TARGETS += exec
>
>
> This breaks when you use TARGETS on the command line, eg:

Taking a step back for a second: isn't the variable you want
TEST_PROGS, not TARGETS?

--Andy
