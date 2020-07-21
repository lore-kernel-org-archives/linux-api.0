Return-Path: <SRS0=QVgP=BA=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FD3C433DF
	for <linux-api@archiver.kernel.org>; Tue, 21 Jul 2020 18:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD5772072E
	for <linux-api@archiver.kernel.org>; Tue, 21 Jul 2020 18:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGUS1F (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 21 Jul 2020 14:27:05 -0400
Received: from verein.lst.de ([213.95.11.211]:53387 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbgGUS1E (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 21 Jul 2020 14:27:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CFAA068AFE; Tue, 21 Jul 2020 20:27:01 +0200 (CEST)
Date:   Tue, 21 Jul 2020 20:27:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 06/24] md: open code vfs_stat in md_setup_drive
Message-ID: <20200721182701.GB14450@lst.de>
References: <20200721162818.197315-1-hch@lst.de> <20200721162818.197315-7-hch@lst.de> <20200721165539.GT2786714@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721165539.GT2786714@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Jul 21, 2020 at 05:55:39PM +0100, Al Viro wrote:
> How about fs/for_init.c and putting the damn helpers there?  With
> calling conventions as close to syscalls as possible, and a fat
> comment regarding their intended use being _ONLY_ the setup
> in should-have-been-done-in-userland parts of init?

Where do you want the prototypes to go?  Also do you want devtmpfs
use the same helpers, which then't can't be marked __init (mount,
chdir, chroot), or separate copies?
