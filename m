From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v10 8/9] kselftest: save-and-restore errno to allow for %m
 formatting
Date: Fri, 19 Jul 2019 16:25:46 -0600
Message-ID: <b32d95a1-8a49-65ef-4ddd-fe86a7ca01d5@kernel.org>
References: <20190719164225.27083-1-cyphar@cyphar.com>
 <20190719164225.27083-9-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190719164225.27083-9-cyphar@cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <skhan@linuxfoundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 7/19/19 10:42 AM, Aleksa Sarai wrote:
> Previously, using "%m" in a ksft_* format string can result in strange
> output because the errno value wasn't saved before calling other libc
> functions. The solution is to simply save and restore the errno before
> we format the user-supplied format string.
> 
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> ---
>   tools/testing/selftests/kselftest.h | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> index ec15c4f6af55..0ac49d91a260 100644
> --- a/tools/testing/selftests/kselftest.h
> +++ b/tools/testing/selftests/kselftest.h
> @@ -10,6 +10,7 @@
>   #ifndef __KSELFTEST_H
>   #define __KSELFTEST_H
>   
> +#include <errno.h>
>   #include <stdlib.h>
>   #include <unistd.h>
>   #include <stdarg.h>
> @@ -81,58 +82,68 @@ static inline void ksft_print_cnts(void)
>   
>   static inline void ksft_print_msg(const char *msg, ...)
>   {
> +	int saved_errno = errno;
>   	va_list args;
>   
>   	va_start(args, msg);
>   	printf("# ");
> +	errno = saved_errno;
>   	vprintf(msg, args);
>   	va_end(args);
>   }
>   
>   static inline void ksft_test_result_pass(const char *msg, ...)
>   {
> +	int saved_errno = errno;
>   	va_list args;
>   
>   	ksft_cnt.ksft_pass++;
>   
>   	va_start(args, msg);
>   	printf("ok %d ", ksft_test_num());
> +	errno = saved_errno;
>   	vprintf(msg, args);
>   	va_end(args);
>   }
>   
>   static inline void ksft_test_result_fail(const char *msg, ...)
>   {
> +	int saved_errno = errno;
>   	va_list args;
>   
>   	ksft_cnt.ksft_fail++;
>   
>   	va_start(args, msg);
>   	printf("not ok %d ", ksft_test_num());
> +	errno = saved_errno;
>   	vprintf(msg, args);
>   	va_end(args);
>   }
>   
>   static inline void ksft_test_result_skip(const char *msg, ...)
>   {
> +	int saved_errno = errno;
>   	va_list args;
>   
>   	ksft_cnt.ksft_xskip++;
>   
>   	va_start(args, msg);
>   	printf("not ok %d # SKIP ", ksft_test_num());
> +	errno = saved_errno;
>   	vprintf(msg, args);
>   	va_end(args);
>   }
>   
>   static inline void ksft_test_result_error(const char *msg, ...)
>   {
> +	int saved_errno = errno;
>   	va_list args;
>   
>   	ksft_cnt.ksft_error++;
>   
>   	va_start(args, msg);
>   	printf("not ok %d # error ", ksft_test_num());
> +	errno = saved_errno;
>   	vprintf(msg, args);
>   	va_end(args);
>   }
> @@ -152,10 +163,12 @@ static inline int ksft_exit_fail(void)
>   
>   static inline int ksft_exit_fail_msg(const char *msg, ...)
>   {
> +	int saved_errno = errno;
>   	va_list args;
>   
>   	va_start(args, msg);
>   	printf("Bail out! ");
> +	errno = saved_errno;
>   	vprintf(msg, args);
>   	va_end(args);
>   
> @@ -178,10 +191,12 @@ static inline int ksft_exit_xpass(void)
>   static inline int ksft_exit_skip(const char *msg, ...)
>   {
>   	if (msg) {
> +		int saved_errno = errno;
>   		va_list args;
>   
>   		va_start(args, msg);
>   		printf("not ok %d # SKIP ", 1 + ksft_test_num());
> +		errno = saved_errno;
>   		vprintf(msg, args);
>   		va_end(args);
>   	} else {
> 

Hi Aleksa,

Can you send this patch separate from the patch series. I will apply
this as bug fix to 5.3-rc2 or rc3.

This isn't part of this series anyway and I would like to get this in
right away.

thanks,
-- Shuah
