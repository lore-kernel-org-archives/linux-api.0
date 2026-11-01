Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793530025;
	b=4rVOnbbXZ2aJd9lb9KAzpgys7zmq5tDQU/+M9H4mEawIqcuYAhuhYw9mpCLQS56mc1Q1
	 0VxtKpJszF4I/w3nQYxC0cO5vBzCNm5qRJAwTBxGSQiDrh3+GI66cGDouQY6iYhNYO7vC
	 z7aNDWnpf7URViXF4Wdai5CJdn+VIMGtG+bcGEQuYjRPFleXiB9qgr95AdClUhednOUu3
	 5qBxYnDuQgN8M9J5VFZ3eDVrNKMNUPzDqlUJRpLWXn7B1GjZ7MOTXQgVUf7wKTXOkmuYM
	 +3oUoG6CPf/2N0iipEAFuA6rwBX3FAyU6uUjbDOtZpSpfeUayw0eWJSwcJC+ERwfB9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793530025;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=zun4IPymVDL2q+RaGkZ5Ofu94Q9+xrFA9vW8dw/AJJA=;
	b=a0IJB1i7FQ9DVtamtz8suAFgwxaPdDAWEuC4kjkkhi8W+GuI+2mvhafsJPJC+YhRw/kI
	 Ynj6qCnOgv13swXaEJupIz02LamLbS38uwl0asoffIqCEOHs7bbAcFQva5TDztCbUjeod
	 iK6tAzjdJCsiwmK7uu13frbnalwTOSOQj/mBJIb9GeFTDKBww6s8UDRs/eLkVeUTCVnEt
	 YemmmHr4w/oO4JfgJ7y9fKIcqcbTVeq3qUE5QBMobEfay8pP1dJ3AIvfbxUqTXkhgBDOO
	 MKCsDpUvp2K2byQHRjVw8nDx2SG9FhgUInXbGKg1G8vNYfmtafhjoir8mea/KIOqV/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M3LRXwiP;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983D5606A333
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 10:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 983D5606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M3LRXwiP
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a208d93758so22284135e9.3
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 02:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793530024; x=1794134824; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zun4IPymVDL2q+RaGkZ5Ofu94Q9+xrFA9vW8dw/AJJA=;
        b=M3LRXwiPKbhRI7NfWThStz7qRQ/Q2Ot3G7Ckyrd07GYSGdOwzz5SawmvUxdoRb0/Vb
         TdewXzl1VPTSIz24ImXOJvjnDl8EyPSvY2r1Uz/Ne2f4aTf1dbs7zJ0s2I389z6DK2wg
         KwQJExxbCjWtrBMW9Ih8oNmFkPMq9mxv4vsTCxPlr4EVaqz0XDGgS0C1XCK4iU25lWLc
         vnsMRIJd9393z/ze9oL70LhbK7h4edt0hIwsXCrwZUI55DztUh0ofO9WtHpIeHLezn2C
         ittmTLRIFSqjS/odqePkaX3NPLVlmBw0AUoRdSWmkLf9gldE/n8kTmMUEEvJgq+KcckN
         nyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793530024; x=1794134824;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zun4IPymVDL2q+RaGkZ5Ofu94Q9+xrFA9vW8dw/AJJA=;
        b=obMRb8oWIMLfxgqiPpu+keDmIwrJAQUCHppG72qBLM1Etj0Zc7nNdWNp6BJG2WaoLv
         JVU5rKkfRFJ8SMAPsgnaDJ/n+0ZryZzAGpldED02xWAgLbooBQmYDjO3wd9rz4h00bIp
         fDzVsxjvYtZ9M2qUM0wHBljV9sTWbSkYQCvJbQwCE0jiv1Sdc+q0R5sOEkCekQKl+cLl
         eVLgcsCK3Q40Ad2NRBW7o2CNdZ23583JLERj1+6sH+Y6TjM6FvFdT6NNFltd1+3IQW7M
         6VNtmAM/c/FTB3aXGDvJH123XxDByrecqRQ/0i6PLWJyG0ULjSdZAY9nTItOpW1e7oSx
         xx3A==
X-Forwarded-Encrypted: i=1; AKwUvBy/htjr/5C33h+uLS4TnzH1YVr3aMsZKzfk3lxlFsiIpOr0VsMCznF2AsGewlQiQv882BSEsLd1HhE=@vger.kernel.org
X-Gm-Message-State: AFq9FYJQIlpauA+8jA76WNwahAZWepb3CFl74PqwWTb6GJjIaFETYVXP
	1/+f0RcLCedku2gNtYQzRVzlwB3u7tcLK3VsrFv6q5Oti/96EJ8gU0FT
