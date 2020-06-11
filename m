Return-Path: <SRS0=gqds=7Y=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81E3C433E0
	for <linux-api@archiver.kernel.org>; Thu, 11 Jun 2020 17:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 508EA207ED
	for <linux-api@archiver.kernel.org>; Thu, 11 Jun 2020 17:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="JEBUgERH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFKRry (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 11 Jun 2020 13:47:54 -0400
Received: from mail.efficios.com ([167.114.26.124]:46392 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgFKRrx (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 11 Jun 2020 13:47:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A05522BA1DF;
        Thu, 11 Jun 2020 13:47:52 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id NzCbs28iN5me; Thu, 11 Jun 2020 13:47:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 466342BA62B;
        Thu, 11 Jun 2020 13:47:52 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 466342BA62B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1591897672;
        bh=1TbQ8X9sMo4Kyo/r88yv2xIYB6h6ej7fHmdbLm+Aw4c=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=JEBUgERHzozSOhf4V0dkYHPmIKLI1d/tmPKm10dhKizvnDxe0kKer+Vbj15eoTmcX
         9a40GLxM5kbBr40mdYUo4iPqwIkOMW24p8LwoTqEdD/M1PK/c4yUinY8+3FXQlmbfj
         SokOXYHdr+4a9cpmBEIuQrlcw1EIXVwOEjEFT4L6BOuBMIkB78oIto2d6SS/DhHOXt
         7ckqPWPnNGC/ms98JdVu+/N7Wlrjae4ZcZKSpNQMSoGi5qEYNEPh9bTKRwBHmWeTAa
         9EYcImNf1c4rtJtp0xNRoiJyPvtijXrx9WtLDZoRM92rZQnUZEFy3Q0MSlhwuvLm1x
         zPc2zcI8hyT8A==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IfOlAu90uq-G; Thu, 11 Jun 2020 13:47:52 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 3397A2BA177;
        Thu, 11 Jun 2020 13:47:52 -0400 (EDT)
Date:   Thu, 11 Jun 2020 13:47:52 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Joseph Myers <joseph@codesourcery.com>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        Florian Weimer <fweimer@redhat.com>,
        Rich Felker <dalias@libc.org>,
        libc-alpha <libc-alpha@sourceware.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-api <linux-api@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Maurer <bmaurer@fb.com>, Dave Watson <davejwatson@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>
Message-ID: <419546979.1229.1591897672174.JavaMail.zimbra@efficios.com>
In-Reply-To: <alpine.DEB.2.21.2006041745360.8237@digraph.polyomino.org.uk>
References: <20200527185130.5604-1-mathieu.desnoyers@efficios.com> <20200527185130.5604-2-mathieu.desnoyers@efficios.com> <87d06gxsla.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.2006031718070.7179@digraph.polyomino.org.uk> <188671972.53608.1591269056445.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.2006041745360.8237@digraph.polyomino.org.uk>
Subject: Re: [PATCH glibc 1/3] glibc: Perform rseq registration at C startup
 and thread creation (v20)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: glibc: Perform rseq registration at C startup and thread creation (v20)
Thread-Index: WQcwWCSA3B8qyXRzTZbTtj4Cnk7X+g==
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

----- On Jun 4, 2020, at 1:46 PM, Joseph Myers joseph@codesourcery.com wrote:

> On Thu, 4 Jun 2020, Mathieu Desnoyers via Libc-alpha wrote:
> 
>> That external piece of documentation would be part of the Linux man-pages
>> project, maintained by Michael Kerrisk. I have submitted a few revisions
>> of the rseq(2) man page, but have been waiting for Michael to reply for more
>> than a year now:
>> 
>>   https://lore.kernel.org/r/2021826204.69809.1588000508294.JavaMail.zimbra@efficios.com
>> 
>> I'm thinking about hosting a rseq(2) man-page into my librseq project, would
>> that make sense ?
> 
> I'm not particularly concerned with exactly where it goes, as long as it's
> somewhere stable we can link to.

I managed to get a repository up and running for librseq, and have integrated
the rseq.2 man page with comments from Michael Kerrisk here:

https://git.kernel.org/pub/scm/libs/librseq/librseq.git/tree/doc/man/rseq.2

Is that a suitable URL ? Can we simply point to it from glibc's manual ?

Thanks,

Mathieu


> 
> --
> Joseph S. Myers
> joseph@codesourcery.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
