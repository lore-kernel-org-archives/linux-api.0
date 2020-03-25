Return-Path: <SRS0=7VMH=5K=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FE0C1975A
	for <linux-api@archiver.kernel.org>; Wed, 25 Mar 2020 09:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8DD20772
	for <linux-api@archiver.kernel.org>; Wed, 25 Mar 2020 09:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgCYJdS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 25 Mar 2020 05:33:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:58424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgCYJdS (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 25 Mar 2020 05:33:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7C6CEAAFD;
        Wed, 25 Mar 2020 09:33:15 +0000 (UTC)
Subject: Re: [PATCH V2] kernel/hung_task.c: Introduce sysctl to print all
 traces when a hung task is detected
To:     Kees Cook <keescook@chromium.org>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, mcgrof@kernel.org, yzaikin@google.com,
        tglx@linutronix.de, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org, cocci@systeme.lip6.fr,
        linux-api@vger.kernel.org, kernel@gpiccoli.net,
        randy Dunlap <rdunlap@infradead.org>
References: <20200323214618.28429-1-gpiccoli@canonical.com>
 <b73a6519-0529-e36f-fac5-e4b638ceb3cf@suse.cz>
 <eee335a2-e673-39bf-ae64-e49c66f74255@canonical.com>
 <202003241119.A666E1C694@keescook>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <9eab7f80-bad4-bcb1-7ec7-b6b90839b13a@suse.cz>
Date:   Wed, 25 Mar 2020 10:33:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202003241119.A666E1C694@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On 3/24/20 7:20 PM, Kees Cook wrote:
> On Tue, Mar 24, 2020 at 09:45:40AM -0300, Guilherme G. Piccoli wrote:
>> Thanks Randy and Vlastimil for the comments. I really liked your
>> approach Vlastimil, I agree that we have no reason to not have a generic
>> sysctl setting via cmdline mechanism - I'll rework this patch removing
>> the kernel parameter (same for other patch I just submitted).
> 
> I've been thinking we'll likely want to have a big patch series that
> removes all the old "duplicate" boot params and adds some kind of
> "alias" mechanism.
> 
> Vlastimil, have you happened to keep a list of other "redundant" boot
> params you've noticed in the kernel? I bet there are a lot. :)

Well, I found about 4 that mentioned sysctl in
Documentation/admin-guide/kernel-parameters.txt
I suspect there will be more, but won't be trivial to identify them.


