From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock
 for reconfiguration [ver #12]
Date: Wed, 17 Oct 2018 15:31:26 +0100
Message-ID: <f6f2553e-f64d-9c26-4290-baf43e5f533b@gmail.com>
References: <19866.1539782101@warthog.procyon.org.uk>
 <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com>
 <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
 <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk>
 <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com>
 <20181013061141.GR32577@ZenIV.linux.org.uk>
 <28710.1539782412@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <28710.1539782412@warthog.procyon.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On 17/10/2018 14:20, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
>
>> I should probably check that the picked point is actually a mountpoint.
> The root of the mount object at the path specified, that is, perhaps with
> something like the attached.
>
> David


I agree.  I'm happy to see this is using the same check as do_remount().


* change filesystem flags. dir should be a physical root of filesystem.
* If you've mounted a non-root directory somewhere and want to do remount
* on it - tough luck.
*/


Thanks

Alan


> ---
> diff --git a/fs/fsopen.c b/fs/fsopen.c
> index f673e93ac456..aaaaa17a233c 100644
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c
> @@ -186,6 +186,10 @@ SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags
>   	if (ret < 0)
>   		goto err;
>   
> +	ret = -EINVAL;
> +	if (target.mnt->mnt_root != target.dentry)
> +		goto err_path;
> +
>   	fc = vfs_new_fs_context(target.dentry->d_sb->s_type, target.dentry,
>   				0, 0, FS_CONTEXT_FOR_RECONFIGURE);
>   	if (IS_ERR(fc)) {
>
