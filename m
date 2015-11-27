From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] input: evdev: introduce new evdev interface
Date: Fri, 27 Nov 2015 18:37:26 +0800
Message-ID: <201511271854.bneqkdcS%fengguang.wu@intel.com>
References: <1448618432-32357-2-git-send-email-pingbo.wen@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448618432-32357-2-git-send-email-pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, y2038-oiO2AC+8nQse6UdIy6AN3A@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aksgarg1989-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, WEN Pingbo <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi WEN,

[auto build test ERROR on: input/next]
[also build test ERROR on: v4.4-rc2 next-20151127]

url:    https://github.com/0day-ci/linux/commits/WEN-Pingbo/introduce-new-evdev-interface-type/20151127-180438
base:   https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git next
config: i386-randconfig-s0-201547 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

Note: the linux-review/WEN-Pingbo/introduce-new-evdev-interface-type/20151127-180438 HEAD fc81990de5842e76f794f755e095e4c5e55f8caa builds fine.
      It only hurts bisectibility.

All error/warnings (new ones prefixed by >>):

   drivers/input/misc/uinput.c: In function 'uinput_inject_events':
>> drivers/input/misc/uinput.c:442:28: error: too few arguments to function 'input_event_size'
     if (count != 0 && count < input_event_size())
                               ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:84:22: note: declared here
    static inline size_t input_event_size(int if_type)
                         ^
   drivers/input/misc/uinput.c:445:17: error: too few arguments to function 'input_event_size'
     while (bytes + input_event_size() <= count) {
                    ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:84:22: note: declared here
    static inline size_t input_event_size(int if_type)
                         ^
>> drivers/input/misc/uinput.c:452:45: warning: passing argument 2 of 'input_event_from_user' from incompatible pointer type [-Wincompatible-pointer-types]
      if (input_event_from_user(buffer + bytes, &ev))
                                                ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:102:5: note: expected 'struct input_value *' but argument is of type 'struct input_event *'
    int input_event_from_user(const char __user *buffer,
        ^
>> drivers/input/misc/uinput.c:452:7: error: too few arguments to function 'input_event_from_user'
      if (input_event_from_user(buffer + bytes, &ev))
          ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:102:5: note: declared here
    int input_event_from_user(const char __user *buffer,
        ^
   drivers/input/misc/uinput.c:456:12: error: too few arguments to function 'input_event_size'
      bytes += input_event_size();
               ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:84:22: note: declared here
    static inline size_t input_event_size(int if_type)
                         ^
   drivers/input/misc/uinput.c: In function 'uinput_events_to_user':
   drivers/input/misc/uinput.c:508:16: error: too few arguments to function 'input_event_size'
     while (read + input_event_size() <= count &&
                   ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:84:22: note: declared here
    static inline size_t input_event_size(int if_type)
                         ^
>> drivers/input/misc/uinput.c:511:42: warning: passing argument 2 of 'input_event_to_user' from incompatible pointer type [-Wincompatible-pointer-types]
      if (input_event_to_user(buffer + read, &event))
                                             ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:105:5: note: expected 'const struct input_value *' but argument is of type 'struct input_event *'
    int input_event_to_user(char __user *buffer, const struct input_value *event,
        ^
>> drivers/input/misc/uinput.c:511:7: error: too few arguments to function 'input_event_to_user'
      if (input_event_to_user(buffer + read, &event))
          ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:105:5: note: declared here
    int input_event_to_user(char __user *buffer, const struct input_value *event,
        ^
   drivers/input/misc/uinput.c:514:11: error: too few arguments to function 'input_event_size'
      read += input_event_size();
              ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:84:22: note: declared here
    static inline size_t input_event_size(int if_type)
                         ^
   drivers/input/misc/uinput.c: In function 'uinput_read':
   drivers/input/misc/uinput.c:526:28: error: too few arguments to function 'input_event_size'
     if (count != 0 && count < input_event_size())
                               ^
   In file included from drivers/input/misc/uinput.c:43:0:
   drivers/input/misc/../input-compat.h:84:22: note: declared here
    static inline size_t input_event_size(int if_type)
                         ^

vim +/input_event_size +442 drivers/input/misc/uinput.c

cbf05413 Ryan Mallon     2013-09-18  436  static ssize_t uinput_inject_events(struct uinput_device *udev,
54ce165e Dmitry Torokhov 2012-07-29  437  				    const char __user *buffer, size_t count)
^1da177e Linus Torvalds  2005-04-16  438  {
^1da177e Linus Torvalds  2005-04-16  439  	struct input_event ev;
cbf05413 Ryan Mallon     2013-09-18  440  	size_t bytes = 0;
^1da177e Linus Torvalds  2005-04-16  441  
cbf05413 Ryan Mallon     2013-09-18 @442  	if (count != 0 && count < input_event_size())
29506415 Dmitry Torokhov 2005-11-20  443  		return -EINVAL;
29506415 Dmitry Torokhov 2005-11-20  444  
cbf05413 Ryan Mallon     2013-09-18 @445  	while (bytes + input_event_size() <= count) {
cbf05413 Ryan Mallon     2013-09-18  446  		/*
cbf05413 Ryan Mallon     2013-09-18  447  		 * Note that even if some events were fetched successfully
cbf05413 Ryan Mallon     2013-09-18  448  		 * we are still going to return EFAULT instead of partial
cbf05413 Ryan Mallon     2013-09-18  449  		 * count to let userspace know that it got it's buffers
cbf05413 Ryan Mallon     2013-09-18  450  		 * all wrong.
cbf05413 Ryan Mallon     2013-09-18  451  		 */
cbf05413 Ryan Mallon     2013-09-18 @452  		if (input_event_from_user(buffer + bytes, &ev))
^1da177e Linus Torvalds  2005-04-16  453  			return -EFAULT;
29506415 Dmitry Torokhov 2005-11-20  454  
^1da177e Linus Torvalds  2005-04-16  455  		input_event(udev->dev, ev.type, ev.code, ev.value);
cbf05413 Ryan Mallon     2013-09-18  456  		bytes += input_event_size();
cbf05413 Ryan Mallon     2013-09-18  457  	}
^1da177e Linus Torvalds  2005-04-16  458  
cbf05413 Ryan Mallon     2013-09-18  459  	return bytes;
29506415 Dmitry Torokhov 2005-11-20  460  }
29506415 Dmitry Torokhov 2005-11-20  461  
54ce165e Dmitry Torokhov 2012-07-29  462  static ssize_t uinput_write(struct file *file, const char __user *buffer,
54ce165e Dmitry Torokhov 2012-07-29  463  			    size_t count, loff_t *ppos)
29506415 Dmitry Torokhov 2005-11-20  464  {
29506415 Dmitry Torokhov 2005-11-20  465  	struct uinput_device *udev = file->private_data;
29506415 Dmitry Torokhov 2005-11-20  466  	int retval;
29506415 Dmitry Torokhov 2005-11-20  467  
22ae19c6 Dmitry Torokhov 2012-07-29  468  	if (count == 0)
22ae19c6 Dmitry Torokhov 2012-07-29  469  		return 0;
22ae19c6 Dmitry Torokhov 2012-07-29  470  
221979aa Dmitry Torokhov 2006-02-19  471  	retval = mutex_lock_interruptible(&udev->mutex);
29506415 Dmitry Torokhov 2005-11-20  472  	if (retval)
29506415 Dmitry Torokhov 2005-11-20  473  		return retval;
29506415 Dmitry Torokhov 2005-11-20  474  
29506415 Dmitry Torokhov 2005-11-20  475  	retval = udev->state == UIST_CREATED ?
cbf05413 Ryan Mallon     2013-09-18  476  			uinput_inject_events(udev, buffer, count) :
29506415 Dmitry Torokhov 2005-11-20  477  			uinput_setup_device(udev, buffer, count);
29506415 Dmitry Torokhov 2005-11-20  478  
221979aa Dmitry Torokhov 2006-02-19  479  	mutex_unlock(&udev->mutex);
29506415 Dmitry Torokhov 2005-11-20  480  
29506415 Dmitry Torokhov 2005-11-20  481  	return retval;
^1da177e Linus Torvalds  2005-04-16  482  }
^1da177e Linus Torvalds  2005-04-16  483  
929d1af5 Dmitry Torokhov 2012-07-29  484  static bool uinput_fetch_next_event(struct uinput_device *udev,
929d1af5 Dmitry Torokhov 2012-07-29  485  				    struct input_event *event)
929d1af5 Dmitry Torokhov 2012-07-29  486  {
929d1af5 Dmitry Torokhov 2012-07-29  487  	bool have_event;
929d1af5 Dmitry Torokhov 2012-07-29  488  
929d1af5 Dmitry Torokhov 2012-07-29  489  	spin_lock_irq(&udev->dev->event_lock);
929d1af5 Dmitry Torokhov 2012-07-29  490  
929d1af5 Dmitry Torokhov 2012-07-29  491  	have_event = udev->head != udev->tail;
929d1af5 Dmitry Torokhov 2012-07-29  492  	if (have_event) {
929d1af5 Dmitry Torokhov 2012-07-29  493  		*event = udev->buff[udev->tail];
929d1af5 Dmitry Torokhov 2012-07-29  494  		udev->tail = (udev->tail + 1) % UINPUT_BUFFER_SIZE;
929d1af5 Dmitry Torokhov 2012-07-29  495  	}
929d1af5 Dmitry Torokhov 2012-07-29  496  
929d1af5 Dmitry Torokhov 2012-07-29  497  	spin_unlock_irq(&udev->dev->event_lock);
929d1af5 Dmitry Torokhov 2012-07-29  498  
929d1af5 Dmitry Torokhov 2012-07-29  499  	return have_event;
929d1af5 Dmitry Torokhov 2012-07-29  500  }
929d1af5 Dmitry Torokhov 2012-07-29  501  
22ae19c6 Dmitry Torokhov 2012-07-29  502  static ssize_t uinput_events_to_user(struct uinput_device *udev,
22ae19c6 Dmitry Torokhov 2012-07-29  503  				     char __user *buffer, size_t count)
^1da177e Linus Torvalds  2005-04-16  504  {
929d1af5 Dmitry Torokhov 2012-07-29  505  	struct input_event event;
22ae19c6 Dmitry Torokhov 2012-07-29  506  	size_t read = 0;
^1da177e Linus Torvalds  2005-04-16  507  
22ae19c6 Dmitry Torokhov 2012-07-29 @508  	while (read + input_event_size() <= count &&
22ae19c6 Dmitry Torokhov 2012-07-29  509  	       uinput_fetch_next_event(udev, &event)) {
f40033ac David Herrmann  2012-07-29  510  
00ce756c Dmitry Torokhov 2012-07-29 @511  		if (input_event_to_user(buffer + read, &event))
00ce756c Dmitry Torokhov 2012-07-29  512  			return -EFAULT;
^1da177e Linus Torvalds  2005-04-16  513  
22ae19c6 Dmitry Torokhov 2012-07-29  514  		read += input_event_size();

:::::: The code at line 442 was first introduced by commit
:::::: cbf0541374e2fcfdfdcaf8365c957a137eb9feea Input: uinput - support injecting multiple events in one write() call

:::::: TO: Ryan Mallon <rmallon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
:::::: CC: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--u3/rZRmxL6MmkK24
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
vhN+RGGEpB9iK/8BV2KUZxoxAQA=

--u3/rZRmxL6MmkK24--
