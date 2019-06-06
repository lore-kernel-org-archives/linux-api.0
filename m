From: Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: Re: [PATCH 10/10] Add sample notification program [ver #3]
Date: Thu, 6 Jun 2019 23:21:40 +0200
Message-ID: <20190606212140.GA25664@vmlxhi-102.adit-jv.com>
References: <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
 <155981421379.17513.13158528501056454772.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <155981421379.17513.13158528501056454772.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Eugeniu Rosca <erosca@de.adit-jv.com>, Eugeniu Rosca <roscaeugeniu@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi David,

On Thu, Jun 06, 2019 at 10:43:33AM +0100, David Howells wrote:
[..]
> diff --git a/samples/watch_queue/Makefile b/samples/watch_queue/Makefile
> new file mode 100644
> index 000000000000..42b694430d0f
> --- /dev/null
> +++ b/samples/watch_queue/Makefile
> @@ -0,0 +1,9 @@
> +# List of programs to build
> +hostprogs-y := watch_test
> +
> +# Tell kbuild to always build the programs
> +always := $(hostprogs-y)
> +
> +HOSTCFLAGS_watch_test.o += -I$(objtree)/usr/include

How about arm64? Do you intend to enable cross-compilation?

> +
> +HOSTLOADLIBES_watch_test += -lkeyutils
> diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch_test.c
> new file mode 100644
> index 000000000000..893a5380f792
> --- /dev/null
> +++ b/samples/watch_queue/watch_test.c
[..]

> +			asm ("lfence" : : : "memory" );
[..]
> +			asm("mfence" ::: "memory");

FWIW, trying to cross-compile it returned:

aarch64-linux-gnu-gcc -I../../usr/include -I../../include  watch_test.c   -o watch_test
/tmp/ccDXYynm.s: Assembler messages:
/tmp/ccDXYynm.s:471: Error: unknown mnemonic `lfence' -- `lfence'
/tmp/ccDXYynm.s:568: Error: unknown mnemonic `mfence' -- `mfence'
<builtin>: recipe for target 'watch_test' failed
make: *** [watch_test] Error 1

-- 
Best Regards,
Eugeniu.
