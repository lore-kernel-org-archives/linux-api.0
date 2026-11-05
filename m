Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907480;
	b=TuamNxMG/okMqX+aqoqdUa7yYc74jDkU1uJvjMttoYyqr/RwovFXZSW2Ho/ijLyOIC9h
	 cJw2wEGgvCmFo8Hm8Lyas6ynL4DN8gTwzKmnx5SKak+FP96ouX3RXEmh41hxRCPrRSX+W
	 aE5+o3J4UK+EtzHSdCS/KyohcDcOVeTzShlWiAOUZ7Wk05rWWFEj7Y/5pRjjEXAeXZrFY
	 PxkwQlqmjhjcXTMj7K1CTlgm53AgL47/i0Xmc+OSuqLssu+FNnYWR81NFjiwzFuB8dQvP
	 X2D6WCKpRJe6LJpf+PYqpvFDTQ8jvESaYasyOTxruvTld7Wtc+kAKh8eNT8T1WSlkvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ij0g0OsXKPamM88HAz3Lefa+vRljQ+YHmBrQJBa3tGU=;
	b=rUUprBlfCRG+Cek6z9Txud0E0fB48yeLMXKCQJpUXHNZh0zXE3eUQvy+H1eVOCHuNZ6h
	 +OoIFIlJzJ+VYsy1Xe7tbK+DG7vNoqHf5fEtazyUWR7mFucQCg82MzbZ2Ej8kP5EVdxsD
	 0oCcpy+zZC3lHLC0VTrwM/n6rmj4VFj15u9z4ze6xp3iAZvIFqPhMxreMpgnmjaVCUTxR
	 vQe/ONZOTIg6WrZW5hBtG8sIr/DvrpTEB4IyHvKQWTHgIiJjuE3W0JPB0QbXoTTiSw+H7
	 WdnecTepom3quli1eLMyGljRc1apuapjSuM3Vh8ZId0R0cQs9ZDJMxXt5nOEurcx74Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arista.com;
	spf=pass smtp.mailfrom=arista.com;
	dkim=pass header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b="U6nh/ArJ";
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8908060A2604
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 19:37:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8908060A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=U6nh/ArJ
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-36a18fc7a38so9562eec.1
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 11:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1793907479; x=1794512279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ij0g0OsXKPamM88HAz3Lefa+vRljQ+YHmBrQJBa3tGU=;
        b=U6nh/ArJsGmiH+qqcKQih8Mqh4TvgZ90R4kDoGQxu+P1s69CrKUnv9GlDc/DaO/BDg
         u/woqO/1TVKF45z9hQKyC+68pdGGgvoeNOCHokzk1PxnkX2DWA66g2K/cXAPFv/aD7Yi
         zoyU1y3R2CaGZIG9DzxfkVmDPMi8YPKpURB5ucW8myb4iofpPRjO/z6Z1ckqirqp2k7L
         7AfGCykfjmKcMcSv0EfpakF5yj53FyzvMOBPGOV+OCfZELijjzk8uGDk5gjXak3YxEnT
         /Bd451Q5bOzhWnhMG9tvvDCcENHYeFq///X4qVjMloZHheBXd7PODrk6ljW5JACwPTye
         lKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907479; x=1794512279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ij0g0OsXKPamM88HAz3Lefa+vRljQ+YHmBrQJBa3tGU=;
        b=dXFh2CU5mv+4HDYpys191QaFJWsU4D62M+Rfl7dw0rjFLbp/w5Pqm0/XJ1jUQ3O4+t
         8CrfOgQGYeN5UGJGxUwMJxE020f4fys06CVi/qLIglcedqRvoahPqRthi9qqVplxMjkV
         cQz0j4HyduYfYIlKQ0sv1F6dF3EhyqdJZfnPcq4lqRMhyH7WoD4Eu7phdK22pfGngh+h
         UrBJFqW6OfK16+heX8vjwIpTPB6CJ04sobGMCVKBOwNk8MI8gwFWnbBvcfvFeWdeVaYh
         JN926nU6Z3TiIKVfKICszcY+E5wpbZHkYlbbgaAxomPrn4kceVsfugc9x3DVjgMORtcP
         jLjQ==
