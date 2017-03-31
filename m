From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH RFC 0/4] proc: support multiple separate proc instances
 per pidnamespace
Date: Fri, 31 Mar 2017 13:26:43 +0200
Message-ID: <CAEiveUe4ztp+gjw8kgZ55vaLr0Zc0R5vG0XWYvZhugoH0jHS6A@mail.gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com> <20170330221649.GB13761@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-7212-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170330221649.GB13761@comp-core-i7-2640m-0182e6>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Kees Cook <keescook@chromium.org>, Dongsu Park <dpark@posteo.net>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 31, 2017 at 12:16 AM, Alexey Gladkov
<gladkov.alexey@gmail.com> wrote:
> On Thu, Mar 30, 2017 at 05:22:55PM +0200, Djalal Harouni wrote:
>> Hi,
>>
>> This RFC can be applied on top of Linus' tree 89970a04d7
>>
>> This RFC implements support for multiple separate proc instances inside
>> the same pid namespace. This allows to solve lot of problems that
>> today's use case face.
>>
>> Historically procfs was tied to pid namespaces, and mount options were
>> propagated to all other procfs instances in the same pid namespace. This
>> solved several use cases in that time. However today we face new
>> problems, there are mutliple container implementations there, some of
>> them want to hide pid entries, others want to hide non-pid entries,
>> others want to have sysctlfs, others want to share pid namespace with
>> private procfs mounts. All these with current implementation won't work
>> since all options will be propagated to all procfs mounts.
>>
>> This series allow to have new instances of procfs per pid namespace wher=
e
>> each instance can have its own mount option inside the same pid namespac=
e.
>> This was also suggested by Andy Lutomirski.
>>
>>
>> Now:
>> $ sudo mount -t proc -o unshare,hidepid=3D2 none /test
>>
>> The option 'unshare' will allow to mount a new instance of procfs inside
>> the same pid namespace.
>>
>> Before:
>> $ stat /proc/slabinfo
>>
>>   File: =E2=80=98/proc/slabinfo=E2=80=99
>>   Size: 0             Blocks: 0          IO Block: 1024   regular empty =
file
>> Device: 4h/4d Inode: 4026532046  Links: 1
>>
>> $ stat /test3/slabinfo
>>
>>   File: =E2=80=98/test3/slabinfo=E2=80=99
>>   Size: 0             Blocks: 0          IO Block: 1024   regular empty =
file
>> Device: 4h/4d Inode: 4026532046  Links: 1
>>
>>
>> After:
>> $ stat /proc/slabinfo
>>
>>   File: =E2=80=98/proc/slabinfo=E2=80=99
>>   Size: 0             Blocks: 0          IO Block: 1024   regular empty =
file
>> Device: 4h/4d Inode: 4026532046  Links: 1
>>
>> $ stat /test3/slabinfo
>>
>>   File: =E2=80=98/test3/slabinfo=E2=80=99
>>   Size: 0             Blocks: 0          IO Block: 1024   regular empty =
file
>> Device: 31h/49d       Inode: 4026532046  Links: 1
>>
>>
>> Any better name for the option 'unshare' ? suggestions ?
>>
>> I was going to use 'version=3D2' but then this may sound more like a
>> proc2 fs which currently impossible to implement since it will share
>> locks with the old proc.
>>
>>
>> Al, Eric any comments please ?
>
> Multiple mnt_root's lead us to significant memory costs for storing dentr=
y
> of tasks. I mean what we will get as many copies of the tasks dentry as m=
any
> times we have mounted the procfs with 'unshare' flag. No?

With current implementation, that's true. However I think that we
should not sacrifice usage for optimization, currently it is
practically impossible to improve procfs, support new options or make
use of the current ones without affecting other procfs mounts. Andy
also suggested to have a mini-proc without non-pid stuff inside, and
without a new disconnected instance, new mounts or bind mounts may
expose the non-pid stuff.

Also we can improve this, right now it is not implemented but we may
can change how we do lookups, instead of doing a ptrace task after
instantiating a pid dentry we may do a ptrace permission check on task
there then create its related proc inode. With this all new procfs
instances with hidepid option set, will only have dentries of tasks
that the caller can ptrace. Also there is already the code to flush
the related task when it dies, tough, it needs further testing.

Also as with tmpfs where inodes are accounted by the memory
controller, I'm not sure if it's possible to account the same in
procfs during the first access ?

I don't see a better way to solve the current procfs problems that we
face or how to modernize it and add new options... in the end users
can always chose to use it or not.

--=20
tixxdz
