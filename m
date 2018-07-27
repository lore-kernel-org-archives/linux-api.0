From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem information [ver #10]
Date: Sat, 28 Jul 2018 00:51:44 +0100
Message-ID: <21746.1532735504@warthog.procyon.org.uk>
References: <21395.1532735340@warthog.procyon.org.uk> <CAG48ez0SdSPkimsk-MW7oSQO-Y64X-LD4JXnuPsZXKuz=y1_Kg@mail.gmail.com> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21395.1532735340@warthog.procyon.org.uk>
Content-ID: <21745.1532735504.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
Cc: dhowells@redhat.com, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> One thing I'm confused about is that fat has both a codepage and a charset and
> I'm not sure of the difference.

In fact, it's not clear that the codepage is actually used.

	warthog>git grep '[.>]codepage'
	fs/fat/inode.c: opts->codepage = fat_default_codepage;
	fs/fat/inode.c:                 opts->codepage = option;
	fs/fat/inode.c: sprintf(buf, "cp%d", sbi->options.codepage);

David
