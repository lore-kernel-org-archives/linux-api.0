Return-Path: <SRS0=+CiM=A2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF1BC433F2
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 14:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 413742075F
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 14:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="lZCRIlc4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgGOOiZ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:38:25 -0400
Received: from mail.efficios.com ([167.114.26.124]:48712 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgGOOiX (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 15 Jul 2020 10:38:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A7FFE282541;
        Wed, 15 Jul 2020 10:38:22 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id VoIxFAwolIrE; Wed, 15 Jul 2020 10:38:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 51F1A282272;
        Wed, 15 Jul 2020 10:38:22 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 51F1A282272
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1594823902;
        bh=MvltfcasujUgKB1aPbhMHKFPfNB/j96cXDmGlUqVTdw=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=lZCRIlc44ECZUl1vUVV2FAr1W9VbcZeqPqcS1lnNllCEQuCITyGjQAz08FcPUDf82
         8dWZZrOvZwH2l1RCwAU6yZbcphquDe9DDFRAl5BFl+nv5CEI7D81STFdmM708lZsw3
         7wgCWioGt7o2CM6xbzh22oTI7jhD0aZHBjceRG+5C5CDaDgrsOzJWyd3s35ZpeqBLJ
         +utixOyLlXbg3mxUuM3oQvjztOjEK+LS8XjPOXFCnzHYZb51nIAEfV7blV/uyT2jJA
         I8HOcru8v4Ki2M8lof+KHzsK1dQYNXsFrqgQUr1vFAthQb8y3jf2TsFZsmAP3HK5/t
         6ukfeITVE9NeA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id f5x0OgtWeVxI; Wed, 15 Jul 2020 10:38:22 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 3EF1B282077;
        Wed, 15 Jul 2020 10:38:22 -0400 (EDT)
Date:   Wed, 15 Jul 2020 10:38:22 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Chris Kennelly <ckennelly@google.com>,
        Peter Oskolkov <posk@google.com>,
        Peter Oskolkov <posk@posk.io>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        carlos <carlos@redhat.com>
Message-ID: <1818805836.14259.1594823902146.JavaMail.zimbra@efficios.com>
In-Reply-To: <87k0z5xpau.fsf@mid.deneb.enyo.de>
References: <20200714030348.6214-1-mathieu.desnoyers@efficios.com> <20200714030348.6214-3-mathieu.desnoyers@efficios.com> <CAFTs51UHaUqaKj5bEj0vQtEZrww9gnrqb-kGVk7DAgQJPBAR+w@mail.gmail.com> <775688146.12145.1594748580461.JavaMail.zimbra@efficios.com> <CAPNVh5fiCCJpyeLj_ciWzFrO4fasVXZNhpfKXJhJWJirXdJOjQ@mail.gmail.com> <CAEE+ybmt4BredezuTPdh-vf=FkKtu0yAhWuf+0daUe89AnbmPg@mail.gmail.com> <87k0z5xpau.fsf@mid.deneb.enyo.de>
Subject: Re: [RFC PATCH 2/4] rseq: Allow extending struct rseq
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3955 (ZimbraWebClient - FF78 (Linux)/8.8.15_GA_3953)
Thread-Topic: rseq: Allow extending struct rseq
Thread-Index: n6SkhqROq4bQCv1AJ1PKhQ/oywsKyQ==
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

----- On Jul 15, 2020, at 2:31 AM, Florian Weimer fw@deneb.enyo.de wrote:

> * Chris Kennelly:
> 
>> When glibc provides registration, is the anticipated use case that a
>> library would unregister and reregister each thread to "upgrade" it to
>> the most modern version of interface it knows about provided by the
>> kernel?
> 
> Absolutely not, that is likely to break other consumers because an
> expected rseq area becomes dormant instead.

Indeed.

> 
>> There, I could assume an all-or-nothing registration of the new
>> feature--limited only by kernel availability for thread
>> homogeneity--but inconsistencies across early adopter libraries would
>> mean each thread would have to examine its own TLS to determine if a
>> feature were available.
> 
> Exactly.  Certain uses of seccomp can also have this effect,
> presenting a non-homogeneous view.

The nice thing about having a consistent feature-set for a given
thread group is that it allows specializing the code at thread
group startup, rather than requiring to dynamically check for
feature availability at runtime in fast-paths.

I wonder whether this kind of non-homogeneous view scenario
caused by seccomp is something we should support, or something
that should be documented as incompatible with rseq ?

Thanks,

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
