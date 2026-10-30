Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394620;
	b=kUt5WUQb4JhCYamN8wP6GwZ7ka//3obPL0NHfluJWkSJquNaRsTOuk8qF4zwKgN8AxvE
	 2nJvyigckBNHA9Qbfe5jrSjcLTgmNAq3UUPxP6mDFmM1rhd4emoI8LsrSRA8NG7G1kL3A
	 Ujayq+5ivzyYxc/XO3ikKg1nYEo3kqvHQXpYkSI47r4pUKTyc5WbvwMFIZSt7UHiRT3Wk
	 RUckrxaqRnT2EeFZkyeDYzISH29/GZlhS49uFR2Q7qTmNiOZAZw7LJQktrh65ImzAlcTQ
	 BvOognxuqwXTGQbAJCq63HIYi7VyQIIlc326ejOsfz3DyF5y3rvZBAEgCb6kiSg9o1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NRj5hwEzENLjlsB+UAcfFJohIr0Hf4YgXfYZEvjse4o=;
	b=bNDCymSLmdpDqWxnPitVsensjuSgnpVokUymdkpZfXii9U9tgeUrhYS72eg7BD19nG5R
	 XiDnoVK5VdY69Ke4/rQ3nmQUuknABnZ0+ebibwkzybypS3No8fma+9mmBp00v2Fhuni4v
	 hsYI6PBZ2zSqe/Xq4+xCnyprf7OoCMO9j6QWqRAilcu3nsx3FC8FMyJl1Q9xLqdTMnSkC
	 0FkvmxB2vJkhAilVMbe31N2i+jWR2PckIGBpGQ36EXG0XtUey8G5DWWk272lgzMPn3tpw
	 2nqrQ+hDzE/n2gTv+8z6xOyUQRBByh+Q9lYNz8Za7/W+J49oZvTreIwKwyrr//ResMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arista.com;
	spf=pass smtp.mailfrom=arista.com;
	dkim=pass header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=Q+l1mbbi;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA69A60A262B
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 21:10:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA69A60A262B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=Q+l1mbbi
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3514b90bb89so2218560eec.1
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 14:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1793394618; x=1793999418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NRj5hwEzENLjlsB+UAcfFJohIr0Hf4YgXfYZEvjse4o=;
        b=Q+l1mbbiKUvjbillm6pdJDpPjF2pQbA9OXFE3js3iBgUUgRIvYtGZk1vlSB8K/HTYA
         JHLWZiJdKozGA+8AxwHbiJNr/oGfNBn1ferC3KPHky9ffn1z68fIGBbdcJkXju0iMcjW
         D7U+S4awiVjIJvkF7oc3ImP0tcsgng9AgW3ZnSKa67rHNurXCk1N9rZPBacfFZaYkbNf
         GLpXVaw0Vn7aHSe6c1RH7FMY2Y0M8a9KhDUI6N/CNshZuvHLimKPE9hD1zC08ZX9FBNm
         tiLFtax3PWuUY+9ZwdfpCHLjjYVGmkIWm3+1+49K8AAuIDQ6MaoqvIsBm3lhULlRz9Og
         7KMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394618; x=1793999418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NRj5hwEzENLjlsB+UAcfFJohIr0Hf4YgXfYZEvjse4o=;
        b=ZHGa4CsQsvipqJUy3bUY3ak3IefEAeXihKnZfCIkIwyJMFQhlLvpI2CFvbOf54j+Lc
         0WRAwMD6+misYkJkuohQpxN+7x3A8mt1U8AYLL9hg5CHATTeV7c5P3Pv57liZcZagI7s
         TXQAf9ZKNEwv56SN9RK84oWDZqlN/ppL3SEGnRtvfG9WFy1JOY9vA+FqT8RCC9wzYPkn
         AcsRTjYVgJN3n/7aNv6LER5yz4E9Pyct14Njtk5wa5M+BtUrr/kMsm56oS7iVSAnD1Lb
         zazSz0AXauaH8SRXTgJa0PtQDt0yiZVEk/zcw6vtFxJl9U0VfCNI/PpEXBX/xYikLvvg
         VoGw==
X-Forwarded-Encrypted: i=1; AKwUvBywYrvbO4tr3OxvWvIHLf9L++OSZAJvw+aCYytzwrk4YCMZN4QHzsPPmTnZEUs7RlXCyBS2YAHavWU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJNATMl5UxGM6SnkPNM6Og2t/h8crLbzM19gm3E3YspF7wnOH5p
	9O8A0hCkUdE37ZxzMxLraBZ9Ex3I32S1rCHs6AZuSdBArYIrDYj7if6IFIPIUzfVZg==
