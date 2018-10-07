From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [RFC v4 1/1] ns: add binfmt_misc to the user namespace
Date: Sun, 7 Oct 2018 11:11:00 +0200
Message-ID: <0d96603a-f739-ca12-eea8-5552d9c6a1fd@vivier.eu>
References: <20181006193546.29340-1-laurent@vivier.eu>
 <20181006193546.29340-2-laurent@vivier.eu>
 <20181007050224.GA3035@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181007050224.GA3035@mail.hallyn.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, linux-fsdevel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, Dmitry Safonov <dima@arista.com>, containers@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-api@vger.kernel.org

Le 07/10/2018 à 07:02, Serge E. Hallyn a écrit :
> On Sat, Oct 06, 2018 at 09:35:46PM +0200, Laurent Vivier wrote:
>> This patch allows to have a different binfmt_misc configuration
>> for each new user namespace. By default, the binfmt_misc configuration
>> is the one of the previous level, but if the binfmt_misc filesystem is
>> mounted in the new namespace a new empty binfmt instance is created and
>> used in this namespace.
>>
>> For instance, using "unshare" we can start a chroot of an another
>> architecture and configure the binfmt_misc interpreter without being root
>> to run the binaries in this chroot.
>>
>> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> 
> Hi,
> 
> quick question below,
> 
>> ---
>>  fs/binfmt_misc.c               | 99 ++++++++++++++++++++++++----------
>>  include/linux/user_namespace.h | 13 +++++
>>  kernel/user.c                  | 13 +++++
>>  kernel/user_namespace.c        |  7 +++
>>  4 files changed, 104 insertions(+), 28 deletions(-)
>>
>> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
>> index aa4a7a23ff99..1beefafcb416 100644
>> --- a/fs/binfmt_misc.c
...
>> @@ -725,12 +736,16 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>>  
>>  	if (e->flags & MISC_FMT_OPEN_FILE) {
>>  		struct file *f;
>> +		const struct cred *old_cred;
>>  
>> +		old_cred = override_creds(file->f_cred);
> 
> What exactly is this aiming to do?

See comment from the version 1:

https://lkml.org/lkml/2018/10/1/377

"This looks wrong. A write handler's behavior should not depend on the
namespace of the process that is using it.

Ideally, the affected namespace should depend on the file you're writing to.
If that's not possible, the affected namespace should at least be the
namespace of the process that opened the file." -- Jann Horn

And from version 2:

https://lkml.org/lkml/2018/10/3/872

"Something else: bm_register_write() currently calls into open_exec(),
which uses the credentials of current. That's not really allowed in
this context - but so far, it's not a big deal because only
init-namespace root can reach this code. Before you expose this stuff
to unprivileged userspace, this needs to get fixed; perhaps by
wrapping the open_exec() call in override_creds(file->f_cred) and
revert_creds()."  -- Jann Horn

Thanks,
Laurent
