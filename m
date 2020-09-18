Return-Path: <SRS0=J0k9=C3=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB75CC43463
	for <linux-api@archiver.kernel.org>; Fri, 18 Sep 2020 03:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 678DE206DB
	for <linux-api@archiver.kernel.org>; Fri, 18 Sep 2020 03:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600398486;
	bh=JYuoka6Dcpa7rPPX+K0pgm8y9LHlMras/8gA7lLYGAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KgQVztFESaxJFy+ZR8Zie1z9PTMaTShbCYDL4O1Kc9p4UxPGP2XRV+ob9W7B7kq5k
	 y57JFzQ4x9o26W5QgUa2L5lufBd/z0RGJUTXHfy69uJcotVPC2jciHFPl9GPHzMDQS
	 QJ2RVxmobAdtFqIih3gdy40oo1hMBGOgpGpOta4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgIRCDj (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgIRCDW (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68FB32311A;
        Fri, 18 Sep 2020 02:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394602;
        bh=JYuoka6Dcpa7rPPX+K0pgm8y9LHlMras/8gA7lLYGAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3w7Ksiyj4EEb47VPvzEC2PuZpyTMGpijrfMGfPBck2zkwa3I70AZylNzRsI/OhfE
         aE50G+UtGVmwj9qEa57tkx4VidYoD+kBFMPoC32LbSyRKPUQi1sf7sM1VLxkP96UdP
         Oc9jBDhrW7Pqxa1PGeU0uxWiDELW1aCjb7PfubmM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 109/330] selftests/ftrace: fix glob selftest
Date:   Thu, 17 Sep 2020 21:57:29 -0400
Message-Id: <20200918020110.2063155-109-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit af4ddd607dff7aabd466a4a878e01b9f592a75ab ]

test.d/ftrace/func-filter-glob.tc is failing on s390 because it has
ARCH_INLINE_SPIN_LOCK and friends set to 'y'. So the usual
__raw_spin_lock symbol isn't in the ftrace function list. Change
'*aw*lock' to '*spin*lock' which would hopefully match some of the
locking functions on all platforms.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
index 27a54a17da65d..f4e92afab14b2 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
@@ -30,7 +30,7 @@ ftrace_filter_check '*schedule*' '^.*schedule.*$'
 ftrace_filter_check 'schedule*' '^schedule.*$'
 
 # filter by *mid*end
-ftrace_filter_check '*aw*lock' '.*aw.*lock$'
+ftrace_filter_check '*pin*lock' '.*pin.*lock$'
 
 # filter by start*mid*
 ftrace_filter_check 'mutex*try*' '^mutex.*try.*'
-- 
2.25.1

