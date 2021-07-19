Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC40C636C9
	for <linux-api@archiver.kernel.org>; Mon, 19 Jul 2021 16:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7CC361464
	for <linux-api@archiver.kernel.org>; Mon, 19 Jul 2021 16:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347090AbhGSPbZ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 19 Jul 2021 11:31:25 -0400
Received: from esa.hc503-62.ca.iphmx.com ([216.71.131.47]:53697 "EHLO
        esa.hc503-62.ca.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349432AbhGSP07 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 19 Jul 2021 11:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=uwaterloo.ca; i=@uwaterloo.ca; q=dns/txt; s=default;
  t=1626710858; x=1658246858;
  h=to:cc:references:subject:in-reply-to:from:message-id:
   date:mime-version:content-transfer-encoding;
  bh=jl235RA06PWh11CvKod4yfJvroVnAN8xTTdoZoAOoFE=;
  b=Exs7oBMc669tX2uyJpKJ1MlxYpXpw097EeizW2dN4tn65hI2gH2OZqnM
   UcXV57acaa/49/RVgoB4/0NbO9uA0CX8iE5GJ7Ve4Qj2oDZPtdgg9WEn5
   FrspsdTo/74iZJFHqtnRyCVUeD9dSeutZ7JEUTNBOulwhbHRzy1xJPWlS
   Q=;
Received: from connect.uwaterloo.ca (HELO connhm04.connect.uwaterloo.ca) ([129.97.208.43])
  by ob1.hc503-62.ca.iphmx.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jul 2021 12:07:34 -0400
Received: from [10.42.0.123] (10.32.139.159) by connhm04.connect.uwaterloo.ca
 (172.16.137.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 19
 Jul 2021 12:07:33 -0400
To:     <posk@posk.io>
CC:     <avagin@google.com>, <bsegall@google.com>, <jannh@google.com>,
        <jnewsome@torproject.org>, <joel@joelfernandes.org>,
        <linux-api@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mingo@redhat.com>, <peterz@infradead.org>, <pjt@google.com>,
        <posk@google.com>, <tdelisle@uwaterloo.ca>, <tglx@linutronix.de>,
        Peter Buhr <pabuhr@uwaterloo.ca>
References: <20210716184719.269033-5-posk@google.com>
Subject: Re: [RFC PATCH 4/4 v0.3] sched/umcg: RFC: implement UMCG syscalls
In-Reply-To: <20210716184719.269033-5-posk@google.com>
From:   Thierry Delisle <tdelisle@uwaterloo.ca>
Message-ID: <2c971806-b8f6-50b9-491f-e1ede4a33579@uwaterloo.ca>
Date:   Mon, 19 Jul 2021 12:07:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.32.139.159]
X-ClientProxiedBy: connhm04.connect.uwaterloo.ca (172.16.137.68) To
 connhm04.connect.uwaterloo.ca (172.16.137.68)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

 > /**
 >  * @idle_servers_ptr: a single-linked list pointing to the list
 >  *                    of idle servers. Can be NULL.
 >  *
 >  * Readable/writable by both the kernel and the userspace: the
 >  * userspace adds items to the list, the kernel removes them.
 >  *
 >  * This is a single-linked list (stack): head->next->next->next->NULL.
 >  * "next" nodes are idle_servers_ptr fields in struct umcg_task.
 >  *
 >  * Example:
 >  *
 >  *  a running worker             idle server 1        idle server 2
 >  *
 >  * struct umct_task:             struct umcg_task:    struct umcg_task:
 >  *    state                         state state
 >  *    api_version                   api_version api_version
 >  *    ...                           ...                  ...
 >  *    idle_servers_ptr --> head --> idle_servers_ptr --> 
idle_servers_ptr --> NULL
 >  *    ...                           ...                  ...
 >  *
 >  *
 >  * Due to the way struct umcg_task is aligned, idle_servers_ptr
 >  * is aligned at 8 byte boundary, and so has its first byte as zero
 >  * when it holds a valid pointer.
 >  *
 >  * When pulling idle servers from the list, the kernel marks nodes as
 >  * "deleted" by ORing the node value (the pointer) with 1UL atomically.
 >  * If a node is "deleted" (i.e. its value AND 1UL is not zero),
 >  * the kernel proceeds to the next node.
 >  *
 >  * The kernel checks at most [nr_cpu_ids * 2] first nodes in the list.
 >  *
 >  * It is NOT considered an error if the kernel cannot find an idle
 >  * server.
 >  *
 >  * The userspace is responsible for cleanup/gc (i.e. for actually
 >  * removing nodes marked as "deleted" from the list).
 >  */
 > uint64_t    idle_servers_ptr;    /* r/w */

I don't understand the reason for using this ad-hoc scheme, over using a 
simple
eventfd to do the job. As I understand it, the goal here is to let 
servers that
cannot find workers to run, block instead of spinning. Isn't that 
exactly what
the eventfd interface is for?

Have you considered an idle_fd field, the kernel writes 1 to the fd when a
worker is appended to the idle_workers_ptr? Servers that don't find work can
read the fd or alternatively use select/poll/epoll. Multiple workers are
expected to share fds, either a single global fd, one fd per server, or any
other combination the scheduler may fancy.

