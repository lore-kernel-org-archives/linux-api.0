Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BDC33DEF7
	for <linux-api@vger.kernel.org>; Sat, 28 Mar 2026 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774718681; cv=none; b=LQiiKJhtJfIKaeSipezkmVNH0jWpOzv6gNNz0MZbWjkJawIgbG2P9jwOTZi2WuDFMuswnDaNRt4pq/c/xVUw0WFzHmyGxHSkUVfSmSWI50FzdDf7wyVlYhw2Uj2aR0ZKRBO/IIWMb0ISsd6c6TqDsEJFHnVfgO8tr50wh/kFoEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774718681; c=relaxed/simple;
	bh=EKC+gjybz5QCo3/A2SoLkAdJ9dHzP8glwvLLU31BmCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbZUoO+XTI2AeRtYfdsQ4iz1n1o3NE7mqcrMu3lruIDldoYo8rr/qjlTTXc8uY3LtLsZsf/v6A6VHzSf5uILpTyH7g1nlWs+oulRZPkKNMqG5+AG88hJPJgMqMGeoLRuXhhIMXt/2NhkBAiz6FzxMtgIuIlBIL7wF1F2u0cLNGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sy39ev+Y; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sy39ev+Y"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35a1cc6e478so1872861a91.0
        for <linux-api@vger.kernel.org>; Sat, 28 Mar 2026 10:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774718679; x=1775323479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cE+gTqS6Acm3OjdFoCwcpAog50aFpqNiNU85af164dY=;
        b=Sy39ev+YkaB+KPsi1XAs4pyTqpWDmmoH72QwZXEGTQq1QlboeGJWmYKxoqtg6gn41k
         YmK6kJvrsEL9BzLhgPWUUm0/ZZdVfkAD98gMPFCDaf4retCZzzOdlIb71Atq12Jx9fTd
         jzDDdFCg6vTtCgauFJqsGyCF2zJUPWbmn4yjivFB43fgCk/BWGtOOgQuyhKh2+2oaOqf
         mTzlitOp5a9pqYZu7J9vBOwBmFVVQA0TIuKNqe3Iv4K6/8bmw5B1L7xJLj/4MZOsqWhA
         W1KjDh8CKcEgp5Cryqh+moIxfcFxsnCUQZys9Z8rb6YLeH39Jee1LOeRM05Yk0LqhHTI
         GSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774718679; x=1775323479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cE+gTqS6Acm3OjdFoCwcpAog50aFpqNiNU85af164dY=;
        b=LnASGzUqYScW/SXv+lBX5QKgi8BJCCdLzLJ4KPU1fdcOEYA0fXuktSfiiFJoX/1eff
         a07bVZD+MaVK5hGFu0kFolGqy6n1fMf7UbLErvbG9b7nyyM2jY8DGmwi63Zo9UaAsZK8
         VFqyl199PFNYy81TMC68HnxpncmmvzkHsHFdfR4Epz7ECluuCEcRMgBWW4eEncyaTJwk
         iPZzURAbjrMCSF8hJnlvE8StW1MpyQsmluEuPfFrXDKkzI1J4tupozFEaq4m0jhL1I+g
         X5l/AsxohqqmmZNKWsI5blc2Fy9DT8GrK2HxLOddBF78/vUyy0EP+ui1BWfmtCUoNNJz
         lPpg==
X-Forwarded-Encrypted: i=1; AJvYcCUh4nEE00ixxAvZba0VhcOwBVpLY6D/sL3mSe3VvjwldrbjgUZYljFr3rgCwMUEoQiMvtB2DG8/NVc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRyuQ5eHaNkXbLZZrpFcErehi+EfVPA/7ZHkfDCAQk6wiVOXtl
	JPXujwnGedxH36xp+g/BKMUuRGRytaIUzpY9YdOJd3viRdi5oJPHR7CL
