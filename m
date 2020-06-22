Return-Path: <SRS0=j+hs=AD=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7071EC433E2
	for <linux-api@archiver.kernel.org>; Mon, 22 Jun 2020 23:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48090207BC
	for <linux-api@archiver.kernel.org>; Mon, 22 Jun 2020 23:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P9lzB3LZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgFVXqF (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 22 Jun 2020 19:46:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48363 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730400AbgFVXqC (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 22 Jun 2020 19:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592869561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=JMv4mx6+Se3DWeaSHcRU/xuepCBk94gqg4Zktde6+Q4=;
        b=P9lzB3LZDXDTfvIGvLFy3qKDAQoztTAUzJqJrIqd8E7PHNQvXBT4IlnQ7yl3fwfkHK0xm4
        Zt2oS09qLm7GN4ErHZyIAhUFZ3khGwWuiVWfzqU3nzOOPbMAVTOQ7x1ClwY3/nQE5dafUX
        dWpsDGoJRU5LRH6M9yNB9Pe20F4o4jg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-Tpn6uXKuPfW8Pya9396Lsw-1; Mon, 22 Jun 2020 19:45:57 -0400
X-MC-Unique: Tpn6uXKuPfW8Pya9396Lsw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECCBF8031D3;
        Mon, 22 Jun 2020 23:45:54 +0000 (UTC)
Received: from virtlab423.virt.lab.eng.bos.redhat.com (virtlab423.virt.lab.eng.bos.redhat.com [10.19.152.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4959A5C221;
        Mon, 22 Jun 2020 23:45:53 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        frederic@kernel.org, mtosatti@redhat.com, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com,
        linux-pci@vger.kernel.org, rostedt@goodmis.org, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com
Subject: [Patch v2 2/3] PCI: Restrict probe functions to housekeeping CPUs
Date:   Mon, 22 Jun 2020 19:45:09 -0400
Message-Id: <20200622234510.240834-3-nitesh@redhat.com>
In-Reply-To: <20200622234510.240834-1-nitesh@redhat.com>
References: <20200622234510.240834-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Alex Belits <abelits@marvell.com>

pci_call_probe() prevents the nesting of work_on_cpu() for a scenario
where a VF device is probed from work_on_cpu() of the PF.

Replace the cpumask used in pci_call_probe() from all online CPUs to only
housekeeping CPUs. This is to ensure that there are no additional latency
overheads caused due to the pinning of jobs on isolated CPUs.

Signed-off-by: Alex Belits <abelits@marvell.com>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/pci/pci-driver.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index da6510af1221..449466f71040 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/sched/isolation.h>
 #include <linux/cpu.h>
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
@@ -333,6 +334,7 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 			  const struct pci_device_id *id)
 {
 	int error, node, cpu;
+	int hk_flags = HK_FLAG_DOMAIN | HK_FLAG_WQ;
 	struct drv_dev_and_id ddi = { drv, dev, id };
 
 	/*
@@ -353,7 +355,8 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	    pci_physfn_is_probed(dev))
 		cpu = nr_cpu_ids;
 	else
-		cpu = cpumask_any_and(cpumask_of_node(node), cpu_online_mask);
+		cpu = cpumask_any_and(cpumask_of_node(node),
+				      housekeeping_cpumask(hk_flags));
 
 	if (cpu < nr_cpu_ids)
 		error = work_on_cpu(cpu, local_pci_probe, &ddi);
-- 
2.18.4

