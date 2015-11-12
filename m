From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] selftests/seccomp: Get page size from sysconf
Date: Thu, 12 Nov 2015 10:11:11 -0800
Message-ID: <CAGXu5jLpJgiSAjEPbXsSQp0Sg+=mJNAhK=Lv5cgj-wsQwEteAw@mail.gmail.com>
References: <1447310485-4710-1-git-send-email-bamvor.zhangjian@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447310485-4710-1-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 11, 2015 at 10:41 PM, Bamvor Jian Zhang
<bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> The commit fd88d16c58c2 ("selftests/seccomp: Be more precise with
> syscall arguments") use PAGE_SIZE directly which lead to build
> failure on arm64.
>
> Replace it with generic interface(sysconf(_SC_PAGESIZE)) to fix this
> failure.

Oh, good catch! Can you respin this and add an ASSERT for sysconf failing?

-Kees

>
> Build and test successful on arm64.
>
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index e38cc54..05afca9 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -492,6 +492,7 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
>         pid_t parent = getppid();
>         int fd;
>         void *map1, *map2;
> +       int page_size = sysconf(_SC_PAGESIZE);
>
>         ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
>         ASSERT_EQ(0, ret);
> @@ -504,16 +505,16 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
>
>         EXPECT_EQ(parent, syscall(__NR_getppid));
>         map1 = (void *)syscall(sysno,
> -               NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, PAGE_SIZE);
> +               NULL, page_size, PROT_READ, MAP_PRIVATE, fd, page_size);
>         EXPECT_NE(MAP_FAILED, map1);
>         /* mmap2() should never return. */
>         map2 = (void *)syscall(sysno,
> -                NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0x0C0FFEE);
> +                NULL, page_size, PROT_READ, MAP_PRIVATE, fd, 0x0C0FFEE);
>         EXPECT_EQ(MAP_FAILED, map2);
>
>         /* The test failed, so clean up the resources. */
> -       munmap(map1, PAGE_SIZE);
> -       munmap(map2, PAGE_SIZE);
> +       munmap(map1, page_size);
> +       munmap(map2, page_size);
>         close(fd);
>  }
>
> --
> 2.1.4
>



-- 
Kees Cook
Chrome OS Security
