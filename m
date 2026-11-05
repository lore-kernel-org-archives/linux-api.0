Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907477;
	b=rZRfRF3cW5GzfX5t9hIb/T1t7ssPQTaKyYDAJM4R1OB57udD2acuSloMUwDsadja3Xrd
	 SUU51hKA5WgSPdWO9iPcjJZvMoXQCOsIZ249m0xK9QxiJQp5lNIkV/FiPqjOQSNde+sdE
	 5mDBJQAtXo5ZV6ZBhktMT7F5tajrxyFiKI0TcK+rH5FsWJgPeO0haHkhA4Uf9DTUp1G5J
	 5flJWSt4b6BxL+9r/Zv/gOGE0DqB7TLGaR71V42LTLXYYiEuY9tI3+X3rmyHq8iuKnndL
	 4S47SwJVduv6l3InYbHiBVQwIXhm2e2mOcVnr/MDOCQAXWgA+QDhELYSgrowBox8vEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEs52XSVkXr3Lysumh8vBcPCuRt3C+96FDYzKDRWk9o=;
	b=eOF+6NBAw3w4LOSkP2n6k+bbA9Lu445BGUEOSXNiDdTXA7lxzVUdCaaThJIAki5Ta0m0
	 h19RswJZiTtfvh+1VVIjhp1Dy7n7zwobjyBpX4m7y+CZKUe9XmFD7k1VbrQlhCxzHB3E3
	 szQK1BD6G9e+8QTrZWRQP8u728fLC1dy9HIhiqt4kFgebJLC1sXg/n9QyTN2jyfoN9MLI
	 j8Pzmornw88Wr6imNMj/bmaR+Ui9Zu2S9HG0i6+LcJlUSdJMKsRurySY1wHal4Vl6oz8x
	 XQHxwa+QkIZYPUrXqlttMT2bkqffeyZBpMCTeNvr2yVL7pzId3vH/PsYjagyFN0ky8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arista.com;
	spf=pass smtp.mailfrom=arista.com;
	dkim=pass header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=CpWYY4HP;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7468D607B95E
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 19:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7468D607B95E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=CpWYY4HP
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36f6295304dso169460eec.1
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 11:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1793907476; x=1794512276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GEs52XSVkXr3Lysumh8vBcPCuRt3C+96FDYzKDRWk9o=;
        b=CpWYY4HPqsMqathLuCP0SqyPHsMFAQWoskfk2GdP07u48l12UmKTiwONJuvB++DOZo
         Yclhv2OYTvpyVQe0nGDznRS9Z3hWx2kbCBFvY0pqnRrXO41EfaKHYTGa75im9YoH0HyQ
         yVlSieODB043s7YTZG83QMLxA1SHJ8toDshd16zaROUJAf2wNKauWeStmi1bLrH6/8Tz
         mQQW4N4m8vwam53SdfBwr6BB3a+iuCtW3J6Db2OjYNgcUSfpF/y05AZgZRu+kEXd/N4u
         Ct4MdT86o/xNJxf/iCp+y8jz1OLKeZSYtEQMz8MNbuIitFs0Ewo+oz4HzT9k1iLJwTE9
         Ebzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907476; x=1794512276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GEs52XSVkXr3Lysumh8vBcPCuRt3C+96FDYzKDRWk9o=;
        b=e+9Z/6dxapYHufkLLJV694xc78wvoqB1APhkXLodFdxeQ/iJDT9bIjVoEK0Bd5XFvX
         Ww8ydERbbtI/9O1jSMFHrs7YqmnRL6sBYEjLGRiB1chKJt474wakq0857b/X+BA5VL7e
         uJoGNH3OSj+DP2UU334TTMr2a5C7Mw+Y47/Z9zOCTSzlGODb3y9OLuzyeI2m/iy5Z/CO
         oBueJguvMlPgX4+6V79/f1E9zUhXxVB8aNsybnTwoFRB5w140jfHK0Iugp5zRxpgJzek
         DjCFr/UKLJXQXcuqeIoAjXFG0bBi7uAnILojJhrg1GXypJw8oRaHNlXj8tqFTBNid0Av
         ZmtA==
X-Forwarded-Encrypted: i=1; AKwUvBxgvr3yrrwO2jGI8BsEwDKtlEzK1o7/aUGeK7vyjWnhmxFbKgftBlcaZb/ggPKzy+kAyK3xLawlMg4=@vger.kernel.org
X-Gm-Message-State: APuU4Z82VLl4gUUDkBnaegufZVfKj033Y0J8YhZKoO0OzIL/SZNDRTA1
	STCRWJ4Oz5pqGOortIZwKrLzC81noTsxQcRxIsI2LwBVusNO22bL1xcK0uIZ8K6Bvg==
