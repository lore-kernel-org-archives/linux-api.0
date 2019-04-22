From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: WARNING in percpu_ref_kill_and_confirm
Date: Mon, 22 Apr 2019 09:48:08 -0700
Message-ID: <CAHk-=wh=kKEb6qbuhnSWh5S55SbQBOE33991ULSFUgVrEnzivA@mail.gmail.com>
References: <00000000000043fe9c058720a5d3@google.com> <ad884b18-0e03-d6be-02b0-4e5273f068ce@kernel.dk>
 <CAHk-=wgG=RqK8T5kWiZfH7da6rBuqp3kAesP=ETgceb6RzvZng@mail.gmail.com>
 <53a17444-9539-5810-82a0-ceeefa742508@kernel.dk> <cfa6be6d-4125-6d1e-8993-e9ec9dbaa7bb@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cfa6be6d-4125-6d1e-8993-e9ec9dbaa7bb@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+10d25e23199614b7721f@syzkaller.appspotmail.com>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Anvin <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 22, 2019 at 9:38 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> With the mutex change in, I can trigger it in a second or so. Just ran
> the reproducer with that change reverted, and I'm not seeing any badness.
> So I do wonder if the bisect results are accurate?

Looking at the syzbot report, it's syzbot being confused.

The actual WARNING in percpu_ref_kill_and_confirm() only happens with
recent kernels.

But then syzbot mixes it up with a completely different bug:

   crash: BUG: MAX_STACK_TRACE_ENTRIES too low!
   BUG: MAX_STACK_TRACE_ENTRIES too low!

and for some reason decides that *that* bug is the same thing entirely.

So yeah, I think the simple percpu_ref_is_dying() check is sufficient,
and that the syzbot bisection is completely bogus.

                Linus
