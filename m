From: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] selftests: Fix the .c linking rule
Date: Tue, 14 Feb 2017 11:07:12 +0800
Message-ID: <CAFy1UST+iV_OjqvvmVyBUDf3C2x7wADC+w0pGo559n=xwkAAhA@mail.gmail.com>
References: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au> <1486630590-9410-2-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486630590-9410-2-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "Zhang Jian(Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Tested-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On 9 February 2017 at 16:56, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> Currently we can't build some tests, for example:
>
>   $ make -C tools/testing/selftests/ TARGETS=vm
>   ...
>   gcc -Wall -I ../../../../usr/include   -lrt -lpthread ../../../../usr/include/linux/kernel.h userfaultfd.c -o tools/testing/selftests/vm/userfaultfd
>   /tmp/ccmOkQSM.o: In function `stress':
>   userfaultfd.c:(.text+0xc60): undefined reference to `pthread_create'
>   userfaultfd.c:(.text+0xca5): undefined reference to `pthread_create'
>   userfaultfd.c:(.text+0xcee): undefined reference to `pthread_create'
>   userfaultfd.c:(.text+0xd30): undefined reference to `pthread_create'
>   userfaultfd.c:(.text+0xd77): undefined reference to `pthread_join'
>   userfaultfd.c:(.text+0xe7d): undefined reference to `pthread_join'
>   userfaultfd.c:(.text+0xe9f): undefined reference to `pthread_cancel'
>   userfaultfd.c:(.text+0xec6): undefined reference to `pthread_join'
>   userfaultfd.c:(.text+0xf14): undefined reference to `pthread_join'
>   /tmp/ccmOkQSM.o: In function `userfaultfd_stress':
>   userfaultfd.c:(.text+0x13e2): undefined reference to `pthread_attr_setstacksize'
>   collect2: error: ld returned 1 exit status
>
> This is because the rule for linking .c files to binaries is incorrect.
>
> The first bug is that it uses $< (first prerequisite) instead of $^ (all
> preqrequisites), fix it by using ^$.
>
> Secondly the ordering of the prerequisites vs $(LDLIBS) is wrong,
> meaning on toolchains that use --as-needed we fail to link (as above).
> Fix that by placing $(LDLIBS) *after* ^$.
>
> Finally switch to using the default rule $(LINK.c), so that we get
> $(CPPFLAGS) etc. included.
>
> Fixes: a8ba798bc8ec ("selftests: enable O and KBUILD_OUTPUT")
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> ---
>  tools/testing/selftests/lib.mk | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 17ed4bbe3963..98841c54763a 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -51,7 +51,7 @@ clean:
>         $(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
>
>  $(OUTPUT)/%:%.c
> -       $(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@
> +       $(LINK.c) $^ $(LDLIBS) -o $@
>
>  $(OUTPUT)/%.o:%.S
>         $(CC) $(ASFLAGS) -c $< -o $@
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
