From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 2/4] selftests/sigaltstack: Fix the sas test on old
 kernels
Date: Sat, 7 May 2016 18:02:26 +0300
Message-ID: <abedee05-5671-7ba7-c256-41e61fb596cb@list.ru>
References: <cover.1462296606.git.luto@kernel.org>
 <f3e739bf435beeaecbd5f038f1359d2eac6d1e63.1462296606.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3e739bf435beeaecbd5f038f1359d2eac6d1e63.1462296606.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

03.05.2016 20:31, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> The handling for old kernels was wrong.  Fix it.
>
> Reported-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>   tools/testing/selftests/sigaltstack/sas.c | 21 ++++++++++++++------=
-
>   1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testin=
g/selftests/sigaltstack/sas.c
> index 57da8bfde60b..a98c3ef8141f 100644
> --- a/tools/testing/selftests/sigaltstack/sas.c
> +++ b/tools/testing/selftests/sigaltstack/sas.c
> @@ -15,6 +15,7 @@
>   #include <alloca.h>
>   #include <string.h>
>   #include <assert.h>
> +#include <errno.h>
>  =20
>   #ifndef SS_AUTODISARM
>   #define SS_AUTODISARM  (1 << 4)
> @@ -117,13 +118,19 @@ int main(void)
>   	stk.ss_flags =3D SS_ONSTACK | SS_AUTODISARM;
>   	err =3D sigaltstack(&stk, NULL);
>   	if (err) {
> -		perror("[FAIL]\tsigaltstack(SS_ONSTACK | SS_AUTODISARM)");
> -		stk.ss_flags =3D SS_ONSTACK;
> -	}
> -	err =3D sigaltstack(&stk, NULL);
> -	if (err) {
> -		perror("[FAIL]\tsigaltstack(SS_ONSTACK)");
> -		return EXIT_FAILURE;
> +		if (errno =3D=3D EINVAL) {
> +			printf("[NOTE]\tThe running kernel doesn't support SS_AUTODISARM\=
n");
> +			/*
> +			 * If test cases for the !SS_AUTODISARM variant were
> +			 * added, we could still run them.  We don't have any
> +			 * test cases like that yet, so just exit and report
> +			 * success.
> +			 */
But that was the point, please see how it handles the
old kernels:

$ ./sas
[FAIL]    sigaltstack(SS_ONSTACK | SS_AUTODISARM): Invalid argument
[RUN]    signal USR1
[FAIL]    ss_flags=3D1, should be SS_DISABLE
[RUN]    switched to user ctx
[RUN]    signal USR2
[FAIL]    sigaltstack re-used
[FAIL]    Stack corrupted
[RUN]    Aborting

Unfortunalely, for Ingo it crashed...
I am not sure why, I can't reproduce. :(
So if you disable all the "old" tests, you can as well
remove them, or... find the bug and re-enable. :)
