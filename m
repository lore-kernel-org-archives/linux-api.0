Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B671C433EF
	for <linux-api@archiver.kernel.org>; Wed, 16 Feb 2022 15:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiBPP7a (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 16 Feb 2022 10:59:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbiBPP7a (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 16 Feb 2022 10:59:30 -0500
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012012A797F;
        Wed, 16 Feb 2022 07:59:17 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:58066)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMi4-009INm-QR; Wed, 16 Feb 2022 08:59:16 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37452 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMi3-002YPH-F4; Wed, 16 Feb 2022 08:59:16 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Wed, 16 Feb 2022 09:58:32 -0600
Message-Id: <20220216155832.680775-5-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nKMi3-002YPH-F4;;;mid=<20220216155832.680775-5-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/+Ki8jT8CUWv1olHpIGtHW6IqQTF2AmAU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v2 5/5] ucounts: Handle wrapping in is_ucounts_overlimit
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

While examining is_ucounts_overlimit and reading the various messages
I realized that is_ucounts_overlimit fails to deal with counts that
may have wrapped.

Being wrapped should be a transitory state for counts and they should
never be wrapped for long, but it can happen so handle it.

Cc: stable@vger.kernel.org
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/ucount.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index 65b597431c86..06ea04d44685 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -350,7 +350,8 @@ bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsign
 	if (rlimit > LONG_MAX)
 		max = LONG_MAX;
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		if (get_ucounts_value(iter, type) > max)
+		long val = get_ucounts_value(iter, type);
+		if (val < 0 || val > max)
 			return true;
 		max = READ_ONCE(iter->ns->ucount_max[type]);
 	}
-- 
2.29.2

