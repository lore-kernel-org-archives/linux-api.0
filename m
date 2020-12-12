Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9D0C19425
	for <linux-api@archiver.kernel.org>; Sat, 12 Dec 2020 16:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF982225E
	for <linux-api@archiver.kernel.org>; Sat, 12 Dec 2020 16:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407659AbgLLQh1 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 12 Dec 2020 11:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439377AbgLLQJg (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Sat, 12 Dec 2020 11:09:36 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 09/23] selftests: tc-testing: enable CONFIG_NET_SCH_RED as a module
Date:   Sat, 12 Dec 2020 11:07:50 -0500
Message-Id: <20201212160804.2334982-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit e14038a7ead09faa180eb072adc4a2157a0b475f ]

a proper kernel configuration for running kselftest can be obtained with:

 $ yes | make kselftest-merge

enable compile support for the 'red' qdisc: otherwise, tdc kselftest fail
when trying to run tdc test items contained in red.json.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/cfa23f2d4f672401e6cebca3a321dd1901a9ff07.1606416464.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index c33a7aac27ff7..b71828df5a6dd 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -59,6 +59,7 @@ CONFIG_NET_IFE_SKBPRIO=m
 CONFIG_NET_IFE_SKBTCINDEX=m
 CONFIG_NET_SCH_FIFO=y
 CONFIG_NET_SCH_ETS=m
+CONFIG_NET_SCH_RED=m
 
 #
 ## Network testing
-- 
2.27.0

