From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/3] selftests: add membarrier syscall test
Date: Mon, 31 Aug 2015 16:54:00 +1000
Message-ID: <1441004040.5735.7.camel@ellerman.id.au>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1436561912-24365-3-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436561912-24365-3-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-07-10 at 16:58 -0400, Mathieu Desnoyers wrote:
> From: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> This patch adds a self test for the membarrier system call.
> 
> CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

Sorry I only just saw this due to some over zealous filtering on my end.


> diff --git a/tools/testing/selftests/membarrier/Makefile b/tools/testing/selftests/membarrier/Makefile
> new file mode 100644
> index 0000000..877a503
> --- /dev/null
> +++ b/tools/testing/selftests/membarrier/Makefile
> @@ -0,0 +1,11 @@
> +CFLAGS += -g -I../../../../usr/include/
> +
> +all:
> +	$(CC) $(CFLAGS) membarrier_test.c -o membarrier_test
>
> +TEST_PROGS := membarrier_test

You don't need to specify the rule, the implict one will do exactly the same,
so you can just do:

TEST_PROGS := membarrier_test

all: $(TEST_PROGS)

> diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
> new file mode 100644
> index 0000000..3c9f217
> --- /dev/null
> +++ b/tools/testing/selftests/membarrier/membarrier_test.c
> @@ -0,0 +1,71 @@
> +#define _GNU_SOURCE
> +#define __EXPORTED_HEADERS__

Why are you exporting that?

I suspect to try and get around the "Attempt to use kernel headers from user space" warning.

But you're correctly building against the installed headers, not the kernel
headers, so you don't need to do that.

> +
> +#include <linux/membarrier.h>
> +#include <asm-generic/unistd.h>

This should just be <unistd.h>


cheers
