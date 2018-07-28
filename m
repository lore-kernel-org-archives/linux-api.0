From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem information [ver #10]
Date: Sat, 28 Jul 2018 01:08:56 +0100
Message-ID: <24079.1532736536@warthog.procyon.org.uk>
References: <CAG48ez3vVEEbJzbK8Nc6HA-W7Sp7==ZXanzFUKo527p4U=OFpA@mail.gmail.com> <CAG48ez0SdSPkimsk-MW7oSQO-Y64X-LD4JXnuPsZXKuz=y1_Kg@mail.gmail.com> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk> <21395.1532735340@warthog.procyon.org.uk> <21746.1532735504@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3vVEEbJzbK8Nc6HA-W7Sp7==ZXanzFUKo527p4U=OFpA@mail.gmail.com>
Content-ID: <24078.1532736536.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> wrote:

> >         fs/fat/inode.c: sprintf(buf, "cp%d", sbi->options.codepage);
> 
>         sprintf(buf, "cp%d", sbi->options.codepage);
>         sbi->nls_disk = load_nls(buf);
>         if (!sbi->nls_disk) {
>                 fat_msg(sb, KERN_ERR, "codepage %s not found", buf);
>                 goto out_fail;
>         }

Sorry, yes.  I was reading the print as the part of the display of superblock
parameters.

David
