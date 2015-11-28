From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v1 0/1] ioctl to disallow detaching kernel USB drivers
Date: Fri, 27 Nov 2015 18:39:25 -0800
Message-ID: <20151128023925.GA5177@kroah.com>
References: <1448466334-21346-1-git-send-email-emilio.lopez@collabora.co.uk>
 <5656CEA1.9010203@samsung.com>
 <20151126172914.GA8671@kroah.com>
 <565817FD.3090409@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <565817FD.3090409-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 27, 2015 at 09:44:45AM +0100, Krzysztof Opasiak wrote:
>=20
>=20
> On 11/26/2015 06:29 PM, Greg KH wrote:
> >On Thu, Nov 26, 2015 at 10:19:29AM +0100, Krzysztof Opasiak wrote:
> >>
> >>
> >>On 11/25/2015 04:45 PM, Emilio L=F3pez wrote:
> >>>Hi everyone,
> >>>
> >>>This patch introduces a new ioctl, USBDEVFS_DROP_PRIVILEGES,
> >>>to voluntarily forgo the ability to issue ioctls which may
> >>>interfere with other users of the USB device.
> >>>
> >>>This feature allows a privileged process (in the case of Chrome OS=
,
> >>>permission_broker) to open a USB device node and then drop a numbe=
r
> >>>of capabilities that are considered "privileged".
> >>
> >>We had the same idea in Tizen but for now we didn't have time to im=
plement
> >>it.
> >>
> >>  These privileges
> >>>include the ability to reset the device if there are other users
> >>>(most notably a kernel driver) or to disconnect a kernel driver
> >>>from the device. The file descriptor can then be passed to an
> >>>unprivileged process.
> >>
> >>And how about switching configuration? This can be also harmful eve=
n if the
> >>are no other users for any interface in this configuration.
> >>(Just imagine the situation in which only second config contains an=
 HID
> >>function and when app switch configuration it is activated without =
user
> >>knowing about this;))
> >
> >Adding this option might be nice.
> >
> >>>This is useful for granting a process access to a device with
> >>>multiple functions. It won't be able to use its access to one
> >>>function to disrupt or take over control of another function.
> >>
> >>I run through your code and as far as I understand above is not exa=
ctly
> >>true. Your patch allows only to prevent userspace from accessing in=
terfaces
> >>which has kernel drivers, there is no way to stop an application fr=
om taking
> >>control over all free interfaces.
> >>
> >>Let's say that your device has 3 interfaces. First of them has a ke=
rnel
> >>driver but second and third doesn't. You have 2 apps. One should co=
mmunicate
> >>using second interface and another one third. But first app is mali=
cious and
> >>it claims all free interfaces of received device (your patch doesn'=
t prevent
> >>this). And when second app starts it is unable to do anything with =
the
> >>device because all interfaces are taken. How would you like to hand=
le this?
> >
> >You can't, and why would you ever want to, as you can't tell what an=
 app
> >"should" or "should not" do.  If you really care about this, then us=
e a
> >LSM policy to prevent this.
>=20
> Well, an app can declare what it does and what it needs in it's manif=
est
> file (or some equivalent of this) and the platform should ensure that=
 app
> can do only what it has declared.

"should"?  Depending on what?  :)

> I would really like to use LSM policy in here but currently it is imp=
ossible
> as one device node represents whole device. Permissions (even those f=
rom
> LSM) are being checked only on open() not on each ioctl() so as far a=
s I
> know there is nothing which prevents any owner of opened fd to claim =
all
> available (not taken by someone else) interfaces and LSM policy is un=
able to
> filter those calls (unless we add some LSM hooks over there).

Yes, it's tough, I know, good luck.

Also deal with multiple devices, busses that are ordered differently
depending on the phase of the moon, and other fun things with dynamic
devices and ioctls.  It's a loosing battle :)

> >>Moreover I'm not convinced to this patch as it hardcodes the *polic=
y* in
> >>kernel code.
> >
> >What policy is that?
>=20
> It's a policy which defines set of ioctls which cannot be issued in
> "restricted mode".
>=20
> >
> >>Generally our approach (with passing fd from broker to
> >>unprivileged process) was similar but we found out that if we would=
 like to
> >>do this correctly there is much more things to filter than in this =
patch. We
> >>had two main ideas:
> >>
> >>- implement some LSM hooks in ioctls() but this leads to a lot of a=
dditional
> >>callbacks in lsm ops struct which even now is very big. But as a be=
nefit we
> >>would get a very flexible policy consistent with other system polic=
ies
> >>
> >>- split single usb device node into multiple files which could repr=
esent
> >>single endpoins only for io and separate control file for privilege=
d but
> >>it's quite a lot of work and I don't know if any one is going to ac=
cept such
> >>a change
> >
> >I've been asking for that for well over a decade, but no one ever di=
d
> >the work.  I think if you work through the options, it ends up not b=
eing
> >a viable solution...
> >
>=20
> I'm not surprised that no one ever did this as it looks like quite a =
lot of
> work and current interface is still working;) Do you have some link t=
o a
> discussion or sth which shows why it's not a good solution?

Dig through the archives, I think the last time this was brought up was
way before USB 3 came out.  As for "not a good solution", you have to
map endpoints together somehow in some way in userspace, which gets
messy fast, and then you would have to somehow modify all userspace
programs to use the new model.

Good luck!

greg k-h
