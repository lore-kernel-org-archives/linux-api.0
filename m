Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6A4C48BE8
	for <linux-api@archiver.kernel.org>; Tue, 15 Jun 2021 11:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2D596145E
	for <linux-api@archiver.kernel.org>; Tue, 15 Jun 2021 11:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhFOLhc (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 15 Jun 2021 07:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229528AbhFOLhb (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 15 Jun 2021 07:37:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A015B61107;
        Tue, 15 Jun 2021 11:35:25 +0000 (UTC)
Date:   Tue, 15 Jun 2021 13:35:22 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Matthew Bobrowski <repnop@google.com>
Cc:     jack@suse.cz, amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 2/5] kernel/pid.c: implement additional checks upon
 pidfd_create() parameters
Message-ID: <20210615113522.kasddqrm6sedn5tj@wittgenstein>
References: <cover.1623282854.git.repnop@google.com>
 <3020418a466bc3f4e90413c3c98c29a1a93fd59f.1623282854.git.repnop@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3020418a466bc3f4e90413c3c98c29a1a93fd59f.1623282854.git.repnop@google.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Jun 10, 2021 at 10:20:43AM +1000, Matthew Bobrowski wrote:
> By adding the pidfd_create() declaration to linux/pid.h, we
> effectively expose this function to the rest of the kernel. In order
> to avoid any unintended behaviour, or set false expectations upon this
> function, ensure that constraints are forced upon each of the passed
> parameters. This includes the checking of whether the passed struct
> pid is a thread-group leader as pidfd creation is currently limited to
> such pid types.
> 
> Signed-off-by: Matthew Bobrowski <repnop@google.com>
> ---

Looks good,
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
