From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Date: Tue, 19 Jan 2010 09:12:44 +0900 (JST)
Message-ID: <20100119091004.5F28.A69D9226@jp.fujitsu.com>
References: <1263827194.4283.609.camel@laptop> <20100118151405.GD14345@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20100118151405.GD14345@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Gleb Natapov <gleb@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, andrew.c.morrow@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

> On Mon, Jan 18, 2010 at 04:06:34PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-01-18 at 17:01 +0200, Gleb Natapov wrote:
> > > There are valid uses for mlockall()
> > 
> > That's debatable.
> > 
> Well, I have use for it. You can look at previous thread were I described
> it and suggest alternatives.

Please stop suck.
This is the reviewing. The reviewers shouldn't need to look at all
previous thread. It mean your description isn't enough.



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
