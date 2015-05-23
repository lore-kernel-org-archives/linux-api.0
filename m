From: Jeremy Allison <jra@samba.org>
Subject: Re: [RFC v3 00/45] Richacls
Date: Sat, 23 May 2015 08:50:56 -0700
Message-ID: <20150523155056.GA2845@jeremy-HP>
References: <cover.1429868795.git.agruenba@redhat.com>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <cover.1429868795.git.agruenba@redhat.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 01:03:57PM +0200, Andreas Gruenbacher wrote:
> Hello,
> 
> here's another update of the richacl patch queue.  The changes since the last
> posting (https://lwn.net/Articles/638242/) include:
> 
>  * The nfs client now allocates pages for received acls on demand like the
>    server does.  It no longer caches the acl size between calls.
> 
>  * All possible acls consisting of only owner@, group@, and everyone@ entries
>    which are equivalent to the file mode permission bits are now recognized.
>    This is needed because by the NFSv4 specification, the nfs server must
>    translate the file mode permission bits into an acl if it supports acls at
>    all.
> 
>  * Support for the dacl attribute over NFSv4.1 for Automatic Inheritance, and
>    also for the write_retention and write_retention_hold permissions.
> 
>  * The richacl_compute_max_masks() documentation has been improved.
> 
>  * Various minor bug fixes.
> 
> The git version is available here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
> 	richacl-2015-04-24

FYI. I have a mostly (needs test suite adding) working module
for Samba for Andreas's richacls code.

Using it we map incoming Windows ACLs directly to richacls
using the same mapping as we use for existing ZFS ACLs.

Jeremy.
