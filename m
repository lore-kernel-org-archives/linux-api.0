From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 9 Mar 2018 07:39:30 -0800
Message-ID: <6d2e31fa-d87b-fea6-c919-b7d066bb0385@fb.com>
References: <20180306013457.1955486-1-ast@kernel.org>
 <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
 <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
 <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
 <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
 <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
 <CALCETrWKLB4e8Cw6ZRiDP535=HzoQJczsEMEpytstveO15mAMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWKLB4e8Cw6ZRiDP535=HzoQJczsEMEpytstveO15mAMg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/9/18 7:16 AM, Andy Lutomirski wrote:
>>> On Mar 8, 2018, at 9:08 PM, Alexei Starovoitov <ast@fb.com> wrote:
>>>
>>> On 3/8/18 7:54 PM, Andy Lutomirski wrote:
>>>
>>>
>>>
>>>> On Mar 8, 2018, at 7:06 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>>
>>>>
>>>> Honestly, that "read twice" thing may be what scuttles this.
>>>> Initially, I thought it was a non-issue, because anybody who controls
>>>> the module subdirectory enough to rewrite files would be in a position
>>>> to just execute the file itself directly instead.
>>>
>>> On further consideration, I think there’s another showstopper. This patch is a potentially severe ABI break. Right now, loading a module *copies* it into memory and does not hold a reference to the underlying fs. With the patch applied, all kinds of use cases can break in gnarly ways. Initramfs is maybe okay, but initrd may be screwed. If you load an ET_EXEC module from initrd, then umount it, then clear the ramdisk, something will go horribly wrong. Exactly what goes wrong depends on whether userspace notices that umount() failed. Similarly, if you load one of these modules over a network and then lose your connection, you have a problem.
>>
>> there is not abi breakage and file cannot disappear from running task.
>> One cannot umount fs while file is still being used.
>
> Sure it is. Without your patch, init_module doesn’t keep using the
> file, so it’s common practice to load a module and then delete or
> unmount it. With your patch, the unmount case breaks. This is likely
> to break existing userspace, so, in Linux speak it’s an ABI break.

please read the patch again.
file is only used in case of umh modules.
There is zero difference in default case.

>>
>>>
>>> The “read twice” thing is also bad for another reason: containers. Suppose I have a setup where a container can load a signed module blob. With the read twice code, the container can race and run an entirely different blob outside the container.
>>
>> Not only "read twice", but "read many".
>> If .text sections of elf that are not yet in memory can be modified
>> by malicious user, later they will be brought in with different code.
>> I think the easiest fix to tighten this "umh modules" to CAP_SYS_ADMIN.
>
> Given this issue, I think the patch would need Kees’s explicit ack. I
> had initially thought your patch had minimal security impact, but I
> was wrong Module security is very complicated and needs to satisfy a
> bunch of requirements. There is a lot of code in the kernel that
> assumes that it’s sufficient to verify a module once at load time,
> your patch changes that, and this has all kinds of nasty interactions
> with autoloading.

not true. you misread the patch and making incorrect conclusions.

> Kees is very reasonable, and he’ll change his mind
> and ack a patch that he’s nacked when presented with a valid technical
> argument.
>
> But I think my ABI break observation is also a major problem, and
> Linus is going to be pissed if this thing lands in his tree and breaks
> systems due to an issue that was raised during review. So I think you
> need to either rework the patch or do a serious survey of how all the

I think you need to stop overreacting on non-issue.

> distros deal with modules (dracut, initramfs-tools, all the older
> stuff, and probably more) and make sure they can all handle your
> patch.  I'd also be concerned about anyone who puts /lib/modules on
> less reliable storage than they use for the rest of their system.  (I
> know it's quite common to have /boot be the only non-RAID partition on
> a system, but modules don't generally live in /boot.)
>
> Also, I think you really ought to explain how your approach will work
> with MODULES=n or convince Linus that it’s okay to start adding core
> networking features that don’t work with MODULES=n and can't be built
> into the main kernel image.

that ship sailed long ago.
config BPF_JIT
         bool "enable BPF Just In Time compiler"
         depends on HAVE_CBPF_JIT || HAVE_EBPF_JIT
         depends on MODULES
