Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911476;
	b=Rj9QU7In/8L2K4yVzA2ITWLG7EQmueytB8CeiPlXTDGv/6SKVNahpLL3lOq6esbV16nT
	 zW5tMpfJLQLlPu1dXzWf/oM8uZgl2StIh0lfplI121/5FbrYJCaPv1A+uP94Dci+oFHTc
	 tXv7y3TMgrQOctpGCHK+3+U8qW0/rVb+b04tQqhOpjzPIr+2ngjvWIgMCmTp1pxkZvM96
	 A6eCbt+VYOD4PXDCn8CUI8VJDQv4w+O8vXocvSAyz8fpeAF/QrvKXsbRApYuw5qzxCj+9
	 Yt3TJlJuW7IQH6gxxauQEv919lavGPtn0l58mjQhQFZtkMUg2oZJow9/E5oPKkre/Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911476;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=q5YxFm7TuHU+WdTu/sAsSrxssHu2WRWeqCoIR2MP2xE=;
	b=RcBl/uUeSksgKGN16oNCTzVsndKlh0CaMTp9DbRy5dDJtUhNAwLpBdtAKEp/e0nyArAT
	 UZUWO52kSjIp/5+SVwOu1yCP7iMnxNBVhbKzHvcmshlAmdzi1kWvnslF1CvWoWwj9ExfD
	 ZaEwPzW147X2zQl7EDVOD3W4uS4JUsfnSMYoMw9eJzWt9vqKjSiX9QkhVdjjOxd6XPu62
	 rZ1fQ1vfIuzr00KXD9gL/1VbGF/QhW6rPdY+pA4AtqWDfnlrY5wGJC/yN5V9RVKKlWs2Z
	 7r2uacYCotMo8mXkzA60qbODUZq4tpKNlyt94FOdSKOcuEUhtIsOoTDeQzBckcfAV7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e40JiDql;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21394606A33E
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 10:31:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21394606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e40JiDql
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso37606605e9.1
        for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 02:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794911474; x=1795516274; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q5YxFm7TuHU+WdTu/sAsSrxssHu2WRWeqCoIR2MP2xE=;
        b=e40JiDql8Jnmhl8iYA/OoSl2lwDIXGxYL0F8dBX1VKyKn96agI6jZATW7vsB1apgoL
         fZNvVfaujHj924lqyALLxt+2dcPjR8jhspCqwFTAm/yHuf+bT6WfzVA+q7bl0ahu6+ME
         iXx3fF2PFVadhlAbmR4qBIfW9VIdmrvsegiWuqjLTPogltX0OVEJCzPZgGTvAamGyxIg
         fgujWar6Lds+rZQpHH/lmPHdzWn7V37JuSXZt+VOlK0u6b3d8JDENZoP31QAMbjOeKZa
         IgSeIZY/JtEVz7+1c2Vy9UiR6XgCtjn5VNP1faN9++PgjIQIhw8hqdzkveAvV8J7appO
         4A2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794911474; x=1795516274;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q5YxFm7TuHU+WdTu/sAsSrxssHu2WRWeqCoIR2MP2xE=;
        b=aeTWVJKJuBIKby9SgBCENqsYbwrxdIo8ptvCdaMaymm17iiVdxdmUI93SQvymwIpeB
         IR4ECbPsUi+orGhzksCgKXU0bWz5e0KHLzn5D29F7voXAvhh5rRCacQBxdDZlktkonsz
         6tuUCXFD7pkQ/X4eKJfKbVgBUCmem0Nue4gxfM7mrd0/tGgWenwEOtMO6PVYlLkoTIX8
         Qr6VpAgmWkikHxPp2BX+fFCNmirEWNiiV5nS1QOmvVGPHT80k7ozUa5+MXiQQRZY4ARa
         zZQxhri1lQrblHBO5u4AgwdqVRdalkOCIGH0m2eDmd8KhzLGr3n+sdVN6EN5nqFUnWRJ
         cUGg==
