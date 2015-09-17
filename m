From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/13] Move bp_type_idx to kernel/event/hw_breakpoint.c
Date: Thu, 17 Sep 2015 11:28:20 +0100
Message-ID: <16775.1442485700@warthog.procyon.org.uk>
References: <2023922.x7a6gQp0x7@wuerfel> <1441832902-28993-1-git-send-email-palmer@dabbelt.com> <1442271047-4908-10-git-send-email-palmer@dabbelt.com> <20150915080607.GW16853@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2023922.x7a6gQp0x7@wuerfel>
Content-ID: <16774.1442485700.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: dhowells@redhat.com, Peter Zijlstra <peterz@infradead.org>, mathieu.desnoyers@efficios.com, Palmer Dabbelt <palmer@dabbelt.com>, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Frederi
List-Id: linux-api@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> That seems unlikely to work, so I suspect it gets a different definition.
> If it uses this definition and it does work, we can probably use
> 
> #if defined(__KERNEL__) && defined(CONFIG_HAVE_MIXED_BREAKPOINTS_REGS)
> 
> but that requires a comment explaining exactly why that works.

Are you suggesting wrapping the entire construct in this within the UAPI
header?

David
