Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACCB455627
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383511; cv=none; b=uip4t9NowRSMezJlmTaZshp20uFLiLBNBq9FIZl6gfN5a94GqLBTXHhxQpyO0W9QKRum70guNA+PKzFYFlGtCW7/t6qdBFj4cJd3TOu8+fEV2wUvuFPJVD3AhwbmSbZCv54ciHmkzprN7BMsEkRVyvxpbJPjygeWCtUTUi7RuRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383511; c=relaxed/simple;
	bh=7n2GUVavWCaznIULC4koTaKML5uMo1SBp+OgkDs0sgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlHE8eVxg+HPEeyJs5clkPBNbwjbMvGvkOCyGmqt+24hi9ZIg3lTcVw6ElQEoNrVo1BCOIe3qDmEXx/g+yUuJakRuYfaNFd3c7rxiXAYN++uzKXnUWIRxcrMUV7wxd46dd2RxL/NFH7DvmC33ZLxw6xyMPxYT0uN0MgXv7viD1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1e03e8004so423415e9.3
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383505; x=1792988305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P8yTvohyfHN+LGgMhB7OAI4MKDO7ZPXP+V+3d2M470U=;
        b=dlcoyWhSVuac/OUVW+RsTG79l4jNtNQcDBgBvZ42qc/JWEocYk/fKfE1zLxtoW7pbn
         N+2Xj1eFsK/DJI6xUxYXq4UVIBfJXnU/ensckIKuHrIsxmYNmuIp5mcWtullfM/6FTDn
         xYAnjS3p5v4NlOTj3mHI3DKeP3Ak/OKF2KKBvugQzzm8ZNiLZcS6cgpCEvYm3sAX+OxO
         rINBz4AKM2w7at02JAcBkgluBibUhNOa52QBKRjlpASCSs6ob/VA6DAZLqjYx1HlKnyv
         bhaIQdA6TgEGzZZVNqBD6CYRyeceWXE0sdDIx87S5Vg69I5T7thqV3A6pQ3t6tImG1Wq
         4yZg==
X-Forwarded-Encrypted: i=1; AKwUvBzqTBAA7QnZ6jtZlG6yDb68YokKHuF/71TWNqSdvSAUnGgrsraJ3aUbaCrP7JTbhmqU2j8e+CDqGxE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLlflCJJm8mM2ft+BtuLKFh6e8bQBpxGshxdBT1wDK6k344visF
	rb5L+UMhOCdX46O6iFQgEFf1nASd2pLXx62VOd3JvjbGWqtvcB+v5zmT
X-Gm-Gg: AYBFou2fYUr5T6cz8MJ9LbIzUzOPGvUDFIy7xubYjMGHO9o+9E7KjTBvhBiOk7f5vU1
	XCjnLotooKDa48dorTPc0J4cDFsBfVhmoGCTHw5jWUAqHD6tXRPrcRBcVE/0l4N+gZYRMG9MvFY
	6VWMmffx4mtHuogHeUfjJ7dsnEqeo7oUrynujI+VszDf6kbRLCtcz//11qMu4NH2FqB2ZUBGi2b
	LZoOJZ9mVuO2p1+7AnhT2q6ORNB7lxqylHeOR0lSOj/wh5Z0+tgYrCCt8iX9evkj0pTYaGRA3zP
	XHoWzrrBuSMYCW6CBV7ccy+ewOnJF4j2J0WoML2ATkAKh5Bvh16UNhEYPh4tQv1CyBIysb2NSvp
	yt06MOrrHBdBCmV3KSRJrve/+UCHAeDUJ52GYgzDtuONiYutd45Po9aCUoI5I3J0jmIgQuR48cn
	7jt2B5qr3O5mzSaUyaggo0oFKeASfCyzk7qi43Qnx3GKqRXLrbMFxILUjN3zlx2kKbfE7eS/Ec/
	mlMfpj8im75DNhYwda0nYJmJCXbC2uIchD0
X-Received: by 2002:a05:600c:4ecc:b0:4a1:e015:6441 with SMTP id 5b1f17b1804b1-4a1e0156660mr91288055e9.0.1792383505145;
        Sun, 18 Oct 2026 21:18:25 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:18:23 -0700 (PDT)
From: Aurelien DESBRIERES <aurelien@hackers.camp>
To: Aurelien DESBRIERES <aurelien@hackers.camp>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	aurelien.desbrieres@gmail.com,
	linux-api@vger.kernel.org
Subject: [RFC PATCH 18/18] MAINTAINERS: add beamfs
Date: Mon, 19 Oct 2026 06:17:28 +0200
Message-ID: <20261019041728.327785-19-aurelien@hackers.camp>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261019041728.327785-1-aurelien@hackers.camp>
References: <20261019041728.327785-1-aurelien@hackers.camp>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an entry for beamfs and its documentation.

Assisted-by: LLM
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 62744835f86f..e5b95458da43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3082,6 +3082,15 @@ F:	drivers/usb/host/ohci-nxp.c
 F:	drivers/watchdog/pnx4008_wdt.c
 N:	lpc32xx
 
+BEAMFS FILE SYSTEM
+M:	Aurelien DESBRIERES <aurelien@hackers.camp>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+W:	https://github.com/roastercode/beamfs
+F:	Documentation/ABI/testing/sysfs-fs-beamfs
+F:	Documentation/filesystems/beamfs.rst
+F:	fs/beamfs/
+
 LPC32XX DMAMUX SUPPORT
 M:	J.M.B. Downing <jonathan.downing@nautel.com>
 M:	Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
-- 
2.55.0