X-Forwarded-Encrypted: i=1; AKwUvBwq08Whm5JttWA53vUKFez52llphn8SaMKj0v/PxRUfYoq2KD8q/VqfdgWZeIfLZSsO2F0anMRkIZA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8kNlALDv+DsSCy7B86GWOv+q8CIWA/lbOtYlfPHmmxWwLV3KsE
	NldJRv7TU5qMZabmp+N0DFGL5hSgCNOg+Hb72ejxxCeJJbz9SP5h30KeTZVsL8iBBg==
X-Gm-Gg: AYBFou2JPaMS191ddjoxo3oqp9EQgzBZ8LuDtpL+carsvWhEPj43cNPUP46zqZgqqh5
	Zb9btIhKEvF/9VuSX1epNGoWmYYn6vPBnIzau+hPB2jG5ur7IeMd4uUFLPDgMObwCnPfUZW7l4B
	gvIvbBB3PV7Zi7ji5L+4EKOaQEts9WyXdi+qBJLXufFJufB10eH1MuxFS6kHNfxFFw+i/b1ZHWG
	JMP+CshbJwnDR+fjxgCeyDo351Pe+peFN5kSwnveiIzp5/tVPdzZcm4VTVo224ajbO6bLsdeh73
	afw/kL0CDkeH++5lZs9lYjCrVtJJsJvgK5Nka+Fr5jzNYT+OI85FnCl+yeLma8eED8TjSVnc+MZ
	lN5SLUBX1G4I2v4133E+L/FMXh6iXJ1BkhZd72cjAimDkVhALJWPsV7LgqFmH7KhRyMN1KAIyfL
	2CEsi4CqeZYocoSuGDBbIA9kilf88aw5vlloAOb7vJ+R9fpKWd3tPicZOddOQ92XRCOLLkPjQE3
	f2g7p5m5cdhA86UQ8FuWgXxpLtxbel6FqOPfMFzAGDL0uOIE7Y+YqNYodifBlT2GvmfZ23NMvTK
	9Az7cdftRS5ikh3WN52nty4NUteNdNEqq6A08Q6Q68wq7O55080zL7uUnbACXrNV7bLhBoJ+goJ
	8czf6VZdeCRiwO77LQ/RxC8w=
X-Received: by 2002:a05:7300:10d:b0:36c:c434:b6b5 with SMTP id 5a478bee46e88-36f76621095mr172222eec.17.1793907478524;
        Thu, 05 Nov 2026 11:37:58 -0800 (PST)
