Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BE14E77EB
	for <linux-api@vger.kernel.org>; Fri,  9 Oct 2026 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791560362; cv=none; b=RDMY5ji0xtf94yx0MTaJHUeo7qBjhYYvICdkYmcO0j0ubd1fmSQGQMvTV1ixJbAl6qrq8U2gSGEuQpKBMxYxt+FZGh/KvTqPrsSKvh2uBaLVBplTlTjLqBLLSII+AU09P6X/Gx93baQvOaTeB49EbM/tjdoxVwrfRp6UUGLWVVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791560362; c=relaxed/simple;
	bh=1Q9ss7gwW7Js4Ee2aM8XMcWq4OPlhdSY81inMwukryk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boSc1dyzYu0JjBRqI4Ypvf7A3UEg/uWx8SEsCGb+nXzQAvzF55By0SYS8CZXBMWOdSS/dHcDgDp37BB5Pfpse9LZKVxORi/pcC49IbZVhHVlGY2UKo0M/dx3MDfRiJilU4mPDmtmi3Y1aGPKKHh3+HClt5eE/76mE7+UoQ6VPWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IpdjYJyX; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpdjYJyX"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc4dbcf2b85so3184734a12.3
        for <linux-api@vger.kernel.org>; Fri, 09 Oct 2026 08:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791560359; x=1792165159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UJr8MEL/MFFt0jx2WIiKTin57SN9MC0NE/wSa+YPiXM=;
        b=IpdjYJyX5XtN+TZxoyXg/WLDk7tMvY0OE9vAMJf89x4J43CRRiT9TUCFr+cSl3kWSe
         L2HTp1GB3a749Q/m9li7e7yX9rFJ75HKQyhivTSavdvUSQ4vvULdZtySGXWIkXyxW+AW
         6231OJkPeM8+xwAaZCx1zYEcgjTen8tHxfCrbosk2d+Np8cTZCb22/bffe6GB2WnxFgG
         7BRo3tTKfgjf8KP+RTK3SzQHwhgo9xlR6B9RtVl1PvQMUF2ifxM6ENELZfRo6wPMDOzf
         LnbfIpa+WaKnaa1turJ1QfsLWWPV/rPUJUcyVe/Gjp6e4B8igDH9mUaP4W7ghDI24y7f
         AyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791560359; x=1792165159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UJr8MEL/MFFt0jx2WIiKTin57SN9MC0NE/wSa+YPiXM=;
        b=fJfD2AU8pvvVk/H7dNu8odWU3AmEuMUue/TEQkcApqXaO6dFIAumaqhF/VvwHI0n1U
         TUscCMU2VnJjlbyaF2ZL4G2o41HjgfpcX/N6rn8SW1pIyc9YasDht3UMcRM7SeZqOrTU
         yt3lyw74Ihm8tUlX0P6iVI7xV3wjn+Wd4F6iX05H0mmKijENqolH8bVTTHfqIV0NJrTd
         a1qAYKREnWlI9+6WUCaZW327+r3FA1MM75vOrQrpx00gw8OzFzkjLYPEFBv/YMKSjkMv
         M4WYk4QEXUOiqmm629igFQO2XT9V//iSWHowRCXhcmVM0CKN0KDFJrSOXm4/P+PeJ6DM
         53GA==
X-Forwarded-Encrypted: i=1; AKwUvBwIRHTERjQo3RfNxAF7zmdN99oKHJcjDz2paYO9WbbTEPbHVq5l+ixBWOaZyiSaUwoUdlDZ07dYyP0=@vger.kernel.org
X-Gm-Message-State: AFq9FYKWC9KoA89XDzIDOaXHS4TTknWBPGt34FRPHEx02awgXHmMPtIY
	siXVP4+3cN26rm3a2OpNrKJxXj9X1MqnyhO6ukfLTKcM6A52QwbDLyv1
X-Gm-Gg: AYBFou1dvkG4P1jaZIFbbH8k9vQ/dY2B9s/68UZxGKYn6dkUHuVJEFJ+HPwUDx89c9E
	UgIiyNdLszYniet1W5uLuq6OzrFt2w8xPWTf0s1o7mNW4rYTLr1aAYwI4+oAUkTmZiaT52e2Fj4
	L43BC7R6GINRB+RvbpZPSYyIyr3tOgBFz2u/BalHbw+WR3NLKpztePg1AapZZTMrtUA/IR7dA2C
	xg989eR+lFUyJdFy61k7RF8jGealZnUIDqYY3K0vaBMoV+3GY7wtyQE9+Gy5+qGG4WvR8e5FWDI
	kEmchFXTf13ovIpKq9i0TwGQULDL+tdNoXqz/K37B3SpcyqaEec7Wud0GWq+v9f1z5CEUerKNSJ
	Yx4SYniL/wuNMk2HQbol1MaVU9gA//XGGwg1T0Agt977b0ElZu480i42N6qzPW890rZ6SAzvog8
	xBuiIpSByZCh5GqZXebk3dv3NYMd8T4AUEyQhCGDO5GEEDIL12SGDsNjFz5Vnel2HR2Yych56lp
	Pwi87M=
X-Received: by 2002:a17:903:41c1:b0:2e5:33a5:36ec with SMTP id d9443c01a7336-2e84280af99mr20072915ad.4.1791560358556;
        Fri, 09 Oct 2026 08:39:18 -0700 (PDT)
