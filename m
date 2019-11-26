From: Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH v26 12/12] LRNG - add interface for gathering of raw
 entropy (fwd)
Date: Tue, 26 Nov 2019 19:04:10 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911261903060.2605@hadrien>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-739979723-1574791451=:2605"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Stephan_M=FCller?= <smueller@chronox.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matth>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-739979723-1574791451=:2605
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

Hello,

Should something be done about the lock on line 162?

julia

---------- Forwarded message ----------
Date: Tue, 26 Nov 2019 01:12:49 +0800
From: kbuild test robot <lkp@intel.com>
To: kbuild@lists.01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v26 12/12] LRNG - add interface for gathering of raw entropy

In-Reply-To: <3742813.K7GG538zxB@positron.chronox.de>
References: <3742813.K7GG538zxB@positron.chronox.de>

Hi "Stephan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on v5.4 next-20191125]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Stephan-M-ller/dev-random-a-new-approach-with-full-SP800-90B/20191125-042152
base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git b78cda795ac83333293f1bfa3165572a47e550c2
:::::: branch date: 21 hours ago
:::::: commit date: 21 hours ago

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>

>> drivers/char/lrng/lrng_testing.c:176:1-7: preceding lock on line 134

# https://github.com/0day-ci/linux/commit/d69edb724ef2677392bfcbaf4fb6750306f8a1f1
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout d69edb724ef2677392bfcbaf4fb6750306f8a1f1
vim +176 drivers/char/lrng/lrng_testing.c

d69edb724ef267 Stephan Müller 2019-11-23  125
d69edb724ef267 Stephan Müller 2019-11-23  126  static int lrng_raw_entropy_reader(u8 *outbuf, u32 outbuflen)
d69edb724ef267 Stephan Müller 2019-11-23  127  {
d69edb724ef267 Stephan Müller 2019-11-23  128  	unsigned long flags;
d69edb724ef267 Stephan Müller 2019-11-23  129  	int collected_data = 0;
d69edb724ef267 Stephan Müller 2019-11-23  130
d69edb724ef267 Stephan Müller 2019-11-23  131  	lrng_raw_entropy_init();
d69edb724ef267 Stephan Müller 2019-11-23  132
d69edb724ef267 Stephan Müller 2019-11-23  133  	while (outbuflen) {
d69edb724ef267 Stephan Müller 2019-11-23 @134  		spin_lock_irqsave(&lrng_raw_lock, flags);
d69edb724ef267 Stephan Müller 2019-11-23  135
d69edb724ef267 Stephan Müller 2019-11-23  136  		/* We have no data or reached the writer. */
d69edb724ef267 Stephan Müller 2019-11-23  137  		if (!lrng_rb_writer || (lrng_rb_writer == lrng_rb_reader)) {
d69edb724ef267 Stephan Müller 2019-11-23  138
d69edb724ef267 Stephan Müller 2019-11-23  139  			spin_unlock_irqrestore(&lrng_raw_lock, flags);
d69edb724ef267 Stephan Müller 2019-11-23  140
d69edb724ef267 Stephan Müller 2019-11-23  141  			/*
d69edb724ef267 Stephan Müller 2019-11-23  142  			 * Now we gathered all boot data, enable regular data
d69edb724ef267 Stephan Müller 2019-11-23  143  			 * collection.
d69edb724ef267 Stephan Müller 2019-11-23  144  			 */
d69edb724ef267 Stephan Müller 2019-11-23  145  			if (boot_test) {
d69edb724ef267 Stephan Müller 2019-11-23  146  				boot_test = 0;
d69edb724ef267 Stephan Müller 2019-11-23  147  				goto out;
d69edb724ef267 Stephan Müller 2019-11-23  148  			}
d69edb724ef267 Stephan Müller 2019-11-23  149
d69edb724ef267 Stephan Müller 2019-11-23  150  			wait_event_interruptible(lrng_raw_read_wait,
d69edb724ef267 Stephan Müller 2019-11-23  151  						 lrng_raw_have_data());
d69edb724ef267 Stephan Müller 2019-11-23  152  			if (signal_pending(current)) {
d69edb724ef267 Stephan Müller 2019-11-23  153  				collected_data = -ERESTARTSYS;
d69edb724ef267 Stephan Müller 2019-11-23  154  				goto out;
d69edb724ef267 Stephan Müller 2019-11-23  155  			}
d69edb724ef267 Stephan Müller 2019-11-23  156
d69edb724ef267 Stephan Müller 2019-11-23  157  			continue;
d69edb724ef267 Stephan Müller 2019-11-23  158  		}
d69edb724ef267 Stephan Müller 2019-11-23  159
d69edb724ef267 Stephan Müller 2019-11-23  160  		/* We copy out word-wise */
d69edb724ef267 Stephan Müller 2019-11-23  161  		if (outbuflen < sizeof(u32))
d69edb724ef267 Stephan Müller 2019-11-23  162  			goto out;
d69edb724ef267 Stephan Müller 2019-11-23  163
d69edb724ef267 Stephan Müller 2019-11-23  164  		memcpy(outbuf, &lrng_testing_rb[lrng_rb_reader], sizeof(u32));
d69edb724ef267 Stephan Müller 2019-11-23  165  		lrng_rb_reader++;
d69edb724ef267 Stephan Müller 2019-11-23  166
d69edb724ef267 Stephan Müller 2019-11-23  167  		spin_unlock_irqrestore(&lrng_raw_lock, flags);
d69edb724ef267 Stephan Müller 2019-11-23  168
d69edb724ef267 Stephan Müller 2019-11-23  169  		outbuf += sizeof(u32);
d69edb724ef267 Stephan Müller 2019-11-23  170  		outbuflen -= sizeof(u32);
d69edb724ef267 Stephan Müller 2019-11-23  171  		collected_data += sizeof(u32);
d69edb724ef267 Stephan Müller 2019-11-23  172  	}
d69edb724ef267 Stephan Müller 2019-11-23  173
d69edb724ef267 Stephan Müller 2019-11-23  174  out:
d69edb724ef267 Stephan Müller 2019-11-23  175  	lrng_raw_entropy_fini();
d69edb724ef267 Stephan Müller 2019-11-23 @176  	return collected_data;
d69edb724ef267 Stephan Müller 2019-11-23  177  }
d69edb724ef267 Stephan Müller 2019-11-23  178

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
--8323329-739979723-1574791451=:2605--
