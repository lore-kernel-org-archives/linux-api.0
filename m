From: Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
Date: Fri, 15 Feb 2013 20:03:12 +0000
Message-ID: <511E9480.5070202@redhat.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <511E8223.6010506@redhat.com> <20130215194356.GA12413@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130215194356.GA12413@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Forgot to reply to this bit:

On 02/15/2013 07:43 PM, Oleg Nesterov wrote:
>> We'd miss the poke
>> > variant, but that looks like something that could be always be added
>> > later.
> Yes. _POKE_ or _QUEUE_ or _DEQUEUE_, we can add more features if user-
> space wants them.

In general, IMO, I agree with Roland at https://lkml.org/lkml/2002/12/20/84
in that it's good to have setters for completeness, so that you can
change all the state via ptrace that you can read via ptrace.

But I'm not doing any of this work, hence my "could always be
added later" comment instead of actually requesting it.  But if
we had it, we could make e.g., gdb inspect the signal queues,
and then be able to tweak a realtime signal before it is
delivered.

-- 
Pedro Alves
