Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D09C5519F
	for <linux-api@archiver.kernel.org>; Tue, 17 Nov 2020 18:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6205324180
	for <linux-api@archiver.kernel.org>; Tue, 17 Nov 2020 18:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgKQSom (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 17 Nov 2020 13:44:42 -0500
Received: from albireo.enyo.de ([37.24.231.21]:48848 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgKQSol (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 17 Nov 2020 13:44:41 -0500
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1kf5xy-00007U-EN; Tue, 17 Nov 2020 18:44:34 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1kf5xy-0003gD-9j; Tue, 17 Nov 2020 19:44:34 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-toolchains@vger.kernel.org
Subject: Re: Is adding an argument to an existing syscall okay?
References: <CALCETrXU2KcH0nsH_vd-fmvpZt_yW2+=VnYtN_BQJ6xsSvm+6A@mail.gmail.com>
        <87k0uj6h03.fsf@mid.deneb.enyo.de>
        <20201117183652.GD2672@gate.crashing.org>
Date:   Tue, 17 Nov 2020 19:44:34 +0100
In-Reply-To: <20201117183652.GD2672@gate.crashing.org> (Segher Boessenkool's
        message of "Tue, 17 Nov 2020 12:36:52 -0600")
Message-ID: <87r1or4yct.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

* Segher Boessenkool:

> But this isn't variadic in the sense of "..." -- on Power that always
> passes the unspecified arguments in memory, while in this case it just
> passes in either two or three registers.  I don't know any arg where
> that would not work, given the Linux system call restrictions.
>
> This is similar to the "open" system call.

Exactly.  You cannot call the open function through a non-variadic
function pointer.  I've seen it cause stack corruption in practice:

commit c7774174beffe9a8d29dd4fb38bbed43ece1cecd
Author: Andreas Schneider <asn@samba.org>
Date:   Wed Aug 2 13:21:59 2017 +0200

    swrap: Fix prototype of open[64] to prevent segfault on ppc64le
    
    The calling conventions for vaarg are different on ppc64le. The patch
    fixes segfaults on that platform.
    
    Thanks to Florian Weimer who helped debugging it!
    
    Signed-off-by: Andreas Schneider <asn@samba.org>
    Reviewed-by: Stefan Metzmacher <metze@samba.org>

<https://git.samba.org/?p=socket_wrapper.git;a=commitdiff;h=c7774174beffe>

It is possible to implement the open function in such a way that it
does not have this problem (simply do not use the parameter save area,
using assembler if necessary), but it's another obscure step that libc
implementers would have to take.
