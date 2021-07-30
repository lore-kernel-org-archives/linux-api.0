Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17281C4338F
	for <linux-api@archiver.kernel.org>; Fri, 30 Jul 2021 07:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E92186103B
	for <linux-api@archiver.kernel.org>; Fri, 30 Jul 2021 07:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbhG3HXb (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 30 Jul 2021 03:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237726AbhG3HXb (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 30 Jul 2021 03:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21DB360BD3;
        Fri, 30 Jul 2021 07:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627629805;
        bh=TAWpNPWPtE6aqY/b/bOHIaT1gyZ70MrhbXPk1T3qRPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lyEWJ15U19tVJxWP1MqNvsXbRy23RGmCbe2VJ09aos3rF2IyvUBRxkHS6Jq3jkSIy
         HvMif0xC6dYugblgV+7hFzq4YXK7X1ai2xLL8Xu0VPw4LKFSqPUzUX0cNocxfXooUY
         xViEu0lGyzP9j70vkskX6teg6fOxQplT9Xf3APZ0=
Date:   Fri, 30 Jul 2021 09:23:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zicheng Wang <wzc@smail.nju.edu.cn>
Cc:     linux-api@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] corrent sys_reboot annotation
Message-ID: <YQOo6mq0ThH7L/DS@kroah.com>
References: <20210730064032.101113-1-wzc@smail.nju.edu.cn>
 <YQOiI/rxCBSxkdW2@kroah.com>
 <6103a3a5.1c69fb81.68c3a.0c9aSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6103a3a5.1c69fb81.68c3a.0c9aSMTPIN_ADDED_BROKEN@mx.google.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Jul 30, 2021 at 03:00:47PM +0800, Zicheng Wang wrote:
> 
> 在 2021/7/30 14:54, Greg KH 写道:
> > On Fri, Jul 30, 2021 at 02:40:32PM +0800, Wang Zi-cheng wrote:
> > > Signed-off-by: Wang Zi-cheng <wzc@smail.nju.edu.cn>
> > You forgot a changelog text :(
> 
> 
> Sorry, and what should I write for a changelog?

You tell me, you are the one that determined this needed a change, not
me :)

Also, your subject is odd and needs to be fixed, please see the
documentation for how to write good kernel changelogs and subject lines.

Also, when starting out, I would recommend working in the
drivers/staging/ part of the kernel until you learn these basic skills
as that is the part of the kernel best for that.

thanks,

greg k-h
