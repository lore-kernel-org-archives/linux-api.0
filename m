Return-Path: <SRS0=fNma=7R=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC66BC433DF
	for <linux-api@archiver.kernel.org>; Thu,  4 Jun 2020 17:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89FDB204EF
	for <linux-api@archiver.kernel.org>; Thu,  4 Jun 2020 17:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgFDRqL (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 4 Jun 2020 13:46:11 -0400
Received: from esa4.mentor.iphmx.com ([68.232.137.252]:30332 "EHLO
        esa4.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730056AbgFDRqL (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 4 Jun 2020 13:46:11 -0400
IronPort-SDR: 8SyGOdcLOgvNBI+ExI4CAJjYtCvlo76T662YYFOIiJJ28i/igbZHwuDJgAgaBBWVDtiiU/ma5z
 pENXMh71N/koeBHQoEffg8AZfUprRf62bgcNbfmnWB1Yvep0dAfG8JDTEAB54Ih0iRyMpyPT5m
 I0xgRAuS9sypJO++k5VRWmoMc4M+0boyUxnF4cD72ZI9FWkCMmdE1w5hL6pk/mwyB5BnRZXtSd
 5HNGRWhmBvbVuBuXh+kM2+jTshkbJtSp1V4DryQXUODyqMx7ZHGsKgrlfoWqTCfTvz0frIhKN0
 VjM=
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="49589522"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa4.mentor.iphmx.com with ESMTP; 04 Jun 2020 09:46:10 -0800
IronPort-SDR: /Eae7ikOMAXi4sSxnXgYKnwCNCA08+A9knW3Ryskk23Q27k/YepH0SbmYsmWYk0TDkb3ADaK5D
 cSZZcokunHWkK9AVnoSg9GFoegrxiookzt04ZcPIqAaPeW9CM6d/BXpBNCQi03upbLsfJkYGbb
 gE8r0AwbLXIi/7b6Nv5d92Xk7OW0RdqxjvkNLRUBrJ8jV2AcWYFOkRA3IKMicerej+iArVgomL
 IS6zEpoh6cnHGo9fsyT7EyFmA5Ou6PUYYL9vlaSMo/lQA02ay8eF22gizAQ7kogMNZEe2jj7pC
 /Bo=
Date:   Thu, 4 Jun 2020 17:46:03 +0000
From:   Joseph Myers <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC:     Michael Kerrisk <mtk.manpages@gmail.com>,
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
Subject: Re: [PATCH glibc 1/3] glibc: Perform rseq registration at C startup
 and thread creation (v20)
In-Reply-To: <188671972.53608.1591269056445.JavaMail.zimbra@efficios.com>
Message-ID: <alpine.DEB.2.21.2006041745360.8237@digraph.polyomino.org.uk>
References: <20200527185130.5604-1-mathieu.desnoyers@efficios.com> <20200527185130.5604-2-mathieu.desnoyers@efficios.com> <87d06gxsla.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.2006031718070.7179@digraph.polyomino.org.uk>
 <188671972.53608.1591269056445.JavaMail.zimbra@efficios.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-03.mgc.mentorg.com (139.181.222.3) To
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, 4 Jun 2020, Mathieu Desnoyers via Libc-alpha wrote:

> That external piece of documentation would be part of the Linux man-pages
> project, maintained by Michael Kerrisk. I have submitted a few revisions
> of the rseq(2) man page, but have been waiting for Michael to reply for more
> than a year now:
> 
>   https://lore.kernel.org/r/2021826204.69809.1588000508294.JavaMail.zimbra@efficios.com
> 
> I'm thinking about hosting a rseq(2) man-page into my librseq project, would
> that make sense ?

I'm not particularly concerned with exactly where it goes, as long as it's 
somewhere stable we can link to.

-- 
Joseph S. Myers
joseph@codesourcery.com
