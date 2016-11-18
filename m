From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH RFC 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Fri, 18 Nov 2016 22:29:48 +1100
Message-ID: <878tshgh5f.fsf@concordia.ellerman.id.au>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com> <1477047694-24122-7-git-send-email-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477047694-24122-7-git-send-email-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org writes:

> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
> to another directory by passing O or KBUILD_OUTPUT. And O is high
> priority than KBUILD_OUTPUT.

We end up saying $(OUTPUT) a lot, kbuild uses $(obj), which is shorter
and less shouty and reads nicer I think ?

> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index a3144a3..79c5e97 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -47,29 +47,47 @@ override LDFLAGS =
>  override MAKEFLAGS =
>  endif
>  
> +ifeq ($(O)$(KBUILD_OUTPUT),)
> +        BUILD :=$(shell pwd)
> +else
> +        ifneq ($(O),)
> +                BUILD := $(O)
> +        else
> +                ifneq ($(KBUILD_OUTPUT),)
> +                        BUILD := $(KBUILD_OUTPUT)
> +                endif
> +        endif
> +endif

That should be equivalent to:

BUILD := $(O)
ifndef BUILD
  BUILD := $(KBUILD_OUTPUT)
endif
ifndef BUILD
  BUILD := $(shell pwd)
endif



> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
> index 48d1f86..fe5cdec 100644
> --- a/tools/testing/selftests/exec/Makefile
> +++ b/tools/testing/selftests/exec/Makefile
> @@ -5,18 +5,19 @@ TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
>  # Makefile is a run-time dependency, since it's accessed by the execveat test
>  TEST_FILES := Makefile
>  
> -EXTRA_CLEAN := subdir.moved execveat.moved xxxxx*
> +EXTRA_CLEAN := $(OUTPUT)subdir.moved $(OUTPUT)execveat.moved $(OUTPUT)xxxxx*

It reads strangely to not have a slash after the output I think it would
be better if you used a slash everywhere you use it, like:

EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*

That makes it clear that it's a directory, and not some other prefix.


Having said that, I think for EXTRA_CLEAN it should just be defined that
the contents are in $(OUTPUT), and so we can just do that in lib.mk, eg:

EXTRA_CLEAN := $(addprefix $(OUTPUT)/,$(EXTRA_CLEAN))

clean:
  	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)


>  include ../lib.mk
>  
> -subdir:
> +$(OUTPUT)subdir:
>  	mkdir -p $@
> -script:
> +$(OUTPUT)script:
>  	echo '#!/bin/sh' > $@
>  	echo 'exit $$*' >> $@
>  	chmod +x $@
> -execveat.symlink: execveat
> -	ln -s -f $< $@
> -execveat.denatured: execveat
> +$(OUTPUT)execveat.symlink: execveat
> +	cd $(OUTPUT) && ln -s -f $< `basename $@`
> +$(OUTPUT)execveat.denatured: execveat
>  	cp $< $@
>  	chmod -x $@

Do those work? I would have thought you'd need $(OUTPUT) on the right
hand side also?

> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 0f7a371..fa87f98 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -33,19 +34,29 @@ endif
>  
>  define EMIT_TESTS
>  	@for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
> -		echo "(./$$TEST && echo \"selftests: $$TEST [PASS]\") || echo \"selftests: $$TEST [FAIL]\""; \
> +		BASENAME_TEST=`basename $$TEST`;	\
> +		echo "(./$$BASENAME_TEST && echo \"selftests: $$BASENAME_TEST [PASS]\") || echo \"selftests: $$BASENAME_TEST [FAIL]\""; \
>  	done;
>  endef
>  
>  emit_tests:
>  	$(EMIT_TESTS)
>  
> +TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)%,$(TEST_GEN_PROGS))
> +TEST_GEN_FILES := $(patsubst %,$(OUTPUT)%,$(TEST_GEN_FILES))

You should just be able to use addprefix there.

> +
>  all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
>  
>  clean:
>  	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
>  
> -%: %.c
> -	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^
> +$(OUTPUT)%:%.c
> +	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@

I think it reads better with a space after the ":"

$(OUTPUT)/%: %.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@



I'll have to go through and check all those conversions. But I think
I've sent you enough comments for today :)

cheers
