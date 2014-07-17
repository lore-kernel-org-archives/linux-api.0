From: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 14:44:50 -0700
Message-ID: <20140717214450.GE24196@lenny.home.zabbo.net>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
 <20140717170115.GO1491@thunk.org>
 <CAComcpObt4y--GEuAZgzkaDWnrJYBKhwsvqjOkdiXU_yGnV2Tg@mail.gmail.com>
 <20140717204340.GS1491@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140717204340.GS1491-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Bob Beck <beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 17, 2014 at 04:43:40PM -0400, Theodore Ts'o wrote:

> So in practice, the fact that we block at system init time shouldn't
> be a hardship for LibreSSL in most cases --- and in the case where you
> are running on an embedded system where there are barely any devices,
> no cycle counter, and nothing that produces enough interrupts to
> initialize the pool, what would you prefer that we do?  Return data
> that might not be fully "seed grade entropy"?
> 
> If you are determined to get data from a not a fully initialized
> entropy pool, then you can open /dev/urandom and get it via the old
> interface.

That sounds reasonable.  Maybe a slightly edited version of this writeup
could be dropped in the man page to give people context?

> (The fact that most systems try to create OpenSSH's host keys as the
> first thing after an out-of-the-Box first boot situation is something
> I've always considered Crazy-Eddie Bat-Shit Insane....)

(Seriously.  My atrophied sysadmin muscles still still cringe at that.)

- z
