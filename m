From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 01/10] security: Override creds in __fput() with last fputter's creds [ver #3]
Date: Thu, 6 Jun 2019 07:57:27 -0700
Message-ID: <176F8189-3BE9-4B8C-A4D5-8915436338FB@amacapital.net>
References: <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <155981413016.17513.10540579988392555403.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155981413016.17513.10540579988392555403.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org



> On Jun 6, 2019, at 2:42 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> So that the LSM can see the credentials of the last process to do an fput(=
)
> on a file object when the file object is being dismantled, do the followin=
g
> steps:
>=20

I still maintain that this is a giant design error. Can someone at least com=
e up with a single valid use case that isn=E2=80=99t entirely full of bugs?=
