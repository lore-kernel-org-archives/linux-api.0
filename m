Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874673;
	b=ZedEftcMWMGFIleMcQ+sNX+JWJicEqzgnMK4Ar7cB1knFuCIbFNoKBv0JPIzlA7aXMrG
	 zomuLEPc4bja4QhY0QCkjMXJ0lYvOkGfwwy8HHlvTTiJrPLcSVRlC+uXhbNDkQeTevowM
	 hJv1JNHVvc65BRD4JDHcIw/YYVXf3h4ZAqHLLFJe6MSYzPHB4ltK0340MeBGHIbYff4W3
	 1B/1b1aoBJcNolezII/8wplEAzC2tCE86Z9zD2I+WnG7cz5Ky0J77oTf4YWYiygkH4xGY
	 fplorx9ZaFNvsvsXB1jxGPnTJjRqz3RZVAPoHxfxfZZAnn+TdEJoV7xetX82sRJYusw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874673;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=g1CqHinjbY2OgjrRQj70R8H/Be4OoPMLQb2dQpJZInM=;
	b=jht7AC2xFIRRM2PT3Z2ilq8A9cQMpehlmdchdGQQcMjdxlEZ57dC92f68DaCtO31V55S
	 kd2TaKBTAYWdlg7gV3J9h7uRHBAW3UoBNHmCp4hG8p37AWyzWuMR+9rsaYBLia71fXxyl
	 wPtRoSdBeZoLOo52W3qTgs2a5x1WZ5uxwynnb88lboWwz8vxKjapd9TIwpklw7ugk5Xdx
	 t8uPqmU9YfX8H9DDrCAbzj+/S+WJqy/WN/m3awBx33H4x3I3bVWtlo1lxGbGj1ui7JpLl
	 wcmrUpqmz3iFY1qmNatvXw9QWG0xnxvx8ZfzVvYc715+dcDkSDidhlrMvG2sYroVAog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wiup1+eY;
	arc=none smtp.remote-ip=209.85.217.41
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5CE606A887
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 00:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF5CE606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wiup1+eY
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-7d2d95c5d81so259131137.0
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 16:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794874671; x=1795479471; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g1CqHinjbY2OgjrRQj70R8H/Be4OoPMLQb2dQpJZInM=;
        b=wiup1+eYOz2l3MPJFqbC2wWZVp7n9BZT7aJO+IKN0DSmQLsuWzJH2RJVc5Kblj+Pkx
         I2Wtall3JpLxHg1fEoXnXo1+85nJ5O7mP435yfASIJsWSaoQjNwEGb6AyT2vAAytemJJ
         WZI1cwFuTlBRTWuCY4ED/Rt6jbEhvGhNszXnx6gz/ymNQFEZ880Bby6NrcCNeU+xcT9B
         NyNFratNa0H1yQs3em3My5L1e4/tGZKaeSUX7GghX6EfoA7qqGpPf8iTFTxOy3XeyaeV
         62v30fIoCiRJXjYUo0kxV6GHs4Eb8l7C8ofZ1YUXJ0aFPf/mKXMdzICjdJ3l91+42QY2
         2xug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794874671; x=1795479471;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g1CqHinjbY2OgjrRQj70R8H/Be4OoPMLQb2dQpJZInM=;
        b=D6w1Tp1CfhQolZB/jlwS2k+fQWEh3H8CIznXnNMpBZqsylU3JrBtg1PcNAA4ldNIS8
         5Yig92hZ67OvVjnYLuzQbZ4aaiD94KsGEnzIA3eJbHdP2d6SLJ584kWI0oDWUaYhyuFm
         gay3N15SViqXzvgg5ETGLG1MZ+niEeDMPKJtdJ5b5dFSOMd/S9yfos0CV8EKsexKGjS3
         L592NgUgk2Y75EXzpR6pMB8WG12GZJ746yJV2IGzbBmeqqhrKe8vA4UxQPycp8+D55ym
         myuc2L43YUsfuxR7aU4KYHIDBSSDgX0FiUlnqHPzQHma6fgcUAD0DocJpdlUv0ZDIBWR
         kHCA==
