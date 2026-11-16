Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794800001;
	b=i1F9b9fdp7aAmkQL/kLhTqHzOphYsCmEIaM3LBqHfLoqvK2jnMpMhrEb8L28Ph8wCwz1
	 cRZzei3jPS/9Iax3m6mQP2X24R9t6LV0VQDdN2cTnNH2sgSnyEp3wrjiX2jaBpWBzluVO
	 CUfvpCHTNxP+jYsPGVuboay1m5UAGteYhnHJfZD9HZDX0WdDgm+lCGIhrQFmtPrbuizf1
	 1+9elveOf65lwNXR4OGAJPDEPcEd4q1qOwuB0KTWllOBPXriwf/Wp/+U6YDwT9H6q8rbg
	 87bqRa4JsQfpRwVPHaR4iI65vcIzvWZEGYigCijHbjpfPfyaI6wI+0kDv3HmcJpySJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794800001;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	bh=nlTtnR+wCpHl9FSCHLEGv7xGmXmxOT2nZcPf4/lr2y4=;
	b=cEkkeG0Efu6NUQ1hqu/3y/4SVxB2I1AfKUJJ+gxLRli0io1r1Rxs4O+tK0JD90Gkz/90
	 nYbCVqStJST8URSw9CtDUrUvmLi/gs8moYTCQMhpbRDomIEFg8EjRHO7ldLC9tKReG1Uy
	 /ZXj+pVe+yeKJMuwH+pKXvqig9+XM1cMlrds+CAnUy1zKQrz51+cI/WvqfDdAWgXrdP1Q
	 jcoVLGpA/lrlDl2EOp0spZS519AwTLfD/cir+MClhuMS9YG7AbailGrPJT87rXzwepfj2
	 a3joamIt3xuDZ9tMjSV5yU08rsW/gB00yVqgEWIjcy8A/qsfIsXEW6091uPgiILQ6Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hgaUM0ak;
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E1B606A31C
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 03:33:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7E1B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hgaUM0ak
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9495f083657so281965185a.0
        for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 19:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794799999; x=1795404799; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nlTtnR+wCpHl9FSCHLEGv7xGmXmxOT2nZcPf4/lr2y4=;
        b=hgaUM0akhfIblJZRHS1um/ResgJtAxAoSHYbf4DebsNzZSgSEOTK2PUUFJYr46ycbO
         SvWxtAghL3ugAZ9pai5SU6+wNpu+O9I3gK3N1i5RZMuiWf+59EDoF67X+yQGTmWaDo6c
         8V4HYkdesumvwLnYssRCdcJB25yQNTfhnma7NQNRpRzsoCt4MLeF7Ia7ZMEC5YYn8fUm
         UoEHspP2YPaP2rFpG2KWdLg/f2d2n41NxSjOdw9txt8/iddqYt9CxJQhpzGFzhZE+RSM
         o6aXlJjWDz/vL1egZ6Y7tUMkgakD0MUgVXKktRggv0cn7BZ88ASPRxmwXt/9bEeu2vQW
         qQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794799999; x=1795404799;
        h=content-type:content-transfer-encoding:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nlTtnR+wCpHl9FSCHLEGv7xGmXmxOT2nZcPf4/lr2y4=;
        b=A06TIEjwU8gU+Zbw/Ir7ycSIBWQXoeRdTjbSkhGOlA3jTEZQxFzwXbugoD9TGrhYvn
         /BDSIvJxaP6hBDCJ6HAn8kNIPaBn9C2YvvdLz9QiDwZ7mwtaW2VgBNOx9Lt9EpOcAWnp
         pZ0GvM1DypSFi+frUAG/2XnFKvap2ehDgS9JhrnWDFpe9vTpr1M5+Mih7cDzLvsmhfnT
         ITLgkWYAg0gtqPGEwvAxz2E5ikMV6caYoLn8P6Ty3sG/qVc5MPJX327hEvbJ/0Svx6Hu
         6a1KmIkFJOrgj7PNVlrkapd2hcMdELrkqr2uMxwXfynD8LPq2E3qO/dvbJnL8YVl+dsr
         d/Cw==
X-Forwarded-Encrypted: i=1; AL+hErEQLHfKK25B3JO5DmD6ao72VHzrVSakjMorSTgOzGljdt0B4awMWlWVrlXlsMNqIvKvk44E5mVK0DY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9bmsxn1uhTz3RgeygB55I5hBtlZzSmE4PIuBidx9KB+9X1iMAq
	n7RLBpP4slZpUEiFY0LTmjVDzRbjwuEnDf3GUT45DZZOeepOJ8Ft7Qvt
X-Gm-Gg: AYBFou1mpYA7cgW0H/zMdSApDLOVo4g+0PEHo4E/jdkfg9M02wPDEwA8iaj4YSIlYuw
	zZFj0BBNaXAIjH4/B4CaDWTKr3kRQ+jPxxCoXF09OJkqHLtAGk3YOI1i6rpBbmx7PQHquTI2b8O
	Dfy07iGb+ZUaQAcQGgYwlTYPvvTps3GB4WmyqyMupJhq3Qgo1Bha5XctNZrTFAnLjTClXoS9z5R
	/mK5EbzU/pwYOnLuPzpt5KqGR5EQmjv3Egnc7mMRgkQiVreGFQ8COZmsX2Kby/4mepE7XLoChDU
	SRJX441awXEI9XKLY1hJUi6y17/ANL4XkfWiYTDjTEPEAiWAMJ4PZsEd53q6Pm57Im21nZDCV7H
	gf8tYcZaf4uKryY5ob/+tGhDgaL+UHnGRNRcvZPS9HzgleZAfFxVm9VsTxYcUxftQaJIrs9Lz0F
	A6MBBq13jmPuwQml3V0HSRo/S5tLdL5Y6/9fpgdwj7mRAuibeZ7m1b1UBKFD97oAZn4V9G8/HGw
	/ABpSpjYXl/moyGGB7H3blRZr52Kjdz5BogBY8JRp45jykDWHkoFVxBU2M+7KNuo9B/BzwwR+PR
	6upyktA/kTjR0sSkV2qShiwHn2iiaSLjsqbh3VvpbUlOCsX75vXRCiRZBws=
X-Received: by 2002:a05:620a:40d2:b0:949:76ed:591f with SMTP id af79cd13be357-94976ed5e0emr393702685a.8.1794799999296;
        Sun, 15 Nov 2026 19:33:19 -0800 (PST)
Received: from daniel-desktop3.localnet ([204.48.77.170])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c836f62sm753411885a.23.2026.11.15.19.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 19:33:18 -0800 (PST)
From: Daniel Tang <danielzgtg.opensource@gmail.com>
To: linux-man@vger.kernel.org,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Alejandro Colomar <alx.manpages@gmail.com>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-api@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] mount_setattr.2: Fix nonexistent perf_setattr
Date: Sun, 15 Nov 2026 22:33:16 -0500
Message-ID: <6099049.DvuYhMxLoT@daniel-desktop3>
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
 man2/mount_setattr.2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man2/mount_setattr.2 b/man2/mount_setattr.2
index 77233f589..5f26119cc 100644
--- a/man2/mount_setattr.2
+++ b/man2/mount_setattr.2
@@ -786,7 +786,7 @@ acting as an implicit version number.
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



