From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [RFC v5 1/1] ns: add binfmt_misc to the user namespace
Date: Tue, 9 Oct 2018 18:57:41 +0200
Message-ID: <795fea1a-97bd-87f5-6a14-6d47a4e42f74@vivier.eu>
References: <20181009103752.21482-1-laurent@vivier.eu>
 <20181009103752.21482-2-laurent@vivier.eu>
 <f14ce318-5a1a-06f3-2e90-91220f39e74b@virtuozzo.com>
 <bc11ca64-8616-f06a-c1fa-c76511e60257@vivier.eu>
 <CAG48ez0pAxC+yetPfM+XyS8kfqA4hw1hxjKG55gbF-4qcNWUiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0pAxC+yetPfM+XyS8kfqA4hw1hxjKG55gbF-4qcNWUiA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: ktkhai@virtuozzo.com, kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, dima@arista.com, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, containers@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Le 09/10/2018 à 18:53, Jann Horn a écrit :
> On Tue, Oct 9, 2018 at 6:45 PM Laurent Vivier <laurent@vivier.eu> wrote:
>> Le 09/10/2018 à 18:15, Kirill Tkhai a écrit :
>>> On 09.10.2018 13:37, Laurent Vivier wrote:
>>>> This patch allows to have a different binfmt_misc configuration
>>>> for each new user namespace. By default, the binfmt_misc configuration
>>>> is the one of the previous level, but if the binfmt_misc filesystem is
>>>> mounted in the new namespace a new empty binfmt instance is created and
>>>> used in this namespace.
>>>>
>>>> For instance, using "unshare" we can start a chroot of an another
>>>> architecture and configure the binfmt_misc interpreter without being root
>>>> to run the binaries in this chroot.
>>>>
>>>> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
>>>> ---
>>>>  fs/binfmt_misc.c               | 106 ++++++++++++++++++++++++---------
>>>>  include/linux/user_namespace.h |  13 ++++
>>>>  kernel/user.c                  |  13 ++++
>>>>  kernel/user_namespace.c        |   3 +
>>>>  4 files changed, 107 insertions(+), 28 deletions(-)
>>>>
>>>> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
>>>> index aa4a7a23ff99..1e0029d097d9 100644
>>>> --- a/fs/binfmt_misc.c
>>>> +++ b/fs/binfmt_misc.c
>> ...
>>>> @@ -80,18 +74,32 @@ static int entry_count;
>>>>   */
>>>>  #define MAX_REGISTER_LENGTH 1920
>>>>
>>>> +static struct binfmt_namespace *binfmt_ns(struct user_namespace *ns)
>>>> +{
>>>> +    struct binfmt_namespace *b_ns;
>>>> +
>>>> +    while (ns) {
>>>> +            b_ns = READ_ONCE(ns->binfmt_ns);
>>>> +            if (b_ns)
>>>> +                    return b_ns;
>>>> +            ns = ns->parent;
>>>> +    }
>>>> +    WARN_ON_ONCE(1);
>>>> +    return NULL;
>>>> +}
>>>> +
>> ...
>>>> @@ -823,12 +847,34 @@ static const struct super_operations s_ops = {
>>>>  static int bm_fill_super(struct super_block *sb, void *data, int silent)
>>>>  {
>>>>      int err;
>>>> +    struct user_namespace *ns = sb->s_user_ns;
>>>>      static const struct tree_descr bm_files[] = {
>>>>              [2] = {"status", &bm_status_operations, S_IWUSR|S_IRUGO},
>>>>              [3] = {"register", &bm_register_operations, S_IWUSR},
>>>>              /* last one */ {""}
>>>>      };
>>>>
>>>> +    /* create a new binfmt namespace
>>>> +     * if we are not in the first user namespace
>>>> +     * but the binfmt namespace is the first one
>>>> +     */
>>>> +    if (READ_ONCE(ns->binfmt_ns) == NULL) {
>>>> +            struct binfmt_namespace *new_ns;
>>>> +
>>>> +            new_ns = kmalloc(sizeof(struct binfmt_namespace),
>>>> +                             GFP_KERNEL);
>>>> +            if (new_ns == NULL)
>>>> +                    return -ENOMEM;
>>>> +            INIT_LIST_HEAD(&new_ns->entries);
>>>> +            new_ns->enabled = 1;
>>>> +            rwlock_init(&new_ns->entries_lock);
>>>> +            new_ns->bm_mnt = NULL;
>>>> +            new_ns->entry_count = 0;
>>>> +            /* ensure new_ns is completely initialized before sharing it */
>>>> +            smp_wmb();
>>>
>>> (I haven't dived into patch logic, here just small barrier remark from quick sight).
>>> smp_wmb() has no sense without paired smp_rmb() on the read side. Possible,
>>> you want something like below in read hunk:
>>>
>>> +             b_ns = READ_ONCE(ns->binfmt_ns);
>>> +             if (b_ns) {
>>> +                     smp_rmb();
>>> +                     return b_ns;
>>> +             }
>>>
>>>
>>
>> The write barrier is here to ensure the structure is fully written
>> before we set the pointer.
>>
>> I don't understand how read barrier can change something at this level,
>> IMHO the couple WRITE_ONCE()/READ_ONCE() should be enough to ensure we
>> have correctly initialized the pointer and the structure when we read
>> the pointer back.
>>
>> I think the pointer itself is the "barrier" to access the memory
>> modified before.
> 
> Things don't work that way on alpha, but that's why READ_ONCE()
> includes an smp_read_barrier_depends():
> 
> #define __READ_ONCE(x, check)                                           \
> ({                                                                      \
>         union { typeof(x) __val; char __c[1]; } __u;                    \
>         if (check)                                                      \
>                 __read_once_size(&(x), __u.__c, sizeof(x));             \
>         else                                                            \
>                 __read_once_size_nocheck(&(x), __u.__c, sizeof(x));     \
>         smp_read_barrier_depends(); /* Enforce dependency ordering from x */ \
>         __u.__val;                                                      \
> })
> #define READ_ONCE(x) __READ_ONCE(x, 1)
> 

So my questions are:

- do we need a smp_wmb() barrier if we use READ_ONCE() and WRITE_ONCE()?

- if we need an smp_wmb() barrier, do we need an smp_rmb() barrier as
the data we want to "protect" are behind an access to the pointer?

Thanks,
Laurent
