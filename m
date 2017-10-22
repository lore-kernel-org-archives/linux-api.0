From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [kernel-hardening] [RFC PATCH 1/2] security, capabilities: Add
 CAP_SYS_MOUNT
Date: Sat, 21 Oct 2017 17:54:11 -0700
Message-ID: <8d0ff7c9-a27f-db74-5870-3d4bdb5784b1@schaufler-ca.com>
References: <20171021134303.20685-1-nicolas@belouin.fr>
 <edfdfc70-fd07-4930-c7f5-0d2b6355b09b@schaufler-ca.com>
 <AED1D433-EDCE-4B0B-AB8D-55627E5B94A4@belouin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AED1D433-EDCE-4B0B-AB8D-55627E5B94A4@belouin.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolas Belouin <nicolas@belouin.fr>, kernel-hardening@lists.openwall.com, David Howells <dhowells@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, linux-cachefs@redhat.com, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/21/2017 11:41 AM, Nicolas Belouin wrote:
>
> On October 21, 2017 7:31:24 PM GMT+02:00, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 10/21/2017 6:43 AM, Nicolas Belouin wrote:
>>> With CAP_SYS_ADMIN being bloated and inapropriate for actions such
>>> as mounting/unmounting filesystems, the creation of a new capability
>>> is needed.
>>> CAP_SYS_MOUNT is meant to give a process the ability to call for
>> mount,
>>> umount and umount2 syscalls.
>> This is increased granularity for it's own sake. There is no
>> compelling reason to break out this capability in particular.
> Obviously there is a need to break CAP_SYS_ADMIN in pieces,

No. This is a baseless assumption. Granularity for the sake of
granularity is bad. Data General (a dead company) followed the
fine grained capability path and ended up with 330 capabilities.
Developers can't handle the granularity we already have (hell,
half of them don't know what mode bits are for) and making it
finer will only make it harder for them to make use of the ones
we have.

>  to do so, you have to start somewhere, so I chose to begin with this.
>
>> Can you identify existing use cases where you would have
>> CAP_SYS_MOUNT without also having CAP_SYS_ADMIN? I should think
>> that all the work that's gone into unprivileged mounts over
>> the past couple years would make this unnecessary.
> If you look at the udiskd deamon used by most desktop environments, it is launched as root or at least with CAP_SYS_ADMIN. Here, you could use CAP_SYS_MOUNT.

Does this demon do anything else that uses CAP_SYS_ADMIN?
If it has to have that anyway, it's not an argument for breaking
out the mount capability.
 

>  There might also be a use within containers as you don't want to give CAP_SYS_ADMIN to a container if it just need to mount/unmount filesystems.

There is massive work going on elsewhere to allow containers to
mount without privilege. And I'm not at all interested in "might".

> If you go even further, it could be used to allow swapon/swapoff (maybe in future patch set).

No, you'd be asking for CAP_SWAP for that. Swap control has nothing to do
with mounting filesystems.

>
>>> Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
>>> ---
>>>  include/uapi/linux/capability.h     | 5 ++++-
>>>  security/selinux/include/classmap.h | 4 ++--
>>>  2 files changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/capability.h
>> b/include/uapi/linux/capability.h
>>> index 230e05d35191..ce230aa6d928 100644
>>> --- a/include/uapi/linux/capability.h
>>> +++ b/include/uapi/linux/capability.h
>>> @@ -365,8 +365,11 @@ struct vfs_ns_cap_data {
>>>  
>>>  #define CAP_AUDIT_READ		37
>>>  
>>> +/* Allow mounting, unmounting filesystems */
>>>  
>>> -#define CAP_LAST_CAP         CAP_AUDIT_READ
>>> +#define CAP_SYS_MOUNT		38
>>> +
>>> +#define CAP_LAST_CAP         CAP_SYS_MOUNT
>>>  
>>>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>>>  
>>> diff --git a/security/selinux/include/classmap.h
>> b/security/selinux/include/classmap.h
>>> index 35ffb29a69cb..a873dce97fd5 100644
>>> --- a/security/selinux/include/classmap.h
>>> +++ b/security/selinux/include/classmap.h
>>> @@ -24,9 +24,9 @@
>>>  	    "audit_control", "setfcap"
>>>  
>>>  #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
>>> -		"wake_alarm", "block_suspend", "audit_read"
>>> +		"wake_alarm", "block_suspend", "audit_read", "sys_mount"
>>>  
>>> -#if CAP_LAST_CAP > CAP_AUDIT_READ
>>> +#if CAP_LAST_CAP > CAP_SYS_MOUNT
>>>  #error New capability defined, please update COMMON_CAP2_PERMS.
>>>  #endif
>>>  
> Nicolas
>
