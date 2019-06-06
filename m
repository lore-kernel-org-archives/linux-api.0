From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC][PATCH 00/10] Mount, FS, Block and Keyrings notifications [ver #3]
Date: Thu, 6 Jun 2019 14:54:27 -0700
Message-ID: <AD7898AE-B92C-4DE6-B895-7116FEDB3091@amacapital.net>
References: <CALCETrVuNRPgEzv-XY4M9m6sEsCiRHxPenN_MpcMYc1h26vVwQ@mail.gmail.com> <b91710d8-cd2d-6b93-8619-130b9d15983d@tycho.nsa.gov> <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <3813.1559827003@warthog.procyon.org.uk> <8382af23-548c-f162-0e82-11e308049735@tycho.nsa.gov> <0eb007c5-b4a0-9384-d915-37b0e5a158bf@schaufler-ca.com> <c82052e5-ca11-67b5-965e-8f828081f31c@tycho.nsa.gov> <07e92045-2d80-8573-4d36-643deeaff9ec@schaufler-ca.com> <23611.1559855827@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <23611.1559855827@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org



> On Jun 6, 2019, at 2:17 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> Andy Lutomirski <luto@kernel.org> wrote:
>=20
>>>> You are allowing arbitrary information flow between T and W above.  Who=

>>>> cares about notifications?
>>>=20
>>> I do. If Watched object is /dev/null no data flow is possible.
>>> There are many objects on a modern Linux system for which this
>>> is true. Even if it's "just a file" the existence of one path
>>> for data to flow does not justify ignoring the rules for other
>>> data paths.
>>=20
>> Aha!
>>=20
>> Even ignoring security, writes to things like /dev/null should
>> probably not trigger notifications to people who are watching
>> /dev/null.  (There are probably lots of things like this: /dev/zero,
>> /dev/urandom, etc.)
>=20
> Even writes to /dev/null might generate access notifications; leastways,
> vfs_read() will call fsnotify_access() afterwards on success.

Hmm. I can see this being an issue, but I guess not with your patch set.

>=20
> Whether or not you can set marks on open device files is another matter.
>=20
>> David, are there any notification types that have this issue in your
>> patchset?  If so, is there a straightforward way to fix it?
>=20
> I'm not sure what issue you're referring to specifically.  Do you mean whe=
ther
> writes to device files generate notifications?

I mean: are there cases where some action generates a notification but does n=
ot otherwise have an effect visible to the users who can receive the notific=
ation. It looks like the answer is probably =E2=80=9Cno=E2=80=9D, which is g=
ood.

Casey, is this good enough for you, or is there still an issue?=
