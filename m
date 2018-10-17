From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [RFC PATCH for 4.21 06/16] cpu_opv: Provide cpu_opv system call
 (v8)
Date: Wed, 17 Oct 2018 10:46:51 +0900
Message-ID: <20181017014651.GB1068@jagdpanzerIV>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
 <20181010191936.7495-7-mathieu.desnoyers@efficios.com>
 <20181016081029.GA30363@jagdpanzerIV>
 <1984292897.263.1539717457933.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1984292897.263.1539717457933.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

On (10/16/18 15:17), Mathieu Desnoyers wrote:
>
> Therefore, only an internal kernel bug between vm_map_user_ram() and
> vm_unmap_user_ram() should trigger the BUG_ON(). No user input is passed
> to vm_unmap_user_ram().
>
> Now, let's look at vm_map_user_ram(). It calls alloc_vmap_area(), which returns
> a vmap_area. Then if vmap_page_range failed, vm_unmap_user_ram is called on the
> memory that has just been returned by vm_map_user_ram. Again, only an internal
> bug between map/unmap can trigger the BUG_ON() in vm_unmap_user_ram.

Thanks for spending time on this.
Just wanted someone to have extra look at syscall->BUG_ON().

	-ss
