From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock
 for reconfiguration [ver #12]
Date: Sat, 13 Oct 2018 10:45:01 +0100
Message-ID: <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com>
References: <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
 <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk>
 <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com>
 <20181013061141.GR32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013061141.GR32577@ZenIV.linux.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On 13/10/2018 07:11, Al Viro wrote:
> On Fri, Oct 12, 2018 at 03:49:50PM +0100, Alan Jenkins wrote:
>>> +SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags)
>>> +{
>>> +	struct fs_context *fc;
>>> +	struct path target;
>>> +	unsigned int lookup_flags;
>>> +	int ret;
>>> +
>>> +	if (!ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN))
>>> +		return -EPERM;
>>
>> This seems to accept basically any mount.  Specifically: are you sure it's
>> OK to return a handle to a SB_NO_USER superblock?
> Umm...  As long as we don't try to do pathname resolution from its ->s_root,
> shouldn't be a problem and I don't see anything that would do that.  I might've
> missed something, but...

Sorry, I guess SB_NOUSER was the wrong word.  I was trying find if 
anything stopped things like

int memfd = memfd_create("foo", 0);
int fsfd = fspick(memfd, "", FSPICK_EMPTY_PATH);

fsconfig(fsfd, FSCONFIG_SET_FLAG, "ro", NULL, 0);
fsconfig(fsfd, FSCONFIG_SET_STRING, "size", "100M", 0);
fsconfig(fsfd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);

So far I'm getting -EBUSY if I try to apply the "ro", -EINVAL if I try 
to apply the "size=100M".  But if I don't apply either, then 
FSCONFIG_CMD_RECONFIGURE succeeds.

It seems worrying that it might let me set options on shm_mnt. Or at 
least letting me get as far as the -EBUSY check for the "ro" superblock 
flag.

I'm not sure why I'm getting the -EINVAL setting the "size" option.  But 
it would be much more reassuring if I was getting -EPERM :-).

Alan
