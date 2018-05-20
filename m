From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v5 3/7] proc: add helpers to set and get proc hidepid and
 gid mount options
Date: Sun, 20 May 2018 15:53:50 +0800
Message-ID: <201805201557.rhcitUVX%fengguang.wu@intel.com>
References: <20180511093528.GA1250@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180511093528.GA1250@comp-core-i7-2640m-0182e6>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: kbuild-all@01.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Steph
List-Id: linux-api@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Djalal,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.17-rc5]
[cannot apply to next-20180517]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Alexey-Gladkov/proc-add-proc_fs_info-struct-to-store-proc-information/20180512-002936
config: xtensa-allnoconfig (attached as .config)
compiler: xtensa-linux-gcc (GCC) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=xtensa 

All errors (new ones prefixed by >>):

   init/do_mounts.o: In function `proc_fs_pid_gid':
>> do_mounts.c:(.text+0x3c): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   arch/xtensa/kernel/setup.o: In function `proc_fs_pid_gid':
   setup.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/fork.o: In function `proc_fs_pid_gid':
   fork.c:(.text+0x2a8): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/exec_domain.o: In function `proc_fs_pid_gid':
   exec_domain.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/cpu.o: In function `proc_fs_pid_gid':
   cpu.c:(.text+0xf0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/exit.o: In function `proc_fs_pid_gid':
   exit.c:(.text+0x188): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/resource.o: In function `proc_fs_pid_gid':
   resource.c:(.text+0x344): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sysctl.o: In function `proc_fs_pid_gid':
   sysctl.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/pid.o: In function `proc_fs_pid_gid':
   pid.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/core.o: In function `proc_fs_pid_gid':
   core.c:(.text+0x6c8): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/loadavg.o: In function `proc_fs_pid_gid':
   loadavg.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/clock.o: In function `proc_fs_pid_gid':
   clock.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/cputime.o: In function `proc_fs_pid_gid':
   cputime.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/idle.o: In function `proc_fs_pid_gid':
   idle.c:(.text+0x98): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/fair.o: In function `proc_fs_pid_gid':
   fair.c:(.text+0xac0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/rt.o: In function `proc_fs_pid_gid':
   rt.c:(.text+0x734): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/deadline.o: In function `proc_fs_pid_gid':
   deadline.c:(.text+0x10b0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/wait.o: In function `proc_fs_pid_gid':
   wait.c:(.text+0x120): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/wait_bit.o: In function `proc_fs_pid_gid':
   wait_bit.c:(.text+0x78): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/swait.o: In function `proc_fs_pid_gid':
   swait.c:(.text+0x24): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/sched/completion.o: In function `proc_fs_pid_gid':
   completion.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   kernel/time/timer_list.o: In function `proc_fs_pid_gid':
   timer_list.c:(.text+0x1c): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   mm/vmstat.o: In function `proc_fs_pid_gid':
   vmstat.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   mm/slab_common.o: In function `proc_fs_pid_gid':
   slab_common.c:(.text+0x0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   mm/vmalloc.o: In function `proc_fs_pid_gid':
   vmalloc.c:(.text+0x514): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   mm/slub.o: In function `proc_fs_pid_gid':
   slub.c:(.text+0x8a4): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   fs/filesystems.o: In function `proc_fs_pid_gid':
   filesystems.c:(.text+0x44): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here
   drivers/char/misc.o: In function `proc_fs_pid_gid':
   misc.c:(.text+0xe0): multiple definition of `proc_fs_pid_gid'
   init/main.o:main.c:(.text+0x30): first defined here

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--pf9I7BMVVzbSWLtt
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
+FrZ/0sT4CsY04hD/j/DcuVlfjcAAA==

--pf9I7BMVVzbSWLtt--
