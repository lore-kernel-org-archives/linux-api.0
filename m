From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1] usb: devio: Add ioctl to disallow detaching kernel
 USB drivers.
Date: Thu, 26 Nov 2015 12:20:14 +0300
Message-ID: <20151126092014.GD7289@mwanda>
References: <1448466334-21346-1-git-send-email-emilio.lopez@collabora.co.uk>
 <1448466334-21346-2-git-send-email-emilio.lopez@collabora.co.uk>
 <20151126085924.GD26397@shlinux2>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151126085924.GD26397@shlinux2>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Chen <peter.chen@freescale.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio.lopez@collabora.co.uk>, gregkh@linuxfoundation.org, stern@rowland.harvard.edu, kborer@gmail.com, reillyg@chromium.org, keescook@chromium.org, linux-api@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jorgelo@chromium.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 26, 2015 at 04:59:25PM +0800, Peter Chen wrote:
> On Wed, Nov 25, 2015 at 12:45:34PM -0300, Emilio L=F3pez wrote:
> > From: Reilly Grant <reillyg@chromium.org>
> >=20
> > The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntar=
ily
> > relinquish the ability to issue other ioctls that may interfere wit=
h
> > other processes and drivers that have claimed an interface on the
> > device.
> >=20
> > Signed-off-by: Reilly Grant <reillyg@chromium.org>
> > Reviewed-by: Jorge Lucangeli Obes <jorgelo@chromium.org>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > [emilio.lopez: fix build for v4.4-rc2 and adjust patch title prefix=
]
> > Signed-off-by: Emilio L=F3pez <emilio.lopez@collabora.co.uk>
> >=20
> > ---
> >=20
> >  drivers/usb/core/devio.c          | 50 +++++++++++++++++++++++++++=
++++++++----
> >  include/uapi/linux/usbdevice_fs.h |  1 +
> >  2 files changed, 47 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> > index 38ae877c..a5ccc50 100644
> > --- a/drivers/usb/core/devio.c
> > +++ b/drivers/usb/core/devio.c
> > @@ -77,6 +77,7 @@ struct usb_dev_state {
> >  	unsigned long ifclaimed;
> >  	u32 secid;
> >  	u32 disabled_bulk_eps;
> > +	bool privileges_dropped;
> >  };
> > =20
> >  struct async {
> > @@ -878,7 +879,7 @@ static int usbdev_open(struct inode *inode, str=
uct file *file)
> >  	int ret;
> > =20
> >  	ret =3D -ENOMEM;
> > -	ps =3D kmalloc(sizeof(struct usb_dev_state), GFP_KERNEL);
> > +	ps =3D kzalloc(sizeof(struct usb_dev_state), GFP_KERNEL);
> >  	if (!ps)
> >  		goto out_free_ps;
> > =20
> > @@ -911,11 +912,8 @@ static int usbdev_open(struct inode *inode, st=
ruct file *file)
> >  	INIT_LIST_HEAD(&ps->async_pending);
> >  	INIT_LIST_HEAD(&ps->async_completed);
> >  	init_waitqueue_head(&ps->wait);
> > -	ps->discsignr =3D 0;
> >  	ps->disc_pid =3D get_pid(task_pid(current));
> >  	ps->cred =3D get_current_cred();
> > -	ps->disccontext =3D NULL;
> > -	ps->ifclaimed =3D 0;
>=20
> The above changes seem to be not related with this change.
>=20

It is though.  They added a new struct member and thought that now it
was cleaner to use kzalloc() instead of initializing the new member to
zero.

> >  	security_task_getsecid(current, &ps->secid);
> >  	smp_wmb();
> >  	list_add_tail(&ps->list, &dev->filelist);
> > @@ -1215,6 +1213,35 @@ static int proc_connectinfo(struct usb_dev_s=
tate *ps, void __user *arg)
> > =20
> >  static int proc_resetdevice(struct usb_dev_state *ps)
> >  {
> > +	if (ps->privileges_dropped) {
> > +		struct usb_host_config *actconfig =3D ps->dev->actconfig;
> > +
> > +		/* Don't touch the device if any interfaces are claimed. It
> > +		 * could interfere with other drivers' operations and this
> > +		 * process has dropped its privileges to do such things.
> > +		 */
> > +		if (actconfig) {
> > +			int i;
> > +
> > +			for (i =3D 0; i < actconfig->desc.bNumInterfaces; ++i) {
> > +				if (usb_interface_claimed(
> > +					actconfig->interface[i])) {
> > +					dev_warn(&ps->dev->dev,
> > +						"usbfs: interface %d claimed by"
> > +						" %s while '%s'"
> > +						" resets device\n",
> > +						actconfig->interface[i]
> > +							->cur_altsetting
> > +							->desc.bInterfaceNumber,
>=20
> The length of line is 80 characters
>=20
> > +						actconfig->interface[i]
> > +							->dev.driver->name,
> > +						current->comm);
> > +					return -EACCES;
> > +				}
> > +			}
> > +		}
> > +	}

Yeah.  Better to flip this around:

static int proc_resetdevice(struct usb_dev_state *ps)
{
        struct usb_host_config *actconfig =3D ps->dev->actconfig;
        struct usb_interface *interface;
        int i;

        if (ps->privileges_dropped && actconfig) {
                for (i =3D 0; i < actconfig->desc.bNumInterfaces; ++i) =
{
                        interface =3D actconfig->interface[i];
                        if (usb_interface_claimed(interface)) {
                                dev_warn(&ps->dev->dev,
                                        "usbfs: interface %d claimed by=
 %s while '%s' resets device\n",
                                        interface->cur_altsetting->desc=
=2EbInterfaceNumber,
                                        interface->dev.driver->name,
                                        current->comm);
                                return -EACCES;
                        }
                }
        }

        return usb_reset_device(ps->dev);
}

It still goes over the 80 character limit, but that's cleaner than
breaking up the variable.

regards,
dan carpenter
