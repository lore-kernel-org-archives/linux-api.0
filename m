From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats
	available [ver #3]
Date: Mon, 05 Jul 2010 15:59:49 +0100
Message-ID: <4859.1278341989@redhat.com>
References: <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com>
	<20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> * Include information from the "inode_info" structure, most notably
> i_flags, but perhaps other info as well.

This thought has occurred to me, but are the contents of i_flags identical for
all filesystems?  Certainly, i_flags doesn't seem to match the FS_IOC_GETFLAGS
mask.  For example:

	#define	FS_SECRM_FL			0x00000001

vs:

	#define S_SYNC		1	/* Writes are synced at once */

I've also been asked to provide st_flags as for BSD, which aren't compatible
either:-/.

Some questions:

 (1) Does it make sense to rearrange the S_xxxx flags to match the numbers for
     FS_xxxx_FL?

 (2) Does it make sense to do the BSD st_flags compatibility in userspace?

 (3) Can we add a couple more flags to make Samba's life easier?  Say an
     archived bit and a hidden bit?

 (4) Do I actually need to provide a mask saying what st_flags are applicable
     to the file you've just queried?

 (5) How often are these flags required?  E.g. does it make more sense to keep
     them as an additional result, or does it make sense to stick them in the
     kstat and xstat structs, knowing that these are allocated on the kernel
     stack maybe as three times if an ecryptfs file?

> * Return a bit mask indicating the presence of additional information
> associated with the i-node. Here, I am thinking of flags that indicate
> that the file has any of the following: capabilities, an ACL, and
> extended attributes (obviously a superset of the previous). I could
> imagine some apps that, having got the xstat info, would be interested
> to obtain some of this other info.
> 
> Obviously, the above only make sense if the overhead of providing the
> extra information is low.

That might make sense as an 'additional result'.  These things may have to be
probed for on disk or on a server, so you might not want to return them by
default, and you may want to indicate what the filesystem can support vs what
the file actually has:

	u64	st_fs_additional_info;	/* what the filesystem supports */
	u64	st_file_additional_info; /* what the file actually has */

	#define XST_ADDINFO_CAPABILITY_MASK
	#define XST_ADDINFO_ACL
	#define XST_ADDINFO_XATTRS
	#define XST_ADDINFO_SECLABEL

David
