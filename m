Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EA0C47096
	for <linux-api@archiver.kernel.org>; Thu,  3 Jun 2021 12:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39DF613F1
	for <linux-api@archiver.kernel.org>; Thu,  3 Jun 2021 12:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhFCMFe (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFCMFd (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 3 Jun 2021 08:05:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA29613E7;
        Thu,  3 Jun 2021 12:03:47 +0000 (UTC)
Date:   Thu, 3 Jun 2021 14:03:45 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        linux-api@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 0/2] Change quotactl_path() to an fd-based syscall
Message-ID: <20210603120345.ukoopjdc7ykkgjby@wittgenstein>
References: <20210602151553.30090-1-jack@suse.cz>
 <20210602151932.GB23647@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210602151932.GB23647@quack2.suse.cz>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Jun 02, 2021 at 05:19:32PM +0200, Jan Kara wrote:
> On Wed 02-06-21 17:15:51, Jan Kara wrote:
> > Hello,
> > 
> > this patch series changes Sasha's quotactl_path() syscall to an fd-based one
> > quotactl_fd() syscall and enables the syscall again. The fd-based syscall was
> > chosen over the path based one because there's no real need for the path -
> > identifying filesystem to operate on by fd is perfectly fine for quotactl and
> > thus we can avoid the need to specify all the details of path lookup in the
> > quotactl_path() API (and possibly keep that uptodate with all the developments
> > in that field).
> > 
> > Patches passed some basic functional testing. Please review.
> 
> Sorry Christian, I've messed up your address when submitting this series...

No problem at all. :)

Christian
