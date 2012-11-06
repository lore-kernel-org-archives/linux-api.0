From: Eric Wong <normalperson@yhbt.net>
Subject: Re: [RFC/PATCH] epoll: replace EPOLL_CTL_DISABLE with
 EPOLL_CTL_POKE
Date: Tue, 6 Nov 2012 21:58:54 +0000
Message-ID: <20121106215854.GA6626@dcvr.yhbt.net>
References: <1351210112-23238-1-git-send-email-palewis@adobe.com>
 <20121102041312.GA15886@dcvr.yhbt.net>
 <20121103011031.GA22452@edge.cmeerw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121103011031.GA22452@edge.cmeerw.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Christof Meerwald <cmeerw@cmeerw.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Holland <pholland@adobe.com>, Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk <mtk.manpages@gmail.com>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, paulmck@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

Christof Meerwald <cmeerw@cmeerw.org> wrote:
> On Fri, 2 Nov 2012 04:13:12 +0000, Eric Wong wrote:
> [...]
> > EPOLL_CTL_POKE may be used to force an item into the epoll
> > ready list.  Instead of disabling an item asynchronously
> > via EPOLL_CTL_DISABLE, this forces the threads calling
> > epoll_wait() to handle the item in its normal loop.
> 
> That was my initial suggestion as well - see
> https://lkml.org/lkml/2012/6/19/358

Thanks, missed that the first time around.  Perhaps TRIGGER is a
better name than POKE :x

I'm hoping Paton has a chance to look at my implementation and
comment on it.
