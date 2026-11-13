Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586151;
	b=eFFB0Vy3x8QtaDqKOTesy3yvCbRAEXPSQ3s4sP/WRBIXLKd6vv+nEwPJUO1oPOEvS0Pm
	 9qmImzk9BtKnEtVp4Vz5wkbChFnnlH4FuWEb/wX+ZUqMBkUc/FWfb4oFgJGxXjSUEICpP
	 uGqD5nxqO69UyoECk3wzwrOrCcyBjL9rHXbUluGsPgBf48aBPPieVA7PRG48KhAQ46vr5
	 4TmNBwCVFdyrSjGho891E/IVjPCHGLLlKqvlktJ9aRbYAoilv2Fg1zN/rHyPaLdzxIttW
	 G9a/x9LG8GahMC5ibbycPrDTWxVhR9SRth+5NOYhrzBtU3pMARfhIpdNfODmAy7wF8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9bo9BfxaEw7amAwj2fZcNBOwQOKFl/OM4ulegQbiyk=;
	b=el4hwUlxmhOG/z95t3A67y9u/2aPGXB6rRw+jH03omBAxi2US35AJLRxlmFh98zCLiWY
	 nDuByTriTvRRIZ3qDsp8q4c59Z0kfU4lrne3JrPNTGjHOcIt9Mv+xxDRdHiA2YjQIRURo
	 SFSDVygpdiIEAnm0uOQ/T+sksVJ6QqGJB3gLYhEf+W1KKNi3bpoLHG94dYjiwjHrv0gbf
	 vMPAfBC6Mhzn51D8pGnyxQijHKtcT3dWE+A4uQKaqzXgV/MnGO6HkDPs/2mned/eMVfUt
	 TIcbomSmtQElm5vbjc28H2W6fpLcKhzCDF1HV167vlmZR9iqfSfFh18h8226qXOwOow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=MLSXJFSL;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8616C607A306
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 16:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8616C607A306
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=MLSXJFSL
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e3b22e971so564507f8f.0
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 08:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794586149; x=1795190949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i9bo9BfxaEw7amAwj2fZcNBOwQOKFl/OM4ulegQbiyk=;
        b=MLSXJFSLknVyIqJNPDUng61UtqOqcxBnSQeC4c5nHraRNdrLeqdxywaSvp2Dlosgdj
         tR3XiT38vJhgVDpE9qFsV3DQZ+sea+YH8t8Tn/0tK6Aky2ddxTNT+mDBXQmdnP3seyVY
         DxoDmplrmkxuTLWWxn1Au3BGzf4GjOxfy1h8XXA/XH9VPe87UspuPLRRhk9hV28vRz55
         OSLJE116gSjuHAKfVgXyQN0FrHB1Aw1fXV1y7QzAt2tHR4mHRcllqerHWpJzt1Geqrqs
         8LofaIKDz+syVMsblreM7ouVC1nu3ZlSVteUq5IvQeMjv4Ozx9XZWLZYbqouBHTpSB/h
         DpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794586149; x=1795190949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i9bo9BfxaEw7amAwj2fZcNBOwQOKFl/OM4ulegQbiyk=;
        b=neAEA7o6IdGVRRaWtt4hQYhapi+N6D5X+gTO/t0jPBD2XGcnSygT/aG3zREVfvrWRV
         Ffpk0KTlIqle3tqYH12ekK4UfytIrJNxhmyRY8ZW0awgoJwcbJt9DYcv83VBfwPRCLvD
         4ZpF+OHHHp0aMur+H95H1Fr5gSsaDEW4C0et+fJrjO0zNnC/u/jmtAiJZ4hKJVFT6k9E
         oM4xnuelXNN07mgX+Ttt5uUuva6qAlKzlseGtEHAmLdy8Ob6wHUGMjSrftHBOW2BfZFa
         qCRI7IkJY9rMjuiF9sRrf9vKKUntPrqkvYVilc9U3xSERKCw0y9yeSz3GdcgOLwR9hyw
         Aqlg==
