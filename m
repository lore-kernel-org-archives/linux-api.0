Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDD1C4338F
	for <linux-api@archiver.kernel.org>; Fri, 20 Aug 2021 08:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C9BA61106
	for <linux-api@archiver.kernel.org>; Fri, 20 Aug 2021 08:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhHTIe5 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 20 Aug 2021 04:34:57 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50354 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhHTIe5 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 20 Aug 2021 04:34:57 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C2CAF1FDED;
        Fri, 20 Aug 2021 08:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629448458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j+c4ZdoO8G3O0f17auzxwdS43shP61k6ykFaMeET9zc=;
        b=kgL7kgRwc1KAWXp4SiKa78J18a/qP8swIOcpzhjvUV1kV28on5m4oqN2Wc2gDMX4zERi3o
        +4ArWoRzPN95r4isDdmq3ZiyuEJDia5dUeczIE8zR8yV0ZkTQq+9UGq0O1RnDIIKK4e7ox
        eqRe74lyZsC2iPkXAFr4RePMjhQBBsU=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 66B2A13883;
        Fri, 20 Aug 2021 08:34:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id MwKKFgppH2EdTAAAGKfGzw
        (envelope-from <nborisov@suse.com>); Fri, 20 Aug 2021 08:34:18 +0000
Subject: Re: [PATCH v10 04/14] btrfs: add ram_bytes and offset to
 btrfs_ordered_extent
To:     Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-api@vger.kernel.org
References: <cover.1629234193.git.osandov@fb.com>
 <463897807ed0366188b9966ae5b722daaf299ec0.1629234193.git.osandov@fb.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <e69e1e3c-6338-d0e4-626a-a2fa9886de7a@suse.com>
Date:   Fri, 20 Aug 2021 11:34:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <463897807ed0366188b9966ae5b722daaf299ec0.1629234193.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org



On 18.08.21 г. 0:06, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Currently, we only create ordered extents when ram_bytes == num_bytes
> and offset == 0. However, RWF_ENCODED writes may create extents which
> only refer to a subset of the full unencoded extent, so we need to plumb

Can you give an example of such a case?

