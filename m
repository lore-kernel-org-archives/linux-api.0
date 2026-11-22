Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310389;
	b=otOFOomnn6XU7uAVrAXNMeY8b8DbBTm3l+tKVNDMbS8ZGFsS1Zpk0Rybf4j0fMCPazRo
	 bQtWpftGXObG8k+1/kB2X7DuzA+fhzRg320a0ulrJ41bay96+TEvfgk7q+eJWRTTjXL4Y
	 0UShRnrko/bRQJWE07pe8UOpGZqccCaE7rJAY0t7bM0dFmUcsMVqQsmUb1kNvMtRNBiTt
	 0QFdC8hLRf45teMpf4epe2s4uEy6S6kol9WeHbrPaZBbJIs+m2b1L4b6Mvgdcp8B5t5kk
	 tvKU35UElvIkkyD1GqO5Ki67Jb9vn8ujBqAlVITPOgLCn7LmceWBt9UMc8TeK1Q5e7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PRa/Z4N97Xs3mX/qNh7M9bbsE39tiqxbHLlAZExaAw8=;
	b=OaDHkYnEn3NFPWCMgQMAKtFpj+yJf871X8ikDKg9kHqr1rBGXCDVOPn3L+n4sGYhoBAt
	 mMFTNCvlAbGhkZj8EnLA1nwcML1A8aaLsaBktwVtK6cNNAjgcEweOqpwHH477GO7xVzof
	 qlErSOArtGG7Cb8xWTVRdQl6NdGP6rOjYkzt5Ty9voSKQHXTyZ0MyAO4MgAC4/Osnin24
	 dP/6nTfoHOxZkkK/2ILotqZgHSf1wY/HiI3wTArGhyKMfXXR7lenP19RtcrZUtxwliaZI
	 AOm+oVxccj8GMcTsCzbp8fnw7uFG2OiN+HhYIJfTHiuFJ+9QmWDkSdrOTuD2qOkDVnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="CSP8/SLw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EC1A960A2622;
	Sun, 22 Nov 2026 01:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSP8/SLw
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EECF01F000E0;
	Sun, 22 Nov 2026 01:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310388;
	bh=PRa/Z4N97Xs3mX/qNh7M9bbsE39tiqxbHLlAZExaAw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSP8/SLw0/pvy7YCDF4gSY+Ry/Hi7tWxmcKW+8hYOQqeYmZcXY1yLmYZKmuKkO9KS
	 5F0EK6LsGG8iEIUnYtG2AkvPjTo7CHHIwYADZYOHoZAYnxww2tq7HRbytgtabF3c8C
	 M6eFafM0n3PyUz1IUz7GDweh4oMgAlhSa1dRxocqBGGq429ZS6MeVx89BWHD1EHWfQ
	 qRaQr7DhxfiY6oPhASWGARcZqcf83Qztql3o8hQz/GTK2erRIMXT096Iw7y1gmLRAC
	 gX3+ltTezUb8qawkLbu+z5nlSkv3VHSAPaVv6mBLKxwv/hlQ4Cb2yh5DgIU9l+9pQp
	 m9GkI1up2vC3Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 23/26] arch: Wire up userland_open() system call
Date: Sun, 22 Nov 2026 03:18:06 +0200
Message-ID: <20261122011809.2667684-24-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that userland lifecycle and VFS mount-tree installation are in
place, expose userland_open() (474, 584 on Alpha) across all
architecture system call tables, asm-generic unistd.h, and the mirrored
copies under tools/.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl              | 1 +
 arch/arm/tools/syscall.tbl                          | 1 +
 arch/arm64/tools/syscall_32.tbl                     | 1 +
 arch/m68k/kernel/syscalls/syscall.tbl               | 1 +
 arch/microblaze/kernel/syscalls/syscall.tbl         | 1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl           | 1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl           | 1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl           | 1 +
 arch/parisc/kernel/syscalls/syscall.tbl             | 1 +
 arch/powerpc/kernel/syscalls/syscall.tbl            | 1 +
 arch/s390/kernel/syscalls/syscall.tbl               | 1 +
 arch/sh/kernel/syscalls/syscall.tbl                 | 1 +
 arch/sparc/kernel/syscalls/syscall.tbl              | 1 +
 arch/x86/entry/syscalls/syscall_32.tbl              | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl              | 1 +
 arch/xtensa/kernel/syscalls/syscall.tbl             | 1 +
 include/uapi/asm-generic/unistd.h                   | 6 +++++-
 scripts/syscall.tbl                                 | 1 +
 tools/include/uapi/asm-generic/unistd.h             | 6 +++++-
 tools/perf/arch/arm/entry/syscalls/syscall.tbl      | 1 +
 tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl | 1 +
 tools/perf/arch/powerpc/entry/syscalls/syscall.tbl  | 1 +
 tools/perf/arch/s390/entry/syscalls/syscall.tbl     | 1 +
 tools/perf/arch/sh/entry/syscalls/syscall.tbl       | 1 +
 tools/perf/arch/sparc/entry/syscalls/syscall.tbl    | 1 +
 tools/perf/arch/x86/entry/syscalls/syscall_32.tbl   | 1 +
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl   | 1 +
 tools/perf/arch/xtensa/entry/syscalls/syscall.tbl   | 1 +
 tools/scripts/syscall.tbl                           | 1 +
 29 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 60d330a51476..2d66a28b610d 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -513,3 +513,4 @@
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
 583	common	userns_set_idmap		sys_userns_set_idmap
