From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 18:27:41 -0400
Message-ID: <20140717222741.GX1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
 <20140717170115.GO1491@thunk.org>
 <CAComcpObt4y--GEuAZgzkaDWnrJYBKhwsvqjOkdiXU_yGnV2Tg@mail.gmail.com>
 <20140717204340.GS1491@thunk.org>
 <20140717214450.GE24196@lenny.home.zabbo.net>
 <CALCETrVC2SVC2BwintZ7P5MvwDO4z0VBe0svpWhVhx7Xgfoeag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVC2SVC2BwintZ7P5MvwDO4z0VBe0svpWhVhx7Xgfoeag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Bob Beck <beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 17, 2014 at 03:00:45PM -0700, Andy Lutomirski wrote:
> 
> And we'll be in a sad state in which we have a getrandom(2) syscall
> but there's no decent way to use srand without either opening
> /dev/urandom or mucking with AT_RANDOM.  And the latter barely works
> because I think that most (all?) glibc versions clear it after using
> it to initialize their stack canaries.

Sorry, I really don't think that supporting srand() is a good use of
getrandom(2).  If it's for non-crypto purposes, using getpid() and
time() is *just* *fine*.

If we add such a flag, my big fear is that it gets misused.  Sometimes
it does make sense to create interfaces that a strong point of view.
The primary use of getrandom(2) should be for cryptographic purposes,
and trying to avoid misuse should be the primary objective.

						- Ted
