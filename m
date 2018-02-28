From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next v8 06/11] bpf,landlock: Add a new map type: inode
Date: Thu, 1 Mar 2018 01:35:48 +0800
Message-ID: <201803010105.33CKFRaJ%fengguang.wu@intel.com>
References: <20180227004121.3633-7-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180227004121.3633-7-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun
List-Id: linux-api@vger.kernel.org

Hi Mickaël,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Micka-l-Sala-n/Landlock-LSM-Toward-unprivileged-sandboxing/20180228-233659
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/init.h:134:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/init.h:135:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/init.h:268:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/init.h:269:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/printk.h:200:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:32:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:34:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:37:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:38:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:40:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:42:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:43:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:45:5: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:46:5: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:49:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/qspinlock.h:53:32: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/workqueue.h:646:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/workqueue.h:647:5: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/numa.h:34:12: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/numa.h:35:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/numa.h:62:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/vmalloc.h:64:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/vmalloc.h:173:8: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/vmalloc.h:174:8: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/fixmap.h:174:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/fixmap.h:176:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/fixmap.h:178:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/fixmap.h:180:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/apic.h:254:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/apic.h:430:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/io_apic.h:184:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/smp.h:113:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/smp.h:125:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/smp.h:126:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:110:33: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:112:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:114:12: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:118:12: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:126:12: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/hrtimer.h:497:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/memory_hotplug.h:221:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/mmzone.h:1292:15: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/kmemleak.h:29:33: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/kasan.h:29:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/kasan.h:30:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/pgtable.h:28:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/slab.h:135:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/slab.h:716:6: sparse: attribute 'indirect_branch': unknown attribute
>> security/landlock/tag.c:127:18: sparse: incompatible types in comparison expression (different address spaces)
   security/landlock/tag.c:257:16: sparse: incompatible types in comparison expression (different address spaces)
   security/landlock/tag.c:263:24: sparse: incompatible types in comparison expression (different address spaces)
   security/landlock/tag.c:357:16: sparse: incompatible types in comparison expression (different address spaces)
