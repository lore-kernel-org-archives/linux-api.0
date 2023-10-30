Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009ACC4332F
	for <linux-api@archiver.kernel.org>; Mon, 30 Oct 2023 20:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjJ3UV3 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 30 Oct 2023 16:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjJ3UV2 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 30 Oct 2023 16:21:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA9DF9
        for <linux-api@vger.kernel.org>; Mon, 30 Oct 2023 13:21:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D15C433C7;
        Mon, 30 Oct 2023 20:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1698697285;
        bh=Hc2kQm6YbC2hf0tYXL3GpNXuoqSnP+6gJ+xY1Y22Nrg=;
        h=Date:From:To:Subject:From;
        b=ufKyJKX1cDynvU9d9EfMBZJQ7KT6XTrRkGlda4LwDfDQM16cFfLaJ5XAyyzbLXR9f
         5oM+8vgJ94xyAp1swBZUvv1hsjca9NpgiX91l381IgTxzvR4MztBTm3WTpzOKEibI7
         MzCCaIxxDvcOjWtgupgGWt50fl62+VXjKLDHHWNc=
Date:   Mon, 30 Oct 2023 16:21:24 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     linux-api@vger.kernel.org
Subject: PSA: migrating linux-api to new vger infrastructure
Message-ID: <20231030-rampant-neat-pronghorn-ecabca@nitro>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Good day!

I plan to migrate the linux-api@vger.kernel.org list to the new infrastructure
this week. We're still doing it list-by-list to make sure that we don't run
into scaling issues with the new infra.

The migration will be performed live and should require any downtime.

Please speak up if you have any objections.

Best wishes,
-K
