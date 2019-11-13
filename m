From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH] Allow restricting permissions in /proc/sys
Date: Wed, 13 Nov 2019 18:19:17 +0200
Message-ID: <13bc7935-8341-bb49-74ea-2eb58f72fd1f@gmail.com>
References: <74a91362-247c-c749-5200-7bdce704ed9e@gmail.com>
 <20191112232239.yevpeemgxz4wy32b@wittgenstein>
 <CAG48ez0j_7NyCyvGn8U8NS2p=CQQb=me-5KTa7k5E6xpHJphaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0j_7NyCyvGn8U8NS2p=CQQb=me-5KTa7k5E6xpHJphaA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On 13.11.2019 18.00, Jann Horn wrote:
> On Wed, Nov 13, 2019 at 12:22 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
>> On Sun, Nov 03, 2019 at 04:55:48PM +0200, Topi Miettinen wrote:
>>> Several items in /proc/sys need not be accessible to unprivileged
>>> tasks. Let the system administrator change the permissions, but only
>>> to more restrictive modes than what the sysctl tables allow.
>>>
>>> Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
>>> ---
>>>   fs/proc/proc_sysctl.c | 41 +++++++++++++++++++++++++++++++----------
>>>   1 file changed, 31 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
>>> index d80989b6c344..88c4ca7d2782 100644
>>> --- a/fs/proc/proc_sysctl.c
>>> +++ b/fs/proc/proc_sysctl.c
>>> @@ -818,6 +818,10 @@ static int proc_sys_permission(struct inode *inode, int
>>> mask)
>>>          if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))
>>>                  return -EACCES;
>>>
>>> +       error = generic_permission(inode, mask);
>>> +       if (error)
>>> +               return error;
> 
> In kernel/ucount.c, the ->permissions handler set_permissions() grants
> access based on whether the caller has CAP_SYS_RESOURCE. And in
> net/sysctl_net.c, the handler net_ctl_permissions() grants access
> based on whether the caller has CAP_NET_ADMIN. This added check is
> going to break those, right?
> 

Right. The comment above seems then a bit misleading:
	/*
	 * sysctl entries that are not writeable,
	 * are _NOT_ writeable, capabilities or not.
	 */

-Topi
