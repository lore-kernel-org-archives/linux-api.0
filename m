From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH ghak90 V5 08/10] audit: add containerid filtering
Date: Mon, 18 Mar 2019 16:39:07 -0400
Message-ID: <20190318203907.GE4111@hmswarspite.think-freely.org>
References: <cover.1552665316.git.rgb@redhat.com>
 <3f02f7b56d2fba2918ff6fe90fcfa3ae558faff8.1552665316.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3f02f7b56d2fba2918ff6fe90fcfa3ae558faff8.1552665316.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 02:29:56PM -0400, Richard Guy Briggs wrote:
> Implement audit container identifier filtering using the AUDIT_CONTID
> field name to send an 8-character string representing a u64 since the
> value field is only u32.
> 
> Sending it as two u32 was considered, but gathering and comparing two
> fields was more complex.
> 
> The feature indicator is AUDIT_FEATURE_BITMAP_CONTAINERID.
> 
> See: https://github.com/linux-audit/audit-kernel/issues/91
> See: https://github.com/linux-audit/audit-userspace/issues/40
> See: https://github.com/linux-audit/audit-testsuite/issues/64
> See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> ---
>  include/linux/audit.h      |  1 +
>  include/uapi/linux/audit.h |  5 ++++-
>  kernel/audit.h             |  1 +
>  kernel/auditfilter.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/auditsc.c           |  3 +++
>  5 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 6db5aba7cc01..fa19fa408931 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -77,6 +77,7 @@ struct audit_field {
>  	u32				type;
>  	union {
>  		u32			val;
> +		u64			val64;
>  		kuid_t			uid;
>  		kgid_t			gid;
>  		struct {
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index a6383e28b2c8..741ab6f38294 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -265,6 +265,7 @@
>  #define AUDIT_LOGINUID_SET	24
>  #define AUDIT_SESSIONID	25	/* Session ID */
>  #define AUDIT_FSTYPE	26	/* FileSystem Type */
> +#define AUDIT_CONTID	27	/* Container ID */
>  
>  				/* These are ONLY useful when checking
>  				 * at syscall exit time (AUDIT_AT_EXIT). */
> @@ -345,6 +346,7 @@ enum {
>  #define AUDIT_FEATURE_BITMAP_SESSIONID_FILTER	0x00000010
>  #define AUDIT_FEATURE_BITMAP_LOST_RESET		0x00000020
>  #define AUDIT_FEATURE_BITMAP_FILTER_FS		0x00000040
> +#define AUDIT_FEATURE_BITMAP_CONTAINERID	0x00000080
>  
>  #define AUDIT_FEATURE_BITMAP_ALL (AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT | \
>  				  AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME | \
> @@ -352,7 +354,8 @@ enum {
>  				  AUDIT_FEATURE_BITMAP_EXCLUDE_EXTEND | \
>  				  AUDIT_FEATURE_BITMAP_SESSIONID_FILTER | \
>  				  AUDIT_FEATURE_BITMAP_LOST_RESET | \
> -				  AUDIT_FEATURE_BITMAP_FILTER_FS)
> +				  AUDIT_FEATURE_BITMAP_FILTER_FS | \
> +				  AUDIT_FEATURE_BITMAP_CONTAINERID)
>  
>  /* deprecated: AUDIT_VERSION_* */
>  #define AUDIT_VERSION_LATEST 		AUDIT_FEATURE_BITMAP_ALL
> diff --git a/kernel/audit.h b/kernel/audit.h
> index 2a1a8b8a8019..3a40b608bf8d 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -230,6 +230,7 @@ static inline int audit_hash_ino(u32 ino)
>  
>  extern int audit_match_class(int class, unsigned syscall);
>  extern int audit_comparator(const u32 left, const u32 op, const u32 right);
> +extern int audit_comparator64(const u64 left, const u32 op, const u64 right);
>  extern int audit_uid_comparator(kuid_t left, u32 op, kuid_t right);
>  extern int audit_gid_comparator(kgid_t left, u32 op, kgid_t right);
>  extern int parent_len(const char *path);
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index add360b46b38..516b8e58959e 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -410,6 +410,7 @@ static int audit_field_valid(struct audit_entry *entry, struct audit_field *f)
>  	/* FALL THROUGH */
>  	case AUDIT_ARCH:
>  	case AUDIT_FSTYPE:
> +	case AUDIT_CONTID:
>  		if (f->op != Audit_not_equal && f->op != Audit_equal)
>  			return -EINVAL;
>  		break;
> @@ -582,6 +583,14 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
>  			}
>  			entry->rule.exe = audit_mark;
>  			break;
> +		case AUDIT_CONTID:
> +			if (f->val != sizeof(u64))
> +				goto exit_free;
> +			str = audit_unpack_string(&bufp, &remain, f->val);
> +			if (IS_ERR(str))
> +				goto exit_free;
> +			f->val64 = ((u64 *)str)[0];
> +			break;
>  		}
>  	}
>  
> @@ -664,6 +673,11 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
>  			data->buflen += data->values[i] =
>  				audit_pack_string(&bufp, audit_mark_path(krule->exe));
>  			break;
> +		case AUDIT_CONTID:
> +			data->buflen += data->values[i] = sizeof(u64);
> +			for (i = 0; i < sizeof(u64); i++)
> +				((char *)bufp)[i] = ((char *)&f->val64)[i];
> +			break;
>  		case AUDIT_LOGINUID_SET:
>  			if (krule->pflags & AUDIT_LOGINUID_LEGACY && !f->val) {
>  				data->fields[i] = AUDIT_LOGINUID;
> @@ -750,6 +764,10 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
>  			if (!gid_eq(a->fields[i].gid, b->fields[i].gid))
>  				return 1;
>  			break;
> +		case AUDIT_CONTID:
> +			if (a->fields[i].val64 != b->fields[i].val64)
> +				return 1;
> +			break;
>  		default:
>  			if (a->fields[i].val != b->fields[i].val)
>  				return 1;
> @@ -1206,6 +1224,31 @@ int audit_comparator(u32 left, u32 op, u32 right)
>  	}
>  }
>  
> +int audit_comparator64(u64 left, u32 op, u64 right)
> +{
> +	switch (op) {
> +	case Audit_equal:
> +		return (left == right);
> +	case Audit_not_equal:
> +		return (left != right);
> +	case Audit_lt:
> +		return (left < right);
> +	case Audit_le:
> +		return (left <= right);
> +	case Audit_gt:
> +		return (left > right);
> +	case Audit_ge:
> +		return (left >= right);
> +	case Audit_bitmask:
> +		return (left & right);
> +	case Audit_bittest:
> +		return ((left & right) == right);
> +	default:
> +		BUG();
> +		return 0;
> +	}
> +}
> +
>  int audit_uid_comparator(kuid_t left, u32 op, kuid_t right)
>  {
>  	switch (op) {
> @@ -1344,6 +1387,10 @@ int audit_filter(int msgtype, unsigned int listtype)
>  				result = audit_comparator(audit_loginuid_set(current),
>  							  f->op, f->val);
>  				break;
> +			case AUDIT_CONTID:
> +				result = audit_comparator64(audit_get_contid(current),
> +							      f->op, f->val64);
> +				break;
>  			case AUDIT_MSGTYPE:
>  				result = audit_comparator(msgtype, f->op, f->val);
>  				break;
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index aa5d13b4fbbb..2d74238e9638 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -616,6 +616,9 @@ static int audit_filter_rules(struct task_struct *tsk,
>  		case AUDIT_LOGINUID_SET:
>  			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
>  			break;
> +		case AUDIT_CONTID:
> +			result = audit_comparator64(audit_get_contid(tsk), f->op, f->val64);
> +			break;
>  		case AUDIT_SUBJ_USER:
>  		case AUDIT_SUBJ_ROLE:
>  		case AUDIT_SUBJ_TYPE:
> -- 
> 1.8.3.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
