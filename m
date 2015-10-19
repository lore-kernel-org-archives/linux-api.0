From: kbuild test robot <lkp@intel.com>
Subject: Re: [RFC v3 1/9] printk: extract kmsg-related routines from printk.c
 to kmsg.c
Date: Mon, 19 Oct 2015 21:53:19 +0800
Message-ID: <201510192110.9FsDZdog%fengguang.wu@intel.com>
References: <1445259503-18158-2-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445259503-18158-2-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paul,

[auto build test ERROR on next-20151016 -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Paul-Osmialowski/Additional-kmsg-devices/20151019-211509
config: x86_64-allnoconfig (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All error/warnings (new ones prefixed by >>):

   In file included from kernel/printk/printk.c:50:0:
>> kernel/printk/printk.h:195:1: error: expected identifier or '(' before '{' token
    {
    ^
>> kernel/printk/printk.c:1541:0: warning: "LOG_LINE_MAX" redefined
    #define LOG_LINE_MAX  0
    ^
   In file included from kernel/printk/printk.c:50:0:
   kernel/printk/printk.h:10:0: note: this is the location of the previous definition
    #define LOG_LINE_MAX  (1024 - PREFIX_MAX)
    ^
>> kernel/printk/printk.c:1542:0: warning: "PREFIX_MAX" redefined
    #define PREFIX_MAX  0
    ^
   In file included from kernel/printk/printk.c:50:0:
   kernel/printk/printk.h:9:0: note: this is the location of the previous definition
    #define PREFIX_MAX  32
    ^
>> kernel/printk/printk.h:192:22: warning: 'msg_print_text' used but never defined
    static inline size_t msg_print_text(const struct printk_log *msg,
                         ^

vim +195 kernel/printk/printk.h

     3	
     4	#include <linux/printk.h>
     5	#include <linux/spinlock_types.h>
     6	#include <linux/types.h>
     7	#include <linux/wait.h>
     8	
   > 9	#define PREFIX_MAX		32
    10	#define LOG_LINE_MAX		(1024 - PREFIX_MAX)
    11	
    12	/*
    13	 * The printk log buffer consists of a chain of concatenated variable
    14	 * length records. Every record starts with a record header, containing
    15	 * the overall length of the record.
    16	 *
    17	 * The heads to the first and last entry in the buffer, as well as the
    18	 * sequence numbers of these entries are maintained when messages are
    19	 * stored.
    20	 *
    21	 * If the heads indicate available messages, the length in the header
    22	 * tells the start next message. A length == 0 for the next message
    23	 * indicates a wrap-around to the beginning of the buffer.
    24	 *
    25	 * Every record carries the monotonic timestamp in microseconds, as well as
    26	 * the standard userspace syslog level and syslog facility. The usual
    27	 * kernel messages use LOG_KERN; userspace-injected messages always carry
    28	 * a matching syslog facility, by default LOG_USER. The origin of every
    29	 * message can be reliably determined that way.
    30	 *
    31	 * The human readable log message directly follows the message header. The
    32	 * length of the message text is stored in the header, the stored message
    33	 * is not terminated.
    34	 *
    35	 * Optionally, a message can carry a dictionary of properties (key/value pairs),
    36	 * to provide userspace with a machine-readable message context.
    37	 *
    38	 * Examples for well-defined, commonly used property names are:
    39	 *   DEVICE=b12:8               device identifier
    40	 *                                b12:8         block dev_t
    41	 *                                c127:3        char dev_t
    42	 *                                n8            netdev ifindex
    43	 *                                +sound:card0  subsystem:devname
    44	 *   SUBSYSTEM=pci              driver-core subsystem name
    45	 *
    46	 * Valid characters in property names are [a-zA-Z0-9.-_]. The plain text value
    47	 * follows directly after a '=' character. Every property is terminated by
    48	 * a '\0' character. The last property is not terminated.
    49	 *
    50	 * Example of a message structure:
    51	 *   0000  ff 8f 00 00 00 00 00 00      monotonic time in nsec
    52	 *   0008  34 00                        record is 52 bytes long
    53	 *   000a        0b 00                  text is 11 bytes long
    54	 *   000c              1f 00            dictionary is 23 bytes long
    55	 *   000e                    03 00      LOG_KERN (facility) LOG_ERR (level)
    56	 *   0010  69 74 27 73 20 61 20 6c      "it's a l"
    57	 *         69 6e 65                     "ine"
    58	 *   001b           44 45 56 49 43      "DEVIC"
    59	 *         45 3d 62 38 3a 32 00 44      "E=b8:2\0D"
    60	 *         52 49 56 45 52 3d 62 75      "RIVER=bu"
    61	 *         67                           "g"
    62	 *   0032     00 00 00                  padding to next message header
    63	 *
    64	 * The 'struct printk_log' buffer header must never be directly exported to
    65	 * userspace, it is a kernel-private implementation detail that might
    66	 * need to be changed in the future, when the requirements change.
    67	 *
    68	 * /dev/kmsg exports the structured data in the following line format:
    69	 *   "<level>,<sequnum>,<tstamp>,<contflag>[,additional_vals, ... ];<msg txt>\n"
    70	 *
    71	 * Users of the export format should ignore possible additional values
    72	 * separated by ',', and find the message after the ';' character.
    73	 *
    74	 * The optional key/value pairs are attached as continuation lines starting
    75	 * with a space character and terminated by a newline. All possible
    76	 * non-prinatable characters are escaped in the "\xff" notation.
    77	 */
    78	
    79	enum log_flags {
    80		LOG_NOCONS	= 1,	/* already flushed, do not print to console */
    81		LOG_NEWLINE	= 2,	/* text ended with a newline */
    82		LOG_PREFIX	= 4,	/* text started with a prefix */
    83		LOG_CONT	= 8,	/* text is a fragment of a continuation line */
    84	};
    85	
    86	struct printk_log {
    87		u64 ts_nsec;		/* timestamp in nanoseconds */
    88		u16 len;		/* length of entire record */
    89		u16 text_len;		/* length of text buffer */
    90		u16 dict_len;		/* length of dictionary buffer */
    91		u8 facility;		/* syslog facility */
    92		u8 flags:5;		/* internal record flags */
    93		u8 level:3;		/* syslog level */
    94	};
    95	
    96	/*
    97	 * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
    98	 * within the scheduler's rq lock. It must be released before calling
    99	 * console_unlock() or anything else that might wake up a process.
   100	 */
   101	extern raw_spinlock_t logbuf_lock;
   102	
   103	#ifdef CONFIG_PRINTK
   104	
   105	extern wait_queue_head_t log_wait;
   106	
   107	/* index and sequence number of the first record stored in the buffer */
   108	extern u64 log_first_seq;
   109	extern u32 log_first_idx;
   110	
   111	/* index and sequence number of the next record to store in the buffer */
   112	extern u64 log_next_seq;
   113	extern u32 log_next_idx;
   114	
   115	/* the next printk record to read after the last 'clear' command */
   116	extern u64 clear_seq;
   117	extern u32 clear_idx;
   118	
   119	ssize_t msg_print_ext_header(char *buf, size_t size,
   120					    struct printk_log *msg, u64 seq,
   121					    enum log_flags prev_flags);
   122	
   123	ssize_t msg_print_ext_body(char *buf, size_t size,
   124					  char *dict, size_t dict_len,
   125					  char *text, size_t text_len);
   126	
   127	size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
   128				bool syslog, char *buf, size_t size);
   129	
   130	/* get next record; idx must point to valid msg */
   131	static inline u32 log_next(u32 idx)
   132	{
   133		char *log_buf = log_buf_addr_get();
   134		struct printk_log *msg = (struct printk_log *)(log_buf + idx);
   135	
   136		/* length == 0 indicates the end of the buffer; wrap */
   137		/*
   138		 * A length == 0 record is the end of buffer marker. Wrap around and
   139		 * read the message at the start of the buffer as *this* one, and
   140		 * return the one after that.
   141		 */
   142		if (!msg->len) {
   143			msg = (struct printk_log *)log_buf;
   144			return msg->len;
   145		}
   146		return idx + msg->len;
   147	}
   148	
   149	/* get record by index; idx must point to valid msg */
   150	static inline struct printk_log *log_from_idx(u32 idx)
   151	{
   152		char *log_buf = log_buf_addr_get();
   153		struct printk_log *msg = (struct printk_log *)(log_buf + idx);
   154	
   155		/*
   156		 * A length == 0 record is the end of buffer marker. Wrap around and
   157		 * read the message at the start of the buffer.
   158		 */
   159		if (!msg->len)
   160			return (struct printk_log *)log_buf;
   161		return msg;
   162	}
   163	
   164	/* human readable text of the record */
   165	static inline char *log_text(const struct printk_log *msg)
   166	{
   167		return (char *)msg + sizeof(struct printk_log);
   168	}
   169	
   170	/* optional key/value pair dictionary attached to the record */
   171	static inline char *log_dict(const struct printk_log *msg)
   172	{
   173		return (char *)msg + sizeof(struct printk_log) + msg->text_len;
   174	}
   175	
   176	#else
   177	
   178	static inline ssize_t msg_print_ext_header(char *buf, size_t size,
   179						    struct printk_log *msg, u64 seq,
   180						    enum log_flags prev_flags)
   181	{
   182		return 0;
   183	}
   184	
   185	static inline ssize_t msg_print_ext_body(char *buf, size_t size,
   186						  char *dict, size_t dict_len,
   187						  char *text, size_t text_len)
   188	{
   189		return 0;
   190	}
   191	
 > 192	static inline size_t msg_print_text(const struct printk_log *msg,
   193					    enum log_flags prev, bool syslog, char *buf,
   194					    size_t size);
 > 195	{
   196		return 0;
   197	}
   198	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--/04w6evG8XlLl3ft
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
VgAA

--/04w6evG8XlLl3ft--
