From: kbuild test robot <lkp@intel.com>
Subject: Re: [RFC v3 8/9] kmsg: add predefined _PID, _TID, _COMM keywords to
 kmsg* log dict
Date: Mon, 19 Oct 2015 21:53:45 +0800
Message-ID: <201510192128.kCuhaP7r%fengguang.wu@intel.com>
References: <1445259503-18158-9-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445259503-18158-9-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
Cc: kbuild-all@01.org, Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Marcin,

[auto build test ERROR on next-20151016 -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Paul-Osmialowski/Additional-kmsg-devices/20151019-211509
config: i386-randconfig-s1-201542 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   kernel/printk/kmsg.c: In function 'set_kmsg_dict':
>> kernel/printk/kmsg.c:55:32: error: implicit declaration of function 'task_tgid_nr' [-Werror=implicit-function-declaration]
     len = sprintf(buf, "_PID=%d", task_tgid_nr(current)) + 1;
                                   ^
>> kernel/printk/kmsg.c:56:39: error: implicit declaration of function 'task_pid_nr' [-Werror=implicit-function-declaration]
     len += sprintf(buf + len, "_TID=%d", task_pid_nr(current)) + 1;
                                          ^
>> kernel/printk/kmsg.c:59:2: error: implicit declaration of function 'get_task_comm' [-Werror=implicit-function-declaration]
     get_task_comm(buf + len, current);
     ^
   In file included from include/linux/fs.h:5:0,
                    from kernel/printk/kmsg.c:5:
   kernel/printk/kmsg.c: In function 'kmsg_sys_write':
   include/linux/wait.h:171:47: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
    #define wake_up_interruptible(x) __wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
                                                  ^
   kernel/printk/kmsg.c:84:3: note: in expansion of macro 'wake_up_interruptible'
      wake_up_interruptible(&log_b->wait);
      ^
   include/linux/wait.h:171:47: note: each undeclared identifier is reported only once for each function it appears in
    #define wake_up_interruptible(x) __wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
                                                  ^
   kernel/printk/kmsg.c:84:3: note: in expansion of macro 'wake_up_interruptible'
      wake_up_interruptible(&log_b->wait);
      ^
   kernel/printk/kmsg.c: In function 'devkmsg_write':
>> kernel/printk/kmsg.c:40:10: error: 'TASK_COMM_LEN' undeclared (first use in this function)
         6 + TASK_COMM_LEN)
             ^
   kernel/printk/kmsg.c:102:12: note: in expansion of macro 'KMSG_DICT_MAX_LEN'
     char dict[KMSG_DICT_MAX_LEN];
               ^
