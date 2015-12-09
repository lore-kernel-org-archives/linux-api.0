From: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 2/4] test: firmware_class: add asynchronous request
 trigger
Date: Wed, 9 Dec 2015 13:48:43 -0800
Message-ID: <20151209214843.GA51175@google.com>
References: <1449628714-66641-1-git-send-email-computersforpeace@gmail.com>
 <1449628714-66641-2-git-send-email-computersforpeace@gmail.com>
 <CAGXu5jJ=JKN9FJzjonixhfNFZxgZ_y74cSkyG1DWPp3BS3VJ7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ=JKN9FJzjonixhfNFZxgZ_y74cSkyG1DWPp3BS3VJ7g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ming Lei <ming.lei@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-api@vger.kernel.org

Hi Kees,

On Wed, Dec 09, 2015 at 01:09:02PM -0800, Kees Cook wrote:
> On Tue, Dec 8, 2015 at 6:38 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
> > diff --git a/lib/test_firmware.c b/lib/test_firmware.c
> > index 841191061816..ba0a12d0301d 100644
> > --- a/lib/test_firmware.c
> > +++ b/lib/test_firmware.c
> > @@ -12,6 +12,7 @@
> >  #include <linux/init.h>
> >  #include <linux/module.h>
> >  #include <linux/printk.h>
> > +#include <linux/completion.h>
> >  #include <linux/firmware.h>
> >  #include <linux/device.h>
> >  #include <linux/fs.h>
> > @@ -81,6 +82,57 @@ out:
> >  }
> >  static DEVICE_ATTR_WO(trigger_request);
> >
> > +static DECLARE_COMPLETION(async_fw_done);
> > +
> > +static void trigger_async_request_cb(const struct firmware *fw, void *context)
> > +{
> > +       test_firmware = fw;
> > +       complete(&async_fw_done);
> > +}
> > +
> > +static ssize_t trigger_async_request_store(struct device *dev,
> > +                                          struct device_attribute *attr,
> > +                                          const char *buf, size_t count)
> > +{
> > +       int rc;
> > +       char *name;
> > +
> > +       name = kzalloc(count + 1, GFP_KERNEL);
> > +       if (!name)
> > +               return -ENOSPC;
> > +       memcpy(name, buf, count);
> 
> It strikes me that this (and the existing code) should use kstrndup
> instead, since the request_firmware* interfaces will ignore \0 bytes
> in the name:
> 
>     name = kstrndup(buf, count, GFP_KERNEL);
>     if (!name)
>         return -ENOSPC;

Thought of that at some point, then for some reason I didn't do it.
Probably laziness...

Will do in a v2, along with the more important fix below.

> > +
> > +       pr_info("loading '%s'\n", name);
> > +
> > +       mutex_lock(&test_fw_mutex);
> > +       release_firmware(test_firmware);
> > +       test_firmware = NULL;
> > +       rc = request_firmware_nowait(THIS_MODULE, 1, name, dev, GFP_KERNEL,
> > +                                    NULL, trigger_async_request_cb);
> > +       /* Free 'name' ASAP, to test for race conditions */
> > +       kfree(name);
> > +       if (rc) {
> > +               pr_info("async load of '%s' failed: %d\n", name, rc);
> 
> Well, that's a little TOO soon. :) The pr_info uses it still.

Haha, yeah... nice catch.

I was also thinking, since use-after-free isn't necessarily immediately
obvious (this worked fine in my testing), that maybe we could poison the
buffer before kfree()'ing? Like:

	name = ...;
	len = strlen(name);

	...

	rc = request_firmware_nowait(...);
	if (rc) {
		pr_info("...");
		kfree(name);
		goto out;
	}
	/*
	 * Clear out the name, to test for race conditions with the
	 * async request
	 */
	memset(name, 0, len);
	kfree(name);

> > +               goto out;
> > +       }
> > +
> > +       wait_for_completion(&async_fw_done);
> > +
> > +       if (test_firmware) {
> > +               pr_info("loaded: %zu\n", test_firmware->size);
> > +               rc = count;
> > +       } else {
> > +               pr_err("failed to async load firmware\n");
> > +               rc = -ENODEV;
> > +       }
> > +
> > +out:
> > +       mutex_unlock(&test_fw_mutex);
> > +
> > +       return rc;
> > +}
> > +static DEVICE_ATTR_WO(trigger_async_request);
> > +
> >  static int __init test_firmware_init(void)
> >  {
> >         int rc;
...

Brian
