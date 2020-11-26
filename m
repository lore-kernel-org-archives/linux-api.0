Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5F7C63798
	for <linux-api@archiver.kernel.org>; Thu, 26 Nov 2020 05:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE7A2145D
	for <linux-api@archiver.kernel.org>; Thu, 26 Nov 2020 05:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbgKZFev (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 26 Nov 2020 00:34:51 -0500
Received: from mga05.intel.com ([192.55.52.43]:10495 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387800AbgKZFev (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 26 Nov 2020 00:34:51 -0500
IronPort-SDR: REP/h1Ayt//S1l3ew2lXpYIe4t0ZDSZZeVZdSkgPo6S0npPhR2ogig4Lz91NX4ej+JIBXJQoJg
 0UCLhB3uuc+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="256948937"
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="256948937"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 21:34:50 -0800
IronPort-SDR: S4GfgKYmKo2+aFMxzmePsg7rw8zPyM7vvNsKBWuPFBPPwXbzvuVQJrmMRc8UKXI5LQKLwmMWBm
 582PwK3W9wEw==
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="537180103"
Received: from yhuang-mobile.sh.intel.com ([10.238.5.184])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 21:34:47 -0800
From:   Huang Ying <ying.huang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Rafael Aquini <aquini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        linux-api@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>
Subject: [PATCH -v6 2/3] NOT kernel/man-pages man2/set_mempolicy.2: Add mode flag MPOL_F_NUMA_BALANCING
Date:   Thu, 26 Nov 2020 13:32:18 +0800
Message-Id: <20201126053219.234793-3-ying.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126053219.234793-1-ying.huang@intel.com>
References: <20201126053219.234793-1-ying.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Huang Ying <caritas@localhost>

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
---
 man2/set_mempolicy.2 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man2/set_mempolicy.2 b/man2/set_mempolicy.2
index 68011eecb..fb16bb351 100644
--- a/man2/set_mempolicy.2
+++ b/man2/set_mempolicy.2
@@ -113,6 +113,11 @@ A nonempty
 .I nodemask
 specifies node IDs that are relative to the set of
 node IDs allowed by the process's current cpuset.
+.TP
+.BR MPOL_F_NUMA_BALANCING " (since Linux 5.11)"
+Enable the Linux kernel NUMA balancing for the task if it is supported
+by kernel.  If the flag isn't supported by Linux kernel, return -1 and
+errno is set to EINVAL.
 .PP
 .I nodemask
 points to a bit mask of node IDs that contains up to
@@ -293,6 +298,9 @@ argument specified both
 .B MPOL_F_STATIC_NODES
 and
 .BR MPOL_F_RELATIVE_NODES .
+Or, the
+.B MPOL_F_NUMA_BALANCING
+isn't supported by the Linux kernel.
 .TP
 .B ENOMEM
 Insufficient kernel memory was available.
-- 
2.29.2

