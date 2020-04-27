Return-Path: <SRS0=bzj+=6L=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899B7C54FCB
	for <linux-api@archiver.kernel.org>; Mon, 27 Apr 2020 14:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B2FE206BF
	for <linux-api@archiver.kernel.org>; Mon, 27 Apr 2020 14:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgD0O6P (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:58:15 -0400
Received: from verein.lst.de ([213.95.11.211]:48813 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbgD0O6O (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Mon, 27 Apr 2020 10:58:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0820A68C7B; Mon, 27 Apr 2020 16:58:13 +0200 (CEST)
Date:   Mon, 27 Apr 2020 16:58:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Martijn Coenen <maco@android.com>
Cc:     axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com,
        narayan@google.com, zezeozue@google.com, kernel-team@android.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        maco@google.com, bvanassche@acm.org, Chaitanya.Kulkarni@wdc.com,
        jaegeuk@kernel.org, Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 9/9] loop: Add LOOP_SET_FD_AND_STATUS ioctl
Message-ID: <20200427145812.GI5490@lst.de>
References: <20200427074222.65369-1-maco@android.com> <20200427074222.65369-10-maco@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427074222.65369-10-maco@android.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
