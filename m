From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 15:00:45 -0700
Message-ID: <CALCETrVC2SVC2BwintZ7P5MvwDO4z0VBe0svpWhVhx7Xgfoeag@mail.gmail.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org> <20140717170115.GO1491@thunk.org>
 <CAComcpObt4y--GEuAZgzkaDWnrJYBKhwsvqjOkdiXU_yGnV2Tg@mail.gmail.com>
 <20140717204340.GS1491@thunk.org> <20140717214450.GE24196@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140717214450.GE24196-fypN+1c5dIyjpB87vu3CluTW4wlIGRCZ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Bob Beck <beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 17, 2014 at 2:44 PM, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org> wrote:
> On Thu, Jul 17, 2014 at 04:43:40PM -0400, Theodore Ts'o wrote:
>
>> So in practice, the fact that we block at system init time shouldn't
>> be a hardship for LibreSSL in most cases --- and in the case where you
>> are running on an embedded system where there are barely any devices,
>> no cycle counter, and nothing that produces enough interrupts to
>> initialize the pool, what would you prefer that we do?  Return data
>> that might not be fully "seed grade entropy"?
>>
>> If you are determined to get data from a not a fully initialized
>> entropy pool, then you can open /dev/urandom and get it via the old
>> interface.
>
> That sounds reasonable.  Maybe a slightly edited version of this writeup
> could be dropped in the man page to give people context?

And we'll be in a sad state in which we have a getrandom(2) syscall
but there's no decent way to use srand without either opening
/dev/urandom or mucking with AT_RANDOM.  And the latter barely works
because I think that most (all?) glibc versions clear it after using
it to initialize their stack canaries.

This isn't a regression, and it isn't a reason to object to
getrandom(2), but if getrandom(2) goes in as is, I'll submit a patch
adding the new flag immediately.

--Andy
