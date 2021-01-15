Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0A0C43333
	for <linux-api@archiver.kernel.org>; Fri, 15 Jan 2021 13:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 955CA2371F
	for <linux-api@archiver.kernel.org>; Fri, 15 Jan 2021 13:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbhAONG7 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:06:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:53642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388602AbhAONG5 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 15 Jan 2021 08:06:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1692EAC8F;
        Fri, 15 Jan 2021 13:06:15 +0000 (UTC)
Subject: Re: [PATCH v2 0/5] Add sysfs interface to collect reports from
 debugging tools
To:     Alexander Potapenko <glider@google.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Linux API <linux-api@vger.kernel.org>
Cc:     andreyknvl@google.com, dvyukov@google.com, mingo@redhat.com,
        elver@google.com, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, linux-mm@kvack.org
References: <20210115130336.2520663-1-glider@google.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <5ae22590-752e-7ea2-5341-a49a99e7507d@suse.cz>
Date:   Fri, 15 Jan 2021 14:06:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115130336.2520663-1-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Should have CCd linux-api@, please do next time

On 1/15/21 2:03 PM, Alexander Potapenko wrote:
> This patchset adds a library that captures error reports from debugging
> tools like KASAN or KFENCE and exposes those reports to userspace via
> sysfs. Report capturing is controlled by two new types of tracepoints:
> error_report_start and error_report_end, that must be added to the tools
> that want to use this new feature.
> 
> v2:
>  - added ABI documentation for /sys/kernel/error_report/
>  - changed error_report_start and error_report end tracepoints to take
>    a fixed set of values for the error detector
> 
> Alexander Potapenko (5):
>   tracing: add error_report trace points
>   lib: add error_report_notify to collect debugging tools' reports
>   docs: ABI: add /sys/kernel/error_report/ documentation
>   kfence: use error_report_start and error_report_end tracepoints
>   kasan: use error_report_start and error_report_end tracepoints
> 
>  .../ABI/testing/sysfs-kernel-error_report     |  41 +++
>  include/trace/events/error_report.h           |  84 ++++++
>  kernel/trace/Makefile                         |   1 +
>  kernel/trace/error_report-traces.c            |  11 +
>  lib/Kconfig.debug                             |  14 +
>  lib/Makefile                                  |   2 +
>  lib/error_report_notify.c                     | 278 ++++++++++++++++++
>  mm/kasan/report.c                             |  15 +-
>  mm/kfence/report.c                            |   3 +
>  9 files changed, 443 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-kernel-error_report
>  create mode 100644 include/trace/events/error_report.h
>  create mode 100644 kernel/trace/error_report-traces.c
>  create mode 100644 lib/error_report_notify.c
> 

