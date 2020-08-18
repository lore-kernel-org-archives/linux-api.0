Return-Path: <SRS0=WFd6=B4=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462BDC433E3
	for <linux-api@archiver.kernel.org>; Tue, 18 Aug 2020 14:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E6A3207FF
	for <linux-api@archiver.kernel.org>; Tue, 18 Aug 2020 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597760255;
	bh=oysYEavAzZfVG+QM9pIpE7mplr7QxKfY0kI4p0rAXl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gKjc9aCop8iTPqU4ujXQ3TrWkk8/uckFR3R73gs4MVLaywQBdt9UgYhzkWsEH1egW
	 R0H2Pg1eBTM+j04j40T9BlhYIgfWK6uGY0CW/AMPPSNFkW06s0YFyixQK2l7Q8NoVc
	 y0pUE57Z/Y4EmUE2r6jB5QZjHhjiHfB0HK3/D4a4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgHRORd (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgHROR0 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 18 Aug 2020 10:17:26 -0400
Received: from aquarius.haifa.ibm.com (nesher1.haifa.il.ibm.com [195.110.40.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DF68207FF;
        Tue, 18 Aug 2020 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597760245;
        bh=oysYEavAzZfVG+QM9pIpE7mplr7QxKfY0kI4p0rAXl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgM/1d+3Sc9LN+ygqstQ1ab9HA/+wldJhx7mVvIkIxNY+T+GPBUAaeuECAsnHiXtt
         zKL7FLfcc/vFMeAojwvfSCJ8XGggFsL1o3JSGfJkhMrPf1ch7uQEDGuNm7/IVfmZqO
         79fXt0odeNH7hRYEr822bqPTQJxIDaIr8fe5mE/c=
From:   Mike Rapoport <rppt@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christopher Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Idan Yaniv <idan.yaniv@ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Mike Rapoport <rppt@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>, Will Deacon <will@kernel.org>,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-riscv@lists.infradead.org, x86@kernel.org
Subject: [PATCH v4 6/6] mm: secretmem: add ability to reserve memory at boot
Date:   Tue, 18 Aug 2020 17:15:54 +0300
Message-Id: <20200818141554.13945-7-rppt@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818141554.13945-1-rppt@kernel.org>
References: <20200818141554.13945-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Taking pages out from the direct map and bringing them back may create
undesired fragmentation and usage of the smaller pages in the direct
mapping of the physical memory.

This can be avoided if a significantly large area of the physical memory
would be reserved for secretmem purposes at boot time.

Add ability to reserve physical memory for secretmem at boot time using
"secretmem" kernel parameter and then use that reserved memory as a global
pool for secret memory needs.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 mm/secretmem.c | 134 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 126 insertions(+), 8 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 333eb18fb483..54067ea62b2d 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/genalloc.h>
 #include <linux/syscalls.h>
+#include <linux/memblock.h>
 #include <linux/pseudo_fs.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
@@ -45,6 +46,39 @@ struct secretmem_ctx {
 	unsigned int mode;
 };
 
+struct secretmem_pool {
+	struct gen_pool *pool;
+	unsigned long reserved_size;
+	void *reserved;
+};
+
+static struct secretmem_pool secretmem_pool;
+
+static struct page *secretmem_alloc_huge_page(gfp_t gfp)
+{
+	struct gen_pool *pool = secretmem_pool.pool;
+	unsigned long addr = 0;
+	struct page *page = NULL;
+
+	if (pool) {
+		if (gen_pool_avail(pool) < PMD_SIZE)
+			return NULL;
+
+		addr = gen_pool_alloc(pool, PMD_SIZE);
+		if (!addr)
+			return NULL;
+
+		page = virt_to_page(addr);
+	} else {
+		page = alloc_pages(gfp, PMD_PAGE_ORDER);
+
+		if (page)
+			split_page(page, PMD_PAGE_ORDER);
+	}
+
+	return page;
+}
+
 static int secretmem_pool_increase(struct secretmem_ctx *ctx, gfp_t gfp)
 {
 	unsigned long nr_pages = (1 << PMD_PAGE_ORDER);
@@ -53,12 +87,11 @@ static int secretmem_pool_increase(struct secretmem_ctx *ctx, gfp_t gfp)
 	struct page *page;
 	int err;
 
-	page = alloc_pages(gfp, PMD_PAGE_ORDER);
+	page = secretmem_alloc_huge_page(gfp);
 	if (!page)
 		return -ENOMEM;
 
 	addr = (unsigned long)page_address(page);
-	split_page(page, PMD_PAGE_ORDER);
 
 	err = gen_pool_add(pool, addr, PMD_SIZE, NUMA_NO_NODE);
 	if (err) {
@@ -267,11 +300,13 @@ SYSCALL_DEFINE1(memfd_secret, unsigned long, flags)
 	return err;
 }
 
-static void secretmem_cleanup_chunk(struct gen_pool *pool,
-				    struct gen_pool_chunk *chunk, void *data)
+static void secretmem_recycle_range(unsigned long start, unsigned long end)
+{
+	gen_pool_free(secretmem_pool.pool, start, PMD_SIZE);
+}
+
+static void secretmem_release_range(unsigned long start, unsigned long end)
 {
-	unsigned long start = chunk->start_addr;
-	unsigned long end = chunk->end_addr;
 	unsigned long nr_pages, addr;
 
 	nr_pages = (end - start + 1) / PAGE_SIZE;
@@ -281,6 +316,18 @@ static void secretmem_cleanup_chunk(struct gen_pool *pool,
 		put_page(virt_to_page(addr));
 }
 
+static void secretmem_cleanup_chunk(struct gen_pool *pool,
+				    struct gen_pool_chunk *chunk, void *data)
+{
+	unsigned long start = chunk->start_addr;
+	unsigned long end = chunk->end_addr;
+
+	if (secretmem_pool.pool)
+		secretmem_recycle_range(start, end);
+	else
+		secretmem_release_range(start, end);
+}
+
 static void secretmem_cleanup_pool(struct secretmem_ctx *ctx)
 {
 	struct gen_pool *pool = ctx->pool;
@@ -320,14 +367,85 @@ static struct file_system_type secretmem_fs = {
 	.kill_sb	= kill_anon_super,
 };
 
+static int secretmem_reserved_mem_init(void)
+{
+	struct gen_pool *pool;
+	struct page *page;
+	void *addr;
+	int err;
+
+	if (!secretmem_pool.reserved)
+		return 0;
+
+	pool = gen_pool_create(PMD_SHIFT, NUMA_NO_NODE);
+	if (!pool)
+		return -ENOMEM;
+
+	err = gen_pool_add(pool, (unsigned long)secretmem_pool.reserved,
+			   secretmem_pool.reserved_size, NUMA_NO_NODE);
+	if (err)
+		goto err_destroy_pool;
+
+	for (addr = secretmem_pool.reserved;
+	     addr < secretmem_pool.reserved + secretmem_pool.reserved_size;
+	     addr += PAGE_SIZE) {
+		page = virt_to_page(addr);
+		__ClearPageReserved(page);
+		set_page_count(page, 1);
+	}
+
+	secretmem_pool.pool = pool;
+	page = virt_to_page(secretmem_pool.reserved);
+	__kernel_map_pages(page, secretmem_pool.reserved_size / PAGE_SIZE, 0);
+	return 0;
+
+err_destroy_pool:
+	gen_pool_destroy(pool);
+	return err;
+}
+
 static int secretmem_init(void)
 {
-	int ret = 0;
+	int ret;
+
+	ret = secretmem_reserved_mem_init();
+	if (ret)
+		return ret;
 
 	secretmem_mnt = kern_mount(&secretmem_fs);
-	if (IS_ERR(secretmem_mnt))
+	if (IS_ERR(secretmem_mnt)) {
+		gen_pool_destroy(secretmem_pool.pool);
 		ret = PTR_ERR(secretmem_mnt);
+	}
 
 	return ret;
 }
 fs_initcall(secretmem_init);
+
+static int __init secretmem_setup(char *str)
+{
+	phys_addr_t align = PMD_SIZE;
+	unsigned long reserved_size;
+	void *reserved;
+
+	reserved_size = memparse(str, NULL);
+	if (!reserved_size)
+		return 0;
+
+	if (reserved_size * 2 > PUD_SIZE)
+		align = PUD_SIZE;
+
+	reserved = memblock_alloc(reserved_size, align);
+	if (!reserved) {
+		pr_err("failed to reserve %lu bytes\n", secretmem_pool.reserved_size);
+		return 0;
+	}
+
+	secretmem_pool.reserved_size = reserved_size;
+	secretmem_pool.reserved = reserved;
+
+	pr_info("reserved %luM\n", reserved_size >> 20);
+
+	return 1;
+}
+__setup("secretmem=", secretmem_setup);
-- 
2.26.2