X-Forwarded-Encrypted: i=1; AL+hErG/LyhG5ISMQCq4IUXb9LKZ8AHfp1+MxdFVWDr3oZBPOVmnbk/MaTe64wqXzjYPUWWRHZtSs6TwvrE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+6oSGYIx2kvuCI+yj29i5xjyiZWaVrLeb7yKSL5yC0qTBz0MmF
	BGqvsXo6MmJ2R0Wh0MbILvLGu0rye2N3xUrMzWodx2/L5OVv8UBpHQs6VR9K/f8GNbI=
X-Gm-Gg: AYBFou1aMFKtUlilZH6lmX2/5ZBK25x+nhrgnrSYtSNPUh3lRz3k7jvtTYZLSBok52V
	CTzkMMfnYCwUEXEb+mAZYeHtWqsVelP/qbp2KaDWCps9sCb3o+2pf+N3L2J9X1yV46WjwcmkLlI
	FTuN50aw5jDQUofXwvxh67zPxtCVR4qSlR8WN5ILdw6mJyyxk9f+/V0w0AFHKFkpt9Cw9rzxXDo
	RGbqEQts9/pBr1502L48YwCN775ZuguJGS1Vr/LEDMRZuVJiaVkFtnWWwP5rjPzP37iO9hFkYKm
	RCdMtMDs+5XaYeVG4dNQTrhKp8SimnxF2Px5wysqXLns2/qo8QZe6CIGbeEU18HN9WWrQVRdi/R
	igy9DrADR2Ik8FBJd7svVS6LqkWxzhtUX7L4ooQo80CWjiQ7bxV33qIhxdSQJ/ay425sWIqqyhp
	xJIff9i+3I9mVqHDhg1bbFazEJQ/qIiVWFdQ6tH8a9yxCpLwYr5bSEp923fdcY6avyjNETnm1En
	HQHWbBiu0T/o6EBtL7oMUSfCxuShBE1f6U17+UHpPaQC40pUa5boxkVM8xUfmvmz2tDL6O0F/sr
	ey42rFCURTfdq0DozKl4mTl4Yd7foAp0CXKrsJU=
X-Received: by 2002:a05:6000:992:b0:491:fd47:5df3 with SMTP id ffacd0b85a97d-49c6fc9e6bcmr6236979f8f.7.1794586148759;
        Fri, 13 Nov 2026 08:09:08 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5d03b10fsm6898877f8f.1.2026.11.13.08.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:09:08 -0800 (PST)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-coco@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	jgg@ziepe.ca,
	david.quigley@intel.com,
	lukas@wunner.de,
	ksinyuk@kernel.org,
	rodrigo.vivi@intel.com,
	cedric.xing@intel.com,
	sameo@meta.com,
	drdeeglaze@gmail.com,
	James.Bottomley@HansenPartnership.com,
	aik@amd.com,
	jpiotrowski@nvidia.com,
	qinkun@google.com,
	pgonda@google.com,
	jic23@kernel.org,
	alistair.francis@wdc.com,
	ankita@nvidia.com,
	suzuki.poulose@arm.com,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	peter.fang@intel.com,
	jarkko@kernel.org,
	zohar@linux.ibm.com,
	yeoreum.yun@arm.com,
	aneesh.kumar@kernel.org,
	dave.jiang@intel.com,
	nik.borisov@suse.com,
	sergii.dmytruk@3mdeb.com
Subject: [PATCH RFC v2 7/9] tdx-guest: Expose the native attestation service API
Date: Fri, 13 Nov 2026 17:08:36 +0100
Message-ID: <20261113160838.2512652-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113160838.2512652-1-jiri@resnulli.us>
References: <20261113160838.2512652-1-jiri@resnulli.us>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Factor the Quote and measurement-register operations of the misc, TSM
report and TSM MR interfaces into helpers declared in a driver-internal
header, for an attestation provider built into the driver to share.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- kept the helpers inside tdx-guest, in place of a client API and its
  header
