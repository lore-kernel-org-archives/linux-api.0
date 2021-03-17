Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534D8C433E0
	for <linux-api@archiver.kernel.org>; Wed, 17 Mar 2021 19:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E70CE64E74
	for <linux-api@archiver.kernel.org>; Wed, 17 Mar 2021 19:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhCQTUj (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 17 Mar 2021 15:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233131AbhCQTUJ (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 17 Mar 2021 15:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 106B261584;
        Wed, 17 Mar 2021 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616008799;
        bh=XiQPm/e8mVsPSTt9gN6hVu81RNW9JrYXw0LrOzZ7DoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DwBucPQ+7adfplBUCb0/84DFy/xK/123m4J2fEqkyIk8Tl2fNSQ5e6reJMUhBPL/Z
         2xs3mG6tm3USNA+2QLyN0+RpUHfoyZk0ScOVS/0MvLIHvfJI1V1Immuns/Fc8LPmjZ
         zeDBOdWXWUKZFM3O+hZjNjOs/avDj18FEPxQv4bk=
Date:   Wed, 17 Mar 2021 20:19:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     min.li.xe@renesas.com
Cc:     derek.kiernan@xilinx.com, dragan.cvetic@xilinx.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH net-next v1] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Message-ID: <YFJWWrX+UgXyD9NS@kroah.com>
References: <1616007596-2402-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616007596-2402-1-git-send-email-min.li.xe@renesas.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Mar 17, 2021 at 02:59:56PM -0400, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> This driver is developed for the IDT ClockMatrix(TM) and 82P33xxx families
> of timing and synchronization devices.It will be used by Renesas PTP Clock
> Manager for Linux (pcm4l) software to provide support to GNSS assisted
> partial timing support (APTS) and other networking timing functions.
> 
> Current version provides kernel API's to support the following functions
> -set combomode to enable SYNCE clock support
> -read dpll's state to determine if the dpll is locked to the GNSS channel
> -read dpll's ffo (fractional frequency offset)
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Why the "net-next" in the subject line?

This is not for the network tree (given that you didn't even cc:
netdev...) or am I confused?

thanks,

gre gk-h
