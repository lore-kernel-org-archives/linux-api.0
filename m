Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20ECC7EE23
	for <linux-api@archiver.kernel.org>; Mon, 15 May 2023 13:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbjEON6N (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 15 May 2023 09:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbjEON6N (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 15 May 2023 09:58:13 -0400
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562B01982;
        Mon, 15 May 2023 06:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1684159088;
        bh=AoXgMzAGruKIA96Gb918/GKv0CpaGYPEKzkfW52ORhI=;
        h=From:To:Cc:Subject:Date:From;
        b=JiEvV/coWDZ3UAKGz+xuCGsqBbOqfRLOOPrRtbMj/sKXd9d0p/HOEp5vsK/juoOuE
         NuKlUwy9PY7jz+2nC0neHZsFHY7Jasw06cprypNOgVcwlcFedcp0pVXMFD5/sBVltj
         qOD7sw0R947XlQ43kmalig+zHMe37OH54o6OE6yjBSwdordrXWuOAaay1yJ2JD3NDB
         kooD7IAG0S/psr9c9l1GVZov0R7j4FubsXXYtaBsm9xlg1SC2ucq3wBpNNtLW9/cSe
         ynfvbO63J0j+v974VXXshojwtl3YWoqFvJQa2ASgpXSHayMYqKwvJCg5h96K2Zkyhx
         9XKv2jq1ac8lA==
Received: from localhost.localdomain (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4QKgtm5XNkz12dQ;
        Mon, 15 May 2023 09:58:08 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/4] RSEQ selftests updates
Date:   Mon, 15 May 2023 09:57:57 -0400
Message-Id: <20230515135801.15220-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi,

You will find in this series updates to the rseq selftests, mainly
bringing fixes from librseq project back into the RSEQ selftests.

Thanks,

Mathieu

Mathieu Desnoyers (4):
  selftests/rseq: Fix CID_ID typo in Makefile
  selftests/rseq: Implement rseq_unqual_scalar_typeof
  selftests/rseq: Fix arm64 buggy load-acquire/store-release macros
  selftests/rseq: Use rseq_unqual_scalar_typeof in macros

 tools/testing/selftests/rseq/Makefile     |  2 +-
 tools/testing/selftests/rseq/compiler.h   | 26 ++++++++++
 tools/testing/selftests/rseq/rseq-arm.h   |  4 +-
 tools/testing/selftests/rseq/rseq-arm64.h | 58 ++++++++++++-----------
 tools/testing/selftests/rseq/rseq-mips.h  |  4 +-
 tools/testing/selftests/rseq/rseq-ppc.h   |  4 +-
 tools/testing/selftests/rseq/rseq-riscv.h |  6 +--
 tools/testing/selftests/rseq/rseq-s390.h  |  4 +-
 tools/testing/selftests/rseq/rseq-x86.h   |  4 +-
 9 files changed, 70 insertions(+), 42 deletions(-)

-- 
2.25.1

