Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0F2C4338F
	for <linux-api@archiver.kernel.org>; Fri, 30 Jul 2021 06:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3136561008
	for <linux-api@archiver.kernel.org>; Fri, 30 Jul 2021 06:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237657AbhG3Gyf (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 30 Jul 2021 02:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237616AbhG3Gye (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 30 Jul 2021 02:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C18D660F6B;
        Fri, 30 Jul 2021 06:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627628070;
        bh=H46xsNB53TZiknPRtRGR1GJYyTltPyt3+oZZ8wWgtFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uvxE0wJjx0O2de0RD9DUzNDnUbqXMKXxd6O/HZZdF16hyn2HaKNDNxqGrqOrXu3zW
         a9NyNhD6eUtM0EX0asQJzL8lxTpYaTnl5Z/QLbKIqsE89jfWHK33x65fHTiM1Y8BS1
         SI9/mlN5WwS37HMlicF29zh6JktJ7b+4BevxFsvQ=
Date:   Fri, 30 Jul 2021 08:54:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wang Zi-cheng <wzc@smail.nju.edu.cn>
Cc:     linux-api@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] corrent sys_reboot annotation
Message-ID: <YQOiI/rxCBSxkdW2@kroah.com>
References: <20210730064032.101113-1-wzc@smail.nju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730064032.101113-1-wzc@smail.nju.edu.cn>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Jul 30, 2021 at 02:40:32PM +0800, Wang Zi-cheng wrote:
> Signed-off-by: Wang Zi-cheng <wzc@smail.nju.edu.cn>

You forgot a changelog text :(
