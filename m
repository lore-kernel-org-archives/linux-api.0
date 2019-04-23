From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in percpu_ref_kill_and_confirm
Date: Tue, 23 Apr 2019 17:41:40 +0300
Message-ID: <CACT4Y+b8dkFzQoJgaNLMiDjF4bM1AeSZaH5EWTvF_o5MQhu4Pg@mail.gmail.com>
References: <00000000000043fe9c058720a5d3@google.com> <ad884b18-0e03-d6be-02b0-4e5273f068ce@kernel.dk>
 <CAHk-=wgG=RqK8T5kWiZfH7da6rBuqp3kAesP=ETgceb6RzvZng@mail.gmail.com>
 <53a17444-9539-5810-82a0-ceeefa742508@kernel.dk> <cfa6be6d-4125-6d1e-8993-e9ec9dbaa7bb@kernel.dk>
 <CAHk-=wh=kKEb6qbuhnSWh5S55SbQBOE33991ULSFUgVrEnzivA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wh=kKEb6qbuhnSWh5S55SbQBOE33991ULSFUgVrEnzivA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, syzbot <syzbot+10d25e23199614b7721f@syzkaller.appspotmail.com>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Anvin <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Thomas Gleixner <tglx@linutronix.de>, Al
List-Id: linux-api@vger.kernel.org

On Mon, Apr 22, 2019 at 7:48 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Apr 22, 2019 at 9:38 AM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > With the mutex change in, I can trigger it in a second or so. Just ran
> > the reproducer with that change reverted, and I'm not seeing any badness.
> > So I do wonder if the bisect results are accurate?
>
> Looking at the syzbot report, it's syzbot being confused.
>
> The actual WARNING in percpu_ref_kill_and_confirm() only happens with
> recent kernels.
>
> But then syzbot mixes it up with a completely different bug:
>
>    crash: BUG: MAX_STACK_TRACE_ENTRIES too low!
>    BUG: MAX_STACK_TRACE_ENTRIES too low!
>
> and for some reason decides that *that* bug is the same thing entirely.
>
> So yeah, I think the simple percpu_ref_is_dying() check is sufficient,
> and that the syzbot bisection is completely bogus.

Using crashed/not-crashed predicate gives better results overall. More
than half kernel bugs have different manifestations due to different
reasons. And even if we can say for sure that we see a different bug,
we still don't know if the original bug is also there or not. See the
following threads for details:
https://groups.google.com/d/msg/syzkaller-bugs/nFeC8-UG1gg/y6gUEsvAAgAJ
https://groups.google.com/d/msg/syzkaller/sR8aAXaWEF4/tTWYRgvmAwAJ

Unrelated crashes is the most common cause of incorrect bisection
results (66%). To enable better bisection we would need to integrate
some meaningful precommit testing into kernel development process
(would be tremendously useful for other reasons too). E.g. this "BUG:
MAX_STACK_TRACE_ENTRIES too low!" is this:
https://syzkaller.appspot.com/bug?id=dbd70f0407487a061d2d46fdc6bccc94b95ce3c0
and the reproducer is simply opening /dev/infiniband/rdma_cm or
/dev/vhci or something equally simple with LOCKDEP enabled. None of
this was done in a testing environment for several weeks. And then it
took another month to propagate the fix through all distributed kernel
trees. For all that time simple programs crash and bisection can't be
done and we are spending time here...
