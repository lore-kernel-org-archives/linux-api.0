From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v18 for v4.1-rc2 1/3] sys_membarrier(): system-wide memory
 barrier (generic, x86)
Date: Wed, 6 May 2015 13:39:07 -0700
Message-ID: <CA+55aFwQbE0pvb2XRRT33rDEwwwQHKN27w5A8f4GWWJ_j6w1EA@mail.gmail.com>
References: <1430940068-4326-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1430940068-4326-2-git-send-email-mathieu.desnoyers@efficios.com>
	<20150506202120.GA23011@cloud>
	<371299002.44925.1430944039395.JavaMail.zimbra@efficios.com>
	<2014027751.44926.1430944422045.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2014027751.44926.1430944422045.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>, Nicholas Miell <nmiell@comcast.net>, Ingo Molnar <mingo@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Lai Jiangshan <laijs@cn.fujitsu.com>, Stephen Hemminger <stephen@networkplumber.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>, Pranith Kumar <bobby.prani@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 6, 2015 at 1:33 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Will try moving those parts under a "---" in the commit
> message, and hope it does what I intend.

Yeah, that should do it for anybody who then uses "git am" to apply
the patches you send out. It's kind of hacky, and I've always worried
a bit that somebody uses "^---$' for real in a commit message and
things get lost, but it is *such* a useful way to add notes to emails
that aren't fit for actually committing, that the risk has never
outweighed the benefits.

                  Linus
