Return-Path: <SRS0=+CiM=A2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B826CC433E5
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 14:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9440F206D5
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 14:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YqFRWUSn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgGOO6z (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:58:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25408 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726201AbgGOO6z (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 15 Jul 2020 10:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594825133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lwi7F6lNPgRmpIECSq0+3vcP/L2xM7AboV3WqOkIYpQ=;
        b=YqFRWUSnP4442v1QPBQn7rKJFtnI/iOBJRsfToh1TcmXT9cIbWiv46yALs64q1gkSykEjl
        4W0eLS/rgXGHDqD3ul/1HBAims1M3s+gVwthWzrAriv0+kprR3wmG/R/PZANHvHY2mGAPf
        j+kZT7F0YErqs0ikFvyKH0zmxcH8JSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-ZM94YXkPNHiyhvmR24MdRA-1; Wed, 15 Jul 2020 10:58:50 -0400
X-MC-Unique: ZM94YXkPNHiyhvmR24MdRA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AB80102C7F1;
        Wed, 15 Jul 2020 14:58:48 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-112-228.ams2.redhat.com [10.36.112.228])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F60361982;
        Wed, 15 Jul 2020 14:58:43 +0000 (UTC)
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
        <87a7028d5u.fsf@oldenburg2.str.redhat.com>
        <2452161.11491.1594732791558.JavaMail.zimbra@efficios.com>
        <71f08b3a-56f5-0e0f-53b0-cc680f7e8181@redhat.com>
        <2053637148.14136.1594818777608.JavaMail.zimbra@efficios.com>
        <87y2nk29rp.fsf@oldenburg2.str.redhat.com>
        <882700738.14181.1594819884049.JavaMail.zimbra@efficios.com>
        <87mu4028uk.fsf@oldenburg2.str.redhat.com>
        <1481331967.14276.1594824846736.JavaMail.zimbra@efficios.com>
Date:   Wed, 15 Jul 2020 16:58:41 +0200
In-Reply-To: <1481331967.14276.1594824846736.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Wed, 15 Jul 2020 10:54:06 -0400
        (EDT)")
Message-ID: <87k0z4zuxq.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> ----- On Jul 15, 2020, at 9:42 AM, Florian Weimer fweimer@redhat.com wrote:
>> * Mathieu Desnoyers:
>> 
> [...]
>>> How would this allow early-rseq-adopter libraries to interact with
>>> glibc ?
>> 
>> Under all extension proposals I've seen so far, early adopters are
>> essentially incompatible with glibc rseq registration.  I don't think
>> you can have it both ways.
>
> The basic question I'm not sure about is whether we are allowed to increase
> the size and alignement of __rseq_abi from e.g. glibc 2.32 to glibc 2.33.

With the current mechanism (global TLS data symbol), we can do that
using symbol versioning.  That means that we can only do this on a
release boundary, and that it's incompatible with other libraries which
use an interposing unversioned symbol.

Thanks,
Florian

