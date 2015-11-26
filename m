From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 0/1] ioctl to disallow detaching kernel USB drivers
Date: Thu, 26 Nov 2015 09:29:14 -0800
Message-ID: <20151126172914.GA8671@kroah.com>
References: <1448466334-21346-1-git-send-email-emilio.lopez@collabora.co.uk>
 <5656CEA1.9010203@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5656CEA1.9010203@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio.lopez@collabora.co.uk>, stern@rowland.harvard.edu, kborer@gmail.com, reillyg@chromium.org, keescook@chromium.org, linux-api@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jorgelo@chromium.org, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org

On Thu, Nov 26, 2015 at 10:19:29AM +0100, Krzysztof Opasiak wrote:
>=20
>=20
> On 11/25/2015 04:45 PM, Emilio L=F3pez wrote:
> >Hi everyone,
> >
> >This patch introduces a new ioctl, USBDEVFS_DROP_PRIVILEGES,
> >to voluntarily forgo the ability to issue ioctls which may
> >interfere with other users of the USB device.
> >
> >This feature allows a privileged process (in the case of Chrome OS,
> >permission_broker) to open a USB device node and then drop a number
> >of capabilities that are considered "privileged".
>=20
> We had the same idea in Tizen but for now we didn't have time to impl=
ement
> it.
>=20
>  These privileges
> >include the ability to reset the device if there are other users
> >(most notably a kernel driver) or to disconnect a kernel driver
> >from the device. The file descriptor can then be passed to an
> >unprivileged process.
>=20
> And how about switching configuration? This can be also harmful even =
if the
> are no other users for any interface in this configuration.
> (Just imagine the situation in which only second config contains an H=
ID
> function and when app switch configuration it is activated without us=
er
> knowing about this;))

Adding this option might be nice.

> >This is useful for granting a process access to a device with
> >multiple functions. It won't be able to use its access to one
> >function to disrupt or take over control of another function.
>=20
> I run through your code and as far as I understand above is not exact=
ly
> true. Your patch allows only to prevent userspace from accessing inte=
rfaces
> which has kernel drivers, there is no way to stop an application from=
 taking
> control over all free interfaces.
>=20
> Let's say that your device has 3 interfaces. First of them has a kern=
el
> driver but second and third doesn't. You have 2 apps. One should comm=
unicate
> using second interface and another one third. But first app is malici=
ous and
> it claims all free interfaces of received device (your patch doesn't =
prevent
> this). And when second app starts it is unable to do anything with th=
e
> device because all interfaces are taken. How would you like to handle=
 this?

You can't, and why would you ever want to, as you can't tell what an ap=
p
"should" or "should not" do.  If you really care about this, then use a
LSM policy to prevent this.

> Moreover I'm not convinced to this patch as it hardcodes the *policy*=
 in
> kernel code.

What policy is that?

> Generally our approach (with passing fd from broker to
> unprivileged process) was similar but we found out that if we would l=
ike to
> do this correctly there is much more things to filter than in this pa=
tch. We
> had two main ideas:
>=20
> - implement some LSM hooks in ioctls() but this leads to a lot of add=
itional
> callbacks in lsm ops struct which even now is very big. But as a bene=
fit we
> would get a very flexible policy consistent with other system policie=
s
>=20
> - split single usb device node into multiple files which could repres=
ent
> single endpoins only for io and separate control file for privileged =
but
> it's quite a lot of work and I don't know if any one is going to acce=
pt such
> a change

I've been asking for that for well over a decade, but no one ever did
the work.  I think if you work through the options, it ends up not bein=
g
a viable solution...

thanks,

greg k-h
