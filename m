From: Palmer Dabbelt <palmer@sifive.com>
Subject: [PATCH 4/5] x86: Add fchmodat4 to syscall_64.tbl
Date: Fri, 31 May 2019 12:12:03 -0700
Message-ID: <20190531191204.4044-5-palmer@sifive.com>
References: <20190531191204.4044-1-palmer@sifive.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531191204.4044-1-palmer@sifive.com>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org, x86@kernel.org, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, Arnd Bergmann <arnd@arndb.de>, Palmer Dabbelt <palmer@sifive.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
---
 arch/x86/entry/syscalls/syscall_64.tbl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 92ee0b4378d4..998aa3eb09e2 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -349,6 +349,7 @@
 425	common	io_uring_setup		__x64_sys_io_uring_setup
 426	common	io_uring_enter		__x64_sys_io_uring_enter
 427	common	io_uring_register	__x64_sys_io_uring_register
+428	common	fchmodat4		__x64_sys_fchmodat4
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
2.21.0
