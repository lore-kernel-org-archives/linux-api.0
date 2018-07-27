From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem
 information [ver #10]
Date: Sat, 28 Jul 2018 01:14:40 +0200
Message-ID: <CAG48ez0SdSPkimsk-MW7oSQO-Y64X-LD4JXnuPsZXKuz=y1_Kg@mail.gmail.com>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 27, 2018 at 7:36 PM David Howells <dhowells@redhat.com> wrote:
>
> Add a system call to allow filesystem information to be queried.  A request
> value can be given to indicate the desired attribute.  Support is provided
> for enumerating multi-value attributes.
[...]
> +static int fsinfo_generic_ids(struct dentry *dentry,
> +                             struct fsinfo_ids *p)
> +{
[...]
> +       strcpy(p->f_fs_name, dentry->d_sb->s_type->name);

Can you use strlcpy() instead? From a quick look, I don't see anything
that actually limits the size of filesystem names, even though
everything in-kernel probably fits into the 16 bytes you've allocated
for the name.

[...]
> +static int fsinfo_generic_name_encoding(struct dentry *dentry, char *buf)
> +{
> +       static const char encoding[] = "utf8";
> +
> +       if (buf)
> +               memcpy(buf, encoding, sizeof(encoding) - 1);
> +       return sizeof(encoding) - 1;
> +}

Is this meant to be "encoding to be used by userspace" or "encoding of
on-disk filenames"? If the former: That's always utf8, right? Are
there any plans to create filesystems that behave differently? If the
latter: This is wrong for e.g. a vfat mount that uses a codepage,
right? Should the default in that case not be "I don't know"?
