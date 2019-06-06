From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/10] Add sample notification program [ver #3]
Date: Thu, 06 Jun 2019 23:52:50 +0100
Message-ID: <31575.1559861570@warthog.procyon.org.uk>
References: <20190606212140.GA25664@vmlxhi-102.adit-jv.com> <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <155981421379.17513.13158528501056454772.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606212140.GA25664@vmlxhi-102.adit-jv.com>
Content-ID: <31574.1559861570.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugeniu Rosca <erosca@de.adit-jv.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Eugeniu Rosca <roscaeugeniu@gmail.com>
List-Id: linux-api@vger.kernel.org

Eugeniu Rosca <erosca@de.adit-jv.com> wrote:

> How about arm64? Do you intend to enable cross-compilation?

There's no guarantee that a cross-compiler can actually build userspace apps,
though I haven't intended to encode anything against that in the Makefile.

> > +			asm ("lfence" : : : "memory" );
> [..]
> > +			asm("mfence" ::: "memory");
> 
> FWIW, trying to cross-compile it returned:
> 
> aarch64-linux-gnu-gcc -I../../usr/include -I../../include  watch_test.c   -o watch_test
> /tmp/ccDXYynm.s: Assembler messages:
> /tmp/ccDXYynm.s:471: Error: unknown mnemonic `lfence' -- `lfence'
> /tmp/ccDXYynm.s:568: Error: unknown mnemonic `mfence' -- `mfence'

Yeah.  I need to use C-standard __atomic_* stuff.

David
