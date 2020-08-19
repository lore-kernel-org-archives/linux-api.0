Return-Path: <SRS0=OHck=B5=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA74C433DF
	for <linux-api@archiver.kernel.org>; Wed, 19 Aug 2020 14:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385EB2083B
	for <linux-api@archiver.kernel.org>; Wed, 19 Aug 2020 14:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHSOzo (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 19 Aug 2020 10:55:44 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2673 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726899AbgHSOzn (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 19 Aug 2020 10:55:43 -0400
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id BE0AA37D166D367E32FE;
        Wed, 19 Aug 2020 15:55:41 +0100 (IST)
Received: from lhrphicprd00229.huawei.com (10.123.41.22) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 19 Aug 2020 15:55:41 +0100
From:   Jonathan Cameron <Jonathan.Cameron@huawei.com>
To:     <linux-mm@kvack.org>, <linux-acpi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <x86@kernel.org>
CC:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <rafael@kernel.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linuxarm@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Brice Goglin <Brice.Goglin@inria.fr>,
        Sean V Kelley <sean.v.kelley@linux.intel.com>,
        <linux-api@vger.kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v9 6/6] docs: mm: numaperf.rst Add brief description for access class 1.
Date:   Wed, 19 Aug 2020 22:51:11 +0800
Message-ID: <20200819145111.1715026-7-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200819145111.1715026-1-Jonathan.Cameron@huawei.com>
References: <20200819145111.1715026-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.41.22]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Try to make minimal changes to the document which already describes
access class 0 in a generic fashion (including IO initiatiors that
are not CPUs).

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 Documentation/admin-guide/mm/numaperf.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/admin-guide/mm/numaperf.rst b/Documentation/admin-guide/mm/numaperf.rst
index 4d69ef1de830..b89bb85eac75 100644
--- a/Documentation/admin-guide/mm/numaperf.rst
+++ b/Documentation/admin-guide/mm/numaperf.rst
@@ -56,6 +56,11 @@ nodes' access characteristics share the same performance relative to other
 linked initiator nodes. Each target within an initiator's access class,
 though, do not necessarily perform the same as each other.
 
+The access class "1" is used to allow differentiation between initiators
+that are CPUs and hence suitable for generic task scheduling, and
+IO initiators such as GPUs and NICs.  Unlike access class 0, only
+nodes containing CPUs are considered.
+
 ================
 NUMA Performance
 ================
@@ -88,6 +93,9 @@ The latency attributes are provided in nanoseconds.
 The values reported here correspond to the rated latency and bandwidth
 for the platform.
 
+Access class 1, takes the same form, but only includes values for CPU to
+memory activity.
+
 ==========
 NUMA Cache
 ==========
-- 
2.19.1

