From: Jens Axboe <axboe@kernel.dk>
Subject: Re: WARNING in percpu_ref_kill_and_confirm
Date: Mon, 22 Apr 2019 10:28:32 -0600
Message-ID: <224b0113-979a-01c3-49a0-6170f075cdae@kernel.dk>
References: <00000000000043fe9c058720a5d3@google.com>
 <CAHk-=wgC5mNgPN5excXyTNtFpOyF4+9jk3tLiC+s-VezgGbVTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgC5mNgPN5excXyTNtFpOyF4+9jk3tLiC+s-VezgGbVTA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, syzbot <syzbot+10d25e23199614b7721f@syzkaller.appspotmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Anvin <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On 4/22/19 10:23 AM, Linus Torvalds wrote:
> On Mon, Apr 22, 2019 at 9:06 AM syzbot
> <syzbot+10d25e23199614b7721f@syzkaller.appspotmail.com> wrote:
>>
>>
>> The bug was bisected to:
>>
>> commit 38e7571c07be01f9f19b355a9306a4e3d5cb0f5b
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Fri Mar 8 22:48:40 2019 +0000
>>
>>      Merge tag 'io_uring-2019-03-06' of git://git.kernel.dk/linux-block
>>
>> percpu_ref_kill_and_confirm called more than once on io_ring_ctx_ref_free!
> 
> So I don't see how that happens in the original code (because
> __io_uring_register() is called with the uring_lock held), but let's
> see.
> 
> HOWEVER.
> 
> I do see how it happens now as of the latest kernel as of commit
> b19062a56726 ("io_uring: fix possible deadlock between
> io_uring_{enter,register}") where the code explicitly drops the mutex
> in order to wait for other uring users to finish.
> 
> So Jens, I think that commit was buggy. I suspect that
> io_uring_register() should perhaps do something like
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2934,7 +2934,10 @@ static int __io_uring_register(struct
> io_ring_ctx *ctx, unsigned opcode,
>  {
>         int ret;
> 
> +       if (!percpu_ref_tryget(&ctx->refs))
> +               return -EBUSY;
>         percpu_ref_kill(&ctx->refs);
> +       percpu_ref_put(&ctx->refs);
> 
>         /*
>          * Drop uring mutex before waiting for references to exit. If another
> 
> to guarantee that it's the *only* case of io_uring_register() doing that kill.
> 
> Hmm?

Just sent out something as well. I think we can get by with just
checking if it's dying, or we can go the route of what you did which is
actually very similar to what the earlier versions did. Both versions
should fix the issue.

I'll test just to be totally sure.

-- 
Jens Axboe
