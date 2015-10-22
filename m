From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] restartable sequences: user-space per-cpu
 critical sections
Date: Fri, 23 Oct 2015 02:53:41 +0800
Message-ID: <201510230203.337YMkHy%fengguang.wu@intel.com>
References: <581c0b6403285219724961a3d250c6d95dfacea7.1445464158.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <581c0b6403285219724961a3d250c6d95dfacea7.1445464158.git.davejwatson-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, davejwatson-b10kYP2dOMg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Dave,

[auto build test WARNING on v4.3-rc6 -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Dave-Watson/restartable-sequences-benchmarks/20151023-020939
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/sched.h:1189:34: sparse: Expected ) in function declarator
   include/linux/sched.h:1189:34: sparse: got (
>> builtin:0:0: sparse: expected ; at end of declaration
   include/linux/sched.h:1190:1: sparse: Expected ; at the end of type declaration
   include/linux/sched.h:1190:1: sparse: got }
   include/linux/radix-tree.h:212:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:196:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:196:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:196:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:196:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:196:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:196:16: sparse: incompatible types in comparison expression (different address spaces)
--
   include/linux/sched.h:1189:34: sparse: Expected ) in function declarator
   include/linux/sched.h:1189:34: sparse: got (
>> builtin:0:0: sparse: expected ; at end of declaration
   include/linux/sched.h:1190:1: sparse: Expected ; at the end of type declaration
   include/linux/sched.h:1190:1: sparse: got }
--
   mm/page_alloc.c:6010:1: sparse: directive in argument list
   mm/page_alloc.c:6012:1: sparse: directive in argument list
   mm/page_alloc.c:6019:1: sparse: directive in argument list
   mm/page_alloc.c:6021:1: sparse: directive in argument list
   include/linux/sched.h:1189:34: sparse: Expected ) in function declarator
   include/linux/sched.h:1189:34: sparse: got (
>> builtin:0:0: sparse: expected ; at end of declaration
   include/linux/sched.h:1190:1: sparse: Expected ; at the end of type declaration
   include/linux/sched.h:1190:1: sparse: got }
--
   include/linux/sched.h:1189:34: sparse: Expected ) in function declarator
   include/linux/sched.h:1189:34: sparse: got (
>> builtin:0:0: sparse: expected ; at end of declaration
   include/linux/sched.h:1190:1: sparse: Expected ; at the end of type declaration
   include/linux/sched.h:1190:1: sparse: got }
   include/linux/radix-tree.h:212:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:196:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:196:16: sparse: incompatible types in comparison expression (different address spaces)
--
   mm/debug.c:176:1: sparse: directive in argument list
   mm/debug.c:178:1: sparse: directive in argument list
   mm/debug.c:187:1: sparse: directive in argument list
   mm/debug.c:189:1: sparse: directive in argument list
   mm/debug.c:190:1: sparse: directive in argument list
   mm/debug.c:192:1: sparse: directive in argument list
   mm/debug.c:194:1: sparse: directive in argument list
   mm/debug.c:196:1: sparse: directive in argument list
   mm/debug.c:197:1: sparse: directive in argument list
   mm/debug.c:199:1: sparse: directive in argument list
   mm/debug.c:200:1: sparse: directive in argument list
   mm/debug.c:202:1: sparse: directive in argument list
   mm/debug.c:206:1: sparse: directive in argument list
   mm/debug.c:208:1: sparse: directive in argument list
   mm/debug.c:221:1: sparse: directive in argument list
   mm/debug.c:223:1: sparse: directive in argument list
   mm/debug.c:224:1: sparse: directive in argument list
   mm/debug.c:226:1: sparse: directive in argument list
   mm/debug.c:228:1: sparse: directive in argument list
   mm/debug.c:230:1: sparse: directive in argument list
   mm/debug.c:231:1: sparse: directive in argument list
   mm/debug.c:233:1: sparse: directive in argument list
   mm/debug.c:234:1: sparse: directive in argument list
   mm/debug.c:236:1: sparse: directive in argument list
   include/linux/sched.h:1189:34: sparse: Expected ) in function declarator
   include/linux/sched.h:1189:34: sparse: got (
>> builtin:0:0: sparse: expected ; at end of declaration
   include/linux/sched.h:1190:1: sparse: Expected ; at the end of type declaration
   include/linux/sched.h:1190:1: sparse: got }
--
   include/linux/sched.h:1189:34: sparse: Expected ) in function declarator
   include/linux/sched.h:1189:34: sparse: got (
>> builtin:0:0: sparse: expected ; at end of declaration
   include/linux/sched.h:1190:1: sparse: Expected ; at the end of type declaration
   include/linux/sched.h:1190:1: sparse: got }
   include/linux/radix-tree.h:212:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/radix-tree.h:212:16: sparse: incompatible types in comparison expression (different address spaces)
--
   include/linux/sched.h:1189:34: sparse: Expected ) in function declarator
   include/linux/sched.h:1189:34: sparse: got (
>> builtin:0:0: sparse: expected ; at end of declaration
   include/linux/sched.h:1190:1: sparse: Expected ; at the end of type declaration
   include/linux/sched.h:1190:1: sparse: got }
   mm/memcontrol.c:3289:21: sparse: incompatible types in comparison expression (different address spaces)
   mm/memcontrol.c:3291:21: sparse: incompatible types in comparison expression (different address spaces)
   mm/memcontrol.c:4861:23: sparse: incompatible types in comparison expression (different address spaces)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
