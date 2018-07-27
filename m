From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem information [ver #10]
Date: Sat, 28 Jul 2018 00:49:00 +0100
Message-ID: <21395.1532735340@warthog.procyon.org.uk>
References: <CAG48ez0SdSPkimsk-MW7oSQO-Y64X-LD4JXnuPsZXKuz=y1_Kg@mail.gmail.com> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0SdSPkimsk-MW7oSQO-Y64X-LD4JXnuPsZXKuz=y1_Kg@mail.gmail.com>
Content-ID: <21394.1532735340.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> wrote:

> > +static int fsinfo_generic_name_encoding(struct dentry *dentry, char *buf)
> > +{
> > +       static const char encoding[] = "utf8";
> > +
> > +       if (buf)
> > +               memcpy(buf, encoding, sizeof(encoding) - 1);
> > +       return sizeof(encoding) - 1;
> > +}
> 
> Is this meant to be "encoding to be used by userspace" or "encoding of
> on-disk filenames"?

The latter.

> Are there any plans to create filesystems that behave differently?

isofs, fat, ntfs, cifs for example.

> If the latter: This is wrong for e.g. a vfat mount that uses a codepage,
> right?  Should the default in that case not be "I don't know"?

Quite possibly.  Note that it could also be what you're interpreting it as
because the codepage got overridden by a mount parameter rather than what's on
the disk (assuming the medium actually records this).

One thing I'm confused about is that fat has both a codepage and a charset and
I'm not sure of the difference.

David
