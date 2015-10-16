From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v11 16/48] richacl: Automatic Inheritance
Date: Fri, 16 Oct 2015 09:00:11 -0700
Message-ID: <CALCETrXFkB01tk21FuEOqABHWg1XyOQwsT+s=Lq0RYye6X_7xw@mail.gmail.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-17-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1445008706-15115-17-git-send-email-agruenba@redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 16, 2015 at 8:17 AM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> Automatic Inheritance (AI) allows changes to the acl of a directory to
> propagate down to children.
>
> This is mostly implemented in user space: when a process changes the
> permissions of a directory and Automatic Inheritance is enabled for that
> directory, the process must propagate those changes to all children,
> recursively.
>
> The kernel enables this by keeping track of which permissions have been
> inherited at create time.  In addition, it makes sure that permission
> propagation is turned off when the permissions are set explicitly (for
> example, upon create or chmod).
>
> Automatic Inheritance works as follows:
>
>  - When the RICHACL_AUTO_INHERIT flag in the acl of a file or directory
>    is not set, the file or directory is not affected by AI.
>
>  - When the RICHACL_AUTO_INHERIT flag in the acl of a directory is set
>    and a file or subdirectory is created in that directory, the
>    inherited acl will have the RICHACL_AUTO_INHERIT flag set, and all
>    inherited aces will have the RICHACE_INHERITED_ACE flag set.  This
>    allows user space to distinguish between aces which have been
>    inherited and aces which have been explicitly added.

What if the file or subdirectory that's created in that directory is a
hard link?

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