X-Forwarded-Encrypted: i=1; AL+hErELl0BAkonIoo+2fBE4t6hX4Es5T7YzyP16keoUUSApPrkwFCQ5e/J6pP4st21Xnwqv0uV0/8CWsrU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+SxDVxxOsDR0NAU5yAGehz6GF9PTmvXbR8Q7PN/IPMG6H7LMun
	wXdiRfQ8M1KkinQ8Gj5WWvUctyd1GVlWAgd6A7cUNsb9UMlvco4Hf3p8
X-Gm-Gg: AYBFou311qQFOg1fD48T52i8yigM010W9m38vbke80ohKtGQmqeW2NdbO041nudQ5nH
	Q+B3Ev58J6Dll2/SM5xhj/C8uX3KktDfVHee1pbu8IA9AW/2n6gLSvEx603yhNDbO29OGq4ib/Z
	mMkFSTkcisqvdgkDNBw2CxX2CApWeTlCiuXdGcga7HERYI9kG6nZ8APH9jQSZGj2h2Q/TtK/WC3
	NzeZjYVhVklb4sv7+GAMo+pdWZYtixMBdiSqf6ooDjIZzJ0hP3bv74xMzYjAXHx1ecExOi2pRfN
	Ngn2dHDOjhY7kiDRfZ9e8o16shYW4Ky2NaEpG4ZRpuNKIHXyz0QgcdwLERxiKLEQdH+5gdhO6st
	Y4ItR7RS3J9WdagIIEJKKkPcjiE+byfr1Q/vkCFrM14f07vS3Sj+oBcnq6NhfynNFqORZnFiaUx
	4gp7BZF8QvVV07rNvZTOOnd/AWSOfvKvIDSPKNYw/lDCWkL3sp8G9V195LQtpqZjTR6S9M+2CTr
	mKtiZK2ywfLSDPBWox59oT/iBASYyfjy0dI5DlU6ehH1SgRt+4wX33MAvOIRJk9CT6aHiAeZu9v
	OSudU3K70uslovNBzla5cgkiu6DtNpctS7DhWue25MQAPreGOiEuVFiwlls=
X-Received: by 2002:a05:6102:54a8:b0:7cc:905a:331a with SMTP id ada2fe7eead31-7d69f73327amr262988137.14.1794874670820;
        Mon, 16 Nov 2026 16:17:50 -0800 (PST)
Received: from daniel-desktop3.localnet ([204.48.79.161])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d69e0859ebsm1155725137.10.2026.11.16.16.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 16:17:50 -0800 (PST)
From: Daniel Tang <danielzgtg.opensource@gmail.com>
To: Alejandro Colomar <alx+linux-man@kernel.org>, linux-man@vger.kernel.org,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Christoph Hellwig <hch@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] mount_setattr.2: Fix nonexistent perf_setattr
Date: Mon, 16 Nov 2026 19:17:48 -0500
Message-ID: <6091006.DvuYhMxLoT@daniel-desktop3>
In-Reply-To: <avuYP6-OQJMhLqCn@devuan>
References: <6099049.DvuYhMxLoT@daniel-desktop3> <avuYP6-OQJMhLqCn@devuan>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

The problematic reference had been copied from openat2.2, where it was
fixed in bbed82c0693a ("openat2.2: tfix: fix minor reference typo"). I
performed the same fix for mount_setattr.2.

Fixes: f3a5ba3f0151 ("mount_setattr.2: New manual page documenting the mount_setattr() system call")
Link: https://lore.kernel.org/linux-man/20200929223509.11783-2-cyphar@cyphar.com/
Link: https://lore.kernel.org/linux-man/20191003145542.17490-1-cyphar@cyphar.com/
Link: https://lore.kernel.org/linux-man/20210730094121.3252024-1-brauner@kernel.org/
Signed-off-by: Daniel Tang <danielzgtg.opensource@gmail.com>
---
 man/man2/mount_setattr.2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man2/mount_setattr.2 b/man/man2/mount_setattr.2
index 0f4b619d8..bb8da7ca4 100644
--- a/man/man2/mount_setattr.2
+++ b/man/man2/mount_setattr.2
@@ -846,7 +846,7 @@ acting as an implicit version number.
 (Because new extension fields will always
 be appended, the structure size will always increase.)
 This extensibility design is very similar to other system calls such as
-.BR perf_setattr (2),
+.BR sched_setattr (2),
 .BR perf_event_open (2),
 .BR clone3 (2)
 and
-- 
2.53.0



