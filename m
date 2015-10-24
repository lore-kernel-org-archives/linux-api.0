From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v7] Input: Add userio module
Date: Sat, 24 Oct 2015 15:26:26 -0700
Message-ID: <20151024222626.GA18702@dtor-pixel>
References: <20151002173714.GA8437@dtor-ws>
 <1444060529-11164-1-git-send-email-cpaul@redhat.com>
 <CANq1E4RCwq49T=iR40NfQLtxKdLCoTLFQB2KA17ksqRyTB568w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANq1E4RCwq49T=iR40NfQLtxKdLCoTLFQB2KA17ksqRyTB568w@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Stephen Chandler Paul <cpaul@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 08, 2015 at 07:20:59PM +0200, David Herrmann wrote:
> On Mon, Oct 5, 2015 at 5:55 PM,  <cpaul@redhat.com> wrote:
> > +static int userio_char_release(struct inode *inode, struct file *file)
> > +{
> > +       struct userio_device *userio = file->private_data;
> > +
> > +       /* Don't free the serio port here, serio_unregister_port() does
> > +        * this for us */
> > +       if (userio->running)
> > +               serio_unregister_port(userio->serio);
> > +       else
> > +               kfree(userio->serio);
> > +
> > +       kfree(userio);
> 
> I'm not very familiar with the serio-subsystem, but is there a
> guarantee that .write() will not be called once unregistered? I can
> see that it's not scheduled by userio anymore, but maybe there's an
> async path that can trigger .write() callbacks. Dunno.. I'll leave
> that to Dmitry.

I think this is OK. When port is unregistered we the driver will be
disconnected from it, and is not supposed to call serio_write() anymore.
In fact, it should not access port after calling serio_close(). If it
keeps the pointer and uses it is a bug in the other driver; we can't
really do much about it.

Thanks.

-- 
Dmitry
