From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/25] vfs: syscall: Add fsinfo() to query filesystem information [ver #13]
Date: Tue, 18 Jun 2019 23:24:25 +0100
Message-ID: <23583.1560896665@warthog.procyon.org.uk>
References: <CAJfpegtkpNNOOWQ3TnLPGSm=bwL2otQp1--GjNNFiXO7imMxEQ@mail.gmail.com> <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk> <155905627049.1662.17033721577309385838.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegtkpNNOOWQ3TnLPGSm=bwL2otQp1--GjNNFiXO7imMxEQ@mail.gmail.com>
Content-ID: <23582.1560896665.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Please don't resurrect MS_ flags.  They are from the old API and
> shouldn't be used in the new one.  Some of them (e.g. MS_POSIXACL,
> MS_I_VERSION) are actually internal flags despite being exported on
> the old API.

That makes it harder to emulate statfs() using this interface, but ok.

I wonder if I should split the standard parameters (rw/ro, posixacl, dirsync,
sync, lazytime, mand) out of FSINFO_ATTR_PARAMETERS and stick them in their
own attribute, say FSINFO_ATTR_STD_PARAMETERS.  That would make it easier for
a filesystem to only overload them if it wants to.

> And there's SB_SILENT which is simply not a superblock flag and we might be
> better getting rid of it entirely.

Yeah.  It's a parse-time flag.

> The proper way to query mount options should be analogous to the way
> they are set on the new API: list of {key, type, value, aux} tuples.

It's not quite that simple: "aux" might be a datum that you can't recover or
is meaningless to another process (an fd, for example).

David