--
   arch/x86/include/asm/mem_encrypt.h:37:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:38:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:40:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:42:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:43:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:45:5: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:46:5: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/mem_encrypt.h:49:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/qspinlock.h:53:32: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/workqueue.h:646:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/workqueue.h:647:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/wait_bit.h:41:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/numa.h:34:12: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/numa.h:35:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/numa.h:62:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/vmalloc.h:64:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/vmalloc.h:173:8: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/vmalloc.h:174:8: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/fixmap.h:174:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/fixmap.h:176:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/fixmap.h:178:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/fixmap.h:180:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/apic.h:254:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/apic.h:430:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/io_apic.h:184:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/smp.h:113:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/smp.h:125:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/smp.h:126:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:110:33: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:112:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:114:12: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:118:12: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/percpu.h:126:12: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/fs.h:63:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/fs.h:64:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/fs.h:65:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/fs.h:66:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/memory_hotplug.h:221:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/mmzone.h:1292:15: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/fs.h:2422:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/fs.h:2423:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/fs.h:3330:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/hrtimer.h:497:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/kmemleak.h:29:33: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/kasan.h:29:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/kasan.h:30:6: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/pgtable.h:28:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/slab.h:135:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/slab.h:716:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/mm.h:1753:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/mm.h:1941:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/mm.h:2083:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/mm.h:2671:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/swiotlb.h:39:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/swiotlb.h:124:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/swiotlb.h:9:12: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/swiotlb.h:10:12: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/swiotlb.h:11:13: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/swiotlb.h:12:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/dma-contiguous.h:85:5: sparse: attribute 'indirect_branch': unknown attribute
   arch/x86/include/asm/vdso.h:44:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/cred.h:167:13: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/nsproxy.h:74:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/io.h:47:6: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/netdevice.h:302:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/netdevice.h:4056:5: sparse: attribute 'indirect_branch': unknown attribute
   include/linux/ftrace.h:462:6: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/bpf.h:59:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/bpf.h:95:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/bpf.h:120:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/bpf.h:150:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/bpf.h:191:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/bpf.h:231:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/bpf.h:285:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/bpf.h:315:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/xdp.h:28:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/xdp.h:53:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/xdp.h:155:1: sparse: attribute 'indirect_branch': unknown attribute
   include/trace/events/xdp.h:190:1: sparse: attribute 'indirect_branch': unknown attribute
   kernel/bpf/core.c:1549:31: sparse: incorrect type in return expression (different address spaces) @@    expected struct bpf_prog_array [noderef] <asn:4>* @@    got sn:4>* @@
   kernel/bpf/core.c:1549:31:    expected struct bpf_prog_array [noderef] <asn:4>*
   kernel/bpf/core.c:1549:31:    got void *
   kernel/bpf/core.c:1553:17: sparse: incorrect type in return expression (different address spaces) @@    expected struct bpf_prog_array [noderef] <asn:4>* @@    got rray [noderef] <asn:4>* @@
   kernel/bpf/core.c:1553:17:    expected struct bpf_prog_array [noderef] <asn:4>*
   kernel/bpf/core.c:1553:17:    got struct bpf_prog_array *<noident>
   kernel/bpf/core.c:1561:9: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct callback_head *head @@    got struct callback_hstruct callback_head *head @@
   kernel/bpf/core.c:1561:9:    expected struct callback_head *head
   kernel/bpf/core.c:1561:9:    got struct callback_head [noderef] <asn:4>*<noident>
   kernel/bpf/core.c:1624:34: sparse: incorrect type in initializer (different address spaces) @@    expected struct bpf_prog **prog @@    got struct bpf_prog *struct bpf_prog **prog @@
   kernel/bpf/core.c:1624:34:    expected struct bpf_prog **prog
   kernel/bpf/core.c:1624:34:    got struct bpf_prog *[noderef] <asn:4>*<noident>
   kernel/bpf/core.c:1647:31: sparse: incorrect type in assignment (different address spaces) @@    expected struct bpf_prog **existing_prog @@    got struct bpf_prog *struct bpf_prog **existing_prog @@
   kernel/bpf/core.c:1647:31:    expected struct bpf_prog **existing_prog
   kernel/bpf/core.c:1647:31:    got struct bpf_prog *[noderef] <asn:4>*<noident>
   kernel/bpf/core.c:1669:15: sparse: incorrect type in assignment (different address spaces) @@    expected struct bpf_prog_array *array @@    got struct bpf_prog_astruct bpf_prog_array *array @@
   kernel/bpf/core.c:1669:15:    expected struct bpf_prog_array *array
   kernel/bpf/core.c:1669:15:    got struct bpf_prog_array [noderef] <asn:4>*
   kernel/bpf/core.c:1675:31: sparse: incorrect type in assignment (different address spaces) @@    expected struct bpf_prog **[assigned] existing_prog @@    got structstruct bpf_prog **[assigned] existing_prog @@
   kernel/bpf/core.c:1675:31:    expected struct bpf_prog **[assigned] existing_prog
   kernel/bpf/core.c:1675:31:    got struct bpf_prog *[noderef] <asn:4>*<noident>
   include/trace/events/bpf.h:59:1: sparse: Using plain integer as NULL pointer
   include/trace/events/bpf.h:95:1: sparse: Using plain integer as NULL pointer
   include/trace/events/bpf.h:120:1: sparse: Using plain integer as NULL pointer
   include/trace/events/bpf.h:191:1: sparse: Using plain integer as NULL pointer
   include/trace/events/bpf.h:231:1: sparse: Using plain integer as NULL pointer
   include/trace/events/bpf.h:285:1: sparse: too many warnings

vim +127 security/landlock/tag.c

   116	
   117	/* return true if the tag_root is queued for freeing, false otherwise */
   118	static void put_tag_root(struct landlock_tag_root **root,
   119			spinlock_t *root_lock)
   120	{
   121		struct landlock_tag_root *freeme;
   122	
   123		if (!root || WARN_ON(!root_lock))
   124			return;
   125	
   126		rcu_read_lock();
 > 127		freeme = rcu_dereference(*root);
   128		if (WARN_ON(!freeme))
   129			goto out_rcu;
   130		if (!refcount_dec_and_lock(&freeme->tag_nb, root_lock))
   131			goto out_rcu;
   132	
   133		rcu_assign_pointer(*root, NULL);
   134		spin_unlock(root_lock);
   135		call_rcu(&freeme->rcu_put, put_tag_root_rcu);
   136	
   137	out_rcu:
   138		rcu_read_unlock();
   139	}
   140	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
