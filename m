From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Tue, 6 Mar 2018 15:42:41 -0800
Message-ID: <EED9C7CB-BC5D-4E2D-B0CC-0003F682C73B@fb.com>
References: <20180306013457.1955486-1-ast@kernel.org>
 <CA+55aFx5Q8D3cmuoXJFV9Ok_vc3fd3rNP-5onqFTPTtfZgi=HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx5Q8D3cmuoXJFV9Ok_vc3fd3rNP-5onqFTPTtfZgi=HQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>, David Miller <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 6 Mar 2018, at 11:12, Linus Torvalds wrote:

> On Mon, Mar 5, 2018 at 5:34 PM, Alexei Starovoitov <ast@kernel.org> 
> wrote:
>> As the first step in development of bpfilter project [1] the 
>> request_module()
>> code is extended to allow user mode helpers to be invoked. Idea is 
>> that
>> user mode helpers are built as part of the kernel build and installed 
>> as
>> traditional kernel modules with .ko file extension into distro 
>> specified
>> location, such that from a distribution point of view, they are no 
>> different
>> than regular kernel modules. Thus, allow request_module() logic to 
>> load such
>> user mode helper (umh) modules via:
> [,,]
>
> I like this, but I have one request: can we make sure that this action
> is visible in the system messages?
>
> When we load a regular module, at least it shows in lsmod afterwards,
> although I have a few times wanted to really see module load as an
> event in the logs too.
>
> When we load a module that just executes a user program, and there is
> no sign of it in the module list, I think we *really* need to make
> that event show to the admin some way.
>
> .. and yes, maybe we'll need to rate-limit the messages, and maybe it
> turns out that I'm entirely wrong and people will hate the messages
> after they get used to the concept of these pseudo-modules, but
> particularly for the early implementation when this is a new thing, I
> really want a message like
>
>      executed user process xyz-abc as a pseudo-module
>
> or something in dmesg.
>
> I do *not* want this to be a magical way to hide things.

Especially early on, this makes a lot of sense.  But I wanted to plug 
bps and the hopefully growing set of bpf introspection tools:

https://github.com/iovisor/bcc/blob/master/introspection/bps_example.txt

Long term these are probably a good place to tell the admin what's going 
on.

-chris
