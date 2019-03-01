From: Jann Horn <jannh@google.com>
Subject: a.out coredumping: fix or delete?
Date: Sat, 2 Mar 2019 00:57:30 +0100
Message-ID: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

In theory, Linux can dump cores for a.out binaries. In practice, that
code is pretty bitrotten and buggy. Does anyone want that code so much
that they'd like to fix it, or can we just delete it?

Here's a shell script that will give you a minimal a.out binary that
Linux will execute (and that then segfaults immediately because it has
no executable pages mapped):

==============
#!/bin/bash
(
  # a_info: magic=OMAGIC
  printf '\x07\x01'
  # a_info: machtype=M_386
  printf '\x64'
  # a_info: flags=0
  printf '\x00'

  # a_text, a_data, a_bss, a_syms: 0
  printf '\x00\x00\x00\x00'
  printf '\x00\x00\x00\x00'
  printf '\x00\x00\x00\x00'
  printf '\x00\x00\x00\x00'

  # a_entry: 0x42424242
  printf '\x42\x42\x42\x42'

  # a_trsize, a_drsize: 0
  printf '\x00\x00\x00\x00'
  printf '\x00\x00\x00\x00'
) > aout_binary
chmod +x aout_binary
==============

You need a kernel with CONFIG_IA32_AOUT enabled (for x86-64) or with
CONFIG_BINFMT_AOUT enabled (for 32-bit x86). If aout is built as a
module, you have to manually load it with "modprobe binfmt_aout",
because even though there is binfmt autoloading code in the kernel, no
aliases are set up for any binfmts.

On a Debian 9 system with a 4.9 stable kernel, if you try to run this
a.out program with core dumps enabled ("ulimit -c unlimited") a few
times, the kernel oopses:

==============
[ 2659.912016] aout_binary[978]: segfault at 42424242 ip 42424242 sp
bfffe4e0 error 14
[ 2659.912318] BUG: unable to handle kernel paging request at bffff000
[ 2659.912336] IP: [<d030bd14>] memcpy+0x14/0x30
[ 2659.912364] *pdpt = 00000000367f7001 *pde = 000000007d0d1067
[ 2659.912368] Oops: 0000 [#1] SMP
[ 2659.912377] Modules linked in: binfmt_aout [...]
[ 2659.912421] CPU: 0 PID: 978 Comm: aout_binary Not tainted
4.9.0-8-686-pae #1 Debian 4.9.144-3.1
[ 2659.912422] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.10.2-1 04/01/2014
[ 2659.912424] task: f30e2000 task.stack: f470a000
[ 2659.912428] EIP: 0060:[<d030bd14>] EFLAGS: 00010206 CPU: 0
[ 2659.912430] EIP is at memcpy+0x14/0x30
[ 2659.912431] EAX: fffba000 EBX: 00001000 ECX: 00000400 EDX: bffff000
[ 2659.912433] ESI: bffff000 EDI: fffba000 EBP: f470bab0 ESP: f470baa4
[ 2659.912434]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 2659.912436] CR0: 80050033 CR2: bffff000 CR3: 346ad4e0 CR4: 001406f0
[ 2659.912442] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 2659.912444] DR6: fffe0ff0 DR7: 00000400
[ 2659.912445] Stack:
[ 2659.912446]  f470bbf0 bffff000 00001000 00001000 d03111a2 f470bb28
00003000 00000000
[ 2659.912449]  fffbb000 f470bc10 fffba000 6721debb 00001000 00002000
00000000 f470bb40
[ 2659.912452]  d016cd10 00001000 00000000 00001000 00000001 f470bb28
f470bb2c 00001000
[ 2659.912456] Call Trace:
[ 2659.912475]  [<d03111a2>] ? iov_iter_copy_from_user_atomic+0x1a2/0x230
[ 2659.912488]  [<d016cd10>] ? generic_perform_write+0xe0/0x1d0
[ 2659.912492]  [<d016ef52>] ? __generic_file_write_iter+0x192/0x1f0
[ 2659.912501]  [<d0217c67>] ? __find_get_block+0xc7/0x250
[ 2659.912512]  [<f8680496>] ? ext4_file_write_iter+0x86/0x460 [ext4]
[ 2659.912514]  [<f85c7050>] ? crc32c_intel_init+0x20/0x20 [crc32c_intel]
[ 2659.912517]  [<d021816c>] ? __getblk_gfp+0x2c/0x310
[ 2659.912523]  [<d01e12bc>] ? generic_file_llseek_size+0x13c/0x1e0
[ 2659.912525]  [<d01e1eac>] ? new_sync_write+0xcc/0x130
[ 2659.912527]  [<d01e1faf>] ? __kernel_write+0x4f/0x100
[ 2659.912537]  [<d023b382>] ? dump_emit+0x92/0xe0
[ 2659.912539]  [<f86fead5>] ? aout_core_dump+0x2a5/0x2f1 [binfmt_aout]
[ 2659.912542]  [<d023bb43>] ? do_coredump+0x4d3/0xde0
[...]
[ 2659.912618] Code: 58 2b 43 50 88 43 4e 5b 5d c3 90 8d 74 26 00 e8
43 fb ff ff eb e8 90 55 89 e5 57 56 53 3e 8d 74 26 00 89 cb 89 c7 c1
e9 02 89 d6 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f 5d c3 8d b6 00
00 00
[ 2659.912639] EIP: [<d030bd14>]
[ 2659.912641] memcpy+0x14/0x30
[ 2659.912642]  SS:ESP 0068:f470baa4
[ 2659.912643] CR2: 00000000bffff000
[ 2659.912645] ---[ end trace 6413c918c629c657 ]---
==============

