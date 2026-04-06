Received: from mail-m128214.netease.com (mail-m128214.netease.com [103.209.128.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2130F38C433;
	Mon,  6 Apr 2026 19:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.209.128.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775502858; cv=none; b=CNvCJpiD5ydppmTOhssG1SNtONC7xACZAwqRhcf/6GUWy5UVNI/Gg4QvEAaksVwCyYopSaS9wouRRxQjMDx9xnXHK6AHKT+dN2X//PSxPz/5HYR2NNZdP9DyhEpCUk1S2VlaUgd8ijjWvEKNvlGQg3AG7/fNdT9vRH/tnP0hVj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775502858; c=relaxed/simple;
	bh=KnDk22NqfK2A5VmoRBMw4hkb6fV0LQGmL7Q7xj9UxpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qgDGGJyi1gut72bPIrcqyFuURJxV67xKp/NeQJCYUh/Fn3/LOKspIn0YuRSiftnzOfaUBo8/dPv0aY5eztM/OIS9czSuMOrpE6DI8QEkoj1W3N4shqfnUVwhqG6HyLLnApQKMUeg/qednaKtcrwBGTLyOsA7cV4fex/l4kdkokU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ruc.edu.cn; spf=pass smtp.mailfrom=ruc.edu.cn; dkim=pass (1024-bit key) header.d=ruc.edu.cn header.i=@ruc.edu.cn header.b=cUnJcBHG; arc=none smtp.client-ip=103.209.128.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ruc.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ruc.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ruc.edu.cn header.i=@ruc.edu.cn header.b="cUnJcBHG"
Received: from lwz.tail698a0e.ts.net (gy-adaptive-ssl-proxy-1-entmail-virt204.gy.ntes [36.112.3.244])
	by smtp.qiye.163.com (Hmail) with ESMTP id 39aaefbdd;
	Tue, 7 Apr 2026 00:51:34 +0800 (GMT+08:00)
From: Wenzhao Liao <wenzhaoliao@ruc.edu.cn>
To: rust-for-linux@vger.kernel.org,
	linux-pci@vger.kernel.org
Cc: ojeda@kernel.org,
	dakr@kernel.org,
	bhelgaas@google.com,
	kwilczynski@kernel.org,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [RFC PATCH v3 3/6] rust: page: add helpers for page-backed ping state
Date: Mon,  6 Apr 2026 12:51:17 -0400
Message-Id: <20260406165120.166928-4-wenzhaoliao@ruc.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260406165120.166928-1-wenzhaoliao@ruc.edu.cn>
References: <cover.1775456181.git.wenzhaoliao@ruc.edu.cn>
 <20260406165120.166928-1-wenzhaoliao@ruc.edu.cn>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d63b4eb5a03a2kunm562d3b0d647e7c
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTRgaVkJOSh4eTksZSUsaSVYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlITVVKSklVSFVJT09ZV1kWGg8SFR0UWUFZT0tIVUpLSEpOTE5VSktLVUpCS0
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=cUnJcBHGiOx97/kgEgPi7Kd1EEfqAQImO7E/GBbnA46rDS77dufPinwtyGC8Gy8oWi02nrZ1qBHWhqJLQBRwmPUniLy/xWqWeBZg3pOWN0bSHsN5ppdXQhEqmCTuSnYJfyCZYvdkLgqwrP4jk1Dx3NNmJnAqJUVe1YKzkCJlMsY=; c=relaxed/relaxed; s=default; d=ruc.edu.cn; v=1;
	bh=kKwjlPbz8irjEUZ4cgjU35rxHOQIvjj9A2j4f+K6xtA=;
	h=date:mime-version:subject:message-id:from;

Add the minimal safe page helpers needed by the goldfish ping buffer: physical address discovery plus bounded read, write, and zeroing operations.

The driver uses these helpers to manage its per-file ping page entirely from safe Rust while keeping the raw page mapping and pointer handling inside the page abstraction.

Signed-off-by: Wenzhao Liao <wenzhaoliao@ruc.edu.cn>
---
 rust/helpers/page.c |  5 +++++
 rust/kernel/page.rs | 52 +++++++++++++++++++++++----------------------
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/rust/helpers/page.c b/rust/helpers/page.c
index f8463fbed2a2..05824bdc4fd8 100644
--- a/rust/helpers/page.c
+++ b/rust/helpers/page.c
@@ -20,6 +20,11 @@ __rust_helper void rust_helper_kunmap_local(const void *addr)
 	kunmap_local(addr);
 }
 
+__rust_helper phys_addr_t rust_helper_page_to_phys(struct page *page)
+{
+	return page_to_phys(page);
+}
+
 #ifndef NODE_NOT_IN_PAGE_FLAGS
 __rust_helper int rust_helper_page_to_nid(const struct page *page)
 {
diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index adecb200c654..e8336d1bcc12 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -7,7 +7,7 @@
     bindings,
     error::code::*,
     error::Result,
-    uaccess::UserSliceReader,
+    io::PhysAddr,
 };
 use core::{
     marker::PhantomData,
@@ -198,6 +198,13 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Returns the physical address of the start of this page.
+    #[inline]
+    pub fn phys_addr(&self) -> PhysAddr {
+        // SAFETY: `self.as_ptr()` is a live `struct page` owned by this `Page`.
+        unsafe { bindings::page_to_phys(self.as_ptr()) }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.
@@ -337,30 +344,25 @@ pub unsafe fn fill_zero_raw(&self, offset: usize, len: usize) -> Result {
         })
     }
 
-    /// Copies data from userspace into this page.
-    ///
-    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
-    /// outside of the page, then this call returns [`EINVAL`].
-    ///
-    /// Like the other `UserSliceReader` methods, data races are allowed on the userspace address.
-    /// However, they are not allowed on the page you are copying into.
-    ///
-    /// # Safety
-    ///
-    /// Callers must ensure that this call does not race with a read or write to the same page that
-    /// overlaps with this write.
-    pub unsafe fn copy_from_user_slice_raw(
-        &self,
-        reader: &mut UserSliceReader,
-        offset: usize,
-        len: usize,
-    ) -> Result {
-        self.with_pointer_into_page(offset, len, move |dst| {
-            // SAFETY: If `with_pointer_into_page` calls into this closure, then it has performed a
-            // bounds check and guarantees that `dst` is valid for `len` bytes. Furthermore, we have
-            // exclusive access to the slice since the caller guarantees that there are no races.
-            reader.read_raw(unsafe { core::slice::from_raw_parts_mut(dst.cast(), len) })
-        })
+    /// Maps the page and reads from it into the given buffer.
+    pub fn read_slice(&self, dst: &mut [u8], offset: usize) -> Result {
+        // SAFETY: `dst` is a valid mutable slice for `dst.len()` bytes. Safe Rust also prevents
+        // callers from obtaining a mutable reference to this `Page` while this shared borrow
+        // exists, so concurrent writes through the safe API cannot overlap with this read.
+        unsafe { self.read_raw(dst.as_mut_ptr(), offset, dst.len()) }
+    }
+
+    /// Maps the page and writes the given buffer into it.
+    pub fn write_slice(&mut self, src: &[u8], offset: usize) -> Result {
+        // SAFETY: `src` is a valid immutable slice for `src.len()` bytes, and `&mut self`
+        // guarantees unique access to the page through the safe API.
+        unsafe { self.write_raw(src.as_ptr(), offset, src.len()) }
+    }
+
+    /// Zeroes a range within the page.
+    pub fn fill_zero(&mut self, offset: usize, len: usize) -> Result {
+        // SAFETY: `&mut self` guarantees unique access to the page through the safe API.
+        unsafe { self.fill_zero_raw(offset, len) }
     }
 }
 
-- 
2.34.1

