Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793530019;
	b=G5wlq0XxofRk9s0al53XLLlGnErrmSYN5K3CYHV8BER0UDdrcL5Tj4wfuz3wruBWzOW9
	 hZhNoAhI+ODOqXcLuhHLG7zwwQo5gQUGHwufJ3LeLiuAahB5Kyn3Zuq1wai1t4NmVN/gB
	 qsekTgUw9ElpDFlcO3QxzafpuxvZYoxaS9fIiifXvGDugisS/feU7UopKdISz7/vyghCP
	 nBey/iSovKAXOOw/cvO0ZT+kh6smhk1AQtESNw+MQgLjAjZpXX2ZC7tiVoVDhNooenNVH
	 +dLqYRQFavDRH32Etn4fDC36WmK6HU0QPn3+9XRAYAlJxL9AL4UciZGJ2a5VAYsYZNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793530019;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=7G9vF9OS16E0g31UX34geJPbbud9xS33YqrpYdPUMwo=;
	b=hu9EImDqglj19wlrMQBFWde3/3ud+uzm29RmlOjyq+M8C/4aA9hVv/u55HNC0ePWw5Ok
	 1vFejKe0j0H5YznIL+WhZBtbuInI2evSikDL/IV4mF2e8zRT4RGepL6hzRZnaMt74kVMN
	 L1Uo2EeejJqSMZ7b3uDe6Rsd/OVJHFFR1rJAwqQvvzZowX1hRTBy3vjJ9kJunEXa2z+Zy
	 9hWjKGOrrJSa2SDzJwzciD+dDUfp6y+32M0JrEcs4aloXnZvgSbrFARJFI4uD0sccgkmL
	 XUUq/RAqTmSVUuU1gEnLSwVhEAvgTY8eSQcGK7oswHlnEPqbUXdqJFVB2weUuggqYag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D5NoKQzc;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA555606A32C
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 10:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA555606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D5NoKQzc
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so26845765e9.1
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 02:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793530017; x=1794134817; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7G9vF9OS16E0g31UX34geJPbbud9xS33YqrpYdPUMwo=;
        b=D5NoKQzcOhGbdR3DBrqW2mnxCLFInSyDjJH/+62YKTx0X38vQhc0vCYMBkzpHK6ymy
         ojU36Lg0xAj5NCCRLOLESGFqMcgx3+01OGf9fHep8bcKrI0/XANmkKByV4QuqjtGZBM+
         7vqshWMC8YbcujGmfcvqq6kI0L5EusmF8CfkQicmO/0vuyhAVoiCIo9170VnG0tWkyYS
         0z5dMP7QJKk0Ylbu6Wo04qPRi/l/f+1VYSgr49ZS60iRBTt6btidI0JBWNWQ0NrfBKpl
         jyI0O4p6VYliMAfJtARMbVyi2ggH6S8I8qE/omv1YL4NqENqwIEOn/dbWDS5jHItVOdF
         Mxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793530017; x=1794134817;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7G9vF9OS16E0g31UX34geJPbbud9xS33YqrpYdPUMwo=;
        b=pML5TMxCas6ks/BS2QoiQC1pxNr9spOFzAB04b9neBQcJNSkScgpvxR3EjjjWG/fmh
         7H4CXfKsBkAs9gqxJgqz37icvpx5za1lNYacNKkZJ3yvq0UtBmz4s6h1L5dJTFLwLsge
         Ip1AoLx3kyMujFrJ6eCF5HYTq9SN+XmnHv2pYPpE8MwnXX+vg7SQnAgElBlNB9Omd40C
         ZwEehZkwVTph1uWm0hR0itFQx44k/72w7P0RnvdvdMYPcu1r31wkydp44M1GVoWvEv8Z
         iHSowcVBvgz41Tb2nnZtyE2YrVxNQ82EP/pTeNcbk+bDW4GILS2pqywcG5MwuzeX+Jel
         Coag==
X-Forwarded-Encrypted: i=1; AKwUvByY/39n65i+CvhWiO7Kpui7LHlHHEDCPTdA9XjAkjt3NGe0AvQcS1OOjmsNfneyFvHnFM8a1UWPRfg=@vger.kernel.org
X-Gm-Message-State: AFq9FYJRIiDvdisGkrkMn6BDUGRT7q5L5weuHnSD5bLhj/+XDxiu8+2r
	A/R1Gb7PxSb0/eGpohYcHJWj3V84i6xEjwWS0mOrSMoaPpYJSoRh2JlW6A5/vFeag7A=
