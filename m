From: Simon McVittie <simon.mcvittie@collabora.co.uk>
Subject: Re: Early comments on kdbus v2 (Re: [PATCH 00/12] Add kdbus implementation)
Date: Wed, 05 Nov 2014 17:02:21 +0000
Message-ID: <545A581D.9040706@collabora.co.uk>
References: <CALCETrVJHFzyjOjUhAjzsknm1VVnUcDU2i=Ymhpmy8q1Pef8PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVJHFzyjOjUhAjzsknm1VVnUcDU2i=Ymhpmy8q1Pef8PQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Daniel Mack <daniel@zonque.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, "alban.crequy" <alban.crequy@collabora.co.uk>, Javier Martinez Canillas <javier.martinez@collabora.co.uk>, Tom Gundersen <teg@jklm.no>
List-Id: linux-api@vger.kernel.org

On 05/11/14 15:56, Andy Lutomirski wrote:
>  - I tend to think that pid and tid should be separate.  They're
> really their own thing, and, as noted in all the perfectly valid
> dislike directed at SO_PEERCRED, they have extremely limited value.

Traditional D-Bus has GetConnectionUnixProcessID(), which is used by
several applications:
<http://codesearch.debian.net/search?q=GetConnectionUnixProcessID>,
<http://codesearch.debian.net/search?q=servicePid> (the latter is the Qt
binding).

I don't know what those applications use it for, or whether they're
doing it safely. CVE-2013-4288, CVE-2014-5033 seem potentially relevant.

In the same way that kernel people don't want to break userland, I don't
want to break existing D-Bus users; it would be a shame if kdbus omits
things that would let it replace traditional D-Bus.

>  - starttime should have a justification or be removed.

I think its justification is "detect pid reuse", although AIUI it
doesn't detect pid "reuse" via exec().

>  - KDBUS_ATTACH_AUXGROUPS: I'm not sure what to think about this.  I
> feel like it's only useful for implementing strange types of policies.

I think the intention is that it enables things like "processes with
group netdev may tell NetworkManager to reconfigure networking".
Traditional D-Bus half-supports this, but interacts poorly with things
like pam_groups that assign groups to processes, not uids.

>  - KDBUS_ATTACH_SECLABEL: The docs talk about selinux.  What does this
> even mean on a non-selinux system?

As far as I understand it, sockets have a generic mechanism for storing
one arbitrary security label alongside the uid, and the active LSM gets
to define its syntax and what it means. This is the equivalent of that.

Traditional D-Bus has GetConnectionSELinuxSecurityContext() which only
returns the SELinux context, and never any other LSM's
context/label/profile/whatever.
<http://codesearch.debian.net/search?q=GetConnectionSELinuxSecurityContext>
suggests that it has users; I don't know what they do with it, or
whether they're correct.

The intention was that each LSM with code in dbus-daemon will eventually
contribute a key/value pair to GetConnectionCredentials() rather than
having their own separate methods, with
GetConnectionSELinuxSecurityContext() deprecated, but that's blocked by
people who understand the LSMs contributing the necessary code and
documentation. (Incidentally, if anyone reading this can contribute
proper documentation of the SELinux context to the D-Bus Specification -
what is the preferred jargon term? what do a couple of typical values
look like? is it restricted to some limited character set? etc. - I
would be grateful for a patch.)

Of course, if kdbus ends up being what everyone uses for D-Bus on Linux,
then there will no longer be much point in adding Linux-specific
features to dbus-daemon.

> Otherwise we'll end up with two
> separate selinux policy databases -- the normal one and whatever dbus
> tries to do

Traditional D-Bus already has this problem: dbus-daemon has to work out
"what would SELinux do?" in userland, including the decision whether to
enforce or just complain, and do the same. My understanding is that one
of the more minor upsides of doing (this part of) D-Bus in the kernel is
that it would remove that intermediary, moving the security decisions to
a location where LSMs can allow/deny things directly.

    S
