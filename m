Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6D3769EC
	for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 08:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376611; cv=none; b=rU19sXJRXwbD8qfEXq4H3585DVNBQOoCYVVHCx6vbrdPsvzcoVYVSdnfypuxleVFibzQ47K9HuARqi3IVypKCyZI60GQm4oMwlcGz6fQrXSpjq902hP+aY0RjrWqDKLSoJeMItZ1sWGxixb/qergiwebBEpljhScF+fr74QR7Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376611; c=relaxed/simple;
	bh=YVkMCLt5FJ+bDbSrJETzwIU6LK60EPUbwXQNXghAHuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZX8+IeNml0x3lmttrySvBeyV9egrEWPofOH/uqYhBi3MN2arsj6mD7vIv2urolAirqx91sBzU5cQvc7kiRSUDvXpTUtoY0X63ZnVg/3izqsY4pA9WgDe7p9obfmt80vjUkGhX+NbN/n0o9DvL3t0561T0reBYHsyUBhgaudjJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IEyFdrkY; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IEyFdrkY"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so19881205e9.1
        for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 01:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376608; x=1782981408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
        b=IEyFdrkY6ibOQ5SLodmI3KTVvtOX2lj01KUp1Css+wNtwgr7qysOfxlxKzWbfM/jYa
         uM4YaF6lbNSJDkV4jcTXrLJrWTa5q0hcoaYDgYHAYPUfCw42pN2U8FHvp2/NlD+3pDr9
         FYux8tfvG3jfuNHzKEyNpZnxJ89CrdPvj1c798+iSCw25OYjhURbBs9vRVJx+bfHrQ6q
         P8yZxlupCaIUxECLNrwDhhT5SiXuPFRWuCJRjjCy54fM6W1oeQCqOeO0/Ju9GoxN9ip/
         iYKZ1LrewZzIhH6CfiNhya8s8AIpmvJL7uDvjMHp7W7ezOsVOfinw8rm4lsisT0+lhcZ
         EpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376608; x=1782981408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
        b=dIMUg6yhXyekORRhLHGCDe/Uc5+uWKMG2l8e1kYdoJFos7e7TNaRO7wsGt8hcFwqpK
         91CCRzF7vzO9kFI/uxAlzNkbdZPAX93h7YDFXaEJ4vtnYpS2DcOXZbYime74PaPRBlXG
         YPJF9pmvPwfBIYbzAm9cu1/LTA53LD8yBd1hFEu8Tpu/ADKKTUCy9NWkRFAdNCnEEr7b
         zcLXrsD4ySef0wc6uwdHDfGWnOe33oxNFtFB0T2SIdDgU2rh3f+GTqe206MLK9qz2g/J
         lRsspJogpv+xWknRVo3PC0nfMbc5ZpG5wL2HRMb8mDhsFxyxYIen36df2tCpt1Vzm7Od
         HnhA==
X-Forwarded-Encrypted: i=1; AFNElJ9Edj/Z1pHscPrmdltjN1XYf2H4+5QQ6sUs3NnGN1ToAMkiPTo0m5nPTRGrKijwsCoMa3U+yDp/ZlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIhJO/1g2roQgSGECT2X8Fk2N7N8IupCgU99oT8gk3Offv61aR
	fu8rJWCHtzwZ1zlFRQmrIqd3FzRLvscGVaxjvzvrUQqlfbmocvJCyJN8
X-Gm-Gg: AfdE7clsJ5NSoIvwaEshSaqNvuhcenKLFAzUujoBQ+L9MLFDxPPS91KIDLLYQxYa7P6
	XjFqkjNQVfzDX1VNG9QITIYO1Qes++9OAgMMmAZjcOIeMPlJ73NoX9NSGq2bzJtNFPlOCI2GVIE
	bqiWo1HFk1XKIFsUE0Mkfn2pkPTyqO+/7jquD0ZAiJMColfJb+FZ3JvJBvEXbJEQranvJvmYaGq
	ina9TeYQrS+a4ryAVkEhZ78hOIfCEyyEXqjgfCRvZ02C25Cbd66I38VwPq9SkhulmQleyWMgIYM
	SzJ8qPcgkoxo7uBFASnq6YNUBVCovtis1Lul+eqc0xFoX7T5T0YuOFcQBlNY7RIoYwTqAA2rrmI
	CBlQQEcxEj2KSUAOp1Opy7lHdbtcPJZYPKQwB7TkQbETp9Qz/rwgarkqrgK1CKIdbqWkHDkKqGQ
	30O5BOrPIx
X-Received: by 2002:a05:600d:8489:10b0:490:a298:3859 with SMTP id 5b1f17b1804b1-49266892151mr13952905e9.24.1782376608352;
        Thu, 25 Jun 2026 01:36:48 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-492640362bcsm70832535e9.8.2026.06.25.01.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:36:47 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 5/7] vmsplice: make sure we don't wait after writing some data
Date: Thu, 25 Jun 2026 08:34:07 +0000
Message-ID: <20260625083409.3769242-6-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure we don't wait for space in pipe after writing some data.
This is needed for compatibility with previous version of vmsplice.
Found by LTP vmsplice01.
See comments in the code and links below for details.

Link: https://lore.kernel.org/all/20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner/
Link: https://lore.kernel.org/all/CAHk-=wgV-j-G3d+899Zm1pQ=NaJrddPz=GKcL5Yw5DTUM=GaUw@mail.gmail.com/
Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 77487b307..dbd0debc2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1221,6 +1221,8 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		unsigned long, vlen, unsigned int, flags)
 {
+	struct pipe_inode_info *pipe;
+
 	if (unlikely(flags & ~SPLICE_F_ALL))
 		return -EINVAL;
 
@@ -1229,11 +1231,44 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		return -EBADF;
 
 	/* We do vfs_writev/vfs_readv, so it is okay to pass "false" here */
-	if (!get_pipe_info(fd_file(f), /* for_splice = */ false))
+	pipe = get_pipe_info(fd_file(f), /* for_splice = */ false);
+
+	if (!pipe)
 		return -EBADF;
 
 	if (fd_file(f)->f_mode & FMODE_WRITE) {
-		ssize_t ret = vfs_writev(fd_file(f), vec, vlen, NULL, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+		/*
+		 * When writing to the pipe, previous implementation of vmsplice
+		 * first waited for space in the pipe to appear
+		 * (depending on whether SPLICE_F_NONBLOCK was passed),
+		 * then did unconditional non-blocking write to the pipe.
+		 *
+		 * This differs from what pwritev2 does.
+		 *
+		 * For compatibility we do the same thing previous
+		 * implementation did.
+		 *
+		 * We lock the pipe, do pipe_wait_for_space, then unlock
+		 * the pipe, and then do vfs_writev. vfs_writev internally
+		 * locks the pipe again. This may cause TOCTOU: when we
+		 * do vfs_writev, the pipe may become full again. So we
+		 * do a loop.
+		 */
+
+		bool non_block = (flags & SPLICE_F_NONBLOCK) || (fd_file(f)->f_flags & O_NONBLOCK);
+		ssize_t ret;
+
+		do {
+			pipe_lock(pipe);
+			ret = pipe_wait_for_space(pipe, non_block);
+			pipe_unlock(pipe);
+
+			if (ret < 0)
+				break;
+
+			ret = vfs_writev(fd_file(f), vec, vlen, NULL, RWF_NOWAIT);
+		} while (!non_block && ret == -EAGAIN);
+
 		if (ret > 0)
 			add_wchar(current, ret);
 		inc_syscw(current);
-- 
2.47.3

