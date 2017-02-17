From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [RFC 1/2] fs,eventpoll: Add ability to install target file by
 its number
Date: Fri, 17 Feb 2017 22:45:02 +0300
Message-ID: <20170217194502.GC23766@uranus>
References: <20170217083324.627615532@openvz.org>
 <CALCETrUOaNaS6yAhLM9jLb8PD2eg2ZwXfu4v327aAOy82SbLwg@mail.gmail.com>
 <20170217171136.GA23766@uranus>
 <CALCETrUmUOXL=72SA-pqNhQda0ic946UNnWUe_vwSHVruiyFfg@mail.gmail.com>
 <20170217180118.GB23766@uranus>
 <c8bc1234-25b4-92dd-d305-839d85489e49@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c8bc1234-25b4-92dd-d305-839d85489e49@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linuxfoundation.org>, Andrew Vagin <avagin@virtuozzo.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kirill Kolyshkin <kir@openvz.org>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 01:34:04PM -0500, Jason Baron wrote:
> > 
> > kcmp over target set seems to be preferred since it gonna be a way
> > faster. But I think about fd-ref idea too. Thanks a huge!
> > 
> 
> I sort of like kcmp() for this as well maybe the epoll fd argument can be a
> pointer to something like:
> 
> struct epoll_slot {
> 	int epfd;
> 	int slot;
> };
> 
> Where 'epfd' is the epoll fd, and slot is just an index into the target fds
> associated with the epoll fd. That is, you would start from 0 and go up to
> n. When you reach the last one you get in -EBADSLT or something.

Yes, I think we can even extend the slot and pass it as a pointer to
target fd set which are to be tested.

> Regarding Andy's point of of not having a reference by some other means, I
> think you have to have it basically otherwise it would be removed from the
> epfd. I guess it could be being passed via a unix socket? But there must be
> a way to get at those anyways, in order to restore them.

Yes. But the file may be obtained from unix sock, then dup'ed and installed
and then this dup'ed file get closed but unix instance is still alive. And
then we need to figure out that it's unix socket from where original target
file came from.

> Also, in the initial patch this function can not restore all target epoll
> files:
> 
> 'ep_find_tfd(struct eventpoll *ep, int tfd)'
> 
> Because the 'target' file for an epfd is the pair: {fd, file}. Thus, you
> could have say two different 'target' files with the same fd number.

Yes, but if we would have _DUP'ed them (ie installed into caller context)
we can find out their order and restore properly I think.

Thanks for comments, I'll think about all them at the weekend or early
next week.

	Cyrill
