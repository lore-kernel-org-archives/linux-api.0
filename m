From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/4] selftests: Add test for sigaltstack(SS_DISABLE)
 inside sighandler
Date: Fri, 12 Feb 2016 09:12:29 -0700
Message-ID: <56BE046D.4080203@osg.samsung.com>
References: <56AE3369.2090709@list.ru> <56AE33D7.1090708@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56AE33D7.1090708@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Stas Sergeev <stsp@list.ru>, Linux kernel <linux-kernel@vger.kernel.org>
Cc: linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 01/31/2016 09:18 AM, Stas Sergeev wrote:
> 
> sigaltstack needs to be disabled before the signal handler can
> safely use swapcontext(). Unfortunately linux implementation of
> sigaltstack() returns EPERM in that case.
> Re-enabling is also needed and tested.
> 
> CC: Shuah Khan <shuahkh@osg.samsung.com>
> CC: linux-kernel@vger.kernel.org
> CC: linux-api@vger.kernel.org
> CC: Andy Lutomirski <luto@amacapital.net>
> 
> Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>

Hi Stas,

Is this patch v4 or Patch 1/4. Confirming to see if
I am missing 3 patches or this is supposed to be
version 4 of a single patch.

thanks,
-- Shuah
> ---
>  tools/testing/selftests/Makefile             |   1 +
>  tools/testing/selftests/sigaltstack/Makefile |   8 ++
>  tools/testing/selftests/sigaltstack/sas.c    | 132 +++++++++++++++++++++++++++
>  3 files changed, 141 insertions(+)
>  create mode 100644 tools/testing/selftests/sigaltstack/Makefile
>  create mode 100644 tools/testing/selftests/sigaltstack/sas.c
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index c8edff6..d5b2005 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -17,6 +17,7 @@ TARGETS += powerpc
>  TARGETS += pstore
>  TARGETS += ptrace
>  TARGETS += seccomp
> +TARGETS += sigaltstack
>  TARGETS += size
>  TARGETS += static_keys
>  TARGETS += sysctl
> diff --git a/tools/testing/selftests/sigaltstack/Makefile b/tools/testing/selftests/sigaltstack/Makefile
> new file mode 100644
> index 0000000..56af56e
> --- /dev/null
> +++ b/tools/testing/selftests/sigaltstack/Makefile
> @@ -0,0 +1,8 @@
> +CFLAGS = -Wall
> +BINARIES = sas
> +all: $(BINARIES)
> +
> +include ../lib.mk
> +
> +clean:
> +    rm -rf $(BINARIES)
> diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
> new file mode 100644
> index 0000000..5d9aabd
> --- /dev/null
> +++ b/tools/testing/selftests/sigaltstack/sas.c
> @@ -0,0 +1,132 @@
> +/*
> + * Stas Sergeev <stsp@users.sourceforge.net>
> + *
> + * test sigcontext(SS_DISABLE) inside signal handler
> + * If that succeeds, then swapcontext() can be used safely.
> + *
> + */
> +
> +#define _GNU_SOURCE
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/mman.h>
> +#include <ucontext.h>
> +#include <alloca.h>
> +#include <string.h>
> +#include <assert.h>
> +
> +static void *sstack, *ustack;
> +static ucontext_t uc, sc;
> +static const char *msg = "[OK]\tStack preserved";
> +static const char *msg2 = "[FAIL]\tStack corrupted";
> +
> +void my_usr1(int sig)
> +{
> +    char *aa, *p;
> +    int *i, err;
> +    stack_t stk = { };
> +
> +    aa = alloca(1024);
> +    assert(aa);
> +    p = aa + 512;
> +    strcpy(p, msg);
> +    i = (int *) (p + 128);
> +    *i = 1;
> +    printf("[RUN]\tsignal USR1\n");
> +    stk.ss_flags = SS_DISABLE;
> +    err = sigaltstack(&stk, &stk);
> +    if (err) {
> +        perror("[FAIL]\tsigaltstack(SS_DISABLE)");
> +        /* don't exit to demonstrate the breakage */
> +        /* exit(EXIT_FAILURE); */
> +    }
> +    swapcontext(&sc, &uc);
> +    printf("%s\n", p);
> +    if (!*i) {
> +        printf("[RUN]\tAborting\n");
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    if (stk.ss_flags != SS_ONSTACK) {
> +        printf("[FAIL]\tsigaltstack() returned wrong ss_flags %i\n",
> +                stk.ss_flags);
> +        stk.ss_flags = SS_ONSTACK;
> +    }
> +    err = sigaltstack(&stk, NULL);
> +    if (err)
> +        printf("[OK]\tsigaltstack(SS_ONSTACK) failed for non_zero "
> +                "size\n");
> +        /* but don't fail otherwise, as this is unspecified */
> +    stk.ss_size = 0;
> +    err = sigaltstack(&stk, NULL);
> +    if (err)
> +        perror("[FAIL]\tsigaltstack(SS_ONSTACK)");
> +}
> +
> +void my_usr2(int sig)
> +{
> +    char *aa, *p;
> +    int *i;
> +
> +    printf("[RUN]\tsignal USR2\n");
> +    aa = alloca(1024);
> +    /* dont run valgrind on this */
> +    p = memmem(aa, 1024, msg, strlen(msg));
> +    if (p) {
> +        printf("[FAIL]\tsigaltstack re-used\n");
> +        strcpy(p, msg2);
> +        i = (int *) (p + 128);
> +        *i = 0;
> +    }
> +}
> +
> +static void switch_fn(void)
> +{
> +    printf("[RUN]\tswitched to user ctx\n");
> +    raise(SIGUSR2);
> +    setcontext(&sc);
> +}
> +
> +int main(void)
> +{
> +    struct sigaction act;
> +    stack_t stk;
> +    int err;
> +
> +    sigemptyset(&act.sa_mask);
> +    act.sa_flags = SA_ONSTACK;
> +    act.sa_handler = my_usr1;
> +    sigaction(SIGUSR1, &act, NULL);
> +    act.sa_handler = my_usr2;
> +    sigaction(SIGUSR2, &act, NULL);
> +    sstack = mmap(NULL, SIGSTKSZ, PROT_READ | PROT_WRITE,
> +              MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
> +    if (sstack == MAP_FAILED) {
> +        perror("mmap()");
> +        return EXIT_FAILURE;
> +    }
> +    stk.ss_sp = sstack;
> +    stk.ss_size = SIGSTKSZ;
> +    stk.ss_flags = SS_ONSTACK;
> +    err = sigaltstack(&stk, NULL);
> +    if (err) {
> +        perror("sigaltstack()");
> +        return EXIT_FAILURE;
> +    }
> +
> +    ustack = mmap(NULL, SIGSTKSZ, PROT_READ | PROT_WRITE,
> +              MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
> +    if (ustack == MAP_FAILED) {
> +        perror("mmap()");
> +        return EXIT_FAILURE;
> +    }
> +    getcontext(&uc);
> +    uc.uc_link = NULL;
> +    uc.uc_stack.ss_sp = ustack;
> +    uc.uc_stack.ss_size = SIGSTKSZ;
> +    makecontext(&uc, switch_fn, 0);
> +    raise(SIGUSR1);
> +    printf("[OK]\tTest passed\n");
> +    return 0;
> +}


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