X-Gm-Gg: AYBFou3yh15J2S9Vtcf/NquE2KQcT0oQrqzZ1oGG9kyfexyNsfJXVeJSSnBPI9L+ZTc
	qsveRZqdD/kFak6qTWgwSQndx7j5sRwDwoM8r6XzI9ARGQdXLE8zyi7J4lKX1K4BfT7XPoyqD/F
	nWDhrwwd+2t/c03iJC2lvEe26O3VQuyJfXbur+8trWV41zJVyp3GkhIu0eNhNwt8xpms4wv89kA
	OFV+Ri7uy242WXxpTxrJNwdLC9bJfo1iaPDdael0MQVdzyTU3yIyqMGzUhAGs808QmoJHRX2ETd
	yjN52JOf+CfYbJ6yyJ9DsFbwQbCTTRmnAV+ZFs5xgZMaJiLRGvlTlGDh9DANKM+zYKMLibm15uI
	Fv5wQRmQhu9KuGRT++rJrGnzb0tntnwXeUkZQ9OM9K/NwDiV7xpovwGoL9AL1YJKoY99ys/60VW
	fazHnwz5llpAaT1G5OHx+jFyz6iHah+QQLOUbORjM4sVPAPVc1eixdFkO/A2qZP+T0Y3Fh1w4Xo
	j00jlFsq768tJkSTf9tYAJUBu7Hiui0dP/1oDstLRaVg8wbGBchCXyA73JMIfFvUYGoYWk1ANi4
	fjLcoHC0aGWnTEJ3hkwYVB02lW8+hE9HECTArDmV0Dbb6WBYpzCZdN7m68PHtdG58XfP1+4P6ta
	bQ/BvrievTQ3ssZEY3LCQS10=
X-Received: by 2002:a05:7022:2581:b0:1a8:7b58:6f1b with SMTP id a92af1059eb24-1ac5cfe587cmr5911022c88.19.1793394617878;
        Fri, 30 Oct 2026 14:10:17 -0700 (PDT)
Received: from dannyhu-upstreamLinux.sjc.aristanetworks.com ([74.123.28.18])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm9471777c88.21.2026.10.30.14.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 14:10:17 -0700 (PDT)
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
	Tianxing Zhang <zhangtianxing3@huawei.com>,
	Zheng Zengkai <zhengzengkai@huawei.com>,
	zhoushuiqing <zhoushuiqing2@huawei.com>,
	zhangguangzhi <zhangguangzhi3@huawei.com>,
	Danny Hu <dannyhu@arista.com>,
	Jason Yan <yanaijie@huawei.com>,
	silviu.vlasceanu@huawei.com,
	hpa@zytor.com,
	arnd@arndb.de,
	rob@landley.net,
	james.w.mcmechan@gmail.com,
	niveditas98@gmail.com,
	pierre@arista.com,
	julien@arista.com,
	kbharathi@arista.com,
	erosca@de.adit-jv.com,
	alexandr.lobakin@intel.com,
	jim_baxter@mentor.com,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bug-cpio@gnu.org
Subject: [PATCH v5 3/4] initramfs: read metadata from special file METADATA!!!
Date: Fri, 30 Oct 2026 14:09:42 -0700
Message-ID: <20261030210944.2143778-4-dannyhu@arista.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261030210944.2143778-1-dannyhu@arista.com>
References: <20261030210944.2143778-1-dannyhu@arista.com>
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

From: Roberto Sassu <roberto.sassu@huawei.com>

Instead of changing the CPIO format, metadata are parsed from regular files
with special name 'METADATA!!!'. This file immediately follows the file
metadata are added to.

This patch checks if the file being extracted has the special name and, if
yes, creates a buffer with the content of that file and calls
do_parse_metadata() to parse metadata from the buffer.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Tianxing Zhang <zhangtianxing3@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Signed-off-by: zhoushuiqing <zhoushuiqing2@huawei.com>
Signed-off-by: zhangguangzhi <zhangguangzhi3@huawei.com>
Signed-off-by: Danny Hu <dannyhu@arista.com>
---
v5 changes:
 - clean up metadata buffer when returning from unpack_to_rootfs()

 init/initramfs.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 36254dba7822..a1744cc9523c 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -265,8 +265,8 @@ static void __init read_into(char *buf, unsigned size, enum state next)
 	}
 }
 
