Return-Path: <SRS0=15JI=6T=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DD9C47256
	for <linux-api@archiver.kernel.org>; Tue,  5 May 2020 05:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6BCE206B9
	for <linux-api@archiver.kernel.org>; Tue,  5 May 2020 05:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgEEFhc (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 5 May 2020 01:37:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:22727 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgEEFhc (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 5 May 2020 01:37:32 -0400
IronPort-SDR: bcTfvk6PM7ytSDCau187dU+P2qH1Rbpw+/JbfZub1nogcPxIpGEOBsAVHBvJTVRHB/tHycRk4A
 bDupKr3cYsCQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 22:37:31 -0700
IronPort-SDR: zFAf3C2fFCIeR+DYnQ/rhAZ32D5zz3tDoDVAj9kP7C27n7W9nw6AOBWEILatPauZI+LgndcSUh
 rpPGBtMBjFng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="259578742"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga003.jf.intel.com with ESMTP; 04 May 2020 22:37:31 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 7D623301C19; Mon,  4 May 2020 22:37:31 -0700 (PDT)
Date:   Mon, 4 May 2020 22:37:31 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] get_mempolicy(2) behaviour
Message-ID: <20200505053731.GA3538@tassilo.jf.intel.com>
References: <20200503192555.GT23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200503192555.GT23230@ZenIV.linux.org.uk>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Hi Al,

Yes it's quite a mess, but it's hard to change now.

> 	At the very least, compat behaviour ought to match what the native
> syscall wouldn't done on 32bit host. 

I suspect 32bit NUMA usage isn't that wide spread, but yes would make
sense.

> And having the manpage match
> the reality would be nice as well.  

Yep.

> Should we do something about the
> cases when the data gets quietly lost?

In theory it could break something, but I suppose the case is unlikely
enough that noone relies on it.

-Andi

