From: Christof Meerwald <cmeerw@cmeerw.org>
Subject: Re: [RFC/PATCH] epoll: replace EPOLL_CTL_DISABLE with EPOLL_CTL_POKE
Date: Sat, 3 Nov 2012 02:10:31 +0100
Message-ID: <20121103011031.GA22452@edge.cmeerw.net>
References: <1351210112-23238-1-git-send-email-palewis@adobe.com>
 <20121102041312.GA15886@dcvr.yhbt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-34322-glibc-alpha=m.gmane.org@sourceware.org>
Content-Disposition: inline
In-Reply-To: <20121102041312.GA15886@dcvr.yhbt.net>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Eric Wong <normalperson@yhbt.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Holland <pholland@adobe.com>, Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk <mtk.manpages@gmail.com>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, paulmck@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

On Fri, 2 Nov 2012 04:13:12 +0000, Eric Wong wrote:
[...]
> EPOLL_CTL_POKE may be used to force an item into the epoll
> ready list.  Instead of disabling an item asynchronously
> via EPOLL_CTL_DISABLE, this forces the threads calling
> epoll_wait() to handle the item in its normal loop.

That was my initial suggestion as well - see
https://lkml.org/lkml/2012/6/19/358


Christof

-- 

http://cmeerw.org                              sip:cmeerw at cmeerw.org
mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org
