Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EB63D25A2
	for <linux-api@vger.kernel.org>; Sat, 10 Oct 2026 10:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791627415; cv=none; b=jB7qNwFxtUScJwxH698BsZe0hHkLU5hVZBZg8xHIYctQEk4WpvVmymnf06Cx0vLwtjSokio4MeRiNiVT0F3P2D3Thwb7QDrbywosr0zJ/29gQY3++rukaHyOOcFF9zZnSP4NzTezwKgAqkiZIEZS8eiDtKw1UhRiHxnsK+gxbEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791627415; c=relaxed/simple;
	bh=vmMrai/SZHWfjpubrhmvNZYZ2tmXfd2uKqkrZBhCMj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9PxvedojTRmz6q45gcGzAszwuovjKp9KeVZwotkJveKxW1UbMYxhSNpcybEUD4JAO8q1lkt8MYrk6Jo7aArdsiQWbVeMkLBv2lb37YOFB/qDQff40x5c791yuI+54hkTOPEaiIwfjBPl3kTXUElzzV4EsWlF5Xl3SbilctjXmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ImA1fi7n; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ImA1fi7n"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b0946c2c2so258195f8f.3
        for <linux-api@vger.kernel.org>; Sat, 10 Oct 2026 03:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791627410; x=1792232210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yyaHXbmIQ7chKBwYcW/anldepruSkhnw3Mp3qDjouh8=;
        b=ImA1fi7n+XdMirxe3q9Ap09ai0W6LTkCdufJd177sCP2TTuohTbROPxc3ZqxHOFEXo
         A5oW6diohPBDWJpvhDWgLC4cg6MvJZjHZ4RopxLJUQ9T6FDSUlJkQ0knHhydUpwaP4Rg
         7u7k/an51Oy0udCazGGS8vryd2nu/wJNzWkbdO+J6W9Y4/EdQTj+SoCw0dbQRZHcFmep
         udCjDF1CY7uQlOxMBU9/b2mjwVa2Fjk3waikbmVKpPnprDS/loIr/o4czEfpZpvSn6xF
         Gb7zfuvvL+2YQfDzrqHoS/zkmkBw1lzfBDosofWm5lF1OLdIgJEOJF/6ydpWsitciLNM
         ElJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791627410; x=1792232210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yyaHXbmIQ7chKBwYcW/anldepruSkhnw3Mp3qDjouh8=;
        b=h4xpwIuIgZMktlDIxKsXiyO6ir3iqJOhjUJtP/vH9jgRI9bcEEoKFGIPKIx5+FfqMn
         7Iv0cdBpyQFBK3m3UtmGAKPNzSIN1QOpPCJvPQhORYMtpfZF9Yl0LnEQcN63mBc3SGur
         fs1eBNkTOupZwTIiN/HyTPc0g3vPgsSWYIqzb2b/JabjI057KJYqJuSnJhz50wk6f0PH
         ApNpDmLGHL1jvgag32XJyMxXuj3ZQii49rmOLU9tErYj3Bbe1/1IZ5SEgRwON8fWATm9
         oIkE1ng89sK5P+EYdFzdGNW9MaWFaGfg0sS0a8dONOuvJ/EKATXNWtzUVqE5JJ7Wt/b3
         Q0WQ==
X-Forwarded-Encrypted: i=1; AKwUvBw0VI3I+Ejp5jLrsGRoMRz4ilPFOVEnpTg64hJ2nu14TyYxlwzhAVJhFI+WnitfExuG0VWbwZOIIRc=@vger.kernel.org
X-Gm-Message-State: AFq9FYI+9Cma+QvFOtBrThTDEw6CmY0nlzPzw2u95FimONLy6DyaNz9w
	QfQtjKgoiokMA/5V1tFi5a3EjDl5H9LPZUAz/RdfXmBW6onbTDYBOto5
