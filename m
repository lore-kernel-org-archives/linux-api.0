Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037337;
	b=2abpFaS/q/QeULLhldtHR2LcUtHnr73kGNdENb/LIYj44rEhE9qFQR0SSn61GM+NIltm
	 t7sKvlpvmzn1mJnUVQoW5+uhkSA3QlAnswZSQ27+r6aH8QFu+oviWuSQZv2wAuxLTPidd
	 eMeOdMhoAi+6v6y/qJl5VTftttRXI5ELo8c6IVJEuVkq2I+5g1fGeoCQe8xFEZek3Zo8u
	 I4C96Z1f66JgYg2oetz9HEjjThwih01p6Ob1eenYyaFEKyEDJBhMaIxmfumP8p2Ytnhe0
	 WiOxwvb/KwB6txbketZaToXymJ/tzXILRyddTe4gKNOAM80iHGe7HeFsCyzHLA9AxKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037337;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L1yhfvEqBP7e5XFUmbUnaIa/8XvUMLf0rUD2vnzu2NQ=;
	b=FfnHNZyaMQnMqP0JZf6l3uD6rS8JrdLzX3ElorlHgsilbiXlwlKnP6MMthOTJOB7amtR
	 1KpWvRLLdivq11fI7lrwONPmF+3OFrJVPGrkzudd2GEEKwRibZpm2uH9sEginuOXlKEoK
	 LSuW/jHegJRr69RFIlcV2Vm0zTpiqzlbuO1xV9K6OOqZRIz4MDAeaGkpAwqBvjOE0waFa
	 wjd65zTRn134845mnf8OkxPrCjnqQrva0EZPK8iDZHO68cvIfiTC9BEcHGZBtsViqbkU+
	 CE4NWvmjVrLbydkyChkb63T3irdIq+V+1d10vZBNHofGzTN/LG08i2MR3vbjk4FG/CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=iSvs7k6Y;
	arc=none smtp.remote-ip=209.85.217.42
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1C9606A337
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 21:28:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF1C9606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=iSvs7k6Y
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7cc53938a8fso1247705137.2
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 13:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795037335; x=1795642135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=L1yhfvEqBP7e5XFUmbUnaIa/8XvUMLf0rUD2vnzu2NQ=;
        b=iSvs7k6YwjaxOvBDjp3PksIfFWqgtnS2UWETg9JQuN099NJd1V5afHew59ASHEXl0t
         /SbmR7llhG9ljkHTguJhDUZoA9ca9FbalTO6CTroVmSlRpekw/wR8CcnvQF4cq87YMYh
         mi/Z1Ga/fbnK6PtFPhzw9saeFY4wOdqc2zFxrrF8E1lFBGz3xnRD5chdVSgzoI8qQydz
         5SR8IQcafGMjeFyIm5Tfvk8qwjx2kTdHXGqG2MBjyKwUcrrAECkvG/utfbg2msB8Nnf7
         zSukO7U2vuN9arRWTK9eU1ldf7qlM0rRUB2bEzLnLXlx8rR0zp5zLamEzGabuhN/P/gJ
         /1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037335; x=1795642135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=L1yhfvEqBP7e5XFUmbUnaIa/8XvUMLf0rUD2vnzu2NQ=;
        b=ANMWhaWiTyXBzG14ts9Eq4fMw227X6jYLmWqID2B16rmWehdO2nUhwCBw4um+pN6ME
         enRRdzVdT4PXVXQaoFAt8ZbkxAmiLRpWjhBRQC/k4n3nnlHlrzVUdOlgSDH/w1mSkQ9J
         4UkamLEDK8UpZcDrBQ4+H7dUTKRR59Ttvv89h7D2APTL/UB/8DA0DYB8hipOsIvfazhL
         /ruGjyk8m+E+/BRWpGmeF2HWTBkCUS9QEkHCbMJzzCgSxjC1BNWCiWmudKrxeCu/rXJh
         4vlGnQhsij/HrumSoQrw/7mq5dM6EPM0nCq5BKYhOk3Kl+LaxPr3BSWY+jgjQ6Y4xk5p
         ZqBg==
X-Forwarded-Encrypted: i=1; AL+hErG/IYH0bcspEY8g7Maus1bJn84l4TbHssQ322V0v+p8yqneMTUI63MAJzuNLf1beeffdJswuTpVo/M=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ugs3AC43wuNhWkIFLgAOf4oWQP0A1fRLBYdV4hnQlC6Y8g68+
	kAPh/djgdTdAILgKPpUTajb+KMkVeCL0IFFUJeejzLv+oJt4/A46z6KpFjdO8TdJX/E=
X-Gm-Gg: AYBFou1u0qBBTzCJ1hHlOTS5DMenHo9KQGwbmtcPn/v6sH2/ohOKZOwyJ8bE6hm7tnD
	5tPnrBto9xb3tGXSxFD/r9/kHaYXHZhPmFi7/ODTYbH0YqMfsXc6NISPSat+XdktV44pvaqyCf7
	VayZsCeiHk7Ini152OlW0D0jTX2vGSUGDxqivoOQ9qXy5K8/+y8h1MLUEs2YAthSi6SFkBLIuB7
	yxs2kVb0i1ulgb/SVTZw4rUbYFkSO0G4EGjJxZ4kUPpN6UvOl2c/w84UnPJEwEuLcxvw0QaFh/a
	fuPkkuxwWPkS+gSjr0ErSSqp7gM9AXi255lja7wqTU2lSnKMucvvEyr3gc45ORK+R4SeKFsc91D
	eDrRFpZIH1PXSPXjsHLcDf5srX/rlXU2UwT3gfZKfoKAGTcZPHim17kPfPtXhUC2SwNur2TGvxv
	mcGt4WvpNQudtODhYmCuaTZhfCEo3wlktv6jBCZIUgXuwE11pCaXqgr2II+d4a2+cE5IFpz+Gvk
	sfDUlIujqT0IDnf/TSqc3sbn+LaGKP78hOQLCH1frpfRBro4v7TnBc+HNgZNxqPW956K4rjlotW
	L/FbIaOvYbu7FY8wKsUEu/13kjWTU/R1wUUV0SbGPwn0DA8eA2DacC1nMTLHIvgOY/qyeccc3Yg
	T6+1D7UTvmeBQwreFRusoiP7UCVGzIqEW22/Fwea0SVQp1Y+TBiVwnjV/IddutkDWquw6WRP4uQ
	==
