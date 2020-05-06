Return-Path: <SRS0=auF4=6U=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCC1C28CBC
	for <linux-api@archiver.kernel.org>; Wed,  6 May 2020 06:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7A61206E6
	for <linux-api@archiver.kernel.org>; Wed,  6 May 2020 06:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEFGJq (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 6 May 2020 02:09:46 -0400
Received: from verein.lst.de ([213.95.11.211]:39079 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgEFGJq (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 6 May 2020 02:09:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4601168C4E; Wed,  6 May 2020 08:09:44 +0200 (CEST)
Date:   Wed, 6 May 2020 08:09:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Martijn Coenen <maco@android.com>
Cc:     axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com,
        narayan@google.com, zezeozue@google.com, kernel-team@android.com,
        maco@google.com, bvanassche@acm.org, Chaitanya.Kulkarni@wdc.com,
        jaegeuk@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v4 10/10] loop: Add LOOP_CONFIGURE ioctl
Message-ID: <20200506060944.GG10771@lst.de>
References: <20200429140341.13294-1-maco@android.com> <20200429140341.13294-11-maco@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429140341.13294-11-maco@android.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Thanks, this looks very nice!

Reviewed-by: Christoph Hellwig <hch@lst.de>

Are you also going to submit a patch to util-linux to use the new
ioctl?
