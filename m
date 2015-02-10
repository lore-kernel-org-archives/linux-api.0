From: Eric Wong <normalperson@yhbt.net>
Subject: Re: [PATCH 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Tue, 10 Feb 2015 19:32:47 +0000
Message-ID: <20150210193247.GA12953@dcvr.yhbt.net>
References: <cover.1423509605.git.jbaron@akamai.com>
 <68a0ad4a99551ea3bfff89da461bb490d63b0ca8.1423509605.git.jbaron@akamai.com>
 <54D915FC.7010003@amacapital.net>
 <54D92780.4000303@akamai.com>
 <CALCETrUQZHHE_PJYoMw8g9C5AAxSdF-jU85EF317O4Krk+bV9w@mail.gmail.com>
 <54D98209.2080901@akamai.com>
 <20150210044939.GA15616@dcvr.yhbt.net>
 <54DA592A.3050102@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54DA592A.3050102@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jason Baron <jbaron@akamai.com> wrote:
> On 02/09/2015 11:49 PM, Eric Wong wrote:
> > Do you have a userland use case to share?
> 
> I've been trying to describe the use case, maybe I haven't been doing a good
> job :(

Sorry, I meant if you had any public code.

Anyways, I've restarted work on another project which I'll hopefully be
able to share in a few weeks which might be a good public candidate for
epoll performance testing.

> > Did you try my suggestion of using a dedicated thread (or thread pool)
> > which does nothing but loop on accept() + EPOLL_CTL_ADD?
> >
> > Those dedicated threads could do its own round-robin in userland to pick
> > a different epollfd to call EPOLL_CTL_ADD on.
> 
> Thanks for your suggestion! I'm not actively working on the user-space
> code here, but I will pass it along.
> 
> I would prefer though not to have to context switch the 'accept' thread
> on and off the cpu every time there is a new connection. So the approach
> suggested here essentially moves this dedicated thread (threads), down
> into the kernel and avoids the creation of these threads entirely.

For cmogstored, I stopped using TCP_DEFER_ACCEPT when using the
dedicated thread.  This approach offloads to epoll and ends up giving
similar behavior to what used to be infinite in TCP_DEFER_ACCEPT in
Linux <= 2.6.31
