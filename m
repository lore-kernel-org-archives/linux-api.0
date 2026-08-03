Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F6E3B42D1
	for <linux-api@vger.kernel.org>; Mon,  3 Aug 2026 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785791246; cv=none; b=qIIcimxGwCg1aTRcGFP+M2mHQeoC8Jzh1dBrhhHtZLnP+ZPd/oKugXV0LWcPBh9kkYW1M1bk42gwEPA/18LOw4HG3Cm9WdALLBgXC+SrEgsHVq3Vv3aLMI/SZ7TjxjyXV1dMsW5x4yYt8BOSbzf6xGG/WOmTMJu1I3rCncmhxak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785791246; c=relaxed/simple;
	bh=nthUiIShsevE0eWa2hPRlXX6lkplZuzzgbo2dNWmXpw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jGVruIlTh/zpzH/p+VO+Js2HAGJEFjk0vp0za30Pns9dlopDSp/Yq0czVPOuuChaihhr8Isns3MlHjNJZZuFn1FDDMI5cfrToUpT5g11neMuspxSRd3yOVX6Eb4SvPvRHnyXaPNjWdTzo4lY+IhiVdic6noMxlAdkwhJhUECmSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9llnKlB; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9llnKlB"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cc73e322dbso37875455ad.1
        for <linux-api@vger.kernel.org>; Mon, 03 Aug 2026 14:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785791245; x=1786396045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qKfhfD+X3yrM3Hm1dz4XJjX8IqpqqbygeYd6dnInQMQ=;
        b=a9llnKlBqJr1zPkc2WBeGCvdfg+B8L43wnRMu3utIaHTVCrXqqskFnYGawa1aPBnS2
         t6No6jKaLKVSbiQPITk6MAhQFbak+HrQ1PeWGf0hyvlt/fytUyzHaOWbv6IU+CnR0jEY
         gezWp3C1Ydap345zbcNGT+stQtQ3UYcA+706+ganScVTDd2TnCoedZKanM8ExN7MEXew
         3nUXDDMKy60dsV9rQUEuLorz+Q5vnx/ETDpdfLBaZsdory1xbCZR2WFqFqEvCiTY/4kh
         BVt9nPuU0CCTgJWRTtmkWAu4VQcREFcBJLzGkY4WKODidqaELtpjlQwtu3bCOfTM87LV
         GDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785791245; x=1786396045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qKfhfD+X3yrM3Hm1dz4XJjX8IqpqqbygeYd6dnInQMQ=;
        b=fyeupgWquVujyT9AvldR7gwLD+4Qxw7Zzdskt7KGcKA9LkrYdQh956d+J++XRJTO28
         N//3rCB25939DvQ/S1zKZe679764G4gfUdT4ii2Yt7MLbEfbRfACIHNj3EPuNk+KJjVM
         FdBb2aDoRt47hrrJm893W+BCo2LgPn9/bpoWqjzLQP0WcRKuQ73Jx4BWz+kejj0r/xO0
         ixHhisnt1rXwItzYqsIE6PJuWsGGNvNNbJwcYUZVZ9OZFCwTr0jnNpjyKa5jWs5UQdWU
         SI2N4STIrA3QLCTnI28YddIbWNwUHAoDYTWPofmo7HI9xaSGzVdfswSPPhrXEJi5wWps
         fYZA==
X-Forwarded-Encrypted: i=1; AHgh+RpB7xxmbZHTjAy9aUX18u2ujGEV0Lbq15VgYygW8Rhk6tmjOtayRE/99DHDnbAvRbEF6BQ1z5Ra0FI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoEfgw6oglkcXRODL6yP0Aaqb7u8+DjkcvnvL5L6ml8CHvHMX5
	Gw7JKa9smoFcWDLblXuFmYNynk0PUqRKqGLYvu46mD4A5HgFpgoqbV4E
