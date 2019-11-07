From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 08/14] pipe: Allow buffers to be marked read-whole-or-error for notifications [ver #2]
Date: Thu, 07 Nov 2019 18:23:04 +0000
Message-ID: <4649.1573150984@warthog.procyon.org.uk>
References: <CALCETrWszYm9=-WEgSbhmGc3DYCvY6q3W4Lezm6YtKnGtRs_5g@mail.gmail.com> <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk> <157313379331.29677.5209561321495531328.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWszYm9=-WEgSbhmGc3DYCvY6q3W4Lezm6YtKnGtRs_5g@mail.gmail.com>
Content-ID: <4648.1573150984.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, USB list <linux-usb@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> > Allow a buffer to be marked such that read() must return the entire buf=
fer
> > in one go or return ENOBUFS.  Multiple buffers can be amalgamated into =
a
> > single read, but a short read will occur if the next "whole" buffer won=
't
> > fit.
> >
> > This is useful for watch queue notifications to make sure we don't spli=
t a
> > notification across multiple reads, especially given that we need to
> > fabricate an overrun record under some circumstances - and that isn't i=
n
> > the buffers.
>=20
> Hmm.  I'm not totally in love with introducing a new error code like
> this for read(), especially if it could affect the kind of pipe that
> is bound to a file in a filesystem.  But maybe it's not a problem.

EMSGSIZE might be better?

David