+584	common	userland_open			sys_userland_open
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index d055515e98cd..4d2608f907de 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -488,3 +488,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index a18982ead3bf..2f3e7a4686bf 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -485,3 +485,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index e89ec7d54b8c..ad1b3326c478 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -473,3 +473,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 0dfcd6f9e4e7..4a9f4e1e7e31 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -479,3 +479,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 882ff15f3e6d..7483d569dcb0 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -412,3 +412,4 @@
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
 473	n32	userns_set_idmap		sys_userns_set_idmap
+474	n32	userland_open			sys_userland_open
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index daa95049baef..fe5c3ab9ffa7 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -388,3 +388,4 @@
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
 473	n64	userns_set_idmap		sys_userns_set_idmap
+474	n64	userland_open			sys_userland_open
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 9e0040399fef..233e0b6850ae 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -461,3 +461,4 @@
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
 473	o32	userns_set_idmap		sys_userns_set_idmap
+474	o32	userland_open			sys_userland_open
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index b77482e68d1a..7c251ea35d4c 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -472,3 +472,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 973562f20a94..b07ab66144b5 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -564,3 +564,4 @@
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	nospu	userns_set_idmap		sys_userns_set_idmap
+474	nospu	userland_open			sys_userland_open
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 19d7b234b31b..4daa1f92e171 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -400,3 +400,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index 252e6f9aa04c..df51ac4faaf4 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -477,3 +477,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 1263d0e825c1..3db2b5a99b1f 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -519,3 +519,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 0f8c81c584e0..68e3e01c8751 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -479,3 +479,4 @@
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
 473	i386	userns_set_idmap	sys_userns_set_idmap
+474	i386	userland_open		sys_userland_open
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 5452b7567bf8..f8ad4c72a86e 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -398,6 +398,7 @@
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
 473	common	userns_set_idmap	sys_userns_set_idmap
+474	common	userland_open		sys_userland_open
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index f10b491c873c..b87586ff006c 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 695eac2d356b..201335a08837 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -871,8 +871,12 @@ __SYSCALL(__NR_fchroot, sys_fchroot)
 #define __NR_userns_set_idmap 473
 __SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
 
+/* kernel/userland.c */
+#define __NR_userland_open 474
+__SYSCALL(__NR_userland_open, sys_userland_open)
+
 #undef __NR_syscalls
-#define __NR_syscalls 474
+#define __NR_syscalls 475
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 7ba073cc0e80..c3d07ff911a7 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -414,3 +414,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index 695eac2d356b..201335a08837 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -871,8 +871,12 @@ __SYSCALL(__NR_fchroot, sys_fchroot)
 #define __NR_userns_set_idmap 473
 __SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
 
+/* kernel/userland.c */
+#define __NR_userland_open 474
+__SYSCALL(__NR_userland_open, sys_userland_open)
+
 #undef __NR_syscalls
-#define __NR_syscalls 474
+#define __NR_syscalls 475
 
 /*
  * 32 bit systems traditionally used different
diff --git a/tools/perf/arch/arm/entry/syscalls/syscall.tbl b/tools/perf/arch/arm/entry/syscalls/syscall.tbl
index d055515e98cd..4d2608f907de 100644
--- a/tools/perf/arch/arm/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/arm/entry/syscalls/syscall.tbl
@@ -488,3 +488,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl b/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
index daa95049baef..fe5c3ab9ffa7 100644
--- a/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
+++ b/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
@@ -388,3 +388,4 @@
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
 473	n64	userns_set_idmap		sys_userns_set_idmap
+474	n64	userland_open			sys_userland_open
diff --git a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
index 973562f20a94..b07ab66144b5 100644
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -564,3 +564,4 @@
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	nospu	userns_set_idmap		sys_userns_set_idmap
+474	nospu	userland_open			sys_userland_open
diff --git a/tools/perf/arch/s390/entry/syscalls/syscall.tbl b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
index 19d7b234b31b..4daa1f92e171 100644
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -400,3 +400,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/perf/arch/sh/entry/syscalls/syscall.tbl b/tools/perf/arch/sh/entry/syscalls/syscall.tbl
index 252e6f9aa04c..df51ac4faaf4 100644
--- a/tools/perf/arch/sh/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/sh/entry/syscalls/syscall.tbl
@@ -477,3 +477,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/perf/arch/sparc/entry/syscalls/syscall.tbl b/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
index 1263d0e825c1..3db2b5a99b1f 100644
--- a/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
@@ -519,3 +519,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
index 0f8c81c584e0..68e3e01c8751 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
@@ -479,3 +479,4 @@
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
 473	i386	userns_set_idmap	sys_userns_set_idmap
+474	i386	userland_open		sys_userland_open
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index 5452b7567bf8..f8ad4c72a86e 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -398,6 +398,7 @@
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
 473	common	userns_set_idmap	sys_userns_set_idmap
+474	common	userland_open		sys_userland_open
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl b/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
index f10b491c873c..b87586ff006c 100644
--- a/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/scripts/syscall.tbl b/tools/scripts/syscall.tbl
index 7ba073cc0e80..c3d07ff911a7 100644
--- a/tools/scripts/syscall.tbl
+++ b/tools/scripts/syscall.tbl
@@ -414,3 +414,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
-- 
2.47.3

