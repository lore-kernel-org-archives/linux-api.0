Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72AEC4338F
	for <linux-api@archiver.kernel.org>; Sat,  7 Aug 2021 11:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 825E960C51
	for <linux-api@archiver.kernel.org>; Sat,  7 Aug 2021 11:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhHGLBg (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 7 Aug 2021 07:01:36 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:43134 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhHGLBc (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 7 Aug 2021 07:01:32 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 3AA4072C8F8;
        Sat,  7 Aug 2021 14:01:13 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 2BC177CF71A; Sat,  7 Aug 2021 14:01:13 +0300 (MSK)
Date:   Sat, 7 Aug 2021 14:01:13 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Chris Hyser <chris.hyser@oracle.com>,
        Josh Don <joshdon@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dmitry V. Levin" <ldv@strace.io>, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] uapi: expose enum pid_type as enum __kernel_pidtype
Message-ID: <20210807110113.GB9671@altlinux.org>
References: <20210807104800.GA22620@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807104800.GA22620@asgard.redhat.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sat, Aug 07, 2021 at 12:48:00PM +0200, Eugene Syromiatnikov wrote:
[...]
> diff --git a/include/uapi/linux/pidtype.h b/include/uapi/linux/pidtype.h
> new file mode 100644
> index 0000000..2105ae3
> --- /dev/null
> +++ b/include/uapi/linux/pidtype.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_PID_H
> +#define _UAPI_LINUX_PID_H

Did you mean _UAPI_LINUX_PIDTYPE_H here?


-- 
ldv
