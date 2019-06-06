From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC][PATCH 00/10] Mount, FS, Block and Keyrings notifications [ver #3]
Date: Thu, 6 Jun 2019 15:42:06 -0700
Message-ID: <D2BD8FEB-5DF5-449B-AF81-83BA65E0E643@amacapital.net>
References: <AD7898AE-B92C-4DE6-B895-7116FEDB3091@amacapital.net> <CALCETrVuNRPgEzv-XY4M9m6sEsCiRHxPenN_MpcMYc1h26vVwQ@mail.gmail.com> <b91710d8-cd2d-6b93-8619-130b9d15983d@tycho.nsa.gov> <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <3813.1559827003@warthog.procyon.org.uk> <8382af23-548c-f162-0e82-11e308049735@tycho.nsa.gov> <0eb007c5-b4a0-9384-d915-37b0e5a158bf@schaufler-ca.com> <c82052e5-ca11-67b5-965e-8f828081f31c@tycho.nsa.gov> <07e92045-2d80-8573-4d36-643deeaff9ec@schaufler-ca.com> <23611.1559855827@warthog.procyon.org.uk> <30567.1559860681@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30567.1559860681@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org



> On Jun 6, 2019, at 3:38 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> Andy Lutomirski <luto@amacapital.net> wrote:
>=20
>> I mean: are there cases where some action generates a notification but do=
es
>> not otherwise have an effect visible to the users who can receive the
>> notification. It looks like the answer is probably =E2=80=9Cno=E2=80=9D, w=
hich is good.
>=20
> mount_notify().  You can get a notification that someone altered the mount=

> topology (eg. by mounting something).  A process receiving a notification
> could then use fsinfo(), say, to reread the mount topology tree, find out
> where the new mount is and wander over there to have a look - assuming the=
y
> have the permissions for pathwalk to succeed.
>=20
>=20

They can call fsinfo() anyway, or just read /proc/self/mounts. As far as I=E2=
=80=99m concerned, if you have CAP_SYS_ADMIN over a mount namespace and LSM p=
olicy lets you mount things, the of course you can get information to basica=
lly anyone who can use that mount namespace.=
