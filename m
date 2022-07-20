Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFD2C43334
	for <linux-api@archiver.kernel.org>; Wed, 20 Jul 2022 14:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiGTOL3 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 20 Jul 2022 10:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiGTOL2 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 20 Jul 2022 10:11:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0507B4C61D;
        Wed, 20 Jul 2022 07:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FfBAUY2VINzd7/hZdmnYyQKs4GYCVpLDOLzWtysprLM=; b=ORLdWZ8K1zi4u+eqHrEEoZPAlF
        J/9/3ledj6TzPUeuBHfq2AMfjBXUZfYkSyJiBw5p70U1+23aQ3cVpXdbcQF0Qc1/o4NAA8p6Bi/JL
        bwspF0Fz4YpASZkAwFeGK1m1JLG4DiNpDcxt+VQgaSidzxzrURt/IU4HEeK4FK54gxXEXOIeHRdXa
        7hO04XpiaQlCQahqDMoeHmo/gzquskHKEKe2FJAxcg0kT7DL2PgOyNDqxxOLU+WOH5P0Q+9CvnI18
        5lMdaMfImFBqKWta9NRl1UEO5jJbNhRES215C9X8+2uBcgC90V7AKj3ihjUvoiDvxhkrW7efgVC7b
        YGIArIqg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oEAQ5-00EWYg-Jx; Wed, 20 Jul 2022 14:11:21 +0000
Date:   Wed, 20 Jul 2022 15:11:21 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Jeremy Bongio <bongiojp@gmail.com>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4] Add ioctls to get/set the ext4 superblock uuid.
Message-ID: <YtgNCfMcuX7DGg7z@casper.infradead.org>
References: <20220719234131.235187-1-bongiojp@gmail.com>
 <Ytd0G0glVWdv+iaD@casper.infradead.org>
 <Ytd28d36kwdYWkVZ@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytd28d36kwdYWkVZ@magnolia>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Jul 19, 2022 at 08:30:57PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 20, 2022 at 04:18:51AM +0100, Matthew Wilcox wrote:
> > On Tue, Jul 19, 2022 at 04:41:31PM -0700, Jeremy Bongio wrote:
> > > +/*
> > > + * Structure for EXT4_IOC_GETFSUUID/EXT4_IOC_SETFSUUID
> > > + */
> > > +struct fsuuid {
> > > +	__u32       fsu_len;
> > > +	__u32       fsu_flags;
> > > +	__u8        fsu_uuid[];
> > > +};
> > 
> > A UUID has a defined size (128 bits):
> > https://en.wikipedia.org/wiki/Universally_unique_identifier
> > 
> > Why are we defining flags and len?
> 
> @flags because XFS actually need to add a superblock feature bit
> (meta_uuid) to change the UUID while the fs is mounted.  That kind of
> change can break backwards compatiblity, so we might want to make
> *absolutely sure* that the sysadmin is aware of this:

OK.  So we'll define a 'force' flag at some point in the future.  Got it.

> @len because some filesystems like vfat have volume identifiers that
> aren't actually UUIDs (they're u32); some day someone might want to port
> vfat to implement at least the GETFSUUID part (they already have
> FAT_IOCTL_GET_VOLUME_ID); and given the amount of confusion that results
> when buffer lengths are implied (see [GS]ETFSLABEL) I'd rather this pair
> of ioctls be explicit about the buffer length now rather than deal with
> the fallout of omitting it now and regretting it later.

Uhhh.  So what are the semantics of len?  That is, on SET, what does
a filesystem do if userspace says "Here's 8 bytes" but the filesystem
usually uses 16 bytes?  What does the same filesystem do if userspace
offers it 32 bytes?  If the answer is "returns -EINVAL", how does
userspace discover what size of volume ID is acceptable to a particular
filesystem?

And then, on GET, does 'len' just mean "here's the length of the buffer,
put however much will fit into it"?  Should filesystems update it to
inform userspace how much was transferred?

I think there was mention of a manpage earlier.  And if this is truly
for "volume ID" instead of "UUID", then lets call it "volume ID" and
not "UUID" to prevent confusion.