X-Gm-Gg: AYBFou0217cjkBmDCDKXoUoSMPcLaGGT1dgtz9LFEe0ty9NmpYp571+/Z2kZ2D5xp3N
	u6O8Vgxx+Bo88gJ7UT/HMvEfT6/VUWJxvjQmUyrBNTMA6uo+r1lyLHe+f1oq6HZeNPFxNroNaSC
	NSlLCm2DCUPAJkDyfJrdz9OLzIrn0KWziWaw0TETh6x6WpLHogjcKSl9JxrfIYRgAOlhQdew6tB
	MFimz1Tl2U7uahAOONNA4UNHGmV0+IY/PGzbzp8J6fK0qbEseLLNGY65mR8xjnVc11xrORthwlk
	0aB2oW2WK7pSoZLnqXJcyX6tmS6U/2Ko08EVlfyDN73O5ipiGq/y3b9JCXkJVrDxZTX8JAeuVBO
	3Gdzv3IVdjLsFqzvoXbxY6fIBquXYdIpoDHrGuFfTp97jPd5CCOm79bbH4DajqjrlTbK7ZjpSOe
	v6QzY6dIhmbuNgOWNG3G5cnmQWYLzXm61NkDAvyReoWMhlRuX249I5/X/Kodccu9ekWxTDTCoi7
	rmja/VE9b4omCj24eoT3qDfCFsFxjV3WwZPIKcpHflgUZi0hNF/jfMn26bVAODe/8lyQQx/H16X
	gxs9pO9g7Dtt81uTvtFAigctMFo=
X-Received: by 2002:a05:600c:34cf:b0:4a2:fe3:121b with SMTP id 5b1f17b1804b1-4ac18d68ba0mr149859905e9.28.1793530024067;
        Sun, 01 Nov 2026 02:47:04 -0800 (PST)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm255602715e9.2.2026.11.01.02.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 02:47:03 -0800 (PST)
From: Bartu Alev <bartualev@gmail.com>
Date: Sun, 01 Nov 2026 13:46:43 +0300
Subject: [PATCH 3/7] platform/x86: asus-wmi: define the fan floor table
 DEVIDs
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261101-asus-fan-floors-v4-v1-3-b8d1c31a99a9@gmail.com>
References: <20261101-asus-fan-floors-v4-v1-0-b8d1c31a99a9@gmail.com>
In-Reply-To: <20261101-asus-fan-floors-v4-v1-0-b8d1c31a99a9@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>, 
 "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
 Hans de Goede <hansg@kernel.org>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>, 
 linux-api@vger.kernel.org, Bartu Alev <bartualev@gmail.com>
X-Mailer: b4 0.15.2

On some ASUS laptops, the embedded controller enforces minimum fan
duties on top of custom fan curves and reports them through three
read-only DSTS methods:

  0x00110026  CPU fan floor table
  0x00110027  GPU fan floor table
  0x00110033  mid fan floor table

The mid fan floor uses 0x00110033 rather than the adjacent 0x00110028.
On examined firmware (FA507, G614PR), 0x00110028 and 0x00110029 are
stubs; while GV601 exposes a GFLB(0x28) AML selector, it is unrelated
to the DSTS devid.

Define these DEVIDs so a follow-up commit can read the tables.

Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 include/linux/platform_data/x86/asus-wmi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index 66c7ab35d6c81..44189c5e6f2cb 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -102,7 +102,10 @@
 #define ASUS_WMI_DEVID_MID_FAN_CTRL 0x00110031
 #define ASUS_WMI_DEVID_CPU_FAN_CURVE	0x00110024
 #define ASUS_WMI_DEVID_GPU_FAN_CURVE	0x00110025
+#define ASUS_WMI_DEVID_CPU_FAN_FLOOR	0x00110026
+#define ASUS_WMI_DEVID_GPU_FAN_FLOOR	0x00110027
 #define ASUS_WMI_DEVID_MID_FAN_CURVE	0x00110032
+#define ASUS_WMI_DEVID_MID_FAN_FLOOR	0x00110033
 
 /* Tunables for AUS ROG laptops */
 #define ASUS_WMI_DEVID_PPT_PL2_SPPT		0x001200A0

-- 
2.56.0

