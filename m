From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for 4.16 00/11] membarrier updates for 4.16
Date: Mon, 29 Jan 2018 09:40:19 -0800
Message-ID: <CA+55aFxdqXJidPLFb--pa8cmJnepzGpLRD=gNXgktkjNW+jJug@mail.gmail.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will
List-Id: linux-api@vger.kernel.org

Ingo/Peter/Thomas,
 can you comment on this? I'd like to get this moving one way or
another, rather than just hold it back forever.

I _think_ all the concerns were resolved, no?

              Linus

On Tue, Jan 23, 2018 at 7:57 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> Hi Ingo, Peter, Thomas,
>
> Here is the updated membarrier patch series following review from
> Andy.
>
> It would be appreciated of those can go through the scheduler tree for
> the 4.16 merge window.