- dropped the MAINTAINERS lines, which N: tdx already covers
- sized the TSM report outblob to its Quote
- dropped an unreachable return in tdx_do_report()
- dropped the stale kernel client section from tdx-guest.rst
- numbered every enum member
---
 drivers/virt/coco/tdx-guest/internal.h  |  30 ++++++
 drivers/virt/coco/tdx-guest/tdx-guest.c | 130 +++++++++++++++++++-----
 2 files changed, 132 insertions(+), 28 deletions(-)
 create mode 100644 drivers/virt/coco/tdx-guest/internal.h

diff --git a/drivers/virt/coco/tdx-guest/internal.h b/drivers/virt/coco/tdx-guest/internal.h
new file mode 100644
index 000000000000..d57a8c385aff
--- /dev/null
+++ b/drivers/virt/coco/tdx-guest/internal.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TDX_GUEST_INTERNAL_H
+#define _TDX_GUEST_INTERNAL_H
+
+#include <crypto/sha2.h>
+#include <linux/types.h>
+
+#define TDX_GUEST_QUOTE_MAX_LEN ((128 * 1024) - 24)
+
+struct tdx_guest_info {
+	u8 mrconfigid[SHA384_DIGEST_SIZE];
+	u8 mrowner[SHA384_DIGEST_SIZE];
+	u8 mrownerconfig[SHA384_DIGEST_SIZE];
+};
+
+enum tdx_guest_mr {
+	TDX_GUEST_MR_MRTD = 0,
+	TDX_GUEST_MR_RTMR0 = 1,
+	TDX_GUEST_MR_RTMR1 = 2,
+	TDX_GUEST_MR_RTMR2 = 3,
+	TDX_GUEST_MR_RTMR3 = 4,
+};
+
+/* @reportdata is TDX_REPORTDATA_LEN bytes, and @out holds TDX_GUEST_QUOTE_MAX_LEN. */
+int tdx_guest_quote_get(const u8 *reportdata, void *out, size_t *out_length);
+int tdx_guest_mr_read(enum tdx_guest_mr mr, u8 value[SHA384_DIGEST_SIZE]);
+int tdx_guest_rtmr_extend(unsigned int rtmr,
+			  const u8 value[SHA384_DIGEST_SIZE]);
+
+#endif /* _TDX_GUEST_INTERNAL_H */
diff --git a/drivers/virt/coco/tdx-guest/tdx-guest.c b/drivers/virt/coco/tdx-guest/tdx-guest.c
index 11d741da3b35..c49454ec0b18 100644
--- a/drivers/virt/coco/tdx-guest/tdx-guest.c
+++ b/drivers/virt/coco/tdx-guest/tdx-guest.c
@@ -25,8 +25,11 @@
 #include <asm/cpu_device_id.h>
 #include <asm/tdx.h>
 
+#include "internal.h"
+
 /* TDREPORT buffer */
 static u8 *tdx_report_buf;
+static struct tdx_guest_info tdx_guest_info;
 
 /* Lock to serialize TDG.MR.REPORT and TDG.MR.RTMR.EXTEND TDCALLs */
 static DEFINE_MUTEX(mr_lock);
@@ -49,27 +52,32 @@ enum {
 	TDREPORT_servtd_hash = TDREPORT_rtmr3 + SHA384_DIGEST_SIZE,
 };
 
