Return-Path: <SRS0=/LmR=6O=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021B5C4724C
	for <linux-api@archiver.kernel.org>; Thu, 30 Apr 2020 14:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D6920774
	for <linux-api@archiver.kernel.org>; Thu, 30 Apr 2020 14:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588255967;
	bh=w+CRxr9kY4K+9b8jpYJdkDCWoR7oDk9596EFqhXzsvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IJkmOq5cw7cTPVgJHoS2P8I1tmCtjpdKZvtide4Rq16kL1auQRrLen9qx7TrRlus2
	 t2QDojxUSgDRbVa6E9WVaL3XFnqDMYo3QlLoOutiFwTz3noa1BALkJy6HxKK2Ke93H
	 jJNIagzNbg7kaRkCcdWT8yF8x+01iO3S0UE7uHSM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgD3OMn (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 30 Apr 2020 10:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgD3NvC (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D4A520870;
        Thu, 30 Apr 2020 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254662;
        bh=w+CRxr9kY4K+9b8jpYJdkDCWoR7oDk9596EFqhXzsvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTomldbZMw4ITCDKM0E/rMvAZO9LypEpJdNriBRsK49UngKy9lnxWDa9DJlAB5Y/o
         E6igEm3y/Y9WPTY7v2aA0Q4N9WfSneI9oXZYVNqJp2NWrUgpzur6V9wfyZvXlOHefH
         NWCM0OyW7rri6dGsiBCJ3hu6G7aBN2Is3ZmPYTBs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sandipan Das <sandipan@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 15/79] selftests: vm: Do not override definition of ARCH
Date:   Thu, 30 Apr 2020 09:49:39 -0400
Message-Id: <20200430135043.19851-15-sashal@kernel.org>
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

From: Sandipan Das <sandipan@linux.ibm.com>

[ Upstream commit 24c3f063c57b2a8ae21b259bcfa7690e2eb56dd9 ]

Independent builds of the vm selftests is currently broken because
commit 7549b3364201 ("selftests: vm: Build/Run 64bit tests only on
64bit arch") overrides the value of ARCH with the machine name from
uname. This does not always match the architecture names used for
tasks like header installation.

E.g. for building tests on powerpc64, we need ARCH=powerpc
and not ARCH=ppc64 or ARCH=ppc64le. Otherwise, the build
fails as shown below.

  $ uname -m
  ppc64le

  $ make -C tools/testing/selftests/vm
  make: Entering directory '/home/sandipan/linux/tools/testing/selftests/vm'
  make --no-builtin-rules ARCH=ppc64le -C ../../../.. headers_install
  make[1]: Entering directory '/home/sandipan/linux'
  Makefile:653: arch/ppc64le/Makefile: No such file or directory
  make[1]: *** No rule to make target 'arch/ppc64le/Makefile'.  Stop.
  make[1]: Leaving directory '/home/sandipan/linux'
  ../lib.mk:50: recipe for target 'khdr' failed
  make: *** [khdr] Error 2
  make: Leaving directory '/home/sandipan/linux/tools/testing/selftests/vm'

Fixes: 7549b3364201 ("selftests: vm: Build/Run 64bit tests only on 64bit arch")
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 7f9a8a8c31da9..3f2e2f0ccbc9a 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
+MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
 
 CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 LDLIBS = -lrt
@@ -19,7 +19,7 @@ TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 
-ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
+ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
 endif
-- 
2.20.1

