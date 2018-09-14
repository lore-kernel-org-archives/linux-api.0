From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] [RFC] making uapi/linux/elfcore.h useful again
Date: Fri, 14 Sep 2018 19:45:28 +0200
Message-ID: <20180914174528.GA35000@gmail.com>
References: <20180914113929.953895-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180914113929.953895-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Joseph =?iso-8859-1?Q?Myers=A0?= <joseph@codesourcery.com>, David Howells <dhowells@redhat.com>, libc-alpha@sourceware.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> After finding a bug in glibc the question came up how linux/elfcore.h
> is supposed to be used from user space. As far as I can tell, it's
> not possible, as it references data types that are simply unavailable
> there.
> 
> The #ifndef __KERNEL__ section in that header dates back to when the
> file was introduced in linux-1.3.5, and presumably was meant to
> provide the structures for the libc sys/procfs.h implementation.
> However, this was never portable to architectures other than x86-32,
> and has been broken on that architecture at a later point.
> 
> These are the steps that I needed to make it possible to include the
> header file, e.g. for libc self-testing in order to make sure the
> structures are compatible with its own:
> 
> - drop the #ifndef __KERNEL__ section that are obviously useless
>   and get in the way
> 
> - change the pid_t references to __kernel_pid_t
> 
> - Move required data from the private x86 asm/elf.h file into
>   a new uapi/asm/elf.h. Some other architectures already do that,
>   but most of them do not. Before applying the patch, we have
>   to do this for all architectures
> 
> - Change ELF_NGREG to an integer literal constant instead of
>   a sizeof operation based on a private type.
> 
> Cc: Joseph Myers <joseph@codesourcery.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: libc-alpha@sourceware.org
> Link: https://patchwork.ozlabs.org/patch/969540/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/x86/include/asm/elf.h         | 24 +-----------------------
>  arch/x86/include/uapi/asm/elf.h    | 30 ++++++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/signal.h |  2 +-
>  include/uapi/linux/elf.h           |  1 +
>  include/uapi/linux/elfcore.h       | 26 +++++---------------------
>  5 files changed, 38 insertions(+), 45 deletions(-)
>  create mode 100644 arch/x86/include/uapi/asm/elf.h

Acked-by: Ingo Molnar <mingo@kernel.org>

I suspect this wants to go through -mm, or do you want to carry it?

Thanks,

	Ingo
