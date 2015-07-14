From: Ben Maurer <bmaurer@fb.com>
Subject: RE: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Tue, 14 Jul 2015 09:34:17 +0000
Message-ID: <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>,<587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-60921-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers wrote:=0A=
> If we invoke this per-thread registration directly in the glibc NPTL impl=
ementation,=0A=
> in start_thread, do you think it would fit your requirements ?=0A=
=0A=
I guess this would basically be transparent to the user -- we'd just need t=
o make sure that the registration happens very early, before any chance of =
calling malloc.=0A=
=0A=
That said, having the ability for the kernel to understand that TLS impleme=
ntation are laid out using the same offset on each thread seems like someth=
ing that could be valuable long term. Doing so makes it possible to build o=
ther TLS-based features without forcing each thread to be registered. =
