Return-Path: <SRS0=/J/S=6P=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8F0C35280
	for <linux-api@archiver.kernel.org>; Fri,  1 May 2020 19:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73DEE2166E
	for <linux-api@archiver.kernel.org>; Fri,  1 May 2020 19:46:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZyvFH+M0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgEATqi (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 1 May 2020 15:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgEATqh (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 1 May 2020 15:46:37 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B96C061A0E
        for <linux-api@vger.kernel.org>; Fri,  1 May 2020 12:46:37 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id j14so4671756lfg.9
        for <linux-api@vger.kernel.org>; Fri, 01 May 2020 12:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kt6IiWcmZXX6mLZe3Npm+KnNStyWK4tvZMSZknHrpEw=;
        b=ZyvFH+M0FEmSh28N06nH7yi6EuuiQnNaCVIMA3mgShcIVa7cWxG83XzZcK+9attidQ
         2c4sCZ0aEx5sZnBre78nNPKQWqJ2puuyL4g+CF4LQDiEavbU3LXBmnx6z3k7+mi1Gcwl
         2NR6PYa09f0mZVpskNA7T0kO1xYiOGZEVm9yBa+ei+GkVggdds92ykznzEzxhfvtpvVa
         rapUqKOvGs7LqMCkRzrgJbhq4h9K7YKmkapN9fsCpiJvkbS85NHlYwaG/L+MVko2VMcr
         7Fc6BK5LCtLbxWvBTe/ruxFuF9NGdx3vH4iOqCfUZ7bBoaY7kRmOclZpIAoC/YtpYx7g
         URmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kt6IiWcmZXX6mLZe3Npm+KnNStyWK4tvZMSZknHrpEw=;
        b=bngSjsg1mpGGPA6JGcFxsR3lokVmQqYPqAjGNnt61XC51ugD5FXC7LvzRF4fTM315x
         ycNWXQzDu97W5phiKgO3Bc57wllObge7KYrPiGuyhKkr++mMfqCuc4615Sx62GuqgfpT
         lqLMcHVuKJ+cnQSLdVIS8xT2zBrZh69+IBF9+dQklxl5JTqJ0RxG0fERgrpvCQkL10Lw
         ZTFz78BGHD5bI2UtBQEQ6DopbpwPx2JJ8P/s2wPUJZbxRjTROfS7aYZ3dqj7PqKMs+YS
         +xgGouphBaNwZFZVviNbWqxGhQkFFLf6nBOAYtpRew9C8KpjrUA7SZKjE54O3w9K6ma9
         11wQ==
X-Gm-Message-State: AGi0PuZISBfbb2F825v6l5nj35xrkllJf38EjC7hhKvwhO4nzsKxNU33
        8EUT/oerhXmtD6vmhrMblbZlKelEmJ1INmLDI/89LA==
X-Google-Smtp-Source: APiQypLCnx5iBY4mxdbtk29iHmVZ+VLcTq41ZYnT5fApK66c7DCSDwDCusSxYcaDfuerlo+1CJxlIg8cVCBKOZUZmGY=
X-Received: by 2002:ac2:4257:: with SMTP id m23mr3390896lfl.141.1588362395236;
 Fri, 01 May 2020 12:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <158812825316.168506.932540609191384366.stgit@magnolia>
In-Reply-To: <158812825316.168506.932540609191384366.stgit@magnolia>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 1 May 2020 21:46:07 +0200
Message-ID: <CAG48ez0Fa6NSmO2a5kuzp6GCAXAXQtBzEDO+YcBL4BW105tF+w@mail.gmail.com>
Subject: Re: [PATCH RFC 00/18] xfs: atomic file updates
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Apr 29, 2020 at 4:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> This series creates a new log incompat feature and log intent items to
> track high level progress of swapping ranges of two files and finish
> interrupted work if the system goes down.  It then adds a new
> FISWAPRANGE ioctl so that userspace can access the atomic extent
> swapping feature.  With this feature, user programs will be able to
> update files atomically by opening an O_TMPFILE, reflinking the source
> file to it, making whatever updates they want to make, and then
> atomically swap the changed bits back to the source file.  It even has
> an optional ability to detect a changed source file and reject the
> update.
>
> The intent behind this new userspace functionality is to enable atomic
> rewrites of arbitrary parts of individual files.  For years, application
> programmers wanting to ensure the atomicity of a file update had to
> write the changes to a new file in the same directory, fsync the new
> file, rename the new file on top of the old filename, and then fsync the
> directory.  People get it wrong all the time, and $fs hacks abound.
>
> With atomic file updates, this is no longer necessary.  Programmers
> create an O_TMPFILE, optionally FICLONE the file contents into the
> temporary file, make whatever changes they want to the tempfile, and
> FISWAPRANGE the contents from the tempfile into the regular file.

That also requires the *readers* to be atomic though, right? Since now
the updates are visible to readers instantly, instead of only on the
next open()? If you used this to update /etc/passwd while someone else
is in the middle of reading it with a sequence of read() calls, there
would be fireworks...

I guess maybe the new API could also be wired up to ext4's
EXT4_IOC_MOVE_EXT somehow, provided that the caller specifies
FILE_SWAP_RANGE_NONATOMIC?
