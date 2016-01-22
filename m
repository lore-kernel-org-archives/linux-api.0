From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] quota: add new quotactl Q_GETNEXTQUOTA
Date: Fri, 22 Jan 2016 10:28:22 +0100
Message-ID: <20160122092822.GC16898@quack.suse.cz>
References: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
	<1453435644-32261-4-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1453435644-32261-4-git-send-email-sandeen@redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com
List-Id: linux-api@vger.kernel.org

On Thu 21-01-16 22:07:20, Eric Sandeen wrote:
> Q_GETNEXTQUOTA is exactly like Q_GETQUOTA, except that it
> will return quota information for the id equal to or greater
> than the id requested.  In other words, if the requested id has
> no quota, the command will return quota information for the
> next higher id which does have a quota set.  If no higher id
> has an active quota, -ESRCH is returned.
> 
> This allows filesystems to do efficient iteration in kernelspace,
> much like extN filesystems do in userspace when asked to report
> all active quotas.
> 
> This does require a new data structure for userspace, as the
> current structure does not include an ID for the returned quota
> information.
> 
> Today, Ext4 with a hidden quota inode requires getpwent-style
> iterations, and for systems which have i.e. LDAP backends,
> this can be very slow, or even impossible if iteration is not
> allowed in the configuration.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Same comments as for XFS version apply here. Furthermore:

> diff --git a/fs/quota/compat.c b/fs/quota/compat.c
> index fb1892f..80773a4 100644
> --- a/fs/quota/compat.c
> +++ b/fs/quota/compat.c
> @@ -19,6 +19,19 @@ struct compat_if_dqblk {
>  	compat_uint_t dqb_valid;
>  };
>  
> +struct compat_if_nextdqblk {
> +	compat_u64 dqb_bhardlimit;
> +	compat_u64 dqb_bsoftlimit;
> +	compat_u64 dqb_curspace;
> +	compat_u64 dqb_ihardlimit;
> +	compat_u64 dqb_isoftlimit;
> +	compat_u64 dqb_curinodes;
> +	compat_u64 dqb_btime;
> +	compat_u64 dqb_itime;
> +	compat_uint_t dqb_valid;
> +	compat_uint_t dqb_id;
> +};
> +

Is there a need for compat version of this structure? Everything is
naturally aligned and the size is a multiple of 8 bytes. But these things
keep surprising me... Added CC to linux-api in a hope that there's someone
who definitely knows.

On a side note when I have API people attention: AFAIU we need
struct compat_if_dqblk (defined in fs/quota/compat.c) because its size is
not multiple of 8 bytes, right? But what is then then reason for get_user()
/ put_user() when the structure is copied into userspace (see below)?
copy_in_user() should have copied everything...

               if (copy_in_user(compat_dqblk, dqblk, sizeof(*compat_dqblk)) ||
                        get_user(data, &dqblk->dqb_valid) ||
                        put_user(data, &compat_dqblk->dqb_valid))
                        ret = -EFAULT;


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
