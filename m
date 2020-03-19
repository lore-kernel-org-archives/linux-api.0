Return-Path: <SRS0=vYuY=5E=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8382EC4332B
	for <linux-api@archiver.kernel.org>; Thu, 19 Mar 2020 02:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58AED20768
	for <linux-api@archiver.kernel.org>; Thu, 19 Mar 2020 02:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCSCQg (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 18 Mar 2020 22:16:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54150 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSCQf (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 18 Mar 2020 22:16:35 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEkjV-00Epvm-CK; Thu, 19 Mar 2020 02:16:29 +0000
Date:   Thu, 19 Mar 2020 02:16:29 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stas Sergeev <stsp@list.ru>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC][possible bug] when should SS_AUTODISARM have effect?
Message-ID: <20200319021629.GC23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

	Consider the following scenario:  SIGPIPE has SA_ONSTACK
handler, SIGSEGV - non-SA_ONSTACK one.  SIGPIPE is delivered
and we fail halfway through setting a sigframe for it.
OK, we get SIGSEGV forced in, which gets handled not on altstack.
But what should happen if we fail *after* having saved the
altstack settings into the sigframe that got abandoned?

	AFAICS, we get them reset and the original setting
entirely lost.  Shouldn't that thing be applied only after
we have succeeded in building the frame?  In signal_delivered(),
perhaps...

	I realize that this is out of scope for POSIX, so it's
not a matter of standard compliance, but it looks like a bit
of a QoI issue...