Received: from dannyhu-upstreamLinux.sjc.aristanetworks.com ([74.123.28.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72ec8a02sm326134eec.11.2026.11.05.11.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:37:58 -0800 (PST)
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
Subject: [PATCH v6 3/4] initramfs: read metadata from special file METADATA!!!
Date: Thu,  5 Nov 2026 11:37:42 -0800
Message-ID: <20261105193743.2654656-4-dannyhu@arista.com>
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

From: Roberto Sassu <roberto.sassu@huawei.com>

Instead of changing the CPIO format, metadata are parsed from regular files
with special name 'METADATA!!!'. This file immediately follows the file
metadata are added to.

This patch checks if the file being extracted has the special name and, if
yes, creates a buffer with the content of that file and transitions
to a new dedicated CollectMetadata state to buffer the metadata contents
in memory without creating a file in the rootfs.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Tianxing Zhang <zhangtianxing3@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Signed-off-by: zhoushuiqing <zhoushuiqing2@huawei.com>
Signed-off-by: zhangguangzhi <zhangguangzhi3@huawei.com>
Signed-off-by: Danny Hu <dannyhu@arista.com>
---
v6 changes:
 - Introduce a dedicated CollectMetadata state to collect METADATA!!! entries
   in memory. This state replaces the metadata flag and eliminates the need to
   reset it on failure paths. Since metadata is collected purely in memory, the
   entry is no longer extracted as a regular file to the root of the archive.
   This also has the benefit of separating metadata collection from do_copy.
 - Validate the checksum before setting the xattr with do_parse_metadata
 - Improve bookkeeping of previous_name_buf by setting it only after the target
   object is created. Clear the buffer on skipped or failed entries to prevent
   setting metadata on the wrong target. Indicate that previous_name_buf is
   invalid/not set by having the first byte be the NUL character
 - Remove "Reviewed-by: Jason Yan <yanaijie@huawei.com>" because patch has
   implementation has significantly changed in the v6 revision

v5 changes:
 - clean up metadata buffer when returning from unpack_to_rootfs()

 init/initramfs.c | 103 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 90 insertions(+), 13 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index d206624d1160..a17c26fde5f5 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -34,6 +34,17 @@
 static __initdata bool csum_present;
 static __initdata u32 io_csum;
 
+static void __init update_csum(const unsigned char *buf, size_t len)
+{
+	size_t i;
+
+	if (!csum_present)
+		return;
+
+	for (i = 0; i < len; i++)
+		io_csum += buf[i];
+}
+
 static ssize_t __init xwrite(struct file *file, const unsigned char *p,
 		size_t count, loff_t *pos)
 {
@@ -50,12 +61,7 @@ static ssize_t __init xwrite(struct file *file, const unsigned char *p,
 		} else if (rv == 0)
 			break;
 
-		if (csum_present) {
-			ssize_t i;
-
-			for (i = 0; i < rv; i++)
-				io_csum += p[i];
-		}
+		update_csum(p, rv);
 
 		p += rv;
 		out += rv;
@@ -233,6 +239,7 @@ static __initdata enum state {
 	SkipIt,
 	GotName,
 	CopyFile,
+	CollectMetadata,
 	GotSymlink,
 	Reset
 } state, next_state;
@@ -266,7 +273,7 @@ static void __init read_into(char *buf, unsigned size, enum state next)
 	}
 }
 
-static __initdata char *header_buf, *symlink_buf, *name_buf;
+static __initdata char *header_buf, *symlink_buf, *name_buf, *previous_name_buf;
 static __initdata char *metadata_buf;
 
 static int __init do_start(void)
@@ -308,10 +315,10 @@ static int __init do_header(void)
 	next_header = (next_header + 3) & ~3;
 	state = SkipIt;
 	if (name_len <= 0 || name_len > PATH_MAX)
-		return 0;
+		goto skip;
 	if (S_ISLNK(mode)) {
 		if (body_len > PATH_MAX)
-			return 0;
+			goto skip;
 		collect = collected = symlink_buf;
 		remains = N_ALIGN(name_len) + body_len;
 		next_state = GotSymlink;
@@ -320,6 +327,11 @@ static int __init do_header(void)
 	}
 	if (S_ISREG(mode) || !body_len)
 		read_into(name_buf, N_ALIGN(name_len), GotName);
+	else
+		goto skip;
+	return 0;
+skip:
+	previous_name_buf[0] = '\0';
 	return 0;
 }
 
@@ -471,6 +483,8 @@ static __initdata loff_t wfile_pos;
 
 static int __init do_name(void)
 {
+	bool target_ready = false;
+
 	state = SkipIt;
 	next_state = Reset;
 
@@ -482,6 +496,19 @@ static int __init do_name(void)
 		return 1;
 	}
 
