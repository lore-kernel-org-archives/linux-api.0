From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] selftests: add seccomp suite
Date: Wed, 17 Jun 2015 16:12:51 +1000
Message-ID: <1434521571.24642.13.camel@ellerman.id.au>
References: <20150616175414.GA24958@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150616175414.GA24958-0X9Bc/hWBUTk6RaD4rd5nQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jingoo Han <jingoohan1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-06-16 at 10:54 -0700, Kees Cook wrote:
> This imports the existing seccomp test suite into the kernel's selftests
> tree. It contains extensive testing of seccomp features and corner cases.
> There remain additional tests to move into the kernel tree, but they have
> not yet been ported to all the architectures seccomp supports:
> https://github.com/redpig/seccomp/tree/master/tests

> diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
> new file mode 100644
> index 000000000000..8401e87e34e1
> --- /dev/null
> +++ b/tools/testing/selftests/seccomp/Makefile
> @@ -0,0 +1,10 @@
> +TEST_PROGS := seccomp_bpf
> +CFLAGS += -Wl,-no-as-needed -Wall
> +LDFLAGS += -lpthread

Can't you do:

  CFLAGS += -Wall
  LDLIBS += -lpthread

?

cheers
