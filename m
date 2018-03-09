From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 9 Mar 2018 10:58:06 -0800
Message-ID: <77cdc9f5-b51c-a18d-5422-763cc4e76279@fb.com>
References: <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
 <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
 <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <20180309.133509.1275903267249306409.davem@davemloft.net>
 <CAGXu5jJcuSojm_KN5+JQ3fV6J09V6dmNB6haqu11xkXTq=nxog@mail.gmail.com>
 <CA+55aFzJEkUGfRkKqc8twaDSdSH_r_OWnFm-e4uNQf4SrJy7-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzJEkUGfRkKqc8twaDSdSH_r_OWnFm-e4uNQf4SrJy7-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/9/18 10:50 AM, Linus Torvalds wrote:
> On Fri, Mar 9, 2018 at 10:43 AM, Kees Cook <keescook@chromium.org> wrote:
>>
>> Module loading (via kernel_read_file()) already uses
>> deny_write_access(), and so does do_open_execat(). As long as module
>> loading doesn't call allow_write_access() before the execve() has
>> started in the new implementation, I think we'd be covered here.
>
> No. kernel_read_file() only does it *during* the read.
>
> So there's a huge big honking gap between the two.
>
> Also, the second part of my suggestion was to be entirely synchronous
> with the whole execution of the process, and do it within the "we do
> mutual exclusion fo rmodules with the same name" logic.
>
> Note that Andrei's patch uses UMH_WAIT_EXEC. That's basically
> "vfork+exec" - it only waits for the exec to have started, it doesn't
> wait for the whole thing.

It's not waiting for the whole thing, because once bpfilter starts it
stays running/sleeping because it's stateful. It needs normal
malloc-ed memory to keep the state of iptable->bpf translation that
it will use later during subsequent translation calls.
Theoretically it can use bpf maps pinned in kernel memory to keep
this state, but then it's non-swappable. It's better to keep bpfilter
state in its own user memory.
