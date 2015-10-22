From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [RFC v3 9/9] kmsg: selftests
Date: Thu, 22 Oct 2015 11:32:12 +1100
Message-ID: <1445473932.30295.4.camel@ellerman.id.au>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
	 <1445259503-18158-10-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1445259503-18158-10-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>, Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2015-10-19 at 14:58 +0200, Paul Osmialowski wrote:

> This patch adds selftests framework and four test scenarios for kmsg.
> 
> The framework shape and code was inspired by similar selftests framework
> for kdbus.

> diff --git a/tools/testing/selftests/kmsg/Makefile b/tools/testing/selftests/kmsg/Makefile
> new file mode 100644
> index 0000000..b4ba892
> --- /dev/null
> +++ b/tools/testing/selftests/kmsg/Makefile
> @@ -0,0 +1,30 @@
> +CFLAGS += -I../../../../usr/include/
> +CFLAGS += -I../../../../samples/kmsg/
> +CFLAGS += -I../../../../include/uapi/

Please don't directly include the unexported kernel headers.

> +CFLAGS += -std=gnu99 -Wall
> +CFLAGS += -DKBUILD_MODNAME=\"kmsg\" -D_GNU_SOURCE

Are you building userspace code here? I'm not sure why you need KBUILD_MODNAME.

> +CFLAGS += -pthread
> +LDLIBS += -pthread
> +
> +OBJS= \
> +	kmsg-test.o				\
> +	test-buffer-add-del.o			\
> +	test-buffer-add-write-read-del.o	\
> +	test-buffer-buf-torture.o		\
> +	test-buffer-buf-multithreaded-torture.o
> +
> +all: kmsg-test
> +
> +include ../lib.mk
> +
> +%.o: %.c kmsg-test.h
> +	$(CC) $(CFLAGS) -c $< -o $@
> +
> +kmsg-test: $(OBJS)
> +	$(CC) $(CFLAGS) $^ $(LDLIBS) -o $@

Those look the same as the implicit rules to me, so I don't think you need to
spell them out.

> +
> +run_tests:
> +	./kmsg-test --tap

This should be giving you a warning about redefining run_tests.

It sounds like you don't actually need to pass --tap, so you don't need to
override run_tests.

So you should just define:

TEST_PROGS := kmsg-test

Before you include lib.mk and then both the run and emit rules will work
without any more work on your part.

cheers

