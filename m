From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem information [ver #10]
Date: Tue, 31 Jul 2018 13:39:16 +0100
Message-ID: <1600.1533040756@warthog.procyon.org.uk>
References: <20180731041642.GH30522@ZenIV.linux.org.uk> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731041642.GH30522@ZenIV.linux.org.uk>
Content-ID: <1599.1533040756.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> Umm...  What's so special about cell/volume/domain/realm?

Nothing particularly.  But they're something various network filesystems might
find useful.  cell for AFS, domain for CIFS, realm for things that use
kerberos.

volume_id/uuid/name would be usable by ext4 too, for example.

> And what do we do when a random filesystem gets added - should its
> parameters go into catch-all pile (attr_parameter),

FSINFO_ATTR_PARAMETER is a way to enumerate the configuration parameters
passed to mount, as an alternative to parsing /proc/mounts.  So, for example,
afs has:

	enum afs_param {
		Opt_autocell,
		Opt_dyn,
		Opt_source,
		nr__afs_params
	};

	static const struct fs_parameter_spec afs_param_specs[nr__afs_params] = {
		[Opt_autocell]	= { fs_param_takes_no_value },
		[Opt_dyn]	= { fs_param_takes_no_value },
		[Opt_source]	= { fs_param_is_string },
	};

	static const struct constant_table afs_param_keys[] = {
		{ "autocell",	Opt_autocell },
		{ "dyn",	Opt_dyn },
		{ "source",	Opt_source },
	};

My thought is that calling fsinfo(..., "/some/afs/file", &params, ...) with:

	struct fsinfo_params params = {
		.request = FSINFO_ATTR_PARAMETER,
		.Nth	 = <parameter-number>,
	};

would get you back, for example:

	Nth	Result
	=======	==========================================
	0	"autocell" (or "" if not set)
	1	"dyn" (or "" if not set)
	2	"source=%#grand.central.org:root.cell."
	3+	-ENODATA (ie. there are no more)

where Nth corresponds to the parameter specified by
FSINFO_ATTR_PARAM_DESCRIPTION and Nth.

Now for some filesystems, cgroups-v1 for example, there are parameters beyond
the list (the subsystem name) and these can be listed after the predefined
parameters, eg.:

	Nth	Result
	=======	==========================================
	0	"all" or ""
	1	"clone_children" or ""
	2	"cpuset_v2_mode" or ""
	3	"name" or ""
	4	"none" or ""
	5	"noprefix" or ""
	6	"release_agent" or ""
	7	"xattr" or ""
	8	"<subsys0>" or ""
	9	"<subsys1>" or ""
	10	"<subsys2>" or ""
	...	-ENODATA

> or should they get classes of their own?

Yes.

> For Cthulhu sake, who's going to maintain that enum in face of
> random out-of-tree filesystems, each wanting a class or two its own?

They don't get their own numbers unless they're in-tree.  Full stop.  We have
the same issue with system calls and not-yet-upstream new syscalls.

Note that, as I have the code now, the "type" of return value for each
attribute must also be declared to the fsinfo() core, and the fsinfo core does
the copy to/from userspace.

> We'd tried that with device numbers; ask hpa how well has that
> worked and how much did he love the whole experience...

What would you do instead?  I would prefer to avoid using text strings as keys
because then I need a big lookup table, and possibly this gets devolved to
each filesystem to handle - which ends up even more of a mess because then
there's nothing to hold consistency.

David
