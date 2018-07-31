From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem
 information [ver #10]
Date: Tue, 31 Jul 2018 05:16:42 +0100
Message-ID: <20180731041642.GH30522@ZenIV.linux.org.uk>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 27, 2018 at 06:35:10PM +0100, David Howells wrote:
> params->request indicates the attribute/attributes to be queried.  This can
> be one of:
> 
> 	fsinfo_attr_statfs		- statfs-style info
> 	fsinfo_attr_fsinfo		- Information about fsinfo()
> 	fsinfo_attr_ids			- Filesystem IDs
> 	fsinfo_attr_limits		- Filesystem limits
> 	fsinfo_attr_supports		- What's supported in statx(), IOC flags
> 	fsinfo_attr_capabilities	- Filesystem capabilities
> 	fsinfo_attr_timestamp_info	- Inode timestamp info
> 	fsinfo_attr_volume_id		- Volume ID (string)
> 	fsinfo_attr_volume_uuid		- Volume UUID
> 	fsinfo_attr_volume_name		- Volume name (string)
> 	fsinfo_attr_cell_name		- Cell name (string)
> 	fsinfo_attr_domain_name		- Domain name (string)
> 	fsinfo_attr_realm_name		- Realm name (string)
> 	fsinfo_attr_server_name		- Name of the Nth server (string)
> 	fsinfo_attr_server_address	- Mth address of the Nth server
> 	fsinfo_attr_parameter		- Nth mount parameter (string)
> 	fsinfo_attr_source		- Nth mount source name (string)
> 	fsinfo_attr_name_encoding	- Filename encoding (string)
> 	fsinfo_attr_name_codepage	- Filename codepage (string)
> 	fsinfo_attr_io_size		- I/O size hints

Umm...  What's so special about cell/volume/domain/realm?  And
what do we do when a random filesystem gets added - should its
parameters go into catch-all pile (attr_parameter), or should they
get classes of their own?

For Cthulhu sake, who's going to maintain that enum in face of
random out-of-tree filesystems, each wanting a class or two its own?
We'd tried that with device numbers; ask hpa how well has that
worked and how much did he love the whole experience...
