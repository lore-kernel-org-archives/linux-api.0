From: Jens Axboe <axboe@kernel.dk>
Subject: Re: WARNING in percpu_ref_kill_and_confirm
Date: Mon, 22 Apr 2019 10:32:31 -0600
Message-ID: <53a17444-9539-5810-82a0-ceeefa742508@kernel.dk>
References: <00000000000043fe9c058720a5d3@google.com>
 <ad884b18-0e03-d6be-02b0-4e5273f068ce@kernel.dk>
 <CAHk-=wgG=RqK8T5kWiZfH7da6rBuqp3kAesP=ETgceb6RzvZng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgG=RqK8T5kWiZfH7da6rBuqp3kAesP=ETgceb6RzvZng@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: syzbot <syzbot+10d25e23199614b7721f@syzkaller.appspotmail.com>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Anvin <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 4/22/19 10:27 AM, Linus Torvalds wrote:
> [ Crossed emails ]
> 
> On Mon, Apr 22, 2019 at 9:23 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I think the below should fix this. Very early versions of io_uring didn't
>> have this issue, since we did the percpu ref tryget for io_uring_register().
> 
> Ok, so I like your patch better than mine, but note how syzbot
> bisected this to the initial merge of the io_uring code.

Yes, I did think about that too...

> I agree that code shouldn't have had this particular issue, but it
> looks like it does.
> 
> Is there some way to race with io_ring_ctx_wait_and_kill(), which
> _also_ does that ref_kill() thing? I'm not seeing how that could
> happen, but maybe if the file ref counts get screwed up you have
> ->release() called early..

I just tried on the current code and it triggers easily, but that's
with that mutex patch in there. I agree it should not trigger before
that, unless something is wonky. I'll try and play around with it a bit
and see what is going on (or if I can trigger it at all with the mutex
change reverted).

-- 
Jens Axboe
