From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: futex(2) man page update help request
Date: Mon, 16 Feb 2015 14:14:28 +0100
Message-ID: <20150216131428.GA20568@rei.suse.de>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <20140515152834.GA6926@rei.Home>
 <CF9A3521.90ECC%dvhart@linux.intel.com>
 <20140515163004.GB7959@rei.Home>
 <CF9A3A75.90F40%dvhart@linux.intel.com>
 <20140515190529.GA8887@rei.Home>
 <CF9A658E.91322%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CF9A658E.91322%dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi!
> I'll follow up with you in a couple weeks most likely. I have some urgent
> things that will be taking all my time and then some until then. Feel free
> to poke me though if I lose track of it :-)

FYI I've started to work on futex testcases for LTP. The first batch has
been commited in:

https://github.com/linux-test-project/ltp/commit/6270ba2ebe999ffdb1364e5e814d7e56070a0198

Some of these are losely based on futextest some are written from
scratch. The requeue operation, pi futexes and bitset are not covered
yet.

-- 
Cyril Hrubis
chrubis@suse.cz
