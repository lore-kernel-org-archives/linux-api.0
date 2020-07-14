Return-Path: <SRS0=8Qj6=AZ=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68652C433E0
	for <linux-api@archiver.kernel.org>; Tue, 14 Jul 2020 03:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3412B21974
	for <linux-api@archiver.kernel.org>; Tue, 14 Jul 2020 03:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="Wfty55aW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgGNDD4 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 13 Jul 2020 23:03:56 -0400
Received: from mail.efficios.com ([167.114.26.124]:46160 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNDD4 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 13 Jul 2020 23:03:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 81CDA2B8641;
        Mon, 13 Jul 2020 23:03:55 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id c7g69rhorLiH; Mon, 13 Jul 2020 23:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2E14F2B84C5;
        Mon, 13 Jul 2020 23:03:55 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 2E14F2B84C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1594695835;
        bh=i0IKhP8FYjVj9PU2ZwfUV53aZ9hjgamCtIU+kee/py8=;
        h=From:To:Date:Message-Id;
        b=Wfty55aWgQavXhCrAE4Emzg17kW+mRORyLaWTEpm7Z0y/TltVeOjk+aKGSuArEV24
         Cr3ycvDPCn/4576UbDV0JqdMrpq1wre2XwJji9839/2Htk9dzo2BkXdYgfTd/twm5a
         JSZd5ncoWkS+vLIE6342d93gs6LStpS3g6lu/M3pfTj+P6U+btMSCiV6fUZp/ONUiX
         N0jy5dwd73NTtmvDsrxoENQsNkAzeHCiwvyCaNAWvFVbyavqVQW10sEut0tDWTu8I4
         Gqj6/8tGDrfpknqAUyhCoLBAGXl4Iefai2RI9is3nCR+ggLN+VGHowQ9stD36wSCkH
         QBL8iILyDwJOQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RAbGfGtBseht; Mon, 13 Jul 2020 23:03:55 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id D4BF82B84C4;
        Mon, 13 Jul 2020 23:03:54 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Weimer <fw@deneb.enyo.de>, carlos@redhat.com,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 0/4] rseq: Introduce extensible struct rseq
Date:   Mon, 13 Jul 2020 23:03:44 -0400
Message-Id: <20200714030348.6214-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Recent discussion led to a solution for extending struct rseq. This is
an implementation of the proposed solution.

Now is a good time to agree on this scheme before the release of glibc
2.32, just in case there are small details to fix on the user-space
side in order to allow extending struct rseq.

Thanks,

Mathieu

Mathieu Desnoyers (4):
  selftests: rseq: Use fixed value as rseq_len parameter
  rseq: Allow extending struct rseq
  selftests: rseq: define __rseq_abi with extensible size
  selftests: rseq: print rseq extensible size in basic test

 include/linux/sched.h                     |  4 +++
 include/uapi/linux/rseq.h                 | 42 ++++++++++++++++++++--
 kernel/rseq.c                             | 44 +++++++++++++++++++----
 tools/testing/selftests/rseq/basic_test.c | 15 ++++++++
 tools/testing/selftests/rseq/rseq.c       |  8 +++--
 5 files changed, 101 insertions(+), 12 deletions(-)

-- 
2.17.1

