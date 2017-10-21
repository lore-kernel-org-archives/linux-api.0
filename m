From: Nicolas Belouin <nicolas@belouin.fr>
Subject: Re: [RFC PATCH 1/2] security, capabilities: Add CAP_SYS_MOUNT
Date: Sat, 21 Oct 2017 20:41:58 +0200
Message-ID: <AED1D433-EDCE-4B0B-AB8D-55627E5B94A4@belouin.fr>
References: <20171021134303.20685-1-nicolas@belouin.fr> <edfdfc70-fd07-4930-c7f5-0d2b6355b09b@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-10233-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <edfdfc70-fd07-4930-c7f5-0d2b6355b09b@schaufler-ca.com>
To: kernel-hardening@lists.openwall.com, Casey Schaufler <casey@schaufler-ca.com>, David Howells <dhowells@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, linux-cachefs@redhat.com, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On October 21, 2017 7:31:24 PM GMT+02:00, Casey Schaufler <casey@schaufler=
-ca=2Ecom> wrote:
>On 10/21/2017 6:43 AM, Nicolas Belouin wrote:
>> With CAP_SYS_ADMIN being bloated and inapropriate for actions such
>> as mounting/unmounting filesystems, the creation of a new capability
>> is needed=2E
>> CAP_SYS_MOUNT is meant to give a process the ability to call for
>mount,
>> umount and umount2 syscalls=2E
>
>This is increased granularity for it's own sake=2E There is no
>compelling reason to break out this capability in particular=2E

Obviously there is a need to break CAP_SYS_ADMIN in pieces, to do so, you =
have to start somewhere, so I chose to begin with this=2E

>Can you identify existing use cases where you would have
>CAP_SYS_MOUNT without also having CAP_SYS_ADMIN? I should think
>that all the work that's gone into unprivileged mounts over
>the past couple years would make this unnecessary=2E

If you look at the udiskd deamon used by most desktop environments, it is =
launched as root or at least with CAP_SYS_ADMIN=2E Here, you could use CAP_=
SYS_MOUNT=2E There might also be a use within containers as you don't want =
to give CAP_SYS_ADMIN to a container if it just need to mount/unmount files=
ystems=2E If you go even further, it could be used to allow swapon/swapoff =
(maybe in future patch set)=2E

>
>> Signed-off-by: Nicolas Belouin <nicolas@belouin=2Efr>
>> ---
>>  include/uapi/linux/capability=2Eh     | 5 ++++-
>>  security/selinux/include/classmap=2Eh | 4 ++--
>>  2 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/capability=2Eh
>b/include/uapi/linux/capability=2Eh
>> index 230e05d35191=2E=2Ece230aa6d928 100644
>> --- a/include/uapi/linux/capability=2Eh
>> +++ b/include/uapi/linux/capability=2Eh
>> @@ -365,8 +365,11 @@ struct vfs_ns_cap_data {
>> =20
>>  #define CAP_AUDIT_READ		37
>> =20
>> +/* Allow mounting, unmounting filesystems */
>> =20
>> -#define CAP_LAST_CAP         CAP_AUDIT_READ
>> +#define CAP_SYS_MOUNT		38
>> +
>> +#define CAP_LAST_CAP         CAP_SYS_MOUNT
>> =20
>>  #define cap_valid(x) ((x) >=3D 0 && (x) <=3D CAP_LAST_CAP)
>> =20
>> diff --git a/security/selinux/include/classmap=2Eh
>b/security/selinux/include/classmap=2Eh
>> index 35ffb29a69cb=2E=2Ea873dce97fd5 100644
>> --- a/security/selinux/include/classmap=2Eh
>> +++ b/security/selinux/include/classmap=2Eh
>> @@ -24,9 +24,9 @@
>>  	    "audit_control", "setfcap"
>> =20
>>  #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
>> -		"wake_alarm", "block_suspend", "audit_read"
>> +		"wake_alarm", "block_suspend", "audit_read", "sys_mount"
>> =20
>> -#if CAP_LAST_CAP > CAP_AUDIT_READ
>> +#if CAP_LAST_CAP > CAP_SYS_MOUNT
>>  #error New capability defined, please update COMMON_CAP2_PERMS=2E
>>  #endif
>> =20

Nicolas