The problem is that since 43a5d548eb594, aout_core_dump() essentially
calls __kernel_write() on a userspace address, which then causes
iov_iter_init() to decide based on uaccess_kernel() that it should use
ITER_KVEC and access the userspace memory with memcpy().


If you try to reproduce this on a 64-bit system with a master branch
kernel, it doesn't work. But that's because that code is even more
broken: The userspace stack pointer is something like 0xffffc4c8, but
fill_dump() for some reason assumes that top-of-stack is at
0xc0000000, causing it to not even attempt to dump the stack:

        if (dump->start_stack < 0xc0000000) {
                unsigned long tmp;

                tmp = (unsigned long) (0xc0000000 - dump->start_stack);
                dump->u_ssize = tmp >> PAGE_SHIFT;
        }

You can reproduce the oops if you use gdb to move the stack pointer
down below 0xc0000000:

==============
user@debian:~/aout$ ulimit -c unlimited
user@debian:~/aout$ gdb ./aout_binary
[...]
(gdb) break *0x42424242
Breakpoint 1 at 0x42424242
(gdb) run
Starting program: /home/user/aout/aout_binary
[...]
(gdb) p/x $sp
$1 = 0xffffcdcc
(gdb) set $sp=0x80000000
(gdb) detach
Detaching from p[   94.987218] aout_binary[1079]: segfault at 42424242
ip 0000000042424242 sp 0000000080000000 error 14
rogram: /home/us[   94.989368] Code: Bad RIP value.
er/aout/aout_binary, process 1079
(gdb) [   94.991341]
==================================================================
[   94.993463] BUG: KASAN: user-memory-access in
iov_iter_copy_from_user_atomic+0x23d/0x530
[   94.995465] Read of size 4096 at addr 0000000080000000 by task
aout_binary/1079
[   94.997069]
[   94.997417] CPU: 4 PID: 1079 Comm: aout_binary Not tainted 5.0.0-rc8 #292
[   94.998942] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.10.2-1 04/01/2014
[   95.000809] Call Trace:
[   95.001412]  dump_stack+0x71/0xab
[...]
[   95.004628]  kasan_report+0x176/0x192
[...]
[   95.006746]  memcpy+0x1f/0x50
[   95.007433]  iov_iter_copy_from_user_atomic+0x23d/0x530
[...]
[   95.009459]  generic_perform_write+0x1a1/0x2d0
[...]
[   95.013166]  __generic_file_write_iter+0x264/0x2a0
[   95.014242]  ext4_file_write_iter+0x3a4/0x680
[...]
[   95.027234]  __vfs_write+0x294/0x3b0
[...]
[   95.032673]  __kernel_write+0x91/0x190
[   95.033540]  dump_emit+0x131/0x1d0
[...]
[   95.076087] Disabling lock debugging due to kernel taint
[   95.077287] BUG: unable to handle kernel paging request at 0000000080000000
[   95.078812] #PF error: [normal kernel read fault]
[   95.079845] PGD 1e0629067 P4D 1e0629067 PUD 0
[   95.080831] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
[...]
==============

Also, the non-compat version of the coredump code looks like it leaks
some kernel memory into the coredump through "struct user". I don't
think anyone's going to care much, given that it looks like on distro
kernels, you won't usually be able to load a.out binaries...


The rest of a.out is also kind of weird; for example, there is support
for loading text at an unaligned offset (by copying code into an
anonymous mapping), but from a glance, it looks like the resulting
text mapping wouldn't actually be executable? And there is support for
loading files without mmap handler, except that an earlier security
check prevents the use of files without mmap handler, unless you're on
x86-64, where the copied code in ia32_aout.c is used that doesn't have
that security check.
