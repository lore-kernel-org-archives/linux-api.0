From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH] x86: Deprecate a.out support
Date: Tue, 5 Mar 2019 15:59:52 +0100
Message-ID: <20190305145717.GD8256@zn.tnic>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic>
 <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190305134347.4be2449c@alans-desktop>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>
List-Id: linux-api@vger.kernel.org

+ akpm and Linus.

On Tue, Mar 05, 2019 at 01:43:47PM +0000, Alan Cox wrote:
> > It's been 25 years since Linux added support for ELF.  Can we just
> > delete the a.out support entirely now?  According to the Linux-ELF HOWTO,
> > support was added in 1.1.52 (August 1994).  It's pretty much necromancy
> > at this point.
> 
> In the unlikely event that someone actually has an a.out binary they
> can't live with they can also just write an a.out loader as an ELF
> program entirely in userspace.
> 
> I'd vote for giving it the boot unless there are any architectures that
> kept using a.out far longer due to tool chain issues ?

We can at least deprecate it on x86...

---
From: Borislav Petkov <bp@suse.de>
Date: Tue, 5 Mar 2019 15:47:51 +0100
Subject: [PATCH] x86: Deprecate a.out support

Linux supports ELF binaries for ~25 years now. a.out coredumping has
bitrotten quite significantly and would need some fixing to get it into
shape again but considering how even the toolchains cannot create a.out
executables in its default configuration, let's deprecate a.out support
and remove it a couple of releases later, instead.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Jann Horn <jannh@google.com>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <x86@kernel.org>
---
 arch/x86/Kconfig    | 2 +-
 arch/x86/um/Kconfig | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 68261430fe6e..ade12ec4224b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -14,7 +14,6 @@ config X86_32
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select CLKSRC_I8253
 	select CLONE_BACKWARDS
-	select HAVE_AOUT
 	select HAVE_GENERIC_DMA_COHERENT
 	select MODULES_USE_ELF_REL
 	select OLD_SIGACTION
@@ -2843,6 +2842,7 @@ config IA32_EMULATION
 config IA32_AOUT
 	tristate "IA32 a.out support"
 	depends on IA32_EMULATION
+	depends on BROKEN
 	---help---
 	  Support old a.out binaries in the 32bit emulation.
 
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index f518b4744ff8..494eeb51e4e1 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -16,7 +16,6 @@ config 64BIT
 
 config X86_32
 	def_bool !64BIT
-	select HAVE_AOUT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select MODULES_USE_ELF_REL
 	select CLONE_BACKWARDS
-- 
2.21.0

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