X-Forwarded-Encrypted: i=1; AL+hErGmpnH2uq2fT/N4Ip/ml16iEtFM4LoS8qZvUYXUnfYYILd+lGEQDqJCRDOfe83LLCxAqJ0ViCQt0oI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9FpXeXnwZB84THxbPczpcM89jYHJyiw7QvF64k7yLXFijLHzUx
	zgyYBNHWjwHGDleNREdTgPYyy+igE/GhkSEXMqmQL4TH7FRrYdfY5+PT
X-Gm-Gg: AYBFou3scoSIbuMOVCpYyLBIobgOnHj2aIZxDKUb8GwWN/KuAE6JVCrhavIkwljO7dd
	xdiPNA1KeD7/J09XvHWPoKX/ZfVJQpdKOtj6T1qCkm+MxEJixuoz0sC/ZMqMrDN9uFDg5eqA7Pv
	000GBYgwSX1HmzpqWCRwI8153AiZhhk6LlEMqud1iQuRtEvyeDuTKYY9AGuiICBKzJLnJ72HECT
	CQgQRndSN/FCCgcqg7GbSYOM1dGKPkBBLylFeBfEfK6O0nZUY/7DnSKl2JAjNcJxejHPWtGVvW4
	BinzqBg8RActiC1CX/GMcRze43duBz9c+uD6vXVCdQ7QkoO4phB2lF/xT54Qyc1pBrJ4B7DQxma
	XLdAWoijIfUs1HN9mj8tY9f+NgsEAhJXEMZPi9bYgYBJtLMBhXNIVeiYLD2davzyW6x/nRC/TdB
	ZllPYXTgf1dPwB3awstjMicRTxllvkccO7gsCR2NvUJUM3Sm/BIZkL6zLdjB9xdQm5nJozsFgZ+
	wJKdYfVwUUf7CzVWq6cvo6icpkYmwQX/L0rOroVd4omrqQJh0xRN4mYCzB30SkbgKwnR55rDIzB
	Qd7pK4lBiqhPgG+pzuAF9T9c214m/g5N+Q==
X-Received: by 2002:a05:600c:6286:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4bb55a5d634mr261868525e9.5.1794911474232;
        Tue, 17 Nov 2026 02:31:14 -0800 (PST)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb783965d4sm57712355e9.7.2026.11.17.02.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:31:13 -0800 (PST)
From: Bartu Alev <bartualev@gmail.com>
Date: Tue, 17 Nov 2026 13:31:04 +0300
Subject: [PATCH v5 1/3] platform/asus: asus-wmi: decode integer replies in
 buffer helper
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
Message-Id: <20261117-asus-tuf-rgb-v4-v5-1-95268035eef1@gmail.com>
References: <20261117-asus-tuf-rgb-v4-v5-0-95268035eef1@gmail.com>
In-Reply-To: <20261117-asus-tuf-rgb-v4-v5-0-95268035eef1@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>, 
 "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
 Hans de Goede <hansg@kernel.org>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org, Denis Benato <benato.denis96@gmail.com>, 
 Bartu Alev <bartualev@gmail.com>
X-Mailer: b4 0.15.2

asus_wmi_evaluate_method_buf() casts the ACPI integer it receives on a
non-buffer reply straight into its int return value.  A status word
with bit 31 set therefore aliases a negative errno: 0xffffffff, for
example, reaches the caller as -EPERM.

Decode the integer through a u32 first.  Map ASUS_WMI_UNSUPPORTED_METHOD
(0xfffffffe) and 0xffffffff to -ENODEV, matching what
asus_wmi_get_devstate() does for ~0, and map every other integer to
-ENODATA like the unhandled object types, since this helper is only
meant for buffer replies.  Buffer replies still return 0, and a missing
ACPI output object now fails cleanly with -ENODATA instead of
dereferencing NULL.