X-Received: by 2002:a67:e113:0:b0:7c3:2b19:6267 with SMTP id ada2fe7eead31-7d6ba46ca11mr1512091137.32.1795037335676;
        Wed, 18 Nov 2026 13:28:55 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6b9185bc3sm2724635137.5.2026.11.18.13.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:28:54 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	linux-api@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v6 7/7] selftests: liveupdate: Test LIVEUPDATE_SESSION_FREEZE across kexec
Date: Wed, 18 Nov 2026 16:28:42 -0500
Message-ID: <20261118212845.2855249-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
In-Reply-To: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
References: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
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

Extend luo_multi_session.c to exercise auto-frozen, kept-open frozen,
closed uncommitted frozen, and closed committed sessions together across
a kexec reboot, and verify that freezing an incoming session returns
-EINVAL.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../selftests/liveupdate/luo_multi_session.c  | 36 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c b/tools/testing/selftests/liveupdate/luo_multi_session.c
index aac24a5f5ce3..3b09cd63c832 100644
--- a/tools/testing/selftests/liveupdate/luo_multi_session.c
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -15,14 +15,17 @@
 #define SESSION_EMPTY_2 "multi-test-empty-2"
 #define SESSION_FILES_1 "multi-test-files-1"
 #define SESSION_FILES_2 "multi-test-files-2"
+#define SESSION_CLOSED "multi-test-closed"
 
 #define MFD1_TOKEN 0x1001
 #define MFD2_TOKEN 0x2002
 #define MFD3_TOKEN 0x3003
+#define MFD_CLOSED_TOKEN 0x4004
 
 #define MFD1_DATA "Data for session files 1"
 #define MFD2_DATA "First file for session files 2"
 #define MFD3_DATA "Second file for session files 2"
+#define MFD_CLOSED_DATA "Closed session data"
 
 #define STATE_SESSION_NAME "kexec_multi_state"
 #define STATE_MEMFD_TOKEN 998
@@ -30,7 +33,7 @@
 /* Stage 1: Executed before the kexec reboot. */
 static void run_stage_1(int luo_fd)
 {
-	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd, s_closed_fd;
 
 	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-session test...\n");
 
@@ -57,6 +60,8 @@ static void run_stage_1(int luo_fd)
 		fail_exit("create_and_preserve_memfd for token %#x",
 			  MFD1_TOKEN);
 	}
+	if (luo_session_freeze(s_files1_fd, 0) < 0)
+		fail_exit("luo_session_freeze for '%s'", SESSION_FILES_1);
 
 	ksft_print_msg("[STAGE 1] Creating session '%s' with two memfds...\n",
 		       SESSION_FILES_2);
@@ -72,6 +77,25 @@ static void run_stage_1(int luo_fd)
 		fail_exit("create_and_preserve_memfd for token %#x",
 			  MFD3_TOKEN);
 	}
+	if (luo_session_freeze(s_files2_fd,
+			       LIVEUPDATE_SESSION_FREEZE_COMMIT) < 0) {
+		fail_exit("luo_session_freeze for '%s'", SESSION_FILES_2);
+	}
+	close(s_files2_fd);
+
+	ksft_print_msg("[STAGE 1] Creating frozen uncommitted session '%s' and closing FD...\n",
+		       SESSION_CLOSED);
+	s_closed_fd = luo_create_session(luo_fd, SESSION_CLOSED);
+	if (s_closed_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_CLOSED);
+	if (create_and_preserve_memfd(s_closed_fd, MFD_CLOSED_TOKEN,
+				      MFD_CLOSED_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD_CLOSED_TOKEN);
+	}
+	if (luo_session_freeze(s_closed_fd, 0) < 0)
+		fail_exit("luo_session_freeze for '%s'", SESSION_CLOSED);
+	close(s_closed_fd);
 
 	close(luo_fd);
 	daemonize_and_wait();
@@ -91,6 +115,13 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 			  stage);
 	}
 
+	ksft_print_msg("[STAGE 2] Verifying closed uncommitted session '%s' was not preserved...\n",
+		       SESSION_CLOSED);
+	if (luo_retrieve_session(luo_fd, SESSION_CLOSED) != -ENOENT) {
+		fail_exit("Expected -ENOENT for closed uncommitted session '%s'",
+			  SESSION_CLOSED);
+	}
+
 	ksft_print_msg("[STAGE 2] Retrieving all sessions...\n");
 	s_empty1_fd = luo_retrieve_session(luo_fd, SESSION_EMPTY_1);
 	if (s_empty1_fd < 0)
@@ -108,6 +139,9 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	if (s_files2_fd < 0)
 		fail_exit("luo_retrieve_session for '%s'", SESSION_FILES_2);
 
+	if (luo_session_freeze(s_files2_fd, 0) != -EINVAL)
+		fail_exit("luo_session_freeze on incoming session did not return -EINVAL");
+
 	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
 		       SESSION_FILES_1);
 	mfd1 = restore_and_verify_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA);
-- 
2.56.1.708.g77570a6a1d-goog