-static int tdx_do_report(sockptr_t data, sockptr_t tdreport)
+static int __tdx_do_report(sockptr_t data, sockptr_t tdreport)
 {
-	scoped_cond_guard(mutex_intr, return -EINTR, &mr_lock) {
-		u8 *reportdata = tdx_report_buf + TDREPORT_reportdata;
-		int ret;
+	u8 *reportdata = tdx_report_buf + TDREPORT_reportdata;
+	int ret;
 
-		if (!sockptr_is_null(data) &&
-		    copy_from_sockptr(reportdata, data, TDX_REPORTDATA_LEN))
-			return -EFAULT;
+	lockdep_assert_held(&mr_lock);
+	if (!sockptr_is_null(data) &&
+	    copy_from_sockptr(reportdata, data, TDX_REPORTDATA_LEN))
+		return -EFAULT;
 
-		ret = tdx_mcall_get_report0(reportdata, tdx_report_buf);
-		if (WARN_ONCE(ret, "tdx_mcall_get_report0() failed: %d", ret))
-			return ret;
+	ret = tdx_mcall_get_report0(reportdata, tdx_report_buf);
+	if (WARN_ONCE(ret, "tdx_mcall_get_report0() failed: %d", ret))
+		return ret;
 
-		if (!sockptr_is_null(tdreport) &&
-		    copy_to_sockptr(tdreport, tdx_report_buf, TDX_REPORT_LEN))
-			return -EFAULT;
-	}
+	if (!sockptr_is_null(tdreport) &&
+	    copy_to_sockptr(tdreport, tdx_report_buf, TDX_REPORT_LEN))
+		return -EFAULT;
 	return 0;
 }
 
