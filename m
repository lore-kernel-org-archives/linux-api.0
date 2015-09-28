From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v3 2/2] pidns: introduce syscall getvpid
Date: Mon, 28 Sep 2015 12:12:21 +0800
Message-ID: <201509281251.xxfjYZb4%fengguang.wu@intel.com>
References: <20150925135247.27620.37109.stgit@buzz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150925135247.27620.37109.stgit@buzz>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Konstantin,

[auto build test results on next-20150925 -- if it's inappropriate base, please ignore]

config: openrisc-or1ksim_defconfig (attached as .config)
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout 7bea85b3c058d69527d79b94338025f218a0655e
  # save the attached .config to linux build tree
  make.cross ARCH=openrisc 

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/unistd.h:1:0,
                    from arch/openrisc/include/uapi/asm/unistd.h:26,
                    from <stdin>:2:
>> include/uapi/asm-generic/unistd.h:718:0: warning: "__NR_mlock2" redefined
   include/uapi/asm-generic/unistd.h:716:0: note: this is the location of the previous definition
   <stdin>:1307:2: warning: #warning syscall getvpid not implemented
--
   In file included from include/asm-generic/unistd.h:1:0,
                    from arch/openrisc/include/uapi/asm/unistd.h:26,
                    from include/uapi/linux/unistd.h:7,
                    from arch/openrisc/kernel/setup.c:25:
>> include/uapi/asm-generic/unistd.h:718:0: warning: "__NR_mlock2" redefined
   include/uapi/asm-generic/unistd.h:716:0: note: this is the location of the previous definition
--
   In file included from include/asm-generic/unistd.h:1:0,
                    from arch/openrisc/include/uapi/asm/unistd.h:26,
                    from include/uapi/linux/unistd.h:7,
                    from include/linux/syscalls.h:78,
                    from arch/openrisc/kernel/sys_call_table.c:17:
>> include/uapi/asm-generic/unistd.h:718:0: warning: "__NR_mlock2" redefined
   include/uapi/asm-generic/unistd.h:716:0: note: this is the location of the previous definition
   In file included from include/asm-generic/unistd.h:1:0,
                    from arch/openrisc/include/uapi/asm/unistd.h:26,
                    from arch/openrisc/kernel/sys_call_table.c:27:
   include/uapi/asm-generic/unistd.h:716:0: warning: "__NR_mlock2" redefined
   include/uapi/asm-generic/unistd.h:718:0: note: this is the location of the previous definition
>> include/uapi/asm-generic/unistd.h:718:0: warning: "__NR_mlock2" redefined
   include/uapi/asm-generic/unistd.h:716:0: note: this is the location of the previous definition
   include/uapi/asm-generic/unistd.h:719:1: error: '__NR_getvpid' undeclared here (not in a function)
   include/uapi/asm-generic/unistd.h:719:1: error: array index in initializer not of integer type
   include/uapi/asm-generic/unistd.h:719:1: error: (near initialization for 'sys_call_table')
--
   kernel/time/Kconfig:155:warning: range is invalid
   In file included from include/asm-generic/unistd.h:1:0,
                    from arch/openrisc/include/uapi/asm/unistd.h:26,
                    from <stdin>:2:
>> include/uapi/asm-generic/unistd.h:718:0: warning: "__NR_mlock2" redefined
   include/uapi/asm-generic/unistd.h:716:0: note: this is the location of the previous definition
   <stdin>:1307:2: warning: #warning syscall getvpid not implemented

vim +/__NR_mlock2 +718 include/uapi/asm-generic/unistd.h

   702	#define __NR_seccomp 277
   703	__SYSCALL(__NR_seccomp, sys_seccomp)
   704	#define __NR_getrandom 278
   705	__SYSCALL(__NR_getrandom, sys_getrandom)
   706	#define __NR_memfd_create 279
   707	__SYSCALL(__NR_memfd_create, sys_memfd_create)
   708	#define __NR_bpf 280
   709	__SYSCALL(__NR_bpf, sys_bpf)
   710	#define __NR_execveat 281
   711	__SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
   712	#define __NR_userfaultfd 282
   713	__SYSCALL(__NR_userfaultfd, sys_userfaultfd)
   714	#define __NR_membarrier 283
   715	__SYSCALL(__NR_membarrier, sys_membarrier)
   716	#define __NR_mlock2 284
   717	__SYSCALL(__NR_mlock2, sys_mlock2)
 > 718	#define __NR_mlock2 285
   719	__SYSCALL(__NR_getvpid, sys_getvpid)
   720	
   721	#undef __NR_syscalls
   722	#define __NR_syscalls 286
   723	
   724	/*
   725	 * All syscalls below here should go away really,
   726	 * these are provided for both review and as a porting

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--YiEDa0DAkWCtVeE4
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
3vkLUeoWHtpXMFHyu6aXFsnQyP0Ps5YCYpJkAAA=

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--YiEDa0DAkWCtVeE4--
