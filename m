From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Fri, 9 Mar 2018 16:24:32 +0000
Message-ID: <CALCETrX+oGQthnk5AR0MUJwLLwguWG_yq_r9QQPhUYjvz9jyPw@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
 <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
 <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
 <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net> <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
 <CALCETrWKLB4e8Cw6ZRiDP535=HzoQJczsEMEpytstveO15mAMg@mail.gmail.com> <6d2e31fa-d87b-fea6-c919-b7d066bb0385@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6d2e31fa-d87b-fea6-c919-b7d066bb0385@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 9, 2018 at 3:39 PM, Alexei Starovoitov <ast@fb.com> wrote:
> On 3/9/18 7:16 AM, Andy Lutomirski wrote:
>>>>
>>>> On Mar 8, 2018, at 9:08 PM, Alexei Starovoitov <ast@fb.com> wrote:
>>>>
>>>> On 3/8/18 7:54 PM, Andy Lutomirski wrote:
>>>>
>>>>
>>>>
>>>>> On Mar 8, 2018, at 7:06 PM, Linus Torvalds
>>>>> <torvalds@linux-foundation.org> wrote:
>>>>>
>>>>>
>>>>> Honestly, that "read twice" thing may be what scuttles this.
>>>>> Initially, I thought it was a non-issue, because anybody who controls
>>>>> the module subdirectory enough to rewrite files would be in a position
>>>>> to just execute the file itself directly instead.
>>>>
>>>>
>>>> On further consideration, I think there’s another showstopper. This
>>>> patch is a potentially severe ABI break. Right now, loading a module
>>>> *copies* it into memory and does not hold a reference to the underlying fs.
>>>> With the patch applied, all kinds of use cases can break in gnarly ways.
>>>> Initramfs is maybe okay, but initrd may be screwed. If you load an ET_EXEC
>>>> module from initrd, then umount it, then clear the ramdisk, something will
>>>> go horribly wrong. Exactly what goes wrong depends on whether userspace
>>>> notices that umount() failed. Similarly, if you load one of these modules
>>>> over a network and then lose your connection, you have a problem.
>>>
>>>
>>> there is not abi breakage and file cannot disappear from running task.
>>> One cannot umount fs while file is still being used.
>>
>>
>> Sure it is. Without your patch, init_module doesn’t keep using the
>> file, so it’s common practice to load a module and then delete or
>> unmount it. With your patch, the unmount case breaks. This is likely
>> to break existing userspace, so, in Linux speak it’s an ABI break.
>
>
> please read the patch again.
> file is only used in case of umh modules.
> There is zero difference in default case.

Say I'm running some distro or other working Linux setup.  I upgrade
my kernel to a kernel that uses umh modules.  The user tooling
generates some kind of boot entry that references the new kernel
image, and it also generates a list of modules to be loaded at various
times in the boot process.  This list might, and probably should,
include one or more umh modules.  (You are being very careful to make
sure that depmod keeps working, so umh modules are clearly intended to
work with existing tooling.)  So now I have a kernel image and some
modules to be loaded from various places.  And I have an init script
(initramfs's '/init' or similar) that will call init_module() on that
.ko file.  That script was certainly written under the assumption
that, once init_module() returns, the kernel is done with the .ko
file.  With your patch applied, that assumption is no longer true.

RHEL 5 uses initrd and is still supported.  For all I know, some
embedded setups put their initial /lib on some block device that
literally disappears after they finish booting.  There are livecds
that let you boot in a mode that lets you remove the CD after you
finish booting.  Heck, someone must have built something that calls
init_module() on a FUSE filesystem.

Heck, on my laptop, all my .ko files are labeled
system_u:object_r:modules_object_t:s0.  I wonder how many SELinux
setups (and AppArmor, etc) will actually disallow execve() on modules?

>
>>>
>>>>
>>>> The “read twice” thing is also bad for another reason: containers.
>>>> Suppose I have a setup where a container can load a signed module blob. With
>>>> the read twice code, the container can race and run an entirely different
>>>> blob outside the container.
>>>
>>>
>>> Not only "read twice", but "read many".
>>> If .text sections of elf that are not yet in memory can be modified
>>> by malicious user, later they will be brought in with different code.
>>> I think the easiest fix to tighten this "umh modules" to CAP_SYS_ADMIN.
>>
>>
>> Given this issue, I think the patch would need Kees’s explicit ack. I
>> had initially thought your patch had minimal security impact, but I
>> was wrong Module security is very complicated and needs to satisfy a
>> bunch of requirements. There is a lot of code in the kernel that
>> assumes that it’s sufficient to verify a module once at load time,
>> your patch changes that, and this has all kinds of nasty interactions
>> with autoloading.
>
>
> not true. you misread the patch and making incorrect conclusions.

So please tell my exactly how I misread the patch and why Linus'
conclusion (which is what I'm echoing) is wrong.

>
> I think you need to stop overreacting on non-issue.
>

Can you please try to have a constructive discussion here?  It's not
so enjoyable to review patches when author declares review comments to
be non-issues without actually explaining *why* they're non-issues.

Alexei, I'm willing to be shown that I'm wrong, but you have to show
me how I'm wrong rather than just telling me over and over that I'm
wrong.
