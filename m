From: kbuild test robot <lkp@intel.com>
Subject: Re: [RFC v3 5/9] kmsg: add function for adding and deleting
 additional buffers
Date: Tue, 20 Oct 2015 02:20:39 +0800
Message-ID: <201510200226.CVm0mP4X%fengguang.wu@intel.com>
References: <1445259503-18158-6-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445259503-18158-6-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
Cc: kbuild-all@01.org, Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Marcin,

[auto build test WARNING on next-20151016 -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Paul-Osmialowski/Additional-kmsg-devices/20151019-211509
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> include/linux/rcupdate.h:915:9: sparse: context imbalance in 'kmsg_read' - unexpected unlock

vim +/kmsg_read +915 include/linux/rcupdate.h

f27bc4873 Paul E. McKenney 2014-05-04  899   * that that preemption never happens within any RCU read-side critical
f27bc4873 Paul E. McKenney 2014-05-04  900   * section whose outermost rcu_read_unlock() is called with irqs disabled.
f27bc4873 Paul E. McKenney 2014-05-04  901   * This approach relies on the fact that rt_mutex_unlock() currently only
f27bc4873 Paul E. McKenney 2014-05-04  902   * acquires irq-disabled locks.
f27bc4873 Paul E. McKenney 2014-05-04  903   *
f27bc4873 Paul E. McKenney 2014-05-04  904   * The second of these two approaches is best in most situations,
f27bc4873 Paul E. McKenney 2014-05-04  905   * however, the first approach can also be useful, at least to those
f27bc4873 Paul E. McKenney 2014-05-04  906   * developers willing to keep abreast of the set of locks acquired by
f27bc4873 Paul E. McKenney 2014-05-04  907   * rt_mutex_unlock().
f27bc4873 Paul E. McKenney 2014-05-04  908   *
3d76c0829 Paul E. McKenney 2009-09-28  909   * See rcu_read_lock() for more information.
3d76c0829 Paul E. McKenney 2009-09-28  910   */
bc33f24bd Paul E. McKenney 2009-08-22  911  static inline void rcu_read_unlock(void)
bc33f24bd Paul E. McKenney 2009-08-22  912  {
f78f5b90c Paul E. McKenney 2015-06-18  913  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
bde23c689 Heiko Carstens   2012-02-01  914  			 "rcu_read_unlock() used illegally while idle");
bc33f24bd Paul E. McKenney 2009-08-22 @915  	__release(RCU);
bc33f24bd Paul E. McKenney 2009-08-22  916  	__rcu_read_unlock();
d24209bb6 Paul E. McKenney 2015-01-21  917  	rcu_lock_release(&rcu_lock_map); /* Keep acq info for rls diags. */
bc33f24bd Paul E. McKenney 2009-08-22  918  }
^1da177e4 Linus Torvalds   2005-04-16  919  
^1da177e4 Linus Torvalds   2005-04-16  920  /**
ca5ecddfa Paul E. McKenney 2010-04-28  921   * rcu_read_lock_bh() - mark the beginning of an RCU-bh critical section
^1da177e4 Linus Torvalds   2005-04-16  922   *
^1da177e4 Linus Torvalds   2005-04-16  923   * This is equivalent of rcu_read_lock(), but to be used when updates

:::::: The code at line 915 was first introduced by commit
:::::: bc33f24bdca8b6e97376e3a182ab69e6cdefa989 rcu: Consolidate sparse and lockdep declarations in include/linux/rcupdate.h

:::::: TO: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
:::::: CC: Ingo Molnar <mingo@elte.hu>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
