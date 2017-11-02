From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [patch v10 1/4] drivers: jtag: Add JTAG core driver (fwd)
Date: Thu, 2 Nov 2017 21:06:02 +0800 (CST)
Message-ID: <alpine.DEB.2.20.1711022104590.2165@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: linux-api@vger.kernel.org

It looks like the return on line 137 belongs after line 138.

julia

---------- Forwarded message ----------
Date: Thu, 2 Nov 2017 21:02:22 +0800
From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To: kbuild-JC7UmRfGjtg@public.gmane.org
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [patch v10 1/4] drivers: jtag: Add JTAG core driver

In-Reply-To: <1509365528-28803-2-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <1509365528-28803-2-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Oleksandr,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.14-rc7]
[cannot apply to next-20171102]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Oleksandr-Shamray/JTAG-driver-introduction/20171102-045624
:::::: branch date: 16 hours ago
:::::: commit date: 16 hours ago

>> drivers/jtag/jtag.c:142:16-25: ERROR: reference preceded by free on line 138

# https://github.com/0day-ci/linux/commit/1a7d120a0e3ba075879bc00ab136c4608f16a2a7
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 1a7d120a0e3ba075879bc00ab136c4608f16a2a7
vim +142 drivers/jtag/jtag.c

1a7d120a Oleksandr Shamray 2017-10-30   46
1a7d120a Oleksandr Shamray 2017-10-30   47  static long jtag_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
1a7d120a Oleksandr Shamray 2017-10-30   48  {
1a7d120a Oleksandr Shamray 2017-10-30   49  	struct jtag *jtag = file->private_data;
1a7d120a Oleksandr Shamray 2017-10-30   50  	struct jtag_run_test_idle idle;
1a7d120a Oleksandr Shamray 2017-10-30   51  	struct jtag_xfer xfer;
1a7d120a Oleksandr Shamray 2017-10-30   52  	u8 *xfer_data;
1a7d120a Oleksandr Shamray 2017-10-30   53  	u32 data_size;
1a7d120a Oleksandr Shamray 2017-10-30   54  	u32 value;
1a7d120a Oleksandr Shamray 2017-10-30   55  	int err;
1a7d120a Oleksandr Shamray 2017-10-30   56
1a7d120a Oleksandr Shamray 2017-10-30   57  	if (!arg)
1a7d120a Oleksandr Shamray 2017-10-30   58  		return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30   59
1a7d120a Oleksandr Shamray 2017-10-30   60  	switch (cmd) {
1a7d120a Oleksandr Shamray 2017-10-30   61  	case JTAG_GIOCFREQ:
1a7d120a Oleksandr Shamray 2017-10-30   62
1a7d120a Oleksandr Shamray 2017-10-30   63  		if (jtag->ops->freq_get)
1a7d120a Oleksandr Shamray 2017-10-30   64  			err = jtag->ops->freq_get(jtag, &value);
1a7d120a Oleksandr Shamray 2017-10-30   65  		else
1a7d120a Oleksandr Shamray 2017-10-30   66  			err = -EOPNOTSUPP;
1a7d120a Oleksandr Shamray 2017-10-30   67  		if (err)
1a7d120a Oleksandr Shamray 2017-10-30   68  			break;
1a7d120a Oleksandr Shamray 2017-10-30   69
1a7d120a Oleksandr Shamray 2017-10-30   70  		if (put_user(value, (__u32 *)arg))
1a7d120a Oleksandr Shamray 2017-10-30   71  			err = -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30   72  		break;
1a7d120a Oleksandr Shamray 2017-10-30   73
1a7d120a Oleksandr Shamray 2017-10-30   74  	case JTAG_SIOCFREQ:
1a7d120a Oleksandr Shamray 2017-10-30   75  		if (get_user(value, (__u32 *)arg))
1a7d120a Oleksandr Shamray 2017-10-30   76  			return -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30   77  		if (value == 0)
1a7d120a Oleksandr Shamray 2017-10-30   78  			return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30   79
1a7d120a Oleksandr Shamray 2017-10-30   80  		if (jtag->ops->freq_set)
1a7d120a Oleksandr Shamray 2017-10-30   81  			err = jtag->ops->freq_set(jtag, value);
1a7d120a Oleksandr Shamray 2017-10-30   82  		else
1a7d120a Oleksandr Shamray 2017-10-30   83  			err = -EOPNOTSUPP;
1a7d120a Oleksandr Shamray 2017-10-30   84  		break;
1a7d120a Oleksandr Shamray 2017-10-30   85
1a7d120a Oleksandr Shamray 2017-10-30   86  	case JTAG_IOCRUNTEST:
1a7d120a Oleksandr Shamray 2017-10-30   87  		if (copy_from_user(&idle, (void *)arg,
1a7d120a Oleksandr Shamray 2017-10-30   88  				   sizeof(struct jtag_run_test_idle)))
1a7d120a Oleksandr Shamray 2017-10-30   89  			return -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30   90
1a7d120a Oleksandr Shamray 2017-10-30   91  		if (idle.mode > JTAG_XFER_SW_MODE)
1a7d120a Oleksandr Shamray 2017-10-30   92  			return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30   93
1a7d120a Oleksandr Shamray 2017-10-30   94  		if (idle.endstate > JTAG_STATE_PAUSEDR)
1a7d120a Oleksandr Shamray 2017-10-30   95  			return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30   96
1a7d120a Oleksandr Shamray 2017-10-30   97  		if (jtag->ops->idle)
1a7d120a Oleksandr Shamray 2017-10-30   98  			err = jtag->ops->idle(jtag, &idle);
1a7d120a Oleksandr Shamray 2017-10-30   99  		else
1a7d120a Oleksandr Shamray 2017-10-30  100  			err = -EOPNOTSUPP;
1a7d120a Oleksandr Shamray 2017-10-30  101  		break;
1a7d120a Oleksandr Shamray 2017-10-30  102
1a7d120a Oleksandr Shamray 2017-10-30  103  	case JTAG_IOCXFER:
1a7d120a Oleksandr Shamray 2017-10-30  104  		if (copy_from_user(&xfer, (void *)arg,
1a7d120a Oleksandr Shamray 2017-10-30  105  				   sizeof(struct jtag_xfer)))
1a7d120a Oleksandr Shamray 2017-10-30  106  			return -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30  107
1a7d120a Oleksandr Shamray 2017-10-30  108  		if (xfer.length >= JTAG_MAX_XFER_DATA_LEN)
1a7d120a Oleksandr Shamray 2017-10-30  109  			return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30  110
1a7d120a Oleksandr Shamray 2017-10-30  111  		if (xfer.mode > JTAG_XFER_SW_MODE)
1a7d120a Oleksandr Shamray 2017-10-30  112  			return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30  113
1a7d120a Oleksandr Shamray 2017-10-30  114  		if (xfer.type > JTAG_SDR_XFER)
1a7d120a Oleksandr Shamray 2017-10-30  115  			return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30  116
1a7d120a Oleksandr Shamray 2017-10-30  117  		if (xfer.direction > JTAG_WRITE_XFER)
1a7d120a Oleksandr Shamray 2017-10-30  118  			return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30  119
1a7d120a Oleksandr Shamray 2017-10-30  120  		if (xfer.endstate > JTAG_STATE_PAUSEDR)
1a7d120a Oleksandr Shamray 2017-10-30  121  			return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30  122
1a7d120a Oleksandr Shamray 2017-10-30  123  		data_size = DIV_ROUND_UP(xfer.length, BITS_PER_BYTE);
1a7d120a Oleksandr Shamray 2017-10-30  124  		xfer_data = memdup_user(u64_to_user_ptr(xfer.tdio), data_size);
1a7d120a Oleksandr Shamray 2017-10-30  125
1a7d120a Oleksandr Shamray 2017-10-30  126  		if (!xfer_data)
1a7d120a Oleksandr Shamray 2017-10-30  127  			return -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30  128
1a7d120a Oleksandr Shamray 2017-10-30  129  		if (jtag->ops->xfer) {
1a7d120a Oleksandr Shamray 2017-10-30  130  			err = jtag->ops->xfer(jtag, &xfer, xfer_data);
1a7d120a Oleksandr Shamray 2017-10-30  131  		} else {
1a7d120a Oleksandr Shamray 2017-10-30  132  			kfree(xfer_data);
1a7d120a Oleksandr Shamray 2017-10-30  133  			return -EOPNOTSUPP;
1a7d120a Oleksandr Shamray 2017-10-30  134  		}
1a7d120a Oleksandr Shamray 2017-10-30  135
1a7d120a Oleksandr Shamray 2017-10-30  136  		if (err) {
1a7d120a Oleksandr Shamray 2017-10-30  137  			return -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30 @138  			kfree(xfer_data);
1a7d120a Oleksandr Shamray 2017-10-30  139  		}
1a7d120a Oleksandr Shamray 2017-10-30  140
1a7d120a Oleksandr Shamray 2017-10-30  141  		err = copy_to_user(u64_to_user_ptr(xfer.tdio),
1a7d120a Oleksandr Shamray 2017-10-30 @142  				   (void *)(xfer_data), data_size);
1a7d120a Oleksandr Shamray 2017-10-30  143
1a7d120a Oleksandr Shamray 2017-10-30  144  		if (err) {
1a7d120a Oleksandr Shamray 2017-10-30  145  			kfree(xfer_data);
1a7d120a Oleksandr Shamray 2017-10-30  146  			return -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30  147  		}
1a7d120a Oleksandr Shamray 2017-10-30  148
1a7d120a Oleksandr Shamray 2017-10-30  149  		kfree(xfer_data);
1a7d120a Oleksandr Shamray 2017-10-30  150  		if (copy_to_user((void *)arg, &xfer, sizeof(struct jtag_xfer)))
1a7d120a Oleksandr Shamray 2017-10-30  151  			return -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30  152  		break;
1a7d120a Oleksandr Shamray 2017-10-30  153
1a7d120a Oleksandr Shamray 2017-10-30  154  	case JTAG_GIOCSTATUS:
1a7d120a Oleksandr Shamray 2017-10-30  155  		if (jtag->ops->status_get)
1a7d120a Oleksandr Shamray 2017-10-30  156  			err = jtag->ops->status_get(jtag, &value);
1a7d120a Oleksandr Shamray 2017-10-30  157  		else
1a7d120a Oleksandr Shamray 2017-10-30  158  			err = -EOPNOTSUPP;
1a7d120a Oleksandr Shamray 2017-10-30  159  		if (err)
1a7d120a Oleksandr Shamray 2017-10-30  160  			break;
1a7d120a Oleksandr Shamray 2017-10-30  161
1a7d120a Oleksandr Shamray 2017-10-30  162  		err = put_user(value, (__u32 *)arg);
1a7d120a Oleksandr Shamray 2017-10-30  163  		if (err)
1a7d120a Oleksandr Shamray 2017-10-30  164  			err = -EFAULT;
1a7d120a Oleksandr Shamray 2017-10-30  165  		break;
1a7d120a Oleksandr Shamray 2017-10-30  166
1a7d120a Oleksandr Shamray 2017-10-30  167  	default:
1a7d120a Oleksandr Shamray 2017-10-30  168  		return -EINVAL;
1a7d120a Oleksandr Shamray 2017-10-30  169  	}
1a7d120a Oleksandr Shamray 2017-10-30  170  	return err;
1a7d120a Oleksandr Shamray 2017-10-30  171  }
1a7d120a Oleksandr Shamray 2017-10-30  172

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
