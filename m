From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 07/11] UAPI: nilfs2: Fix use of undefined byteswapping
 functions
Date: Wed, 5 Sep 2018 23:20:05 +0100
Message-ID: <20180905222005.GS19965@ZenIV.linux.org.uk>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <153616292366.23468.14988166998690800938.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153616292366.23468.14988166998690800938.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 05, 2018 at 04:55:23PM +0100, David Howells wrote:
>  nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)		\
>  {									\
> -	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |		\
> +	cp->cp_flags = __cpu_to_le32(__le32_to_cpu(cp->cp_flags) |	\
>  				   (1UL << NILFS_CHECKPOINT_##flag));	\

How about sanitiziung the damn thing to
	cp->cp_flags |= __cpu_to_le32(1UL << NILFS_CHECKPOINT_##flag));

while you are at it?  Or, perhaps, even
#define NILFS2_CP_FLAG(flag) __cpu_to_le32(1UL << NILFS_CHECKPOINT_##flag)

and cp->cp_flags |= NILFS2_CP_FLAG(flag) for this one,

>  }									\
>  static inline void							\
>  nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)		\
>  {									\
> -	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) &		\
> +	cp->cp_flags = __cpu_to_le32(__le32_to_cpu(cp->cp_flags) &	\
>  				   ~(1UL << NILFS_CHECKPOINT_##flag));	\
	cp->cp_flags &= ~NILFS2_CP_FLAG(flag);
here

>  }									\
>  static inline int							\
>  nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
>  {									\
> -	return !!(le32_to_cpu(cp->cp_flags) &				\
> +	return !!(__le32_to_cpu(cp->cp_flags) &				\
>  		  (1UL << NILFS_CHECKPOINT_##flag));			\

and !!(cp->cp_flags & NILFS2_CP_FLAG(flag)
here?  Or maybe even make the damn thing bool and lose the !! here...

)>  }
>  

and similar for those:

> @@ -595,20 +596,20 @@ enum {
>  static inline void							\
>  nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)		\
>  {									\
> -	su->su_flags = cpu_to_le32(le32_to_cpu(su->su_flags) |		\
> +	su->su_flags = __cpu_to_le32(__le32_to_cpu(su->su_flags) |	\
>  				   (1UL << NILFS_SEGMENT_USAGE_##flag));\
>  }									\
>  static inline void							\
>  nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)	\
>  {									\
>  	su->su_flags =							\
> -		cpu_to_le32(le32_to_cpu(su->su_flags) &			\
> +		__cpu_to_le32(__le32_to_cpu(su->su_flags) &		\
>  			    ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
>  }									\
>  static inline int							\
>  nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
>  {									\
> -	return !!(le32_to_cpu(su->su_flags) &				\
> +	return !!(__le32_to_cpu(su->su_flags) &				\
>  		  (1UL << NILFS_SEGMENT_USAGE_##flag));			\
>  }



> @@ -619,15 +620,15 @@ NILFS_SEGMENT_USAGE_FNS(ERROR, error)
>  static inline void
>  nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
>  {
> -	su->su_lastmod = cpu_to_le64(0);
> -	su->su_nblocks = cpu_to_le32(0);
> -	su->su_flags = cpu_to_le32(0);
> +	su->su_lastmod = __cpu_to_le64(0);
> +	su->su_nblocks = __cpu_to_le32(0);
> +	su->su_flags = __cpu_to_le32(0);
>  }
>  
>  static inline int
>  nilfs_segment_usage_clean(const struct nilfs_segment_usage *su)
>  {
> -	return !le32_to_cpu(su->su_flags);
> +	return !__le32_to_cpu(su->su_flags);

"Check that after byteswap it becomes 0", is it?  How is that different
from return !su->su_flags; ?