-static __initdata char *header_buf, *symlink_buf, *name_buf;
-static __initdata char *metadata_buf;
+static __initdata char *header_buf, *symlink_buf, *name_buf, *previous_name_buf;
+static __initdata char *metadata_buf, *metadata_buf_ptr;
 
 static int __init do_start(void)
 {
@@ -454,6 +454,7 @@ static int __init __maybe_unused do_parse_metadata(char *pathname)
 
 static __initdata struct file *wfile;
 static __initdata loff_t wfile_pos;
+static __initdata int metadata;
 
 static int __init do_name(void)
 {
@@ -471,6 +472,10 @@ static int __init do_name(void)
 	if (strcmp(collected, "TRAILER!!!") == 0) {
 		free_hash();
 		return 0;
+	} else if (strcmp(collected, METADATA_FILENAME) == 0) {
+		metadata = 1;
+	} else {
+		memcpy(previous_name_buf, collected, strlen(collected) + 1);
 	}
 	clean_path(collected, mode);
 	if (S_ISREG(mode)) {
@@ -508,11 +513,47 @@ static int __init do_name(void)
 	return 0;
 }
 
+static int __init do_process_metadata(char *buf, int len, bool last)
+{
+	int ret = 0;
+
+	if (!metadata_buf) {
+		metadata_buf_ptr = metadata_buf = kmalloc(body_len, GFP_KERNEL);
+		if (!metadata_buf_ptr) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		metadata_len = body_len;
+	}
+
+	if (metadata_buf_ptr + len > metadata_buf + metadata_len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	memcpy(metadata_buf_ptr, buf, len);
+	metadata_buf_ptr += len;
+
+	if (last)
+		do_parse_metadata(previous_name_buf);
+out:
+	if (ret < 0 || last) {
+		kfree(metadata_buf);
+		metadata_buf = NULL;
+		metadata = 0;
+	}
+
+	return ret;
+}
+
 static int __init do_copy(void)
 {
 	if (byte_count >= body_len) {
 		if (xwrite(wfile, victim, body_len, &wfile_pos) != body_len)
 			error("write error");
+		if (metadata)
+			do_process_metadata(victim, body_len, true);
 
 		do_utime_path(&wfile->f_path, mtime);
 		fput(wfile);
@@ -524,6 +565,8 @@ static int __init do_copy(void)
 	} else {
 		if (xwrite(wfile, victim, byte_count, &wfile_pos) != byte_count)
 			error("write error");
+		if (metadata)
+			do_process_metadata(victim, byte_count, false);
 		body_len -= byte_count;
 		eat(byte_count);
 		return 1;
@@ -539,6 +582,7 @@ static int __init do_symlink(void)
 		return 1;
 	}
 	collected[N_ALIGN(name_len) + body_len] = '\0';
+	memcpy(previous_name_buf, collected, strlen(collected) + 1);
 	clean_path(collected, 0);
 	init_symlink(collected + N_ALIGN(name_len), collected);
 	init_chown(collected, uid, gid, AT_SYMLINK_NOFOLLOW);
@@ -614,6 +658,7 @@ char * __init unpack_to_rootfs(char *buf, unsigned long len)
 		char header[CPIO_HDRLEN];
 		char symlink[PATH_MAX + N_ALIGN(PATH_MAX) + 1];
 		char name[N_ALIGN(PATH_MAX)];
+		char prev_name[PATH_MAX + N_ALIGN(PATH_MAX) + 1];
 	} *bufs = kmalloc_obj(*bufs);
 
 	if (!bufs)
@@ -622,6 +667,7 @@ char * __init unpack_to_rootfs(char *buf, unsigned long len)
 	header_buf = bufs->header;
 	symlink_buf = bufs->symlink;
 	name_buf = bufs->name;
+	previous_name_buf = bufs->prev_name;
 
 	state = Start;
 	this_header = 0;
@@ -664,6 +710,9 @@ char * __init unpack_to_rootfs(char *buf, unsigned long len)
 	dir_utime();
 	/* free any hardlink state collected without optional TRAILER!!! */
 	free_hash();
+	kfree(metadata_buf);
+	metadata_buf = NULL;
+	metadata = 0;
 	kfree(bufs);
 	return message;
 }
-- 
2.51.0