Received: from mincom1 ([14.67.155.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421ae999sm11847705ad.31.2026.10.09.08.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:39:18 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] hwmon: Export sensor and attribute definitions to userspace
Date: Sat, 10 Oct 2026 00:38:40 +0900
Message-ID: <583573c30df45e4498737a89138e6f4f8911c631.1791559095.git.hurryman2212@gmail.com>
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

Move sensor types, attribute identifiers and configuration bits to
linux/hwmon.h in the UAPI so kernel and userspace drivers share them.
Keep existing values unchanged and use userspace-safe bit definitions.

Keep operations, channel structures and registration helpers in the
kernel header.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 MAINTAINERS                |   1 +
 include/linux/hwmon.h      | 353 +----------------------------------
 include/uapi/linux/hwmon.h | 372 +++++++++++++++++++++++++++++++++++++
 3 files changed, 374 insertions(+), 352 deletions(-)
 create mode 100644 include/uapi/linux/hwmon.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 65e8a4b5c90b..f3f0292832bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11492,6 +11492,7 @@ F:	Documentation/hwmon/
 F:	drivers/hwmon/
 F:	include/linux/hwmon*.h
 F:	include/trace/events/hwmon*.h
+F:	include/uapi/linux/hwmon.h
 K:	(devm_)?hwmon_device_(un)?register(|_with_groups|_with_info)
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index dd713e193d0c..d48e0aa82bc5 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -14,362 +14,11 @@
 
 #include <linux/bitops.h>
 #include <linux/cleanup.h>
+#include <uapi/linux/hwmon.h>
 
 struct device;
 struct attribute_group;
 
-enum hwmon_sensor_types {
-	hwmon_chip,
-	hwmon_temp,
-	hwmon_in,
-	hwmon_curr,
-	hwmon_power,
-	hwmon_energy,
-	hwmon_energy64,
-	hwmon_humidity,
-	hwmon_fan,
-	hwmon_pwm,
-	hwmon_intrusion,
-	hwmon_max,
-};
-
-enum hwmon_chip_attributes {
-	hwmon_chip_temp_reset_history,
-	hwmon_chip_in_reset_history,
-	hwmon_chip_curr_reset_history,
-	hwmon_chip_power_reset_history,
-	hwmon_chip_register_tz,
-	hwmon_chip_update_interval,
-	hwmon_chip_update_interval_us,
-	hwmon_chip_alarms,
-	hwmon_chip_samples,
-	hwmon_chip_curr_samples,
-	hwmon_chip_in_samples,
-	hwmon_chip_power_samples,
-	hwmon_chip_temp_samples,
-	hwmon_chip_beep_enable,
-	hwmon_chip_pec,
-};
-
-#define HWMON_C_TEMP_RESET_HISTORY	BIT(hwmon_chip_temp_reset_history)
-#define HWMON_C_IN_RESET_HISTORY	BIT(hwmon_chip_in_reset_history)
-#define HWMON_C_CURR_RESET_HISTORY	BIT(hwmon_chip_curr_reset_history)
-#define HWMON_C_POWER_RESET_HISTORY	BIT(hwmon_chip_power_reset_history)
-#define HWMON_C_REGISTER_TZ		BIT(hwmon_chip_register_tz)
-#define HWMON_C_UPDATE_INTERVAL		BIT(hwmon_chip_update_interval)
-#define HWMON_C_UPDATE_INTERVAL_US	BIT(hwmon_chip_update_interval_us)
-#define HWMON_C_ALARMS			BIT(hwmon_chip_alarms)
-#define HWMON_C_SAMPLES			BIT(hwmon_chip_samples)
-#define HWMON_C_CURR_SAMPLES		BIT(hwmon_chip_curr_samples)
-#define HWMON_C_IN_SAMPLES		BIT(hwmon_chip_in_samples)
-#define HWMON_C_POWER_SAMPLES		BIT(hwmon_chip_power_samples)
-#define HWMON_C_TEMP_SAMPLES		BIT(hwmon_chip_temp_samples)
-#define HWMON_C_BEEP_ENABLE		BIT(hwmon_chip_beep_enable)
-#define HWMON_C_PEC			BIT(hwmon_chip_pec)
-
-enum hwmon_temp_attributes {
-	hwmon_temp_enable,
-	hwmon_temp_input,
-	hwmon_temp_type,
-	hwmon_temp_lcrit,
-	hwmon_temp_lcrit_hyst,
-	hwmon_temp_min,
-	hwmon_temp_min_hyst,
-	hwmon_temp_max,
-	hwmon_temp_max_hyst,
-	hwmon_temp_crit,
-	hwmon_temp_crit_hyst,
-	hwmon_temp_emergency,
-	hwmon_temp_emergency_hyst,
-	hwmon_temp_alarm,
-	hwmon_temp_lcrit_alarm,
-	hwmon_temp_min_alarm,
-	hwmon_temp_max_alarm,
-	hwmon_temp_crit_alarm,
-	hwmon_temp_emergency_alarm,
-	hwmon_temp_fault,
-	hwmon_temp_offset,
-	hwmon_temp_label,
-	hwmon_temp_lowest,
-	hwmon_temp_highest,
-	hwmon_temp_reset_history,
-	hwmon_temp_rated_min,
-	hwmon_temp_rated_max,
-	hwmon_temp_beep,
-};
-
-#define HWMON_T_ENABLE		BIT(hwmon_temp_enable)
-#define HWMON_T_INPUT		BIT(hwmon_temp_input)
-#define HWMON_T_TYPE		BIT(hwmon_temp_type)
-#define HWMON_T_LCRIT		BIT(hwmon_temp_lcrit)
-#define HWMON_T_LCRIT_HYST	BIT(hwmon_temp_lcrit_hyst)
-#define HWMON_T_MIN		BIT(hwmon_temp_min)
-#define HWMON_T_MIN_HYST	BIT(hwmon_temp_min_hyst)
-#define HWMON_T_MAX		BIT(hwmon_temp_max)
-#define HWMON_T_MAX_HYST	BIT(hwmon_temp_max_hyst)
-#define HWMON_T_CRIT		BIT(hwmon_temp_crit)
-#define HWMON_T_CRIT_HYST	BIT(hwmon_temp_crit_hyst)
-#define HWMON_T_EMERGENCY	BIT(hwmon_temp_emergency)
-#define HWMON_T_EMERGENCY_HYST	BIT(hwmon_temp_emergency_hyst)
-#define HWMON_T_ALARM		BIT(hwmon_temp_alarm)
-#define HWMON_T_MIN_ALARM	BIT(hwmon_temp_min_alarm)
-#define HWMON_T_MAX_ALARM	BIT(hwmon_temp_max_alarm)
-#define HWMON_T_CRIT_ALARM	BIT(hwmon_temp_crit_alarm)
-#define HWMON_T_LCRIT_ALARM	BIT(hwmon_temp_lcrit_alarm)
-#define HWMON_T_EMERGENCY_ALARM	BIT(hwmon_temp_emergency_alarm)
-#define HWMON_T_FAULT		BIT(hwmon_temp_fault)
-#define HWMON_T_OFFSET		BIT(hwmon_temp_offset)
-#define HWMON_T_LABEL		BIT(hwmon_temp_label)
-#define HWMON_T_LOWEST		BIT(hwmon_temp_lowest)
-#define HWMON_T_HIGHEST		BIT(hwmon_temp_highest)
-#define HWMON_T_RESET_HISTORY	BIT(hwmon_temp_reset_history)
-#define HWMON_T_RATED_MIN	BIT(hwmon_temp_rated_min)
-#define HWMON_T_RATED_MAX	BIT(hwmon_temp_rated_max)
-#define HWMON_T_BEEP		BIT(hwmon_temp_beep)
-
-enum hwmon_in_attributes {
-	hwmon_in_enable,
-	hwmon_in_input,
-	hwmon_in_min,
-	hwmon_in_max,
-	hwmon_in_lcrit,
-	hwmon_in_crit,
-	hwmon_in_average,
-	hwmon_in_lowest,
-	hwmon_in_highest,
-	hwmon_in_reset_history,
-	hwmon_in_label,
-	hwmon_in_alarm,
-	hwmon_in_min_alarm,
-	hwmon_in_max_alarm,
-	hwmon_in_lcrit_alarm,
-	hwmon_in_crit_alarm,
-	hwmon_in_rated_min,
-	hwmon_in_rated_max,
-	hwmon_in_beep,
-	hwmon_in_fault,
-};
-
-#define HWMON_I_ENABLE		BIT(hwmon_in_enable)
-#define HWMON_I_INPUT		BIT(hwmon_in_input)
-#define HWMON_I_MIN		BIT(hwmon_in_min)
-#define HWMON_I_MAX		BIT(hwmon_in_max)
-#define HWMON_I_LCRIT		BIT(hwmon_in_lcrit)
-#define HWMON_I_CRIT		BIT(hwmon_in_crit)
-#define HWMON_I_AVERAGE		BIT(hwmon_in_average)
-#define HWMON_I_LOWEST		BIT(hwmon_in_lowest)
-#define HWMON_I_HIGHEST		BIT(hwmon_in_highest)
-#define HWMON_I_RESET_HISTORY	BIT(hwmon_in_reset_history)
-#define HWMON_I_LABEL		BIT(hwmon_in_label)
-#define HWMON_I_ALARM		BIT(hwmon_in_alarm)
-#define HWMON_I_MIN_ALARM	BIT(hwmon_in_min_alarm)
-#define HWMON_I_MAX_ALARM	BIT(hwmon_in_max_alarm)
-#define HWMON_I_LCRIT_ALARM	BIT(hwmon_in_lcrit_alarm)
-#define HWMON_I_CRIT_ALARM	BIT(hwmon_in_crit_alarm)
-#define HWMON_I_RATED_MIN	BIT(hwmon_in_rated_min)
-#define HWMON_I_RATED_MAX	BIT(hwmon_in_rated_max)
-#define HWMON_I_BEEP		BIT(hwmon_in_beep)
-#define HWMON_I_FAULT		BIT(hwmon_in_fault)
-
-enum hwmon_curr_attributes {
-	hwmon_curr_enable,
-	hwmon_curr_input,
-	hwmon_curr_min,
-	hwmon_curr_max,
-	hwmon_curr_lcrit,
-	hwmon_curr_crit,
-	hwmon_curr_average,
-	hwmon_curr_lowest,
-	hwmon_curr_highest,
-	hwmon_curr_reset_history,
-	hwmon_curr_label,
-	hwmon_curr_alarm,
-	hwmon_curr_min_alarm,
-	hwmon_curr_max_alarm,
-	hwmon_curr_lcrit_alarm,
-	hwmon_curr_crit_alarm,
-	hwmon_curr_rated_min,
-	hwmon_curr_rated_max,
-	hwmon_curr_beep,
-};
-
-#define HWMON_C_ENABLE		BIT(hwmon_curr_enable)
-#define HWMON_C_INPUT		BIT(hwmon_curr_input)
-#define HWMON_C_MIN		BIT(hwmon_curr_min)
-#define HWMON_C_MAX		BIT(hwmon_curr_max)
-#define HWMON_C_LCRIT		BIT(hwmon_curr_lcrit)
-#define HWMON_C_CRIT		BIT(hwmon_curr_crit)
-#define HWMON_C_AVERAGE		BIT(hwmon_curr_average)
-#define HWMON_C_LOWEST		BIT(hwmon_curr_lowest)
-#define HWMON_C_HIGHEST		BIT(hwmon_curr_highest)
-#define HWMON_C_RESET_HISTORY	BIT(hwmon_curr_reset_history)
-#define HWMON_C_LABEL		BIT(hwmon_curr_label)
-#define HWMON_C_ALARM		BIT(hwmon_curr_alarm)
-#define HWMON_C_MIN_ALARM	BIT(hwmon_curr_min_alarm)
-#define HWMON_C_MAX_ALARM	BIT(hwmon_curr_max_alarm)
-#define HWMON_C_LCRIT_ALARM	BIT(hwmon_curr_lcrit_alarm)
-#define HWMON_C_CRIT_ALARM	BIT(hwmon_curr_crit_alarm)
-#define HWMON_C_RATED_MIN	BIT(hwmon_curr_rated_min)
-#define HWMON_C_RATED_MAX	BIT(hwmon_curr_rated_max)
-#define HWMON_C_BEEP		BIT(hwmon_curr_beep)
-
-enum hwmon_power_attributes {
-	hwmon_power_enable,
-	hwmon_power_average,
-	hwmon_power_average_interval,
-	hwmon_power_average_interval_max,
-	hwmon_power_average_interval_min,
-	hwmon_power_average_highest,
-	hwmon_power_average_lowest,
-	hwmon_power_average_max,
-	hwmon_power_average_min,
-	hwmon_power_input,
-	hwmon_power_input_highest,
-	hwmon_power_input_lowest,
-	hwmon_power_reset_history,
-	hwmon_power_accuracy,
-	hwmon_power_cap,
-	hwmon_power_cap_hyst,
-	hwmon_power_cap_max,
-	hwmon_power_cap_min,
-	hwmon_power_min,
-	hwmon_power_max,
-	hwmon_power_crit,
-	hwmon_power_lcrit,
-	hwmon_power_label,
-	hwmon_power_alarm,
-	hwmon_power_cap_alarm,
-	hwmon_power_min_alarm,
-	hwmon_power_max_alarm,
-	hwmon_power_lcrit_alarm,
-	hwmon_power_crit_alarm,
-	hwmon_power_rated_min,
-	hwmon_power_rated_max,
-};
-
-#define HWMON_P_ENABLE			BIT(hwmon_power_enable)
-#define HWMON_P_AVERAGE			BIT(hwmon_power_average)
-#define HWMON_P_AVERAGE_INTERVAL	BIT(hwmon_power_average_interval)
-#define HWMON_P_AVERAGE_INTERVAL_MAX	BIT(hwmon_power_average_interval_max)
-#define HWMON_P_AVERAGE_INTERVAL_MIN	BIT(hwmon_power_average_interval_min)
-#define HWMON_P_AVERAGE_HIGHEST		BIT(hwmon_power_average_highest)
-#define HWMON_P_AVERAGE_LOWEST		BIT(hwmon_power_average_lowest)
-#define HWMON_P_AVERAGE_MAX		BIT(hwmon_power_average_max)
-#define HWMON_P_AVERAGE_MIN		BIT(hwmon_power_average_min)
-#define HWMON_P_INPUT			BIT(hwmon_power_input)
-#define HWMON_P_INPUT_HIGHEST		BIT(hwmon_power_input_highest)
-#define HWMON_P_INPUT_LOWEST		BIT(hwmon_power_input_lowest)
-#define HWMON_P_RESET_HISTORY		BIT(hwmon_power_reset_history)
-#define HWMON_P_ACCURACY		BIT(hwmon_power_accuracy)
-#define HWMON_P_CAP			BIT(hwmon_power_cap)
-#define HWMON_P_CAP_HYST		BIT(hwmon_power_cap_hyst)
-#define HWMON_P_CAP_MAX			BIT(hwmon_power_cap_max)
-#define HWMON_P_CAP_MIN			BIT(hwmon_power_cap_min)
-#define HWMON_P_MIN			BIT(hwmon_power_min)
-#define HWMON_P_MAX			BIT(hwmon_power_max)
-#define HWMON_P_LCRIT			BIT(hwmon_power_lcrit)
-#define HWMON_P_CRIT			BIT(hwmon_power_crit)
-#define HWMON_P_LABEL			BIT(hwmon_power_label)
-#define HWMON_P_ALARM			BIT(hwmon_power_alarm)
-#define HWMON_P_CAP_ALARM		BIT(hwmon_power_cap_alarm)
-#define HWMON_P_MIN_ALARM		BIT(hwmon_power_min_alarm)
-#define HWMON_P_MAX_ALARM		BIT(hwmon_power_max_alarm)
-#define HWMON_P_LCRIT_ALARM		BIT(hwmon_power_lcrit_alarm)
-#define HWMON_P_CRIT_ALARM		BIT(hwmon_power_crit_alarm)
-#define HWMON_P_RATED_MIN		BIT(hwmon_power_rated_min)
-#define HWMON_P_RATED_MAX		BIT(hwmon_power_rated_max)
-
-enum hwmon_energy_attributes {
-	hwmon_energy_enable,
-	hwmon_energy_input,
-	hwmon_energy_label,
-};
-
-#define HWMON_E_ENABLE			BIT(hwmon_energy_enable)
-#define HWMON_E_INPUT			BIT(hwmon_energy_input)
-#define HWMON_E_LABEL			BIT(hwmon_energy_label)
-
-enum hwmon_humidity_attributes {
-	hwmon_humidity_enable,
-	hwmon_humidity_input,
-	hwmon_humidity_label,
-	hwmon_humidity_min,
-	hwmon_humidity_min_hyst,
-	hwmon_humidity_max,
-	hwmon_humidity_max_hyst,
-	hwmon_humidity_alarm,
-	hwmon_humidity_fault,
-	hwmon_humidity_rated_min,
-	hwmon_humidity_rated_max,
-	hwmon_humidity_min_alarm,
-	hwmon_humidity_max_alarm,
-};
-
-#define HWMON_H_ENABLE			BIT(hwmon_humidity_enable)
-#define HWMON_H_INPUT			BIT(hwmon_humidity_input)
-#define HWMON_H_LABEL			BIT(hwmon_humidity_label)
-#define HWMON_H_MIN			BIT(hwmon_humidity_min)
-#define HWMON_H_MIN_HYST		BIT(hwmon_humidity_min_hyst)
-#define HWMON_H_MAX			BIT(hwmon_humidity_max)
-#define HWMON_H_MAX_HYST		BIT(hwmon_humidity_max_hyst)
-#define HWMON_H_ALARM			BIT(hwmon_humidity_alarm)
-#define HWMON_H_FAULT			BIT(hwmon_humidity_fault)
-#define HWMON_H_RATED_MIN		BIT(hwmon_humidity_rated_min)
-#define HWMON_H_RATED_MAX		BIT(hwmon_humidity_rated_max)
-#define HWMON_H_MIN_ALARM		BIT(hwmon_humidity_min_alarm)
-#define HWMON_H_MAX_ALARM		BIT(hwmon_humidity_max_alarm)
-
-enum hwmon_fan_attributes {
-	hwmon_fan_enable,
-	hwmon_fan_input,
-	hwmon_fan_label,
-	hwmon_fan_min,
-	hwmon_fan_max,
-	hwmon_fan_div,
-	hwmon_fan_pulses,
-	hwmon_fan_target,
-	hwmon_fan_alarm,
-	hwmon_fan_min_alarm,
-	hwmon_fan_max_alarm,
-	hwmon_fan_fault,
-	hwmon_fan_beep,
-};
-
-#define HWMON_F_ENABLE			BIT(hwmon_fan_enable)
-#define HWMON_F_INPUT			BIT(hwmon_fan_input)
-#define HWMON_F_LABEL			BIT(hwmon_fan_label)
-#define HWMON_F_MIN			BIT(hwmon_fan_min)
-#define HWMON_F_MAX			BIT(hwmon_fan_max)
-#define HWMON_F_DIV			BIT(hwmon_fan_div)
-#define HWMON_F_PULSES			BIT(hwmon_fan_pulses)
-#define HWMON_F_TARGET			BIT(hwmon_fan_target)
-#define HWMON_F_ALARM			BIT(hwmon_fan_alarm)
-#define HWMON_F_MIN_ALARM		BIT(hwmon_fan_min_alarm)
-#define HWMON_F_MAX_ALARM		BIT(hwmon_fan_max_alarm)
-#define HWMON_F_FAULT			BIT(hwmon_fan_fault)
-#define HWMON_F_BEEP			BIT(hwmon_fan_beep)
-
-enum hwmon_pwm_attributes {
-	hwmon_pwm_input,
-	hwmon_pwm_enable,
-	hwmon_pwm_mode,
-	hwmon_pwm_freq,
-	hwmon_pwm_auto_channels_temp,
-};
-
-#define HWMON_PWM_INPUT			BIT(hwmon_pwm_input)
-#define HWMON_PWM_ENABLE		BIT(hwmon_pwm_enable)
-#define HWMON_PWM_MODE			BIT(hwmon_pwm_mode)
-#define HWMON_PWM_FREQ			BIT(hwmon_pwm_freq)
-#define HWMON_PWM_AUTO_CHANNELS_TEMP	BIT(hwmon_pwm_auto_channels_temp)
-
-enum hwmon_intrusion_attributes {
-	hwmon_intrusion_alarm,
-	hwmon_intrusion_beep,
-};
-#define HWMON_INTRUSION_ALARM		BIT(hwmon_intrusion_alarm)
-#define HWMON_INTRUSION_BEEP		BIT(hwmon_intrusion_beep)
-
 /**
  * struct hwmon_ops - hwmon device operations
  * @visible:	Static visibility. If non-zero, 'is_visible' is ignored.
diff --git a/include/uapi/linux/hwmon.h b/include/uapi/linux/hwmon.h
new file mode 100644
index 000000000000..274f9c9dcb87
--- /dev/null
+++ b/include/uapi/linux/hwmon.h
@@ -0,0 +1,372 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Hardware monitoring sensor types, attributes and configuration bits.
+ *
+ * Copyright (C) 2005 Mark M. Hoffman <mhoffman@lightlink.com>
+ * Copyright (C) 2026 Jihong Min <hurryman2212@gmail.com>
+ */
+
+#ifndef _UAPI_LINUX_HWMON_H
+#define _UAPI_LINUX_HWMON_H
+
+#include <linux/const.h>
+
+/*
+ * Existing identifiers are ABI: never change their values. Append new attributes
+ * at the end of their enum and new sensor types before hwmon_max.
+ */
+
+enum hwmon_sensor_types {
+	hwmon_chip = 0,
+	hwmon_temp = 1,
+	hwmon_in = 2,
+	hwmon_curr = 3,
+	hwmon_power = 4,
+	hwmon_energy = 5,
+	hwmon_energy64 = 6,
+	hwmon_humidity = 7,
+	hwmon_fan = 8,
+	hwmon_pwm = 9,
+	hwmon_intrusion = 10,
+	hwmon_max = 11,
+};
+
+enum hwmon_chip_attributes {
+	hwmon_chip_temp_reset_history = 0,
+	hwmon_chip_in_reset_history = 1,
+	hwmon_chip_curr_reset_history = 2,
+	hwmon_chip_power_reset_history = 3,
+	hwmon_chip_register_tz = 4,
+	hwmon_chip_update_interval = 5,
+	hwmon_chip_update_interval_us = 6,
+	hwmon_chip_alarms = 7,
+	hwmon_chip_samples = 8,
+	hwmon_chip_curr_samples = 9,
+	hwmon_chip_in_samples = 10,
+	hwmon_chip_power_samples = 11,
+	hwmon_chip_temp_samples = 12,
+	hwmon_chip_beep_enable = 13,
+	hwmon_chip_pec = 14,
+};
+
+#define HWMON_C_TEMP_RESET_HISTORY _BITUL(hwmon_chip_temp_reset_history)
+#define HWMON_C_IN_RESET_HISTORY _BITUL(hwmon_chip_in_reset_history)
+#define HWMON_C_CURR_RESET_HISTORY _BITUL(hwmon_chip_curr_reset_history)
+#define HWMON_C_POWER_RESET_HISTORY _BITUL(hwmon_chip_power_reset_history)
+#define HWMON_C_REGISTER_TZ _BITUL(hwmon_chip_register_tz)
+#define HWMON_C_UPDATE_INTERVAL _BITUL(hwmon_chip_update_interval)
+#define HWMON_C_UPDATE_INTERVAL_US _BITUL(hwmon_chip_update_interval_us)
+#define HWMON_C_ALARMS _BITUL(hwmon_chip_alarms)
+#define HWMON_C_SAMPLES _BITUL(hwmon_chip_samples)
+#define HWMON_C_CURR_SAMPLES _BITUL(hwmon_chip_curr_samples)
+#define HWMON_C_IN_SAMPLES _BITUL(hwmon_chip_in_samples)
+#define HWMON_C_POWER_SAMPLES _BITUL(hwmon_chip_power_samples)
+#define HWMON_C_TEMP_SAMPLES _BITUL(hwmon_chip_temp_samples)
+#define HWMON_C_BEEP_ENABLE _BITUL(hwmon_chip_beep_enable)
+#define HWMON_C_PEC _BITUL(hwmon_chip_pec)
+
+enum hwmon_temp_attributes {
+	hwmon_temp_enable = 0,
+	hwmon_temp_input = 1,
+	hwmon_temp_type = 2,
+	hwmon_temp_lcrit = 3,
+	hwmon_temp_lcrit_hyst = 4,
+	hwmon_temp_min = 5,
+	hwmon_temp_min_hyst = 6,
+	hwmon_temp_max = 7,
+	hwmon_temp_max_hyst = 8,
+	hwmon_temp_crit = 9,
+	hwmon_temp_crit_hyst = 10,
+	hwmon_temp_emergency = 11,
+	hwmon_temp_emergency_hyst = 12,
+	hwmon_temp_alarm = 13,
+	hwmon_temp_lcrit_alarm = 14,
+	hwmon_temp_min_alarm = 15,
+	hwmon_temp_max_alarm = 16,
+	hwmon_temp_crit_alarm = 17,
+	hwmon_temp_emergency_alarm = 18,
+	hwmon_temp_fault = 19,
+	hwmon_temp_offset = 20,
+	hwmon_temp_label = 21,
+	hwmon_temp_lowest = 22,
+	hwmon_temp_highest = 23,
+	hwmon_temp_reset_history = 24,
+	hwmon_temp_rated_min = 25,
+	hwmon_temp_rated_max = 26,
+	hwmon_temp_beep = 27,
+};
+
+#define HWMON_T_ENABLE _BITUL(hwmon_temp_enable)
+#define HWMON_T_INPUT _BITUL(hwmon_temp_input)
+#define HWMON_T_TYPE _BITUL(hwmon_temp_type)
+#define HWMON_T_LCRIT _BITUL(hwmon_temp_lcrit)
+#define HWMON_T_LCRIT_HYST _BITUL(hwmon_temp_lcrit_hyst)
+#define HWMON_T_MIN _BITUL(hwmon_temp_min)
+#define HWMON_T_MIN_HYST _BITUL(hwmon_temp_min_hyst)
+#define HWMON_T_MAX _BITUL(hwmon_temp_max)
+#define HWMON_T_MAX_HYST _BITUL(hwmon_temp_max_hyst)
+#define HWMON_T_CRIT _BITUL(hwmon_temp_crit)
+#define HWMON_T_CRIT_HYST _BITUL(hwmon_temp_crit_hyst)
+#define HWMON_T_EMERGENCY _BITUL(hwmon_temp_emergency)
+#define HWMON_T_EMERGENCY_HYST _BITUL(hwmon_temp_emergency_hyst)
+#define HWMON_T_ALARM _BITUL(hwmon_temp_alarm)
+#define HWMON_T_MIN_ALARM _BITUL(hwmon_temp_min_alarm)
+#define HWMON_T_MAX_ALARM _BITUL(hwmon_temp_max_alarm)
+#define HWMON_T_CRIT_ALARM _BITUL(hwmon_temp_crit_alarm)
+#define HWMON_T_LCRIT_ALARM _BITUL(hwmon_temp_lcrit_alarm)
+#define HWMON_T_EMERGENCY_ALARM _BITUL(hwmon_temp_emergency_alarm)
+#define HWMON_T_FAULT _BITUL(hwmon_temp_fault)
+#define HWMON_T_OFFSET _BITUL(hwmon_temp_offset)
+#define HWMON_T_LABEL _BITUL(hwmon_temp_label)
+#define HWMON_T_LOWEST _BITUL(hwmon_temp_lowest)
+#define HWMON_T_HIGHEST _BITUL(hwmon_temp_highest)
+#define HWMON_T_RESET_HISTORY _BITUL(hwmon_temp_reset_history)
+#define HWMON_T_RATED_MIN _BITUL(hwmon_temp_rated_min)
+#define HWMON_T_RATED_MAX _BITUL(hwmon_temp_rated_max)
+#define HWMON_T_BEEP _BITUL(hwmon_temp_beep)
+
+enum hwmon_in_attributes {
+	hwmon_in_enable = 0,
+	hwmon_in_input = 1,
+	hwmon_in_min = 2,
+	hwmon_in_max = 3,
+	hwmon_in_lcrit = 4,
+	hwmon_in_crit = 5,
+	hwmon_in_average = 6,
+	hwmon_in_lowest = 7,
+	hwmon_in_highest = 8,
+	hwmon_in_reset_history = 9,
+	hwmon_in_label = 10,
+	hwmon_in_alarm = 11,
+	hwmon_in_min_alarm = 12,
+	hwmon_in_max_alarm = 13,
+	hwmon_in_lcrit_alarm = 14,
+	hwmon_in_crit_alarm = 15,
+	hwmon_in_rated_min = 16,
+	hwmon_in_rated_max = 17,
+	hwmon_in_beep = 18,
+	hwmon_in_fault = 19,
+};
+
+#define HWMON_I_ENABLE _BITUL(hwmon_in_enable)
+#define HWMON_I_INPUT _BITUL(hwmon_in_input)
+#define HWMON_I_MIN _BITUL(hwmon_in_min)
+#define HWMON_I_MAX _BITUL(hwmon_in_max)
+#define HWMON_I_LCRIT _BITUL(hwmon_in_lcrit)
+#define HWMON_I_CRIT _BITUL(hwmon_in_crit)
+#define HWMON_I_AVERAGE _BITUL(hwmon_in_average)
+#define HWMON_I_LOWEST _BITUL(hwmon_in_lowest)
+#define HWMON_I_HIGHEST _BITUL(hwmon_in_highest)
+#define HWMON_I_RESET_HISTORY _BITUL(hwmon_in_reset_history)
+#define HWMON_I_LABEL _BITUL(hwmon_in_label)
+#define HWMON_I_ALARM _BITUL(hwmon_in_alarm)
+#define HWMON_I_MIN_ALARM _BITUL(hwmon_in_min_alarm)
+#define HWMON_I_MAX_ALARM _BITUL(hwmon_in_max_alarm)
+#define HWMON_I_LCRIT_ALARM _BITUL(hwmon_in_lcrit_alarm)
+#define HWMON_I_CRIT_ALARM _BITUL(hwmon_in_crit_alarm)
+#define HWMON_I_RATED_MIN _BITUL(hwmon_in_rated_min)
+#define HWMON_I_RATED_MAX _BITUL(hwmon_in_rated_max)
+#define HWMON_I_BEEP _BITUL(hwmon_in_beep)
+#define HWMON_I_FAULT _BITUL(hwmon_in_fault)
+
+enum hwmon_curr_attributes {
+	hwmon_curr_enable = 0,
+	hwmon_curr_input = 1,
+	hwmon_curr_min = 2,
+	hwmon_curr_max = 3,
+	hwmon_curr_lcrit = 4,
+	hwmon_curr_crit = 5,
+	hwmon_curr_average = 6,
+	hwmon_curr_lowest = 7,
+	hwmon_curr_highest = 8,
+	hwmon_curr_reset_history = 9,
+	hwmon_curr_label = 10,
+	hwmon_curr_alarm = 11,
+	hwmon_curr_min_alarm = 12,
+	hwmon_curr_max_alarm = 13,
+	hwmon_curr_lcrit_alarm = 14,
+	hwmon_curr_crit_alarm = 15,
+	hwmon_curr_rated_min = 16,
+	hwmon_curr_rated_max = 17,
+	hwmon_curr_beep = 18,
+};
+
+#define HWMON_C_ENABLE _BITUL(hwmon_curr_enable)
+#define HWMON_C_INPUT _BITUL(hwmon_curr_input)
+#define HWMON_C_MIN _BITUL(hwmon_curr_min)
+#define HWMON_C_MAX _BITUL(hwmon_curr_max)
+#define HWMON_C_LCRIT _BITUL(hwmon_curr_lcrit)
+#define HWMON_C_CRIT _BITUL(hwmon_curr_crit)
+#define HWMON_C_AVERAGE _BITUL(hwmon_curr_average)
+#define HWMON_C_LOWEST _BITUL(hwmon_curr_lowest)
+#define HWMON_C_HIGHEST _BITUL(hwmon_curr_highest)
+#define HWMON_C_RESET_HISTORY _BITUL(hwmon_curr_reset_history)
+#define HWMON_C_LABEL _BITUL(hwmon_curr_label)
+#define HWMON_C_ALARM _BITUL(hwmon_curr_alarm)
+#define HWMON_C_MIN_ALARM _BITUL(hwmon_curr_min_alarm)
+#define HWMON_C_MAX_ALARM _BITUL(hwmon_curr_max_alarm)
+#define HWMON_C_LCRIT_ALARM _BITUL(hwmon_curr_lcrit_alarm)
+#define HWMON_C_CRIT_ALARM _BITUL(hwmon_curr_crit_alarm)
+#define HWMON_C_RATED_MIN _BITUL(hwmon_curr_rated_min)
+#define HWMON_C_RATED_MAX _BITUL(hwmon_curr_rated_max)
+#define HWMON_C_BEEP _BITUL(hwmon_curr_beep)
+
+enum hwmon_power_attributes {
+	hwmon_power_enable = 0,
+	hwmon_power_average = 1,
+	hwmon_power_average_interval = 2,
+	hwmon_power_average_interval_max = 3,
+	hwmon_power_average_interval_min = 4,
+	hwmon_power_average_highest = 5,
+	hwmon_power_average_lowest = 6,
+	hwmon_power_average_max = 7,
+	hwmon_power_average_min = 8,
+	hwmon_power_input = 9,
+	hwmon_power_input_highest = 10,
+	hwmon_power_input_lowest = 11,
+	hwmon_power_reset_history = 12,
+	hwmon_power_accuracy = 13,
+	hwmon_power_cap = 14,
+	hwmon_power_cap_hyst = 15,
+	hwmon_power_cap_max = 16,
+	hwmon_power_cap_min = 17,
+	hwmon_power_min = 18,
+	hwmon_power_max = 19,
+	hwmon_power_crit = 20,
+	hwmon_power_lcrit = 21,
+	hwmon_power_label = 22,
+	hwmon_power_alarm = 23,
+	hwmon_power_cap_alarm = 24,
+	hwmon_power_min_alarm = 25,
+	hwmon_power_max_alarm = 26,
+	hwmon_power_lcrit_alarm = 27,
+	hwmon_power_crit_alarm = 28,
+	hwmon_power_rated_min = 29,
+	hwmon_power_rated_max = 30,
+};
+
+#define HWMON_P_ENABLE _BITUL(hwmon_power_enable)
+#define HWMON_P_AVERAGE _BITUL(hwmon_power_average)
+#define HWMON_P_AVERAGE_INTERVAL _BITUL(hwmon_power_average_interval)
+#define HWMON_P_AVERAGE_INTERVAL_MAX _BITUL(hwmon_power_average_interval_max)
+#define HWMON_P_AVERAGE_INTERVAL_MIN _BITUL(hwmon_power_average_interval_min)
+#define HWMON_P_AVERAGE_HIGHEST _BITUL(hwmon_power_average_highest)
+#define HWMON_P_AVERAGE_LOWEST _BITUL(hwmon_power_average_lowest)
+#define HWMON_P_AVERAGE_MAX _BITUL(hwmon_power_average_max)
+#define HWMON_P_AVERAGE_MIN _BITUL(hwmon_power_average_min)
+#define HWMON_P_INPUT _BITUL(hwmon_power_input)
+#define HWMON_P_INPUT_HIGHEST _BITUL(hwmon_power_input_highest)
+#define HWMON_P_INPUT_LOWEST _BITUL(hwmon_power_input_lowest)
+#define HWMON_P_RESET_HISTORY _BITUL(hwmon_power_reset_history)
+#define HWMON_P_ACCURACY _BITUL(hwmon_power_accuracy)
+#define HWMON_P_CAP _BITUL(hwmon_power_cap)
+#define HWMON_P_CAP_HYST _BITUL(hwmon_power_cap_hyst)
+#define HWMON_P_CAP_MAX _BITUL(hwmon_power_cap_max)
+#define HWMON_P_CAP_MIN _BITUL(hwmon_power_cap_min)
+#define HWMON_P_MIN _BITUL(hwmon_power_min)
+#define HWMON_P_MAX _BITUL(hwmon_power_max)
+#define HWMON_P_LCRIT _BITUL(hwmon_power_lcrit)
+#define HWMON_P_CRIT _BITUL(hwmon_power_crit)
+#define HWMON_P_LABEL _BITUL(hwmon_power_label)
+#define HWMON_P_ALARM _BITUL(hwmon_power_alarm)
+#define HWMON_P_CAP_ALARM _BITUL(hwmon_power_cap_alarm)
+#define HWMON_P_MIN_ALARM _BITUL(hwmon_power_min_alarm)
+#define HWMON_P_MAX_ALARM _BITUL(hwmon_power_max_alarm)
+#define HWMON_P_LCRIT_ALARM _BITUL(hwmon_power_lcrit_alarm)
+#define HWMON_P_CRIT_ALARM _BITUL(hwmon_power_crit_alarm)
+#define HWMON_P_RATED_MIN _BITUL(hwmon_power_rated_min)
+#define HWMON_P_RATED_MAX _BITUL(hwmon_power_rated_max)
+
+enum hwmon_energy_attributes {
+	hwmon_energy_enable = 0,
+	hwmon_energy_input = 1,
+	hwmon_energy_label = 2,
+};
+
+#define HWMON_E_ENABLE _BITUL(hwmon_energy_enable)
+#define HWMON_E_INPUT _BITUL(hwmon_energy_input)
+#define HWMON_E_LABEL _BITUL(hwmon_energy_label)
+
+enum hwmon_humidity_attributes {
+	hwmon_humidity_enable = 0,
+	hwmon_humidity_input = 1,
+	hwmon_humidity_label = 2,
+	hwmon_humidity_min = 3,
+	hwmon_humidity_min_hyst = 4,
+	hwmon_humidity_max = 5,
+	hwmon_humidity_max_hyst = 6,
+	hwmon_humidity_alarm = 7,
+	hwmon_humidity_fault = 8,
+	hwmon_humidity_rated_min = 9,
+	hwmon_humidity_rated_max = 10,
+	hwmon_humidity_min_alarm = 11,
+	hwmon_humidity_max_alarm = 12,
+};
+
+#define HWMON_H_ENABLE _BITUL(hwmon_humidity_enable)
+#define HWMON_H_INPUT _BITUL(hwmon_humidity_input)
+#define HWMON_H_LABEL _BITUL(hwmon_humidity_label)
+#define HWMON_H_MIN _BITUL(hwmon_humidity_min)
+#define HWMON_H_MIN_HYST _BITUL(hwmon_humidity_min_hyst)
+#define HWMON_H_MAX _BITUL(hwmon_humidity_max)
+#define HWMON_H_MAX_HYST _BITUL(hwmon_humidity_max_hyst)
+#define HWMON_H_ALARM _BITUL(hwmon_humidity_alarm)
+#define HWMON_H_FAULT _BITUL(hwmon_humidity_fault)
+#define HWMON_H_RATED_MIN _BITUL(hwmon_humidity_rated_min)
+#define HWMON_H_RATED_MAX _BITUL(hwmon_humidity_rated_max)
+#define HWMON_H_MIN_ALARM _BITUL(hwmon_humidity_min_alarm)
+#define HWMON_H_MAX_ALARM _BITUL(hwmon_humidity_max_alarm)
+
+enum hwmon_fan_attributes {
+	hwmon_fan_enable = 0,
+	hwmon_fan_input = 1,
+	hwmon_fan_label = 2,
+	hwmon_fan_min = 3,
+	hwmon_fan_max = 4,
+	hwmon_fan_div = 5,
+	hwmon_fan_pulses = 6,
+	hwmon_fan_target = 7,
+	hwmon_fan_alarm = 8,
+	hwmon_fan_min_alarm = 9,
+	hwmon_fan_max_alarm = 10,
+	hwmon_fan_fault = 11,
+	hwmon_fan_beep = 12,
+};
+
+#define HWMON_F_ENABLE _BITUL(hwmon_fan_enable)
+#define HWMON_F_INPUT _BITUL(hwmon_fan_input)
+#define HWMON_F_LABEL _BITUL(hwmon_fan_label)
+#define HWMON_F_MIN _BITUL(hwmon_fan_min)
+#define HWMON_F_MAX _BITUL(hwmon_fan_max)
+#define HWMON_F_DIV _BITUL(hwmon_fan_div)
+#define HWMON_F_PULSES _BITUL(hwmon_fan_pulses)
+#define HWMON_F_TARGET _BITUL(hwmon_fan_target)
+#define HWMON_F_ALARM _BITUL(hwmon_fan_alarm)
+#define HWMON_F_MIN_ALARM _BITUL(hwmon_fan_min_alarm)
+#define HWMON_F_MAX_ALARM _BITUL(hwmon_fan_max_alarm)
+#define HWMON_F_FAULT _BITUL(hwmon_fan_fault)
+#define HWMON_F_BEEP _BITUL(hwmon_fan_beep)
+
+enum hwmon_pwm_attributes {
+	hwmon_pwm_input = 0,
+	hwmon_pwm_enable = 1,
+	hwmon_pwm_mode = 2,
+	hwmon_pwm_freq = 3,
+	hwmon_pwm_auto_channels_temp = 4,
+};
+
+#define HWMON_PWM_INPUT _BITUL(hwmon_pwm_input)
+#define HWMON_PWM_ENABLE _BITUL(hwmon_pwm_enable)
+#define HWMON_PWM_MODE _BITUL(hwmon_pwm_mode)
+#define HWMON_PWM_FREQ _BITUL(hwmon_pwm_freq)
+#define HWMON_PWM_AUTO_CHANNELS_TEMP _BITUL(hwmon_pwm_auto_channels_temp)
+
+enum hwmon_intrusion_attributes {
+	hwmon_intrusion_alarm = 0,
+	hwmon_intrusion_beep = 1,
+};
+
+#define HWMON_INTRUSION_ALARM _BITUL(hwmon_intrusion_alarm)
+#define HWMON_INTRUSION_BEEP _BITUL(hwmon_intrusion_beep)
+
+#endif /* _UAPI_LINUX_HWMON_H */
