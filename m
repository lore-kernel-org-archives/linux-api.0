From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [RFC PATCH for 4.21 04/16] mm: Introduce vm_map_user_ram,
 vm_unmap_user_ram
Date: Thu, 18 Oct 2018 00:34:08 +0900
Message-ID: <20181017153408.GB426@tigerII.localdomain>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
 <20181010191936.7495-5-mathieu.desnoyers@efficios.com>
 <20181016143016.10da89bd@gandalf.local.home>
 <20181017002722.GA1068@jagdpanzerIV>
 <1051015468.759.1539788401096.JavaMail.zimbra@efficios.com>
 <2060193272.771.1539788641739.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2060193272.771.1539788641739.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On (10/17/18 11:04), Mathieu Desnoyers wrote:
> >> 
> >>> 	if (WARN_ON(x))
> >>> 		return;
> >> 
> >> Given that this somewhat MM-related, I'd may be say VM_WARN_ON().
> 
> I notice that VM_WARN_ON() casts the result of WARN_ON() to (void), so it
> cannot be used in a if () statement.
> 
> VM_WARN_ON() will only warn if CONFIG_DEBUG_VM is set.
> 
> Is it really what we want ?

Oh, indeed... Sorry, I forgot that they cast WANR_ON() return to void.
Let's do what Steven suggested.

	-ss
