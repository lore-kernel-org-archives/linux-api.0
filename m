Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742FF24E4C6
	for <linux-api@vger.kernel.org>; Sat,  6 Jun 2026 06:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780726312; cv=none; b=FbNSu16eKn2JHaP02rucD4ZdKEAdPJqlvP95nvRci+sZh4VkQyH/DVY7vDSHS2SBk5kKkSmW99rVxPtBEWIL45JFqTmqIzo/wLuiuu6zCgAkmIYaJgwmH+sLxtPHnMi1ZUFPtL73b5aahpFrI9BEwn44YAfB6qP3IZM2eDrlPTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780726312; c=relaxed/simple;
	bh=x+w9SGxZBWO4hPXg8E+A/q/4ScS0BqeDSCrwJNo6iBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOta53Q6+jwNduAT7ZQaUvjx7HYJwpQDkIOiemDv2l56DYa0TYbS8mBMzTHt1awwtkqDXJfH/QLkK2HqwQZ8tTXUM9pJCDPa0FtkIb6P3/JpuB1tWbc+4fu9N5yqkDj58a7oa6yAsqM75N2+RNujFrqRn02tUDmgpbrG3nmwkNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NjKXTOhZ; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NjKXTOhZ"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ef56d9b67so1989190f8f.2
        for <linux-api@vger.kernel.org>; Fri, 05 Jun 2026 23:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726309; x=1781331109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=NjKXTOhZ6oFtD6egk7Q8ZGBQebsZA/l29SSQKp5HIFtTtDs5m9pJncOdhT1E4OMNlw
         voEdgti52EWxYcP4vTsS4BbnzSSgKcN3+Sj8qb3PYtHNlqx0Yti9pz12uYadPiFktEvI
         GEY2VByqek/o37vSoIwXjHuNB2Wk+xq00+LtVXml4K2ZaB309p+/VTaXBq7SvGMQTLaS
         9dG79e/RcblaWFrhC1exZ24H/AznHI1yD5BpA6VnbtCSbx/10pau+uv5bTw4iUoWA6/Y
         MdH4ZC3Vk3LSX0FT0DfUFQvy7RPM7Jc3cMEtLJ/Y56H/K7XXdGGTNtMsrIvCtmE4Y+Hk
         LdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726309; x=1781331109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=Wv6m/+1zzEUY3WSKplsVjXRAKUmOMr5/U1lo+z5EvpUfJBtWL/VjZ3oM4tEleGcdwc
         Mxjv40vCtnLkJBFDJHWdiINHbX6GJbCLclwXvkSyKscBGb5lsV1DM9Rg7BJGccsbjEHC
         wRpi+DjScrN0yPhHpo78TEsE3g3pqUgluwtwF6nkWWMZC69pG9pAyLxMIhllUSYkehqC
         Y5dUgtVKMBpqSMBvlmK2WIDQUuCgyHBVl90fVuYt+y2cnqF1pMsj9T+Sq9xbohSUDZJY
         7tXySh3KNTTZIJmo8ChcJBAuydBcpWADMIzqylzSRa6QVfss9ely9+PwvyUFRxsLIzW1
         E8kQ==
X-Forwarded-Encrypted: i=1; AFNElJ/lA7i4pFwkPjDmY8S1bKV26HVEADX1KEffV1qeNRpAUsLRsYjpxfTyi4ItSfSlEeE/2A7tr0cLW+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFAoNOPdeHDRSHQfy2y06XT3u8TTjJ0E4og9e430OmaVL7v/8z
	Bgowxrw92L9pO6LZ/RvlkRhRShoekNWMXcvb8m4VTUm+jTOdoWqnPFzl
X-Gm-Gg: Acq92OEiQTEj8471JYgf4n4P8xhKI3iqCt3+vmOvFTYaidMk+URpAoN8fWF0ZGeUKTa
	jiz++1Wk+fZroou02YpddtzJE7rf+DlNlciinfUmwkn2YNjezE8Vrppr1wYcS8lfOQmy750RM3F
	6RdKioJrer/4AWwLTmgGS9QyzW26WY1t89d2qDGw2c7/fAEAIKoai5qp89rl4NtZqa6FZhP9Gs1
	W3Wop/Gyy0H43U3frHyLbGnX07Hydsu9KKSIOb7CqviK5E+HGpzAWpo+K/4gHjyp4jy0narYdPg
	ATu51m3GwRpWWrym1Y9ezCxM0g7p2bfVuaq2FxaACYDi2pGTslcsIzPdXz+dggPFCwimQej8rHI
	AgHFHiXZBJEx9IqUOnvuUsNUUoBrULLmwwAuuPqCo8KcdhcP4x1b9LdR0JQ3lroXvFymPdopOOi
	PZGCNbjLhtaduLSoci9utzMfKKv84vxJvdzknCNuI8
X-Received: by 2002:adf:e014:0:20b0:45e:f29d:d438 with SMTP id ffacd0b85a97d-46030618a38mr7876243f8f.28.1780726308885;
        Fri, 05 Jun 2026 23:11:48 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46028a6dce6sm24115947f8f.30.2026.06.05.23.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:11:48 -0700 (PDT)
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
	ltp@lists.linux.it,
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
	Steven Rostedt <rostedt@goodmis.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH 2/5] vmsplice: change argument type back to "int"
Date: Sat,  6 Jun 2026 06:10:28 +0000
Message-ID: <20260606061031.3744880-3-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
References: <20260606061031.3744880-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My previous vmsplice patchset changed vmsplice argument from
"int" to "unsigned long". This may cause problems, so let's
change it back.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c          | 2 +-
 include/linux/syscalls.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e224e7cb8..77487b307 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1218,7 +1218,7 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 /*
  * Legacy preadv2/pwritev2 wrapper.
  */
-SYSCALL_DEFINE4(vmsplice, unsigned long, fd, const struct iovec __user *, vec,
+SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		unsigned long, vlen, unsigned int, flags)
 {
 	if (unlikely(flags & ~SPLICE_F_ALL))
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a86a88207..46a3ec954 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -514,7 +514,7 @@ asmlinkage long sys_ppoll_time32(struct pollfd __user *, unsigned int,
 			  struct old_timespec32 __user *, const sigset_t __user *,
 			  size_t);
 asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
-asmlinkage long sys_vmsplice(unsigned long fd, const struct iovec __user *vec,
+asmlinkage long sys_vmsplice(int fd, const struct iovec __user *vec,
 			     unsigned long vlen, unsigned int flags);
 asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
 			   int fd_out, loff_t __user *off_out,
-- 
2.47.3

