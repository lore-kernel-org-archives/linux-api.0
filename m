From: wli@movementarian.org
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Tue, 3 Feb 2009 20:00:36 -0500
Message-ID: <20090204010036.GA10229@movementarian.org>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754237AbZBDBA7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090203133942.2ecec281.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, andi@firstfloor.org, oleg@redhat.com, viro@ZenIV.linux.org.uk, davidel@xmailserver.org, davem@davemloft.net, hch@lst.de, linux-api@vger.kernel.org, mpm@selenic.com, alan@lxorguk.ukuu.org.uk
List-Id: linux-api@vger.kernel.org

On Mon,  2 Feb 2009 11:20:09 -0700 Jonathan Corbet <corbet@lwn.net> wrote:
>> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
>> saving space in struct file.  This patch makes that change.

On Tue, Feb 03, 2009 at 01:39:42PM -0800, Andrew Morton wrote:
> hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> it doesn't have all the correct/well-understood memory/compiler
> ordering semantics which spinlocks have.  And lockdep doesn't know about
> it.

ISTR the memory/compiler ordering semantics bits coming up when it was
still pte_chain_lock(), but not the entirety of it. I think
smp_mb__after_clear_bit() and/or smp_mb__before_clear_bit() turned out
to be needed in the unlock function, and they're there now with
clear_bit_unlock() et al. lockdep I'm less sure about, but suspect
the objects with bit locks embedded in them are too numerous to feasibly
track, e.g. there may be several bh's per-page, and how numerous they
are tends to be why they're using bit locks in the first place.


-- wli
