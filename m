From: Mike Marshall <hubcap@omnibond.com>
Subject: Re: O_DIRECT as a hint, was: Re: [PATCH] ext4: refuse O_DIRECT opens
 for mode where DIO doesn't work
Date: Tue, 26 Apr 2016 11:07:40 -0400
Message-ID: <CAOg9mSSVy_AHiZkLwPx4nKrwXFgSZJNSW1YQiystkZ28cjHmqA@mail.gmail.com>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
	<877ffmhvzt.fsf@openvz.org>
	<20160425234946.GB26977@dastard>
	<20160426081451.GA25616@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160426081451.GA25616@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dmitry Monakhov <dmonlist@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

We have Orangefs users who have applications they
can't run because the applications open with
O_DIRECT. They are happy when I show them
how to "pretend" to support O_DIRECT - the
way they did it in NFS back in the 2.6 era...

I was thinking of adding it to the upstream version,
maybe as a mount option... so I like this "hint" idea...

-Mike

On Tue, Apr 26, 2016 at 4:14 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Apr 26, 2016 at 09:49:46AM +1000, Dave Chinner wrote:
>> Why not just transparently fall back to buffered IO if direct IO
>> cannot be done? Saves people from wondering why applications fail
>> on one ext4 filesystem and not another....
>
> I've been doing an audit of our direct I/O implementations, and most
> of them does some form of transparent fallback, including some that
> only pretend to support O_DIRECT, but do anything special for it at all,
> while at the same time we go through greast efforts to check a file
> system actualy supports direct I/O, leading to nasty no-op ->direct_IO
> implementations as we even got that abstraction wrong.
>
> At this point I wonder if we should simply treat O_DIRECT as a hint
> and always allow it, and just let the file system optimize for it
> (skip buffering, require alignment, relaxed Posix atomicy requirements)
> if it is set.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
