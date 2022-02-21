Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5650AC433EF
	for <linux-api@archiver.kernel.org>; Mon, 21 Feb 2022 02:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbiBUCYY (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 20 Feb 2022 21:24:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343681AbiBUCYG (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 20 Feb 2022 21:24:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FB63C703;
        Sun, 20 Feb 2022 18:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D39EB80E48;
        Mon, 21 Feb 2022 02:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CE2C340F5;
        Mon, 21 Feb 2022 02:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645410211;
        bh=+f42uaVoaynmzvwmeFuqeFek1G2q6WaVoSIttveoc8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLvxKXaKx0rMZKnbOvnm3aDrNWfwxuV/c8/wQLOuIU3L2P/7R8+zQdXY52FE614ZS
         9L2Pb2ol73j8BsrUFxxUI+9L+4kUXAXgDhvpWKT0NNV2azcRVLinU1X3WTUdfphXn2
         ugad5JGWoEL+ow43PZzZ5xPrat2Az80vP/ZZAaLXMkhZqzETW6e0glh/YVrKscYttp
         5mrBx3z9iQVemas6NXu8JCUWjIP2rBWGj7dDa/b+gVIeSRRMAoxai0sAONIpamxajB
         75QMoQZ0GIOmxECAI0cBQoOCrr3nBM89bg+k3zMkKLt02yoic+V3udmWcy4BOK9/Su
         0bx4nPXNoDuaw==
Date:   Sun, 20 Feb 2022 18:23:29 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 0/3] block: show crypto capabilities in sysfs
Message-ID: <YhL3obBiHO92EcEc@sol.localdomain>
References: <20220124215938.2769-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124215938.2769-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Jan 24, 2022 at 01:59:35PM -0800, Eric Biggers wrote:
> This series adds sysfs files that expose the inline encryption
> capabilities of request queues.
> 
> Patches 1 and 2 are some related cleanups for existing blk-sysfs code.
> Patch 3 is the real change; see there for more details.
> 
> This series applies to v5.17-rc1.
> 
> Changed v3 => v4:
>    - Reworded a comment in patch 2.
>    - Updated dates in sysfs documentation.
>    - Added more Reviewed-by tags.
> 
> Changed v2 => v3:
>    - Moved the documentation into Documentation/ABI/stable/sysfs-block,
>      and improved it a bit.
>    - Write "/sys/block/" instead of "/sys/class/block/".
>    - Added Reviewed-by tags.
> 
> Changed v1 => v2:
>    - Use sysfs_emit() instead of sprintf().
>    - Use __ATTR_RO().
> 
> Eric Biggers (3):
>   block: simplify calling convention of elv_unregister_queue()
>   block: don't delete queue kobject before its children
>   blk-crypto: show crypto capabilities in sysfs
> 

Any more feedback on this?

- Eric
