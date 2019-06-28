From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Subject: Re: [PATCH bpf-next v9 05/10] bpf,landlock: Add a new map type: inode
Date: Fri, 28 Jun 2019 15:17:01 +0200
Message-ID: <9dbe8d9c-d7a7-5bf2-dda2-7dd72c44be2d@ssi.gouv.fr>
References: <20190625215239.11136-1-mic@digikod.net>
 <20190625215239.11136-6-mic@digikod.net>
 <20190625225201.GJ17978@ZenIV.linux.org.uk>
 <79bac827-4092-8a4d-9dc6-6019419b2486@ssi.gouv.fr>
 <20190627165640.GQ17978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190627165640.GQ17978@ZenIV.linux.org.uk>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>, Sargun
List-Id: linux-api@vger.kernel.org



On 27/06/2019 18:56, Al Viro wrote:
> On Thu, Jun 27, 2019 at 06:18:12PM +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>
>>>> +/* called from syscall */
>>>> +static int sys_inode_map_delete_elem(struct bpf_map *map, struct inod=
e *key)
>>>> +{
>>>> +    struct inode_array *array =3D container_of(map, struct inode_arra=
y, map);
>>>> +    struct inode *inode;
>>>> +    int i;
>>>> +
>>>> +    WARN_ON_ONCE(!rcu_read_lock_held());
>>>> +    for (i =3D 0; i < array->map.max_entries; i++) {
>>>> +            if (array->elems[i].inode =3D=3D key) {
>>>> +                    inode =3D xchg(&array->elems[i].inode, NULL);
>>>> +                    array->nb_entries--;
>>>
>>> Umm...  Is that intended to be atomic in any sense?
>>
>> nb_entries is not used as a bound check but to avoid walking uselessly
>> through the (pre-allocated) array when adding a new element, but I'll
>> use an atomic to avoid inconsistencies anyway.
>
>
>>> Wait a sec...  So we have those beasties that can have long-term
>>> references to arbitrary inodes stuck in them?  What will happen
>>> if you get umount(2) called while such a thing exists?
>>
>> I though an umount would be denied but no, we get a self-destructed busy
>> inode and a bug!
>> What about wrapping the inode's superblock->s_op->destroy_inode() to
>> first remove the element from the map and then call the real
>> destroy_inode(), if any?
>
> What do you mean, _the_ map?  I don't see anything to prevent insertion
> of references to the same inode into any number of those...

Indeed, the current design needs to check for duplicate inode references
to avoid unused entries (until a reference is removed). I was planning
to use an rbtree but I'm working on using a hash table instead (cf.
bpf/hashtab.c), which will solve the issue anyway.

>
>> Or I could update fs/inode.c:destroy_inode() to call inode->free_inode()
>> if it is set, and set it when such inode is referenced by a map?
>> Or maybe I could hold the referencing file in the map and then wrap its
>> f_op?
>
> First of all, anything including the word "wrap" is a non-starter.
> We really don't need the headache associated with the locking needed
> to replace the method tables on the fly, or with the code checking that
> ->f_op points to given method table, etc.  That's not going to fly,
> especially since you'd end up _chaining_ those (again, the same reference
> can go in more than once).
>
> Nothing is allowed to change the method tables of live objects, period.
> Once a struct file is opened, its ->f_op is never going to change and
> it entirely belongs to the device driver or filesystem it resides on.
> Nothing else (not VFS, not VM, not some LSM module, etc.) has any busines=
s
> touching that.  The same goes for inodes, dentries, etc.
>
> What kind of behaviour do you want there?  Do you want the inodes you've
> referenced there to be forgotten on e.g. memory pressure?  The thing is,
> I don't see how "it's getting freed" could map onto any semantics that
> might be useful for you - it looks like the wrong event for that.

At least, I would like to be able to compare an inode with the reference
one if this reference may be accessible somewhere on the system. Being
able to keep the inode reference as long as its superblock is alive
seems to solve the problem. This enable for example to compare inodes
from two bind mounts of the same file system even if one mount point is
unmounted.

Storing and using the device ID and the inode number bring a new problem
when an inode is removed and when its number is recycled. However, if I
can be notified when such an inode is removed (preferably without using
an LSM hook) and if I can know when the backing device go out of the
scope of the (live) system (e.g. hot unplugging an USB drive), this
should solve the problem and also enable to keep a reference to an inode
as long as possible without any dangling pointer nor wrapper.