+	if (S_ISREG(mode) && strcmp(collected, METADATA_FILENAME) == 0) {
+		metadata_len = body_len;
+		if (metadata_len)
+			metadata_buf = kmalloc(metadata_len, GFP_KERNEL);
+		else
+			metadata_buf = NULL;
+		io_csum = 0;
+		state = CollectMetadata;
+		return 0;
+	}
+
+	/* Clear metadata target only after checking entry is not metadata */
+	previous_name_buf[0] = '\0';
 	if (strcmp(collected, "TRAILER!!!") == 0) {
 		free_hash();
 		return 0;
@@ -504,24 +531,65 @@ static int __init do_name(void)
 			if (body_len)
 				vfs_truncate(&wfile->f_path, body_len);
 			state = CopyFile;
+			target_ready = true;
 		}
 	} else if (S_ISDIR(mode)) {
-		init_mkdir(collected, mode);
+		int ret = init_mkdir(collected, mode);
+
+		target_ready = !ret || ret == -EEXIST;
 		init_chown(collected, uid, gid, 0);
 		init_chmod(collected, mode);
 		dir_add(collected, name_len, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
-		if (maybe_link() == 0) {
-			init_mknod(collected, mode, rdev);
+		int ml = maybe_link();
+
+		if (ml == 0) {
+			int ret = init_mknod(collected, mode, rdev);
+
+			target_ready = !ret || ret == -EEXIST;
 			init_chown(collected, uid, gid, 0);
 			init_chmod(collected, mode);
 			do_utime(collected, mtime);
+		} else if (ml == 1) {
+			target_ready = true;
 		}
 	}
+	if (target_ready)
+		memcpy(previous_name_buf, collected, strlen(collected) + 1);
 	return 0;
 }
 
+static void __init do_process_metadata(const char *buf, size_t len)
+{
+	/* Still checksum the body if allocation failed. */
+	update_csum((const unsigned char *)buf, len);
+	if (metadata_buf)
+		memcpy(metadata_buf + (metadata_len - body_len), buf, len);
+}
+
+static int __init do_collect_metadata(void)
+{
+	if (byte_count >= body_len) {
+		do_process_metadata(victim, body_len);
+		if (csum_present && io_csum != hdr_csum)
+			error("bad data checksum");
+		else if (metadata_buf && previous_name_buf[0])
+			do_parse_metadata(previous_name_buf);
+		kfree(metadata_buf);
+		metadata_buf = NULL;
+		metadata_len = 0;
+		eat(body_len);
+		state = SkipIt;
+		return 0;
+	}
+
+	do_process_metadata(victim, byte_count);
+	body_len -= byte_count;
+	eat(byte_count);
+	return 1;
+}
+
 static int __init do_copy(void)
 {
 	if (byte_count >= body_len) {
@@ -546,6 +614,7 @@ static int __init do_copy(void)
 
 static int __init do_symlink(void)
 {
+	previous_name_buf[0] = '\0';
 	if (collected[name_len - 1] != '\0') {
 		pr_err("initramfs symlink without nulterm: %.*s\n",
 		       (int)name_len, collected);
@@ -554,7 +623,8 @@ static int __init do_symlink(void)
 	}
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
-	init_symlink(collected + N_ALIGN(name_len), collected);
+	if (!init_symlink(collected + N_ALIGN(name_len), collected))
+		memcpy(previous_name_buf, collected, strlen(collected) + 1);
 	init_chown(collected, uid, gid, AT_SYMLINK_NOFOLLOW);
 	do_utime(collected, mtime);
 	state = SkipIt;
@@ -569,6 +639,7 @@ static __initdata int (*actions[])(void) = {
 	[SkipIt]	= do_skip,
 	[GotName]	= do_name,
 	[CopyFile]	= do_copy,
+	[CollectMetadata] = do_collect_metadata,
 	[GotSymlink]	= do_symlink,
 	[Reset]		= do_reset,
 };
@@ -628,6 +699,7 @@ char * __init unpack_to_rootfs(char *buf, unsigned long len)
 		char header[CPIO_HDRLEN];
 		char symlink[PATH_MAX + N_ALIGN(PATH_MAX) + 1];
 		char name[N_ALIGN(PATH_MAX)];
+		char prev_name[PATH_MAX + N_ALIGN(PATH_MAX) + 1];
 	} *bufs = kmalloc_obj(*bufs);
 
 	if (!bufs)
@@ -636,6 +708,8 @@ char * __init unpack_to_rootfs(char *buf, unsigned long len)
 	header_buf = bufs->header;
 	symlink_buf = bufs->symlink;
 	name_buf = bufs->name;
+	previous_name_buf = bufs->prev_name;
+	previous_name_buf[0] = '\0';
 
 	state = Start;
 	this_header = 0;
@@ -678,6 +752,9 @@ char * __init unpack_to_rootfs(char *buf, unsigned long len)
 	dir_utime();
 	/* free any hardlink state collected without optional TRAILER!!! */
 	free_hash();
+	kfree(metadata_buf);
+	metadata_buf = NULL;
+	metadata_len = 0;
 	kfree(bufs);
 	return message;
 }
-- 
2.51.0

