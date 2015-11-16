From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 1/3] selftests/capabilities: align the usage of CFLAGS
 with others
Date: Mon, 16 Nov 2015 20:00:45 +1100
Message-ID: <1447664445.2191.1.camel@ellerman.id.au>
References: <1447480914-14834-1-git-send-email-bamvor.zhangjian@linaro.org>
	 <1447480914-14834-2-git-send-email-bamvor.zhangjian@linaro.org>
	 <1447650976.959.5.camel@ellerman.id.au>
	 <CAFy1USTzsUcmwoS3Y4LRQjQykK2CSMKZ7JEDX517x6R3u801cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFy1USTzsUcmwoS3Y4LRQjQykK2CSMKZ7JEDX517x6R3u801cw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2015-11-16 at 16:52 +0800, Bamvor Zhang Jian wrote:
> Hi, Michael
> On 11/16/2015 01:16 PM, Michael Ellerman wrote:
> > On Sat, 2015-11-14 at 14:01 +0800, Bamvor Jian Zhang wrote:
> > > User need to provide cap-ng.h and libcap-ng.so for cross compiling
> > > which could be done by pass extra cflags to EXTRA_CLAGS. But other
> > > testcases pass CFLAGS instead.
> > > 
> > > Change CLAGS ':=' to CLAGS '+=' to align with others. Delete useless
> > > EXTRA_CLAGS at the same time.
> > 
> > Actually I think you can clean this up even more. I don't see any reason it
> > can't use the implicit rule for compilation.

> Yes, and with your comment in 2/3, how about this one:

Yeah that's fine. You have to say ${TEST_FILES} ${TEST_PROGS} twice, but that's
not so bad.

I think it's more common to use $( ) brackets in Makefiles, so I'd prefer you
used that rather than ${ }.

cheers

> diff --git a/tools/testing/selftests/capabilities/Makefile
> b/tools/testing/selftests/capabilities/Makefile
> index 8c8f0c1..de07767 100644
> --- a/tools/testing/selftests/capabilities/Makefile
> +++ b/tools/testing/selftests/capabilities/Makefile
> @@ -1,18 +1,13 @@
> -all:
> -
> -include ../lib.mk
> -
> -.PHONY: all clean
> -
> -TARGETS := validate_cap test_execve
> +TEST_FILES := validate_cap
>  TEST_PROGS := test_execve
> 
> -CFLAGS := -O2 -g -std=gnu99 -Wall -lcap-ng
> +CFLAGS += -O2 -g -std=gnu99 -Wall
> +LDLIBS += -lcap-ng -lrt -ldl
> 
> -all: $(TARGETS)
> +all: ${TEST_PROGS} ${TEST_FILES}
> 
>  clean:
> - $(RM) $(TARGETS)
> + ${RM} ${TEST_PROGS} ${TEST_FILES}
> +
> +include ../lib.mk
> 
> -$(TARGETS): %: %.c
> - $(CC) -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