>> kernel/printk/kmsg.c:102:7: warning: unused variable 'dict' [-Wunused-variable]
     char dict[KMSG_DICT_MAX_LEN];
          ^
   In file included from include/linux/fs.h:5:0,
                    from kernel/printk/kmsg.c:5:
   kernel/printk/kmsg.c: In function 'kmsg_read':
   include/linux/wait.h:400:31: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
     ___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,  \
                                  ^
   include/linux/wait.h:225:52: note: in definition of macro '___wait_event'
      long __int = prepare_to_wait_event(&wq, &__wait, state);\
                                                       ^
   include/linux/wait.h:423:11: note: in expansion of macro '__wait_event_interruptible'
      __ret = __wait_event_interruptible(wq, condition); \
              ^
   kernel/printk/kmsg.c:181:10: note: in expansion of macro 'wait_event_interruptible'
       ret = wait_event_interruptible(log_b->wait,
             ^
   include/linux/wait.h:198:43: error: 'TASK_KILLABLE' undeclared (first use in this function)
      state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE) \
                                              ^
   include/linux/wait.h:230:7: note: in expansion of macro '___wait_is_interruptible'
      if (___wait_is_interruptible(state) && __int) {  \
          ^
   include/linux/wait.h:400:2: note: in expansion of macro '___wait_event'
     ___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,  \
     ^
   include/linux/wait.h:423:11: note: in expansion of macro '__wait_event_interruptible'
      __ret = __wait_event_interruptible(wq, condition); \
              ^
   kernel/printk/kmsg.c:181:10: note: in expansion of macro 'wait_event_interruptible'
       ret = wait_event_interruptible(log_b->wait,
             ^
   include/linux/wait.h:401:9: error: implicit declaration of function 'schedule' [-Werror=implicit-function-declaration]
            schedule())
            ^
   include/linux/wait.h:240:3: note: in definition of macro '___wait_event'
      cmd;       \
      ^
   include/linux/wait.h:423:11: note: in expansion of macro '__wait_event_interruptible'
      __ret = __wait_event_interruptible(wq, condition); \
              ^
   kernel/printk/kmsg.c:181:10: note: in expansion of macro 'wait_event_interruptible'
       ret = wait_event_interruptible(log_b->wait,
             ^
   kernel/printk/kmsg.c: In function 'kmsg_sys_buffer_del':
   include/linux/wait.h:171:47: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
    #define wake_up_interruptible(x) __wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
                                                  ^
   kernel/printk/kmsg.c:734:2: note: in expansion of macro 'wake_up_interruptible'
     wake_up_interruptible(&log_b->wait);
     ^
   cc1: some warnings being treated as errors

vim +/task_tgid_nr +55 kernel/printk/kmsg.c

    34	 * Fromat below describes dict appended to message written from userspace:
    35	 * "_PID=<pid>\0_TID=<tid>\0_COMM=<comm>"
    36	 * KMSG_DICT_MAX_LEN definition represents maximal length of this dict.
    37	 */
    38	#define KMSG_DICT_MAX_LEN	(5 + MAX_PID_LEN + 1 + \
    39					 5 + MAX_TID_LEN + 1 + \
  > 40					 6 + TASK_COMM_LEN)
    41	
    42	/* /dev/kmsg - userspace message inject/listen interface */
    43	struct devkmsg_user {
    44		u64 seq;
    45		u32 idx;
    46		enum log_flags prev;
    47		struct mutex lock;
    48		char buf[CONSOLE_EXT_LOG_MAX];
    49	};
    50	
    51	static size_t set_kmsg_dict(char *buf)
    52	{
    53		size_t len;
    54	
  > 55		len = sprintf(buf, "_PID=%d", task_tgid_nr(current)) + 1;
  > 56		len += sprintf(buf + len, "_TID=%d", task_pid_nr(current)) + 1;
    57		memcpy(buf + len, "_COMM=", 6);
    58		len += 6;
  > 59		get_task_comm(buf + len, current);
    60		while (buf[len] != '\0')
    61			len++;
    62		return len;
    63	}
    64	
    65	static int kmsg_sys_write(int minor, int level,
    66				  const char *dict, size_t dictlen,
    67				  const char *fmt, ...)
    68	{
    69		va_list args;
    70		int ret = -ENXIO;
    71		struct log_buffer *log_b;
    72	
    73		rcu_read_lock();
    74		list_for_each_entry_rcu(log_b, &log_buf.list, list) {
    75			if (log_b->minor != minor)
    76				continue;
    77	
    78			raw_spin_lock(&log_b->lock);
    79	
    80			va_start(args, fmt);
    81			log_format_and_store(log_b, 1 /* LOG_USER */, level,
    82					     dict, dictlen, fmt, args);
    83			va_end(args);
  > 84			wake_up_interruptible(&log_b->wait);
    85	
    86			raw_spin_unlock(&log_b->lock);
    87	
    88			ret = 0;
    89			break;
    90		}
    91		rcu_read_unlock();
    92		return ret;
    93	}
    94	
    95	static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
    96	{
    97		char *buf, *line;
    98		int i;
    99		int level = default_message_loglevel;
   100		int facility = 1;	/* LOG_USER */
   101		size_t len = iov_iter_count(from);
 > 102		char dict[KMSG_DICT_MAX_LEN];
   103		size_t dictlen;
   104		ssize_t ret = len;
   105		int minor = iminor(iocb->ki_filp->f_inode);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--IJpNTDwzlM2Ie8A6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--IJpNTDwzlM2Ie8A6--
