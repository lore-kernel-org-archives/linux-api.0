From: Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 0/2] __vdso_findsym
Date: Sat, 14 Jun 2014 11:16:42 -0700
Message-ID: <cover.1402769596.git.luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Russ Cox <rsc@golang.org>, linux-api@vger.kernel.org, Ian Taylor <iant@golang.org>, linux-kernel@vger.kernel.org
Cc: X86 ML <x86@kernel.org>, dalias@libc.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

The idea is to add AT_VDSO_FINDSYM pointing at __vdso_findsym.  This
implements __vdso_findsym.

This would make it easier for runtimes that don't otherwise implement
ELF loaders to use the vdso.

Thoughts?

If people like the basic concept, I'll finish it, write up
documentation and a selftest.  If people don't like it, I'll drop it.

Andy Lutomirski (2):
  uapi: Add some missing dynamic table-related definitions to elf.h
  [NOT READY] x86/vdso: Add __vdso_findsym

 arch/x86/vdso/Makefile          |   3 +
 arch/x86/vdso/vdso-findsym.c    | 136 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso-layout.lds.S |  11 ++--
 arch/x86/vdso/vdso.lds.S        |   1 +
 arch/x86/vdso/vdso2c.h          |   2 +-
 include/uapi/linux/elf.h        | 121 +++++++++++++++++++++++++++++++++++
 6 files changed, 268 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/vdso/vdso-findsym.c

-- 
1.9.3
