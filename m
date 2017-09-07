From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/4] Fix check address limit on user-mode
Date: Thu,  7 Sep 2017 08:30:43 -0700
Message-ID: <1504798247-48833-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Dave Martin <Dave.Martin@arm.com>, Pratyush Anand <panand@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Yonghong Song <yhs@fb.com>, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes from Thomas Garnier: the new address limit check was causing
hangs on ARM. This solves the problem and takes proactive steps on
ARM64. Additionally removes the unconditional BUG_ON() on check failures.

-Kees
