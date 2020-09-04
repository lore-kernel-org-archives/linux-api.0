Return-Path: <SRS0=+ro9=CN=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E31C43461
	for <linux-api@archiver.kernel.org>; Fri,  4 Sep 2020 16:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42D132074D
	for <linux-api@archiver.kernel.org>; Fri,  4 Sep 2020 16:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIDQES (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 4 Sep 2020 12:04:18 -0400
Received: from verein.lst.de ([213.95.11.211]:42376 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgIDQES (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 4 Sep 2020 12:04:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1934268BEB; Fri,  4 Sep 2020 18:04:15 +0200 (CEST)
Date:   Fri, 4 Sep 2020 18:04:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Barret Rhoden <brho@google.com>
Cc:     hch@lst.de, gregkh@linuxfoundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, rafael@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        luto@kernel.org
Subject: Re: [PATCH] init: fix error check in clean_path()
Message-ID: <20200904160414.GA31683@lst.de>
References: <20200728163416.556521-22-hch@lst.de> <20200904135332.1130070-1-brho@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904135332.1130070-1-brho@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Sep 04, 2020 at 09:53:32AM -0400, Barret Rhoden wrote:
> init_stat() returns 0 on success, same as vfs_lstat().  When it replaced
> vfs_lstat(), the '!' was dropped.
> 
> Fixes: 716308a5331b ("init: add an init_stat helper")
> Signed-off-by: Barret Rhoden <brho@google.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