X-Gm-Gg: AR+sD123aUbOfW44liPn11vwJPWUhf3JZYxeCE8F/wqKy2+b3Y4wKolgmJB9CFELFdn
	3nuSmqahRtcr5LZNhUZaCgpGWowIgmaMiUX6rfPll4ZR3Xio1lgfW4R5NqUF2hdGy/Q6T6/OWA7
	HZsgiZlYWs8xp5Z8N2xMmXKBNUbjzjYPj3z9FPfNbTH47MtQ2ZCLADCoF/FOH2h/jBJmggCSiPn
	LCmPXbOupjwz1tZW2hfDrc6ZhBtCPaawemND9VW9FVSkvs6SIUWd7QpAsuTadq/s/ec6K+GeUzx
	OBTJ2EkVbqBpkC2YzXv+HBJhK4/E4PA+oZaGpiKpkfJM9Y1I02vn3KuABVdH1AeH7Qc4V9oJebt
	x/bI2clPZzJkpY+1AKGp/NSAO7h+ZoEhppWsvltVk9L2kr6OQE0Pxq6dWKz+JxTHloZRO7Avdir
	1rA+lt50CltTH/J775QnFPIRup3GJtkhUcTYT6CLYgkMXLxvxJrXdZKA8dO0ofVRW814OeaE2sN
	w7MWGor+44anqhGANjws2Hp5ypJydygAxWXjO9DTw==
X-Received: by 2002:a05:6a21:7a82:b0:3c0:9c19:65a4 with SMTP id adf61e73a8af0-3c92a992be6mr11926671637.76.1785791244783;
        Mon, 03 Aug 2026 14:07:24 -0700 (PDT)
Received: from lappy (108-228-232-20.lightspeed.sndgca.sbcglobal.net. [108.228.232.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e06f88fsm40203442eec.20.2026.08.03.14.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 14:07:24 -0700 (PDT)
From: "Derek J. Clark" <derekjohn.clark@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Hans de Goede <hansg@kernel.org>,
	"Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
	"Derek J . Clark" <derekjohn.clark@gmail.com>,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH] Documentation: sysfs-class-power: Update Long_Life description
Date: Mon,  3 Aug 2026 14:07:20 -0700
Message-ID: <20260803210720.23844-1-derekjohn.clark@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While adding charge limiting support to the Lenovo WMI drivers, there
was some back and forth about whether charge_types or
charge_control_end_threshold was the appropriate attribute to expose a
battery charge limiting toggle that is fixed in the BIOS. The confusion
arose because the charge_control_end_threshold description closely
matches the functional change the hardware is making, while the
charge_types functionality better suits the actual an on/off toggle that
occurs in the BIOS. This specific scenario is not explicitly enumerated
in the documentation, though it is fairly common.

Given that the original intention was to use it this way[1],[2], and that
the samsung-laptop[3], ideapad-laptop[4], and lenovo-wmi-other[5] drivers
all use the convention of charge_types with an exposed Long_Life and
Standard value for this, codify it in the Documentation to avoid confusion
in the future.

[1] https://lore.kernel.org/linux-pm/49993a42-aa91-46bf-acef-4a089db4c2db@redhat.com/
[2] https://lore.kernel.org/platform-driver-x86/20241209204051.8786-1-hdegoede@redhat.com/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=de2884c6cdd3d133704ce37393590dd1c761500c
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=da8f2708f9b69707f4efeb432a18395e46b4666f
[5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9ca8fc065b88b327acbfdc33454efea391639716

Suggested-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Derek J. Clark  <derekjohn.clark@gmail.com>
---
 Documentation/ABI/testing/sysfs-class-power | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index 5641f1fd5fd6..98b389845d1e 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -365,9 +365,12 @@ Contact:	linux-pm@vger.kernel.org
 Description:
 		Represents a battery percentage level, above which charging will
 		stop. Not all hardware is capable of setting this to an arbitrary
-		percentage. Drivers will round written values to the nearest
-		supported value. Reading back the value will show the actual
-		threshold set by the driver.
+		value, instead providing different minimum, maximum, or step
+		values. Drivers will round written values to the nearest supported
+		value. Reading back the value will show the actual threshold set
+		by the driver. For hardware that only supports a single fixed
+		value, use charge_types with a value of "Long Life" (vs "Standard")
+		instead'
 
 		Access: Read, Write
 
@@ -398,8 +401,9 @@ Description:
 			when to start and stop charging. Advanced users
 			can use this to drastically extend battery life.
 		Long Life:
-			The charger reduces its charging rate in order to
-			prolong the battery health.
+			The charger firmware reduces its charging rate and/or
+			maximum charging percentage to a hardware specified
+			fixed limit in order to prolong the battery health.
 		Bypass:
 			The charger bypasses the charging path around the
 			integrated converter allowing for a "smart" wall
-- 
2.55.0

