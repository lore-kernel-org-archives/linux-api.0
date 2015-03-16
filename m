From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] selftests: Fix kcmp build to not require headers install
Date: Mon, 16 Mar 2015 22:00:39 +1100
Message-ID: <1426503639.4716.7.camel@ellerman.id.au>
References: <1426297504-14432-1-git-send-email-shuahkh@osg.samsung.com>
	 <1426297504-14432-2-git-send-email-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426297504-14432-2-git-send-email-shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-03-13 at 19:45 -0600, Shuah Khan wrote:
> Change CFLAGS to look in uapi to allow kcmp to be built without
> requiring headers install. This will make it easier to run tests
> without going through the headers install step.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  tools/testing/selftests/kcmp/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
> index ff0eefd..d405ad4 100644
> --- a/tools/testing/selftests/kcmp/Makefile
> +++ b/tools/testing/selftests/kcmp/Makefile
> @@ -1,5 +1,5 @@
>  CC := $(CROSS_COMPILE)$(CC)
> -CFLAGS += -I../../../../usr/include/
> +CFLAGS += -I../../../../include/uapi -I../../../../usr/include/

Hi Shuah,

Sorry but this is wrong. The contents of include/uapi are not the same as the
exported kernel headers.

Mixing the unprocessed kernel headers with user headers leads to all sorts of
mess, eg:

$ cc -I../../../../include/uapi -I../../../../usr/include/ kcmp_test.c   -o kcmp_test
In file included from /usr/include/powerpc64le-linux-gnu/asm/ptrace.h:27:0,
                 from /usr/include/powerpc64le-linux-gnu/asm/sigcontext.h:11,
                 from /usr/include/powerpc64le-linux-gnu/bits/sigcontext.h:27,
                 from /usr/include/signal.h:332,
                 from kcmp_test.c:5:
../../../../include/uapi/linux/types.h:9:2: warning: #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders" [-Wcpp]
 #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
  ^
In file included from ../../../../include/uapi/linux/posix_types.h:4:0,
                 from ../../../../include/uapi/linux/types.h:13,
                 from /usr/include/powerpc64le-linux-gnu/asm/ptrace.h:27,
                 from /usr/include/powerpc64le-linux-gnu/asm/sigcontext.h:11,
                 from /usr/include/powerpc64le-linux-gnu/bits/sigcontext.h:27,
                 from /usr/include/signal.h:332,
                 from kcmp_test.c:5:
../../../../include/uapi/linux/stddef.h:1:28: fatal error: linux/compiler.h: No such file or directory
 #include <linux/compiler.h>
                            ^
compilation terminated.
<builtin>: recipe for target 'kcmp_test' failed
make: *** [kcmp_test] Error 1


If you want to make it easier to build tests that need the kernel headers then
maybe kselftest should depend on headers_install?

cheers
