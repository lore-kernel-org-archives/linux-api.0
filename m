From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v23 08/22] richacl: Compute maximum file masks from an acl
Date: Wed, 13 Jul 2016 14:34:31 +0200
Message-ID: <CAHc6FU5oeaCxgZPFeNSHDfSjnVKe9km14R4s5RoBhJXPaL7ymQ@mail.gmail.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-9-git-send-email-agruenba@redhat.com>
	<1467728537.3800.32.camel@redhat.com>
	<014101d1d6df$e059fd20$a10df760$@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <014101d1d6df$e059fd20$a10df760$@mindspring.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Frank Filz <ffilzlnx@mindspring.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@redhat.com>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-Id: linux-api@vger.kernel.org

Frank,

On Tue, Jul 5, 2016 at 7:08 PM, Frank Filz <ffilzlnx@mindspring.com> wrote:
>> > + * Note: functions like richacl_allowed_to_who(),
>> > +richacl_group_class_allowed(),
>> > + * and richacl_compute_max_masks() iterate through the entire acl in
>> > +reverse
>> > + * order as an optimization.
>> > + *
>> > + * In the standard algorithm, aces are considered in forward order.
>> > +When a
>> > + * process matches an ace, the permissions in the ace are either
>> > +allowed or
>> > + * denied depending on the ace type.  Once a permission has been
>> > +allowed or
>> > + * denied, it is no longer considered in further aces.
>> > + *
>> > + * By iterating through the acl in reverse order, we can compute the
>> > +same
>> > + * result without having to keep track of which permissions have been
>> > +allowed
>> > + * and denied already.
>> > + */
>> >
>>
>> Clever!
>
> Hmm, but does that result in examining the whole ACL for most access checks, at least for files where most of the accesses are by the owner, or a member of a specific group (with perhaps a ton of special case users added on the end)?

I don't understand -- what does this algorithm have to do with access checks?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