The only current caller, fan_curve_get_factory_default(), logs and
returns non-zero errors to its callers; fan_curve_enable_store()
propagates them to sysfs, so any unexpected integer reply now
surfaces as a proper negative errno rather than a raw positive value
or -EPERM, while fan_curve_check_present() still treats any non-zero
return as unavailable.

Add kernel-doc for the parameters and error returns as well.

Link: https://lore.kernel.org/all/20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com/
Suggested-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 drivers/platform/asus/asus-wmi.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/asus/asus-wmi.c b/drivers/platform/asus/asus-wmi.c
index b33ebdb21aa21..4d844f914f77e 100644
--- a/drivers/platform/asus/asus-wmi.c
+++ b/drivers/platform/asus/asus-wmi.c
@@ -461,9 +461,25 @@ static int asus_wmi_evaluate_method5(u32 method_id,
 	return 0;
 }
 
-/*
- * Returns as an error if the method output is not a buffer. Typically this
- * means that the method called is unsupported.
+/**
+ * asus_wmi_evaluate_method_buf() - Evaluate a WMI method with a buffer reply
+ * @method_id: The WMI method ID to evaluate
+ * @arg0: The first argument passed to the method
+ * @arg1: The second argument passed to the method
+ * @ret_buffer: Buffer to copy the returned ACPI buffer into
+ * @size: Size of @ret_buffer in bytes
+ *
+ * Evaluate a WMI method and copy its output buffer into @ret_buffer.
+ * The reply must be an ACPI buffer: a buffer larger than @size is not
+ * copied and returns %-ENOSPC, and an empty buffer returns %-ENODATA.
+ *
+ * Integer replies carry no buffer: %ASUS_WMI_UNSUPPORTED_METHOD
+ * (%0xfffffffe) and %0xffffffff map to %-ENODEV, while any other integer
+ * (such as %0 returned by %ASUS_WMI_DEVID_CPU_FAN_CURVE when no argument
+ * is provided) maps to %-ENODATA like any other non-buffer reply.
+ *
+ * Return: %0 on success, or a negative errno (%-EIO, %-ENODEV,
+ * %-ENODATA, %-ENOSPC) on failure.
  */
 static int asus_wmi_evaluate_method_buf(u32 method_id,
 		u32 arg0, u32 arg1, u8 *ret_buffer, size_t size)
@@ -477,6 +493,7 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
 	acpi_status status;
 	union acpi_object *obj;
+	u32 retval;
 	int err = 0;
 
 	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
@@ -490,6 +507,8 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 	}
 
 	obj = (union acpi_object *)output.pointer;
+	if (!obj)
+		return -ENODATA;
 
 	switch (obj->type) {
 	case ACPI_TYPE_BUFFER:
@@ -505,15 +524,18 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 		memcpy(ret_buffer, obj->buffer.pointer, obj->buffer.length);
 		break;
 	case ACPI_TYPE_INTEGER:
-		err = (u32)obj->integer.value;
+		retval = (u32)obj->integer.value;
 
-		if (err == ASUS_WMI_UNSUPPORTED_METHOD)
-			err = -ENODEV;
 		/*
-		 * At least one method returns a 0 with no buffer if no arg
-		 * is provided, such as ASUS_WMI_DEVID_CPU_FAN_CURVE
+		 * Also map 0xffffffff to -ENODEV (matching
+		 * asus_wmi_get_devstate()) so bit-31 values cannot alias
+		 * negative errnos.  Any other integer is not a buffer reply,
+		 * such as the 0 returned by ASUS_WMI_DEVID_CPU_FAN_CURVE
+		 * when no arg is provided.
 		 */
-		if (err == 0)
+		if (retval == ASUS_WMI_UNSUPPORTED_METHOD || retval == ~0U)
+			err = -ENODEV;
+		else
 			err = -ENODATA;
 		break;
 	default:

-- 
2.56.0

