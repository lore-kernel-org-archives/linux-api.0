Return-Path: <SRS0=+CiM=A2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20483C433E0
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 13:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBA49206F5
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 13:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="fChuM0sc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbgGONbZ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:31:25 -0400
Received: from mail.efficios.com ([167.114.26.124]:55356 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731629AbgGONbZ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 15 Jul 2020 09:31:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 6F6FF281BB5;
        Wed, 15 Jul 2020 09:31:24 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id x456bqztpUaV; Wed, 15 Jul 2020 09:31:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2CDA8281D33;
        Wed, 15 Jul 2020 09:31:24 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 2CDA8281D33
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1594819884;
        bh=oiV20TFEdg/WOjUfdcRO5DKrVFJm+7E+Ps+0ZX3tPDU=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=fChuM0scw5yPL3HRGW6aeXy1V5SY4zG8eVVUidUGRxoCvWlWzTozGvyw24z07q0yE
         yivaIoBlBe7zZzo+Ag8yDbpNyJrQGHuYRFnrjR/wc6WMRyd2pZti88UoPlOqMYXZzz
         L0wNSO3vfI3UAjo27v2TxsMZu2yq8SkDuZ0pXN4nzMjCTbOkn4Vf2wZiRKGnvk1pex
         2+KFt2eD523DXEQb5qHPEhdxKLPze58Kkc/f0CC7ux7ooWyRC63mbQphOG16OR/Swl
         3COZ1UK+9AqgSmQMysU3cl8PUYQWEfRpbgOA19Z9/pNDsYlJ+rqq2NVYIROFxRm7q5
         egSHsn4sI2EMw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3oemUUox7m-y; Wed, 15 Jul 2020 09:31:24 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 1FC062819DC;
        Wed, 15 Jul 2020 09:31:24 -0400 (EDT)
Date:   Wed, 15 Jul 2020 09:31:24 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     carlos <carlos@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Message-ID: <882700738.14181.1594819884049.JavaMail.zimbra@efficios.com>
In-Reply-To: <87y2nk29rp.fsf@oldenburg2.str.redhat.com>
References: <20200714030348.6214-1-mathieu.desnoyers@efficios.com> <87mu42bepq.fsf@oldenburg2.str.redhat.com> <131549905.11442.1594731035989.JavaMail.zimbra@efficios.com> <87a7028d5u.fsf@oldenburg2.str.redhat.com> <2452161.11491.1594732791558.JavaMail.zimbra@efficios.com> <71f08b3a-56f5-0e0f-53b0-cc680f7e8181@redhat.com> <2053637148.14136.1594818777608.JavaMail.zimbra@efficios.com> <87y2nk29rp.fsf@oldenburg2.str.redhat.com>
Subject: Re: [RFC PATCH 2/4] rseq: Allow extending struct rseq
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3955 (ZimbraWebClient - FF78 (Linux)/8.8.15_GA_3953)
Thread-Topic: rseq: Allow extending struct rseq
Thread-Index: V96wiIe8u1FFBKTMqXUWPRUhLORLEA==
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

----- On Jul 15, 2020, at 9:22 AM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
> 
>> Practically speaking, I suspect this would mean postponing availability of
>> rseq for widely deployed applications for a few more years ?
> 
> There is no rseq support in GCC today, so you have to write assembler
> code anyway.

Assembler code is only needed for the rseq critical sections, not for accessing
the __rseq_abi. Use-cases like getting the current cpu number do not currently
require any assembler for instance.

So indeed it could be done today without upgrading the toolchains by writing
custom assembler for each architecture to get the thread's struct rseq. AFAIU
the ABI to access the thread pointer is fixed for each architecture, right ?

How would this allow early-rseq-adopter libraries to interact with glibc ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
