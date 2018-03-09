From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 9 Mar 2018 10:15:27 -0800
Message-ID: <20180309181527.GA15803@kroah.com>
References: <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
 <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
 <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
 <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
 <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
 <CALCETrWKLB4e8Cw6ZRiDP535=HzoQJczsEMEpytstveO15mAMg@mail.gmail.com>
 <6d2e31fa-d87b-fea6-c919-b7d066bb0385@fb.com>
 <CALCETrX+oGQthnk5AR0MUJwLLwguWG_yq_r9QQPhUYjvz9jyPw@mail.gmail.com>
 <c9388b10-19ac-0bd5-4986-9c306d23046e@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c9388b10-19ac-0bd5-4986-9c306d23046e@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 09, 2018 at 09:32:36AM -0800, Alexei Starovoitov wrote:
> On 3/9/18 8:24 AM, Andy Lutomirski wrote:
> > On Fri, Mar 9, 2018 at 3:39 PM, Alexei Starovoitov <ast@fb.com> wrote:
> > > On 3/9/18 7:16 AM, Andy Lutomirski wrote:
> > > > > > 
> > > > > > On Mar 8, 2018, at 9:08 PM, Alexei Starovoitov <ast@fb.com> wrote:
> > > > > > 
> > > > > > On 3/8/18 7:54 PM, Andy Lutomirski wrote:
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > > On Mar 8, 2018, at 7:06 PM, Linus Torvalds
> > > > > > > <torvalds@linux-foundation.org> wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > Honestly, that "read twice" thing may be what scuttles this.
> > > > > > > Initially, I thought it was a non-issue, because anybody who controls
> > > > > > > the module subdirectory enough to rewrite files would be in a position
> > > > > > > to just execute the file itself directly instead.
> > > > > > 
> > > > > > 
> > > > > > On further consideration, I think there’s another showstopper. This
> > > > > > patch is a potentially severe ABI break. Right now, loading a module
> > > > > > *copies* it into memory and does not hold a reference to the underlying fs.
> > > > > > With the patch applied, all kinds of use cases can break in gnarly ways.
> > > > > > Initramfs is maybe okay, but initrd may be screwed. If you load an ET_EXEC
> > > > > > module from initrd, then umount it, then clear the ramdisk, something will
> > > > > > go horribly wrong. Exactly what goes wrong depends on whether userspace
> > > > > > notices that umount() failed. Similarly, if you load one of these modules
> > > > > > over a network and then lose your connection, you have a problem.
> > > > > 
> > > > > 
> > > > > there is not abi breakage and file cannot disappear from running task.
> > > > > One cannot umount fs while file is still being used.
> > > > 
> > > > 
> > > > Sure it is. Without your patch, init_module doesn’t keep using the
> > > > file, so it’s common practice to load a module and then delete or
> > > > unmount it. With your patch, the unmount case breaks. This is likely
> > > > to break existing userspace, so, in Linux speak it’s an ABI break.
> > > 
> > > 
> > > please read the patch again.
> > > file is only used in case of umh modules.
> > > There is zero difference in default case.
> > 
> > Say I'm running some distro or other working Linux setup.  I upgrade
> > my kernel to a kernel that uses umh modules.  The user tooling
> > generates some kind of boot entry that references the new kernel
> > image, and it also generates a list of modules to be loaded at various
> > times in the boot process.  This list might, and probably should,
> > include one or more umh modules.  (You are being very careful to make
> > sure that depmod keeps working, so umh modules are clearly intended to
> > work with existing tooling.)  So now I have a kernel image and some
> > modules to be loaded from various places.  And I have an init script
> > (initramfs's '/init' or similar) that will call init_module() on that
> > .ko file.  That script was certainly written under the assumption
> > that, once init_module() returns, the kernel is done with the .ko
> > file.  With your patch applied, that assumption is no longer true.
> 
> There is no intent to use umh modules during boot process.

For _your_ use case, yes.  For mine and Andy's and someone else's in the
future, it might be :)

You are creating a very generic, new, user/kernel api that a whole bunch
of people are going to want to use.  Let's not hamper the ability for us
all to use this right from the beginning please.

> This is not a replacement for drivers and kernel modules.
> From your earlier comments regarding usb driver as umh module
> I suspect you're assuming that everything will sooner or later
> will convert to umh model.

We have userspace drivers for USB today, being able to drag that
out-of-tree codebase into the kernel is a _HUGE_ bonus, and something
that I would love to do for a lot of reasons.  I also can see moving
some of our existing in-kernel drivers out of the kernel in a way that
provides "it just works" functionality by using this type of feature.

So again, please don't prevent us from using this, otherwise you should
be just calling this "bpf_usermode_helper" :)

Oh, and for the record, I like Andy's proposal as well as dumping this
into a kernel module "blob" with the exception that this now would take
up unswapable memory, which isn't the nicest and is one big reason we
removed the in-kernel-memory firmware blobs many years ago.

thanks,

greg k-h
