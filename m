From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC v5 0/8] Additional kmsg devices
Date: Wed, 24 Feb 2016 14:59:44 -0800
Message-ID: <20160224145944.d19fd3b66e183702b5ee13b1@linux-foundation.org>
References: <1445941723-20388-1-git-send-email-p.osmialowsk@samsung.com>
	<1450223166.4142.34.camel@perches.com>
	<56711717.60704@nod.at>
	<20151216152757.GH4026@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151216152757.GH4026@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Richard Weinberger <richard@nod.at>, Joe Perches <joe@perches.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Richard Weinberger <richard.weinberger@gmail.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Wed, 16 Dec 2015 10:27:57 -0500 Tejun Heo <tj@kernel.org> wrote:

> On Wed, Dec 16, 2015 at 08:47:35AM +0100, Richard Weinberger wrote:
> > > Andrew?  Are you or anyone else interested in picking up this patchset?
> > 
> > I know I'm repeating myself. But this should be done in userspace.
> 
> Nothing in this posting explains why this is being added.  Kinda
> difficult to say yay or nay.

Yes, I've been rather scratching my head over all of that: what does it
all really do, why does it do it, what problem does it solve, what's
the end-user benefit, etc.

There doesn't appear to be a Documentation update in the patchset. 
Perhaps rectifying that omission with a rather good documentation file
would help people to appreciate it all...
