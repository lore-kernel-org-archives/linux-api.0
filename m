Return-Path: <SRS0=/LmR=6O=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158D9C47247
	for <linux-api@archiver.kernel.org>; Thu, 30 Apr 2020 13:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E04F820774
	for <linux-api@archiver.kernel.org>; Thu, 30 Apr 2020 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588254851;
	bh=JhaoRj9jZk39lYShkuqJ2n3OdDYo4lbMd/G3DAoAJHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m1vzh0y+SoeGsag2xvM66OuBWDCNyYgKxfAIXRd7w7RXMYkk/dE4a0abi09HohrKH
	 JSGlAT2PzCWJeNC20HTwpfks1TpwJNRip2w89cU33KajCs218qAi1jbZblA8C6Z5OL
	 lhFIRzXgHCOAPshrdk/KNInxnGQwkid9zq9ntQJ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgD3NyJ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728894AbgD3NyI (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 30 Apr 2020 09:54:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE8A0208D5;
        Thu, 30 Apr 2020 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254848;
        bh=JhaoRj9jZk39lYShkuqJ2n3OdDYo4lbMd/G3DAoAJHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryUw709zvMp6EiZJj5euqpDcMNadYCceMJE7uIQwdeghKh9EfGFhM42GEC7FiFScn
         53FM0f1v92u8e9zDMNNEmpWnoh06UxtV/EdTxuKBTp8GQLynZ9VALTFcHpWvt2gYvY
         NMoSunFiSeF++dnCxxNroplWYG05Dmys/UfD3Q10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tyler Hicks <tyhicks@linux.microsoft.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/27] selftests/ipc: Fix test failure seen after initial test run
Date:   Thu, 30 Apr 2020 09:53:40 -0400
Message-Id: <20200430135402.20994-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135402.20994-1-sashal@kernel.org>
References: <20200430135402.20994-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit b87080eab4c1377706c113fc9c0157f19ea8fed1 ]

After successfully running the IPC msgque test once, subsequent runs
result in a test failure:

  $ sudo ./run_kselftest.sh
  TAP version 13
  1..1
  # selftests: ipc: msgque
  # Failed to get stats for IPC queue with id 0
  # Failed to dump queue: -22
  # Bail out!
  # # Pass 0 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
  not ok 1 selftests: ipc: msgque # exit=1

The dump_queue() function loops through the possible message queue index
values using calls to msgctl(kern_id, MSG_STAT, ...) where kern_id
represents the index value. The first time the test is ran, the initial
index value of 0 is valid and the test is able to complete. The index
value of 0 is not valid in subsequent test runs and the loop attempts to
try index values of 1, 2, 3, and so on until a valid index value is
found that corresponds to the message queue created earlier in the test.

The msgctl() syscall returns -1 and sets errno to EINVAL when invalid
index values are used. The test failure is caused by incorrectly
comparing errno to -EINVAL when cycling through possible index values.

Fix invalid test failures on subsequent runs of the msgque test by
correctly comparing errno values to a non-negated EINVAL.

Fixes: 3a665531a3b7 ("selftests: IPC message queue copy feature test")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ipc/msgque.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index c5587844fbb8c..ad723a5d0f831 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -137,7 +137,7 @@ int dump_queue(struct msgque_data *msgque)
 	for (kern_id = 0; kern_id < 256; kern_id++) {
 		ret = msgctl(kern_id, MSG_STAT, &ds);
 		if (ret < 0) {
-			if (errno == -EINVAL)
+			if (errno == EINVAL)
 				continue;
 			printf("Failed to get stats for IPC queue with id %d\n",
 					kern_id);
-- 
2.20.1