X-Gm-Gg: AYBFou2cEpt2oxSQXcHT3vAUVmN/2J5F2nx2WnCwKDzoamB/GDOM26o60TFraqOUez/
	4XrkCWe6dec5r0Ipwugd59Qv8MBLNDdoWfbno523JXZLJX40OItMppX6xljIMWrV4xztl8LpL8J
	QW6ynDXls2lZZsHzNzKFcWG6sN1q+EELepAjklAJ2PYmJt7YTDqeTnqyroN/HuKjpSeOf2QqDzc
	5QEddjIx+Cjji3yC6w+qj80H6mxcWeV0NVTJCLj/unBoMF+TlpLKs7AjX/bkVnfRX6LfBmUSucP
	hFnc6GTNtinIKopgN+8hJ9ZZ5SYW+5hbNkEepoojyK95RPbG1zvYONuTLTo/sbSTT/pxHXrBY7a
	KRlpuiXoY2yKnYI9KvVCBkUIdhXFKanrf4zafbHVNX+aTQ+34FH6b0PHn9WlshyRZTtiKMm4Gn1
	m8l7kAynlU134/Ovov4kXoVB3Sd+HJoMuFKXGMjCq3RhkVvOqWm37EzuXv+qo2ZgAfk6Uby1htV
	hkDv9yHrelm9mxDxIJw9DGxLYp9pi5k+IbAQlyutTz2cPvupA/lPDpxMbPAHq7xnsoOHRyZzPlO
	nFjKLyf3mLNAyBzrdQ6UUCdPVlKhpttQ6E/PzfwXDSpM5kcS2JFEwzKQatyCZqvAHD6yqeuVIZa
	hn6arw7y6s6ikW1kASmwEtyw=
X-Received: by 2002:a05:7300:3e97:b0:36d:9900:bb92 with SMTP id 5a478bee46e88-36f75254a98mr150454eec.10.1793907475358;
        Thu, 05 Nov 2026 11:37:55 -0800 (PST)
Received: from dannyhu-upstreamLinux.sjc.aristanetworks.com ([74.123.28.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72ec8a02sm326134eec.11.2026.11.05.11.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:37:54 -0800 (PST)
From: Danny Hu <dannyhu@arista.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Victor Kamensky <kamensky@cisco.com>,
	Taras Kondratiuk <takondra@cisco.com>,
	Zheng Zengkai <zhengzengkai@huawei.com>,
	zhangguangzhi <zhangguangzhi3@huawei.com>,
	Danny Hu <dannyhu@arista.com>,
	Jason Yan <yanaijie@huawei.com>,
	silviu.vlasceanu@huawei.com,
	hpa@zytor.com,
	arnd@arndb.de,
	james.w.mcmechan@gmail.com,
	niveditas98@gmail.com,
	pierre@arista.com,
	julien@arista.com,
	kbharathi@arista.com,
	alexandr.lobakin@intel.com,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bug-cpio@gnu.org
Subject: [PATCH v6 1/4] ima: skip algorithm availability check until initramfs unpacking is finished
Date: Thu,  5 Nov 2026 11:37:40 -0800
Message-ID: <20261105193743.2654656-2-dannyhu@arista.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105193743.2654656-1-dannyhu@arista.com>
References: <20261105193743.2654656-1-dannyhu@arista.com>
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

With CONFIG_IMA_APPRAISE=y, restoring xattrs during initramfs unpacking
can deadlock the kernel if the xattr being restored is signed with a hash
that the kernel does not already have available. This occurs when the
ima_inode_setxattr() hook calls crypto_has_alg(). crypto_has_alg() may
synchronously request a module leading to a circular dependency where the
userspace helper waits for initramfs unpacking to complete while initramfs
unpacking waits for the userspace helper.

Guard this crypto availability check in validate_hash_algo() until
initramfs unpacking is complete. This prevents the kernel from requesting
a module during unpacking and allows security.ima xattrs to be restored
even if the hash algorithm is unavailable in the running kernel.
Essentially, this flag distinguishes restoration of existing metadata
during initial population from setting/changing an xattr during runtime.

A benefit of this approach is that once unpacking is complete, all
subsequent xattr updates go through the same codepath as before which
preserves the existing behavior during normal userspace operation.

Signed-off-by: Danny Hu <dannyhu@arista.com>
---
 security/integrity/ima/ima_appraise.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 63b0cb957c65..1403f5653973 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -20,6 +20,14 @@
 
 #include "ima.h"
 
+static bool ima_initramfs_populated __ro_after_init =
+	!IS_ENABLED(CONFIG_BLK_DEV_INITRD);
+
+static void ima_notify_initramfs_populated(void)
+{
+	ima_initramfs_populated = true;
+}
+
 #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
 static char *ima_appraise_cmdline_default __initdata;
 core_param(ima_appraise, ima_appraise_cmdline_default, charp, 0);
@@ -738,6 +746,22 @@ static int validate_hash_algo(struct dentry *dentry,
 		if (likely(xattr_hash_algo == ima_hash_algo))
 			return 0;
 
+		/*
+		 * IMA validates the crypto algorithm whenever the security.ima
+		 * xattr is set. Restoring xattrs during initramfs unpacking
+		 * can call crypto_has_alg() before unpacking has completed.
+		 *
+		 * If the algo is unavailable, crypto_has_alg() may
+		 * synchronously request a module. The userspace helper waits
+		 * for initramfs unpacking to finish and creates a circular
+		 * dependency.
+		 *
+		 * Skip the algorithm availability check until initramfs is
+		 * populated to avoid this deadlock.
+		 */
+		if (!ima_initramfs_populated)
+			return 0;
+
 		/* allow any xattr using an algorithm built in the kernel */
 		if (crypto_has_alg(hash_algo_name[xattr_hash_algo], 0, 0))
 			return 0;
@@ -829,6 +853,7 @@ static struct security_hook_list ima_appraise_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(inode_set_acl, ima_inode_set_acl),
 	LSM_HOOK_INIT(inode_removexattr, ima_inode_removexattr),
 	LSM_HOOK_INIT(inode_remove_acl, ima_inode_remove_acl),
+	LSM_HOOK_INIT(initramfs_populated, ima_notify_initramfs_populated),
 };
 
 void __init init_ima_appraise_lsm(const struct lsm_id *lsmid)
-- 
2.51.0

