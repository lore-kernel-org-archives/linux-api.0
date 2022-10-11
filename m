Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486C4C433F5
	for <linux-api@archiver.kernel.org>; Tue, 11 Oct 2022 15:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiJKPYf (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 11 Oct 2022 11:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJKPYQ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 11 Oct 2022 11:24:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5269FD57C0;
        Tue, 11 Oct 2022 08:15:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0D84A20121;
        Tue, 11 Oct 2022 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1665500416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RO0FO74ctDC9cFYZEDLiw7BGFiXGuRuOlnU9ALUUx4Q=;
        b=UdX58LtbOBVnHrZvPxzq+OnrT4JBCxyKX7In8GNplrTy13057zqHjS17NhVXO+X6uvxB+F
        yWFaRqu7LeV7MI2FHa89kpRAGRakFbDpECYhA7UBIDylrvfmtmTE9wEJI6mhsWJfIxmD+O
        f+rcsieq2uSRQGfJSh//Jbj6k19Qu2A=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C78AC139ED;
        Tue, 11 Oct 2022 15:00:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fuh0LP+ERWNxSQAAMHmgww
        (envelope-from <mhocko@suse.com>); Tue, 11 Oct 2022 15:00:15 +0000
Date:   Tue, 11 Oct 2022 17:00:14 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Frank van der Linden <fvdl@google.com>
Cc:     Zhongkun He <hezhongkun.hzk@bytedance.com>, corbet@lwn.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, wuyun.abel@bytedance.com
Subject: Re: [RFC] mm: add new syscall pidfd_set_mempolicy()
Message-ID: <Y0WE/lEiNvl2ljo1@dhcp22.suse.cz>
References: <20221010094842.4123037-1-hezhongkun.hzk@bytedance.com>
 <CAPTztWYTGOb8ZQzfgThqJn+fyi4ZB8=JQQZi5_rUoDhdftKtvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPTztWYTGOb8ZQzfgThqJn+fyi4ZB8=JQQZi5_rUoDhdftKtvg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon 10-10-22 09:22:13, Frank van der Linden wrote:
> For consistency with process_madvise(), I would suggest calling it
> process_set_mempolicy.

This operation has per-thread rather than per-process semantic so I do
not think your proposed naming is better.

> Other than that, this makes sense. To complete
> the set, perhaps a process_mbind() should be added as well. What do
> you think?

Is there any real usecase for this interface? How is the caller supposed
to make per-range decisions without a very involved coordination with
the target process?
-- 
Michal Hocko
SUSE Labs
