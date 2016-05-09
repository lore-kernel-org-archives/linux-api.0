From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/4] selftests/sigaltstack: Fix the sas test on old kernels
Date: Sun, 8 May 2016 18:32:34 -0700
Message-ID: <CALCETrVRzZAEakv0ZqUYHhxJN0e00oLN0d0uSrkemBvRWjok9A@mail.gmail.com>
References: <cover.1462296606.git.luto@kernel.org> <f3e739bf435beeaecbd5f038f1359d2eac6d1e63.1462296606.git.luto@kernel.org>
 <abedee05-5671-7ba7-c256-41e61fb596cb@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <abedee05-5671-7ba7-c256-41e61fb596cb-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On May 7, 2016 8:02 AM, "Stas Sergeev" <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>
> 03.05.2016 20:31, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>
>> The handling for old kernels was wrong.  Fix it.
>>
>> Reported-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
>> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
>> Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
>> Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>   tools/testing/selftests/sigaltstack/sas.c | 21 ++++++++++++++-----=
--
>>   1 file changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testi=
ng/selftests/sigaltstack/sas.c
>> index 57da8bfde60b..a98c3ef8141f 100644
>> --- a/tools/testing/selftests/sigaltstack/sas.c
>> +++ b/tools/testing/selftests/sigaltstack/sas.c
>> @@ -15,6 +15,7 @@
>>   #include <alloca.h>
>>   #include <string.h>
>>   #include <assert.h>
>> +#include <errno.h>
>>     #ifndef SS_AUTODISARM
>>   #define SS_AUTODISARM  (1 << 4)
>> @@ -117,13 +118,19 @@ int main(void)
>>         stk.ss_flags =3D SS_ONSTACK | SS_AUTODISARM;
>>         err =3D sigaltstack(&stk, NULL);
>>         if (err) {
>> -               perror("[FAIL]\tsigaltstack(SS_ONSTACK | SS_AUTODISA=
RM)");
>> -               stk.ss_flags =3D SS_ONSTACK;
>> -       }
>> -       err =3D sigaltstack(&stk, NULL);
>> -       if (err) {
>> -               perror("[FAIL]\tsigaltstack(SS_ONSTACK)");
>> -               return EXIT_FAILURE;
>> +               if (errno =3D=3D EINVAL) {
>> +                       printf("[NOTE]\tThe running kernel doesn't s=
upport SS_AUTODISARM\n");
>> +                       /*
>> +                        * If test cases for the !SS_AUTODISARM vari=
ant were
>> +                        * added, we could still run them.  We don't=
 have any
>> +                        * test cases like that yet, so just exit an=
d report
>> +                        * success.
>> +                        */
>
> But that was the point, please see how it handles the
> old kernels:
>
> $ ./sas
> [FAIL]    sigaltstack(SS_ONSTACK | SS_AUTODISARM): Invalid argument
> [RUN]    signal USR1
> [FAIL]    ss_flags=3D1, should be SS_DISABLE
> [RUN]    switched to user ctx
> [RUN]    signal USR2
> [FAIL]    sigaltstack re-used
> [FAIL]    Stack corrupted
> [RUN]    Aborting

This is useful as a demonstration of why the feature is useful, but it
doesn't indicate that anything is wrong with old kernels per she.
That's why I changed it to simply report that the feature is missing.
