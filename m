From: David Drysdale <drysdale@google.com>
Subject: [PATCH RFC 0/1] UAPI,x86: export syscall numbers for all x86 archs
Date: Tue, 28 Jul 2015 09:05:30 +0100
Message-ID: <1438070731-17764-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

A while ago I was trying to build a seccomp-bpf filter program that would
survive a change of x86 architecture.  This was complicated for all sorts of
reasons, but one of the problems was that the different syscall numbers aren't
all available at the same time -- hence this patch.

Naming-wise, Andy Lutomirski has indicated he'd prefer the prefixes to be
__NR_x86_64_, __NR_x86_64_x32_ and __NR_i386_; however, for the latter two
sets of numbers there are existing headers that use different prefixes
(__NR_x32_ and __NR_ia32_), so altering those would involve a change and/or an
additional set of definitions.  For the new constants I've left in my
original suggestion (__NR_amd64_) for the time being.

What are folks' thoughts about the preferred naming for these?


David Drysdale (1):
  UAPI,x86: export syscall numbers for all x86 archs

 arch/x86/entry/syscalls/Makefile | 11 ++++++++---
 arch/x86/include/uapi/asm/Kbuild |  3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

--
2.4.3.573.g4eafbef
