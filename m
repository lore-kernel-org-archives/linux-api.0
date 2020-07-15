Return-Path: <SRS0=+CiM=A2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_C,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1985BC433E3
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 13:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF4BF206D5
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 13:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFYnl6qQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbgGONWa (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:22:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27642 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731632AbgGONWa (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 15 Jul 2020 09:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594819349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=eujgVDOYWc3cCN8+v848SftAP3mzH/rlkfn6GJO88Cw=;
        b=dFYnl6qQhMVhpL6/t3WAcFOapxsuknckepE24/z2SiizLklZftxUrRXg452KQjW40dCAcs
        l2dBRxUFbI/1XJdSmK6qmE0bTNarcBfBg7CTAQNCxtQtluN+dLoku7dQ+cA7o0n0Sjs5E1
        NKZr7PmlBOihvA8m1VvzSji6Z4iQRG0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-yLJrAiKwNNq5CnTy7sBerw-1; Wed, 15 Jul 2020 09:22:27 -0400
X-MC-Unique: yLJrAiKwNNq5CnTy7sBerw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98F2718A1DE2;
        Wed, 15 Jul 2020 13:22:25 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-112-228.ams2.redhat.com [10.36.112.228])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8102E5D9CA;
        Wed, 15 Jul 2020 13:22:20 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     carlos <carlos@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [RFC PATCH 2/4] rseq: Allow extending struct rseq
References: <20200714030348.6214-1-mathieu.desnoyers@efficios.com>
        <20200714030348.6214-3-mathieu.desnoyers@efficios.com>
        <87mu42bepq.fsf@oldenburg2.str.redhat.com>
        <131549905.11442.1594731035989.JavaMail.zimbra@efficios.com>
        <87a7028d5u.fsf@oldenburg2.str.redhat.com>
        <2452161.11491.1594732791558.JavaMail.zimbra@efficios.com>
        <71f08b3a-56f5-0e0f-53b0-cc680f7e8181@redhat.com>
        <2053637148.14136.1594818777608.JavaMail.zimbra@efficios.com>
Date:   Wed, 15 Jul 2020 15:22:18 +0200
Message-ID: <87y2nk29rp.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Practically speaking, I suspect this would mean postponing availability of
> rseq for widely deployed applications for a few more years ?

There is no rseq support in GCC today, so you have to write assembler
code anyway.

Thanks,
Florian