+static int tdx_do_report(sockptr_t data, sockptr_t tdreport)
+{
+	scoped_cond_guard(mutex_intr, return -EINTR, &mr_lock)
+		return __tdx_do_report(data, tdreport);
+}
+
 static int tdx_do_extend(u8 mr_ind, const u8 *data)
 {
 	scoped_cond_guard(mutex_intr, return -EINTR, &mr_lock) {
@@ -90,6 +98,34 @@ static int tdx_do_extend(u8 mr_ind, const u8 *data)
 	return 0;
 }
 
+int tdx_guest_mr_read(enum tdx_guest_mr mr, u8 value[SHA384_DIGEST_SIZE])
+{
+	static const size_t offsets[] = {
+		[TDX_GUEST_MR_MRTD] = TDREPORT_mrtd,
+		[TDX_GUEST_MR_RTMR0] = TDREPORT_rtmr0,
+		[TDX_GUEST_MR_RTMR1] = TDREPORT_rtmr1,
+		[TDX_GUEST_MR_RTMR2] = TDREPORT_rtmr2,
+		[TDX_GUEST_MR_RTMR3] = TDREPORT_rtmr3,
+	};
+	int ret;
+
+	scoped_cond_guard(mutex_intr, return -EINTR, &mr_lock) {
+		ret = __tdx_do_report(KERNEL_SOCKPTR(NULL),
+				      KERNEL_SOCKPTR(NULL));
+		if (ret)
+			return ret;
+		memcpy(value, tdx_report_buf + offsets[mr],
+		       SHA384_DIGEST_SIZE);
+	}
+	return 0;
+}
+
+int tdx_guest_rtmr_extend(unsigned int rtmr,
+			  const u8 value[SHA384_DIGEST_SIZE])
+{
+	return tdx_do_extend(rtmr, value);
+}
+
 #define TDX_MR_(r) .mr_value = (void *)TDREPORT_##r, TSM_MR_(r, SHA384)
 static struct tsm_measurement_register tdx_mrs[] = {
 	{ TDX_MR_(rtmr0) | TSM_MR_F_RTMR },
@@ -135,6 +171,12 @@ static const struct attribute_group *tdx_mr_init(void)
 	rc = tdx_mr_refresh(&tdx_measurements);
 	if (rc)
 		return ERR_PTR(rc);
+	memcpy(tdx_guest_info.mrconfigid,
+	       buf + TDREPORT_mrconfigid, SHA384_DIGEST_SIZE);
+	memcpy(tdx_guest_info.mrowner,
+	       buf + TDREPORT_mrowner, SHA384_DIGEST_SIZE);
+	memcpy(tdx_guest_info.mrownerconfig,
+	       buf + TDREPORT_mrownerconfig, SHA384_DIGEST_SIZE);
 
 	/*
 	 * @mr_value was initialized with the offset only, while the base
@@ -189,6 +231,9 @@ struct tdx_quote_buf {
 	u8 data[];
 };
 
+static_assert(TDX_GUEST_QUOTE_MAX_LEN ==
+	      TDX_DEFAULT_QUOTE_SIZE - sizeof(struct tdx_quote_buf));
+
 static struct tdx_quote_buf *quote_buf;
 
 /* Lock to streamline quote requests */
@@ -285,15 +330,18 @@ static int wait_for_quote_completion(struct tdx_quote_buf *buf, u32 timeout)
 	return (i == timeout) ? -ETIMEDOUT : 0;
 }
 
-static int tdx_report_new_locked(struct tsm_report *report)
+/* Leaves the Quote in quote_buf; copy it out before dropping quote_lock. */
+static int __tdx_guest_quote_get(const u8 *reportdata, size_t length,
+				 size_t *out_length)
 {
-	u8 *buf;
-	struct tsm_report_desc *desc = &report->desc;
 	size_t quote_buf_size = get_quote_buf_size();
 	u32 out_len;
 	int ret;
 	u64 err;
 
+	lockdep_assert_held(&quote_lock);
+	if (!reportdata || length != TDX_REPORTDATA_LEN)
+		return -EINVAL;
 	/*
 	 * If the previous request is timedout or interrupted, and the
 	 * Quote buf status is still in GET_QUOTE_IN_FLIGHT (owned by
@@ -302,16 +350,13 @@ static int tdx_report_new_locked(struct tsm_report *report)
 	if (quote_buf->status == GET_QUOTE_IN_FLIGHT)
 		return -EBUSY;
 
-	if (desc->inblob_len != TDX_REPORTDATA_LEN)
-		return -EINVAL;
-
 	memset(quote_buf, 0, quote_buf_size);
 
 	/* Update Quote buffer header */
 	quote_buf->version = GET_QUOTE_CMD_VER;
 	quote_buf->in_len = TDX_REPORT_LEN;
 
-	ret = tdx_do_report(KERNEL_SOCKPTR(desc->inblob),
+	ret = tdx_do_report(KERNEL_SOCKPTR((void *)reportdata),
 			    KERNEL_SOCKPTR(quote_buf->data));
 	if (ret)
 		return ret;
@@ -337,13 +382,7 @@ static int tdx_report_new_locked(struct tsm_report *report)
 
 	if (struct_size(quote_buf, data, out_len) > quote_buf_size)
 		return -EFBIG;
-
-	buf = kvmemdup(quote_buf->data, out_len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	report->outblob = buf;
-	report->outblob_len = out_len;
+	*out_length = out_len;
 
 	/*
 	 * TODO: parse the PEM-formatted cert chain out of the quote buffer when
@@ -353,6 +392,41 @@ static int tdx_report_new_locked(struct tsm_report *report)
 	return ret;
 }
 
+int tdx_guest_quote_get(const u8 *reportdata, void *out, size_t *out_length)
+{
+	int ret;
+
+	scoped_cond_guard(mutex_intr, return -EINTR, &quote_lock) {
+		ret = __tdx_guest_quote_get(reportdata, TDX_REPORTDATA_LEN,
+					    out_length);
+		if (ret)
+			return ret;
+		/* The TDX module may allow a Quote longer than @out. */
+		if (*out_length > TDX_GUEST_QUOTE_MAX_LEN)
+			return -EFBIG;
+		memcpy(out, quote_buf->data, *out_length);
+	}
+	return 0;
+}
+
+static int tdx_report_new_locked(struct tsm_report *report)
+{
+	struct tsm_report_desc *desc = &report->desc;
+	size_t length;
+	void *buf;
+	int ret;
+
+	ret = __tdx_guest_quote_get(desc->inblob, desc->inblob_len, &length);
+	if (ret)
+		return ret;
+	buf = kvmemdup(quote_buf->data, length, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	report->outblob = buf;
+	report->outblob_len = length;
+	return 0;
+}
+
 static int tdx_report_new(struct tsm_report *report, void *unused)
 {
 	scoped_cond_guard(mutex_intr, return -EINTR, &quote_lock)
-- 
2.56.0

