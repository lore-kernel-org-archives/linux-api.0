From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v13 21/51] ext4: Add richacl feature flag
Date: Wed, 4 Nov 2015 03:43:31 +0100
Message-ID: <CAHc6FU4=aNhir7UJjr=Xh28aWB7sZ0xhaawpmHxeB33RzaMHug@mail.gmail.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-22-git-send-email-agruenba@redhat.com>
	<06282344-726E-49AD-936B-7BFF8F43B967@dilger.ca>
	<CAHc6FU46EuDQ0S9TPYuLosHvppsqcqOF_oxxgTFHr+uXj59Drg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <CAHc6FU46EuDQ0S9TPYuLosHvppsqcqOF_oxxgTFHr+uXj59Drg@mail.gmail.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 4, 2015 at 3:28 AM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
> It's the commit message that's misleading here, I'll fix it.

Commit message changed to:

    This feature flag selects richacl instead of POSIX ACL support on the
    filesystem.  When this feature is off, the "acl" and "noacl" mount options
    control whether POSIX ACLs are enabled.  When it is on, richacls are
    automatically enabled and using the "noacl" mount option leads to an error.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
