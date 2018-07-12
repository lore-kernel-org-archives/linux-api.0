From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 22:26:37 +0100
Message-ID: <18233.1531430797@warthog.procyon.org.uk>
References: <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com> <16699.1531426991@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com>
Content-ID: <18232.1531430797.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The unix semantics are that credentials are checked at open time.

Sigh.

The problem is that there's more than one actual "open" involved.

	fd = fsopen("ext4");				<--- #1
	whatever_interface(fd, "s /dev/sda1");
	whatever_interface(fd, "o journal_path=/dev/sda2");
	do_the_create_thing(fd);			<--- #2 and #3

The initial check to see whether you can mount or not is done at #1.

But later there are two nested file opens.  Internally, deep down inside the
block layer, /dev/sda1 and /dev/sda2 are opened and further permissions checks
are done, whether you like it or not.  But these have no access to the creds
attached to fd as things currently stand.

So we have three choices:

 (1) Pass the creds from ->get_tree() all the way down into pathwalk and make
     sure *every* check that pathwalk does uses it.

 (2) When do_the_create_thing() is invoked, it wraps the call to ->get_tree()
     with override_creds(file->f_cred).

 (3) Forget using an fd to refer to the context.  fsopen() takes absolutely
     everything, perhaps as a kv array and spits out an O_PATH fd.  You don't
     get improved error reporting, you don't get a chance for interaction -
     say with the server, to construct an ID mapping table - and you don't get
     the chance to query the superblock before creating a mount.

     So, something like:

	struct fsopen_param {
		unsigned int type,
		const char *key;
		const void *val;
		unsigned int val_len;
	};

	mfd = fsopen(const char *fs_type,
		     unsigned int flags, /* CLOEXEC */
		     const struct fsopen_param *params,
		     unsigned int param_count,
		     unsigned int ms_flags /* eg. MNT_NOEXEC */);

     For example:

	struct fsopen_param params[] = {
		{ fsopen_source, "dev.fs", "/dev/sda1" }
		{ fsopen_source, "dev.journal", "/dev/sda2" }
		{ fsopen_option, "user_xattr" }
		{ fsopen_option, "data", "journal" }
		{ fsopen_option, "jqfmt", "vfsv1" }
		{ fsopen_security, "selinux.context", "unconfined_u..." }
	};

	mfd = fsopen("ext4", FSOPEN_CLOEXEC, params, ARRAY_SIZE(params),
		     MNT_NOEXEC);

     There would need to be an fsreconfig() also in a similar vein.

David