X-Gm-Gg: ATEYQzz39w7wQzK6JUxvB12kwH92vR2F/UwcUK0+GTwStP18CvYFq7SalAPR0AZ1yGA
	X5W80iSbK8jmcdN8jXFtyipyoU0Eq0qNM/MR7laswRxZJjSxpXbpb6fugzKFN9JbVSobItpsiqC
	u/D+vnxo+uYhlQ23c4ugTAT1+YaZ8AJCNG6vG5D214Rute1ErRz5u1I5lETKo6B+878x5KmKFAO
	qkn2MJEyZ2ZiOuxZm278bsqoXTOd3fAB0wWIBGYJbmd8cb7NIi7vouWCJRbHEjfOQmMgDHs9eXx
	5Rz2U1Hdx6CPAWesv5pDdYOAFDfc+6aLIMB5M6HaEzVfLQ5qwcxSwpuKjol3tYFsIg1ScnWTYX1
	xFh/EhmoFoFf9FPjmYi6IspaZe1Tt8ypIKD0l8Om5/aSdqbwogquecd8PNeNSI8cJPS4J0trWRP
	IIhl/YntuQDKr1naK/fsHwExCwPvV53f7/g5hdKbG+XIsN4XH3AkRv10A=
X-Received: by 2002:a17:90a:da8d:b0:356:22ef:57ba with SMTP id 98e67ed59e1d1-35c2ff1be2cmr6736609a91.7.1774718678998;
        Sat, 28 Mar 2026 10:24:38 -0700 (PDT)
Received: from toolbx ([103.103.35.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22a5570esm10513773a91.3.2026.03.28.10.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 10:24:38 -0700 (PDT)
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	jlayton@kernel.org,
	chuck.lever@oracle.com,
	alex.aring@gmail.com,
	arnd@arndb.de,
	adilger@dilger.ca,
	mjguzik@gmail.com,
	smfrench@gmail.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	tsbogend@alpha.franken.de,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	davem@davemloft.net,
	andreas@gaisler.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	slava@dubeyko.com,
	agruenba@redhat.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	shuah@kernel.org,
	miklos@szeredi.hu,
	hansg@kernel.org
Subject: [PATCH v6 4/4] mips/fcntl.h: convert O_* flag macros from hex to octal
Date: Sat, 28 Mar 2026 23:22:25 +0600
Message-ID: <20260328172314.45807-5-dorjoychy111@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328172314.45807-1-dorjoychy111@gmail.com>
References: <20260328172314.45807-1-dorjoychy111@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the convention in include/uapi/asm-generic/fcntl.h and other
architecture specific arch/*/include/uapi/asm/fcntl.h files.

Signed-off-by: Dorjoy Chowdhury <dorjoychy111@gmail.com>
---
 arch/mips/include/uapi/asm/fcntl.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/mips/include/uapi/asm/fcntl.h b/arch/mips/include/uapi/asm/fcntl.h
index 0369a38e3d4f..6aa3f49df17e 100644
--- a/arch/mips/include/uapi/asm/fcntl.h
+++ b/arch/mips/include/uapi/asm/fcntl.h
@@ -11,15 +11,15 @@
 
 #include <asm/sgidefs.h>
 
-#define O_APPEND	0x0008
-#define O_DSYNC		0x0010	/* used to be O_SYNC, see below */
-#define O_NONBLOCK	0x0080
-#define O_CREAT		0x0100	/* not fcntl */
-#define O_TRUNC		0x0200	/* not fcntl */
-#define O_EXCL		0x0400	/* not fcntl */
-#define O_NOCTTY	0x0800	/* not fcntl */
-#define FASYNC		0x1000	/* fcntl, for BSD compatibility */
-#define O_LARGEFILE	0x2000	/* allow large file opens */
+#define O_APPEND	0000010
+#define O_DSYNC		0000020	/* used to be O_SYNC, see below */
+#define O_NONBLOCK	0000200
+#define O_CREAT		0000400	/* not fcntl */
+#define O_TRUNC		0001000	/* not fcntl */
+#define O_EXCL		0002000	/* not fcntl */
+#define O_NOCTTY	0004000	/* not fcntl */
+#define FASYNC		0010000	/* fcntl, for BSD compatibility */
+#define O_LARGEFILE	0020000	/* allow large file opens */
 /*
  * Before Linux 2.6.33 only O_DSYNC semantics were implemented, but using
  * the O_SYNC flag.  We continue to use the existing numerical value
@@ -33,9 +33,9 @@
  *
  * Note: __O_SYNC must never be used directly.
  */
-#define __O_SYNC	0x4000
+#define __O_SYNC	0040000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
-#define O_DIRECT	0x8000	/* direct disk access hint */
+#define O_DIRECT	0100000	/* direct disk access hint */
 
 #define F_GETLK		14
 #define F_SETLK		6
-- 
2.53.0

