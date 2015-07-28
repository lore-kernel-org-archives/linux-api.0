From: David Drysdale <drysdale@google.com>
Subject: [PATCH RFC 1/1] UAPI,x86: export syscall numbers for all x86 archs
Date: Tue, 28 Jul 2015 09:05:31 +0100
Message-ID: <1438070731-17764-2-git-send-email-drysdale@google.com>
References: <1438070731-17764-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438070731-17764-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Some userspace code occasionally has a need to reference the syscall
numbers for different-but-compatible architectures, so explicitly
export the generated files that contain the __NR_ia32_<name> and
__NR_x32_<name> constants.

Also, add a new generated unistd_64_amd64.h file, holding amd64
system call numbers in form __NR_amd64_<name>.

For example, this allows a seccomp-bpf filter to include filtering
for multiple architectures, and (in particular) to include x32
syscalls in an x86_64 filter.  (Programmatic control of the audit
framework is another possible use case.)

Signed-off-by: David Drysdale <drysdale@google.com>
---
 arch/x86/entry/syscalls/Makefile | 11 ++++++++---
 arch/x86/include/uapi/asm/Kbuild |  3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/syscalls/Makefile b/arch/x86/entry/syscalls/Makefile
index 57aa59fd140c..ec6811d0db0b 100644
--- a/arch/x86/entry/syscalls/Makefile
+++ b/arch/x86/entry/syscalls/Makefile
@@ -28,7 +28,7 @@ $(uapi)/unistd_32.h: $(syscall32) $(syshdr)

 syshdr_abi_unistd_32_ia32 := i386
 syshdr_pfx_unistd_32_ia32 := ia32_
-$(out)/unistd_32_ia32.h: $(syscall32) $(syshdr)
+$(uapi)/unistd_32_ia32.h: $(syscall32) $(syshdr)
 	$(call if_changed,syshdr)

 syshdr_abi_unistd_x32 := common,x32
@@ -42,7 +42,12 @@ $(uapi)/unistd_64.h: $(syscall64) $(syshdr)

 syshdr_abi_unistd_64_x32 := x32
 syshdr_pfx_unistd_64_x32 := x32_
-$(out)/unistd_64_x32.h: $(syscall64) $(syshdr)
+$(uapi)/unistd_64_x32.h: $(syscall64) $(syshdr)
+	$(call if_changed,syshdr)
+
+syshdr_abi_unistd_64_amd64 := common,64
+syshdr_pfx_unistd_64_amd64 := amd64_
+$(uapi)/unistd_64_amd64.h: $(syscall64) $(syshdr)
 	$(call if_changed,syshdr)

 $(out)/syscalls_32.h: $(syscall32) $(systbl)
@@ -56,8 +61,8 @@ $(out)/xen-hypercalls.h: $(srctree)/scripts/xen-hypercalls.sh
 $(out)/xen-hypercalls.h: $(srctree)/include/xen/interface/xen*.h

 uapisyshdr-y			+= unistd_32.h unistd_64.h unistd_x32.h
+uapisyshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h unistd_64_amd64.h unistd_64_x32.h
 syshdr-y			+= syscalls_32.h
-syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h unistd_64_x32.h
 syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
 syshdr-$(CONFIG_XEN)		+= xen-hypercalls.h

diff --git a/arch/x86/include/uapi/asm/Kbuild b/arch/x86/include/uapi/asm/Kbuild
index 3dec769cadf7..68805cba2fad 100644
--- a/arch/x86/include/uapi/asm/Kbuild
+++ b/arch/x86/include/uapi/asm/Kbuild
@@ -4,6 +4,9 @@ include include/uapi/asm-generic/Kbuild.asm
 genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
+genhdr-y += unistd_64_amd64.h
+genhdr-y += unistd_64_x32.h
+genhdr-y += unistd_32_ia32.h
 header-y += a.out.h
 header-y += auxvec.h
 header-y += bitsperlong.h
--
2.4.3.573.g4eafbef
