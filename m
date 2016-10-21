From: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 2/6] selftests: remove useless TEST_DIRS
Date: Fri, 21 Oct 2016 19:15:02 +0800
Message-ID: <CAFy1USRoDbmuFvv7tzL+QYk0qnvD=qxu2qeTsEzvVxDcPMgHVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhang Jian(Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Fix the wrong email address of kevin hilman to khilman-DgEjT+Ai2yi4UlQgPVntAg@public.gmane.org
Sorry for inconvenience.

On 21 October 2016 at 19:01,  <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> The TEST_DIRS was introduced in Commit e8c1d7cdf137 ("selftests: copy
> TEST_DIRS to INSTALL_PATH") for coping a whole directory in ftrace.
>
> After rsync(with -a) is introduced by Commit 900d65ee11aa ("selftests:
> change install command to rsync"). Rsync could handle the directory
> without the definition of TEST_DIRS.
>
> This patch simply replace TEST_DIRS with TEST_FILES in ftrace and remove
> the TEST_DIRS in tools/testing/selftest/lib.mk
>
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  tools/testing/selftests/ftrace/Makefile | 2 +-
>  tools/testing/selftests/lib.mk          | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
> index 4e6ed13..a715300 100644
> --- a/tools/testing/selftests/ftrace/Makefile
> +++ b/tools/testing/selftests/ftrace/Makefile
> @@ -1,7 +1,7 @@
>  all:
>
>  TEST_PROGS := ftracetest
> -TEST_DIRS := test.d
> +TEST_FILES := test.d
>
>  include ../lib.mk
>
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 12edfb1f..8c0440d 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -14,8 +14,8 @@ run_tests: all
>  define INSTALL_RULE
>         @if [ "X$(TEST_PROGS)$(TEST_PROGS_EXTENDED)$(TEST_FILES)" != "X" ]; then                                        \
>                 mkdir -p ${INSTALL_PATH};                                                                               \
> -               echo "rsync -a $(TEST_DIRS) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/";       \
> -               rsync -a $(TEST_DIRS) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/;              \
> +               echo "rsync -a $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/";    \
> +               rsync -a $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/;           \
>         fi
>         @if [ "X$(TEST_GEN_PROGS)$(TEST_GEN_PROGS_EXTENDED)$(TEST_GEN_FILES)" != "X" ]; then                                    \
>                 mkdir -p ${INSTALL_PATH};                                                                               \
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
