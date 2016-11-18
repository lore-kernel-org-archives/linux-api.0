From: "Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Fri, 18 Nov 2016 21:03:09 +0800
Message-ID: <c8b1b78e-5c57-4522-3e86-b0c6d3b7df28@huawei.com>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com>
 <1477047694-24122-7-git-send-email-bamvor.zhangjian@huawei.com>
 <878tshgh5f.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <878tshgh5f.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi, Macheal

Thanks your reply.

On 2016/11/18 19:29, Michael Ellerman wrote:
 >> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 >>
 >> Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
 >> to another directory by passing O or KBUILD_OUTPUT. And O is high
 >> priority than KBUILD_OUTPUT.
 >
 >We end up saying $(OUTPUT) a lot, kbuild uses $(obj), which is shorter
 >and less shouty and reads nicer I think ?
I agree that we need a clearly name. Meanwhile the $(obj) sounds like
compile objects. But it is actually a directory which we put objs to
there. I am wondering if people may confuse about he name. Given that
kbuild make KBUILD_OUTPUT work by defining the srctree. How about pick
up dst (means dsttree) instead of OUTPUT?
 >
 >> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
 >> index a3144a3..79c5e97 100644
 >> --- a/tools/testing/selftests/Makefile
 >> +++ b/tools/testing/selftests/Makefile
 >> @@ -47,29 +47,47 @@ override LDFLAGS =
 >>  override MAKEFLAGS =
 >>  endif
 >>
 >> +ifeq ($(O)$(KBUILD_OUTPUT),)
 >> +        BUILD :=$(shell pwd)
 >> +else
 >> +        ifneq ($(O),)
 >> +                BUILD := $(O)
 >> +        else
 >> +                ifneq ($(KBUILD_OUTPUT),)
 >> +                        BUILD := $(KBUILD_OUTPUT)
 >> +                endif
 >> +        endif
 >> +endif
 >
 >That should be equivalent to:
 >
 >BUILD := $(O)
 >ifndef BUILD
 >  BUILD := $(KBUILD_OUTPUT)
 >endif
 >ifndef BUILD
 >  BUILD := $(shell pwd)
 >endif
Thanks. It works for me. I will update in my next version.
 >
 >> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
 >> index 48d1f86..fe5cdec 100644
 >> --- a/tools/testing/selftests/exec/Makefile
 >> +++ b/tools/testing/selftests/exec/Makefile
 >> @@ -5,18 +5,19 @@ TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 >>  # Makefile is a run-time dependency, since it's accessed by the execveat test
 >>  TEST_FILES := Makefile
 >>
 >> -EXTRA_CLEAN := subdir.moved execveat.moved xxxxx*
 >> +EXTRA_CLEAN := $(OUTPUT)subdir.moved $(OUTPUT)execveat.moved $(OUTPUT)xxxxx*
 >
 >It reads strangely to not have a slash after the output I think it would
 >be better if you used a slash everywhere you use it, like:
 >
 >EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*
 >
 >That makes it clear that it's a directory, and not some other prefix.
Oh, yes. The origin code is not work if remove the slash. I eventually
found that it is because I do the wrong replacement in TEST_GEN_PROGS
and TEST_GEN_FILES. They should be:
TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
 >
 >
 >Having said that, I think for EXTRA_CLEAN it should just be defined that
 >the contents are in $(OUTPUT), and so we can just do that in lib.mk, eg:
 >
 >EXTRA_CLEAN := $(addprefix $(OUTPUT)/,$(EXTRA_CLEAN))
 >
 >clean:
 >    $(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
The OUTPUT is the directory we build. It may be not be not the
directory we run the test. For example, pstore do not need compile.
It could run in the source directory.
 >
 >
 >>  include ../lib.mk
 >>
 >> -subdir:
 >> +$(OUTPUT)subdir:
 >>   mkdir -p $@
 >> -script:
 >> +$(OUTPUT)script:
 >>   echo '#!/bin/sh' > $@
 >>   echo 'exit $$*' >> $@
 >>   chmod +x $@
 >> -execveat.symlink: execveat
 >> - ln -s -f $< $@
 >> -execveat.denatured: execveat
 >> +$(OUTPUT)execveat.symlink: execveat
 >> + cd $(OUTPUT) && ln -s -f $< `basename $@`
 >> +$(OUTPUT)execveat.denatured: execveat
 >>   cp $< $@
 >>   chmod -x $@
 >
 >Do those work? I would have thought you'd need $(OUTPUT) on the right
 >hand side also?
It works because execveat will generate twice which is wrong. I will
fix in next version.
 >
 >> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
 >> index 0f7a371..fa87f98 100644
 >> --- a/tools/testing/selftests/lib.mk
 >> +++ b/tools/testing/selftests/lib.mk
 >> @@ -33,19 +34,29 @@ endif
 >>
 >>  define EMIT_TESTS
 >>   @for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
 >> -     echo "(./$$TEST && echo \"selftests: $$TEST [PASS]\") || echo \"selftests: $$TEST [FAIL]\""; \
 >> +     BASENAME_TEST=`basename $$TEST`;    \
 >> +     echo "(./$$BASENAME_TEST && echo \"selftests: $$BASENAME_TEST [PASS]\") || echo \"selftests: $$BASENAME_TEST [FAIL]\""; \
 >>   done;
 >>  endef
 >>
 >>  emit_tests:
 >>   $(EMIT_TESTS)
 >>
 >> +TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)%,$(TEST_GEN_PROGS))
 >> +TEST_GEN_FILES := $(patsubst %,$(OUTPUT)%,$(TEST_GEN_FILES))
 >
 >You should just be able to use addprefix there.
Yes.
 >
 >> +
 >>  all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
 >>
 >>  clean:
 >>   $(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
 >>
 >> -%: %.c
 >> - $(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^
 >> +$(OUTPUT)%:%.c
 >> + $(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@
 >
 >I think it reads better with a space after the ":"
Sure

Regards

Bamvor

 >
 >$(OUTPUT)/%: %.c
 >    $(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@
 >
