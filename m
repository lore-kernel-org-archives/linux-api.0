From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [RFC v4 1/1] ns: add binfmt_misc to the user namespace
Date: Mon, 8 Oct 2018 21:05:34 +0200
Message-ID: <6150310e-75fa-0199-71bd-5794392b73c2@vivier.eu>
References: <20181006193546.29340-1-laurent@vivier.eu>
 <20181006193546.29340-2-laurent@vivier.eu>
 <CAG48ez1S7CVDCCec5F-N32BVEPckLb0Qy+PypThezwKA=8HSSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1S7CVDCCec5F-N32BVEPckLb0Qy+PypThezwKA=8HSSg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, avagin@gmail.com, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, dima@arista.com, containers@lists.linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-api@vger.kernel.org

Le 08/10/2018 à 13:26, Jann Horn a écrit :
> On Sat, Oct 6, 2018 at 9:36 PM Laurent Vivier <laurent@vivier.eu> wrote:
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
>> ---
> [...]
...
>> @@ -838,7 +858,29 @@ static int bm_fill_super(struct super_block *sb, void *data, int silent)
>>  static struct dentry *bm_mount(struct file_system_type *fs_type,
>>         int flags, const char *dev_name, void *data)
>>  {
>> -       return mount_single(fs_type, flags, data, bm_fill_super);
>> +       struct user_namespace *ns = current_user_ns();
>> +
>> +       /* create a new binfmt namespace
>> +        * if we are not in the first user namespace
>> +        * but the binfmt namespace is the first one
>> +        */
>> +       if (ns->binfmt_ns == NULL) {
>> +               struct binfmt_namespace *new_ns;
>> +
>> +               new_ns = kmalloc(sizeof(struct binfmt_namespace),
>> +                                GFP_KERNEL);
>> +               if (new_ns == NULL)
>> +                       return ERR_PTR(-ENOMEM);
>> +               INIT_LIST_HEAD(&new_ns->entries);
>> +               new_ns->enabled = 1;
>> +               rwlock_init(&new_ns->entries_lock);
>> +               new_ns->bm_mnt = NULL;
>> +               new_ns->entry_count = 0;
>> +               ns->binfmt_ns = new_ns;
> 
> What happens if someone mounts two instances of the binfmt_misc
> filesystem at the same time? Would you end up creating two binfmt
> namespaces, one of which would never be freed again?

I think you're right. And there is also a problem if mount_ns() fails.

So I think I can put this sequence in bm_fill_super() to avoid these
problems.

Thanks,
Laurent
