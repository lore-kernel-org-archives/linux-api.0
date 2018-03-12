From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Mon, 12 Mar 2018 10:49:02 -0700
Message-ID: <46e60759-e095-cb3c-4505-e5632916cd55@fb.com>
References: <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
 <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
 <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <20180309.133509.1275903267249306409.davem@davemloft.net>
 <CAGXu5jJcuSojm_KN5+JQ3fV6J09V6dmNB6haqu11xkXTq=nxog@mail.gmail.com>
 <CA+55aFzJEkUGfRkKqc8twaDSdSH_r_OWnFm-e4uNQf4SrJy7-A@mail.gmail.com>
 <77cdc9f5-b51c-a18d-5422-763cc4e76279@fb.com>
 <30db1e8e-8eb4-5072-8360-6cafe26db113@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30db1e8e-8eb4-5072-8360-6cafe26db113@solarflare.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Edward Cree <ecree@solarflare.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/12/18 5:02 AM, Edward Cree wrote:
> On 09/03/18 18:58, Alexei Starovoitov wrote:
>> It's not waiting for the whole thing, because once bpfilter starts it
>> stays running/sleeping because it's stateful.
> So, this has been bugging me a bit.
> If bpfilter takes a signal and crashes, all that state goes away.
> Does that mean your iptables/netfilter config just got forgotten and next
>  time you run iptables it disappears, so you have to re-apply it all again?
>> It needs normal
>> malloc-ed memory to keep the state of iptable->bpf translation that
>> it will use later during subsequent translation calls.
>> Theoretically it can use bpf maps pinned in kernel memory to keep
>> this state, but then it's non-swappable. It's better to keep bpfilter
>> state in its own user memory.
> Perhaps the state should live in swappable kernel memory (e.g. a tmpfs
>  thing, which bpfilter could access through a mount).  It'd be read-only
>  to userspace, listing the existing rules (in untranslated form), and be
>  updated to reflect the new rule after bpfilter has supplied the updated
>  translation.
> Then bpfilter can cache things if it wants, but the kernel remains the
>  ultimate arbiter of the state and maintains it over a bpfilter crash.

seems like overkill.
I consider crashing bpfilter same severity as kernel bug.
Whatever firewall rules already installed will continue to work,
but new ones won't be able to load and current set cannot be queried.
Control plane crashed, dataplane continues to work.
Still a ton better than whole system crash.
We have plenty of work ahead of us without worrying about restarting
that umh and reloading its state from tmpfs.
Something to consider for later phases of the project.
