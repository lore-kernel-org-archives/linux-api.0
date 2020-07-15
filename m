Return-Path: <SRS0=+CiM=A2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5F4C433DF
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 10:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCF7B206E9
	for <linux-api@archiver.kernel.org>; Wed, 15 Jul 2020 10:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgGOK7v (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 15 Jul 2020 06:59:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43326 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgGOK7v (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 15 Jul 2020 06:59:51 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jvf8Z-0004KP-VG; Wed, 15 Jul 2020 10:59:44 +0000
Date:   Wed, 15 Jul 2020 12:59:43 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Chris Kennelly <ckennelly@google.com>,
        Peter Oskolkov <posk@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Oskolkov <posk@posk.io>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>, carlos <carlos@redhat.com>
Subject: Re: [RFC PATCH 2/4] rseq: Allow extending struct rseq
Message-ID: <20200715105943.3xbbwbzwc6drughf@wittgenstein>
References: <20200714030348.6214-1-mathieu.desnoyers@efficios.com>
 <20200714030348.6214-3-mathieu.desnoyers@efficios.com>
 <CAFTs51UHaUqaKj5bEj0vQtEZrww9gnrqb-kGVk7DAgQJPBAR+w@mail.gmail.com>
 <775688146.12145.1594748580461.JavaMail.zimbra@efficios.com>
 <CAPNVh5fiCCJpyeLj_ciWzFrO4fasVXZNhpfKXJhJWJirXdJOjQ@mail.gmail.com>
 <CAEE+ybmt4BredezuTPdh-vf=FkKtu0yAhWuf+0daUe89AnbmPg@mail.gmail.com>
 <87k0z5xpau.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87k0z5xpau.fsf@mid.deneb.enyo.de>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Jul 15, 2020 at 08:31:05AM +0200, Florian Weimer wrote:
> * Chris Kennelly:
> 
> > When glibc provides registration, is the anticipated use case that a
> > library would unregister and reregister each thread to "upgrade" it to
> > the most modern version of interface it knows about provided by the
> > kernel?
> 
> Absolutely not, that is likely to break other consumers because an
> expected rseq area becomes dormant instead.
> 
> > There, I could assume an all-or-nothing registration of the new
> > feature--limited only by kernel availability for thread
> > homogeneity--but inconsistencies across early adopter libraries would
> > mean each thread would have to examine its own TLS to determine if a
> > feature were available.

Fwiw, I pointed this out in the discussions that led up to this
patchset. I don't see how this can work if threads don't check for their
feature set.

> 
> Exactly.  Certain uses of seccomp can also have this effect,
> presenting a non-homogeneous view.

Good point. There might be threads with a seccomp filter that would
block rseq features is what you mean, I assume.

Christian
