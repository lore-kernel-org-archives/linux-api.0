From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 4.16 00/11] membarrier updates for 4.16
Date: Mon, 5 Feb 2018 18:53:00 +0000 (UTC)
Message-ID: <1659703322.16254.1517856780591.JavaMail.zimbra@efficios.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com> <CA+55aFxdqXJidPLFb--pa8cmJnepzGpLRD=gNXgktkjNW+jJug@mail.gmail.com> <20180205163353.llyamby4o7ajsvt7@gmail.com> <CA+55aFw9r1bLhPZ8bOApD7dBPTtFLBk+A71qLNF+XrEOL8+1oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw9r1bLhPZ8bOApD7dBPTtFLBk+A71qLNF+XrEOL8+1oA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, maged michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Feb 5, 2018, at 12:23 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Feb 5, 2018 at 8:33 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> Yeah, I wanted to apply these bits later today with some minor edits - unless
>> you
>> are going to pull it directly.
> 
> I have not pulled yet, I wanted to check. But I do want to get it merged.
> 
> It gets easier for me if I can just pull.
> 
> Mathieu, do you have a git tree? I don't think I've pulled from you,
> so in that sense it's more convenient for me if it goes through Ingo.
> 
> But if you have a git tree already set up, just holler.

I indeed have a git tree setup. The URL is in the pull request I sent you this
morning.

But I favor letting it go through Ingo's scheduler tree and benefit from the extra
bit of automated testing this could add.

Thanks to you both,

Mathieu

> 
>              Linus

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
