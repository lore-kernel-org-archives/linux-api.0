From: Lyude <cpaul@redhat.com>
Subject: Re: [PATCH v6.2 1/1] Input: Add userio module
Date: Mon, 26 Oct 2015 09:51:57 -0400
Message-ID: <1445867517.3535.6.camel@redhat.com>
References: <1444053984.8404.1.camel@redhat.com>
	 <1445633266-14691-1-git-send-email-cpaul@redhat.com>
	 <20151024224012.GA13584@dtor-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151024224012.GA13584@dtor-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi! So, I'm guessing you want me to merge this with the patch I've got
right now and post the new version? (Just making sure since I'm a bit
new to this :)

On Sat, 2015-10-24 at 15:40 -0700, Dmitry Torokhov wrote:
> Hi Stephen,
> 
> On Fri, Oct 23, 2015 at 04:47:46PM -0400, cpaul@redhat.com wrote:
> > From: Stephen Chandler Paul <cpaul@redhat.com>
> > 
> > Debugging input devices, specifically laptop touchpads, can be
> > tricky
> > without having the physical device handy. Here we try to remedy
> > that
> > with userio. This module allows an application to connect to a
> > character
> > device provided by the kernel, and emulate any serio device. In
> > combination with userspace programs that can record PS/2 devices
> > and
> > replay them through the /dev/userio device, this allows developers
> > to
> > debug driver issues on the PS/2 level with devices simply by
> > requesting
> > a recording from the user experiencing the issue without having to
> > have
> > the physical hardware in front of them.
> > 
> > Signed-off-by: Stephen Chandler Paul <cpaul@redhat.com>
> > Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> > ---
> > 				    Changes
> > * Remove the if (!userio) { return -1; } check that somehow got
> > left in.
> > 
> > Sorry this took so long! I was wondering why you hadn't replied
> > yet, only to
> > notice I only made this change on my own tree and never sent out a
> > response
> > patch. Oops.
> 
> Thank you for making all the changes.
> 
> > +
> > +static ssize_t userio_char_read(struct file *file, char __user
> > *user_buffer,
> > +				size_t count, loff_t *ppos)
> > +{
> > +	struct userio_device *userio = file->private_data;
> > +	int ret;
> > +	size_t nonwrap_len, copylen;
> > +	unsigned char buf[USERIO_BUFSIZE];
> > +	unsigned long flags;
> > +
> > +	if (!count)
> > +		return 0;
> 
> This is not quite right: read of size 0 should still check if there
> is
> data in the buffer and return -EAGAIN for non-blocking descriptors.
> 
> I cooked a patch (below) that should adjust the read behavior (_+ a
> coupe of formatting changes), please take a look.
> 
> Thanks!
> 
-- 
Cheers,
	Lyude
