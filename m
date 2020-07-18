Return-Path: <SRS0=xOp5=A5=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C49C433E4
	for <linux-api@archiver.kernel.org>; Sat, 18 Jul 2020 01:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 410142070E
	for <linux-api@archiver.kernel.org>; Sat, 18 Jul 2020 01:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgGRB43 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 17 Jul 2020 21:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGRB43 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 17 Jul 2020 21:56:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9B1C0619D2;
        Fri, 17 Jul 2020 18:56:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3633D11E45916;
        Fri, 17 Jul 2020 18:56:29 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:56:28 -0700 (PDT)
Message-Id: <20200717.185628.2081788534116318446.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nsekhar@ti.com, grygorii.strashko@ti.com, vinicius.gomes@intel.com
Subject: Re: [net-next PATCH v3 2/7] net: hsr: introduce common code for
 skb initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717151511.329-3-m-karicheri2@ti.com>
References: <20200717151511.329-1-m-karicheri2@ti.com>
        <20200717151511.329-3-m-karicheri2@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:56:29 -0700 (PDT)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Fri, 17 Jul 2020 11:15:06 -0400

> +static void send_hsr_supervision_frame(struct hsr_port *master,
> +				       u8 type, u8 hsr_ver)
> +{
> +	struct sk_buff *skb;
> +	struct hsr_tag *hsr_tag;
> +	struct hsr_sup_tag *hsr_stag;
> +	struct hsr_sup_payload *hsr_sp;
> +	unsigned long irqflags;

Reverse christmas tree please.
