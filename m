From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v9 10/10] selftests: add openat2(2) selftests
Date: Mon, 08 Jul 2019 11:15:35 +1000
Message-ID: <878st9iax4.fsf@concordia.ellerman.id.au>
References: <20190706145737.5299-1-cyphar@cyphar.com> <20190706145737.5299-11-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190706145737.5299-11-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Aleksa,

A few minor comments below.

Aleksa Sarai <cyphar@cyphar.com> writes:
> diff --git a/tools/testing/selftests/openat2/Makefile b/tools/testing/selftests/openat2/Makefile
> new file mode 100644
> index 000000000000..8235a49928f6
> --- /dev/null
> +++ b/tools/testing/selftests/openat2/Makefile
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +CFLAGS += -Wall -O2 -g
> +TEST_GEN_PROGS := linkmode_test resolve_test rename_attack_test
> +
> +include ../lib.mk
> +
> +$(OUTPUT)/linkmode_test: linkmode_test.c helpers.o
> +$(OUTPUT)/rename_attack_test: rename_attack_test.c helpers.o
> +$(OUTPUT)/resolve_test: resolve_test.c helpers.o

You don't need to tell make that foo depends on foo.c.

Also if you make the dependency be on helpers.c then you won't get an
intermediate helpers.o, and then you don't need to clean it.

So the above three lines could just be:

$(TEST_GEN_PROGS): helpers.c

> +EXTRA_CLEAN = helpers.o $(wildcard /tmp/ksft-openat2-*)

If you follow my advice above you don't need helpers.o in there.

Deleting things from /tmp is also a bit fishy on shared machines, ie. it
will error if those files happen to be owned by another user.

cheers