X-Gm-Gg: AYBFou1NZAGItmpBGQK0CjI/J26i6AmgbNMdKdFkM4WfRJN3ePl9eNNDTiEqiurBtMy
	pUYKM+y2hiGIOVG1zqsOLqxkVn7ktJ4s3ZGF5B+OyDvxx2f3hx73toh4+5FS+5W8HtPfSsube5q
	zu+wNDdlAFTKP4iJmpjo3R/POOxBo2oLajq4J9Lp/Czoh50U439mqaWkdg6W48W5dGj3tvmljdI
	g0KEUwj++1ZsIwUjolp1LGfyWL3gotKyjTRI8zCoEh9vY+c0CqpKWHDD6Po8jMN89E5TlZnzUZU
	72T9PFnwG5TSyhqRMcxE7NuBJzbAx5HDGj5ZLK1Uu3v8F/J/2B16/oVxhiw5i7XpT/JX/oR5qVr
	MtkE1b6+eZCszBcIsM7WATyYWlmCNo0aXEWfZ8A/o9lNwwRz0wnGs+KX9UdzGcaJCxwgGrhsGCc
	7Dy/n0+o7bVW5NcaJqZF6KHmEHvlIIQXXKPVrASFDyxSHkxyR+hGHxVhG8WEk=
X-Received: by 2002:a05:6000:2f89:b0:488:89ed:4430 with SMTP id ffacd0b85a97d-48dbacdfc52mr8738925f8f.33.1791627410079;
        Sat, 10 Oct 2026 03:16:50 -0700 (PDT)
Received: from ASUS ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db98c38f4sm9417856f8f.27.2026.10.10.03.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:16:49 -0700 (PDT)
From: Bartu Alev <bartualev@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: ilpo.jarvinen@linux.intel.com,
	hansg@kernel.org,
	luke@ljones.dev,
	denis.benato@linux.dev,
	benato.denis96@gmail.com,
	corentin.chary@gmail.com,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bartu Alev <bartualev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/5] platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming
Date: Sat, 10 Oct 2026 13:15:58 +0300
Message-ID: <20261010101601.888709-3-bartualev@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261010101601.888709-1-bartualev@gmail.com>
References: <20261010101601.888709-1-bartualev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fourth state flag of kbd_rgb_state_index is named "keyboard" and has
long been treated as having no effect.  In hardware the flag, BIT(7) of
the payload sent to the TUF RGB state device, gates whether the keyboard
backlight stays lit while the machine powers off: with the bit set the
keyboard lights up white during the ACPI S5 sequence, with the bit clear
the machine powers off dark.  Verified by A/B testing both values on a
TUF Gaming A15 (FA507NV).

Rename the fourth field and its index entry from "keyboard" to
"shutdown".  The write format is unchanged, the value is still
positional, and the diff is two variable names and one string, so it
backports cleanly.

Fixes: 61f64515299e ("platform/x86: asus-wmi: Implement TUF laptop keyboard power states")
Cc: stable@vger.kernel.org
Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 drivers/platform/x86/asus-wmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 5adf7a289f82..5cc71bfac841 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1119,10 +1119,10 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	u32 flags, cmd, boot, awake, sleep, keyboard;
+	u32 flags, cmd, boot, awake, sleep, shutdown;
 	int err;
 
-	if (sscanf(buf, "%d %d %d %d %d", &cmd, &boot, &awake, &sleep, &keyboard) != 5)
+	if (sscanf(buf, "%d %d %d %d %d", &cmd, &boot, &awake, &sleep, &shutdown) != 5)
 		return -EINVAL;
 
 	if (cmd)
@@ -1135,7 +1135,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 		flags |= BIT(3);
 	if (sleep)
 		flags |= BIT(5);
-	if (keyboard)
+	if (shutdown)
 		flags |= BIT(7);
 
 	/* 0xbd is the required default arg0 for the method. Nothing happens otherwise */
@@ -1149,7 +1149,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 static DEVICE_ATTR_WO(kbd_rgb_state);
 
 static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
-			     "cmd boot awake sleep keyboard");
+			     "cmd boot awake sleep shutdown");
 
 static struct attribute *kbd_rgb_state_attrs[] = {
 	&dev_attr_kbd_rgb_state.attr,
-- 
2.56.0