X-Gm-Gg: AYBFou3b2GYHHB6ZTLUxFMPhe41G6V1+3NRuO4Tw23mztIn/9X1CLw602xGA0/z9BVJ
	wLTUu4L5UwB7a2SYA8Vp1CdY5UEd474+QiuWQH4QqOQ9dkgV9IlKXLeFJBXTPe1EcvDLATh3Ugp
	1dH+o8sGoj/sSfcSOX2bzGC8yGlT4nG7Rqja7IHRUv5QW0+pfdbL3ZdufhqtJ4pgPbx5hjkC+tS
	HAUJ1mQqlNJRBRWM2kZp1QeotmqILhRYpf2JccWhWcGIJBwDKfRa02yr4NkFSPY7W0XfkdHkbA9
	RgyflZsrb3l3XT1EEeTXhaiMBmLkcuzYzF+PYojmPT+vly4FR4tamFMoV26dJjqPngFquD28r9H
	PxkjcvhXnI3gL/bD4fOQD1CAeovCIByTuaNl9AOM/YL7As1RYSM7fW6IOFze28axPpqaVHbVDv6
	L7kIvIaSQD2AV5irm9NYf68PoIX9nQTMzW2jjJaC7zn3JL5r8cTwJOaTMlS2NKVTCfFUQPjt22O
	uGido+34WnU3HR69nyTyLht6TPLgymP4bVqUz5l25gPh/c63zdeijolj37oX9Tje5F8Z39OtrRY
	uZcR79YcTA9ACcXgujWd0qVmnA0=
X-Received: by 2002:a05:600c:8116:b0:4a0:20b4:ba93 with SMTP id 5b1f17b1804b1-4ac17e10724mr168860485e9.16.1793530017002;
        Sun, 01 Nov 2026 02:46:57 -0800 (PST)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm255602715e9.2.2026.11.01.02.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 02:46:56 -0800 (PST)
From: Bartu Alev <bartualev@gmail.com>
Date: Sun, 01 Nov 2026 13:46:41 +0300
Subject: [PATCH 1/7] platform/x86: asus-wmi: dump buffer replies in the
 debugfs dsts file
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
Message-Id: <20261101-asus-fan-floors-v4-v1-1-b8d1c31a99a9@gmail.com>
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

Reading dsts calls asus_wmi_get_devstate(), which uses
asus_wmi_evaluate_method().  Because that helper handles only
ACPI_TYPE_INTEGER and leaves other return types zeroed, methods
returning an ACPI buffer read as 0x0.  This affects fan floor tables
(0x00110026, 0x00110027, 0x00110033), fan curve getters (0x00110024,
0x00110025), and TUF RGB readback (0x0010005B).

Evaluate the method through asus_wmi_evaluate_method_locked() directly,
matching the call node, which keeps execution serialized against other
WMI operations.  Format integer replies as before, dump buffer
contents with their byte length, and print any other type as t:<type>:

  DSTS(0x110026) = 16 bytes:
    00000000: 00 00 00 00 19 30 3a 4a 00 00 00 00 00 00 00 00

The sentinels 0xfffffffe and 0xffffffff continue to return -ENODEV.

Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 drivers/platform/x86/asus-wmi.c | 46 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index b33ebdb21aa21..c55f469cb03dc 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -5038,16 +5038,48 @@ struct asus_wmi_debugfs_node {
 static int show_dsts(struct seq_file *m, void *data)
 {
 	struct asus_wmi *asus = m->private;
-	int err;
-	u32 retval = -1;
+	struct bios_args args = {
+		.arg0 = asus->debug.dev_id,
+	};
+	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	acpi_status status;
+	u32 retval;
+	int err = 0;
 
-	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
-	if (err < 0)
-		return err;
+	status = asus_wmi_evaluate_method_locked(asus->dsts_id, &input, &output);
+	if (ACPI_FAILURE(status))
+		return -EIO;
 
-	seq_printf(m, "DSTS(%#x) = %#x\n", asus->debug.dev_id, retval);
+	obj = (union acpi_object *)output.pointer;
+	if (!obj)
+		return -ENODATA;
 
-	return 0;
+	switch (obj->type) {
+	case ACPI_TYPE_BUFFER:
+		seq_printf(m, "DSTS(%#x) = %u bytes:\n", asus->debug.dev_id,
+			   obj->buffer.length);
+		seq_hex_dump(m, "  ", DUMP_PREFIX_OFFSET, 16, 1,
+			     obj->buffer.pointer, obj->buffer.length, false);
+		break;
+	case ACPI_TYPE_INTEGER:
+		retval = (u32)obj->integer.value;
+		if (retval == ASUS_WMI_UNSUPPORTED_METHOD || retval == (u32)~0)
+			err = -ENODEV;
+		else
+			seq_printf(m, "DSTS(%#x) = %#x\n", asus->debug.dev_id,
+				   retval);
+		break;
+	default:
+		seq_printf(m, "DSTS(%#x) = t:%d\n", asus->debug.dev_id,
+			   obj->type);
+		break;
+	}
+
+	kfree(obj);
+
+	return err;
 }
 
 static int show_devs(struct seq_file *m, void *data)

-- 
2.56.0

