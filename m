From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2 2/2] tests: add close_range() tests
Date: Tue, 28 May 2019 12:33:41 +1000
Message-ID: <8736kzqpdm.fsf@concordia.ellerman.id.au>
References: <20190523154747.15162-1-christian@brauner.io> <20190523154747.15162-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523154747.15162-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, fweimer@redhat.com
Cc: jannh@google.com, oleg@redhat.com, tglx@linutronix.de, arnd@arndb.de, shuah@kernel.org, dhowells@redhat.com, tkjos@android.com, ldv@altlinux.org, miklos@szeredi.hu, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org, x86@kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian@brauner.io> writes:
> This adds basic tests for the new close_range() syscall.
> - test that no invalid flags can be passed
> - test that a range of file descriptors is correctly closed
> - test that a range of file descriptors is correctly closed if there there
>   are already closed file descriptors in the range
> - test that max_fd is correctly capped to the current fdtable maximum
>
> Signed-off-by: Christian Brauner <christian@brauner.io>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jann Horn <jannh@google.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Dmitry V. Levin <ldv@altlinux.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Florian Weimer <fweimer@redhat.com>
> Cc: linux-api@vger.kernel.org
> ---
> v1: unchanged
> v2:
> - Christian Brauner <christian@brauner.io>:
>   - verify that close_range() correctly closes a single file descriptor
> ---
>  tools/testing/selftests/Makefile              |   1 +
>  tools/testing/selftests/core/.gitignore       |   1 +
>  tools/testing/selftests/core/Makefile         |   6 +
>  .../testing/selftests/core/close_range_test.c | 142 ++++++++++++++++++
>  4 files changed, 150 insertions(+)
>  create mode 100644 tools/testing/selftests/core/.gitignore
>  create mode 100644 tools/testing/selftests/core/Makefile
>  create mode 100644 tools/testing/selftests/core/close_range_test.c
>
> diff --git a/tools/testing/selftests/core/.gitignore b/tools/testing/selftests/core/.gitignore
> new file mode 100644
> index 000000000000..6e6712ce5817
> --- /dev/null
> +++ b/tools/testing/selftests/core/.gitignore
> @@ -0,0 +1 @@
> +close_range_test
> diff --git a/tools/testing/selftests/core/Makefile b/tools/testing/selftests/core/Makefile
> new file mode 100644
> index 000000000000..de3ae68aa345
> --- /dev/null
> +++ b/tools/testing/selftests/core/Makefile
> @@ -0,0 +1,6 @@
> +CFLAGS += -g -I../../../../usr/include/ -I../../../../include

Your second -I pulls the unexported kernel headers in, userspace
programs shouldn't include unexported kernel headers.

It breaks the build on powerpc with eg:

  powerpc64le-linux-gnu-gcc -g -I../../../../usr/include/ -I../../../../include    close_range_test.c  -o /output/kselftest/core/close_range_test
  In file included from /usr/powerpc64le-linux-gnu/include/bits/fcntl-linux.h:346,
                   from /usr/powerpc64le-linux-gnu/include/bits/fcntl.h:62,
                   from /usr/powerpc64le-linux-gnu/include/fcntl.h:35,
                   from close_range_test.c:5:
  ../../../../include/linux/falloc.h:13:2: error: unknown type name '__s16'
    __s16  l_type;
    ^~~~~


Did you do that on purpose or just copy it from one of the other
Makefiles? :)

If you're just wanting to get the syscall number when the headers
haven't been exported, I think the best solution is to do eg:

diff --git a/tools/testing/selftests/core/close_range_test.c b/tools/testing/selftests/core/close_range_test.c
index d6e6079d3d53..34c6f02f25de 100644
--- a/tools/testing/selftests/core/close_range_test.c
+++ b/tools/testing/selftests/core/close_range_test.c
@@ -14,6 +14,10 @@

 #include "../kselftest.h"

+#ifndef __NR_close_range
+#define __NR_close_range       435
+#endif
+
 static inline int sys_close_range(unsigned int fd, unsigned int max_fd,
                                  unsigned int flags)
 {


cheers
