Return-Path: <SRS0=/LmR=6O=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C8FC47247
	for <linux-api@archiver.kernel.org>; Thu, 30 Apr 2020 14:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 964BA2063A
	for <linux-api@archiver.kernel.org>; Thu, 30 Apr 2020 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588255941;
	bh=pNDq+qA0a6AeHHaZ1+wh57H8blS3M82LwnhCyrgPei8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fMRw+HUtY+b/oaA3eeFCb1fCj4ndW8CTrTXuPxEQuv9FAw0TAFe4PAQRtJAFQlxTO
	 BQs/KvjyREwR7TxfTT1OfWSzdDwRaS+w/iUl3cX9qc3CTK96xrkP0BCg/U/TwK9b/d
	 cg0cplXXv4CPoIx4FqxRcBpb0pFmK34FC//TItjY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgD3NvH (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgD3NvG (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1176E24954;
        Thu, 30 Apr 2020 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254665;
        bh=pNDq+qA0a6AeHHaZ1+wh57H8blS3M82LwnhCyrgPei8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmqG9RGED98L/rX3qYChQfInbO2hMoWdwBwCgL6HGBiw/9WVGUniHHgsbjalvJDKj
         z3ptY+puGMZV9tL6nhcqzrWvznwFPfCQn3pEBWrmJ/HeziC1pbf19kOse3Us6kM5Tk
         5trv2rZ1+L0s80eBAb49o5dmyN5BoYfOX4iF8xMg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nikita Sobolev <Nikita.Sobolev@synopsys.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 18/79] Revert "Kernel selftests: tpm2: check for tpm support"
Date:   Thu, 30 Apr 2020 09:49:42 -0400
Message-Id: <20200430135043.19851-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

[ Upstream commit aaa2d92efe1f972567f1691b423ab8dc606ab3a9 ]

This reverts commit b32694cd0724d4ceca2c62cc7c3d3a8d1ffa11fc.

The original comment was neither reviewed nor tested. Thus, this the
*only* possible action to take.

Cc: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tpm2/test_smoke.sh | 13 ++-----------
 tools/testing/selftests/tpm2/test_space.sh |  9 +--------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/tpm2/test_smoke.sh b/tools/testing/selftests/tpm2/test_smoke.sh
index b630c7b5950a9..8155c2ea7ccbb 100755
--- a/tools/testing/selftests/tpm2/test_smoke.sh
+++ b/tools/testing/selftests/tpm2/test_smoke.sh
@@ -1,17 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
-self.flags = flags
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-
-if [ -f /dev/tpm0 ] ; then
-	python -m unittest -v tpm2_tests.SmokeTest
-	python -m unittest -v tpm2_tests.AsyncTest
-else
-	exit $ksft_skip
-fi
+python -m unittest -v tpm2_tests.SmokeTest
+python -m unittest -v tpm2_tests.AsyncTest
 
 CLEAR_CMD=$(which tpm2_clear)
 if [ -n $CLEAR_CMD ]; then
diff --git a/tools/testing/selftests/tpm2/test_space.sh b/tools/testing/selftests/tpm2/test_space.sh
index 180b469c53b47..a6f5e346635e5 100755
--- a/tools/testing/selftests/tpm2/test_space.sh
+++ b/tools/testing/selftests/tpm2/test_space.sh
@@ -1,11 +1,4 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-if [ -f /dev/tpmrm0 ] ; then
-	python -m unittest -v tpm2_tests.SpaceTest
-else
-	exit $ksft_skip
-fi
+python -m unittest -v tpm2_tests.SpaceTest
-- 
2.20.1

