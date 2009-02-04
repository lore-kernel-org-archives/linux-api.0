From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Wed, 4 Feb 2009 15:54:27 +1100
Message-ID: <200902041554.29184.nickpiggin@yahoo.com.au>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754735AbZBDEzL@vger.kernel.org>
In-Reply-To: <20090203133942.2ecec281.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, andi@firstfloor.org, oleg@redhat.com, viro@zeniv.linux.org.uk, davidel@xmailserver.org, davem@davemloft.net, hch@lst.de, linux-api@vger.kernel.org, mpm@selenic.com, alan@lxorguk.ukuu.org.uk
List-Id: linux-api@vger.kernel.org

On Wednesday 04 February 2009 08:39:42 Andrew Morton wrote:
> On Mon,  2 Feb 2009 11:20:09 -0700
>
> Jonathan Corbet <corbet@lwn.net> wrote:
> > Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way
> > of saving space in struct file.  This patch makes that change.
>
> hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> it doesn't have all the correct/well-understood memory/compiler
> ordering semantics which spinlocks have.

Bit spinlocks are OK now they are using lock bitops. Of course, they are
even nicer (and become very comparable to spinlocks) if you can use the
non-atomic unlock __bit_spin_unlock().

But it seems probably like another approach being discussed is a better
idea anyway.

> And lockdep doesn't know about
> it.

This is a valid concern. Someone had a patch to add lockdep support to it,
which might be a good idea to do. But for small inner locks, maybe not a
huge problem.
