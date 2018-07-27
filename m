From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem information [ver #10]
Date: Fri, 27 Jul 2018 23:12:25 +0100
Message-ID: <9462.1532729545@warthog.procyon.org.uk>
References: <CALCETrW6HQnGnnmzNrNAeEyRZZv9uJFcH92jjofR1Rx5NQTxDQ@mail.gmail.com> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW6HQnGnnmzNrNAeEyRZZv9uJFcH92jjofR1Rx5NQTxDQ@mail.gmail.com>
Content-ID: <9461.1532729545.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> > Add a system call to allow filesystem information to be queried.  A request
> > value can be given to indicate the desired attribute.  Support is provided
> > for enumerating multi-value attributes.
> 
> Has anyone seriously reviewed this?

I don't know.  I've certainly posted it before.

> > params->request indicates the attribute/attributes to be queried.  This can
> > be one of:
> >
> >         fsinfo_attr_statfs              - statfs-style info
> >         fsinfo_attr_fsinfo              - Information about fsinfo()
> 
> Constants are almost always all caps.  Is there any reason these are
> lowercase?

It looks better IMO, particularly for enum constants.  I'm not sure if there
are any rules about this in system vs user definitions.

David
