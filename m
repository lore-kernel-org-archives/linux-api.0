From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem
 information [ver #10]
Date: Fri, 27 Jul 2018 12:35:08 -0700
Message-ID: <CALCETrW6HQnGnnmzNrNAeEyRZZv9uJFcH92jjofR1Rx5NQTxDQ@mail.gmail.com>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 27, 2018 at 10:35 AM, David Howells <dhowells@redhat.com> wrote:
> Add a system call to allow filesystem information to be queried.  A request
> value can be given to indicate the desired attribute.  Support is provided
> for enumerating multi-value attributes.

Has anyone seriously reviewed this?  It might make sense to defer this
to a followup patch set.  Also:

> params->request indicates the attribute/attributes to be queried.  This can
> be one of:
>
>         fsinfo_attr_statfs              - statfs-style info
>         fsinfo_attr_fsinfo              - Information about fsinfo()

Constants are almost always all caps.  Is there any reason these are lowercase?
