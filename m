From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats available [ver #3]
Date: Fri, 2 Jul 2010 09:49:52 -0600
Message-ID: <2DBA0FC9-192C-49F2-8DB5-F33090B1C221@dilger.ca>
References: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk> <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2010-07-01, at 23:36, Michael Kerrisk wrote:
> * Include information from the "inode_info" structure, most notably
> i_flags, but perhaps other info as well.

This one is actually pretty interesting, though instead of exporting the i_flags directly (the S_* flags), it would be much better to export the FS_*_FL values.  The FS_*_FL values (e.g. FS_IMMUTABLE_FL) are already exposed to userspace via FS_IOC_{GET,SET}FLAGS and are stored on disk in ext2/3/4, so are guaranteed never to change.  The S_* flags DO in fact change between kernel releases.


Cheers, Andreas





