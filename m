Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDF8C4338F
	for <linux-api@archiver.kernel.org>; Wed, 11 Aug 2021 21:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED41861077
	for <linux-api@archiver.kernel.org>; Wed, 11 Aug 2021 21:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhHKVMh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 11 Aug 2021 17:12:37 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55444 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhHKVMg (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 11 Aug 2021 17:12:36 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 05F241F438CB
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Jan Kara <jack@suse.cz>
Cc:     jack@suse.com, amir73il@gmail.com, djwong@kernel.org,
        tytso@mit.edu, david@fromorbit.com, dhowells@redhat.com,
        khazhy@google.com, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-api@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCH v5 14/23] fanotify: Encode invalid file handler when no
 inode is provided
Organization: Collabora
References: <20210804160612.3575505-1-krisman@collabora.com>
        <20210804160612.3575505-15-krisman@collabora.com>
        <20210805095618.GF14483@quack2.suse.cz>
Date:   Wed, 11 Aug 2021 17:12:05 -0400
In-Reply-To: <20210805095618.GF14483@quack2.suse.cz> (Jan Kara's message of
        "Thu, 5 Aug 2021 11:56:18 +0200")
Message-ID: <87fsvf65zu.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Wed 04-08-21 12:06:03, Gabriel Krisman Bertazi wrote:
>> Instead of failing, encode an invalid file handler in fanotify_encode_fh
>> if no inode is provided.  This bogus file handler will be reported by
>> FAN_FS_ERROR for non-inode errors.
>> 
>> Also adjust the single caller that might rely on failure after passing
>> an empty inode.
>
> It is not 'file handler' but rather 'file handle' - several times in the
> changelog and in subject :).
>
>> Suggested-by: Amir Goldstein <amir73il@gmail.com>
>> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
>> ---
>>  fs/notify/fanotify/fanotify.c | 39 ++++++++++++++++++++---------------
>>  fs/notify/fanotify/fanotify.h |  6 ++++--
>>  2 files changed, 26 insertions(+), 19 deletions(-)
>> 
>> diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
>> index 0d6ba218bc01..456c60107d88 100644
>> --- a/fs/notify/fanotify/fanotify.c
>> +++ b/fs/notify/fanotify/fanotify.c
>> @@ -349,12 +349,6 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
>>  	void *buf = fh->buf;
>>  	int err;
>>  
>> -	fh->type = FILEID_ROOT;
>> -	fh->len = 0;
>> -	fh->flags = 0;
>> -	if (!inode)
>> -		return 0;
>> -
>
> I'd keep the fh->flags initialization here. Otherwise it will not be
> initialized on some error returns.
>
>> @@ -363,8 +357,9 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
>>  	if (fh_len < 4 || WARN_ON_ONCE(fh_len % 4))
>>  		goto out_err;
>>  
>> -	/* No external buffer in a variable size allocated fh */
>> -	if (gfp && fh_len > FANOTIFY_INLINE_FH_LEN) {
>> +	fh->flags = 0;
>> +	/* No external buffer in a variable size allocated fh or null fh */
>> +	if (inode && gfp && fh_len > FANOTIFY_INLINE_FH_LEN) {
>>  		/* Treat failure to allocate fh as failure to encode fh */
>>  		err = -ENOMEM;
>>  		ext_buf = kmalloc(fh_len, gfp);
>> @@ -376,14 +371,24 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
>>  		fh->flags |= FANOTIFY_FH_FLAG_EXT_BUF;
>>  	}
>>  
>> -	dwords = fh_len >> 2;
>> -	type = exportfs_encode_inode_fh(inode, buf, &dwords, NULL);
>> -	err = -EINVAL;
>> -	if (!type || type == FILEID_INVALID || fh_len != dwords << 2)
>> -		goto out_err;
>> -
>> -	fh->type = type;
>> -	fh->len = fh_len;
>> +	if (inode) {
>> +		dwords = fh_len >> 2;
>> +		type = exportfs_encode_inode_fh(inode, buf, &dwords, NULL);
>> +		err = -EINVAL;
>> +		if (!type || type == FILEID_INVALID || fh_len != dwords << 2)
>> +			goto out_err;
>> +		fh->type = type;
>> +		fh->len = fh_len;
>> +	} else {
>> +		/*
>> +		 * Invalid FHs are used on FAN_FS_ERROR for errors not
>> +		 * linked to any inode. Caller needs to guarantee the fh
>> +		 * has at least FANOTIFY_NULL_FH_LEN bytes of space.
>> +		 */
>> +		fh->type = FILEID_INVALID;
>> +		fh->len = FANOTIFY_NULL_FH_LEN;
>> +		memset(buf, 0, FANOTIFY_NULL_FH_LEN);
>> +	}
>
> Maybe it will become clearer later during the series but why do you set
> fh->len to FANOTIFY_NULL_FH_LEN and not 0?

Jan,

That is how we encode a NULL file handle (i.e. superblock error).  Amir
suggested it would be an invalid FILEID_INVALID, with a zeroed handle of
size 8.  I will improve the comment on the next iteration.

-- 
Gabriel Krisman Bertazi
