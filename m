From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Thu, 8 Mar 2018 21:08:17 -0800
Message-ID: <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
References: <20180306013457.1955486-1-ast@kernel.org>
 <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
 <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
 <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
 <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/8/18 7:54 PM, Andy Lutomirski wrote:
>
>
>
>> On Mar 8, 2018, at 7:06 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>
>> Honestly, that "read twice" thing may be what scuttles this.
>> Initially, I thought it was a non-issue, because anybody who controls
>> the module subdirectory enough to rewrite files would be in a position
>> to just execute the file itself directly instead.
>>
>
> On further consideration, I think there’s another showstopper. This patch is a potentially severe ABI break. Right now, loading a module *copies* it into memory and does not hold a reference to the underlying fs. With the patch applied, all kinds of use cases can break in gnarly ways. Initramfs is maybe okay, but initrd may be screwed. If you load an ET_EXEC module from initrd, then umount it, then clear the ramdisk, something will go horribly wrong. Exactly what goes wrong depends on whether userspace notices that umount() failed. Similarly, if you load one of these modules over a network and then lose your connection, you have a problem.

there is not abi breakage and file cannot disappear from running task.
One cannot umount fs while file is still being used.

>
> The “read twice” thing is also bad for another reason: containers. Suppose I have a setup where a container can load a signed module blob. With the read twice code, the container can race and run an entirely different blob outside the container.

Not only "read twice", but "read many".
If .text sections of elf that are not yet in memory can be modified
by malicious user, later they will be brought in with different code.
I think the easiest fix to tighten this "umh modules" to CAP_SYS_ADMIN.
