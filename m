Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902954E9C28
	for <linux-api@vger.kernel.org>; Fri,  9 Oct 2026 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791560370; cv=none; b=iBqnGQrpm/3magxEcfvhTY+4Nj2HM+UF+Peyz8H4w6xDEOP0SmHmSPvCJ6sGpySFSGZtAl96Q4eD7aa+hg+ggLzs0t6vFu1ErD3vKM1QbTEbQo2TLLfNxRItHS4AA8WMk7TvyISw6LeogMHtI0Eafbg1UTNJgR7UD614c29L+2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791560370; c=relaxed/simple;
	bh=+Rw07kfriWEyCGpVzJxK6mSgxAao1ypqtfUdivitgpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABr502cLojX9qfc8jtHHQeb8AwGCKmjnMCPLmHtF6a0pNIvDn/ObwqDR8gSI+MF1ImDtJOAikSqR/6UpFd+uNCpxDv359AHFOPtZUmh9ibBrFylNbyI0DlFLnaCUlOqyO/9Xn6IlejdCrqEWz46vX1eJ53RK1PY+bhSaue3UNwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YZPJFDXB; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZPJFDXB"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e2c837fa12so20646835ad.1
        for <linux-api@vger.kernel.org>; Fri, 09 Oct 2026 08:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791560368; x=1792165168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PkPwa+ResHmZ7LdsIwsHxXNe9JhyIG2QiRNQ9+4WsYI=;
        b=YZPJFDXBJhN9r7Gztqxrun5SPp3gutm/XTwS4a6fqz2Hvw8mfZc1msshKuE7TcfxMr
         Pa6tjSLYvKouIWUn4WTHt0Efjmtsp8lpvXAHl/KvFACdaKswrKM5nDYxciQA4ni2ykue
         5Gb2/1W/8k6LiuW6Sg/AmJvwzwrjzzRazja97aY06/h9JOTKvSyLUJJTkIM8Qixj6TqL
         ZqMCQfocCth6rRq6kuezcc05NR7Zapyhjwk0crenHOFvTvX7IiOsI1yQqSqUXE+je10a
         BUnkyDN/4QrETulYIALYgGPJUZA9GLBd94cZdQb1kT4CJIyGgzMLdeWcK6ZvFIBl3Z1J
         RLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791560368; x=1792165168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PkPwa+ResHmZ7LdsIwsHxXNe9JhyIG2QiRNQ9+4WsYI=;
        b=izkiuzv+nm05SxZ7hhKTbFUdFbjV+nroVMkyevCshgZeCmlmp2Raf9/bMKeoTYdoQY
         zEA8F7WQrfWgLuu9+MD8x7iUM+IdXVjWmAqLrjLJMeikJoigQyz8AdBnuDKCgGO41440
         IrXVEwbhX/bEPHn3LbfzBnat9oDpL4dSRNWQzUpnv+PzFR2jeyE06+ywrne95k9ijLCA
         dQN96Odk+RoJPw9tFyTfx6A5J3xkSuIyetecdbPFtRfUTiM38baCcELLJcRoqvqSsZhf
         0CsM04CsnNSB/fJQHiXCVck+OweGkuoUBNxaAm5Pvyryv+opYiGk45S3wAmWlCduIE6F
         gjpA==
X-Forwarded-Encrypted: i=1; AKwUvBzSSwPfhADZ2uQvThAtaIZE7X3C8LUohhIcXsneLK3JYIHKtLdRzyCGjPvwqXtRTGhm2ABYo7Jv59o=@vger.kernel.org
X-Gm-Message-State: AFq9FYI1Y9GNAeHSObOQTsW4VAg9zFDsZ45K6daDwpDKMCvGmoHLS8FT
	02w7uQyfFjL0OilaC0forqcxmEtKBtOcHMtWoP168HMrgkFkJDlO4sXKOQVwDuzQ+cQ=
X-Gm-Gg: AYBFou2WS/yvrA5dakMHGgUBjYLfbJtIcheQ7ewQ04b8ib9xNJg3BEAwjycjKqB9aWM
	jNXGu4XtkWnZKwr5PJeG4E1QKCCpun2bN2mltc3L4thM2ffPj3r9bZtr6WP7VNcxQ2kVrvYt2Nv
	HR0wtYK+dN8snlph1kkjBX/u5O31FLBGZw2bZ6MoWKKPjt/3ynbDoDfHCnefI2h/D1Q5vHyZxCp
	mH44tCRomgIvd023xI2p6ShbOYiIRwWQ9xRXPwTz5M4nQydugAda6ajNH4qY+biFhEpZM5oWQTT
	80U17gYlw7tPGochzsg3E+hxPNdpC39jY8joWdu8gQYxm+CsdPfHuppoTkQ7OHJiLYAwP8/KOKC
	EwqBUHPJwSKG/uUFbSvGvVjc/Z6dlcdzw36y4QAc8LJB9KD2vqFskJbWCO9xPwpKgkiP6S1zYN2
	Jc40cBbhN8yFj/zyfFWgS2emfRk5bHyAMaqVO/vZcWymu46R1XSDRCGtNATn+ibFCPYUN7xw==
X-Received: by 2002:a17:903:41c1:b0:2dd:c053:82f3 with SMTP id d9443c01a7336-2e842ce20a2mr18707215ad.42.1791560367626;
        Fri, 09 Oct 2026 08:39:27 -0700 (PDT)
Received: from mincom1 ([14.67.155.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421ae999sm11847705ad.31.2026.10.09.08.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:39:27 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] hwmon: Reject truncated attribute names
Date: Sat, 10 Oct 2026 00:38:43 +0900
Message-ID: <c9a2e5f5a8bf08545a999c6ab70aa058eae947dc.1791559095.git.hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791531025.git.hurryman2212@gmail.com>
References: <cover.1791531025.git.hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Large channel numbers can produce truncated or conflicting attribute
names. Return -EOVERFLOW if a generated name does not fit its buffer.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 drivers/hwmon/hwmon.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index bed16cfd4f1c..288f356980e4 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -553,8 +553,12 @@ static const struct attribute *hwmon_genattr(const void *drvdata,
 	if (type == hwmon_chip) {
 		name = template;
 	} else {
-		scnprintf(hattr->name, sizeof(hattr->name), template,
-			  index + hwmon_attr_base(type));
+		if (snprintf(hattr->name, sizeof(hattr->name), template,
+			     index + hwmon_attr_base(type)) >=
+		    sizeof(hattr->name)) {
+			kfree(hattr);
+			return ERR_PTR(-EOVERFLOW);
+		}
 		name = hattr->name;
 	}
 
