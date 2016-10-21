From: Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>
Subject: Re: [PATCH RFC 4/6] selftests: remove CROSS_COMPILE in dedicated Makefile
Date: Fri, 21 Oct 2016 19:16:14 +0800
Message-ID: <CAFy1USTGZKv2mDO19M23jD6OyQdSc8EhmnK-t7oLGmMFw5HDBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zhang Jian(Bamvor)" <bamvor.zhangjian@huawei.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Kevin Hilman <khilman@kernel.org>
List-Id: linux-api@vger.kernel.org

Fix the wrong email address of kevin hilman to khilman@kernel.org.
Sorry for inconvenience.

On 21 October 2016 at 19:01,  <bamvor.zhangjian@huawei.com> wrote:
> From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
>
> After previous clean up patches, memfd and timers could get
> CROSS_COMPILE from tools/testing/selftest/lib.mk. There is no need to
> preserve these definition. So, this patch remove them.
>
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
> ---
>  tools/testing/selftests/memfd/Makefile  | 1 -
>  tools/testing/selftests/timers/Makefile | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
> index 2c87f23..79891d0 100644
> --- a/tools/testing/selftests/memfd/Makefile
> +++ b/tools/testing/selftests/memfd/Makefile
> @@ -1,4 +1,3 @@
> -CC = $(CROSS_COMPILE)gcc
>  CFLAGS += -D_FILE_OFFSET_BITS=64
>  CFLAGS += -I../../../../include/uapi/
>  CFLAGS += -I../../../../include/
> diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
> index 4a3bffe..b90e50c 100644
> --- a/tools/testing/selftests/timers/Makefile
> +++ b/tools/testing/selftests/timers/Makefile
> @@ -1,4 +1,3 @@
> -CC = $(CROSS_COMPILE)gcc
>  BUILD_FLAGS = -DKTEST
>  CFLAGS += -O3 -Wl,-no-as-needed -Wall $(BUILD_FLAGS)
>  LDFLAGS += -lrt -lpthread
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
