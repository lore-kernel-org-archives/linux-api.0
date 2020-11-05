Return-Path: <SRS0=3rNV=EL=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAA7C00A89
	for <linux-api@archiver.kernel.org>; Thu,  5 Nov 2020 09:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDF0D2151B
	for <linux-api@archiver.kernel.org>; Thu,  5 Nov 2020 09:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604568122;
	bh=mF+d9sIm/MeYnn43YMxCszIzEO4a0JVy1XN+RmmDr2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FTVfeGKa9JMCVu/Cy+vqmUbMG69I59mvxRK4bsHci82x7bNIrr+GUeYgOs3OR1tQJ
	 Yo6ZaTsEmyKGMaQbJimja41pLf2Ve4s7BiX2F52eRnDMqWaUC2cdyTWMbkdbRg6hRC
	 61Jmo/4TBfM0GtCI6rVTXV+Qd9XLyj/GhACuxnRc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgKEJV6 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgKEJV5 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 5 Nov 2020 04:21:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32D3820786;
        Thu,  5 Nov 2020 09:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604568116;
        bh=mF+d9sIm/MeYnn43YMxCszIzEO4a0JVy1XN+RmmDr2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HrklGPu25k2eVteIqn2VXi8jVAZLdT1hk/UZ5muAnSdLqinlPVtA/3yPruuTgJCYR
         ygc6iTA0gyoXBAZNe1ENb+P6pmEBaj3dmAEDWMA0z1RfbQF/ADvQKpKNtAPyAIUN2O
         Pe8UDkSBz7DN/wDNtAWHS4qcXgZ57QgFpYTvSjf8=
Date:   Thu, 5 Nov 2020 10:22:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        paul@paul-moore.com, sds@tycho.nsa.gov,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v22 12/23] LSM: Specify which LSM to display
Message-ID: <20201105092245.GB3439341@kroah.com>
References: <20201104234114.11346-1-casey@schaufler-ca.com>
 <20201104234114.11346-13-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104234114.11346-13-casey@schaufler-ca.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Nov 04, 2020 at 03:41:03PM -0800, Casey Schaufler wrote:
> Create a new entry "display" in the procfs attr directory for
> controlling which LSM security information is displayed for a
> process. A process can only read or write its own display value.
> 
> The name of an active LSM that supplies hooks for
> human readable data may be written to "display" to set the
> value. The name of the LSM currently in use can be read from
> "display". At this point there can only be one LSM capable
> of display active. A helper function lsm_task_display() is
> provided to get the display slot for a task_struct.
> 
> Setting the "display" requires that all security modules using
> setprocattr hooks allow the action. Each security module is
> responsible for defining its policy.
> 
> AppArmor hook provided by John Johansen <john.johansen@canonical.com>
> SELinux hook provided by Stephen Smalley <sds@tycho.nsa.gov>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Acked-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: linux-api@vger.kernel.org
> ---
>  fs/proc/base.c                       |   1 +
>  include/linux/lsm_hooks.h            |  17 +++
>  security/apparmor/include/apparmor.h |   3 +-
>  security/apparmor/lsm.c              |  32 +++++
>  security/security.c                  | 169 ++++++++++++++++++++++++---
>  security/selinux/hooks.c             |  11 ++
>  security/selinux/include/classmap.h  |   2 +-
>  security/smack/smack_lsm.c           |   7 ++
>  8 files changed, 223 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 0f707003dda5..7432f24f0132 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2806,6 +2806,7 @@ static const struct pid_entry attr_dir_stuff[] = {
>  	ATTR(NULL, "fscreate",		0666),
>  	ATTR(NULL, "keycreate",		0666),
>  	ATTR(NULL, "sockcreate",	0666),
> +	ATTR(NULL, "display",		0666),

That's a vague name, any chance it can be more descriptive?

And where is the Documentation/ABI/ entries for all of this, how does
userspace know what these things are, and how to use them?

thanks,

greg k-h
