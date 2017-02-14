From: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] selftests: Fix the .S and .S -> .o rules
Date: Tue, 14 Feb 2017 11:07:28 +0800
Message-ID: <CAFy1USS8b=eYyrp7k8f0_nUc8Rf4bCuCRTeYLG7CUcNOyQzeiw@mail.gmail.com>
References: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au> <1486630590-9410-3-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486630590-9410-3-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "Zhang Jian(Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Tested-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On 9 February 2017 at 16:56, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> Both these rules incorrectly use $< (first prerequisite) rather than
> $^ (all prerequisites), meaning they don't work if we're using more than
> one .S file as input. Switch them to using $^.
>
> They also don't include $(CPPFLAGS) and other variables used in the
> default rules, which breaks targets that require those. Fix that by
> using the builtin $(COMPILE.S) and $(LINK.S) rules.
>
> Fixes: a8ba798bc8ec ("selftests: enable O and KBUILD_OUTPUT")
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> ---
>  tools/testing/selftests/lib.mk | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 98841c54763a..ce96d80ad64f 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -54,9 +54,9 @@ $(OUTPUT)/%:%.c
>         $(LINK.c) $^ $(LDLIBS) -o $@
>
>  $(OUTPUT)/%.o:%.S
> -       $(CC) $(ASFLAGS) -c $< -o $@
> +       $(COMPILE.S) $^ -o $@
>
>  $(OUTPUT)/%:%.S
> -       $(CC) $(ASFLAGS) $< -o $@
> +       $(LINK.S) $^ $(LDLIBS) -o $@
>
>  .PHONY: run_tests all clean install emit_tests
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
