From: nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org
Subject: Re: [kernel-hardening] [RFC PATCH 1/2] security, capabilities: create CAP_TRUSTED
Date: Sat, 21 Oct 2017 21:04:48 +0200
Message-ID: <201710211904.v9LJ4o1X046943__22397.5650188097$1508612910$gmane$org@smtp5.infomaniak.ch>
References: <20171021134558.21195-1-nicolas@belouin.fr> <d3e1c911-138d-082a-b941-651217d0faf8@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d3e1c911-138d-082a-b941-651217d0faf8-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Fasheh <mfasheh-rOS7oXVqrJRBDgjK7y7TUQ@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Phillip Lougher <phillip-Y7wUz+saRi+tmTQ+vhA3Yw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James.Morris-g+Cd2gT1u6QP3drIcvDWNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

<james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org,linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org,linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
From: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Message-ID: <E5A1BDA4-A309-4118-84D5-72780F619EBA-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>



On October 21, 2017 7:25:21 PM GMT+02:00, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>On 10/21/2017 6:45 AM, Nicolas Belouin wrote:
>> with CAP_SYS_ADMIN being bloated, the usefulness of using it to
>> flag a process to be entrusted for e.g reading and writing trusted
>> xattr is near zero.
>> CAP_TRUSTED aims to provide userland with a way to mark a process as
>> entrusted to do specific (not specially admin-centered) actions. It
>> would for example allow a process to red/write the trusted xattrs.
>
>Please explain how this is different from CAP_MAC_ADMIN in
>any existing use case. If it is significantly different, how
>would the two interact?

>From my point of view, CAP_MAC_ADMIN allows one to read/write security xattrs, those are meant to describe security policies. As far as I know of, trusted xattrs are intended for a privileged process to read or write arbitrary data. I don't have any real world example in mind that use trusted xattrs, but I'll try to find one.

>
>> Signed-off-by: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
>> ---
>>  include/uapi/linux/capability.h     | 6 +++++-
>>  security/selinux/include/classmap.h | 5 +++--
>>  2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/capability.h
>b/include/uapi/linux/capability.h
>> index ce230aa6d928..27e457b93c84 100644
>> --- a/include/uapi/linux/capability.h
>> +++ b/include/uapi/linux/capability.h
>> @@ -369,7 +369,11 @@ struct vfs_ns_cap_data {
>>  
>>  #define CAP_SYS_MOUNT		38
>>  
>> -#define CAP_LAST_CAP         CAP_SYS_MOUNT
>> +/* Allow read/write trusted xattr */
>> +
>> +#define CAP_TRUSTED		39
>> +
>> +#define CAP_LAST_CAP         CAP_TRUSTED
>>  
>>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>>  
>> diff --git a/security/selinux/include/classmap.h
>b/security/selinux/include/classmap.h
>> index a873dce97fd5..f5dc8e109f5a 100644
>> --- a/security/selinux/include/classmap.h
>> +++ b/security/selinux/include/classmap.h
>> @@ -24,9 +24,10 @@
>>  	    "audit_control", "setfcap"
>>  
>>  #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
>> -		"wake_alarm", "block_suspend", "audit_read", "sys_mount"
>> +		"wake_alarm", "block_suspend", "audit_read", "sys_mount", \
>> +		"trusted"
>>  
>> -#if CAP_LAST_CAP > CAP_SYS_MOUNT
>> +#if CAP_LAST_CAP > CAP_TRUSTED
>>  #error New capability defined, please update COMMON_CAP2_PERMS.
>>  #endif
>>  

Nicolas
