Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B6FC433ED
	for <linux-api@archiver.kernel.org>; Thu,  8 Apr 2021 06:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD8ED61175
	for <linux-api@archiver.kernel.org>; Thu,  8 Apr 2021 06:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhDHG4B (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 8 Apr 2021 02:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHG4B (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 8 Apr 2021 02:56:01 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5ACC061760;
        Wed,  7 Apr 2021 23:55:50 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8DBAE2224B;
        Thu,  8 Apr 2021 08:55:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1617864945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/Ib6E1aHyQ0zhhtE0Z7gd1zjY5vFtQFqY5uVvY+Uv0=;
        b=u/vC2TGnRp0P8lItXAZXWGe1sH6DNKY5I6Icz++fuvrfjfZiDtT/MvOWh6SduMAQimbj8h
        Yx0AQQJz1lxWZKonpLYAznp+3VjVw3iLJWq+K96n3Tsj+9mZH75BHtJnYHhXQUsRDNR3vD
        k8QXM8yPUYfIvo/rKPXE1U5MQebbBEg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 08 Apr 2021 08:55:42 +0200
From:   Michael Walle <michael@walle.cc>
To:     Tudor.Ambarus@microchip.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com
Subject: Re: [PATCH] mtd: add OTP (one-time-programmable) erase ioctl
In-Reply-To: <c8f6bd61-528e-0353-aa23-aaec2be2b3ff@microchip.com>
References: <20210303201819.2752-1-michael@walle.cc>
 <c8f6bd61-528e-0353-aa23-aaec2be2b3ff@microchip.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <904d986fbd6f718cf8b7b9fc54b339d4@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi Tudor,

Am 2021-04-08 07:51, schrieb Tudor.Ambarus@microchip.com:
> Would you please resend this patch, together with the mtd-utils
> and the SPI NOR patch in a single patch set? You'll help us all
> having all in a single place.

This has already been picked-up:
https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/commit/?h=mtd/next&id=e3c1f1c92d6ede3cfa09d6a103d3d1c1ef645e35

Although, I didn't receive an email notice.

-michael
